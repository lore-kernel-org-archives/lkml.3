Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3BSFK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:10:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56478 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab3BSFKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:10:21 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] leds: add new LP5562 LED driver
Thread-Topic: [PATCH 1/2] leds: add new LP5562 LED driver
Thread-Index: Ac4OX2Yv741ZKDVwRS2bm8JjE2iaBQ==
Date: Tue, 19 Feb 2013 05:10:14 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F79272C46@DQHE02.ent.ti.com>
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

LP5562 can drive up to 4 channels, RGB and White.
LEDs can be controlled directly via the led class control interface.

 LP55xx common driver
  LP5562 is one of LP55xx family device, so LP55xx common code are used.
  On the other hand, chip specific configuration is defined in the structure
  'lp55xx_device_config'

 LED pattern data
  LP5562 has also internal program memory which is used for running various LED
  patterns. LP5562 driver supports the firmware interface and the predefined
  pattern data as well.

 LP5562 device attributes: 'led_pattern' and 'engine_mux'
  A 'led_pattern' is an index code which runs the predefined pattern data.
  And 'engine_mux' is updated with the firmware interface is activated.
  Detailed description has been updated in the documentation files,
  'leds-lp55xx.txt' and 'leds-lp5562.txt'.

 Changes on the header file
  LP5562 configurable definitions are added.
  Pattern RGB data is fixed as constant value.
  (No side effect on other devices, LP5521 or LP5523.)

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/leds/00-INDEX               |    2 +
 Documentation/leds/leds-lp5562.txt        |  135 +++++++
 Documentation/leds/leds-lp55xx.txt        |   46 ++-
 drivers/leds/Kconfig                      |   14 +-
 drivers/leds/Makefile                     |    1 +
 drivers/leds/leds-lp5562.c                |  594 +++++++++++++++++++++++++++++
 include/linux/platform_data/leds-lp55xx.h |   13 +-
 7 files changed, 799 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/leds/leds-lp5562.txt
 create mode 100644 drivers/leds/leds-lp5562.c

diff --git a/Documentation/leds/00-INDEX b/Documentation/leds/00-INDEX
index 5246090..1ecd159 100644
--- a/Documentation/leds/00-INDEX
+++ b/Documentation/leds/00-INDEX
@@ -6,6 +6,8 @@ leds-lp5521.txt
 	- notes on how to use the leds-lp5521 driver.
 leds-lp5523.txt
 	- notes on how to use the leds-lp5523 driver.
+leds-lp5562.txt
+	- notes on how to use the leds-lp5562 driver.
 leds-lp55xx.txt
 	- description about lp55xx common driver.
 leds-lm3556.txt
diff --git a/Documentation/leds/leds-lp5562.txt b/Documentation/leds/leds-lp5562.txt
new file mode 100644
index 0000000..9606100
--- /dev/null
+++ b/Documentation/leds/leds-lp5562.txt
@@ -0,0 +1,135 @@
+Kernel driver for LP5562
+========================
+
+* TI LP5562 LED Driver
+
+Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+
+Description
+
+  LP5562 can drive up to 4 channels. R/G/B and White.
+  LEDs can be controlled directly via the led class control interface.
+
+  All four channels can be also controlled using the engine micro programs.
+  LP5562 has the internal program memory for running various LED patterns.
+  For the details, please refer to 'firmware' section in leds-lp55xx.txt
+
+Device attribute: engine_mux
+
+  3 Engines are allocated in LP5562, but the number of channel is 4.
+  Therefore each channel should be mapped to the engine number.
+  Value : RGB or W
+
+  This attribute is used for programming LED data with the firmware interface.
+  Unlike the LP5521/LP5523/55231, LP5562 has unique feature for the engine mux,
+  so additional sysfs is required.
+
+  LED Map
+  Red   ... Engine 1 (fixed)
+  Green ... Engine 2 (fixed)
+  Blue  ... Engine 3 (fixed)
+  White ... Engine 1 or 2 or 3 (selective)
+
+How to load the program data using engine_mux
+
+  Before loading the LP5562 program data, engine_mux should be written between
+  the engine selection and loading the firmware.
+  Engine mux has two different mode, RGB and W.
+  RGB is used for loading RGB program data, W is used for W program data.
+
+  For example, run blinking green channel pattern,
+  echo 2 > /sys/bus/i2c/devices/xxxx/select_engine     # 2 is for green channel
+  echo "RGB" > /sys/bus/i2c/devices/xxxx/engine_mux    # engine mux for RGB
+  echo 1 > /sys/class/firmware/lp5562/loading
+  echo "4000600040FF6000" > /sys/class/firmware/lp5562/data
+  echo 0 > /sys/class/firmware/lp5562/loading
+  echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
+
+  To run a blinking white pattern,
+  echo 1 or 2 or 3 > /sys/bus/i2c/devices/xxxx/select_engine
+  echo "W" > /sys/bus/i2c/devices/xxxx/engine_mux
+  echo 1 > /sys/class/firmware/lp5562/loading
+  echo "4000600040FF6000" > /sys/class/firmware/lp5562/data
+  echo 0 > /sys/class/firmware/lp5562/loading
+  echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
+
+How to load the predefined patterns
+
+  Please refer to 'leds-lp55xx.txt"
+
+Setting Current of Each Channel
+
+  Like LP5521 and LP5523/55231, LP5562 provides LED current settings.
+  The 'led_current' and 'max_current' are used.
+
+(Example of Platform data)
+
+To configure the platform specific data, lp55xx_platform_data structure is used.
+
+static struct lp55xx_led_config lp5562_led_config[] = {
+	{
+		.name 		= "R",
+		.chan_nr	= 0,
+		.led_current	= 20,
+		.max_current	= 40,
+	},
+	{
+		.name 		= "G",
+		.chan_nr	= 1,
+		.led_current	= 20,
+		.max_current	= 40,
+	},
+	{
+		.name 		= "B",
+		.chan_nr	= 2,
+		.led_current	= 20,
+		.max_current	= 40,
+	},
+	{
+		.name 		= "W",
+		.chan_nr	= 3,
+		.led_current	= 20,
+		.max_current	= 40,
+	},
+};
+
+static int lp5562_setup(void)
+{
+	/* setup HW resources */
+}
+
+static void lp5562_release(void)
+{
+	/* Release HW resources */
+}
+
+static void lp5562_enable(bool state)
+{
+	/* Control of chip enable signal */
+}
+
+static struct lp55xx_platform_data lp5562_platform_data = {
+        .led_config     = lp5562_led_config,
+        .num_channels   = ARRAY_SIZE(lp5562_led_config),
+        .setup_resources   = lp5562_setup,
+        .release_resources = lp5562_release,
+        .enable            = lp5562_enable,
+};
+
+If the current is set to 0 in the platform data, that channel is
+disabled and it is not visible in the sysfs.
+
+The 'update_config' : CONFIG register (ADDR 08h)
+This value is platform-specific data.
+If update_config is not defined, the CONFIG register is set with
+'LP5562_PWRSAVE_EN | LP5562_CLK_AUTO'.
+(Enable auto-powersave, set automatic clock source selection)
+
+#define LP5562_CONFIGS	(LP5562_PWM_HF | LP5562_PWRSAVE_EN | \
+			 LP5562_CLK_SRC_EXT)
+
+static struct lp55xx_platform_data lp5562_pdata = {
+	.led_config = lp5562_led_config,
+	.num_channels = ARRAY_SIZE(lp5562_led_config),
+	.update_config = LP5562_CONFIGS,
+};
diff --git a/Documentation/leds/leds-lp55xx.txt b/Documentation/leds/leds-lp55xx.txt
index ced4186..eec8fa2 100644
--- a/Documentation/leds/leds-lp55xx.txt
+++ b/Documentation/leds/leds-lp55xx.txt
@@ -5,7 +5,7 @@ Authors: Milo(Woogyom) Kim <milo.kim@ti.com>
 
 Description
 -----------
-LP5521, LP5523/55231 have common features as below.
+LP5521, LP5523/55231 and LP5562 have common features as below.
 
   Register access via the I2C
   Device initialization/deinitialization
@@ -116,3 +116,47 @@ To support this, 'run_engine' and 'firmware_cb' are configurable in each driver.
 run_engine  : Control the selected engine
 firmware_cb : The callback function after loading the firmware is done.
               Chip specific commands for loading and updating program memory.
+
+( Predefined pattern data )
+
+Without the firmware interface, LP55xx driver provides another method for
+loading a LED pattern. That is 'predefined' pattern.
+A predefined pattern is defined in the platform data and load it(or them)
+via the sysfs if needed.
+To use the predefined pattern concept, 'patterns' and 'num_patterns' should be
+configured.
+
+  Example of predefined pattern data:
+
+  /* mode_1: blinking data */
+  static const u8 mode_1[] = {
+		0x40, 0x00, 0x60, 0x00, 0x40, 0xFF, 0x60, 0x00,
+		};
+
+  /* mode_2: always on */
+  static const u8 mode_2[] = { 0x40, 0xFF, };
+
+  struct lp55xx_predef_pattern board_led_patterns[] = {
+	{
+		.r = mode_1,
+		.size_r = ARRAY_SIZE(mode_1),
+	},
+	{
+		.b = mode_2,
+		.size_b = ARRAY_SIZE(mode_2),
+	},
+  }
+
+  struct lp55xx_platform_data lp5562_pdata = {
+  ...
+	.patterns      = board_led_patterns,
+	.num_patterns  = ARRAY_SIZE(board_led_patterns),
+  };
+
+Then, mode_1 and mode_2 can be run via through the sysfs.
+
+  echo 1 > /sys/bus/i2c/devices/xxxx/led_pattern    # red blinking LED pattern
+  echo 2 > /sys/bus/i2c/devices/xxxx/led_pattern    # blue LED always on
+
+To stop running pattern,
+  echo 0 > /sys/bus/i2c/devices/xxxx/led_pattern
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 78b354f..913326f 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -194,8 +194,8 @@ config LEDS_LP3944
 	  module will be called leds-lp3944.
 
 config LEDS_LP55XX_COMMON
-	tristate "Common Driver for TI/National LP5521 and LP5523/55231"
-	depends on LEDS_LP5521 || LEDS_LP5523
+	tristate "Common Driver for TI/National LP5521, LP5523/55231 and LP5562"
+	depends on LEDS_LP5521 || LEDS_LP5523 || LEDS_LP5562
 	select FW_LOADER
 	help
 	  This option supports common operations for LP5521 and LP5523/55231
@@ -222,6 +222,16 @@ config LEDS_LP5523
 	  Driver provides direct control via LED class and interface for
 	  programming the engines.
 
+config LEDS_LP5562
+	tristate "LED Support for TI LP5562 LED driver chip"
+	depends on LEDS_CLASS && I2C
+	select LEDS_LP55XX_COMMON
+	help
+	  If you say yes here you get support for TI LP5562 LED driver.
+	  It is 4 channels chip with programmable engines.
+	  Driver provides direct control via LED class and interface for
+	  programming the engines.
+
 config LEDS_LP8788
 	tristate "LED support for the TI LP8788 PMIC"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 215e7e3..ab8f5c5 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_LEDS_LP3944)		+= leds-lp3944.o
 obj-$(CONFIG_LEDS_LP55XX_COMMON)	+= leds-lp55xx-common.o
 obj-$(CONFIG_LEDS_LP5521)		+= leds-lp5521.o
 obj-$(CONFIG_LEDS_LP5523)		+= leds-lp5523.o
+obj-$(CONFIG_LEDS_LP5562)		+= leds-lp5562.o
 obj-$(CONFIG_LEDS_LP8788)		+= leds-lp8788.o
 obj-$(CONFIG_LEDS_TCA6507)		+= leds-tca6507.o
 obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
diff --git a/drivers/leds/leds-lp5562.c b/drivers/leds/leds-lp5562.c
new file mode 100644
index 0000000..9974033
--- /dev/null
+++ b/drivers/leds/leds-lp5562.c
@@ -0,0 +1,594 @@
+/*
+ * LP5562 LED driver
+ *
+ * Copyright (C) 2013 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_data/leds-lp55xx.h>
+#include <linux/slab.h>
+
+#include "leds-lp55xx-common.h"
+
+#define LP5562_PROGRAM_LENGTH		32
+#define LP5562_MAX_LEDS			4
+
+/* ENABLE Register 00h */
+#define LP5562_REG_ENABLE		0x00
+#define LP5562_EXEC_ENG1_M		0x30
+#define LP5562_EXEC_ENG2_M		0x0C
+#define LP5562_EXEC_ENG3_M		0x03
+#define LP5562_EXEC_M			0x3F
+#define LP5562_MASTER_ENABLE		0x40	/* Chip master enable */
+#define LP5562_LOGARITHMIC_PWM		0x80	/* Logarithmic PWM adjustment */
+#define LP5562_EXEC_RUN			0x2A
+#define LP5562_ENABLE_DEFAULT	\
+	(LP5562_MASTER_ENABLE | LP5562_LOGARITHMIC_PWM)
+#define LP5562_ENABLE_RUN_PROGRAM	\
+	(LP5562_ENABLE_DEFAULT | LP5562_EXEC_RUN)
+
+/* OPMODE Register 01h */
+#define LP5562_REG_OP_MODE		0x01
+#define LP5562_MODE_ENG1_M		0x30
+#define LP5562_MODE_ENG2_M		0x0C
+#define LP5562_MODE_ENG3_M		0x03
+#define LP5562_LOAD_ENG1		0x10
+#define LP5562_LOAD_ENG2		0x04
+#define LP5562_LOAD_ENG3		0x01
+#define LP5562_RUN_ENG1			0x20
+#define LP5562_RUN_ENG2			0x08
+#define LP5562_RUN_ENG3			0x02
+#define LP5562_ENG1_IS_LOADING(mode)	\
+	((mode & LP5562_MODE_ENG1_M) == LP5562_LOAD_ENG1)
+#define LP5562_ENG2_IS_LOADING(mode)	\
+	((mode & LP5562_MODE_ENG2_M) == LP5562_LOAD_ENG2)
+#define LP5562_ENG3_IS_LOADING(mode)	\
+	((mode & LP5562_MODE_ENG3_M) == LP5562_LOAD_ENG3)
+
+/* BRIGHTNESS Registers */
+#define LP5562_REG_R_PWM		0x04
+#define LP5562_REG_G_PWM		0x03
+#define LP5562_REG_B_PWM		0x02
+#define LP5562_REG_W_PWM		0x0E
+
+/* CURRENT Registers */
+#define LP5562_REG_R_CURRENT		0x07
+#define LP5562_REG_G_CURRENT		0x06
+#define LP5562_REG_B_CURRENT		0x05
+#define LP5562_REG_W_CURRENT		0x0F
+
+/* CONFIG Register 08h */
+#define LP5562_REG_CONFIG		0x08
+#define LP5562_DEFAULT_CFG	\
+	(LP5562_PWM_HF | LP5562_PWRSAVE_EN | LP5562_CLK_INT)
+
+/* RESET Register 0Dh */
+#define LP5562_REG_RESET		0x0D
+#define LP5562_RESET			0xFF
+
+/* PROGRAM ENGINE Registers */
+#define LP5562_REG_PROG_MEM_ENG1	0x10
+#define LP5562_REG_PROG_MEM_ENG2	0x30
+#define LP5562_REG_PROG_MEM_ENG3	0x50
+
+/* LEDMAP Register 70h */
+#define LP5562_REG_ENG_SEL		0x70
+#define LP5562_ENG_SEL_PWM		0
+#define LP5562_ENG_FOR_RGB_M		0x3F
+#define LP5562_ENG_SEL_RGB		0x1B	/* R:ENG1, G:ENG2, B:ENG3 */
+#define LP5562_ENG_FOR_W_M		0xC0
+#define LP5562_ENG1_FOR_W		0x40	/* W:ENG1 */
+#define LP5562_ENG2_FOR_W		0x80	/* W:ENG2 */
+#define LP5562_ENG3_FOR_W		0xC0	/* W:ENG3 */
+
+/* Program Commands */
+#define LP5562_CMD_DISABLE		0x00
+#define LP5562_CMD_LOAD			0x15
+#define LP5562_CMD_RUN			0x2A
+#define LP5562_CMD_DIRECT		0x3F
+#define LP5562_PATTERN_OFF		0
+
+static inline void lp5562_wait_opmode_done(void)
+{
+	/* operation mode change needs to be longer than 153 us */
+	usleep_range(200, 300);
+}
+
+static inline void lp5562_wait_enable_done(void)
+{
+	/* it takes more 488 us to update ENABLE register */
+	usleep_range(500, 600);
+}
+
+static void lp5562_set_led_current(struct lp55xx_led *led, u8 led_current)
+{
+	u8 addr[] = {
+		LP5562_REG_R_CURRENT,
+		LP5562_REG_G_CURRENT,
+		LP5562_REG_B_CURRENT,
+		LP5562_REG_W_CURRENT,
+	};
+
+	led->led_current = led_current;
+	lp55xx_write(led->chip, addr[led->chan_nr], led_current);
+}
+
+static void lp5562_load_engine(struct lp55xx_chip *chip)
+{
+	enum lp55xx_engine_index idx = chip->engine_idx;
+	u8 mask[] = {
+		[LP55XX_ENGINE_1] = LP5562_MODE_ENG1_M,
+		[LP55XX_ENGINE_2] = LP5562_MODE_ENG2_M,
+		[LP55XX_ENGINE_3] = LP5562_MODE_ENG3_M,
+	};
+
+	u8 val[] = {
+		[LP55XX_ENGINE_1] = LP5562_LOAD_ENG1,
+		[LP55XX_ENGINE_2] = LP5562_LOAD_ENG2,
+		[LP55XX_ENGINE_3] = LP5562_LOAD_ENG3,
+	};
+
+	lp55xx_update_bits(chip, LP5562_REG_OP_MODE, mask[idx], val[idx]);
+
+	lp5562_wait_opmode_done();
+}
+
+static void lp5562_stop_engine(struct lp55xx_chip *chip)
+{
+	lp55xx_write(chip, LP5562_REG_OP_MODE, LP5562_CMD_DISABLE);
+	lp5562_wait_opmode_done();
+}
+
+static void lp5562_run_engine(struct lp55xx_chip *chip, bool start)
+{
+	int ret;
+	u8 mode;
+	u8 exec;
+
+	/* stop engine */
+	if (!start) {
+		lp55xx_write(chip, LP5562_REG_ENABLE, LP5562_ENABLE_DEFAULT);
+		lp5562_wait_enable_done();
+		lp5562_stop_engine(chip);
+		lp55xx_write(chip, LP5562_REG_ENG_SEL, LP5562_ENG_SEL_PWM);
+		lp55xx_write(chip, LP5562_REG_OP_MODE, LP5562_CMD_DIRECT);
+		lp5562_wait_opmode_done();
+		return;
+	}
+
+	/*
+	 * To run the engine,
+	 * operation mode and enable register should updated at the same time
+	 */
+
+	ret = lp55xx_read(chip, LP5562_REG_OP_MODE, &mode);
+	if (ret)
+		return;
+
+	ret = lp55xx_read(chip, LP5562_REG_ENABLE, &exec);
+	if (ret)
+		return;
+
+	/* change operation mode to RUN only when each engine is loading */
+	if (LP5562_ENG1_IS_LOADING(mode)) {
+		mode = (mode & ~LP5562_MODE_ENG1_M) | LP5562_RUN_ENG1;
+		exec = (exec & ~LP5562_EXEC_ENG1_M) | LP5562_RUN_ENG1;
+	}
+
+	if (LP5562_ENG2_IS_LOADING(mode)) {
+		mode = (mode & ~LP5562_MODE_ENG2_M) | LP5562_RUN_ENG2;
+		exec = (exec & ~LP5562_EXEC_ENG2_M) | LP5562_RUN_ENG2;
+	}
+
+	if (LP5562_ENG3_IS_LOADING(mode)) {
+		mode = (mode & ~LP5562_MODE_ENG3_M) | LP5562_RUN_ENG3;
+		exec = (exec & ~LP5562_EXEC_ENG3_M) | LP5562_RUN_ENG3;
+	}
+
+	lp55xx_write(chip, LP5562_REG_OP_MODE, mode);
+	lp5562_wait_opmode_done();
+
+	lp55xx_update_bits(chip, LP5562_REG_ENABLE, LP5562_EXEC_M, exec);
+	lp5562_wait_enable_done();
+}
+
+static int lp5562_update_firmware(struct lp55xx_chip *chip,
+					const u8 *data, size_t size)
+{
+	enum lp55xx_engine_index idx = chip->engine_idx;
+	u8 pattern[LP5562_PROGRAM_LENGTH] = {0};
+	u8 addr[] = {
+		[LP55XX_ENGINE_1] = LP5562_REG_PROG_MEM_ENG1,
+		[LP55XX_ENGINE_2] = LP5562_REG_PROG_MEM_ENG2,
+		[LP55XX_ENGINE_3] = LP5562_REG_PROG_MEM_ENG3,
+	};
+	unsigned cmd;
+	char c[3];
+	int program_size;
+	int nrchars;
+	int offset = 0;
+	int ret;
+	int i;
+
+	/* clear program memory before updating */
+	for (i = 0; i < LP5562_PROGRAM_LENGTH; i++)
+		lp55xx_write(chip, addr[idx] + i, 0);
+
+	i = 0;
+	while ((offset < size - 1) && (i < LP5562_PROGRAM_LENGTH)) {
+		/* separate sscanfs because length is working only for %s */
+		ret = sscanf(data + offset, "%2s%n ", c, &nrchars);
+		if (ret != 1)
+			goto err;
+
+		ret = sscanf(c, "%2x", &cmd);
+		if (ret != 1)
+			goto err;
+
+		pattern[i] = (u8)cmd;
+		offset += nrchars;
+		i++;
+	}
+
+	/* Each instruction is 16bit long. Check that length is even */
+	if (i % 2)
+		goto err;
+
+	program_size = i;
+	for (i = 0; i < program_size; i++)
+		lp55xx_write(chip, addr[idx] + i, pattern[i]);
+
+	return 0;
+
+err:
+	dev_err(&chip->cl->dev, "wrong pattern format\n");
+	return -EINVAL;
+}
+
+static void lp5562_firmware_loaded(struct lp55xx_chip *chip)
+{
+	const struct firmware *fw = chip->fw;
+
+	if (fw->size > LP5562_PROGRAM_LENGTH) {
+		dev_err(&chip->cl->dev, "firmware data size overflow: %zu\n",
+			fw->size);
+		return;
+	}
+
+	/*
+	 * Program momery sequence
+	 *  1) set engine mode to "LOAD"
+	 *  2) write firmware data into program memory
+	 */
+
+	lp5562_load_engine(chip);
+	lp5562_update_firmware(chip, fw->data, fw->size);
+}
+
+static int lp5562_post_init_device(struct lp55xx_chip *chip)
+{
+	int ret;
+	u8 update_cfg = chip->pdata->update_config ? : LP5562_DEFAULT_CFG;
+
+	/* Set all PWMs to direct control mode */
+	ret = lp55xx_write(chip, LP5562_REG_OP_MODE, LP5562_CMD_DIRECT);
+	if (ret)
+		return ret;
+
+	lp5562_wait_opmode_done();
+
+	ret = lp55xx_write(chip, LP5562_REG_CONFIG, update_cfg);
+	if (ret)
+		return ret;
+
+	/* Initialize all channels PWM to zero -> leds off */
+	lp55xx_write(chip, LP5562_REG_R_PWM, 0);
+	lp55xx_write(chip, LP5562_REG_G_PWM, 0);
+	lp55xx_write(chip, LP5562_REG_B_PWM, 0);
+	lp55xx_write(chip, LP5562_REG_W_PWM, 0);
+
+	/* Set LED map as register PWM by default */
+	lp55xx_write(chip, LP5562_REG_ENG_SEL, LP5562_ENG_SEL_PWM);
+
+	return 0;
+}
+
+static void lp5562_led_brightness_work(struct work_struct *work)
+{
+	struct lp55xx_led *led = container_of(work, struct lp55xx_led,
+					      brightness_work);
+	struct lp55xx_chip *chip = led->chip;
+	u8 addr[] = {
+		LP5562_REG_R_PWM,
+		LP5562_REG_G_PWM,
+		LP5562_REG_B_PWM,
+		LP5562_REG_W_PWM,
+	};
+
+	mutex_lock(&chip->lock);
+	lp55xx_write(chip, addr[led->chan_nr], led->brightness);
+	mutex_unlock(&chip->lock);
+}
+
+static void lp5562_write_program_memory(struct lp55xx_chip *chip,
+					u8 base, const u8 *rgb, int size)
+{
+	int i;
+
+	if (!rgb || size <= 0)
+		return;
+
+	for (i = 0; i < size; i++)
+		lp55xx_write(chip, base + i, *(rgb + i));
+
+	lp55xx_write(chip, base + i, 0);
+	lp55xx_write(chip, base + i + 1, 0);
+}
+
+/* check the size of program count */
+static inline bool _is_pc_overflow(struct lp55xx_predef_pattern *ptn)
+{
+	return (ptn->size_r >= LP5562_PROGRAM_LENGTH ||
+		ptn->size_g >= LP5562_PROGRAM_LENGTH ||
+		ptn->size_b >= LP5562_PROGRAM_LENGTH);
+}
+
+static int lp5562_run_predef_led_pattern(struct lp55xx_chip *chip, int mode)
+{
+	struct lp55xx_predef_pattern *ptn;
+	int i;
+
+	if (mode == LP5562_PATTERN_OFF) {
+		lp5562_run_engine(chip, false);
+		return 0;
+	}
+
+	ptn = chip->pdata->patterns + (mode - 1);
+	if (!ptn || _is_pc_overflow(ptn)) {
+		dev_err(&chip->cl->dev, "invalid pattern data\n");
+		return -EINVAL;
+	}
+
+	lp5562_stop_engine(chip);
+
+	/* Set LED map as RGB */
+	lp55xx_write(chip, LP5562_REG_ENG_SEL, LP5562_ENG_SEL_RGB);
+
+	/* Load engines */
+	for (i = LP55XX_ENGINE_1; i <= LP55XX_ENGINE_3; i++) {
+		chip->engine_idx = i;
+		lp5562_load_engine(chip);
+	}
+
+	/* Clear program registers */
+	lp55xx_write(chip, LP5562_REG_PROG_MEM_ENG1, 0);
+	lp55xx_write(chip, LP5562_REG_PROG_MEM_ENG1 + 1, 0);
+	lp55xx_write(chip, LP5562_REG_PROG_MEM_ENG2, 0);
+	lp55xx_write(chip, LP5562_REG_PROG_MEM_ENG2 + 1, 0);
+	lp55xx_write(chip, LP5562_REG_PROG_MEM_ENG3, 0);
+	lp55xx_write(chip, LP5562_REG_PROG_MEM_ENG3 + 1, 0);
+
+	/* Program engines */
+	lp5562_write_program_memory(chip, LP5562_REG_PROG_MEM_ENG1,
+				ptn->r, ptn->size_r);
+	lp5562_write_program_memory(chip, LP5562_REG_PROG_MEM_ENG2,
+				ptn->g, ptn->size_g);
+	lp5562_write_program_memory(chip, LP5562_REG_PROG_MEM_ENG3,
+				ptn->b, ptn->size_b);
+
+	/* Run engines */
+	lp5562_run_engine(chip, true);
+
+	return 0;
+}
+
+static ssize_t lp5562_store_pattern(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t len)
+{
+	struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
+	struct lp55xx_chip *chip = led->chip;
+	struct lp55xx_predef_pattern *ptn = chip->pdata->patterns;
+	int num_patterns = chip->pdata->num_patterns;
+	unsigned long mode;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &mode);
+	if (ret)
+		return ret;
+
+	if (mode > num_patterns || !ptn)
+		return -EINVAL;
+
+	mutex_lock(&chip->lock);
+	ret = lp5562_run_predef_led_pattern(chip, mode);
+	mutex_unlock(&chip->lock);
+
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static ssize_t lp5562_store_engine_mux(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
+	struct lp55xx_chip *chip = led->chip;
+	u8 mask;
+	u8 val;
+
+	/* LED map
+	 * R ... Engine 1 (fixed)
+	 * G ... Engine 2 (fixed)
+	 * B ... Engine 3 (fixed)
+	 * W ... Engine 1 or 2 or 3
+	 */
+
+	if (sysfs_streq(buf, "RGB")) {
+		mask = LP5562_ENG_FOR_RGB_M;
+		val = LP5562_ENG_SEL_RGB;
+	} else if (sysfs_streq(buf, "W")) {
+		enum lp55xx_engine_index idx = chip->engine_idx;
+
+		mask = LP5562_ENG_FOR_W_M;
+		switch (idx) {
+		case LP55XX_ENGINE_1:
+			val = LP5562_ENG1_FOR_W;
+			break;
+		case LP55XX_ENGINE_2:
+			val = LP5562_ENG2_FOR_W;
+			break;
+		case LP55XX_ENGINE_3:
+			val = LP5562_ENG3_FOR_W;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+	} else {
+		dev_err(dev, "choose RGB or W\n");
+		mutex_unlock(&chip->lock);
+		return -EINVAL;
+	}
+
+	mutex_lock(&chip->lock);
+	lp55xx_update_bits(chip, LP5562_REG_ENG_SEL, mask, val);
+	mutex_unlock(&chip->lock);
+
+	return len;
+}
+
+static DEVICE_ATTR(led_pattern, S_IWUSR, NULL, lp5562_store_pattern);
+static DEVICE_ATTR(engine_mux, S_IWUSR, NULL, lp5562_store_engine_mux);
+
+static struct attribute *lp5562_attributes[] = {
+	&dev_attr_led_pattern.attr,
+	&dev_attr_engine_mux.attr,
+	NULL,
+};
+
+static const struct attribute_group lp5562_group = {
+	.attrs = lp5562_attributes,
+};
+
+/* Chip specific configurations */
+static struct lp55xx_device_config lp5562_cfg = {
+	.max_channel  = LP5562_MAX_LEDS,
+	.reset = {
+		.addr = LP5562_REG_RESET,
+		.val  = LP5562_RESET,
+	},
+	.enable = {
+		.addr = LP5562_REG_ENABLE,
+		.val  = LP5562_ENABLE_DEFAULT,
+	},
+	.post_init_device   = lp5562_post_init_device,
+	.set_led_current    = lp5562_set_led_current,
+	.brightness_work_fn = lp5562_led_brightness_work,
+	.run_engine         = lp5562_run_engine,
+	.firmware_cb        = lp5562_firmware_loaded,
+	.dev_attr_group     = &lp5562_group,
+};
+
+static int lp5562_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	int ret;
+	struct lp55xx_chip *chip;
+	struct lp55xx_led *led;
+	struct lp55xx_platform_data *pdata = client->dev.platform_data;
+
+	if (!pdata) {
+		dev_err(&client->dev, "no platform data\n");
+		return -EINVAL;
+	}
+
+	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	led = devm_kzalloc(&client->dev,
+			sizeof(*led) * pdata->num_channels, GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	chip->cl = client;
+	chip->pdata = pdata;
+	chip->cfg = &lp5562_cfg;
+
+	mutex_init(&chip->lock);
+
+	i2c_set_clientdata(client, led);
+
+	ret = lp55xx_init_device(chip);
+	if (ret)
+		goto err_init;
+
+	ret = lp55xx_register_leds(led, chip);
+	if (ret)
+		goto err_register_leds;
+
+	ret = lp55xx_register_sysfs(chip);
+	if (ret) {
+		dev_err(&client->dev, "registering sysfs failed\n");
+		goto err_register_sysfs;
+	}
+
+	return 0;
+
+err_register_sysfs:
+	lp55xx_unregister_leds(led, chip);
+err_register_leds:
+	lp55xx_deinit_device(chip);
+err_init:
+	return ret;
+}
+
+static int lp5562_remove(struct i2c_client *client)
+{
+	struct lp55xx_led *led = i2c_get_clientdata(client);
+	struct lp55xx_chip *chip = led->chip;
+
+	lp5562_stop_engine(chip);
+
+	lp55xx_unregister_sysfs(chip);
+	lp55xx_unregister_leds(led, chip);
+	lp55xx_deinit_device(chip);
+
+	return 0;
+}
+
+static const struct i2c_device_id lp5562_id[] = {
+	{ "lp5562", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, lp5562_id);
+
+static struct i2c_driver lp5562_driver = {
+	.driver = {
+		.name	= "lp5562",
+	},
+	.probe		= lp5562_probe,
+	.remove		= lp5562_remove,
+	.id_table	= lp5562_id,
+};
+
+module_i2c_driver(lp5562_driver);
+
+MODULE_DESCRIPTION("Texas Instruments LP5562 LED Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/leds-lp55xx.h b/include/linux/platform_data/leds-lp55xx.h
index 1509570..1f1041e 100644
--- a/include/linux/platform_data/leds-lp55xx.h
+++ b/include/linux/platform_data/leds-lp55xx.h
@@ -32,6 +32,13 @@
 #define LP5521_CLK_INT			1	/* Internal clock */
 #define LP5521_CLK_AUTO			2	/* Automatic clock selection */
 
+/* Bits in LP5562 CONFIG register */
+#define LP5562_PWM_HF			LP5521_PWM_HF
+#define LP5562_PWRSAVE_EN		LP5521_PWRSAVE_EN
+#define LP5562_CLK_SRC_EXT		LP5521_CLK_SRC_EXT
+#define LP5562_CLK_INT			LP5521_CLK_INT
+#define LP5562_CLK_AUTO			LP5521_CLK_AUTO
+
 struct lp55xx_led_config {
 	const char *name;
 	u8 chan_nr;
@@ -40,9 +47,9 @@ struct lp55xx_led_config {
 };
 
 struct lp55xx_predef_pattern {
-	u8 *r;
-	u8 *g;
-	u8 *b;
+	const u8 *r;
+	const u8 *g;
+	const u8 *b;
 	u8 size_r;
 	u8 size_g;
 	u8 size_b;
-- 
1.7.9.5


Best Regards,
Milo

