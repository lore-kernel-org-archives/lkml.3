Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaAWJGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:06:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50275 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaAWJFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:05:38 -0500
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
Subject: [PATCH 1/2] PWM: let of_xlate handlers check args count
Date: Thu, 23 Jan 2014 10:04:57 +0100
Message-Id: <1390467898-9216-2-git-send-email-s.hauer@pengutronix.de>
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

of_pwm_n_cells for the of_xlate handler is stored in struct pwm_chip,
but it is only ever used by the of_xlate handler itsel. Remove
of_pwm_n_cells from struct pwm_chip and let the handler do the argument
count checking to simplify the code.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/pwm/core.c            | 15 +++------------
 drivers/pwm/pwm-atmel-tcb.c   |  1 -
 drivers/pwm/pwm-renesas-tpu.c |  1 -
 drivers/pwm/pwm-samsung.c     |  1 -
 drivers/pwm/pwm-tiecap.c      |  1 -
 drivers/pwm/pwm-tiehrpwm.c    |  1 -
 drivers/pwm/pwm-vt8500.c      |  1 -
 7 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 2ca9504..c882051 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -136,7 +136,7 @@ of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
 {
 	struct pwm_device *pwm;
 
-	if (pc->of_pwm_n_cells < 3)
+	if (args->args_count != 3)
 		return ERR_PTR(-EINVAL);
 
 	if (args->args[0] >= pc->npwm)
@@ -162,7 +162,7 @@ of_pwm_simple_xlate(struct pwm_chip *pc, const struct of_phandle_args *args)
 {
 	struct pwm_device *pwm;
 
-	if (pc->of_pwm_n_cells < 2)
+	if (args->args_count != 2)
 		return ERR_PTR(-EINVAL);
 
 	if (args->args[0] >= pc->npwm)
@@ -182,10 +182,8 @@ static void of_pwmchip_add(struct pwm_chip *chip)
 	if (!chip->dev || !chip->dev->of_node)
 		return;
 
-	if (!chip->of_xlate) {
+	if (!chip->of_xlate)
 		chip->of_xlate = of_pwm_simple_xlate;
-		chip->of_pwm_n_cells = 2;
-	}
 
 	of_node_get(chip->dev->of_node);
 }
@@ -536,13 +534,6 @@ struct pwm_device *of_pwm_get(struct device_node *np, const char *con_id)
 		goto put;
 	}
 
-	if (args.args_count != pc->of_pwm_n_cells) {
-		pr_debug("%s: wrong #pwm-cells for %s\n", np->full_name,
-			 args.np->full_name);
-		pwm = ERR_PTR(-EINVAL);
-		goto put;
-	}
-
 	pwm = pc->of_xlate(pc, &args);
 	if (IS_ERR(pwm))
 		goto put;
diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index f3dcd02..55fabf8 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -395,7 +395,6 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 	tcbpwm->chip.dev = &pdev->dev;
 	tcbpwm->chip.ops = &atmel_tcb_pwm_ops;
 	tcbpwm->chip.of_xlate = of_pwm_xlate_with_flags;
-	tcbpwm->chip.of_pwm_n_cells = 3;
 	tcbpwm->chip.base = -1;
 	tcbpwm->chip.npwm = NPWM;
 	tcbpwm->tc = tc;
diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index aff6ba9..0a8adb6 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -434,7 +434,6 @@ static int tpu_probe(struct platform_device *pdev)
 	tpu->chip.dev = &pdev->dev;
 	tpu->chip.ops = &tpu_pwm_ops;
 	tpu->chip.of_xlate = of_pwm_xlate_with_flags;
-	tpu->chip.of_pwm_n_cells = 3;
 	tpu->chip.base = -1;
 	tpu->chip.npwm = TPU_CHANNEL_MAX;
 
diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index b59639e..8d8dced 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -487,7 +487,6 @@ static int pwm_samsung_probe(struct platform_device *pdev)
 			return ret;
 
 		chip->chip.of_xlate = of_pwm_xlate_with_flags;
-		chip->chip.of_pwm_n_cells = 3;
 	} else {
 		if (!pdev->dev.platform_data) {
 			dev_err(&pdev->dev, "no platform data specified\n");
diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 4e5c3d1..4d7a01a 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -229,7 +229,6 @@ static int ecap_pwm_probe(struct platform_device *pdev)
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &ecap_pwm_ops;
 	pc->chip.of_xlate = of_pwm_xlate_with_flags;
-	pc->chip.of_pwm_n_cells = 3;
 	pc->chip.base = -1;
 	pc->chip.npwm = 1;
 
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index a4d8f51..2c2621a 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -460,7 +460,6 @@ static int ehrpwm_pwm_probe(struct platform_device *pdev)
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &ehrpwm_pwm_ops;
 	pc->chip.of_xlate = of_pwm_xlate_with_flags;
-	pc->chip.of_pwm_n_cells = 3;
 	pc->chip.base = -1;
 	pc->chip.npwm = NUM_PWM_CHANNEL;
 
diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
index 323125a..5472051 100644
--- a/drivers/pwm/pwm-vt8500.c
+++ b/drivers/pwm/pwm-vt8500.c
@@ -219,7 +219,6 @@ static int vt8500_pwm_probe(struct platform_device *pdev)
 	chip->chip.dev = &pdev->dev;
 	chip->chip.ops = &vt8500_pwm_ops;
 	chip->chip.of_xlate = of_pwm_xlate_with_flags;
-	chip->chip.of_pwm_n_cells = 3;
 	chip->chip.base = -1;
 	chip->chip.npwm = VT8500_NR_PWMS;
 
-- 
1.8.5.2

