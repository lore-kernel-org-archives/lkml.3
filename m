Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3CUAhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 20:37:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45863 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3CUAhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:37:10 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "Mike Turquette (mturquette@linaro.org)" <mturquette@linaro.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] leds: lp55xx: configure the clock detection
Thread-Topic: [PATCH 2/2] leds: lp55xx: configure the clock detection
Thread-Index: Ac4lzDYZcGGVYcp0QXW6eJ3SiqYPxg==
Date: Thu, 21 Mar 2013 00:37:04 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E48E33@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now LP55xx provides automatic clock detection API, lp55xx_is_extclk_used().
The clock configuration can be done by the driver itself.

(a) Concept
The default value is set by each driver with clock selection.
The internal clock selection bit is updated in case that the external clock
is not detected or clock rate is not 32KHz.

(b) Change on LP55xx platform data
The clock configuration is done automatically, so no need to define
'update_config' in the platform side.
Correlated information are removed in the documentations and header.

(c) Definitions moved from header to driver files
CONFIG register values are moved each driver, LP5521 and LP5562.
Not necessary definitions are removed also.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/leds/leds-lp5521.txt        |   19 -------------------
 Documentation/leds/leds-lp5562.txt        |   15 ---------------
 drivers/leds/leds-lp5521.c                |   19 +++++++++++++++++--
 drivers/leds/leds-lp5562.c                |   14 ++++++++++----
 include/linux/platform_data/leds-lp55xx.h |   22 ----------------------
 5 files changed, 27 insertions(+), 62 deletions(-)

diff --git a/Documentation/leds/leds-lp5521.txt b/Documentation/leds/leds-lp5521.txt
index 270f571..79e4c2e 100644
--- a/Documentation/leds/leds-lp5521.txt
+++ b/Documentation/leds/leds-lp5521.txt
@@ -81,22 +81,3 @@ static struct lp55xx_platform_data lp5521_platform_data = {
 
 If the current is set to 0 in the platform data, that channel is
 disabled and it is not visible in the sysfs.
-
-The 'update_config' : CONFIG register (ADDR 08h)
-This value is platform-specific data.
-If update_config is not defined, the CONFIG register is set with
-'LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT'.
-(Enable auto-powersave, set charge pump to auto, red to battery)
-
-example of update_config :
-
-#define LP5521_CONFIGS	(LP5521_PWM_HF | LP5521_PWRSAVE_EN | \
-			LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT | \
-			LP5521_CLK_INT)
-
-static struct lp55xx_platform_data lp5521_pdata = {
-	.led_config = lp5521_led_config,
-	.num_channels = ARRAY_SIZE(lp5521_led_config),
-	.clock_mode = LP55XX_CLOCK_INT,
-	.update_config = LP5521_CONFIGS,
-};
diff --git a/Documentation/leds/leds-lp5562.txt b/Documentation/leds/leds-lp5562.txt
index 9606100..5a823ff 100644
--- a/Documentation/leds/leds-lp5562.txt
+++ b/Documentation/leds/leds-lp5562.txt
@@ -118,18 +118,3 @@ static struct lp55xx_platform_data lp5562_platform_data = {
 
 If the current is set to 0 in the platform data, that channel is
 disabled and it is not visible in the sysfs.
-
-The 'update_config' : CONFIG register (ADDR 08h)
-This value is platform-specific data.
-If update_config is not defined, the CONFIG register is set with
-'LP5562_PWRSAVE_EN | LP5562_CLK_AUTO'.
-(Enable auto-powersave, set automatic clock source selection)
-
-#define LP5562_CONFIGS	(LP5562_PWM_HF | LP5562_PWRSAVE_EN | \
-			 LP5562_CLK_SRC_EXT)
-
-static struct lp55xx_platform_data lp5562_pdata = {
-	.led_config = lp5562_led_config,
-	.num_channels = ARRAY_SIZE(lp5562_led_config),
-	.update_config = LP5562_CONFIGS,
-};
diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 7f10304..19752c9 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -68,6 +68,18 @@
 #define LP5521_ENABLE_RUN_PROGRAM	\
 	(LP5521_ENABLE_DEFAULT | LP5521_EXEC_RUN)
 
+/* CONFIG register */
+#define LP5521_PWM_HF			0x40	/* PWM: 0 = 256Hz, 1 = 558Hz */
+#define LP5521_PWRSAVE_EN		0x20	/* 1 = Power save mode */
+#define LP5521_CP_MODE_OFF		0	/* Charge pump (CP) off */
+#define LP5521_CP_MODE_BYPASS		8	/* CP forced to bypass mode */
+#define LP5521_CP_MODE_1X5		0x10	/* CP forced to 1.5x mode */
+#define LP5521_CP_MODE_AUTO		0x18	/* Automatic mode selection */
+#define LP5521_R_TO_BATT		0x04	/* R out: 0 = CP, 1 = Vbat */
+#define LP5521_CLK_INT			0x01	/* Internal clock */
+#define LP5521_DEFAULT_CFG		\
+	(LP5521_PWM_HF | LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO)
+
 /* Status */
 #define LP5521_EXT_CLK_USED		0x08
 
@@ -296,8 +308,11 @@ static int lp5521_post_init_device(struct lp55xx_chip *chip)
 	/* Set all PWMs to direct control mode */
 	ret = lp55xx_write(chip, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
 
-	val = chip->pdata->update_config ?
-		: (LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT);
+	/* Update configuration for the clock setting */
+	val = LP5521_DEFAULT_CFG;
+	if (!lp55xx_is_extclk_used(chip))
+		val |= LP5521_CLK_INT;
+
 	ret = lp55xx_write(chip, LP5521_REG_CONFIG, val);
 	if (ret)
 		return ret;
diff --git a/drivers/leds/leds-lp5562.c b/drivers/leds/leds-lp5562.c
index f8b9277..513f239 100644
--- a/drivers/leds/leds-lp5562.c
+++ b/drivers/leds/leds-lp5562.c
@@ -71,8 +71,10 @@
 
 /* CONFIG Register 08h */
 #define LP5562_REG_CONFIG		0x08
-#define LP5562_DEFAULT_CFG	\
-	(LP5562_PWM_HF | LP5562_PWRSAVE_EN | LP5562_CLK_INT)
+#define LP5562_PWM_HF			0x40
+#define LP5562_PWRSAVE_EN		0x20
+#define LP5562_CLK_INT			0x01	/* Internal clock */
+#define LP5562_DEFAULT_CFG		(LP5562_PWM_HF | LP5562_PWRSAVE_EN)
 
 /* RESET Register 0Dh */
 #define LP5562_REG_RESET		0x0D
@@ -280,7 +282,7 @@ static void lp5562_firmware_loaded(struct lp55xx_chip *chip)
 static int lp5562_post_init_device(struct lp55xx_chip *chip)
 {
 	int ret;
-	u8 update_cfg = chip->pdata->update_config ? : LP5562_DEFAULT_CFG;
+	u8 cfg = LP5562_DEFAULT_CFG;
 
 	/* Set all PWMs to direct control mode */
 	ret = lp55xx_write(chip, LP5562_REG_OP_MODE, LP5562_CMD_DIRECT);
@@ -289,7 +291,11 @@ static int lp5562_post_init_device(struct lp55xx_chip *chip)
 
 	lp5562_wait_opmode_done();
 
-	ret = lp55xx_write(chip, LP5562_REG_CONFIG, update_cfg);
+	/* Update configuration for the clock setting */
+	if (!lp55xx_is_extclk_used(chip))
+		cfg |= LP5562_CLK_INT;
+
+	ret = lp55xx_write(chip, LP5562_REG_CONFIG, cfg);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/platform_data/leds-lp55xx.h b/include/linux/platform_data/leds-lp55xx.h
index 1f1041e..202e290 100644
--- a/include/linux/platform_data/leds-lp55xx.h
+++ b/include/linux/platform_data/leds-lp55xx.h
@@ -20,25 +20,6 @@
 #define LP55XX_CLOCK_INT	1
 #define LP55XX_CLOCK_EXT	2
 
-/* Bits in LP5521 CONFIG register. 'update_config' in lp55xx_platform_data */
-#define LP5521_PWM_HF			0x40	/* PWM: 0 = 256Hz, 1 = 558Hz */
-#define LP5521_PWRSAVE_EN		0x20	/* 1 = Power save mode */
-#define LP5521_CP_MODE_OFF		0	/* Charge pump (CP) off */
-#define LP5521_CP_MODE_BYPASS		8	/* CP forced to bypass mode */
-#define LP5521_CP_MODE_1X5		0x10	/* CP forced to 1.5x mode */
-#define LP5521_CP_MODE_AUTO		0x18	/* Automatic mode selection */
-#define LP5521_R_TO_BATT		4	/* R out: 0 = CP, 1 = Vbat */
-#define LP5521_CLK_SRC_EXT		0	/* Ext-clk source (CLK_32K) */
-#define LP5521_CLK_INT			1	/* Internal clock */
-#define LP5521_CLK_AUTO			2	/* Automatic clock selection */
-
-/* Bits in LP5562 CONFIG register */
-#define LP5562_PWM_HF			LP5521_PWM_HF
-#define LP5562_PWRSAVE_EN		LP5521_PWRSAVE_EN
-#define LP5562_CLK_SRC_EXT		LP5521_CLK_SRC_EXT
-#define LP5562_CLK_INT			LP5521_CLK_INT
-#define LP5562_CLK_AUTO			LP5521_CLK_AUTO
-
 struct lp55xx_led_config {
 	const char *name;
 	u8 chan_nr;
@@ -86,9 +67,6 @@ struct lp55xx_platform_data {
 	/* Predefined pattern data */
 	struct lp55xx_predef_pattern *patterns;
 	unsigned int num_patterns;
-
-	/* _CONFIG register */
-	u8 update_config;
 };
 
 #endif /* _LEDS_LP55XX_H */
-- 
1.7.9.5


Best Regards,
Milo


