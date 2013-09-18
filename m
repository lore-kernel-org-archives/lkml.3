Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab3IRM0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:26:52 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1124 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab3IRM0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:26:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Sep 2013 05:23:28 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <swarren@nvidia.com>, <rob.herring@calxeda.com>, <mark.rutland@arm.com>,
        <rob@landley.net>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lgirdwood@gmail.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V4] regulator: core: add support for configuring turn-on time through constraints
Date: Wed, 18 Sep 2013 18:18:02 +0530
Message-ID: <1379508482-10550-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The turn-on time of the regulator depends on the regulator device's
electrical characteristics. Sometimes regulator turn-on time also
depends on the capacitive load on the given platform and it can be
more than the datasheet value.

The driver provides the enable-time as per datasheet.

Add support for configure the enable ramp time through regulator
constraints so that regulator core can take this value for enable
time for that regulator.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1: 
- Change property name to regulator-enable-ramp-delay and add more details
  in DT doc.
- add the valid pointer check for constraints before accessing it.

Changes from V2: 
- Rephrase the descripton of property regulator-enable-ramp-delay.
Changes from V3: 
- Use the description provided by Stephen to describe
  regulator-enable-ramp-delay.

 .../devicetree/bindings/regulator/regulator.txt    |    5 +++++
 drivers/regulator/core.c                           |    2 ++
 drivers/regulator/of_regulator.c                   |    6 ++++++
 include/linux/regulator/machine.h                  |    2 ++
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 2bd8f09..e2c7f1e 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -14,6 +14,11 @@ Optional properties:
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
   For hardwares which support disabling ramp rate, it should be explicitly
   intialised to zero (regulator-ramp-delay = <0>) for disabling ramp delay.
+- regulator-enable-ramp-delay: The time taken, in microseconds, for the supply
+  rail to reach the target voltage, plus/minus whatever tolerance the board
+  design requires. This property describes the total system ramp time
+  required due to the combination of internal ramping of the regulator itself,
+  and board design issues such as trace capacitance and load on the supply.
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b698e2b..4eefcc3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1167,6 +1167,8 @@ overflow_err:
 
 static int _regulator_get_enable_time(struct regulator_dev *rdev)
 {
+	if (rdev->constraints && rdev->constraints->enable_time)
+		return rdev->constraints->enable_time;
 	if (!rdev->desc->ops->enable_time)
 		return rdev->desc->enable_time;
 	return rdev->desc->ops->enable_time(rdev);
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 7827384..ea4f36f 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -23,6 +23,8 @@ static void of_get_regulation_constraints(struct device_node *np,
 	const __be32 *min_uA, *max_uA, *ramp_delay;
 	struct property *prop;
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
+	int ret;
+	u32 pval;
 
 	constraints->name = of_get_property(np, "regulator-name", NULL);
 
@@ -73,6 +75,10 @@ static void of_get_regulation_constraints(struct device_node *np,
 		else
 			constraints->ramp_disable = true;
 	}
+
+	ret = of_property_read_u32(np, "regulator-enable-ramp-delay", &pval);
+	if (!ret)
+		constraints->enable_time = pval;
 }
 
 /**
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index a9f7c55..730e638 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -95,6 +95,7 @@ struct regulator_state {
  * @initial_state: Suspend state to set by default.
  * @initial_mode: Mode to set at startup.
  * @ramp_delay: Time to settle down after voltage change (unit: uV/us)
+ * @enable_time: Turn-on time of the rails (unit: microseconds)
  */
 struct regulation_constraints {
 
@@ -129,6 +130,7 @@ struct regulation_constraints {
 	unsigned int initial_mode;
 
 	unsigned int ramp_delay;
+	unsigned int enable_time;
 
 	/* constraint flags */
 	unsigned always_on:1;	/* regulator never off when system is on */
-- 
1.7.1.1

