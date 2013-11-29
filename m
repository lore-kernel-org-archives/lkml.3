Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3K2Lma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:42:30 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:55367 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3K2LmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:42:03 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 3/3] w1: mxc_w1: Check the clk_prepare_enable() return value
Date: Fri, 29 Nov 2013 15:39:30 +0400
Message-Id: <1385725170-31515-3-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385725170-31515-1-git-send-email-shc_work@mail.ru>
References: <1385725170-31515-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/w1/masters/mxc_w1.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 953168c..1e5d94c 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -108,7 +108,7 @@ static int mxc_w1_probe(struct platform_device *pdev)
 	unsigned long clkrate;
 	struct resource *res;
 	unsigned int clkdiv;
-	int err = 0;
+	int err;
 
 	mdev = devm_kzalloc(&pdev->dev, sizeof(struct mxc_w1_device),
 			    GFP_KERNEL);
@@ -135,20 +135,23 @@ static int mxc_w1_probe(struct platform_device *pdev)
 	if (IS_ERR(mdev->regs))
 		return PTR_ERR(mdev->regs);
 
-	clk_prepare_enable(mdev->clk);
+	err = clk_prepare_enable(mdev->clk);
+	if (err)
+		return err;
+
 	__raw_writeb(clkdiv - 1, mdev->regs + MXC_W1_TIME_DIVIDER);
 
 	mdev->bus_master.data = mdev;
 	mdev->bus_master.reset_bus = mxc_w1_ds2_reset_bus;
 	mdev->bus_master.touch_bit = mxc_w1_ds2_touch_bit;
 
-	err = w1_add_master_device(&mdev->bus_master);
+	platform_set_drvdata(pdev, mdev);
 
+	err = w1_add_master_device(&mdev->bus_master);
 	if (err)
-		return err;
+		clk_disable_unprepare(mdev->clk);
 
-	platform_set_drvdata(pdev, mdev);
-	return 0;
+	return err;
 }
 
 /*
-- 
1.8.3.2

