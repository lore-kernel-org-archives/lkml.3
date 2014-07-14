Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbaGNOem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:34:42 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:52013 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbaGNOeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:34:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, thierry.reding@gmail.com,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        ajitpal.singh@st.com
Subject: [PATCH v2 11/11] pwm: sti: Remove PWM period table
Date: Mon, 14 Jul 2014 15:33:32 +0100
Message-Id: <1405348412-7352-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ajit Pal Singh <ajitpal.singh@st.com>

Removes the PWM period table. Instead the prescaler is computed
from the period value passed in the config() function.

Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/pwm/pwm-sti.c | 64 +++++++++++++--------------------------------------
 1 file changed, 16 insertions(+), 48 deletions(-)

diff --git a/drivers/pwm/pwm-sti.c b/drivers/pwm/pwm-sti.c
index 1aa901d..ceeeef6 100644
--- a/drivers/pwm/pwm-sti.c
+++ b/drivers/pwm/pwm-sti.c
@@ -10,7 +10,6 @@
  * (at your option) any later version.
  */
 
-#include <linux/bsearch.h>
 #include <linux/clk.h>
 #include <linux/math64.h>
 #include <linux/mfd/syscon.h>
@@ -56,7 +55,6 @@ struct sti_pwm_chip {
 	struct regmap_field *prescale_high;
 	struct regmap_field *pwm_en;
 	struct regmap_field *pwm_int_en;
-	unsigned long *pwm_periods;
 	struct pwm_chip chip;
 	struct pwm_device *cur;
 	unsigned int en_count;
@@ -77,29 +75,31 @@ static inline struct sti_pwm_chip *to_sti_pwmchip(struct pwm_chip *chip)
 }
 
 /*
- * Calculate the period values supported by the PWM for the
- * current clock rate.
+ * Calculate the prescaler value corresponding to the period.
  */
-static void sti_pwm_calc_periods(struct sti_pwm_chip *pc)
+static int sti_pwm_get_prescale(struct sti_pwm_chip *pc, unsigned long period,
+				unsigned int *prescale)
 {
 	struct sti_pwm_compat_data *cdata = pc->cdata;
-	struct device *dev = pc->dev;
 	unsigned long val;
-	int i;
+	unsigned int ps;
 
 	/*
-	 * period_ns = (10^9 * (prescaler + 1) * (MAX_PWM_COUNT + 1)) / CLK_RATE
+	 * prescale = ((period_ns * clk_rate) / (10^9 * (max_pwm_count + 1)) - 1
 	 */
 	val = NSEC_PER_SEC / pc->clk_rate;
 	val *= cdata->max_pwm_cnt + 1;
 
-	dev_dbg(dev, "possible periods for clkrate[HZ]:%lu\n", pc->clk_rate);
-
-	for (i = 0; i <= cdata->max_prescale; i++) {
-		pc->pwm_periods[i] = val * (i + 1);
-		dev_dbg(dev, "prescale:%d, period[ns]:%lu\n",
-			i, pc->pwm_periods[i]);
+	if (period % val) {
+		return -EINVAL;
+	} else {
+		ps  = period / val - 1;
+		if (ps > cdata->max_prescale)
+			return -EINVAL;
 	}
+	*prescale = ps;
+
+	return 0;
 }
 
 /* Calculate the number of PWM devices configured with a period. */
@@ -120,17 +120,6 @@ unsigned int sti_pwm_count_configured(struct pwm_chip *chip)
 	return ncfg;
 }
 
-static int sti_pwm_cmp_periods(const void *key, const void *elt)
-{
-	unsigned long i = *(unsigned long *)key;
-	unsigned long j = *(unsigned long *)elt;
-
-	if (i < j)
-		return -1;
-	else
-		return i == j ? 0 : 1;
-}
-
 /*
  * For STiH4xx PWM IP, the PWM period is fixed to 256 local clock cycles.
  * The only way to change the period (apart from changing the PWM input clock)
@@ -148,7 +137,6 @@ static int sti_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	struct pwm_device *cur = pc->cur;
 	struct device *dev = pc->dev;
 	unsigned int prescale = 0, pwmvalx;
-	unsigned long *found;
 	int ret;
 	unsigned int ncfg;
 	bool period_same = false;
@@ -178,21 +166,9 @@ static int sti_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 			return ret;
 
 		if (!period_same) {
-			/*
-			 * Search for matching period value.
-			 * The corresponding index is our prescale value.
-			 */
-			found = bsearch(&period_ns, &pc->pwm_periods[0],
-					cdata->max_prescale + 1,
-					sizeof(unsigned long),
-					sti_pwm_cmp_periods);
-			if (!found) {
-				dev_err(dev,
-					"failed to find matching period\n");
-				ret = -EINVAL;
+			ret = sti_pwm_get_prescale(pc, period_ns, &prescale);
+			if (ret)
 				goto clk_dis;
-			}
-			prescale = found - &pc->pwm_periods[0];
 
 			ret =
 			regmap_field_write(pc->prescale_low,
@@ -373,12 +349,6 @@ static int sti_pwm_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	pc->pwm_periods = devm_kzalloc(dev,
-			sizeof(unsigned long) * (pc->cdata->max_prescale + 1),
-			GFP_KERNEL);
-	if (!pc->pwm_periods)
-		return -ENOMEM;
-
 	pc->clk = of_clk_get_by_name(np, "pwm");
 	if (IS_ERR(pc->clk)) {
 		dev_err(dev, "failed to get PWM clock\n");
@@ -397,8 +367,6 @@ static int sti_pwm_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	sti_pwm_calc_periods(pc);
-
 	pc->chip.dev = dev;
 	pc->chip.ops = &sti_pwm_ops;
 	pc->chip.base = -1;
-- 
1.8.3.2

