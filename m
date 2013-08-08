Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008Ab3HHIAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:00:38 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:50013 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933849Ab3HHIAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:00:36 -0400
From: Milo Kim <woogyom.kim@gmail.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Milo Kim <milo.kim@ti.com>
Subject: [PATCH 05/10] leds: lp5523: make separate API for loading engine
Date: Thu,  8 Aug 2013 16:59:49 +0900
Message-Id: <1375948794-6286-6-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375948794-6286-1-git-send-email-milo.kim@ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lp5523_load_engine()
  It is called whenever the operation mode is changed to 'load'.
  It is used for simple operation mode change.
  It will be used when engine mode and LED selection is updated in later patch.

lp5523_load_engine_and_select_page()
  Change the operation mode to 'load' and select program page number.
  This is used for programming a LED pattern at a time.
  So load_engine() is replaced with new API, load_engine_and_select_page()
  in lp5523_firmware_loaded().

Signed-off-by: Milo Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5523.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 72c10e2..b509480 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -152,15 +152,21 @@ static void lp5523_load_engine(struct lp55xx_chip *chip)
 		[LP55XX_ENGINE_3] = LP5523_LOAD_ENG3,
 	};
 
+	lp55xx_update_bits(chip, LP5523_REG_OP_MODE, mask[idx], val[idx]);
+
+	lp5523_wait_opmode_done();
+}
+
+static void lp5523_load_engine_and_select_page(struct lp55xx_chip *chip)
+{
+	enum lp55xx_engine_index idx = chip->engine_idx;
 	u8 page_sel[] = {
 		[LP55XX_ENGINE_1] = LP5523_PAGE_ENG1,
 		[LP55XX_ENGINE_2] = LP5523_PAGE_ENG2,
 		[LP55XX_ENGINE_3] = LP5523_PAGE_ENG3,
 	};
 
-	lp55xx_update_bits(chip, LP5523_REG_OP_MODE, mask[idx], val[idx]);
-
-	lp5523_wait_opmode_done();
+	lp5523_load_engine(chip);
 
 	lp55xx_write(chip, LP5523_REG_PROG_PAGE_SEL, page_sel[idx]);
 }
@@ -290,7 +296,7 @@ static void lp5523_firmware_loaded(struct lp55xx_chip *chip)
 	 *  2) write firmware data into program memory
 	 */
 
-	lp5523_load_engine(chip);
+	lp5523_load_engine_and_select_page(chip);
 	lp5523_update_program_memory(chip, fw->data, fw->size);
 }
 
-- 
1.7.9.5

