Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695Ab3DBLds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:33:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46574 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760304Ab3DBLdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:03 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 11/16] extcon: arizona: Don't ground flip when using HPDET identification
Date: Tue,  2 Apr 2013 12:32:43 +0100
Message-Id: <1364902368-1123-11-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extra check makes the procedure take longer and is of marginal use
in identification so do not execute it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index c18cf14..7c4ce81 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -470,29 +470,7 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 	 */
 	if (arizona->pdata.hpdet_acc_id) {
 		info->hpdet_res[info->num_hpdet_res++] = *reading;
-
-		/*
-		 * If the impedence is too high don't measure the
-		 * second ground.
-		 */
-		if (info->num_hpdet_res == 1 && *reading >= 45) {
-			dev_dbg(arizona->dev, "Skipping ground flip\n");
-			info->hpdet_res[info->num_hpdet_res++] = *reading;
-		}
-
-		if (info->num_hpdet_res == 1) {
-			dev_dbg(arizona->dev, "Flipping ground\n");
-
-			regmap_update_bits(arizona->regmap,
-					   ARIZONA_ACCESSORY_DETECT_MODE_1,
-					   ARIZONA_ACCDET_SRC,
-					   ~info->micd_modes[0].src);
-
-			regmap_update_bits(arizona->regmap,
-					   ARIZONA_HEADPHONE_DETECT_1,
-					   ARIZONA_HP_POLL, ARIZONA_HP_POLL);
-			return -EAGAIN;
-		}
+		info->hpdet_res[info->num_hpdet_res++] = *reading;
 
 		/* Only check the mic directly if we didn't already ID it */
 		if (id_gpio && info->num_hpdet_res == 2 &&
-- 
1.7.10.4

