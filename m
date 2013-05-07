Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab3EGOWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:22:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42114 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab3EGNkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 020/118] regulator: fixed regulator_bulk_enable unwinding code
Date: Tue,  7 May 2013 14:37:46 +0100
Message-Id: <1367933964-1564-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Hajda <a.hajda@samsung.com>

commit fbe31057fafebdc2811a7101b8b4a0460f5417d1 upstream.

Unwinding code disables all successfully enabled regulators.
Error is logged for every failed regulator.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/regulator/core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8b4b382..4a4d12e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2769,9 +2769,13 @@ int regulator_bulk_enable(int num_consumers,
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

