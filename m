Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935999Ab3DIMRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:17:22 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54735 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759088Ab3DIMRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:17:21 -0400
Message-ID: <1365509835.3801.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: ab8500: Don't update lp_mode_req flag in
 set_mode() error paths
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2013 20:17:15 +0800
In-Reply-To: <1365509706.3801.1.camel@phoenix>
References: <1365509706.3801.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, set invalid mode setting for shared mode regulators may change
sm->lp_mode_req flag. This patch ensures we don't set lp_mode_req flag to wrong
status if set_mode() fails.

This patch includes some clean up, and these changes makes this patch looks like
code refactor. The clean up is mainly to avoid adding ugly code to handle
failure paths. 

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   98 +++++++++++++++++++-------------------------
 1 file changed, 43 insertions(+), 55 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 1866dbf..88ab408 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -348,11 +348,8 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 				     unsigned int mode)
 {
 	int ret = 0;
-	u8 bank;
-	u8 reg;
-	u8 mask;
-	u8 val;
-	bool dmr = false; /* Dedicated mode register */
+	u8 bank, reg, mask, val;
+	bool lp_mode_req = false;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
 	if (info == NULL) {
@@ -360,66 +357,54 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	if (info->shared_mode) {
-		/*
-		 * Special case where mode is shared between two regulators.
-		 */
-		struct ab8500_shared_mode *sm = info->shared_mode;
-		mutex_lock(&shared_mode_mutex);
-
-		if (mode == REGULATOR_MODE_IDLE) {
-			sm->lp_mode_req = true; /* Low power mode requested */
-			if (!((sm->shared_regulator)->
-			      shared_mode->lp_mode_req)) {
-				mutex_unlock(&shared_mode_mutex);
-				return 0; /* Other regulator prevent LP mode */
-			}
-		} else {
-			sm->lp_mode_req = false;
-		}
-	}
-
 	if (info->mode_mask) {
-		/* Dedicated register for handling mode */
-
-		dmr = true;
-
-		switch (mode) {
-		case REGULATOR_MODE_NORMAL:
-			val = info->mode_val_normal;
-			break;
-		case REGULATOR_MODE_IDLE:
-			val = info->mode_val_idle;
-			break;
-		default:
-			ret = -EINVAL;
-			goto out_unlock;
-		}
-
 		bank = info->mode_bank;
 		reg = info->mode_reg;
 		mask = info->mode_mask;
 	} else {
-		/* Mode register same as enable register */
+		bank = info->update_bank;
+		reg = info->update_reg;
+		mask = info->update_mask;
+	}
+
+	if (info->shared_mode)
+		mutex_lock(&shared_mode_mutex);
 
-		switch (mode) {
-		case REGULATOR_MODE_NORMAL:
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		if (info->shared_mode)
+			lp_mode_req = false;
+
+		if (info->mode_mask)
+			val = info->mode_val_normal;
+		else
 			val = info->update_val_normal;
-			break;
-		case REGULATOR_MODE_IDLE:
-			val = info->update_val_idle;
-			break;
-		default:
-			ret = -EINVAL;
-			goto out_unlock;
+		break;
+	case REGULATOR_MODE_IDLE:
+		if (info->shared_mode) {
+			struct ab8500_regulator_info *shared_regulator;
+
+			shared_regulator = info->shared_mode->shared_regulator;
+			if (!shared_regulator->shared_mode->lp_mode_req) {
+				/* Other regulator prevent LP mode */
+				info->shared_mode->lp_mode_req = true;
+				goto out_unlock;
+			}
+
+			lp_mode_req = true;
 		}
 
-		bank = info->update_bank;
-		reg = info->update_reg;
-		mask = info->update_mask;
+		if (info->mode_mask)
+			val = info->mode_val_idle;
+		else
+			val = info->update_val_idle;
+		break;
+	default:
+		ret = -EINVAL;
+		goto out_unlock;
 	}
 
-	if (dmr || ab8500_regulator_is_enabled(rdev)) {
+	if (info->mode_mask || ab8500_regulator_is_enabled(rdev)) {
 		ret = abx500_mask_and_set_register_interruptible(info->dev,
 			bank, reg, mask, val);
 		if (ret < 0) {
@@ -435,9 +420,12 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 			mask, val);
 	}
 
-	if (!dmr)
+	if (!info->mode_mask)
 		info->update_val = val;
 
+	if (info->shared_mode)
+		info->shared_mode->lp_mode_req = lp_mode_req;
+
 out_unlock:
 	if (info->shared_mode)
 		mutex_unlock(&shared_mode_mutex);
-- 
1.7.10.4



