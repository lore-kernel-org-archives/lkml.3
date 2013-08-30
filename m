Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3H3MHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:07:44 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:42150 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3H3MHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:07:43 -0400
Message-ID: <1377864458.12097.2.camel@phoenix>
Subject: [PATCH 1/2] regulator: da9063: Optimize da9063_set_current_limit
 implementation
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 20:07:38 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the current limit tables have the values in ascend order.
So we can slightly optimize the for loop iteration because the first match
is the minimal value.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9063-regulator.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index fc2871cb..f29e729 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -166,22 +166,15 @@ static int da9063_set_current_limit(struct regulator_dev *rdev,
 {
 	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
 	const struct da9063_regulator_info *rinfo = regl->info;
-	int val = INT_MAX;
-	unsigned sel = 0;
-	int n;
-	int tval;
+	int n, tval;
 
 	for (n = 0; n < rinfo->n_current_limits; n++) {
 		tval = rinfo->current_limits[n];
-		if (tval >= min_uA && tval <= max_uA && val > tval) {
-			val = tval;
-			sel = n;
-		}
+		if (tval >= min_uA && tval <= max_uA)
+			return regmap_field_write(regl->ilimit, n);
 	}
-	if (val == INT_MAX)
-		return -EINVAL;
 
-	return regmap_field_write(regl->ilimit, sel);
+	return -EINVAL;
 }
 
 static int da9063_get_current_limit(struct regulator_dev *rdev)
-- 
1.8.1.2



