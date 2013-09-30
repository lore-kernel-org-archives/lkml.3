Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3I3PWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:22:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54600 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753743Ab3I3PWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:22:53 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-pwm@vger.kernel.org, voice.shen@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2] PWM: atmel-pwm: use request/free instead of enable/disable
Date: Mon, 30 Sep 2013 17:22:33 +0200
Message-Id: <1380554553-25676-1-git-send-email-alexandre.belloni@free-electrons.com>
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
Applies on [PATCH v5] PWM: atmel-pwm: add PWM controller driver

Changes in v2:
  - add dummies pwm_enable and pwm_disable to be able to register the pwm chip.

 drivers/pwm/pwm-atmel.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
index b4df36c..732312c 100644
--- a/drivers/pwm/pwm-atmel.c
+++ b/drivers/pwm/pwm-atmel.c
@@ -206,7 +206,7 @@ static int atmel_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
 	return 0;
 }
 
-static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+static int atmel_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
 	int ret;
@@ -222,7 +222,7 @@ static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	return 0;
 }
 
-static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+static void atmel_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
 
@@ -231,9 +231,28 @@ static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	clk_disable(atmel_pwm->clk);
 }
 
+static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	/*
+	 * This is a dummy function, required to be able to register the pwm
+	 * chip, see pwmadd_chip() in pwm/core.c
+	 */
+	return 0;
+}
+
+static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	/*
+	 * This is a dummy function, required to be able to register the pwm
+	 * chip, see pwmadd_chip() in pwm/core.c
+	 */
+}
+
 static const struct pwm_ops atmel_pwm_ops = {
 	.config = atmel_pwm_config,
 	.set_polarity = atmel_pwm_set_polarity,
+	.request = atmel_pwm_request,
+	.free = atmel_pwm_free,
 	.enable = atmel_pwm_enable,
 	.disable = atmel_pwm_disable,
 	.owner = THIS_MODULE,
-- 
1.8.1.2

