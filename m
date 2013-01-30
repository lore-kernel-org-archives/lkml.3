Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3A3Kdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:33:33 -0500
Received: from service87.mimecast.com ([91.220.42.44]:36111 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab3A3Kdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:33:31 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] mfd: vexpress: Add pseudo-GPIO based LEDs
Date: Wed, 30 Jan 2013 10:33:16 +0000
Message-Id: <1359541996-18127-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.7.10.4
X-OriginalArrivalTime: 30 Jan 2013 10:33:28.0275 (UTC) FILETIME=[3DD94230:01CDFED5]
X-MC-Unique: 113013010332906401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r0UAXYx2014109

The LEDs on the Versatile Express motherboard are controlled
through simple memory-mapped register. This patch extends
the pseudo-GPIO controller definition for these lines and
creates generic "leds-gpio" device using them

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---

Hello Samuel,

Would you be so kind to take this patch in for 3.9? Or would
you prefer to get it in through arm-soc tree?

Thanks!

Pawel

 drivers/mfd/vexpress-sysreg.c |   73 +++++++++++++++++++++++++++++++----------
 include/linux/vexpress.h      |    8 +++++
 2 files changed, 63 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index 77048b1..51c3ca2 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -49,6 +49,8 @@
 #define SYS_ID_HBI_SHIFT	16
 #define SYS_PROCIDx_HBI_SHIFT	0
 
+#define SYS_LED_LED(n)		(1 << (n))
+
 #define SYS_MCI_CARDIN		(1 << 0)
 #define SYS_MCI_WPROT		(1 << 1)
 
@@ -348,22 +350,27 @@ void __init vexpress_sysreg_of_early_init(void)
 }
 
 
+#define VEXPRESS_SYSREG_GPIO(_name, _reg, _value) \
+	[VEXPRESS_GPIO_##_name] = { \
+		.reg = _reg, \
+		.value = _reg##_##_value, \
+	}
+
 static struct vexpress_sysreg_gpio {
 	unsigned long reg;
 	u32 value;
 } vexpress_sysreg_gpios[] = {
-	[VEXPRESS_GPIO_MMC_CARDIN] = {
-		.reg = SYS_MCI,
-		.value = SYS_MCI_CARDIN,
-	},
-	[VEXPRESS_GPIO_MMC_WPROT] = {
-		.reg = SYS_MCI,
-		.value = SYS_MCI_WPROT,
-	},
-	[VEXPRESS_GPIO_FLASH_WPn] = {
-		.reg = SYS_FLASH,
-		.value = SYS_FLASH_WPn,
-	},
+	VEXPRESS_SYSREG_GPIO(MMC_CARDIN,	SYS_MCI,	CARDIN),
+	VEXPRESS_SYSREG_GPIO(MMC_WPROT,		SYS_MCI,	WPROT),
+	VEXPRESS_SYSREG_GPIO(FLASH_WPn,		SYS_FLASH,	WPn),
+	VEXPRESS_SYSREG_GPIO(LED0,		SYS_LED,	LED(0)),
+	VEXPRESS_SYSREG_GPIO(LED1,		SYS_LED,	LED(1)),
+	VEXPRESS_SYSREG_GPIO(LED2,		SYS_LED,	LED(2)),
+	VEXPRESS_SYSREG_GPIO(LED3,		SYS_LED,	LED(3)),
+	VEXPRESS_SYSREG_GPIO(LED4,		SYS_LED,	LED(4)),
+	VEXPRESS_SYSREG_GPIO(LED5,		SYS_LED,	LED(5)),
+	VEXPRESS_SYSREG_GPIO(LED6,		SYS_LED,	LED(6)),
+	VEXPRESS_SYSREG_GPIO(LED7,		SYS_LED,	LED(7)),
 };
 
 static int vexpress_sysreg_gpio_direction_input(struct gpio_chip *chip,
@@ -372,12 +379,6 @@ static int vexpress_sysreg_gpio_direction_input(struct gpio_chip *chip,
 	return 0;
 }
 
-static int vexpress_sysreg_gpio_direction_output(struct gpio_chip *chip,
-						unsigned offset, int value)
-{
-	return 0;
-}
-
 static int vexpress_sysreg_gpio_get(struct gpio_chip *chip,
 				       unsigned offset)
 {
@@ -401,6 +402,14 @@ static void vexpress_sysreg_gpio_set(struct gpio_chip *chip,
 	writel(reg_value, vexpress_sysreg_base + gpio->reg);
 }
 
+static int vexpress_sysreg_gpio_direction_output(struct gpio_chip *chip,
+						unsigned offset, int value)
+{
+	vexpress_sysreg_gpio_set(chip, offset, value);
+
+	return 0;
+}
+
 static struct gpio_chip vexpress_sysreg_gpio_chip = {
 	.label = "vexpress-sysreg",
 	.direction_input = vexpress_sysreg_gpio_direction_input,
@@ -412,6 +421,30 @@ static struct gpio_chip vexpress_sysreg_gpio_chip = {
 };
 
 
+#define VEXPRESS_SYSREG_GREEN_LED(_name, _default_trigger, _gpio) \
+	{ \
+		.name = "v2m:green:"_name, \
+		.default_trigger = _default_trigger, \
+		.gpio = VEXPRESS_GPIO_##_gpio, \
+	}
+
+struct gpio_led vexpress_sysreg_leds[] = {
+	VEXPRESS_SYSREG_GREEN_LED("user1",	"heartbeat",	LED0),
+	VEXPRESS_SYSREG_GREEN_LED("user2",	"mmc0",		LED1),
+	VEXPRESS_SYSREG_GREEN_LED("user3",	"cpu0",		LED2),
+	VEXPRESS_SYSREG_GREEN_LED("user4",	"cpu1",		LED3),
+	VEXPRESS_SYSREG_GREEN_LED("user5",	"cpu2",		LED4),
+	VEXPRESS_SYSREG_GREEN_LED("user6",	"cpu3",		LED5),
+	VEXPRESS_SYSREG_GREEN_LED("user7",	"cpu4",		LED6),
+	VEXPRESS_SYSREG_GREEN_LED("user8",	"cpu5",		LED7),
+};
+
+struct gpio_led_platform_data vexpress_sysreg_leds_pdata = {
+	.num_leds = ARRAY_SIZE(vexpress_sysreg_leds),
+	.leds = vexpress_sysreg_leds,
+};
+
+
 static ssize_t vexpress_sysreg_sys_id_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -456,6 +489,10 @@ static int vexpress_sysreg_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	platform_device_register_data(vexpress_sysreg_dev, "leds-gpio",
+			PLATFORM_DEVID_AUTO, &vexpress_sysreg_leds_pdata,
+			sizeof(vexpress_sysreg_leds_pdata));
+
 	vexpress_sysreg_dev = &pdev->dev;
 
 	device_create_file(vexpress_sysreg_dev, &dev_attr_sys_id);
diff --git a/include/linux/vexpress.h b/include/linux/vexpress.h
index c52215f..7581874 100644
--- a/include/linux/vexpress.h
+++ b/include/linux/vexpress.h
@@ -27,6 +27,14 @@
 #define VEXPRESS_GPIO_MMC_CARDIN	0
 #define VEXPRESS_GPIO_MMC_WPROT		1
 #define VEXPRESS_GPIO_FLASH_WPn		2
+#define VEXPRESS_GPIO_LED0		3
+#define VEXPRESS_GPIO_LED1		4
+#define VEXPRESS_GPIO_LED2		5
+#define VEXPRESS_GPIO_LED3		6
+#define VEXPRESS_GPIO_LED4		7
+#define VEXPRESS_GPIO_LED5		8
+#define VEXPRESS_GPIO_LED6		9
+#define VEXPRESS_GPIO_LED7		10
 
 #define VEXPRESS_RES_FUNC(_site, _func)	\
 {					\
-- 
1.7.10.4


