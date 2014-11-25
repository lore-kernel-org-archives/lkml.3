Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaKYIQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:16:40 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6621 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaKYIQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:16:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 25 Nov 2014 00:15:27 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2] gpio: remove const modifier from gpiod_get_direction()
Date: Tue, 25 Nov 2014 17:16:31 +0900
Message-ID: <1416903391-12693-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <5474391F.6030908@nvidia.com>
References: <5474391F.6030908@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although gpiod_get_direction() can be considered side-effect free for
consumers, its internals involve setting or clearing bits in the
affected GPIO descriptor, for which we need to force-cast the const
descriptor variable to non-const. This could lead to incorrect behavior
if the compiler decides to optimize here, so remove this const
attribute. The intent is to make gpiod_get_direction() private anyway,
so it does not really matter.

Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Changes since v1:
- Fixed poor grammar in commit log
- Added Uwe's Ack

 drivers/gpio/gpiolib-sysfs.c  | 2 +-
 drivers/gpio/gpiolib.c        | 8 +++-----
 include/linux/gpio/consumer.h | 2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index 781fbed00fc3..2ac1800b58bb 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -41,7 +41,7 @@ static DEFINE_MUTEX(sysfs_lock);
 static ssize_t gpio_direction_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
 	ssize_t			status;
 
 	mutex_lock(&sysfs_lock);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 5619922ebf44..0b271ef87c09 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -148,7 +148,7 @@ static int gpiochip_find_base(int ngpio)
  *
  * This function may sleep if gpiod_cansleep() is true.
  */
-int gpiod_get_direction(const struct gpio_desc *desc)
+int gpiod_get_direction(struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	unsigned		offset;
@@ -164,13 +164,11 @@ int gpiod_get_direction(const struct gpio_desc *desc)
 	if (status > 0) {
 		/* GPIOF_DIR_IN, or other positive */
 		status = 1;
-		/* FLAG_IS_OUT is just a cache of the result of get_direction(),
-		 * so it does not affect constness per se */
-		clear_bit(FLAG_IS_OUT, &((struct gpio_desc *)desc)->flags);
+		clear_bit(FLAG_IS_OUT, &desc->flags);
 	}
 	if (status == 0) {
 		/* GPIOF_DIR_OUT */
-		set_bit(FLAG_IS_OUT, &((struct gpio_desc *)desc)->flags);
+		set_bit(FLAG_IS_OUT, &desc->flags);
 	}
 	return status;
 }
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 83c0a61c605d..d54d158ca327 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -66,7 +66,7 @@ __devm_gpiod_get_index_optional(struct device *dev, const char *con_id,
 			      unsigned int index, enum gpiod_flags flags);
 void devm_gpiod_put(struct device *dev, struct gpio_desc *desc);
 
-int gpiod_get_direction(const struct gpio_desc *desc);
+int gpiod_get_direction(struct gpio_desc *desc);
 int gpiod_direction_input(struct gpio_desc *desc);
 int gpiod_direction_output(struct gpio_desc *desc, int value);
 int gpiod_direction_output_raw(struct gpio_desc *desc, int value);
-- 
2.1.3

