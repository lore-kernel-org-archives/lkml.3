Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935870Ab3DHMbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:31:22 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:43152 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935851Ab3DHMbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:31:21 -0400
Message-ID: <1365424274.21989.2.camel@phoenix>
Subject: [PATCH] regulator: ab8500: Fix get_mode for shared mode regulators
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 20:31:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The special handling code for getting shared mode status is wrong
because it needs to check info->shared_mode->lp_mode_req for
both regulators that shared the same mode register.

In set_mode(), current code ensures we won't set mode to REGULATOR_MODE_IDLE
if only one of the regulator requests to set idle.

In get_mode(), we can just remove the special handling code for shared mode.
Read the register value always returns correct status no matter the regulator
has shared mode register or not.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 9ebd131..acdffc5 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -456,14 +456,6 @@ static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
 		return -EINVAL;
 	}
 
-	/* Need special handling for shared mode */
-	if (info->shared_mode) {
-		if (info->shared_mode->lp_mode_req)
-			return REGULATOR_MODE_IDLE;
-		else
-			return REGULATOR_MODE_NORMAL;
-	}
-
 	if (info->mode_mask) {
 		/* Dedicated register for handling mode */
 		ret = abx500_get_register_interruptible(info->dev,
-- 
1.7.10.4



