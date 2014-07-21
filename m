Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbaGUPju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:39:50 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19640 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931AbaGUPjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:39:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Jul 2014 08:28:04 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, <devicetree@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, <broonie@kernel.org>
Subject: [PATCH v2 02/16] regulator: Add helpers for low-level register access
Date: Mon, 21 Jul 2014 18:38:48 +0300
Message-ID: <1405957142-19416-3-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helper functions that allow regulator consumers to obtain low-level
details about the regulator hardware, like the voltage selector register
address and such. These details can be useful when configuring hardware
or firmware that want to do low-level access to regulators, with no
involvement from the kernel.

The use-case for Tegra is a voltage-controlled oscillator clocksource
which has control logic to change the supply voltage via I2C to achieve
a desired output clock rate.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 Documentation/power/regulator/consumer.txt | 35 +++++++++++++++
 drivers/regulator/core.c                   | 71 ++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h         | 26 +++++++++++
 3 files changed, 132 insertions(+)

diff --git a/Documentation/power/regulator/consumer.txt b/Documentation/power/regulator/consumer.txt
index 55c4175..81c0e2b 100644
--- a/Documentation/power/regulator/consumer.txt
+++ b/Documentation/power/regulator/consumer.txt
@@ -180,3 +180,38 @@ int regulator_unregister_notifier(struct regulator *regulator,
 
 Regulators use the kernel notifier framework to send event to their interested
 consumers.
+
+7. Regulator Direct Register Access
+===================================
+Some kinds of power management hardware or firmware are designed such that
+they need to do low-level hardware access to regulators, with no involvement
+from the kernel. Examples of such devices are:
+
+- clocksource with a voltage-controlled oscillator and control logic to change
+  the supply voltage over I2C to achieve a desired output clock rate
+- thermal management firmware that can issue an arbitrary I2C transaction to
+  perform system poweroff during overtemperature conditions
+
+To set up such a device/firmware, various parameters like I2C address of the
+regulator, addresses of various regulator registers etc. need to be configured
+to it. The regulator framework provides the following helpers for querying
+these details.
+
+Bus-specific details, like I2C addresses or transfer rates are handled by the
+regmap framework. To get the regulator's regmap (if supported), use :-
+
+struct regmap *regulator_get_regmap(struct regulator *regulator);
+
+To obtain the hardware register offset and bitmask for the regulator's voltage
+selector register, use :-
+
+int regulator_get_hardware_vsel_register(struct regulator *regulator,
+					 unsigned *vsel_reg,
+					 unsigned *vsel_mask);
+
+To convert a regulator framework voltage selector code (used by
+regulator_list_voltage) to a hardware-specific voltage selector that can be
+directly written to the voltage selector register, use :-
+
+int regulator_list_hardware_vsel(struct regulator *regulator,
+				 unsigned selector);
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c563d93..69c9c08 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2228,6 +2228,77 @@ int regulator_list_voltage(struct regulator *regulator, unsigned selector)
 EXPORT_SYMBOL_GPL(regulator_list_voltage);
 
 /**
+ * regulator_get_regmap - get the regulator's register map
+ * @regulator: regulator source
+ *
+ * Returns the register map for the given regulator, or an ERR_PTR value
+ * if the regulator doesn't use regmap.
+ */
+struct regmap *regulator_get_regmap(struct regulator *regulator)
+{
+	struct regmap *map = regulator->rdev->regmap;
+
+	return map ? map : ERR_PTR(-EOPNOTSUPP);
+}
+
+/**
+ * regulator_get_hardware_vsel_register - get the HW voltage selector register
+ * @regulator: regulator source
+ * @vsel_reg: voltage selector register, output parameter
+ * @vsel_mask: mask for voltage selector bitfield, output parameter
+ *
+ * Returns the hardware register offset and bitmask used for setting the
+ * regulator voltage. This might be useful when configuring voltage-scaling
+ * hardware or firmware that can make I2C requests behind the kernel's back,
+ * for example.
+ *
+ * On success, the output parameters @vsel_reg and @vsel_mask are filled in
+ * and 0 is returned, otherwise a negative errno is returned.
+ */
+int regulator_get_hardware_vsel_register(struct regulator *regulator,
+					 unsigned *vsel_reg,
+					 unsigned *vsel_mask)
+{
+	struct regulator_dev	*rdev = regulator->rdev;
+	struct regulator_ops	*ops = rdev->desc->ops;
+
+	if (ops->set_voltage_sel != regulator_set_voltage_sel_regmap)
+		return -EOPNOTSUPP;
+
+	 *vsel_reg = rdev->desc->vsel_reg;
+	 *vsel_mask = rdev->desc->vsel_mask;
+
+	 return 0;
+}
+EXPORT_SYMBOL_GPL(regulator_get_hardware_vsel_register);
+
+/**
+ * regulator_list_hardware_vsel - get the HW-specific register value for a selector
+ * @regulator: regulator source
+ * @selector: identify voltage to list
+ *
+ * Converts the selector to a hardware-specific voltage selector that can be
+ * directly written to the regulator registers. The address of the voltage
+ * register can be determined by calling @regulator_get_hardware_vsel_register.
+ *
+ * On error a negative errno is returned.
+ */
+int regulator_list_hardware_vsel(struct regulator *regulator,
+				 unsigned selector)
+{
+	struct regulator_dev	*rdev = regulator->rdev;
+	struct regulator_ops	*ops = rdev->desc->ops;
+
+	if (selector >= rdev->desc->n_voltages)
+		return -EINVAL;
+	if (ops->set_voltage_sel != regulator_set_voltage_sel_regmap)
+		return -EOPNOTSUPP;
+
+	return selector;
+}
+EXPORT_SYMBOL_GPL(regulator_list_hardware_vsel);
+
+/**
  * regulator_get_linear_step - return the voltage step size between VSEL values
  * @regulator: regulator source
  *
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 14ec18d..6bb5002 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -37,6 +37,7 @@
 
 struct device;
 struct notifier_block;
+struct regmap;
 
 /*
  * Regulator operating modes.
@@ -215,6 +216,13 @@ int regulator_set_optimum_mode(struct regulator *regulator, int load_uA);
 
 int regulator_allow_bypass(struct regulator *regulator, bool allow);
 
+struct regmap *regulator_get_regmap(struct regulator *regulator);
+int regulator_get_hardware_vsel_register(struct regulator *regulator,
+					 unsigned *vsel_reg,
+					 unsigned *vsel_mask);
+int regulator_list_hardware_vsel(struct regulator *regulator,
+				 unsigned selector);
+
 /* regulator notifier block */
 int regulator_register_notifier(struct regulator *regulator,
 			      struct notifier_block *nb);
@@ -457,6 +465,24 @@ static inline int regulator_allow_bypass(struct regulator *regulator,
 	return 0;
 }
 
+struct regmap *regulator_get_regmap(struct regulator *regulator)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+int regulator_get_hardware_vsel_register(struct regulator *regulator,
+					 unsigned *vsel_reg,
+					 unsigned *vsel_mask)
+{
+	return -EOPNOTSUPP;
+}
+
+int regulator_list_hardware_vsel(struct regulator *regulator,
+				 unsigned selector)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int regulator_register_notifier(struct regulator *regulator,
 			      struct notifier_block *nb)
 {
-- 
1.8.1.5

