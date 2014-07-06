Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaGFRr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:47:58 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:43600 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaGFRr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:47:56 -0400
Date: Sun, 6 Jul 2014 23:17:46 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>
Cc: julia.lawall@lip6.fr
Subject: [PATCH 1/5] gpiolib: devres: Introduce the function
 devm_request_gpio_array
Message-ID: <1a1752ce7455bac8f2505a9790da891a830699f5.1404665589.git.himangi774@gmail.com>
References: <cover.1404665589.git.himangi774@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1404665589.git.himangi774@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the function devm_request_gpio_array that
allocates multiple GPIOs in a single call in a managed manner. The
function is also included in the documentation and a declaration is
added in include/linux/gpio.h.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
 Documentation/driver-model/devres.txt |  1 +
 drivers/gpio/devres.c                 | 21 +++++++++++++++++++++
 include/linux/gpio.h                  |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 9e2098e..756f6cf 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -337,6 +337,7 @@ GPIO
   devm_gpiod_put()
   devm_gpio_request()
   devm_gpio_request_one()
+  devm_gpio_request_array()
   devm_gpio_free()
 
 SND
diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 65978cf..adae7fa 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -229,6 +229,27 @@ int devm_gpio_request_one(struct device *dev, unsigned gpio,
 EXPORT_SYMBOL(devm_gpio_request_one);
 
 /**
+ *	devm_gpio_request_array - request multiple GPIOs in a single call
+ *	@dev:   device to request for
+ *	@array:	array of the 'struct gpio'
+ *	@num:	how many GPIOs in the array
+ */
+int devm_gpio_request_array(struct device *dev, const struct gpio *array,
+			    size_t num)
+{
+	int i, err;
+
+	for (i = 0; i < num; i++, array++) {
+		err = devm_gpio_request_one(dev, array->gpio, array->flags,
+					    array->label);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_gpio_request_array);
+
+/**
  *      devm_gpio_free - free a GPIO
  *      @dev: device to free GPIO for
  *      @gpio: GPIO to free
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 85aa5d0..c85f243 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -84,6 +84,8 @@ struct device;
 int devm_gpio_request(struct device *dev, unsigned gpio, const char *label);
 int devm_gpio_request_one(struct device *dev, unsigned gpio,
 			  unsigned long flags, const char *label);
+int devm_gpio_request_array(struct device *dev, const struct gpio *array,
+			    size_t num);
 void devm_gpio_free(struct device *dev, unsigned int gpio);
 
 #else /* ! CONFIG_GPIOLIB */
-- 
1.9.1

