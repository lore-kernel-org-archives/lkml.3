Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab3HHIAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:00:42 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:59965 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933849Ab3HHIAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:00:39 -0400
From: Milo Kim <woogyom.kim@gmail.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Milo Kim <milo.kim@ti.com>
Subject: [PATCH 06/10] leds: lp5523: LED MUX configuration on initializing
Date: Thu,  8 Aug 2013 16:59:50 +0900
Message-Id: <1375948794-6286-7-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375948794-6286-1-git-send-email-milo.kim@ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED MUX start and stop address should be updated in the program memory
on LP5523 initialization.
LED pattern doesn't work without additional MUX address configuration.
This handling is done by new function, lp5523_init_program_engine().
Eventually, it's called during device initialization, lp5523_post_init_device().

This is a conflict after git commit 632418bf65503405df3f9a6a1616f5a95f91db85
(leds-lp5523: clean up lp5523_configure()).
So it should be fixed.

Cc: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Milo Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5523.c |   70 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index b509480..29c8b19 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -49,6 +49,9 @@
 #define LP5523_REG_RESET		0x3D
 #define LP5523_REG_LED_TEST_CTRL	0x41
 #define LP5523_REG_LED_TEST_ADC		0x42
+#define LP5523_REG_CH1_PROG_START	0x4C
+#define LP5523_REG_CH2_PROG_START	0x4D
+#define LP5523_REG_CH3_PROG_START	0x4E
 #define LP5523_REG_PROG_PAGE_SEL	0x4F
 #define LP5523_REG_PROG_MEM		0x50
 
@@ -65,6 +68,7 @@
 #define LP5523_RESET			0xFF
 #define LP5523_ADC_SHORTCIRC_LIM	80
 #define LP5523_EXT_CLK_USED		0x08
+#define LP5523_ENG_STATUS_MASK		0x07
 
 /* Memory Page Selection */
 #define LP5523_PAGE_ENG1		0
@@ -99,6 +103,8 @@ enum lp5523_chip_id {
 	LP55231,
 };
 
+static int lp5523_init_program_engine(struct lp55xx_chip *chip);
+
 static inline void lp5523_wait_opmode_done(void)
 {
 	usleep_range(1000, 2000);
@@ -134,7 +140,11 @@ static int lp5523_post_init_device(struct lp55xx_chip *chip)
 	if (ret)
 		return ret;
 
-	return lp55xx_write(chip, LP5523_REG_ENABLE_LEDS_LSB, 0xff);
+	ret = lp55xx_write(chip, LP5523_REG_ENABLE_LEDS_LSB, 0xff);
+	if (ret)
+		return ret;
+
+	return lp5523_init_program_engine(chip);
 }
 
 static void lp5523_load_engine(struct lp55xx_chip *chip)
@@ -233,6 +243,64 @@ static void lp5523_run_engine(struct lp55xx_chip *chip, bool start)
 	lp55xx_update_bits(chip, LP5523_REG_ENABLE, LP5523_EXEC_M, exec);
 }
 
+static int lp5523_init_program_engine(struct lp55xx_chip *chip)
+{
+	int i;
+	int j;
+	int ret;
+	u8 status;
+	/* one pattern per engine setting LED MUX start and stop addresses */
+	static const u8 pattern[][LP5523_PROGRAM_LENGTH] =  {
+		{ 0x9c, 0x30, 0x9c, 0xb0, 0x9d, 0x80, 0xd8, 0x00, 0},
+		{ 0x9c, 0x40, 0x9c, 0xc0, 0x9d, 0x80, 0xd8, 0x00, 0},
+		{ 0x9c, 0x50, 0x9c, 0xd0, 0x9d, 0x80, 0xd8, 0x00, 0},
+	};
+
+	/* hardcode 32 bytes of memory for each engine from program memory */
+	ret = lp55xx_write(chip, LP5523_REG_CH1_PROG_START, 0x00);
+	if (ret)
+		return ret;
+
+	ret = lp55xx_write(chip, LP5523_REG_CH2_PROG_START, 0x10);
+	if (ret)
+		return ret;
+
+	ret = lp55xx_write(chip, LP5523_REG_CH3_PROG_START, 0x20);
+	if (ret)
+		return ret;
+
+	/* write LED MUX address space for each engine */
+	for (i = LP55XX_ENGINE_1; i <= LP55XX_ENGINE_3; i++) {
+		chip->engine_idx = i;
+		lp5523_load_engine_and_select_page(chip);
+
+		for (j = 0; j < LP5523_PROGRAM_LENGTH; j++) {
+			ret = lp55xx_write(chip, LP5523_REG_PROG_MEM + j,
+					pattern[i - 1][j]);
+			if (ret)
+				goto out;
+		}
+	}
+
+	lp5523_run_engine(chip, true);
+
+	/* Let the programs run for couple of ms and check the engine status */
+	usleep_range(3000, 6000);
+	lp55xx_read(chip, LP5523_REG_STATUS, &status);
+	status &= LP5523_ENG_STATUS_MASK;
+
+	if (status != LP5523_ENG_STATUS_MASK) {
+		dev_err(&chip->cl->dev,
+			"cound not configure LED engine, status = 0x%.2x\n",
+			status);
+		ret = -1;
+	}
+
+out:
+	lp5523_stop_engine(chip);
+	return ret;
+}
+
 static int lp5523_update_program_memory(struct lp55xx_chip *chip,
 					const u8 *data, size_t size)
 {
-- 
1.7.9.5

