Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaAWOTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:19:11 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36009 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbaAWOPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:15:50 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Ingo Molnar <mingo@kernel.org>, linux-fbdev@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 02/11] x86: sysfb: remove sysfb when probing real hw
Date: Thu, 23 Jan 2014 15:14:54 +0100
Message-Id: <1390486503-1504-3-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_X86_SYSFB=y, probing real hw-drivers may result in
resource-conflicts and drivers will refuse to load. A call to
request_mem_region() will fail, if the region overlaps with the mem-region
used by simplefb. The common desktop DRM drivers (intel, nouveau, radeon)
are not affected as they don't reserve their resources, but some others
do, including (nvidiafb, cirrus, ..).

The problem is that we add an IORESOURCE_MEM to the simple-framebuffer
platform-device during bootup but never release it. Probing simplefb on
this platform-device is fine, but the handover to real-hw via
remove_conflicting_framebuffers() will only unload the fbdev driver, but
keep the platform-device around. Thus, if the real hw-driver calls
request_mem_region() and friends on the same PCI region, we will get a
resource conflict and most drivers refuse to load. Users will see
errors like:
  "nvidiafb: cannot reserve video memory at <xyz>"

vesafb and efifb don't store any resources, so disabling CONFIG_X86_SYSFB
and falling back to those drivers will avoid the bug. With sysfb enabled,
we need to properly unload the simple-framebuffer devices before probing
real hw-drivers.

This patch adds sysfb_unregister() for that purpose. It can be called from
any context (except from the platform-device ->probe and ->remove callback
path), synchronously unloads any global sysfb and prevents new sysfbs from
getting registered. Thus, you can call it even before any sysfb has been
loaded. Note that for now we only do that for simple-framebuffer devices,
as efi/vesa-framebuffer platform-drivers lack ->remove() callbacks.
They're not affected by the resource-conflicts, so we can fix those later.

This also changes remove_conflicting_framebuffer() to call this helper
*before* trying its heuristic to remove conflicting drivers. This way, we
unload sysfbs properly on any conflict. But to avoid dead-locks in
register_framebuffer(), we must not call sysfb_unregister() for
framebuffers probing on sysfb devices. Hence, we simply remove any
aperture from simplefb and we're good to go. simplefb is unregistered by
sysfb_unregister() now, so no reason to keep the apertures (on non-x86,
there currently is no handover from simplefb, so we're fine. If it's
added, they need to provide something like sysfb_unregister() too)

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Tested-by: Takashi Iwai <tiwai@suse.de>
---
 arch/x86/include/asm/sysfb.h     |  5 ++++
 arch/x86/kernel/sysfb.c          | 65 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/sysfb_simplefb.c |  9 ++----
 drivers/video/fbmem.c            | 11 +++++++
 drivers/video/simplefb.c         |  8 -----
 5 files changed, 83 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sysfb.h b/arch/x86/include/asm/sysfb.h
index 2aeb3e2..6f95b8d 100644
--- a/arch/x86/include/asm/sysfb.h
+++ b/arch/x86/include/asm/sysfb.h
@@ -59,6 +59,11 @@ struct efifb_dmi_info {
 	int flags;
 };
 
+int __init sysfb_register(const char *name, int id,
+			  const struct resource *res, unsigned int res_num,
+			  const void *data, size_t data_size);
+void sysfb_unregister(const struct apertures_struct *apert, bool primary);
+
 #ifdef CONFIG_EFI
 
 extern struct efifb_dmi_info efifb_dmi_list[];
diff --git a/arch/x86/kernel/sysfb.c b/arch/x86/kernel/sysfb.c
index 193ec2c..ba9ff26 100644
--- a/arch/x86/kernel/sysfb.c
+++ b/arch/x86/kernel/sysfb.c
@@ -33,11 +33,76 @@
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
+int __init sysfb_register(const char *name, int id,
+			  const struct resource *res, unsigned int res_num,
+			  const void *data, size_t data_size)
+{
+	struct platform_device *pd;
+	int ret = 0;
+
+	mutex_lock(&sysfb_lock);
+	if (!sysfb_dev) {
+		pd = platform_device_register_resndata(NULL, name, id,
+						       res, res_num,
+						       data, data_size);
+		if (IS_ERR(pd))
+			ret = PTR_ERR(pd);
+		else
+			sysfb_dev = pd;
+	}
+	mutex_unlock(&sysfb_lock);
+
+	return ret;
+}
+
+static bool sysfb_match(const struct apertures_struct *apert)
+{
+	struct screen_info *si = &screen_info;
+	unsigned int i;
+	const struct aperture *a;
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
+/* Remove sysfb and disallow new sysfbs from now on. Can be called from any
+ * context except recursively (see also remove_conflicting_framebuffers()). */
+void sysfb_unregister(const struct apertures_struct *apert, bool primary)
+{
+	if (!apert)
+		return;
+
+	mutex_lock(&sysfb_lock);
+	if (!IS_ERR(sysfb_dev) && sysfb_dev) {
+		if (primary || sysfb_match(apert)) {
+			platform_device_unregister(sysfb_dev);
+			sysfb_dev = ERR_PTR(-EALREADY);
+		}
+	} else {
+		/* set/overwrite error so no new sysfb is probed later */
+		sysfb_dev = ERR_PTR(-EALREADY);
+	}
+	mutex_unlock(&sysfb_lock);
+}
+
 static __init int sysfb_init(void)
 {
 	struct screen_info *si = &screen_info;
diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 86179d4..a760d47 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -64,7 +64,6 @@ __init bool parse_mode(const struct screen_info *si,
 __init int create_simplefb(const struct screen_info *si,
 			   const struct simplefb_platform_data *mode)
 {
-	struct platform_device *pd;
 	struct resource res;
 	unsigned long len;
 
@@ -86,10 +85,6 @@ __init int create_simplefb(const struct screen_info *si,
 	if (res.end <= res.start)
 		return -EINVAL;
 
-	pd = platform_device_register_resndata(NULL, "simple-framebuffer", 0,
-					       &res, 1, mode, sizeof(*mode));
-	if (IS_ERR(pd))
-		return PTR_ERR(pd);
-
-	return 0;
+	return sysfb_register("simple-framebuffer", 0, &res, 1, mode,
+			      sizeof(*mode));
 }
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index e296967..79a47ff 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -35,6 +35,9 @@
 
 #include <asm/fb.h>
 
+#ifdef CONFIG_X86_SYSFB
+#  include <asm/sysfb.h>
+#endif
 
     /*
      *  Frame buffer device initialization and setup routines
@@ -1751,6 +1754,10 @@ int remove_conflicting_framebuffers(struct apertures_struct *a,
 {
 	int ret;
 
+#ifdef CONFIG_X86_SYSFB
+	sysfb_unregister(a, primary);
+#endif
+
 	mutex_lock(&registration_lock);
 	ret = do_remove_conflicting_framebuffers(a, name, primary);
 	mutex_unlock(&registration_lock);
@@ -1773,6 +1780,10 @@ register_framebuffer(struct fb_info *fb_info)
 {
 	int ret;
 
+#ifdef CONFIG_X86_SYSFB
+	sysfb_unregister(fb_info->apertures, fb_is_primary_device(fb_info));
+#endif
+
 	mutex_lock(&registration_lock);
 	ret = do_register_framebuffer(fb_info);
 	mutex_unlock(&registration_lock);
diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
index 210f3a0..9f4a0cf 100644
--- a/drivers/video/simplefb.c
+++ b/drivers/video/simplefb.c
@@ -209,14 +209,6 @@ static int simplefb_probe(struct platform_device *pdev)
 	info->var.blue = params.format->blue;
 	info->var.transp = params.format->transp;
 
-	info->apertures = alloc_apertures(1);
-	if (!info->apertures) {
-		framebuffer_release(info);
-		return -ENOMEM;
-	}
-	info->apertures->ranges[0].base = info->fix.smem_start;
-	info->apertures->ranges[0].size = info->fix.smem_len;
-
 	info->fbops = &simplefb_ops;
 	info->flags = FBINFO_DEFAULT | FBINFO_MISC_FIRMWARE;
 	info->screen_base = ioremap_wc(info->fix.smem_start,
-- 
1.8.5.3

