Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaKGFvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:51:06 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34717 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaKGFuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:50:55 -0500
From: Vignesh R <vigneshr@ti.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Vignesh R <vigneshr@ti.com>, Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>
Subject: [PATCH 3/5] mfd: ti_am335x_tscadc: Remove unwanted reg_se_cache save
Date: Fri, 7 Nov 2014 11:19:08 +0530
Message-ID: <1415339350-17679-4-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415339350-17679-1-git-send-email-vigneshr@ti.com>
References: <1415339350-17679-1-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In one shot mode, sequencer automatically disables all enabled steps at
the end of each cycle. (both ADC steps and TSC steps) Hence these steps
need not be saved in reg_se_cache for clearing these steps at a later
stage.
Also, when ADC wakes up Sequencer should not be busy executing any of the
config steps except for the charge step. Previously charge step was 1 ADC
clock cycle and hence it was ignored.

Signed-off-by: Vignesh R <vigneshr@ti.com>
---
 drivers/mfd/ti_am335x_tscadc.c       | 7 +++++--
 include/linux/mfd/ti_am335x_tscadc.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index d877e777cce6..94ef8992f46b 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -86,8 +86,12 @@ static void am335x_tscadc_need_adc(struct ti_tscadc_dev *tsadc)
 		spin_lock_irq(&tsadc->reg_lock);
 		finish_wait(&tsadc->reg_se_wait, &wait);
 
+		/*
+		 * Sequencer should either be idle or
+		 * busy applying the charge step.
+		 */
 		reg = tscadc_readl(tsadc, REG_ADCFSM);
-		WARN_ON(reg & SEQ_STATUS);
+		WARN_ON(reg & SEQ_STATUS & (!CHARGE_STEP));
 		tsadc->adc_waiting = false;
 	}
 	tsadc->adc_in_use = true;
@@ -96,7 +100,6 @@ static void am335x_tscadc_need_adc(struct ti_tscadc_dev *tsadc)
 void am335x_tsc_se_set_once(struct ti_tscadc_dev *tsadc, u32 val)
 {
 	spin_lock_irq(&tsadc->reg_lock);
-	tsadc->reg_se_cache |= val;
 	am335x_tscadc_need_adc(tsadc);
 
 	tscadc_writel(tsadc, REG_SE, val);
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index c99be5dc0f5c..fcce182e4a35 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -128,6 +128,7 @@
 
 /* Sequencer Status */
 #define SEQ_STATUS BIT(5)
+#define CHARGE_STEP		0x11
 
 #define ADC_CLK			3000000
 #define TOTAL_STEPS		16
-- 
1.9.1

