Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab3GRKyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:54:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45868 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab3GRKyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:54:05 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Thu, 18 Jul 2013 11:53:51 +0100
Message-Id: <1374144831-25622-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: core: Use the power efficient workqueue for delayed powerdown
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

There is no need to use a normal per-CPU workqueue for delayed power downs
as they're not timing or performance critical and waking up a core for them
would defeat some of the point.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b6efead..6ef476f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1891,8 +1891,9 @@ int regulator_disable_deferred(struct regulator *regulator, int ms)
 	rdev->deferred_disables++;
 	mutex_unlock(&rdev->mutex);
 
-	ret = schedule_delayed_work(&rdev->disable_work,
-				    msecs_to_jiffies(ms));
+	ret = queue_delayed_work(system_power_efficient_wq,
+				 &rdev->disable_work,
+				 msecs_to_jiffies(ms));
 	if (ret < 0)
 		return ret;
 	else
-- 
1.8.3.2

