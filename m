Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbbALQND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:13:03 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:44412 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbbALQMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:12:49 -0500
From: Johan Hovold <johan@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 5/6] gpio: fix sleep-while-atomic in gpiochip_remove
Date: Mon, 12 Jan 2015 17:12:28 +0100
Message-Id: <1421079149-2236-6-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1421079149-2236-1-git-send-email-johan@kernel.org>
References: <1421079149-2236-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move direct and indirect calls to gpiochip_remove_pin_ranges outside of
spin lock as they can end up taking a mutex in pinctrl_remove_gpio_range.

Note that the pin ranges are already added outside of the lock.

Fixes: 9ef0d6f7628b ("gpiolib: call pin removal in chip removal function")
Fixes: f23f1516b675 ("gpiolib: provide provision to register pin ranges")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpio/gpiolib.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 0f8173051edc..37f919dc2cb4 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -330,12 +330,10 @@ void gpiochip_remove(struct gpio_chip *chip)
 	gpiochip_irqchip_remove(chip);
 
 	acpi_gpiochip_remove(chip);
-
-	spin_lock_irqsave(&gpio_lock, flags);
-
 	gpiochip_remove_pin_ranges(chip);
 	of_gpiochip_remove(chip);
 
+	spin_lock_irqsave(&gpio_lock, flags);
 	for (id = 0; id < chip->ngpio; id++) {
 		if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags))
 			dev_crit(chip->dev, "REMOVING GPIOCHIP WITH GPIOS STILL REQUESTED\n");
-- 
2.0.5

