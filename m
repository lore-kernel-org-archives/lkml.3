Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaFZUgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:36:50 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:39822
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbaFZUf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:35:27 -0400
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com
Subject: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen by force on VM panic
Date: Thu, 26 Jun 2014 14:35:01 -0700
Message-Id: <1403818501-15547-1-git-send-email-decui@microsoft.com>
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

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/video/fbdev/hyperv_fb.c | 58 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index e23392e..291d171 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -226,11 +226,16 @@ struct hvfb_par {
 	u8 recv_buf[MAX_VMBUS_PKT_SIZE];
 };
 
+static struct fb_info *hvfb_info;
+
 static uint screen_width = HVFB_WIDTH;
 static uint screen_height = HVFB_HEIGHT;
 static uint screen_depth;
 static uint screen_fb_size;
 
+/* If true, the VSC notifies the VSP on every framebuffer change */
+static bool synchronous_fb;
+
 /* Send message to Hyper-V host */
 static inline int synthvid_send(struct hv_device *hdev,
 				struct synthvid_msg *msg)
@@ -532,6 +537,20 @@ static void hvfb_update_work(struct work_struct *w)
 		schedule_delayed_work(&par->dwork, HVFB_UPDATE_DELAY);
 }
 
+static int hvfb_on_panic(struct notifier_block *nb,
+			unsigned long e, void *p)
+{
+	if (hvfb_info)
+		synthvid_update(hvfb_info);
+
+	synchronous_fb = true;
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block hvfb_panic_nb = {
+	.notifier_call = hvfb_on_panic,
+};
 
 /* Framebuffer operation handlers */
 
@@ -582,14 +601,41 @@ static int hvfb_blank(int blank, struct fb_info *info)
 	return 1;	/* get fb_blank to set the colormap to all black */
 }
 
+static void hvfb_cfb_fillrect(struct fb_info *p,
+				const struct fb_fillrect *rect)
+{
+	cfb_fillrect(p, rect);
+
+	if (unlikely(synchronous_fb))
+		synthvid_update(p);
+}
+
+static void hvfb_cfb_copyarea(struct fb_info *p,
+				const struct fb_copyarea *area)
+{
+	cfb_copyarea(p, area);
+
+	if (unlikely(synchronous_fb))
+		synthvid_update(p);
+}
+
+static void hvfb_cfb_imageblit(struct fb_info *p,
+				const struct fb_image *image)
+{
+	cfb_imageblit(p, image);
+
+	if (unlikely(synchronous_fb))
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
 
@@ -801,6 +847,9 @@ static int hvfb_probe(struct hv_device *hdev,
 
 	par->fb_ready = true;
 
+	hvfb_info = info;
+	atomic_notifier_chain_register(&panic_notifier_list, &hvfb_panic_nb);
+
 	return 0;
 
 error:
@@ -820,6 +869,9 @@ static int hvfb_remove(struct hv_device *hdev)
 	struct fb_info *info = hv_get_drvdata(hdev);
 	struct hvfb_par *par = info->par;
 
+	atomic_notifier_chain_unregister(&panic_notifier_list, &hvfb_panic_nb);
+	hvfb_info = NULL;
+
 	par->update = false;
 	par->fb_ready = false;
 
-- 
1.9.1

