Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3ITHV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 03:21:29 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13724 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3ITHV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 03:21:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 20 Sep 2013 00:21:27 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <swarren@nvidia.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] regulator: core: set current constraints while setting machine constraints
Date: Fri, 20 Sep 2013 13:13:02 +0530
Message-ID: <1379662982-21327-1-git-send-email-ldewangan@nvidia.com>
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
Changes from V1:
- Correct the indentng.
- Prints warning when current-ops are not implemented.
- Set constraint current unconditionally.
- Blank line before last return.

 drivers/regulator/core.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b698e2b..bc75cb2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -904,6 +904,36 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 	return 0;
 }
 
+static int machine_constraints_current(struct regulator_dev *rdev,
+	struct regulation_constraints *constraints)
+{
+	struct regulator_ops *ops = rdev->desc->ops;
+	int ret;
+
+	if (!constraints->min_uA && !constraints->max_uA)
+		return 0;
+
+	if (constraints->min_uA > constraints->max_uA) {
+		rdev_err(rdev, "Invalid current constraints\n");
+		return -EINVAL;
+	}
+
+	if (!ops->set_current_limit || !ops->get_current_limit) {
+		rdev_warn(rdev, "Operation of current configuration missing\n");
+		return 0;
+	}
+
+	/* Set regulator current in constraints range */
+	ret = ops->set_current_limit(rdev, constraints->min_uA,
+			constraints->max_uA);
+	if (ret < 0) {
+		rdev_err(rdev, "Failed to set current constraint, %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 /**
  * set_machine_constraints - sets regulator constraints
  * @rdev: regulator source
@@ -934,6 +964,10 @@ static int set_machine_constraints(struct regulator_dev *rdev,
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

