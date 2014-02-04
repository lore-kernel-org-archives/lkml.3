Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaBDFyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 00:54:33 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:64444 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaBDFy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 00:54:27 -0500
From: Bjorn Andersson <bjorn@kryo.se>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] regulator: core: Make regulator object reflect configured voltage
Date: Mon,  3 Feb 2014 21:54:28 -0800
Message-Id: <1391493268-3242-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case when a regulator is initialized from DT with equal min and max
voltages the voltage is applied on initialization and future calls to
regulator_set_voltage fails. This behavious is different than if the regulator
is configured to be a span and therefor requires logic to handle this
difference in the consumer driver.

Eliminate this difference by populating the min_uV and max_uV of the newly
created regulator from the constraints so that calles to regulator_set_voltage
is considered no-ops and not a failure.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/regulator/core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d85f313..9c82d37 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1209,6 +1209,16 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 	    _regulator_is_enabled(rdev))
 		regulator->always_on = true;
 
+	/*
+	 * Make the regulator reflect the configured voltage selected in
+	 * machine_constraints_voltage()
+	 */
+	if (rdev->constraints->apply_uV &&
+	    rdev->constraints->min_uV == rdev->constraints->max_uV) {
+		regulator->min_uV = rdev->constraints->min_uV;
+		regulator->max_uV = rdev->constraints->min_uV;
+	}
+
 	mutex_unlock(&rdev->mutex);
 	return regulator;
 overflow_err:
-- 
1.7.9.5

