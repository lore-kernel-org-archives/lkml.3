Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbaGNOfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:35:12 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:54260 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbaGNOeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:34:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, thierry.reding@gmail.com,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        ajitpal.singh@st.com
Subject: [PATCH v2 08/11] pwm: st: Fix PWM prescaler handling
Date: Mon, 14 Jul 2014 15:33:29 +0100
Message-Id: <1405348412-7352-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ajit Pal Singh <ajitpal.singh@st.com>

This patch fixes the pwm driver to write the complete 8 bits of
the prescaler value to the PWM Control register.

Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/pwm/pwm-sti.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/pwm/pwm-sti.c b/drivers/pwm/pwm-sti.c
index fdedce0..21d97bc2 100644
--- a/drivers/pwm/pwm-sti.c
+++ b/drivers/pwm/pwm-sti.c
@@ -25,10 +25,13 @@
 #define STI_DS_REG(ch)	(4 * (ch))	/* Channel's Duty Cycle register */
 #define STI_PWMCR	0x50		/* Control/Config register */
 #define STI_INTEN	0x54		/* Interrupt Enable/Disable register */
+#define PWM_PRESCALE_LOW_MASK		0x0f
+#define PWM_PRESCALE_HIGH_MASK		0xf0
 
 /* Regfield IDs */
 enum {
-	PWMCLK_PRESCALE,
+	PWMCLK_PRESCALE_LOW,
+	PWMCLK_PRESCALE_HIGH,
 	PWM_EN,
 	PWM_INT_EN,
 
@@ -49,7 +52,8 @@ struct sti_pwm_chip {
 	unsigned long clk_rate;
 	struct regmap *regmap;
 	struct sti_pwm_compat_data *cdata;
-	struct regmap_field *prescale;
+	struct regmap_field *prescale_low;
+	struct regmap_field *prescale_high;
 	struct regmap_field *pwm_en;
 	struct regmap_field *pwm_int_en;
 	unsigned long *pwm_periods;
@@ -58,7 +62,8 @@ struct sti_pwm_chip {
 };
 
 static const struct reg_field sti_pwm_regfields[MAX_REGFIELDS] = {
-	[PWMCLK_PRESCALE]	= REG_FIELD(STI_PWMCR, 0, 3),
+	[PWMCLK_PRESCALE_LOW]	= REG_FIELD(STI_PWMCR, 0, 3),
+	[PWMCLK_PRESCALE_HIGH]	= REG_FIELD(STI_PWMCR, 11, 14),
 	[PWM_EN]		= REG_FIELD(STI_PWMCR, 9, 9),
 	[PWM_INT_EN]		= REG_FIELD(STI_INTEN, 0, 0),
 };
@@ -109,10 +114,10 @@ static int sti_pwm_cmp_periods(const void *key, const void *elt)
  * For STiH4xx PWM IP, the PWM period is fixed to 256 local clock cycles.
  * The only way to change the period (apart from changing the PWM input clock)
  * is to change the PWM clock prescaler.
- * The prescaler is of 4 bits, so only 16 prescaler values and hence only
- * 16 possible period values are supported (for a particular clock rate).
+ * The prescaler is of 8 bits, so 256 prescaler values and hence
+ * 256 possible period values are supported (for a particular clock rate).
  * The requested period will be applied only if it matches one of these
- * 16 values.
+ * 256 values.
  */
 static int sti_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 			 int duty_ns, int period_ns)
@@ -154,7 +159,13 @@ static int sti_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (ret)
 		return ret;
 
-	ret = regmap_field_write(pc->prescale, prescale);
+	ret = regmap_field_write(pc->prescale_low,
+				 prescale & PWM_PRESCALE_LOW_MASK);
+	if (ret)
+		goto clk_dis;
+
+	ret = regmap_field_write(pc->prescale_high,
+				 (prescale & PWM_PRESCALE_HIGH_MASK) >> 4);
 	if (ret)
 		goto clk_dis;
 
@@ -222,10 +233,15 @@ static int sti_pwm_probe_dt(struct sti_pwm_chip *pc)
 
 	reg_fields = cdata->reg_fields;
 
-	pc->prescale = devm_regmap_field_alloc(dev, pc->regmap,
-					       reg_fields[PWMCLK_PRESCALE]);
-	if (IS_ERR(pc->prescale))
-		return PTR_ERR(pc->prescale);
+	pc->prescale_low = devm_regmap_field_alloc(dev, pc->regmap,
+					reg_fields[PWMCLK_PRESCALE_LOW]);
+	if (IS_ERR(pc->prescale_low))
+		return PTR_ERR(pc->prescale_low);
+
+	pc->prescale_high = devm_regmap_field_alloc(dev, pc->regmap,
+					reg_fields[PWMCLK_PRESCALE_HIGH]);
+	if (IS_ERR(pc->prescale_high))
+		return PTR_ERR(pc->prescale_high);
 
 	pc->pwm_en = devm_regmap_field_alloc(dev, pc->regmap,
 					     reg_fields[PWM_EN]);
-- 
1.8.3.2

