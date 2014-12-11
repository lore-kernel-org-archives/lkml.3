Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbaLKBHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:07:00 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:14220 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621AbaLKBG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:06:58 -0500
X-IronPort-AV: E=Sophos;i="5.07,554,1413270000"; 
   d="scan'208";a="52776747"
From: Jonathan Richardson <jonathar@broadcom.com>
To: Tim Kryger <tim.kryger@gmail.com>
CC: Scott Branden <sbranden@broadcom.com>,
        Arun Ramamurthy <arun.ramamurthy@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
        "Jonathan Richardson" <jonathar@broadcom.com>
Subject: [PATCH v2 1/2]     pwm: kona: Fix incorrect enable, config, and disable procedures
Date: Wed, 10 Dec 2014 17:07:38 -0800
Message-ID: <1418260059-1642-1-git-send-email-jonathar@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Jonathan Richardson <jonathar@broadcom.com>
References: <Jonathan Richardson <jonathar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    The config procedure doesn't follow the spec which periodically results
    in failing to enable the output signal. This happens one in ten or
    twenty attempts. Following the spec and adding a 400ns delay in the
    appropriate locations resolves this problem. It also ensures that the
    signal transition is smooth.

    If config is called when the pwm is disabled and there is nothing to do,
    the while loop to calculate duty cycle and period doesn't need to be
    done. The function now just returns if the pwm state is disabled.

    The disable procedure now also follows the spec to ensure a smooth
    transition. Not following the spec can cause non-smooth transitions.

    The enable procedure now clears the enabled bit if enabling failed.
    Enabling can fail if an invalid duty cycle and period is set. This
    prevents the sysfs interface from reporting the pwm is enabled after a
    failed call to enable.

Reviewed-by: Arun Ramamurthy <arunrama@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
Tested-by: Scott Branden <sbranden@broadcom.com>
Signed-off-by: Jonathan Richardson <jonathar@broadcom.com>
---
 drivers/pwm/pwm-bcm-kona.c |   91 ++++++++++++++++++++++++++++++++------------
 1 file changed, 67 insertions(+), 24 deletions(-)

diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
index 02bc048..6d92026 100644
--- a/drivers/pwm/pwm-bcm-kona.c
+++ b/drivers/pwm/pwm-bcm-kona.c
@@ -80,15 +80,19 @@ static void kona_pwmc_apply_settings(struct kona_pwmc *kp, unsigned int chan)
 {
 	unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
 
-	/* Clear trigger bit but set smooth bit to maintain old output */
-	value |= 1 << PWM_CONTROL_SMOOTH_SHIFT(chan);
-	value &= ~(1 << PWM_CONTROL_TRIGGER_SHIFT(chan));
-	writel(value, kp->base + PWM_CONTROL_OFFSET);
+	/*
+	 * There must be a min 400ns delay between clearing enable and setting
+	 * it. Failing to do this may result in no PWM signal.
+	 */
+	ndelay(400);
 
 	/* Set trigger bit and clear smooth bit to apply new settings */
 	value &= ~(1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
 	value |= 1 << PWM_CONTROL_TRIGGER_SHIFT(chan);
 	writel(value, kp->base + PWM_CONTROL_OFFSET);
+
+	/* PWMOUT_ENABLE must be held high for at least 400 ns. */
+	ndelay(400);
 }
 
 static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
@@ -99,6 +103,9 @@ static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long prescale = PRESCALE_MIN, pc, dc;
 	unsigned int value, chan = pwm->hwpwm;
 
+	if (!test_bit(PWMF_ENABLED, &pwm->flags))
+		return 0;
+
 	/*
 	 * Find period count, duty count and prescale to suit duty_ns and
 	 * period_ns. This is done according to formulas described below:
@@ -121,31 +128,60 @@ static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		dc = div64_u64(val, div);
 
 		/* If duty_ns or period_ns are not achievable then return */
-		if (pc < PERIOD_COUNT_MIN || dc < DUTY_CYCLE_HIGH_MIN)
+		if (pc < PERIOD_COUNT_MIN) {
+			dev_warn(chip->dev,
+				"%s: pwm[%d]: period=%d is not achievable, pc=%lu, prescale=%lu\n",
+				__func__, chan, period_ns, pc, prescale);
 			return -EINVAL;
+		}
+
+		/* If duty_ns is not achievable then return */
+		if (dc < DUTY_CYCLE_HIGH_MIN) {
+			if (0 != duty_ns) {
+				dev_warn(chip->dev,
+					"%s: pwm[%d]: duty cycle=%d is not achievable, dc=%lu, prescale=%lu\n",
+					__func__, chan, duty_ns, dc, prescale);
+			}
+			return -EINVAL;
+		}
 
 		/* If pc and dc are in bounds, the calculation is done */
 		if (pc <= PERIOD_COUNT_MAX && dc <= DUTY_CYCLE_HIGH_MAX)
 			break;
 
 		/* Otherwise, increase prescale and recalculate pc and dc */
-		if (++prescale > PRESCALE_MAX)
+		if (++prescale > PRESCALE_MAX) {
+			dev_warn(chip->dev,
+				"%s: pwm[%d]: Prescale (=%lu) within max (=%d) for period=%d and duty cycle=%d is not achievable\n",
+				__func__, chan, prescale, PRESCALE_MAX,
+				period_ns, duty_ns);
 			return -EINVAL;
+		}
 	}
 
-	/* If the PWM channel is enabled, write the settings to the HW */
-	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
-		value = readl(kp->base + PRESCALE_OFFSET);
-		value &= ~PRESCALE_MASK(chan);
-		value |= prescale << PRESCALE_SHIFT(chan);
-		writel(value, kp->base + PRESCALE_OFFSET);
+	dev_dbg(chip->dev, "pwm[%d]: period=%lu, duty_high=%lu, prescale=%lu\n",
+		chan, pc, dc, prescale);
 
-		writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
+	value = readl(kp->base + PWM_CONTROL_OFFSET);
 
-		writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
+	/*
+	 * Clear trigger bit but set smooth bit to maintain old
+	 * output.
+	 */
+	value |= 1 << PWM_CONTROL_SMOOTH_SHIFT(chan);
+	value &= ~(1 << PWM_CONTROL_TRIGGER_SHIFT(chan));
+	writel(value, kp->base + PWM_CONTROL_OFFSET);
 
-		kona_pwmc_apply_settings(kp, chan);
-	}
+	value = readl(kp->base + PRESCALE_OFFSET);
+	value &= ~PRESCALE_MASK(chan);
+	value |= prescale << PRESCALE_SHIFT(chan);
+	writel(value, kp->base + PRESCALE_OFFSET);
+
+	writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
+
+	writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
+
+	kona_pwmc_apply_settings(kp, chan);
 
 	return 0;
 }
@@ -173,11 +209,6 @@ static int kona_pwmc_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	writel(value, kp->base + PWM_CONTROL_OFFSET);
 
-	kona_pwmc_apply_settings(kp, chan);
-
-	/* Wait for waveform to settle before gating off the clock */
-	ndelay(400);
-
 	clk_disable_unprepare(kp->clk);
 
 	return 0;
@@ -190,12 +221,14 @@ static int kona_pwmc_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	ret = clk_prepare_enable(kp->clk);
 	if (ret < 0) {
+		clear_bit(PWMF_ENABLED, &pwm->flags);
 		dev_err(chip->dev, "failed to enable clock: %d\n", ret);
 		return ret;
 	}
 
 	ret = kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period);
 	if (ret < 0) {
+		clear_bit(PWMF_ENABLED, &pwm->flags);
 		clk_disable_unprepare(kp->clk);
 		return ret;
 	}
@@ -207,13 +240,23 @@ static void kona_pwmc_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct kona_pwmc *kp = to_kona_pwmc(chip);
 	unsigned int chan = pwm->hwpwm;
+	unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
+
+	/* Set smooth type to 0 and disable */
+	value &= ~(1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
+	value &= ~(1 << PWM_CONTROL_TRIGGER_SHIFT(chan));
+	writel(value, kp->base + PWM_CONTROL_OFFSET);
 
 	/* Simulate a disable by configuring for zero duty */
 	writel(0, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
-	kona_pwmc_apply_settings(kp, chan);
+	writel(0, kp->base + PERIOD_COUNT_OFFSET(chan));
 
-	/* Wait for waveform to settle before gating off the clock */
-	ndelay(400);
+	/* Set prescale to 0 for this channel */
+	value = readl(kp->base + PRESCALE_OFFSET);
+	value &= ~PRESCALE_MASK(chan);
+	writel(value, kp->base + PRESCALE_OFFSET);
+
+	kona_pwmc_apply_settings(kp, chan);
 
 	clk_disable_unprepare(kp->clk);
 }
-- 
1.7.9.5

