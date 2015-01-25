Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbbAYScd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:32:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbbAYSK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.18 137/183] gpio: fix sleep-while-atomic in gpiochip_remove
Date: Sun, 25 Jan 2015 10:07:39 -0800
Message-Id: <20150125180816.130616375@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6798acaa0138d8b12f1c54402ebcb66fea3deb03 upstream.

Move direct and indirect calls to gpiochip_remove_pin_ranges outside of
spin lock as they can end up taking a mutex in pinctrl_remove_gpio_range.

Note that the pin ranges are already added outside of the lock.

Fixes: 9ef0d6f7628b ("gpiolib: call pin removal in chip removal function")
Fixes: f23f1516b675 ("gpiolib: provide provision to register pin ranges")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -319,12 +319,10 @@ void gpiochip_remove(struct gpio_chip *c
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


