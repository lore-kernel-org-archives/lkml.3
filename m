Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3GQR1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:27:08 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:55989 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab3GQR1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:05 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 06/21] MFD: ti_tscadc: ADC Clock check not required
Date: Wed, 17 Jul 2013 18:26:35 +0100
Message-Id: <1374082010-28095-7-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ADC is ideally expected to work at a frequency of 3MHz.

The present code had a check, which returned error if the frequency

went below the threshold  value. But since AM335x supports various

working frequencies, this check is not required.

Now the code just uses the internal ADC clock divider to set the ADC

frequency w.r.t the sys clock.

Signed-off-by: Patil, Rachna <rachna@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/mfd/ti_am335x_tscadc.c       |    6 +-----
 include/linux/mfd/ti_am335x_tscadc.h |    1 -
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index fdbd0d5..e7314e4 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -197,11 +197,7 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	clock_rate = clk_get_rate(clk);
 	clk_put(clk);
 	clk_value = clock_rate / ADC_CLK;
-	if (clk_value < MAX_CLK_DIV) {
-		dev_err(&pdev->dev, "clock input less than min clock requirement\n");
-		err = -EINVAL;
-		goto err_disable_clk;
-	}
+
 	/* TSCADC_CLKDIV needs to be configured to the value minus 1 */
 	clk_value = clk_value - 1;
 	tscadc_writel(tscadc, REG_CLKDIV, clk_value);
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index f436918..1516dc8 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -127,7 +127,6 @@
 #define SEQ_STATUS BIT(5)
 
 #define ADC_CLK			3000000
-#define	MAX_CLK_DIV		7
 #define TOTAL_STEPS		16
 #define TOTAL_CHANNELS		8
 #define FIFO1_THRESHOLD                        19
-- 
1.7.9.5

