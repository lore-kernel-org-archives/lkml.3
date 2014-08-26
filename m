Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbaHZMHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:07:41 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:39179 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754626AbaHZMHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:07:40 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH v2 1/2] msm: msm_fb: Add remove function for platform driver for clean unloading
Date: Tue, 26 Aug 2014 17:40:37 +0530
Message-Id: <1409055038-9204-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a  remove function to platform driver structure so that
resources are released when driver is unloaded.

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Stephen Boyd <sboyd@codeaurora.org>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Rob Clark <robdclark@gmail.com>

---
 drivers/video/fbdev/msm/msm_fb.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/video/fbdev/msm/msm_fb.c b/drivers/video/fbdev/msm/msm_fb.c
index 1374803..4640188 100644
--- a/drivers/video/fbdev/msm/msm_fb.c
+++ b/drivers/video/fbdev/msm/msm_fb.c
@@ -589,6 +589,8 @@ static int msmfb_probe(struct platform_device *pdev)
 
 	msmfb->sleeping = WAKING;
 
+	platform_set_drvdata(pdev, msmfb);
+
 	return 0;
 
 error_register_framebuffer:
@@ -598,9 +600,23 @@ error_setup_fbmem:
 	return ret;
 }
 
+static int msmfb_remove(struct platform_device *pdev)
+{
+	struct msmfb_info *msmfb;
+
+	msmfb = platform_get_drvdata(pdev);
+
+	unregister_framebuffer(msmfb->fb);
+	iounmap(msmfb->fb->screen_base);
+	framebuffer_release(msmfb->fb);
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
 
-- 
1.7.9.5

