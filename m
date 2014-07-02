Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaGBKHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:07:43 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:40920 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752051AbaGBKHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:07:40 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: lgirdwood@gmail.com, broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk,
        ian.molton@codethink.co.uk, ben.dooks@codethink.co.uk, heiko@sntech.de,
        rob.jones@codethink.co.uk
Subject: [PATCH V2 2/3] gpio: allow gpio array requests for managed devices
Date: Wed,  2 Jul 2014 11:05:50 +0100
Message-Id: <1404295551-13470-3-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404295551-13470-1-git-send-email-rob.jones@codethink.co.uk>
References: <1404295551-13470-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions devm_gpio_request_array() and devm_gpio_free_array()
which are exactly analogous to the equivalent non-managed device
functions gpio_request_array() and gpio_free_array(), which can be
found in the module gpiolib.c.

Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 drivers/gpio/devres.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpio.h  |    4 ++++
 2 files changed, 67 insertions(+)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 307464f..b97c34b 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -186,6 +186,69 @@ int devm_gpio_request_one(struct device *dev, unsigned gpio,
 EXPORT_SYMBOL(devm_gpio_request_one);
 
 /**
+ * devm_gpio_request_array - request multiple GPIOs in a single call
+ *			     for a managed device
+ * @dev:	device requesting the gpio
+ * @array:	array of the 'struct gpio'
+ * @num:	how many GPIOs in the array
+ *
+ * Except for the extra @dev argument, this function takes the
+ * same arguments and performs the same function as
+ * gpio_request().  GPIOs requested with this function will be
+ * automatically freed on driver detach.
+ *
+ * Note that if any gpio request returns an error, any gpios previously
+ * obtained are immediately freed and the error code is returned,
+ * meaning that the whole call failed and no gpios are obtained, no
+ * indication is provided as to which particular request failed.
+ *
+ * If GPIOs allocated with this function need to be freed separately,
+ * devm_gpio_free_array() or devm_gpio_free() must be used.
+ */
+int devm_gpio_request_array(struct device *dev,
+			    const struct gpio *array,
+			    size_t num)
+{
+	int i, err = 0;
+
+	for (i = 0; i < num; i++, array++) {
+		err = devm_gpio_request_one(dev,
+					    array->gpio,
+					    array->flags,
+					    array->label);
+		if (err) {
+			while (i--)
+				devm_gpio_free(dev, (--array)->gpio);
+			break;
+		}
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(devm_gpio_request_array);
+
+/**
+ * devm_gpio_free_array - release multiple GPIOs in a single call
+ *			  for a managed device
+ * @dev:	device requesting the gpio
+ * @array:	array of the 'struct gpio'
+ * @num:	how many GPIOs in the array
+ *
+ * Except for the extra @dev argument, this function takes the
+ * same arguments and performs the same function as gpio_free_array().
+ * This function instead of gpio_free_array() should be used to
+ * manually free GPIOs allocated with devm_gpio_request().
+ */
+void devm_gpio_free_array(struct device *dev,
+			  const struct gpio *array,
+			  size_t num)
+{
+	while (num--)
+		devm_gpio_free(dev, (array++)->gpio);
+}
+EXPORT_SYMBOL(devm_gpio_free_array);
+
+/**
  *      devm_gpio_free - free a GPIO
  *      @dev: device to free GPIO for
  *      @gpio: GPIO to free
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 85aa5d0..12d5648 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -84,6 +84,10 @@ struct device;
 int devm_gpio_request(struct device *dev, unsigned gpio, const char *label);
 int devm_gpio_request_one(struct device *dev, unsigned gpio,
 			  unsigned long flags, const char *label);
+int devm_gpio_request_array(struct device *dev, const struct gpio *array,
+			    size_t num);
+void devm_gpio_free_array(struct device *dev, const struct gpio *array,
+			 size_t num);
 void devm_gpio_free(struct device *dev, unsigned int gpio);
 
 #else /* ! CONFIG_GPIOLIB */
-- 
1.7.10.4

