Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab3BKQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:27:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35462 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757575Ab3BKQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:27:12 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 02/11] extcon: arizona: Retry failed HP measurements
Date: Mon, 11 Feb 2013 16:26:57 +0000
Message-Id: <1360600026-16878-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130211162614.GH4607@opensource.wolfsonmicro.com>
 <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have mechanisms in place to allow retries so let's use them rather
than guessing.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index ce95f86..5283034 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -31,8 +31,6 @@
 #include <linux/mfd/arizona/pdata.h>
 #include <linux/mfd/arizona/registers.h>
 
-#define ARIZONA_DEFAULT_HP 32
-
 #define ARIZONA_NUM_BUTTONS 6
 
 #define ARIZONA_ACCDET_MODE_MIC 0
@@ -208,7 +206,7 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 		if (!(val & ARIZONA_HP_DONE)) {
 			dev_err(arizona->dev, "HPDET did not complete: %x\n",
 				val);
-			val = ARIZONA_DEFAULT_HP;
+			return -EAGAIN;
 		}
 
 		val &= ARIZONA_HP_LVL_MASK;
@@ -218,14 +216,14 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 		if (!(val & ARIZONA_HP_DONE_B)) {
 			dev_err(arizona->dev, "HPDET did not complete: %x\n",
 				val);
-			return ARIZONA_DEFAULT_HP;
+			return -EAGAIN;
 		}
 
 		ret = regmap_read(arizona->regmap, ARIZONA_HP_DACVAL, &val);
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to read HP value: %d\n",
 				ret);
-			return ARIZONA_DEFAULT_HP;
+			return -EAGAIN;
 		}
 
 		regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
@@ -267,7 +265,7 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 		if (!(val & ARIZONA_HP_DONE_B)) {
 			dev_err(arizona->dev, "HPDET did not complete: %x\n",
 				val);
-			return ARIZONA_DEFAULT_HP;
+			return -EAGAIN;
 		}
 
 		val &= ARIZONA_HP_LVL_B_MASK;
-- 
1.7.10.4

