Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaBXQCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:02:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:31272 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbaBXQA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:00:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,535,1389772800"; 
   d="scan'208";a="487165106"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alexandre Courbot <gnurou@gmail.com>, Lan Tianyu <tianyu.lan@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/6] gpiolib: Allow GPIO chips to request their own GPIOs
Date: Mon, 24 Feb 2014 18:00:06 +0200
Message-Id: <1393257611-18031-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it is useful to allow GPIO chips themselves to request GPIOs they
own through gpiolib API. One usecase is ACPI ASL code that should be able
to toggle GPIOs through GPIO operation regions.

We can't really use gpio_request() and its counterparts because it will pin
the module to the kernel forever (as it calls module_get()). Instead we
provide a gpiolib internal functions gpiochip_request/free_own_desc() that
work the same as gpio_request() but don't manipulate module refrence count.

Since it's the GPIO chip driver who requests the GPIOs in the first place
we can be sure that it cannot be unloaded without the driver knowing about
that. Furthermore we only limit this functionality to be available only
inside gpiolib.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpiolib.c | 57 +++++++++++++++++++++++++++++++++++++++++++-------
 drivers/gpio/gpiolib.h |  3 +++
 2 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f60d74bc2fce..489a63524eb6 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1458,7 +1458,8 @@ EXPORT_SYMBOL_GPL(gpiochip_remove_pin_ranges);
  * on each other, and help provide better diagnostics in debugfs.
  * They're called even less than the "set direction" calls.
  */
-static int gpiod_request(struct gpio_desc *desc, const char *label)
+static int __gpiod_request(struct gpio_desc *desc, const char *label,
+			   bool module_refcount)
 {
 	struct gpio_chip	*chip;
 	int			status = -EPROBE_DEFER;
@@ -1475,8 +1476,10 @@ static int gpiod_request(struct gpio_desc *desc, const char *label)
 	if (chip == NULL)
 		goto done;
 
-	if (!try_module_get(chip->owner))
-		goto done;
+	if (module_refcount) {
+		if (!try_module_get(chip->owner))
+			goto done;
+	}
 
 	/* NOTE:  gpio_request() can be called in early boot,
 	 * before IRQs are enabled, for non-sleeping (SOC) GPIOs.
@@ -1487,7 +1490,8 @@ static int gpiod_request(struct gpio_desc *desc, const char *label)
 		status = 0;
 	} else {
 		status = -EBUSY;
-		module_put(chip->owner);
+		if (module_refcount)
+			module_put(chip->owner);
 		goto done;
 	}
 
@@ -1499,7 +1503,8 @@ static int gpiod_request(struct gpio_desc *desc, const char *label)
 
 		if (status < 0) {
 			desc_set_label(desc, NULL);
-			module_put(chip->owner);
+			if (module_refcount)
+				module_put(chip->owner);
 			clear_bit(FLAG_REQUESTED, &desc->flags);
 			goto done;
 		}
@@ -1517,13 +1522,18 @@ done:
 	return status;
 }
 
+static int gpiod_request(struct gpio_desc *desc, const char *label)
+{
+	return __gpiod_request(desc, label, true);
+}
+
 int gpio_request(unsigned gpio, const char *label)
 {
 	return gpiod_request(gpio_to_desc(gpio), label);
 }
 EXPORT_SYMBOL_GPL(gpio_request);
 
-static void gpiod_free(struct gpio_desc *desc)
+static void __gpiod_free(struct gpio_desc *desc, bool module_refcount)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
@@ -1548,7 +1558,8 @@ static void gpiod_free(struct gpio_desc *desc)
 			spin_lock_irqsave(&gpio_lock, flags);
 		}
 		desc_set_label(desc, NULL);
-		module_put(desc->chip->owner);
+		if (module_refcount)
+			module_put(desc->chip->owner);
 		clear_bit(FLAG_ACTIVE_LOW, &desc->flags);
 		clear_bit(FLAG_REQUESTED, &desc->flags);
 		clear_bit(FLAG_OPEN_DRAIN, &desc->flags);
@@ -1559,6 +1570,11 @@ static void gpiod_free(struct gpio_desc *desc)
 	spin_unlock_irqrestore(&gpio_lock, flags);
 }
 
+static void gpiod_free(struct gpio_desc *desc)
+{
+	__gpiod_free(desc, true);
+}
+
 void gpio_free(unsigned gpio)
 {
 	gpiod_free(gpio_to_desc(gpio));
@@ -1678,6 +1694,33 @@ const char *gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
 }
 EXPORT_SYMBOL_GPL(gpiochip_is_requested);
 
+/**
+ * gpiochip_request_own_desc - Allow GPIO chip to request its own descriptor
+ * @desc: GPIO descriptor to request
+ * @label: label for the GPIO
+ *
+ * Function allows GPIO chip drivers to request and use their own GPIO
+ * descriptors via gpiolib API. Difference to gpiod_request() is that this
+ * function will not increase reference count of the GPIO chip module. This
+ * allows the GPIO chip module to be unloaded as needed (we assume that the
+ * GPIO chip driver handles freeing the GPIOs it has requested).
+ */
+int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label)
+{
+	return __gpiod_request(desc, label, false);
+}
+
+/**
+ * gpiochip_free_own_desc - Free GPIO requested by the chip driver
+ * @desc: GPIO descriptor to free
+ *
+ * Function frees the given GPIO requested previously with
+ * gpiochip_request_own_desc().
+ */
+void gpiochip_free_own_desc(struct gpio_desc *desc)
+{
+	__gpiod_free(desc, false);
+}
 
 /* Drivers MUST set GPIO direction before making get/set calls.  In
  * some cases this is done in early boot, before IRQs are enabled.
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index 82be586c1f90..cf092941a9fd 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -43,4 +43,7 @@ acpi_get_gpiod_by_index(struct device *dev, int index,
 }
 #endif
 
+int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label);
+void gpiochip_free_own_desc(struct gpio_desc *desc);
+
 #endif /* GPIOLIB_H */
-- 
1.9.0.rc3

