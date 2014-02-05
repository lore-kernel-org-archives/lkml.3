Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaBEUa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:30:27 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:49016 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270AbaBEUaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:30:23 -0500
From: Bjorn Andersson <bjorn@kryo.se>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] regulator: core: Allow regulator_set_voltage for fixed regulators
Date: Wed,  5 Feb 2014 12:30:26 -0800
Message-Id: <1391632226-10060-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391493268-3242-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1391493268-3242-1-git-send-email-bjorn.andersson@sonymobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it okay to call regulator_set_voltage on regulators with fixed
voltage if the requested range overlaps the current/configured voltage.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/regulator/core.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b38a6b6..0cd1a3b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2395,6 +2395,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret = 0;
 	int old_min_uV, old_max_uV;
+	int current_uV;
 
 	mutex_lock(&rdev->mutex);
 
@@ -2405,6 +2406,19 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	if (regulator->min_uV == min_uV && regulator->max_uV == max_uV)
 		goto out;
 
+	/* If we're trying to set a range that overlaps the current voltage,
+	 * return succesfully even though the regulator does not support
+	 * changing the voltage.
+	 */
+	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
+		current_uV = _regulator_get_voltage(rdev);
+		if (min_uV <= current_uV && current_uV <= max_uV) {
+			regulator->min_uV = min_uV;
+			regulator->max_uV = max_uV;
+			goto out;
+		}
+	}
+
 	/* sanity check */
 	if (!rdev->desc->ops->set_voltage &&
 	    !rdev->desc->ops->set_voltage_sel) {
-- 
1.7.9.5

