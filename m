Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaCKGwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:52:16 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12073 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaCKGwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:52:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 10 Mar 2014 23:48:55 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2] gpio: clamp returned values to the boolean range
Date: Tue, 11 Mar 2014 15:52:09 +0900
Message-ID: <1394520729-1587-1-git-send-email-acourbot@nvidia.com>
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
things with it as well.

Another way to fix this would be to change the prototypes of the driver
interface to use bool directly, but this would require a huge
cross-systems patch so this simpler solution is preferred.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
Changes since v1:
- Change local variable type to bool as well, use boolean values in
  code
- Also change prototype of open drain/open source setting functions
  since they are only called from _gpiod_set_raw_value()

This probably calls for a larger booleanization of gpiolib, but let's
keep that for a latter change - right now we need to address the issue
of non-boolean values returned by drivers.

 drivers/gpio/gpiolib.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 9cd7082cca08..83f60f47c95e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1958,15 +1958,15 @@ EXPORT_SYMBOL_GPL(gpiod_is_active_low);
  * that the GPIO was actually requested.
  */
 
-static int _gpiod_get_raw_value(const struct gpio_desc *desc)
+static bool _gpiod_get_raw_value(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
-	int value;
+	bool value;
 	int offset;
 
 	chip = desc->chip;
 	offset = gpio_chip_hwgpio(desc);
-	value = chip->get ? chip->get(chip, offset) : 0;
+	value = chip->get ? chip->get(chip, offset) : false;
 	trace_gpio_value(desc_to_gpio(desc), 1, value);
 	return value;
 }
@@ -2022,7 +2022,7 @@ EXPORT_SYMBOL_GPL(gpiod_get_value);
  * @desc: gpio descriptor whose state need to be set.
  * @value: Non-zero for setting it HIGH otherise it will set to LOW.
  */
-static void _gpio_set_open_drain_value(struct gpio_desc *desc, int value)
+static void _gpio_set_open_drain_value(struct gpio_desc *desc, bool value)
 {
 	int err = 0;
 	struct gpio_chip *chip = desc->chip;
@@ -2049,7 +2049,7 @@ static void _gpio_set_open_drain_value(struct gpio_desc *desc, int value)
  * @desc: gpio descriptor whose state need to be set.
  * @value: Non-zero for setting it HIGH otherise it will set to LOW.
  */
-static void _gpio_set_open_source_value(struct gpio_desc *desc, int value)
+static void _gpio_set_open_source_value(struct gpio_desc *desc, bool value)
 {
 	int err = 0;
 	struct gpio_chip *chip = desc->chip;
@@ -2071,7 +2071,7 @@ static void _gpio_set_open_source_value(struct gpio_desc *desc, int value)
 			  __func__, err);
 }
 
-static void _gpiod_set_raw_value(struct gpio_desc *desc, int value)
+static void _gpiod_set_raw_value(struct gpio_desc *desc, bool value)
 {
 	struct gpio_chip	*chip;
 
-- 
1.9.0

