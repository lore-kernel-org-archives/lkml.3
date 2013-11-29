Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3K2Ll7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:41:59 -0500
Received: from fallback7.mail.ru ([94.100.176.135]:48136 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3K2Ll5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:41:57 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/3] w1: mxc_w1: Add warning for base frequency calculation
Date: Fri, 29 Nov 2013 15:39:29 +0400
Message-Id: <1385725170-31515-2-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385725170-31515-1-git-send-email-shc_work@mail.ru>
References: <1385725170-31515-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Base frequency should be as close as possible to 1 MHz. This patch
adds warnings when clock is unreliable, according to i.MX datasheet.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/w1/masters/mxc_w1.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 5de3ca9..953168c 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -105,6 +105,7 @@ static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 static int mxc_w1_probe(struct platform_device *pdev)
 {
 	struct mxc_w1_device *mdev;
+	unsigned long clkrate;
 	struct resource *res;
 	unsigned int clkdiv;
 	int err = 0;
@@ -118,7 +119,16 @@ static int mxc_w1_probe(struct platform_device *pdev)
 	if (IS_ERR(mdev->clk))
 		return PTR_ERR(mdev->clk);
 
-	clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;
+	clkrate = clk_get_rate(mdev->clk);
+	if (clkrate < 10000000)
+		dev_warn(&pdev->dev,
+			 "Low clock frequency causes improper function\n");
+
+	clkdiv = DIV_ROUND_CLOSEST(clkrate, 1000000);
+	clkrate /= clkdiv;
+	if ((clkrate < 980000) || (clkrate > 1020000))
+		dev_warn(&pdev->dev,
+			 "Incorrect time base frequency %lu Hz\n", clkrate);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mdev->regs = devm_ioremap_resource(&pdev->dev, res);
@@ -126,7 +136,7 @@ static int mxc_w1_probe(struct platform_device *pdev)
 		return PTR_ERR(mdev->regs);
 
 	clk_prepare_enable(mdev->clk);
-	__raw_writeb(clkdiv, mdev->regs + MXC_W1_TIME_DIVIDER);
+	__raw_writeb(clkdiv - 1, mdev->regs + MXC_W1_TIME_DIVIDER);
 
 	mdev->bus_master.data = mdev;
 	mdev->bus_master.reset_bus = mxc_w1_ds2_reset_bus;
-- 
1.8.3.2

