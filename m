Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3IWUni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:43:38 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39896 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3IWUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:43:36 -0400
X-Originating-IP: 83.160.107.163
Date: Mon, 23 Sep 2013 22:43:29 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: ti_am335x_tscadc: Restore clock divider on resume
Message-ID: <20130923204329.GG27515@raspi>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADC clock divider needs to be restored on resume as the register content
is lost when the ADC is powered down

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

---
 drivers/mfd/ti_am335x_tscadc.c       |   10 ++++++----
 include/linux/mfd/ti_am335x_tscadc.h |    1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index baaf5a8..a3685d6 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -95,7 +95,7 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	const __be32            *cur;
 	u32			val;
 	int			err, ctrl;
-	int			clk_value, clock_rate;
+	int			clock_rate;
 	int			tsc_wires = 0, adc_channels = 0, total_channels;
 	int			readouts = 0;
 
@@ -196,11 +196,11 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	}
 	clock_rate = clk_get_rate(clk);
 	clk_put(clk);
-	clk_value = clock_rate / ADC_CLK;
+	tscadc->clk_div = clock_rate / ADC_CLK;
 
 	/* TSCADC_CLKDIV needs to be configured to the value minus 1 */
-	clk_value = clk_value - 1;
-	tscadc_writel(tscadc, REG_CLKDIV, clk_value);
+	tscadc->clk_div--;
+	tscadc_writel(tscadc, REG_CLKDIV, tscadc->clk_div);
 
 	/* Set the control register bits */
 	ctrl = CNTRLREG_STEPCONFIGWRT |
@@ -303,6 +303,8 @@ static int tscadc_resume(struct device *dev)
 	tscadc_writel(tscadc_dev, REG_CTRL,
 			(restore | CNTRLREG_TSCSSENB));
 
+	tscadc_writel(tscadc_dev, REG_CLKDIV, tscadc_dev->clk_div);
+
 	return 0;
 }
 
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index 25f2c61..f03281d 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -146,6 +146,7 @@ struct ti_tscadc_dev {
 	struct mfd_cell cells[TSCADC_CELLS];
 	u32 reg_se_cache;
 	spinlock_t reg_lock;
+	unsigned int clk_div;
 
 	/* tsc device */
 	struct titsc *tsc;
-- 
1.7.9.5

