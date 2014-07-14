Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaGNOe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:34:59 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:50998 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbaGNOeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:34:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, thierry.reding@gmail.com,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        ajitpal.singh@st.com
Subject: [PATCH v2 10/11] pwm: sti: Sync between enable/disable calls
Date: Mon, 14 Jul 2014 15:33:31 +0100
Message-Id: <1405348412-7352-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ajit Pal Singh <ajitpal.singh@st.com>

ST PWM IP has a common enable/disable control for all the PWM
channels on a PWM cell. Disables PWM output on the PWM HW only
when disable is called for the last channel.

Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/pwm/pwm-sti.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/pwm/pwm-sti.c b/drivers/pwm/pwm-sti.c
index 0fdf4b4..1aa901d 100644
--- a/drivers/pwm/pwm-sti.c
+++ b/drivers/pwm/pwm-sti.c
@@ -59,6 +59,8 @@ struct sti_pwm_chip {
 	unsigned long *pwm_periods;
 	struct pwm_chip chip;
 	struct pwm_device *cur;
+	unsigned int en_count;
+	struct mutex sti_pwm_lock; /* To sync between enable/disable calls */
 	void __iomem *mmio;
 };
 
@@ -236,32 +238,44 @@ static int sti_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct sti_pwm_chip *pc = to_sti_pwmchip(chip);
 	struct device *dev = pc->dev;
-	int ret;
-
-	ret = clk_enable(pc->clk);
-	if (ret)
-		return ret;
+	int ret = 0;
 
-	ret = regmap_field_write(pc->pwm_en, 1);
-	if (ret)
-		dev_err(dev, "%s,pwm_en write failed\n", __func__);
+	/*
+	 * Since we have a common enable for all PWM channels,
+	 * do not enable if already enabled.
+	 */
+	mutex_lock(&pc->sti_pwm_lock);
+	if (!pc->en_count) {
+		ret = clk_enable(pc->clk);
+		if (ret)
+			goto out;
 
+		ret = regmap_field_write(pc->pwm_en, 1);
+		if (ret) {
+			dev_err(dev, "failed to enable PWM device:%d\n",
+				pwm->hwpwm);
+			goto out;
+		}
+	}
+	pc->en_count++;
+out:
+	mutex_unlock(&pc->sti_pwm_lock);
 	return ret;
 }
 
 static void sti_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct sti_pwm_chip *pc = to_sti_pwmchip(chip);
-	struct device *dev = pc->dev;
-	unsigned int val;
 
+	mutex_lock(&pc->sti_pwm_lock);
+	if (--pc->en_count) {
+		mutex_unlock(&pc->sti_pwm_lock);
+		return;
+	}
 	regmap_field_write(pc->pwm_en, 0);
 
-	regmap_read(pc->regmap, STI_CNT, &val);
-
-	dev_dbg(dev, "pwm counter :%u\n", val);
-
 	clk_disable(pc->clk);
+	mutex_unlock(&pc->sti_pwm_lock);
 }
 
 static const struct pwm_ops sti_pwm_ops = {
@@ -352,6 +366,8 @@ static int sti_pwm_probe(struct platform_device *pdev)
 
 	pc->cdata = cdata;
 	pc->dev = dev;
+	pc->en_count = 0;
+	mutex_init(&pc->sti_pwm_lock);
 
 	ret = sti_pwm_probe_dt(pc);
 	if (ret)
-- 
1.8.3.2

