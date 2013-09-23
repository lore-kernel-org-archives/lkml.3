Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3IWNoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:44:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55027 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889Ab3IWNox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:44:53 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: myungjoo.ham@samsung.com, cw00.choi@samsung.com
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] extcon: arizona: Don't require micbias to be shifted in pdata
Date: Mon, 23 Sep 2013 14:33:59 +0100
Message-Id: <1379943239-2779-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1379943239-2779-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1379943239-2779-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every other pdata field is specified unshifted the patch handles
shifting for the MICBIAS from the microphone detection polarity
configurations in the extcon driver rather than demanding it in
pdata to match other fields.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 5096919..3c55ec8 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -86,8 +86,8 @@ struct arizona_extcon_info {
 };
 
 static const struct arizona_micd_config micd_default_modes[] = {
-	{ ARIZONA_ACCDET_SRC, 1 << ARIZONA_MICD_BIAS_SRC_SHIFT, 0 },
-	{ 0,                  2 << ARIZONA_MICD_BIAS_SRC_SHIFT, 1 },
+	{ ARIZONA_ACCDET_SRC, 1, 0 },
+	{ 0,                  2, 1 },
 };
 
 static const struct arizona_micd_range micd_default_ranges[] = {
@@ -182,7 +182,8 @@ static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
 					info->micd_modes[mode].gpio);
 	regmap_update_bits(arizona->regmap, ARIZONA_MIC_DETECT_1,
 			   ARIZONA_MICD_BIAS_SRC_MASK,
-			   info->micd_modes[mode].bias);
+			   info->micd_modes[mode].bias <<
+			   ARIZONA_MICD_BIAS_SRC_SHIFT);
 	regmap_update_bits(arizona->regmap, ARIZONA_ACCESSORY_DETECT_MODE_1,
 			   ARIZONA_ACCDET_SRC, info->micd_modes[mode].src);
 
@@ -193,7 +194,7 @@ static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
 
 static const char *arizona_extcon_get_micbias(struct arizona_extcon_info *info)
 {
-	switch (info->micd_modes[0].bias >> ARIZONA_MICD_BIAS_SRC_SHIFT) {
+	switch (info->micd_modes[0].bias) {
 	case 1:
 		return "MICBIAS1";
 	case 2:
-- 
1.7.2.5

