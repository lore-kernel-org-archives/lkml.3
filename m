Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3I0UKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:10:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47408 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751985Ab3I0UKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:10:32 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-pwm@vger.kernel.org, voice.shen@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] PWM: atmel-pwm: use request/free instead of enable/disable
Date: Fri, 27 Sep 2013 22:10:28 +0200
Message-Id: <1380312628-6564-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that disabling a pwm while it is at a low level will actually put it
back at a high level. The main symptom is that leds-pwm is calling pwm_disable()
after setting the duty cycle to 0. Hence, instead of getting a switched off LED,
you get an LED lit up at full brightness.

Solve that by using the request and free callbacks to enable and disable the
pwm channels and the clock.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---

This patch applies after:
  [PATCH v4] PWM: atmel-pwm: add PWM controller driver

 drivers/pwm/pwm-atmel.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
index 6af7a50..4526e71 100644
--- a/drivers/pwm/pwm-atmel.c
+++ b/drivers/pwm/pwm-atmel.c
@@ -209,7 +209,7 @@ static int atmel_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
 	return 0;
 }
 
-static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+static int atmel_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
 	int ret;
@@ -225,23 +225,19 @@ static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	return 0;
 }
 
-static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+static void atmel_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
-	u32 val;
 
 	atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
-
-	val = atmel_pwm_readl(atmel_pwm, PWM_SR);
-	if ((val & PWM_SR_ALL_CH_ON) == 0)
-		clk_disable(atmel_pwm->clk);
+	clk_disable(atmel_pwm->clk);
 }
 
 static const struct pwm_ops atmel_pwm_ops = {
 	.config = atmel_pwm_config,
 	.set_polarity = atmel_pwm_set_polarity,
-	.enable = atmel_pwm_enable,
-	.disable = atmel_pwm_disable,
+	.request = atmel_pwm_request,
+	.free = atmel_pwm_free,
 	.owner = THIS_MODULE,
 };
 
-- 
1.8.1.2

