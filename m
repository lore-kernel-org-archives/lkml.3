Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935709Ab3DIMPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:15:15 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63640 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759009Ab3DIMPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:15:13 -0400
Message-ID: <1365509706.3801.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: ab8500: Don't update info->update_val if
 write to register fails
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2013 20:15:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ensures info->update_val is consistent with current register value.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index acdffc5..1866dbf 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -392,9 +392,8 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 			val = info->mode_val_idle;
 			break;
 		default:
-			if (info->shared_mode)
-				mutex_unlock(&shared_mode_mutex);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_unlock;
 		}
 
 		bank = info->mode_bank;
@@ -405,17 +404,14 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 
 		switch (mode) {
 		case REGULATOR_MODE_NORMAL:
-			info->update_val = info->update_val_normal;
 			val = info->update_val_normal;
 			break;
 		case REGULATOR_MODE_IDLE:
-			info->update_val = info->update_val_idle;
 			val = info->update_val_idle;
 			break;
 		default:
-			if (info->shared_mode)
-				mutex_unlock(&shared_mode_mutex);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_unlock;
 		}
 
 		bank = info->update_bank;
@@ -426,9 +422,11 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 	if (dmr || ab8500_regulator_is_enabled(rdev)) {
 		ret = abx500_mask_and_set_register_interruptible(info->dev,
 			bank, reg, mask, val);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(rdev_get_dev(rdev),
 				"couldn't set regulator mode\n");
+			goto out_unlock;
+		}
 
 		dev_vdbg(rdev_get_dev(rdev),
 			"%s-set_mode (bank, reg, mask, value): "
@@ -437,6 +435,10 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 			mask, val);
 	}
 
+	if (!dmr)
+		info->update_val = val;
+
+out_unlock:
 	if (info->shared_mode)
 		mutex_unlock(&shared_mode_mutex);
 
-- 
1.7.10.4



