Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922Ab3DGPNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 11:13:46 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61324 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860Ab3DGPNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 11:13:45 -0400
Message-ID: <1365347619.9931.3.camel@phoenix>
Subject: [PATCH 2/4] regulator: ab8500-ext: Get rid of is_enabled from
 struct ab8500_ext_regulator_info
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 07 Apr 2013 23:13:39 +0800
In-Reply-To: <1365347548.9931.1.camel@phoenix>
References: <1365347548.9931.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intention of this patch is to simplify the code.

Maintain the is_enabled flag is not trivial, it not only needs to set/clear the
flag in disable()/enable() but also needs to set the flag in is_enable() to get
initial status. The only benefit of keeping is_enabled flag is just save a
register read when set_mode(). Remove is_enabled flag makes the code simpler.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500-ext.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 57d43a1..5e604a2 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -29,7 +29,6 @@
  * @desc: regulator description
  * @rdev: regulator device
  * @cfg: regulator configuration (extension of regulator FW configuration)
- * @is_enabled: status of regulator (on/off)
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
  * @update_mask: mask to enable/disable and set mode of regulator
@@ -46,7 +45,6 @@ struct ab8500_ext_regulator_info {
 	struct regulator_desc desc;
 	struct regulator_dev *rdev;
 	struct ab8500_ext_regulator_cfg *cfg;
-	bool is_enabled;
 	u8 update_bank;
 	u8 update_reg;
 	u8 update_mask;
@@ -78,8 +76,6 @@ static int enable(struct ab8500_ext_regulator_info *info, u8 *regval)
 		return ret;
 	}
 
-	info->is_enabled = true;
-
 	return ret;
 }
 
@@ -125,8 +121,6 @@ static int disable(struct ab8500_ext_regulator_info *info, u8 *regval)
 		return ret;
 	}
 
-	info->is_enabled = false;
-
 	return ret;
 }
 
@@ -177,11 +171,9 @@ static int ab8500_ext_regulator_is_enabled(struct regulator_dev *rdev)
 
 	if (((regval & info->update_mask) == info->update_val_lp) ||
 	    ((regval & info->update_mask) == info->update_val_hp))
-		info->is_enabled = true;
+		return 1;
 	else
-		info->is_enabled = false;
-
-	return info->is_enabled;
+		return 0;
 }
 
 static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
@@ -207,7 +199,7 @@ static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	if (info->is_enabled) {
+	if (ab8500_ext_regulator_is_enabled(rdev)) {
 		u8 regval;
 
 		ret = enable(info, &regval);
-- 
1.7.10.4



