Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaAWJFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:05:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50268 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaAWJF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:05:28 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/2] PWM: handle additional flags in of_pwm_simple_xlate
Date: Thu, 23 Jan 2014 10:04:58 +0100
Message-Id: <1390467898-9216-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1390467898-9216-1-git-send-email-s.hauer@pengutronix.de>
References: <20140123083714.3c6e86ae@ipc1.ka-ro>
 <1390467898-9216-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let of_pwm_simple_xlate behave like of_pwm_xlate_with_flags when
the argument count is 3. This makes of_pwm_xlate_with_flags unncessary.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/pwm/core.c            | 30 ++++++------------------------
 drivers/pwm/pwm-atmel-tcb.c   |  1 -
 drivers/pwm/pwm-renesas-tpu.c |  1 -
 drivers/pwm/pwm-samsung.c     |  2 --
 drivers/pwm/pwm-tiecap.c      |  1 -
 drivers/pwm/pwm-tiehrpwm.c    |  1 -
 drivers/pwm/pwm-vt8500.c      |  1 -
 include/linux/pwm.h           |  3 ---
 8 files changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index c882051..329b1e5 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -131,12 +131,12 @@ static int pwm_device_request(struct pwm_device *pwm, const char *label)
 	return 0;
 }
 
-struct pwm_device *
-of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
+static struct pwm_device *
+of_pwm_simple_xlate(struct pwm_chip *pc, const struct of_phandle_args *args)
 {
 	struct pwm_device *pwm;
 
-	if (args->args_count != 3)
+	if (args->args_count < 2)
 		return ERR_PTR(-EINVAL);
 
 	if (args->args[0] >= pc->npwm)
@@ -148,6 +148,9 @@ of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
 
 	pwm_set_period(pwm, args->args[1]);
 
+	if (args->args_count < 3)
+		return 0;
+
 	if (args->args[2] & PWM_POLARITY_INVERTED)
 		pwm_set_polarity(pwm, PWM_POLARITY_INVERSED);
 	else
@@ -155,27 +158,6 @@ of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
 
 	return pwm;
 }
-EXPORT_SYMBOL_GPL(of_pwm_xlate_with_flags);
-
-static struct pwm_device *
-of_pwm_simple_xlate(struct pwm_chip *pc, const struct of_phandle_args *args)
-{
-	struct pwm_device *pwm;
-
-	if (args->args_count != 2)
-		return ERR_PTR(-EINVAL);
-
-	if (args->args[0] >= pc->npwm)
-		return ERR_PTR(-EINVAL);
-
-	pwm = pwm_request_from_chip(pc, args->args[0], NULL);
-	if (IS_ERR(pwm))
-		return pwm;
-
-	pwm_set_period(pwm, args->args[1]);
-
-	return pwm;
-}
 
 static void of_pwmchip_add(struct pwm_chip *chip)
 {
diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index 55fabf8..e1e5a20 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -394,7 +394,6 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 
 	tcbpwm->chip.dev = &pdev->dev;
 	tcbpwm->chip.ops = &atmel_tcb_pwm_ops;
-	tcbpwm->chip.of_xlate = of_pwm_xlate_with_flags;
 	tcbpwm->chip.base = -1;
 	tcbpwm->chip.npwm = NPWM;
 	tcbpwm->tc = tc;
diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index 0a8adb6..82dcab9 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -433,7 +433,6 @@ static int tpu_probe(struct platform_device *pdev)
 
 	tpu->chip.dev = &pdev->dev;
 	tpu->chip.ops = &tpu_pwm_ops;
-	tpu->chip.of_xlate = of_pwm_xlate_with_flags;
 	tpu->chip.base = -1;
 	tpu->chip.npwm = TPU_CHANNEL_MAX;
 
diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index 8d8dced..465f9ee 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -485,8 +485,6 @@ static int pwm_samsung_probe(struct platform_device *pdev)
 		ret = pwm_samsung_parse_dt(chip);
 		if (ret)
 			return ret;
-
-		chip->chip.of_xlate = of_pwm_xlate_with_flags;
 	} else {
 		if (!pdev->dev.platform_data) {
 			dev_err(&pdev->dev, "no platform data specified\n");
diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 4d7a01a..27cde03 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -228,7 +228,6 @@ static int ecap_pwm_probe(struct platform_device *pdev)
 
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &ecap_pwm_ops;
-	pc->chip.of_xlate = of_pwm_xlate_with_flags;
 	pc->chip.base = -1;
 	pc->chip.npwm = 1;
 
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 2c2621a..4e566df 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -459,7 +459,6 @@ static int ehrpwm_pwm_probe(struct platform_device *pdev)
 
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &ehrpwm_pwm_ops;
-	pc->chip.of_xlate = of_pwm_xlate_with_flags;
 	pc->chip.base = -1;
 	pc->chip.npwm = NUM_PWM_CHANNEL;
 
diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
index 5472051..30def61 100644
--- a/drivers/pwm/pwm-vt8500.c
+++ b/drivers/pwm/pwm-vt8500.c
@@ -218,7 +218,6 @@ static int vt8500_pwm_probe(struct platform_device *pdev)
 
 	chip->chip.dev = &pdev->dev;
 	chip->chip.ops = &vt8500_pwm_ops;
-	chip->chip.of_xlate = of_pwm_xlate_with_flags;
 	chip->chip.base = -1;
 	chip->chip.npwm = VT8500_NR_PWMS;
 
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index f0feafd..2447d6f 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -188,9 +188,6 @@ struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
 					 unsigned int index,
 					 const char *label);
 
-struct pwm_device *of_pwm_xlate_with_flags(struct pwm_chip *pc,
-		const struct of_phandle_args *args);
-
 struct pwm_device *pwm_get(struct device *dev, const char *con_id);
 struct pwm_device *of_pwm_get(struct device_node *np, const char *con_id);
 void pwm_put(struct pwm_device *pwm);
-- 
1.8.5.2

