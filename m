Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaBZBlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:41:21 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6436 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaBZBlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:41:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 25 Feb 2014 17:37:39 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpio: clamp returned values to the boolean range
Date: Wed, 26 Feb 2014 10:40:00 +0900
Message-ID: <1393378800-7220-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing prevents GPIO drivers from returning values outside the
boolean range, and as it turns out a few drivers are actually doing so.
These values were passed as-is to unsuspecting consumers and created
confusion.

This patch makes the internal _gpiod_get_raw_value() function return a
bool, effectively clamping the GPIO value to the boolean range no
matter what the driver does.

While we are at it, we also change the value parameter of
_gpiod_set_raw_value() to bool type before drivers start doing funny
things with non-boolean values.

Another way to fix this would be to change the prototypes of the driver
interface to use bool directly, but this would require a huge
cross-systems patch so this simpler solution is preferred.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
This issue was discussed some time ago already
(https://www.mail-archive.com/linux-gpio@vger.kernel.org/msg02019.html),
here is finally the fix for it. Not exactly what we planned but who would
take a hundreds-lines change when a two-liner does the same?

 drivers/gpio/gpiolib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 50c4922fe53a..45cefccbf4bf 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1928,7 +1928,7 @@ EXPORT_SYMBOL_GPL(gpiod_is_active_low);
  * that the GPIO was actually requested.
  */
 
-static int _gpiod_get_raw_value(const struct gpio_desc *desc)
+static bool _gpiod_get_raw_value(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	int value;
@@ -2041,7 +2041,7 @@ static void _gpio_set_open_source_value(struct gpio_desc *desc, int value)
 			  __func__, err);
 }
 
-static void _gpiod_set_raw_value(struct gpio_desc *desc, int value)
+static void _gpiod_set_raw_value(struct gpio_desc *desc, bool value)
 {
 	struct gpio_chip	*chip;
 
-- 
1.9.0

