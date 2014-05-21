Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaEUQyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:54:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51818 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEUQyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:54:03 -0400
From: Lucas Stach <l.stach@pengutronix.de>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH] regulator: core: allow non-exact matches in regulator_set_voltage_time()
Date: Wed, 21 May 2014 18:53:59 +0200
Message-Id: <1400691239-21987-1-git-send-email-l.stach@pengutronix.de>
X-Mailer: git-send-email 2.0.0.rc0
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently this function only provides a valid output if both
old_uV and new_uV are exact voltages that can be provided by the
regulator.
This is almost impossible to achive as the consumer has
no way to know the exact voltages provided by the regulator.
Also it creates an unexpected twist in the API, as a user
could possibly not use the same voltage parameters for
set_voltage_time() as for set_voltage_time().

This breaks the current cpufreq users of this function, as they
stick in the raw voltages retrieved from their operating points,
which may or may not match one of the regulator voltages.

To make this function behave as expected employ the same logic
as used when calling set_voltage() and round the voltages to
the closest matching voltage supported by the regulator.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/regulator/core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9a09f3cdbabb..29ab83f49da9 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2477,7 +2477,7 @@ int regulator_set_voltage_time(struct regulator *regulator,
 	struct regulator_ops	*ops = rdev->desc->ops;
 	int old_sel = -1;
 	int new_sel = -1;
-	int voltage;
+	int voltage, best_match_old_uV = INT_MAX, best_match_new_uV = INT_MAX;
 	int i;
 
 	/* Currently requires operations to do this */
@@ -2486,16 +2486,19 @@ int regulator_set_voltage_time(struct regulator *regulator,
 		return -EINVAL;
 
 	for (i = 0; i < rdev->desc->n_voltages; i++) {
-		/* We only look for exact voltage matches here */
 		voltage = regulator_list_voltage(regulator, i);
 		if (voltage < 0)
 			return -EINVAL;
 		if (voltage == 0)
 			continue;
-		if (voltage == old_uV)
+		if (voltage >= old_uV && voltage < best_match_old_uV) {
 			old_sel = i;
-		if (voltage == new_uV)
+			best_match_old_uV = voltage;
+		}
+		if (voltage >= new_uV && voltage < best_match_new_uV) {
 			new_sel = i;
+			best_match_new_uV = voltage;
+		}
 	}
 
 	if (old_sel < 0 || new_sel < 0)
-- 
2.0.0.rc0

