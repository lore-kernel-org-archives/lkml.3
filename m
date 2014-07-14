Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaGNOfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:35:07 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:62949 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbaGNOeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:34:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, thierry.reding@gmail.com,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        ajitpal.singh@st.com
Subject: [PATCH v2 09/11] pwm: sti: Ensure same period values for all channels
Date: Mon, 14 Jul 2014 15:33:30 +0100
Message-Id: <1405348412-7352-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ajit Pal Singh <ajitpal.singh@st.com>

ST PWM IP shares the same clock prescaler across all the PWM
channels. Hence configuration requests which change the period
will affect all the channels. Do not allow period changes which
will stomp period settings of the already configured channels.

Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/pwm/pwm-sti.c | 140 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 96 insertions(+), 44 deletions(-)

diff --git a/drivers/pwm/pwm-sti.c b/drivers/pwm/pwm-sti.c
index 21d97bc2..0fdf4b4 100644
--- a/drivers/pwm/pwm-sti.c
+++ b/drivers/pwm/pwm-sti.c
@@ -58,6 +58,7 @@ struct sti_pwm_chip {
 	struct regmap_field *pwm_int_en;
 	unsigned long *pwm_periods;
 	struct pwm_chip chip;
+	struct pwm_device *cur;
 	void __iomem *mmio;
 };
 
@@ -99,6 +100,24 @@ static void sti_pwm_calc_periods(struct sti_pwm_chip *pc)
 	}
 }
 
+/* Calculate the number of PWM devices configured with a period. */
+unsigned int sti_pwm_count_configured(struct pwm_chip *chip)
+{
+	struct pwm_device *pwm;
+	unsigned int ncfg = 0;
+	unsigned int i;
+
+	for (i = 0; i < chip->npwm; i++) {
+		pwm = &chip->pwms[i];
+		if (test_bit(PWMF_REQUESTED, &pwm->flags)) {
+			if (pwm_get_period(pwm))
+				ncfg++;
+		}
+	}
+
+	return ncfg;
+}
+
 static int sti_pwm_cmp_periods(const void *key, const void *elt)
 {
 	unsigned long i = *(unsigned long *)key;
@@ -124,57 +143,90 @@ static int sti_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 {
 	struct sti_pwm_chip *pc = to_sti_pwmchip(chip);
 	struct sti_pwm_compat_data *cdata = pc->cdata;
+	struct pwm_device *cur = pc->cur;
 	struct device *dev = pc->dev;
-	unsigned int prescale, pwmvalx;
+	unsigned int prescale = 0, pwmvalx;
 	unsigned long *found;
 	int ret;
-
-	/*
-	 * Search for matching period value. The corresponding index is our
-	 * prescale value
+	unsigned int ncfg;
+	bool period_same = false;
+
+	ncfg = sti_pwm_count_configured(chip);
+	if (ncfg)
+		period_same = (period_ns == pwm_get_period(cur));
+
+	/* Allow configuration changes if one of the
+	 * following conditions satisfy.
+	 * 1. No channels have been configured.
+	 * 2. Only one channel has been configured and the new request
+	 *    is for the same channel.
+	 * 3. Only one channel has been configured and the new request is
+	 *    for a new channel and period of the new channel is same as
+	 *    the current configured period.
+	 * 4. More than one channels are configured and period of the new
+	 *    requestis the same as the current period.
 	 */
-	found = bsearch(&period_ns, &pc->pwm_periods[0],
-			cdata->max_prescale + 1, sizeof(unsigned long),
-			sti_pwm_cmp_periods);
-	if (!found) {
-		dev_err(dev, "failed to find matching period\n");
+	if (!ncfg ||
+	    ((ncfg == 1) && (pwm->hwpwm == cur->hwpwm)) ||
+	    ((ncfg == 1) && (pwm->hwpwm != cur->hwpwm) && period_same) ||
+	    ((ncfg > 1) && period_same)) {
+		/* Enable clock before writing to PWM registers. */
+		ret = clk_enable(pc->clk);
+		if (ret)
+			return ret;
+
+		if (!period_same) {
+			/*
+			 * Search for matching period value.
+			 * The corresponding index is our prescale value.
+			 */
+			found = bsearch(&period_ns, &pc->pwm_periods[0],
+					cdata->max_prescale + 1,
+					sizeof(unsigned long),
+					sti_pwm_cmp_periods);
+			if (!found) {
+				dev_err(dev,
+					"failed to find matching period\n");
+				ret = -EINVAL;
+				goto clk_dis;
+			}
+			prescale = found - &pc->pwm_periods[0];
+
+			ret =
+			regmap_field_write(pc->prescale_low,
+					   prescale & PWM_PRESCALE_LOW_MASK);
+			if (ret)
+				goto clk_dis;
+
+			ret =
+			regmap_field_write(pc->prescale_high,
+				(prescale & PWM_PRESCALE_HIGH_MASK) >> 4);
+			if (ret)
+				goto clk_dis;
+		}
+
+		/*
+		 * When PWMVal == 0, PWM pulse = 1 local clock cycle.
+		 * When PWMVal == max_pwm_count,
+		 * PWM pulse = (max_pwm_count + 1) local cycles,
+		 * that is continuous pulse: signal never goes low.
+		 */
+		pwmvalx = cdata->max_pwm_cnt * duty_ns / period_ns;
+
+		ret = regmap_write(pc->regmap, STI_DS_REG(pwm->hwpwm), pwmvalx);
+		if (ret)
+			goto clk_dis;
+
+		ret = regmap_field_write(pc->pwm_int_en, 0);
+
+		pc->cur = pwm;
+
+		dev_dbg(dev, "prescale:%u, period:%lu, duty:%i, pwmvalx:%u\n",
+			prescale, period_ns, duty_ns, pwmvalx);
+	} else {
 		return -EINVAL;
 	}
 
-	prescale = found - &pc->pwm_periods[0];
-
-	/*
-	 * When PWMVal == 0, PWM pulse = 1 local clock cycle.
-	 * When PWMVal == max_pwm_count,
-	 * PWM pulse = (max_pwm_count + 1) local cycles,
-	 * that is continuous pulse: signal never goes low.
-	 */
-	pwmvalx = cdata->max_pwm_cnt * duty_ns / period_ns;
-
-	dev_dbg(dev, "prescale:%u, period:%i, duty:%i, pwmvalx:%u\n",
-		prescale, period_ns, duty_ns, pwmvalx);
-
-	/* Enable clock before writing to PWM registers */
-	ret = clk_enable(pc->clk);
-	if (ret)
-		return ret;
-
-	ret = regmap_field_write(pc->prescale_low,
-				 prescale & PWM_PRESCALE_LOW_MASK);
-	if (ret)
-		goto clk_dis;
-
-	ret = regmap_field_write(pc->prescale_high,
-				 (prescale & PWM_PRESCALE_HIGH_MASK) >> 4);
-	if (ret)
-		goto clk_dis;
-
-	ret = regmap_write(pc->regmap, STI_PWMVAL(pwm->hwpwm), pwmvalx);
-	if (ret)
-		goto clk_dis;
-
-	ret = regmap_field_write(pc->pwm_int_en, 0);
-
 clk_dis:
 	clk_disable(pc->clk);
 	return ret;
-- 
1.8.3.2

