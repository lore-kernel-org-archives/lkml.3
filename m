Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3JDSAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:00:15 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16640 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3JDSAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:00:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Oct 2013 10:56:14 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/2] gpiolib: safer implementation of desc_to_gpio()
Date: Fri, 4 Oct 2013 10:59:57 -0700
Message-ID: <1380909598-6382-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of desc_to_gpio() relies on the chip pointer
to be set to a valid value in order to compute the GPIO number. This
was done in the hope that we can get rid of the gpio_desc global array,
but this is not happening anytime soon.

This patch reimplements desc_to_gpio() in a fashion similar to that of
gpio_to_desc(). As a result, desc_to_gpio(gpio_to_desc(gpio)) == gpio is
now always true. This allows to call desc_to_gpio() on non-initialized
descriptors as some error-handling code currently does.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reported-by: Dr. H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 86ef346..f330631 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -136,7 +136,7 @@ static struct gpio_desc *gpio_to_desc(unsigned gpio)
  */
 static int desc_to_gpio(const struct gpio_desc *desc)
 {
-	return desc->chip->base + gpio_chip_hwgpio(desc);
+	return desc - &gpio_desc[0];
 }
 
 
-- 
1.8.4

