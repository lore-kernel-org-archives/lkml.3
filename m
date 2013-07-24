Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3GXQ2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:28:13 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13047 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3GXQ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:28:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 24 Jul 2013 09:27:02 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: Joseph Lo <josephl@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH] regulator: palmas: fix pdata ptr not be updated after it has been allocated
Date: Wed, 24 Jul 2013 12:28:02 -0400
Message-ID: <1374683282-17517-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pmic platform data wasn't updated to dev.platform_data after it had
been allocated. That can cause the driver crash when using it.
This patch fixes the issue.

We need to update the pdata pointer at the end of probe because if
probe should fail for some reason, for instance if an in-supply
isn't ready yet, then probe will defer. However, the pdata is allocated
with devm, and so is freed when probe is deferred.

Based on work by Joseph Lo.

Cc: Joseph Lo <josephl@nvidia.com>
Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/regulator/palmas-regulator.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index d0c8785..e11b762 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -1027,6 +1027,8 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* Store the pdata pointer after everything else passes */
+	pdev->dev.platform_data = pdata;
 
 	return 0;
 
-- 
1.7.9.5

