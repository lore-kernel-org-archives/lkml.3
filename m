Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161608AbaKNSbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:31:00 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:57075 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161538AbaKNSay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:30:54 -0500
X-IronPort-AV: E=Sophos;i="5.07,387,1413270000"; 
   d="scan'208";a="50722169"
From: Scott Branden <sbranden@broadcom.com>
To: Scott Branden <sbranden@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Ray Jui <rjui@broadcom.com>, Arun Ramamurthy <arunrama@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] pwm: kona: Fix enable, disable and config procedures
Date: Fri, 14 Nov 2014 10:29:59 -0800
Message-ID: <1415989800-7515-4-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415989800-7515-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1415989800-7515-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun Ramamurthy <arunrama@broadcom.com>

- Added helper functions to set and clear smooth and trigger bits
- Added 400ns delays when clearing and setting trigger bit as requied
  by spec
- Added helper function to write prescale and other settings
- Updated config procedure to match spec
- Added code to handle pwn config when channel is disabled
- Updated disable procedure to match spec

Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
Reviewed-by: Ray Jui <rjui@broadcom.com>
Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/pwm/pwm-bcm-kona.c | 100 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 78 insertions(+), 22 deletions(-)

diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
index fa0b5bf..06fa983 100644
--- a/drivers/pwm/pwm-bcm-kona.c
+++ b/drivers/pwm/pwm-bcm-kona.c
@@ -65,6 +65,10 @@
 #define DUTY_CYCLE_HIGH_MIN			(0x00000000)
 #define DUTY_CYCLE_HIGH_MAX			(0x00ffffff)
 
+/* The delay required after clearing or setting
+   PWMOUT_ENABLE*/
+#define PWMOUT_ENABLE_HOLD_DELAY 400
+
 struct kona_pwmc {
 	struct pwm_chip chip;
 	void __iomem *base;
@@ -76,28 +80,70 @@ static inline struct kona_pwmc *to_kona_pwmc(struct pwm_chip *_chip)
 	return container_of(_chip, struct kona_pwmc, chip);
 }
 
-static void kona_pwmc_apply_settings(struct kona_pwmc *kp, unsigned int chan)
+static inline void kona_pwmc_set_trigger(struct kona_pwmc *kp,
+					 unsigned int chan)
 {
 	unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
 
-	/* Clear trigger bit but set smooth bit to maintain old output */
-	value |= 1 << PWM_CONTROL_SMOOTH_SHIFT(chan);
+	/* set trigger bit to enable channel */
+	value |= 1 << PWM_CONTROL_TRIGGER_SHIFT(chan);
+	writel(value, kp->base + PWM_CONTROL_OFFSET);
+	ndelay(PWMOUT_ENABLE_HOLD_DELAY);
+}
+static inline void kona_pwmc_clear_trigger(struct kona_pwmc *kp,
+					   unsigned int chan)
+{
+	unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
+
+	/* Clear trigger bit */
 	value &= ~(1 << PWM_CONTROL_TRIGGER_SHIFT(chan));
 	writel(value, kp->base + PWM_CONTROL_OFFSET);
+	ndelay(PWMOUT_ENABLE_HOLD_DELAY);
+}
 
-	/* Set trigger bit and clear smooth bit to apply new settings */
+static inline void kona_pwmc_clear_smooth(struct kona_pwmc *kp,
+					  unsigned int chan)
+{
+	unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
+
+	/* Clear smooth bit */
 	value &= ~(1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
-	value |= 1 << PWM_CONTROL_TRIGGER_SHIFT(chan);
 	writel(value, kp->base + PWM_CONTROL_OFFSET);
 }
 
+static inline void kona_pwmc_set_smooth(struct kona_pwmc *kp, unsigned int chan)
+{
+	unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
+
+	/*  set smooth bit to maintain old output */
+	value |= 1 << PWM_CONTROL_SMOOTH_SHIFT(chan);
+	writel(value, kp->base + PWM_CONTROL_OFFSET);
+}
+
+static void kona_pwmc_write_settings(struct kona_pwmc *kp, unsigned int chan,
+				     unsigned long prescale, unsigned long pc,
+				     unsigned long dc)
+{
+	unsigned int value;
+
+	value = readl(kp->base + PRESCALE_OFFSET);
+	value &= ~PRESCALE_MASK(chan);
+	value |= prescale << PRESCALE_SHIFT(chan);
+	writel(value, kp->base + PRESCALE_OFFSET);
+
+	writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
+
+	writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
+
+}
+
 static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
 			    int duty_ns, int period_ns)
 {
 	struct kona_pwmc *kp = to_kona_pwmc(chip);
 	u64 val, div, rate;
 	unsigned long prescale = PRESCALE_MIN, pc, dc;
-	unsigned int value, chan = pwm->hwpwm;
+	unsigned int ret, chan = pwm->hwpwm;
 
 	/*
 	 * Find period count, duty count and prescale to suit duty_ns and
@@ -133,19 +179,30 @@ static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
 			return -EINVAL;
 	}
 
-	/* If the PWM channel is enabled, write the settings to the HW */
-	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
-		value = readl(kp->base + PRESCALE_OFFSET);
-		value &= ~PRESCALE_MASK(chan);
-		value |= prescale << PRESCALE_SHIFT(chan);
-		writel(value, kp->base + PRESCALE_OFFSET);
 
-		writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
+	/* If the PWM channel is not enabled, enable the clock */
+	if (!test_bit(PWMF_ENABLED, &pwm->flags)) {
+		ret = clk_prepare_enable(kp->clk);
+		if (ret < 0) {
+			dev_err(chip->dev, "failed to enable clock: %d\n", ret);
+			return ret;
+		}
+	}
 
-		writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
+	/* Set smooth bit to maintain old output */
+	kona_pwmc_set_smooth(kp, chan);
+	kona_pwmc_clear_trigger(kp, chan);
+
+	/* apply new settings */
+	kona_pwmc_write_settings(kp, chan, prescale, pc, dc);
+
+	/*If the PWM is enabled, enable the channel with the new settings
+	 and if not  disable the clock*/
+	if (test_bit(PWMF_ENABLED, &pwm->flags))
+		kona_pwmc_set_trigger(kp, chan);
+	else
+		clk_disable_unprepare(kp->clk);
 
-		kona_pwmc_apply_settings(kp, chan);
-	}
 
 	return 0;
 }
@@ -188,7 +245,6 @@ static int kona_pwmc_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 		dev_err(chip->dev, "failed to enable clock: %d\n", ret);
 		return ret;
 	}
-
 	ret = kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period);
 	if (ret < 0) {
 		clk_disable_unprepare(kp->clk);
@@ -203,12 +259,12 @@ static void kona_pwmc_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct kona_pwmc *kp = to_kona_pwmc(chip);
 	unsigned int chan = pwm->hwpwm;
 
+	kona_pwmc_clear_smooth(kp, chan);
+	kona_pwmc_clear_trigger(kp, chan);
 	/* Simulate a disable by configuring for zero duty */
-	writel(0, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
-	kona_pwmc_apply_settings(kp, chan);
-
-	/* Wait for waveform to settle before gating off the clock */
-	ndelay(400);
+	kona_pwmc_write_settings(kp, chan, 0, 0, 0);
+	kona_pwmc_set_polarity(chip, pwm, PWM_POLARITY_NORMAL);
+	kona_pwmc_set_trigger(kp, chan);
 
 	clk_disable_unprepare(kp->clk);
 }
-- 
2.1.3

