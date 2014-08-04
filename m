Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaHDOky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:40:54 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:52886 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbaHDOk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:40:27 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH] msm: msm_fb: Add remove function for platform driver for clean unloading
Date: Mon,  4 Aug 2014 20:13:53 +0530
Message-Id: <1407163433-13528-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a  remove function to platform driver structure so that
resources are released when driver is unloaded.

Moved kzalloc to use managed resource and adds a return check if failed.

CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Stephen Boyd <sboyd@codeaurora.org>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Rob Clark <robdclark@gmail.com>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/video/fbdev/msm/msm_fb.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/msm/msm_fb.c b/drivers/video/fbdev/msm/msm_fb.c
index 1374803..ac277e2 100644
--- a/drivers/video/fbdev/msm/msm_fb.c
+++ b/drivers/video/fbdev/msm/msm_fb.c
@@ -553,6 +553,7 @@ static int msmfb_probe(struct platform_device *pdev)
 	fb = framebuffer_alloc(sizeof(struct msmfb_info), &pdev->dev);
 	if (!fb)
 		return -ENOMEM;
+
 	msmfb = fb->par;
 	msmfb->fb = fb;
 	msmfb->panel = panel;
@@ -569,8 +570,13 @@ static int msmfb_probe(struct platform_device *pdev)
 	mutex_init(&msmfb->panel_init_lock);
 	init_waitqueue_head(&msmfb->frame_wq);
 	INIT_WORK(&msmfb->resume_work, power_on_panel);
-	msmfb->black = kzalloc(msmfb->fb->var.bits_per_pixel*msmfb->xres,
-			       GFP_KERNEL);
+	msmfb->black = devm_kzalloc(&pdev->dev,
+				    msmfb->fb->var.bits_per_pixel*msmfb->xres,
+				    GFP_KERNEL);
+	if (!msmfb->black) {
+		ret = -ENOMEM;
+		goto error_register_framebuffer;
+	}
 
 	printk(KERN_INFO "msmfb_probe() installing %d x %d panel\n",
 	       msmfb->xres, msmfb->yres);
@@ -589,6 +595,8 @@ static int msmfb_probe(struct platform_device *pdev)
 
 	msmfb->sleeping = WAKING;
 
+	platform_set_drvdata(pdev, msmfb);
+
 	return 0;
 
 error_register_framebuffer:
@@ -598,13 +606,27 @@ error_setup_fbmem:
 	return ret;
 }
 
+static int msmfb_remove(struct platform_device *pdev)
+{
+	struct msmfb_info *msmfb = NULL;
+
+	msmfb = platform_get_drvdata(pdev);
+	if (msmfb) {
+		unregister_framebuffer(msmfb->fb);
+		iounmap(msmfb->fb->screen_base);
+		framebuffer_release(msmfb->fb);
+	}
+
+	return 0;
+}
+
 static struct platform_driver msm_panel_driver = {
 	/* need to write remove */
 	.probe = msmfb_probe,
+	.remove = msmfb_remove,
 	.driver = {.name = "msm_panel"},
 };
 
-
 static int msmfb_add_mdp_device(struct device *dev,
 				struct class_interface *class_intf)
 {
-- 
1.7.9.5

