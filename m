Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3LFCHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:07:13 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5696 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3LFCHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:07:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Dec 2013 18:04:04 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpiolib: return -ENOENT when no GPIO mapping exists
Date: Fri, 6 Dec 2013 11:06:56 +0900
Message-ID: <1386295616-14192-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices drivers make use of optional GPIO parameters. For such
drivers, it is important to discriminate between the case where no
GPIO mapping has been defined for the function they are requesting, and
the case where a mapping exists but an error occured while resolving it
or when acquiring the GPIO.

This patch changes the family of gpiod_get() functions such that they
will return -ENOENT if and only if no GPIO mapping is defined for the
requested function. Other error codes are used when an actual error
occured during the GPIO resolution.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
I think this change should be merged early as not having it may prevent
some users to switch to gpiod. I stumbled upon this issue while
considering porting a simple driver (pwm_bl) that has an optional GPIO
parameter.

Mika, Andy: if Linus agrees with this change, could you take care of
having -ENOENT returned as well for the ACPI and SFI GPIOs lookup?
My understanding of ACPI was not sufficient to allow me to do it myself.
SFI OTOH should be trivial as it is a simple table.

 Documentation/gpio/consumer.txt |  6 +++++-
 drivers/gpio/gpiolib.c          | 31 ++++++++++++++++---------------
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/Documentation/gpio/consumer.txt b/Documentation/gpio/consumer.txt
index 07c74a3765a0..e42f77d8d4ca 100644
--- a/Documentation/gpio/consumer.txt
+++ b/Documentation/gpio/consumer.txt
@@ -38,7 +38,11 @@ device that displays digits), an additional index argument can be specified:
 					  const char *con_id, unsigned int idx)
 
 Both functions return either a valid GPIO descriptor, or an error code checkable
-with IS_ERR(). They will never return a NULL pointer.
+with IS_ERR() (they will never return a NULL pointer). -ENOENT will be returned
+if and only if no GPIO has been assigned to the device/function/index triplet,
+other error codes are used for cases where a GPIO has been assigned but an error
+occured while trying to acquire it. This is useful to discriminate between mere
+errors and an absence of GPIO for optional GPIO parameters.
 
 Device-managed variants of these functions are also defined:
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 5fad38fcd701..e96d4a90c0c3 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2358,7 +2358,7 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
 				    unsigned int idx,
 				    enum gpio_lookup_flags *flags)
 {
-	struct gpio_desc *desc = ERR_PTR(-ENODEV);
+	struct gpio_desc *desc = ERR_PTR(-ENOENT);
 	struct gpiod_lookup_table *table;
 	struct gpiod_lookup *p;
 
@@ -2380,19 +2380,21 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
 		chip = find_chip_by_name(p->chip_label);
 
 		if (!chip) {
-			dev_warn(dev, "cannot find GPIO chip %s\n",
-				 p->chip_label);
-			continue;
+			dev_err(dev, "cannot find GPIO chip %s\n",
+				p->chip_label);
+			return ERR_PTR(-ENODEV);
 		}
 
 		if (chip->ngpio <= p->chip_hwnum) {
-			dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
-				 chip->label, chip->ngpio);
-			continue;
+			dev_err(dev, "requested GPIO %d but chip %s has %d\n",
+				idx, chip->label, chip->ngpio);
+			return ERR_PTR(-EINVAL);
 		}
 
 		desc = gpiochip_offset_to_desc(chip, p->chip_hwnum);
 		*flags = p->flags;
+
+		return desc;
 	}
 
 	return desc;
@@ -2404,7 +2406,8 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
  * @con_id:	function within the GPIO consumer
  *
  * Return the GPIO descriptor corresponding to the function con_id of device
- * dev, or an IS_ERR() condition if an error occured.
+ * dev, -ENOENT if no GPIO has been assigned to the requested function, or
+ * another IS_ERR() code if an error occured while trying to acquire the GPIO.
  */
 struct gpio_desc *__must_check gpiod_get(struct device *dev, const char *con_id)
 {
@@ -2421,7 +2424,9 @@ EXPORT_SYMBOL_GPL(gpiod_get);
  * This variant of gpiod_get() allows to access GPIOs other than the first
  * defined one for functions that define several GPIOs.
  *
- * Return a valid GPIO descriptor, or an IS_ERR() condition in case of error.
+ * Return a valid GPIO descriptor, -ENOENT if no GPIO has been assigned to the
+ * requested function and/or index, or another IS_ERR() code if an error
+ * occured while trying to acquire the GPIO.
  */
 struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 					       const char *con_id,
@@ -2446,13 +2451,9 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 	 * Either we are not using DT or ACPI, or their lookup did not return
 	 * a result. In that case, use platform lookup as a fallback.
 	 */
-	if (!desc || IS_ERR(desc)) {
-		struct gpio_desc *pdesc;
+	if (!desc || desc == ERR_PTR(-ENOENT)) {
 		dev_dbg(dev, "using lookup tables for GPIO lookup");
-		pdesc = gpiod_find(dev, con_id, idx, &flags);
-		/* If used as fallback, do not replace the previous error */
-		if (!IS_ERR(pdesc) || !desc)
-			desc = pdesc;
+		desc = gpiod_find(dev, con_id, idx, &flags);
 	}
 
 	if (IS_ERR(desc)) {
-- 
1.8.4.2

