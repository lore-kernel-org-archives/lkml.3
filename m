Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935214Ab3BTEkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:40:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33365 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933599Ab3BTEk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:40:26 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] backlight: lp855x_bl: support new LP8557 device
Thread-Topic: [PATCH 2/3] backlight: lp855x_bl: support new LP8557 device
Thread-Index: Ac4PJF5ugARLeEliTmeyoKRw0r/4Gw==
Date: Wed, 20 Feb 2013 04:40:11 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F792735CD@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.62]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LP8557 is one of LP855x family device, but it has different register map
and initialization process.
To support this device, device specific configuration is done through the
lp855x_device_config structure.

Few register definitions are fixed for better readability.
  BRIGHTNESS_CTRL -> LP855X_BRIGHTNESS_CTRL
  DEVICE_CTRL     -> LP855X_DEVICE_CTRL
  EEPROM_START    -> LP855X_EEPROM_START
  EEPROM_END      -> LP855X_EEPROM_END
  EPROM_START     -> LP8556_EPROM_START
  EPROM_END       -> LP8556_EPROM_END

And LP8557 register definitions are added.
New register function, lp855x_update_bit() is added.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/backlight/lp855x-driver.txt |    4 +-
 drivers/video/backlight/Kconfig           |    2 +-
 drivers/video/backlight/lp855x_bl.c       |   87 ++++++++++++++++++++++++-----
 include/linux/platform_data/lp855x.h      |   19 +++++++
 4 files changed, 94 insertions(+), 18 deletions(-)

diff --git a/Documentation/backlight/lp855x-driver.txt b/Documentation/backlight/lp855x-driver.txt
index 1529394..18b06ca 100644
--- a/Documentation/backlight/lp855x-driver.txt
+++ b/Documentation/backlight/lp855x-driver.txt
@@ -4,7 +4,7 @@ Kernel driver lp855x
 Backlight driver for LP855x ICs
 
 Supported chips:
-	Texas Instruments LP8550, LP8551, LP8552, LP8553 and LP8556
+	Texas Instruments LP8550, LP8551, LP8552, LP8553, LP8556 and LP8557
 
 Author: Milo(Woogyom) Kim <milo.kim@ti.com>
 
@@ -24,7 +24,7 @@ Value : pwm based or register based
 
 2) chip_id
 The lp855x chip id.
-Value : lp8550/lp8551/lp8552/lp8553/lp8556
+Value : lp8550/lp8551/lp8552/lp8553/lp8556/lp8557
 
 Platform data for lp855x
 ------------------------
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 765a945..f24bc79 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -366,7 +366,7 @@ config BACKLIGHT_LP855X
 	tristate "Backlight driver for TI LP855X"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	help
-	  This supports TI LP8550, LP8551, LP8552, LP8553 and LP8556
+	  This supports TI LP8550, LP8551, LP8552, LP8553, LP8556 and LP8557
 	  backlight driver.
 
 config BACKLIGHT_OT200
diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 050cfbb..edd2041 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -17,13 +17,23 @@
 #include <linux/platform_data/lp855x.h>
 #include <linux/pwm.h>
 
-/* Registers */
-#define BRIGHTNESS_CTRL		0x00
-#define DEVICE_CTRL		0x01
-#define EEPROM_START		0xA0
-#define EEPROM_END		0xA7
-#define EPROM_START		0xA0
-#define EPROM_END		0xAF
+/* LP8550/1/2/3/6 Registers */
+#define LP855X_BRIGHTNESS_CTRL		0x00
+#define LP855X_DEVICE_CTRL		0x01
+#define LP855X_EEPROM_START		0xA0
+#define LP855X_EEPROM_END		0xA7
+#define LP8556_EPROM_START		0xA0
+#define LP8556_EPROM_END		0xAF
+
+/* LP8557 Registers */
+#define LP8557_BL_CMD			0x00
+#define LP8557_BL_MASK			0x01
+#define LP8557_BL_ON			0x01
+#define LP8557_BL_OFF			0x00
+#define LP8557_BRIGHTNESS_CTRL		0x04
+#define LP8557_CONFIG			0x10
+#define LP8557_EPROM_START		0x10
+#define LP8557_EPROM_END		0x1E
 
 #define BUF_SIZE		20
 #define DEFAULT_BL_NAME		"lcd-backlight"
@@ -75,6 +85,24 @@ static int lp855x_write_byte(struct lp855x *lp, u8 reg, u8 data)
 	return i2c_smbus_write_byte_data(lp->client, reg, data);
 }
 
+static int lp855x_update_bit(struct lp855x *lp, u8 reg, u8 mask, u8 data)
+{
+	int ret;
+	u8 tmp;
+
+	ret = i2c_smbus_read_byte_data(lp->client, reg);
+	if (ret < 0) {
+		dev_err(lp->dev, "failed to read 0x%.2x\n", reg);
+		return ret;
+	}
+
+	tmp = (u8)ret;
+	tmp &= ~mask;
+	tmp |= data & mask;
+
+	return lp855x_write_byte(lp, reg, tmp);
+}
+
 static bool lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
 {
 	u8 start, end;
@@ -84,12 +112,16 @@ static bool lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
 	case LP8551:
 	case LP8552:
 	case LP8553:
-		start = EEPROM_START;
-		end = EEPROM_END;
+		start = LP855X_EEPROM_START;
+		end = LP855X_EEPROM_END;
 		break;
 	case LP8556:
-		start = EPROM_START;
-		end = EPROM_END;
+		start = LP8556_EPROM_START;
+		end = LP8556_EPROM_END;
+		break;
+	case LP8557:
+		start = LP8557_EPROM_START;
+		end = LP8557_EPROM_END;
 		break;
 	default:
 		return false;
@@ -98,9 +130,30 @@ static bool lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
 	return (addr >= start && addr <= end);
 }
 
+static int lp8557_bl_off(struct lp855x *lp)
+{
+	/* BL_ON = 0 before updating EPROM settings */
+	return lp855x_update_bit(lp, LP8557_BL_CMD, LP8557_BL_MASK,
+				LP8557_BL_OFF);
+}
+
+static int lp8557_bl_on(struct lp855x *lp)
+{
+	/* BL_ON = 1 after updating EPROM settings */
+	return lp855x_update_bit(lp, LP8557_BL_CMD, LP8557_BL_MASK,
+				LP8557_BL_ON);
+}
+
 static struct lp855x_device_config lp855x_dev_cfg = {
-	.reg_brightness = BRIGHTNESS_CTRL,
-	.reg_devicectrl = DEVICE_CTRL,
+	.reg_brightness = LP855X_BRIGHTNESS_CTRL,
+	.reg_devicectrl = LP855X_DEVICE_CTRL,
+};
+
+static struct lp855x_device_config lp8557_dev_cfg = {
+	.reg_brightness = LP8557_BRIGHTNESS_CTRL,
+	.reg_devicectrl = LP8557_CONFIG,
+	.pre_init_device = lp8557_bl_off,
+	.post_init_device = lp8557_bl_on,
 };
 
 /*
@@ -123,6 +176,9 @@ static int lp855x_configure(struct lp855x *lp)
 	case LP8550 ... LP8556:
 		lp->cfg = &lp855x_dev_cfg;
 		break;
+	case LP8557:
+		lp->cfg = &lp8557_dev_cfg;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -210,7 +266,7 @@ static int lp855x_bl_update_status(struct backlight_device *bl)
 
 	} else if (mode == REGISTER_BASED) {
 		u8 val = bl->props.brightness;
-		lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
+		lp855x_write_byte(lp, lp->cfg->reg_brightness, val);
 	}
 
 	return 0;
@@ -224,7 +280,7 @@ static int lp855x_bl_get_brightness(struct backlight_device *bl)
 	if (mode == REGISTER_BASED) {
 		u8 val = 0;
 
-		lp855x_read_byte(lp, BRIGHTNESS_CTRL, &val);
+		lp855x_read_byte(lp, lp->cfg->reg_brightness, &val);
 		bl->props.brightness = val;
 	}
 
@@ -376,6 +432,7 @@ static const struct i2c_device_id lp855x_ids[] = {
 	{"lp8552", LP8552},
 	{"lp8553", LP8553},
 	{"lp8556", LP8556},
+	{"lp8557", LP8557},
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, lp855x_ids);
diff --git a/include/linux/platform_data/lp855x.h b/include/linux/platform_data/lp855x.h
index e81f62d..20ee8b2 100644
--- a/include/linux/platform_data/lp855x.h
+++ b/include/linux/platform_data/lp855x.h
@@ -49,12 +49,24 @@
 #define LP8556_FAST_CONFIG	BIT(7) /* use it if EPROMs should be maintained
 					  when exiting the low power mode */
 
+/* CONFIG register - LP8557 */
+#define LP8557_PWM_STANDBY	BIT(7)
+#define LP8557_PWM_FILTER	BIT(6)
+#define LP8557_RELOAD_EPROM	BIT(3)	/* use it if EPROMs should be reset
+					   when the backlight turns on */
+#define LP8557_OFF_OPENLEDS	BIT(2)
+#define LP8557_PWM_CONFIG	LP8557_PWM_ONLY
+#define LP8557_I2C_CONFIG	LP8557_I2C_ONLY
+#define LP8557_COMB1_CONFIG	LP8557_COMBINED1
+#define LP8557_COMB2_CONFIG	LP8557_COMBINED2
+
 enum lp855x_chip_id {
 	LP8550,
 	LP8551,
 	LP8552,
 	LP8553,
 	LP8556,
+	LP8557,
 };
 
 enum lp855x_brightness_ctrl_mode {
@@ -89,6 +101,13 @@ enum lp8556_brightness_source {
 	LP8556_COMBINED2,	/* pwm + i2c after the shaper block */
 };
 
+enum lp8557_brightness_source {
+	LP8557_PWM_ONLY,
+	LP8557_I2C_ONLY,
+	LP8557_COMBINED1,	/* pwm + i2c after the shaper block */
+	LP8557_COMBINED2,	/* pwm + i2c before the shaper block */
+};
+
 struct lp855x_rom_data {
 	u8 addr;
 	u8 val;
-- 
1.7.9.5


Best Regards,
Milo


