Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab3GHI5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:57:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36028 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3GHI5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:57:21 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Mon,  8 Jul 2013 09:15:36 +0100
Message-Id: <1373271336-29943-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: core: Drop references on supply regulator when unregistering
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e8604be..cfb17e6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3827,8 +3827,11 @@ void regulator_unregister(struct regulator_dev *rdev)
 	if (rdev == NULL)
 		return;
 
-	if (rdev->supply)
+	if (rdev->supply) {
+		while (rdev->use_count--)
+			regulator_disable(rdev->supply);
 		regulator_put(rdev->supply);
+	}
 	mutex_lock(&regulator_list_mutex);
 	debugfs_remove_recursive(rdev->debugfs);
 	flush_work(&rdev->disable_work.work);
-- 
1.8.3.2

