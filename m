Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3IJK7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 06:59:04 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13068 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3IJK67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 06:58:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 10 Sep 2013 03:58:59 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <rob.herring@calxeda.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <rob@landley.net>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lgirdwood@gmail.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] regulator: core: add support for configuring turn-on time through constraints
Date: Tue, 10 Sep 2013 16:48:08 +0530
Message-ID: <1378811888-2268-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1378811888-2268-1-git-send-email-ldewangan@nvidia.com>
References: <1378811888-2268-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Turn-ON time of the regulator depends on the regulator device's
electrical characteristics. Sometimes regulator turn-on time also
depends on the capacitive load on the given platform and it can be
more than the datasheet value.

The driver provides the enable-time as per datasheet.

Add support for configure the enable time through regulator constraints
so that regulator core can take this value for enable time for that
regulator.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 .../devicetree/bindings/regulator/regulator.txt    |    1 +
 drivers/regulator/core.c                           |    2 ++
 drivers/regulator/of_regulator.c                   |    6 ++++++
 include/linux/regulator/machine.h                  |    2 ++
 4 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 2bd8f09..f04b165 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -14,6 +14,7 @@ Optional properties:
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
   For hardwares which support disabling ramp rate, it should be explicitly
   intialised to zero (regulator-ramp-delay = <0>) for disabling ramp delay.
+- regulator-enable-time: Turn ON time for regulator(in uS)
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a01b8b3..8dea3a4 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1186,6 +1186,8 @@ overflow_err:
 
 static int _regulator_get_enable_time(struct regulator_dev *rdev)
 {
+	if (rdev->constraints->enable_time)
+		return rdev->constraints->enable_time;
 	if (!rdev->desc->ops->enable_time)
 		return rdev->desc->enable_time;
 	return rdev->desc->ops->enable_time(rdev);
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 7827384..3152c03 100644
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
+	ret = of_property_read_u32(np, "regulator-enable-time", &pval);
+	if (!ret)
+		constraints->enable_time = pval;
 }
 
 /**
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 999b20c..a9cf1af 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -95,6 +95,7 @@ struct regulator_state {
  * @initial_state: Suspend state to set by default.
  * @initial_mode: Mode to set at startup.
  * @ramp_delay: Time to settle down after voltage change (unit: uV/us)
+ * @enable_time: Turn ON time of the rails (unit: us)
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

