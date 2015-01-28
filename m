Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbbA2JVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:21:45 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44888 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760380AbbA2JHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:07:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 105/176] gpio: fix memory and reference leaks in gpiochip_add error path
Date: Wed, 28 Jan 2015 15:28:55 +0100
Message-Id: <5d0a558e5ff4a3a9bc8ba8f5da1a66606ee502a2.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpio/gpiolib.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 0dee0e0c247a..aed1a6216b6b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1216,18 +1216,20 @@ int gpiochip_add(struct gpio_chip *chip)
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
+	if (status)
+		goto fail;
+
 #ifdef CONFIG_PINCTRL
 	INIT_LIST_HEAD(&chip->pin_ranges);
 #endif
 
 	of_gpiochip_add(chip);
 
-	if (status)
-		goto fail;
-
 	status = gpiochip_export(chip);
-	if (status)
+	if (status) {
+		of_gpiochip_remove(chip);
 		goto fail;
+	}
 
 	pr_debug("gpiochip_add: registered GPIOs %d to %d on device: %s\n",
 		chip->base, chip->base + chip->ngpio - 1,
-- 
2.2.2

