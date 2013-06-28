Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3F1TUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:20:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41533 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3F1Sw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:52:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 005/105] regulator: fixed regulator_bulk_enable unwinding code
Date: Fri, 28 Jun 2013 11:50:27 -0700
Message-Id: <1372445527-24414-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Hajda <a.hajda@samsung.com>

commit fbe31057fafebdc2811a7101b8b4a0460f5417d1 upstream.

Unwinding code disables all successfully enabled regulators.
Error is logged for every failed regulator.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/regulator/core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5a0f54a..e56185b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3032,9 +3032,13 @@ int regulator_bulk_enable(int num_consumers,
 	return 0;
 
 err:
-	pr_err("Failed to enable %s: %d\n", consumers[i].supply, ret);
-	while (--i >= 0)
-		regulator_disable(consumers[i].consumer);
+	for (i = 0; i < num_consumers; i++) {
+		if (consumers[i].ret < 0)
+			pr_err("Failed to enable %s: %d\n", consumers[i].supply,
+			       consumers[i].ret);
+		else
+			regulator_disable(consumers[i].consumer);
+	}
 
 	return ret;
 }
-- 
1.8.1.2

