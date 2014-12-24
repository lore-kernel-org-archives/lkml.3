Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaLXHGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:06:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47004 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbaLXHFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:05:51 -0500
From: Vignesh R <vigneshr@ti.com>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Brad Griffis <bgriffis@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Jan Kardell <jan.kardell@telliq.com>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, Vignesh R <vigneshr@ti.com>
Subject: [PATCH v5 3/6] mfd: ti_am335x_tscadc: Remove unwanted reg_se_cache save
Date: Wed, 24 Dec 2014 12:33:36 +0530
Message-ID: <1419404619-10744-4-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419404619-10744-1-git-send-email-vigneshr@ti.com>
References: <1419404619-10744-1-git-send-email-vigneshr@ti.com>
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
TSC steps are always disabled at the end of each conversion cycle, hence
there is no need to explicitly disable TSC steps by writing 0 to REG_SE.

Signed-off-by: Vignesh R <vigneshr@ti.com>
---

v5:
 - Remove unnecessary clearing of REG_SE

 drivers/mfd/ti_am335x_tscadc.c       | 13 +++++--------
 include/linux/mfd/ti_am335x_tscadc.h |  1 +
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index 467c80e1c4ae..e4e4b22eebc9 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -68,12 +68,6 @@ static void am335x_tscadc_need_adc(struct ti_tscadc_dev *tsadc)
 	DEFINE_WAIT(wait);
 	u32 reg;
 
-	/*
-	 * disable TSC steps so it does not run while the ADC is using it. If
-	 * write 0 while it is running (it just started or was already running)
-	 * then it completes all steps that were enabled and stops then.
-	 */
-	tscadc_writel(tsadc, REG_SE, 0);
 	reg = tscadc_readl(tsadc, REG_ADCFSM);
 	if (reg & SEQ_STATUS) {
 		tsadc->adc_waiting = true;
@@ -86,8 +80,12 @@ static void am335x_tscadc_need_adc(struct ti_tscadc_dev *tsadc)
 		spin_lock_irq(&tsadc->reg_lock);
 		finish_wait(&tsadc->reg_se_wait, &wait);
 
+		/*
+		 * Sequencer should either be idle or
+		 * busy applying the charge step.
+		 */
 		reg = tscadc_readl(tsadc, REG_ADCFSM);
-		WARN_ON(reg & SEQ_STATUS);
+		WARN_ON((reg & SEQ_STATUS) && !(reg & CHARGE_STEP));
 		tsadc->adc_waiting = false;
 	}
 	tsadc->adc_in_use = true;
@@ -96,7 +94,6 @@ static void am335x_tscadc_need_adc(struct ti_tscadc_dev *tsadc)
 void am335x_tsc_se_set_once(struct ti_tscadc_dev *tsadc, u32 val)
 {
 	spin_lock_irq(&tsadc->reg_lock);
-	tsadc->reg_se_cache |= val;
 	am335x_tscadc_need_adc(tsadc);
 
 	tscadc_writel(tsadc, REG_SE, val);
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index 3f4e994ace2b..1fd50dcfe47c 100644
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

