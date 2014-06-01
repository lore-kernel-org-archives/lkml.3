Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaFASQC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 14:16:02 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50143 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaFASQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 14:16:00 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Sun,  1 Jun 2014 19:15:48 +0100
Message-Id: <1401646548-27150-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.0.0.rc4
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: Don't disable unused regulators we don't have permission for
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

In the spirit of conservatism that governs our general approach to
permissions it is better if we don't touch regulators we weren't explicitly
given permissions to control. This avoids the need to explicitly specify
unknown regulators in DT as always on, if a regulator is not otherwise
involved in software control it can be omitted from the DT.

Regulators explicitly given constraints in DT still need to have an always
on constraint specified as before.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index af7a17677f3d..d7f111781867 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3822,8 +3822,9 @@ static int __init regulator_init_complete(void)
 	mutex_lock(&regulator_list_mutex);
 
 	/* If we have a full configuration then disable any regulators
-	 * which are not in use or always_on.  This will become the
-	 * default behaviour in the future.
+	 * we have permission to change the status for and which are
+	 * not in use or always_on.  This is effectively the default
+	 * for DT and ACPI as they have full constraints.
 	 */
 	list_for_each_entry(rdev, &regulator_list, list) {
 		ops = rdev->desc->ops;
@@ -3832,6 +3833,9 @@ static int __init regulator_init_complete(void)
 		if (c && c->always_on)
 			continue;
 
+		if (c && !(c->valid_ops_mask & REGULATOR_CHANGE_STATUS))
+			continue;
+
 		mutex_lock(&rdev->mutex);
 
 		if (rdev->use_count)
-- 
2.0.0.rc4

