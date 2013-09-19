Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3ISOZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:25:13 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3702 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3ISOZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:25:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 19 Sep 2013 07:21:47 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <swarren@nvidia.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: core: set current constraints while setting machine constraints
Date: Thu, 19 Sep 2013 20:16:28 +0530
Message-ID: <1379601988-25839-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Machine constraints is configured during regulator register. If current
constraints are provided through machine constraints then it is observed
that sometime the current configured on rail is out of range what machine
constraint has.

Set the current constraints when setting machine constraints to make
sure that rail's current is within the range of given machine constraints.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/core.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b698e2b..617e337 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -904,6 +904,40 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 	return 0;
 }
 
+static int machine_constraints_current(struct regulator_dev *rdev,
+	struct regulation_constraints *constraints)
+{
+	int current_uA;
+	int ret;
+
+	if (!rdev->desc->ops->set_current_limit ||
+			!rdev->desc->ops->get_current_limit)
+		return 0;
+
+	if (!rdev->constraints->min_uA && !rdev->constraints->max_uA)
+		return 0;
+
+	if (rdev->constraints->min_uA > rdev->constraints->max_uA) {
+		rdev_err(rdev, "Current constraint is invalid\n");
+		return -EINVAL;
+	}
+
+	/* Set regulator current in constraint range */
+	current_uA = rdev->desc->ops->get_current_limit(rdev);
+	if (current_uA < rdev->constraints->min_uA ||
+			current_uA > rdev->constraints->max_uA) {
+		ret = rdev->desc->ops->set_current_limit(rdev,
+				rdev->constraints->min_uA,
+				rdev->constraints->max_uA);
+		if (ret < 0) {
+			rdev_err(rdev,
+				"Failed to set current constraint, %d\n", ret);
+			return ret;
+		}
+	}
+	return 0;
+}
+
 /**
  * set_machine_constraints - sets regulator constraints
  * @rdev: regulator source
@@ -934,6 +968,10 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	if (ret != 0)
 		goto out;
 
+	ret = machine_constraints_current(rdev, rdev->constraints);
+	if (ret != 0)
+		goto out;
+
 	/* do we need to setup our suspend state */
 	if (rdev->constraints->initial_state) {
 		ret = suspend_prepare(rdev, rdev->constraints->initial_state);
-- 
1.7.1.1

