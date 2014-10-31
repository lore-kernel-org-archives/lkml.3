Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbaJaLld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:41:33 -0400
Received: from mga03.intel.com ([134.134.136.65]:9873 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758711AbaJaLla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:41:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,294,1413270000"; 
   d="scan'208";a="628954305"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH] leds: leds-gpio: Convert gpio_blink_set() to use GPIO descriptors
Date: Fri, 31 Oct 2014 13:40:58 +0200
Message-Id: <1414755658-96293-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 21f2aae91e902aad ("leds: leds-gpio: Add support for GPIO
descriptors") already converted most of the driver to use GPIO descriptors.
What is still missing is the platform specific hook gpio_blink_set() and
board files which pass legacy GPIO numbers to this driver in platform data.

In this patch we handle the former and convert gpio_blink_set() to take
GPIO descriptor instead. In order to do this we convert the existing four
users to accept GPIO descriptor and translate it to legacy GPIO number in
the platform code. This effectively "pushes" legacy GPIO number usage from
the driver to platforms.

Also add comment to the remaining block describing that it is legacy code
path and we are getting rid of it eventually.

Suggested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Hi all,

This has been discussed in the following thread

http://marc.info/?l=devicetree&m=141468331302908&w=4

In brief, while making example driver changes for generic device property
accessors we converted these drivers from legacy GPIO numbers to GPIO
descriptors. We did this only partially leaving the legacy code path for
existing users (there are pretty many existing users for this).

It turned out that it is pretty simple to go bit further and convert
gpio_blink_set() to use GPIO descptors as well. This patch does just that.

I have not been able to test the ARM parts on a real hardware so they are
only compile tested.

This patch is on top of Rafael's linux-pm.git/device-properties branch [1]

[1] git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git

 arch/arm/mach-s3c24xx/h1940-bluetooth.c       |  4 ++--
 arch/arm/mach-s3c24xx/h1940.h                 |  4 +++-
 arch/arm/mach-s3c24xx/mach-h1940.c            |  3 ++-
 arch/arm/mach-s3c24xx/mach-rx1950.c           |  3 ++-
 arch/arm/plat-orion/gpio.c                    |  3 ++-
 arch/arm/plat-orion/include/plat/orion-gpio.h |  5 ++++-
 drivers/leds/leds-gpio.c                      | 31 +++++++++++----------------
 include/linux/leds.h                          |  2 +-
 8 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/h1940-bluetooth.c b/arch/arm/mach-s3c24xx/h1940-bluetooth.c
index b4d14b864367..9c8b1279a4ba 100644
--- a/arch/arm/mach-s3c24xx/h1940-bluetooth.c
+++ b/arch/arm/mach-s3c24xx/h1940-bluetooth.c
@@ -41,7 +41,7 @@ static void h1940bt_enable(int on)
 		mdelay(10);
 		gpio_set_value(S3C2410_GPH(1), 0);
 
-		h1940_led_blink_set(-EINVAL, GPIO_LED_BLINK, NULL, NULL);
+		h1940_led_blink_set(NULL, GPIO_LED_BLINK, NULL, NULL);
 	}
 	else {
 		gpio_set_value(S3C2410_GPH(1), 1);
@@ -50,7 +50,7 @@ static void h1940bt_enable(int on)
 		mdelay(10);
 		gpio_set_value(H1940_LATCH_BLUETOOTH_POWER, 0);
 
-		h1940_led_blink_set(-EINVAL, GPIO_LED_NO_BLINK_LOW, NULL, NULL);
+		h1940_led_blink_set(NULL, GPIO_LED_NO_BLINK_LOW, NULL, NULL);
 	}
 }
 
diff --git a/arch/arm/mach-s3c24xx/h1940.h b/arch/arm/mach-s3c24xx/h1940.h
index 2950cc466840..596d9f64c5b6 100644
--- a/arch/arm/mach-s3c24xx/h1940.h
+++ b/arch/arm/mach-s3c24xx/h1940.h
@@ -19,8 +19,10 @@
 #define H1940_SUSPEND_RESUMEAT		(0x30081000)
 #define H1940_SUSPEND_CHECK		(0x30080000)
 
+struct gpio_desc;
+
 extern void h1940_pm_return(void);
-extern int h1940_led_blink_set(unsigned gpio, int state,
+extern int h1940_led_blink_set(struct gpio_desc *desc, int state,
 			       unsigned long *delay_on,
 			       unsigned long *delay_off);
 
diff --git a/arch/arm/mach-s3c24xx/mach-h1940.c b/arch/arm/mach-s3c24xx/mach-h1940.c
index d35ddc1d9991..d40d4f5244c6 100644
--- a/arch/arm/mach-s3c24xx/mach-h1940.c
+++ b/arch/arm/mach-s3c24xx/mach-h1940.c
@@ -359,10 +359,11 @@ static struct platform_device h1940_battery = {
 
 static DEFINE_SPINLOCK(h1940_blink_spin);
 
-int h1940_led_blink_set(unsigned gpio, int state,
+int h1940_led_blink_set(struct gpio_desc *desc, int state,
 	unsigned long *delay_on, unsigned long *delay_off)
 {
 	int blink_gpio, check_gpio1, check_gpio2;
+	int gpio = desc ? desc_to_gpio(desc) : -EINVAL;
 
 	switch (gpio) {
 	case H1940_LATCH_LED_GREEN:
diff --git a/arch/arm/mach-s3c24xx/mach-rx1950.c b/arch/arm/mach-s3c24xx/mach-rx1950.c
index c3f2682d0c62..1d35ff375a01 100644
--- a/arch/arm/mach-s3c24xx/mach-rx1950.c
+++ b/arch/arm/mach-s3c24xx/mach-rx1950.c
@@ -250,9 +250,10 @@ static void rx1950_disable_charger(void)
 
 static DEFINE_SPINLOCK(rx1950_blink_spin);
 
-static int rx1950_led_blink_set(unsigned gpio, int state,
+static int rx1950_led_blink_set(struct gpio_desc *desc, int state,
 	unsigned long *delay_on, unsigned long *delay_off)
 {
+	int gpio = desc_to_gpio(desc);
 	int blink_gpio, check_gpio;
 
 	switch (gpio) {
diff --git a/arch/arm/plat-orion/gpio.c b/arch/arm/plat-orion/gpio.c
index b61a3bcc2fa8..b357053f40d9 100644
--- a/arch/arm/plat-orion/gpio.c
+++ b/arch/arm/plat-orion/gpio.c
@@ -306,9 +306,10 @@ EXPORT_SYMBOL(orion_gpio_set_blink);
 
 #define ORION_BLINK_HALF_PERIOD 100 /* ms */
 
-int orion_gpio_led_blink_set(unsigned gpio, int state,
+int orion_gpio_led_blink_set(struct gpio_desc *desc, int state,
 	unsigned long *delay_on, unsigned long *delay_off)
 {
+	unsigned gpio = desc_to_gpio(desc);
 
 	if (delay_on && delay_off && !*delay_on && !*delay_off)
 		*delay_on = *delay_off = ORION_BLINK_HALF_PERIOD;
diff --git a/arch/arm/plat-orion/include/plat/orion-gpio.h b/arch/arm/plat-orion/include/plat/orion-gpio.h
index e763988b04b9..e856b073a9c8 100644
--- a/arch/arm/plat-orion/include/plat/orion-gpio.h
+++ b/arch/arm/plat-orion/include/plat/orion-gpio.h
@@ -14,12 +14,15 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/irqdomain.h>
+
+struct gpio_desc;
+
 /*
  * Orion-specific GPIO API extensions.
  */
 void orion_gpio_set_unused(unsigned pin);
 void orion_gpio_set_blink(unsigned pin, int blink);
-int orion_gpio_led_blink_set(unsigned gpio, int state,
+int orion_gpio_led_blink_set(struct gpio_desc *desc, int state,
 	unsigned long *delay_on, unsigned long *delay_off);
 
 #define GPIO_INPUT_OK		(1 << 0)
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index edd370dbb22f..ba4698c32bb0 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -28,7 +28,7 @@ struct gpio_led_data {
 	u8 new_level;
 	u8 can_sleep;
 	u8 blinking;
-	int (*platform_gpio_blink_set)(unsigned gpio, int state,
+	int (*platform_gpio_blink_set)(struct gpio_desc *desc, int state,
 			unsigned long *delay_on, unsigned long *delay_off);
 };
 
@@ -38,13 +38,8 @@ static void gpio_led_work(struct work_struct *work)
 		container_of(work, struct gpio_led_data, work);
 
 	if (led_dat->blinking) {
-		int gpio = desc_to_gpio(led_dat->gpiod);
-		int level = led_dat->new_level;
-
-		if (gpiod_is_active_low(led_dat->gpiod))
-			level = !level;
-
-		led_dat->platform_gpio_blink_set(gpio, level, NULL, NULL);
+		led_dat->platform_gpio_blink_set(led_dat->gpiod,
+					led_dat->new_level, NULL, NULL);
 		led_dat->blinking = 0;
 	} else
 		gpiod_set_value_cansleep(led_dat->gpiod, led_dat->new_level);
@@ -71,13 +66,8 @@ static void gpio_led_set(struct led_classdev *led_cdev,
 		schedule_work(&led_dat->work);
 	} else {
 		if (led_dat->blinking) {
-			int gpio = desc_to_gpio(led_dat->gpiod);
-
-			if (gpiod_is_active_low(led_dat->gpiod))
-				level = !level;
-
-			led_dat->platform_gpio_blink_set(gpio, level, NULL,
-							 NULL);
+			led_dat->platform_gpio_blink_set(led_dat->gpiod, level,
+							 NULL, NULL);
 			led_dat->blinking = 0;
 		} else
 			gpiod_set_value(led_dat->gpiod, level);
@@ -89,20 +79,25 @@ static int gpio_blink_set(struct led_classdev *led_cdev,
 {
 	struct gpio_led_data *led_dat =
 		container_of(led_cdev, struct gpio_led_data, cdev);
-	int gpio = desc_to_gpio(led_dat->gpiod);
 
 	led_dat->blinking = 1;
-	return led_dat->platform_gpio_blink_set(gpio, GPIO_LED_BLINK,
+	return led_dat->platform_gpio_blink_set(led_dat->gpiod, GPIO_LED_BLINK,
 						delay_on, delay_off);
 }
 
 static int create_gpio_led(const struct gpio_led *template,
 	struct gpio_led_data *led_dat, struct device *parent,
-	int (*blink_set)(unsigned, int, unsigned long *, unsigned long *))
+	int (*blink_set)(struct gpio_desc *, int, unsigned long *,
+			 unsigned long *))
 {
 	int ret, state;
 
 	if (!template->gpiod) {
+		/*
+		 * This is the legacy code path for platform code that
+		 * still uses GPIO numbers. Ultimately we would like to get
+		 * rid of this block completely.
+		 */
 		unsigned long flags = 0;
 
 		/* skip leds that aren't available */
diff --git a/include/linux/leds.h b/include/linux/leds.h
index f3af5c4d9084..361101fef270 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -274,7 +274,7 @@ struct gpio_led_platform_data {
 #define GPIO_LED_NO_BLINK_LOW	0	/* No blink GPIO state low */
 #define GPIO_LED_NO_BLINK_HIGH	1	/* No blink GPIO state high */
 #define GPIO_LED_BLINK		2	/* Please, blink */
-	int		(*gpio_blink_set)(unsigned gpio, int state,
+	int		(*gpio_blink_set)(struct gpio_desc *desc, int state,
 					unsigned long *delay_on,
 					unsigned long *delay_off);
 };
-- 
2.1.1

