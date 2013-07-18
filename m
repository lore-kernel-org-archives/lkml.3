Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031Ab3GROWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 10:22:07 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51652 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab3GROWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 10:22:03 -0400
Message-ID: <1374157317.8329.1.camel@phoenix>
Subject: [PATCH] regulator: core: Allow fixed voltage range in multiple
 linear ranges
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 18 Jul 2013 22:21:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code does not allow fixed voltage range in multiple linear ranges.
If someone does set range->uV_step == 0 in one of the linear ranges, we hit
divided by zero bug. This patch fixes this issue.
For fixed voltage range, return any selector means the same voltage.
Thus just return 0.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Note: One of the use case is tps65217.

The voltage table for tps65217_vsel_to_uv1:

0  ... 24: uV = vsel * 25000 + 900000;
25 ... 52: uV = (vsel - 24) * 50000 + 1500000;
              = (vsel -25) * 50000 + 1550000;
53 ... 55: uV = (vsel - 52) * 100000 + 2900000;
              = (vsel - 53) * 100000 + 3000000;
56 ... 62: uV = 3300000;

 drivers/regulator/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b6efead..51a8077 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2437,9 +2437,15 @@ int regulator_map_voltage_linear_range(struct regulator_dev *rdev,
 		if (min_uV <= range->min_uV)
 			min_uV = range->min_uV;
 
-		ret = DIV_ROUND_UP(min_uV - range->min_uV, range->uV_step);
-		if (ret < 0)
-			return ret;
+		/* range->uV_step == 0 means fixed voltage range */
+		if (range->uV_step == 0) {
+			ret = 0;
+		} else {
+			ret = DIV_ROUND_UP(min_uV - range->min_uV,
+					   range->uV_step);
+			if (ret < 0)
+				return ret;
+		}
 
 		break;
 	}
-- 
1.8.1.2



