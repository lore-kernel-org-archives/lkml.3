Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaIXGD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 02:03:28 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.31]:58670 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaIXGD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 02:03:27 -0400
X-Greylist: delayed 709 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 02:03:27 EDT
From: Nikolaus Voss <n.voss@weinmann-emt.de>
To: Bo Shen <voice.shen@atmel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Sep 2014 15:30:21 +0200
Subject: [PATCH] pwm: atmel-pwm: fix calculation of prescale value
Message-Id: <20140924055138.477E540656@mail.steuer-voss.de>
X-Df-Sender: cG9zdGZpeEBzdGV1ZXItdm9zcy5kZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prescale value used for calculating the period was incremented
afterwards, thus the resulting prescale value is by one too high.
This resulted in a pwm frequency only half as high as requested.

This patch moves the 64 bit division out of the prescale loop to
correct the above issue and make the calculation more efficient.

Signed-off-by: Nikolaus Voss <n.voss@weinmann-emt.de>
---
 drivers/pwm/pwm-atmel.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
index 6e700a5..ff17b5d 100644
--- a/drivers/pwm/pwm-atmel.c
+++ b/drivers/pwm/pwm-atmel.c
@@ -102,7 +102,7 @@ static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 			    int duty_ns, int period_ns)
 {
 	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
-	unsigned long clk_rate, prd, dty;
+	unsigned long prd, dty;
 	unsigned long long div;
 	unsigned int pres = 0;
 	u32 val;
@@ -113,20 +113,18 @@ static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		return -EBUSY;
 	}
 
-	clk_rate = clk_get_rate(atmel_pwm->clk);
-	div = clk_rate;
+	/* Calculate the period cycles and prescale value */
+	div = (unsigned long long)clk_get_rate(atmel_pwm->clk) * period_ns;
+	do_div(div, (int)1e9);
 
-	/* Calculate the period cycles */
 	while (div > PWM_MAX_PRD) {
-		div = clk_rate / (1 << pres);
-		div = div * period_ns;
-		/* 1/Hz = 100000000 ns */
-		do_div(div, 1000000000);
-
-		if (pres++ > PRD_MAX_PRES) {
-			dev_err(chip->dev, "pres exceeds the maximum value\n");
-			return -EINVAL;
-		}
+		div >>= 1;
+		++pres;
+	}
+
+	if (pres > PRD_MAX_PRES) {
+		dev_err(chip->dev, "pres exceeds the maximum value\n");
+		return -EINVAL;
 	}
 
 	/* Calculate the duty cycles */
-- 
1.9.1

