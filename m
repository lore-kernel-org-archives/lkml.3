Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbbAYTPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:15:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbbAYSJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.14 57/98] gpio: fix memory and reference leaks in gpiochip_add error path
Date: Sun, 25 Jan 2015 10:07:15 -0800
Message-Id: <20150125180715.329686973@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 5539b3c938d64a60cb1fc442ac3ce9263d52de0c upstream.

Memory allocated and references taken by of_gpiochip_add and
acpi_gpiochip_add were never released on errors in gpiochip_add (e.g.
failure to find free gpio range).

Fixes: 391c970c0dd1 ("of/gpio: add default of_xlate function if device
has a node pointer")
Fixes: 664e3e5ac64c ("gpio / ACPI: register to ACPI events
automatically")

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1222,6 +1222,9 @@ int gpiochip_add(struct gpio_chip *chip)
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
+	if (status)
+		goto fail;
+
 #ifdef CONFIG_PINCTRL
 	INIT_LIST_HEAD(&chip->pin_ranges);
 #endif
@@ -1229,12 +1232,12 @@ int gpiochip_add(struct gpio_chip *chip)
 	of_gpiochip_add(chip);
 	acpi_gpiochip_add(chip);
 
-	if (status)
-		goto fail;
-
 	status = gpiochip_export(chip);
-	if (status)
+	if (status) {
+		acpi_gpiochip_remove(chip);
+		of_gpiochip_remove(chip);
 		goto fail;
+	}
 
 	pr_debug("%s: registered GPIOs %d to %d on device: %s\n", __func__,
 		chip->base, chip->base + chip->ngpio - 1,


