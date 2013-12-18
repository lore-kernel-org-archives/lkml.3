Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab3LRLsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:48:32 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:65161 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab3LRLsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:48:30 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Stephen Warren <swarren@wwwdotorg.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-fbdev@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, David Herrmann <dh.herrmann@gmail.com>
Subject: [RFC] x86: sysfb: remove sysfb when probing real hw
Date: Wed, 18 Dec 2013 12:48:03 +0100
Message-Id: <1387367283-20078-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <s5hk3f2v15r.wl%tiwai@suse.de>
References: <s5hk3f2v15r.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we probe a real hw driver for graphics devices, we need to unload any
generic fallback driver like efifb/vesafb/simplefb on the system
framebuffer. This is currently done via remove_conflicting_framebuffers()
in fbmem.c. However, this only removes the fbdev driver, not the fake
platform devices underneath. This hasn't been a problem so far, as efifb
and vesafb didn't store any resources there. However, with simplefb this
changed.

To correctly release the IORESOURCE_MEM resources of simple-framebuffer
platform devices, we need to unregister the underlying platform device
*before* probing any new hw driver. This patch adds sysfb_unregister() for
that purpose. It can be called from any context (except from the
platform-device ->remove callback path) and synchronously unloads any
global sysfb and prevents new sysfbs from getting registered. Thus, you
can call it even before any sysfb has been loaded.

This also changes remove_conflicting_framebuffer() to call this helper
*before* trying it's fbdev heuristic to remove conflicting drivers.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
Hi

This is imho the clean version of Takashi's fix. However, it gets pretty huge. I
wouldn't object to marking CONFIG_X86_SYSFB broken in the stable series and get
this in for 3.14. Your call..

This patch basically simulates an unplug event for system-framebuffers when
loading real hardware drivers. To trigger it, call sysfb_unregister(). You can
optionally pass an aperture-struct and primary-flag similar to
remove_conflicting_framebuffers(). If they're not passed, we remove it
unconditionally.

Untested, but my kernel compiles are already running. If my tests succeed and
nobody has objections, I can resend it as proper PATCH and marked for stable.
And maybe split the fbmem and sysfb changes into two patches..

Thanks
David

 arch/x86/include/asm/sysfb.h     |  10 ++++
 arch/x86/kernel/sysfb.c          | 103 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/sysfb_simplefb.c |   5 +-
 drivers/video/fbmem.c            |  16 ++++++
 4 files changed, 128 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/sysfb.h b/arch/x86/include/asm/sysfb.h
index 2aeb3e2..713bc17 100644
--- a/arch/x86/include/asm/sysfb.h
+++ b/arch/x86/include/asm/sysfb.h
@@ -11,6 +11,7 @@
  * any later version.
  */
 
+#include <linux/fb.h>
 #include <linux/kernel.h>
 #include <linux/platform_data/simplefb.h>
 #include <linux/screen_info.h>
@@ -59,6 +60,15 @@ struct efifb_dmi_info {
 	int flags;
 };
 
+__init struct platform_device *sysfb_alloc(const char *name,
+					   int id,
+					   const struct resource *res,
+					   unsigned int res_num,
+					   const void *data,
+					   size_t data_size);
+__init int sysfb_register(struct platform_device *dev);
+void sysfb_unregister(const struct apertures_struct *apert, bool primary);
+
 #ifdef CONFIG_EFI
 
 extern struct efifb_dmi_info efifb_dmi_list[];
diff --git a/arch/x86/kernel/sysfb.c b/arch/x86/kernel/sysfb.c
index 193ec2c..3d4554e 100644
--- a/arch/x86/kernel/sysfb.c
+++ b/arch/x86/kernel/sysfb.c
@@ -33,11 +33,106 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <linux/platform_data/simplefb.h>
 #include <linux/platform_device.h>
 #include <linux/screen_info.h>
 #include <asm/sysfb.h>
 
+static DEFINE_MUTEX(sysfb_lock);
+static struct platform_device *sysfb_dev;
+
+/* register @dev as sysfb; takes ownership over @dev */
+__init int sysfb_register(struct platform_device *dev)
+{
+	int r = 0;
+
+	mutex_lock(&sysfb_lock);
+	if (!sysfb_dev) {
+		r = platform_device_add(dev);
+		if (r < 0)
+			put_device(&dev->dev);
+		else
+			sysfb_dev = dev;
+	} else {
+		/* if there already is/was a sysfb, destroy @pd but return 0 */
+		platform_device_put(dev);
+	}
+	mutex_unlock(&sysfb_lock);
+
+	return r;
+}
+
+static bool sysfb_match(const struct apertures_struct *apert, bool primary)
+{
+	struct screen_info *si = &screen_info;
+	unsigned int i;
+	const struct aperture *a;
+
+	if (!apert || primary)
+		return true;
+
+	for (i = 0; i < apert->count; ++i) {
+		a = &apert->ranges[i];
+		if (a->base >= si->lfb_base &&
+		    a->base < si->lfb_base + ((u64)si->lfb_size << 16))
+			return true;
+		if (si->lfb_base >= a->base &&
+		    si->lfb_base < a->base + a->size)
+			return true;
+	}
+
+	return false;
+}
+
+/* unregister the sysfb and prevent new sysfbs from getting registered */
+void sysfb_unregister(const struct apertures_struct *apert, bool primary)
+{
+
+	mutex_lock(&sysfb_lock);
+	if (!IS_ERR(sysfb_dev)) {
+		if (sysfb_dev) {
+			if (sysfb_match(apert, primary)) {
+				platform_device_del(sysfb_dev);
+				platform_device_put(sysfb_dev);
+				sysfb_dev = ERR_PTR(-EALREADY);
+			}
+		} else {
+			sysfb_dev = ERR_PTR(-EALREADY);
+		}
+	}
+	mutex_unlock(&sysfb_lock);
+}
+
+__init struct platform_device *sysfb_alloc(const char *name,
+					   int id,
+					   const struct resource *res,
+					   unsigned int res_num,
+					   const void *data,
+					   size_t data_size)
+{
+	struct platform_device *pd;
+	int ret;
+
+	pd = platform_device_alloc(name, id);
+	if (!pd)
+		return ERR_PTR(-ENOMEM);
+
+	ret = platform_device_add_resources(pd, res, res_num);
+	if (ret)
+		goto err;
+
+	ret = platform_device_add_data(pd, data, data_size);
+	if (ret)
+		goto err;
+
+	return pd;
+
+err:
+	platform_device_put(pd);
+	return ERR_PTR(ret);
+}
+
 static __init int sysfb_init(void)
 {
 	struct screen_info *si = &screen_info;
@@ -65,9 +160,11 @@ static __init int sysfb_init(void)
 	else
 		name = "platform-framebuffer";
 
-	pd = platform_device_register_resndata(NULL, name, 0,
-					       NULL, 0, si, sizeof(*si));
-	return IS_ERR(pd) ? PTR_ERR(pd) : 0;
+	pd = sysfb_alloc(name, 0, NULL, 0, si, sizeof(*si));
+	if (IS_ERR(pd))
+		return PTR_ERR(pd);
+
+	return sysfb_register(pd);
 }
 
 /* must execute after PCI subsystem for EFI quirks */
diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 86179d4..8e7bd23 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -86,10 +86,9 @@ __init int create_simplefb(const struct screen_info *si,
 	if (res.end <= res.start)
 		return -EINVAL;
 
-	pd = platform_device_register_resndata(NULL, "simple-framebuffer", 0,
-					       &res, 1, mode, sizeof(*mode));
+	pd = sysfb_alloc("simple-framebuffer", 0, &res, 1, mode, sizeof(*mode));
 	if (IS_ERR(pd))
 		return PTR_ERR(pd);
 
-	return 0;
+	return sysfb_register(pd);
 }
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 010d191..53e3894 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -35,6 +35,9 @@
 
 #include <asm/fb.h>
 
+#if IS_ENABLED(CONFIG_X86_SYSFB)
+#include <asm/sysfb.h>
+#endif
 
     /*
      *  Frame buffer device initialization and setup routines
@@ -1604,6 +1607,14 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
 	}
 }
 
+static void remove_conflicting_sysfb(const struct apertures_struct *apert,
+				     bool primary)
+{
+#if IS_ENABLED(CONFIG_X86_SYSFB)
+	sysfb_unregister(apert, primary);
+#endif
+}
+
 static int do_register_framebuffer(struct fb_info *fb_info)
 {
 	int i;
@@ -1742,6 +1753,8 @@ EXPORT_SYMBOL(unlink_framebuffer);
 void remove_conflicting_framebuffers(struct apertures_struct *a,
 				     const char *name, bool primary)
 {
+	remove_conflicting_sysfb(a, primary);
+
 	mutex_lock(&registration_lock);
 	do_remove_conflicting_framebuffers(a, name, primary);
 	mutex_unlock(&registration_lock);
@@ -1762,6 +1775,9 @@ register_framebuffer(struct fb_info *fb_info)
 {
 	int ret;
 
+	remove_conflicting_sysfb(fb_info->apertures,
+				 fb_is_primary_device(fb_info));
+
 	mutex_lock(&registration_lock);
 	ret = do_register_framebuffer(fb_info);
 	mutex_unlock(&registration_lock);
-- 
1.8.5.1

