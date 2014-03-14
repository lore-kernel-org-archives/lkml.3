Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaCNTFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:05:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50215 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751946AbaCNTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:05:42 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Bo Shen <voice.shen@atmel.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] PWM: atmel: fix incorrect CDTY value after enabling or disabling
Date: Fri, 14 Mar 2014 20:05:31 +0100
Message-Id: <1394823931-2815-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pwm-leds calls .config() and .disable() in a row. This exhibits that it may
happen that the channel gets disabled before CDTY has been updated with CUPD.
The issue gets quite worse with long periods.
So, ensure by reading ISR that at least one period has past before disabling the
channel.

The other issue is that it may happen that CUPD is not flushed before enabling
the channel so it will update CDTY/CPRD just after one period. So we always set
CUPD, even when the channel is not enabled.

Tested on at91sam9g45 and sama5d31ek.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pwm/pwm-atmel.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
index 0adc952cc4ef..0e589594b1cb 100644
--- a/drivers/pwm/pwm-atmel.c
+++ b/drivers/pwm/pwm-atmel.c
@@ -16,11 +16,13 @@
 #include <linux/platform_device.h>
 #include <linux/pwm.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 
 /* The following is global registers for PWM controller */
 #define PWM_ENA			0x04
 #define PWM_DIS			0x08
 #define PWM_SR			0x0C
+#define PWM_ISR			0x1C
 /* Bit field in SR */
 #define PWM_SR_ALL_CH_ON	0x0F
 
@@ -157,24 +159,25 @@ static void atmel_pwm_config_v1(struct pwm_chip *chip, struct pwm_device *pwm,
 	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
 	unsigned int val;
 
-	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
-		/*
-		 * If the PWM channel is enabled, using the update register,
-		 * it needs to set bit 10 of CMR to 0
-		 */
-		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV1_CUPD, dty);
 
-		val = atmel_pwm_ch_readl(atmel_pwm, pwm->hwpwm, PWM_CMR);
-		val &= ~PWM_CMR_UPD_CDTY;
-		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
-	} else {
-		/*
-		 * If the PWM channel is disabled, write value to duty and
-		 * period registers directly.
-		 */
-		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV1_CDTY, dty);
-		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV1_CPRD, prd);
-	}
+	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV1_CUPD, dty);
+
+	val = atmel_pwm_ch_readl(atmel_pwm, pwm->hwpwm, PWM_CMR);
+	val &= ~PWM_CMR_UPD_CDTY;
+	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
+
+	/*
+	 * If the PWM channel is enabled, only update CDTY by using the update
+	 * register, it needs to set bit 10 of CMR to 0
+	 */
+	if (test_bit(PWMF_ENABLED, &pwm->flags))
+		return;
+	/*
+	 * If the PWM channel is disabled, write value to duty and period
+	 * registers directly.
+	 */
+	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV1_CDTY, dty);
+	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV1_CPRD, prd);
 }
 
 static void atmel_pwm_config_v2(struct pwm_chip *chip, struct pwm_device *pwm,
@@ -245,6 +248,15 @@ static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
 
+	/*
+	 * Wait for at least a complete period to have passed before disabling a
+	 * channel to be sure that CDTY has been updated
+	 */
+	atmel_pwm_readl(atmel_pwm, PWM_ISR);
+
+	while (!(atmel_pwm_readl(atmel_pwm, PWM_ISR) & (1 << pwm->hwpwm)))
+		usleep_range(10, 100);
+
 	atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
 
 	clk_disable(atmel_pwm->clk);
-- 
1.8.3.2

