Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3LCDbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:31:21 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6129 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3LCDbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:31:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Dec 2013 19:24:44 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpio: rewrite gpiochip_offset_to_desc()
Date: Tue, 3 Dec 2013 12:31:11 +0900
Message-ID: <1386041471-1826-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpiochip_offset_to_desc() was using gpio_to_desc(), which directly
addresses the global GPIO array we are hoping to get rid of someday.
Reimplement it using the descriptor array of the chip itself, after
checking the requested offset is within the valid bounds of the chip.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 4ca103965d8c..ea95b42c6154 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -150,9 +150,10 @@ EXPORT_SYMBOL_GPL(gpio_to_desc);
 static struct gpio_desc *gpiochip_offset_to_desc(struct gpio_chip *chip,
 						 unsigned int offset)
 {
-	unsigned int gpio = chip->base + offset;
+	if (offset >= chip->ngpio)
+		return ERR_PTR(-EINVAL);
 
-	return gpio_to_desc(gpio);
+	return &chip->desc[offset];
 }
 
 /**
-- 
1.8.4.2

