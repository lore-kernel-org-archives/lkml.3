Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbbAYScb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:32:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbbAYSK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.18 136/183] gpio: fix memory leak and sleep-while-atomic
Date: Sun, 25 Jan 2015 10:07:38 -0800
Message-Id: <20150125180816.089114188@linuxfoundation.org>
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

commit 00acc3dc248063f982cfacfbe5e78c0d6797ffef upstream.

Fix memory leak and sleep-while-atomic in gpiochip_remove.

The memory leak was introduced by afa82fab5e13 ("gpio / ACPI: Move event
handling registration to gpiolib irqchip helpers") that moved the
release of acpi interrupt resources to gpiochip_irqchip_remove, but by
then the resources are no longer accessible as the acpi_gpio_chip has
already been freed by acpi_gpiochip_remove.

Note that this also fixes a few potential sleep-while-atomics, which has
been around since 1425052097b5 ("gpio: add IRQ chip helpers in gpiolib")
when the call to gpiochip_irqchip_remove while holding a spinlock was
added (a couple of irq-domain paths can end up grabbing mutexes).

Fixes: afa82fab5e13 ("gpio / ACPI: Move event handling registration to
gpiolib irqchip helpers")
Fixes: 1425052097b5 ("gpio: add IRQ chip helpers in gpiolib")

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -316,11 +316,12 @@ void gpiochip_remove(struct gpio_chip *c
 	unsigned long	flags;
 	unsigned	id;
 
+	gpiochip_irqchip_remove(chip);
+
 	acpi_gpiochip_remove(chip);
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	gpiochip_irqchip_remove(chip);
 	gpiochip_remove_pin_ranges(chip);
 	of_gpiochip_remove(chip);
 


