Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab3HXUz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 16:55:27 -0400
Received: from nm25-vm9.access.bullet.mail.gq1.yahoo.com ([216.39.62.72]:37958
	"EHLO nm25-vm9.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755453Ab3HXUz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 16:55:26 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Aug 2013 16:55:26 EDT
X-Yahoo-Newman-Id: 170277.95200.bm@smtp106.sbc.mail.gq1.yahoo.com
X-Rocket-Received: from localhost.localdomain (danielfsantos@99.70.244.137 with login)
        by smtp106.sbc.mail.gq1.yahoo.com with SMTP; 24 Aug 2013 13:48:25 -0700 PDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IgjQiw0VM1lizeqep.8riUv7Kk22LDzUcMZlOBqJspSCQjT
 haN4rTR56g8biPAkch38FBmgR9sUWQibynSfhEWFelWswbsgVTAxGWTOLnOZ
 6hSRNril7kci80.Jw7gNPJx53MkqhLY1uXLf0XU06lk.Hp8MylCHXwyqlsxo
 KZe8EfgnlJFZItnSIU3CyAjzmTCGJe5HsbW_27L665e3Y7cqKQ12rru3fHBj
 7g9b9x_p.1Is8dQwz0g_ImvuUchKfavfi__a9mlRW7SOLM7CuCbrgpMsRBn8
 mHqd55H8ykXWGpYRR1Qsf45D0wWaNKdgGcisWNPvAxj.NNj_6hXb8kV8zIYP
 vW736dsCJkbyUUz5nyTXd2WxTIzjCGT9tiJJdZBehVeNouXqgc7B6pyRh57C
 XUs19PdzolgXOcbIu3OMchmxyXf5l3a2553oqt_f08jkaz4FyyFV07U3.m6H
 i3gLuNlbi7nc7ZEnS4etE.mXP9y7DFfEBOnRwBV2N7pi16vi88bgAQJhHg8m
 hlAjZJmc6WOY4G9HZqWsDHQE.RnfCFzCUWj0IP8ejkLQ.MAZTowH_sfjI02_
 wW6CdReQOd9i.Hi0Anh23Q7tTw8sfxia59i2Tzd6scrGOa04jtvXwsCwaVjp
 TjvLhQ2O04iikKeGGiSwUVyBl9PViKw--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH] gpiolib: Fix crash when exporting non-existant gpio
Date: Sat, 24 Aug 2013 15:48:25 -0500
Message-Id: <1377377305-11695-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1377370108-2867-1-git-send-email-daniel.santos@pobox.com>
References: <1377370108-2867-1-git-send-email-daniel.santos@pobox.com>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this on an RPi and I can't find anything specific to that.
Besides, it's clearly wrong to try to access desc->chip when we have
just tested that it may be NULL at drivers/gpio/gpiolib.c:1409:

	chip = desc->chip;
	if (chip == NULL)
		goto done;

....

done:
	if (status)
		pr_debug("_gpio_request: gpio-%d (%s) status %d\n",
			 desc_to_gpio(desc), label ? : "?", status);

To reproduce, just pick an invalid gpio nubmer and:

echo -n 248 > /sys/class/gpio/export

However, I wasn't able to reproduce it on my laptop, maybe because I
don't have any real gpio chips there, not sure.  More info on RPi bug
report: https://github.com/raspberrypi/linux/issues/364

This fix makes sure that gpio_to_desc() only returns non-NULL if the
specified gpio really has a chip, and not just if it's within the ranged
of gpios for the arch.

[  222.961384] Unable to handle kernel NULL pointer dereference at
virtual address 00000044
[  222.969486] pgd = d97d0000
[  222.972190] [00000044] *pgd=1aaca831, *pte=00000000, *ppte=00000000
[  222.978483] Internal error: Oops: 17 [#1] PREEMPT ARM
---
 drivers/gpio/gpiolib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d6413b2..db7c6bb 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -123,7 +123,8 @@ static int gpio_chip_hwgpio(const struct gpio_desc *desc)
  */
 static struct gpio_desc *gpio_to_desc(unsigned gpio)
 {
-	if (WARN(!gpio_is_valid(gpio), "invalid GPIO %d\n", gpio))
+	if (WARN(!gpio_is_valid(gpio) || !gpio_desc[gpio].chip,
+			"invalid GPIO %d\n", gpio))
 		return NULL;
 	else
 		return &gpio_desc[gpio];
@@ -1406,8 +1407,7 @@ static int gpiod_request(struct gpio_desc *desc, const char *label)
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	chip = desc->chip;
-	if (chip == NULL)
-		goto done;
+	BUG_ON(!chip);
 
 	if (!try_module_get(chip->owner))
 		goto done;
-- 
1.8.1.5

