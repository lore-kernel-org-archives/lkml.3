Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaHAK0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:26:06 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:48430
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbaHAK0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:26:04 -0400
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
        dan.carpenter@oracle.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, linux-fbdev@vger.kernel.org
Cc: olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com
Subject: [PATCH v4] video: hyperv: hyperv_fb: refresh the VM screen by force on VM panic
Date: Fri,  1 Aug 2014 04:27:54 -0700
Message-Id: <1406892474-6548-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the VSC has no chance to notify the VSP of the dirty rectangle on VM
panic because the notification work is done in a workqueue, and in panic() the
kernel typically ends up in an infinite loop, and a typical kernel config has
CONFIG_PREEMPT_VOLUNTARY=y and CONFIG_PREEMPT is not set, so a context switch
can't happen in panic() and the workqueue won't have a chance to run. As a
result, the VM Connection window can't refresh until it's closed and we
re-connect to the VM.

We can register a handler on panic_notifier_list: the handler can notify
the VSC and switch the framebuffer driver to a "synchronous mode", meaning
the VSC flushes any future framebuffer change to the VSP immediately.

v2: removed the MS-TFS line in the commit message
v3: remove some 'unlikely' markings
v4: avoid global variables as Tomi Valkeinen suggested

Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/video/fbdev/hyperv_fb.c | 62 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index e23392e..569e756 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -224,6 +224,11 @@ struct hvfb_par {
 	u32 pseudo_palette[16];
 	u8 init_buf[MAX_VMBUS_PKT_SIZE];
 	u8 recv_buf[MAX_VMBUS_PKT_SIZE];
+
+	/* If true, the VSC notifies the VSP on every framebuffer change */
+	bool synchronous_fb;
+
+	struct notifier_block hvfb_panic_nb;
 };
 
 static uint screen_width = HVFB_WIDTH;
@@ -532,6 +537,19 @@ static void hvfb_update_work(struct work_struct *w)
 		schedule_delayed_work(&par->dwork, HVFB_UPDATE_DELAY);
 }
 
+static int hvfb_on_panic(struct notifier_block *nb,
+			 unsigned long e, void *p)
+{
+	struct hvfb_par *par;
+	struct fb_info *info;
+
+	par = container_of(nb, struct hvfb_par, hvfb_panic_nb);
+	par->synchronous_fb = true;
+	info = par->info;
+	synthvid_update(info);
+
+	return NOTIFY_DONE;
+}
 
 /* Framebuffer operation handlers */
 
@@ -582,14 +600,44 @@ static int hvfb_blank(int blank, struct fb_info *info)
 	return 1;	/* get fb_blank to set the colormap to all black */
 }
 
+static void hvfb_cfb_fillrect(struct fb_info *p,
+			      const struct fb_fillrect *rect)
+{
+	struct hvfb_par *par = p->par;
+
+	cfb_fillrect(p, rect);
+	if (par->synchronous_fb)
+		synthvid_update(p);
+}
+
+static void hvfb_cfb_copyarea(struct fb_info *p,
+			      const struct fb_copyarea *area)
+{
+	struct hvfb_par *par = p->par;
+
+	cfb_copyarea(p, area);
+	if (par->synchronous_fb)
+		synthvid_update(p);
+}
+
+static void hvfb_cfb_imageblit(struct fb_info *p,
+			       const struct fb_image *image)
+{
+	struct hvfb_par *par = p->par;
+
+	cfb_imageblit(p, image);
+	if (par->synchronous_fb)
+		synthvid_update(p);
+}
+
 static struct fb_ops hvfb_ops = {
 	.owner = THIS_MODULE,
 	.fb_check_var = hvfb_check_var,
 	.fb_set_par = hvfb_set_par,
 	.fb_setcolreg = hvfb_setcolreg,
-	.fb_fillrect = cfb_fillrect,
-	.fb_copyarea = cfb_copyarea,
-	.fb_imageblit = cfb_imageblit,
+	.fb_fillrect = hvfb_cfb_fillrect,
+	.fb_copyarea = hvfb_cfb_copyarea,
+	.fb_imageblit = hvfb_cfb_imageblit,
 	.fb_blank = hvfb_blank,
 };
 
@@ -801,6 +849,11 @@ static int hvfb_probe(struct hv_device *hdev,
 
 	par->fb_ready = true;
 
+	par->synchronous_fb = false;
+	par->hvfb_panic_nb.notifier_call = hvfb_on_panic;
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &par->hvfb_panic_nb);
+
 	return 0;
 
 error:
@@ -820,6 +873,9 @@ static int hvfb_remove(struct hv_device *hdev)
 	struct fb_info *info = hv_get_drvdata(hdev);
 	struct hvfb_par *par = info->par;
 
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &par->hvfb_panic_nb);
+
 	par->update = false;
 	par->fb_ready = false;
 
-- 
1.9.1

