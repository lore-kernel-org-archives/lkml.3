Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaHSDoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 23:44:04 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:41461 "EHLO
	script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaHSDjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 23:39:40 -0400
X-DKIM: Courier DKIM Filter v0.50+pk-2014-03-23 mail.cs.helsinki.fi Tue, 19 Aug 2014 06:34:06 +0300
From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        devicetree@vger.kernel.org, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v3 04/15] clk: tegra: Add functions for parsing CVB tables
Date: Tue, 19 Aug 2014 06:33:14 +0300
Message-Id: <1408419205-10048-5-git-send-email-tuomas.tynkkynen@iki.fi>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
References: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

Tegra CVB tables encode the relationship between operating voltage
and optimal frequency as a function of the so-called speedo value.
The speedo value is written to the on-chip fuses at the factory,
which allows the voltage-frequency operating points to be calculated
on an per-chip basis.

Add utility functions to parse the Tegra-specific tables and export the
voltage-frequency pairs to the generic OPP framework for other drivers
to use.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 arch/arm/mach-tegra/Kconfig |   1 +
 drivers/clk/tegra/cvb.c     | 133 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/cvb.h     |  67 ++++++++++++++++++++++
 3 files changed, 201 insertions(+)
 create mode 100644 drivers/clk/tegra/cvb.c
 create mode 100644 drivers/clk/tegra/cvb.h

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 0953996..0d5832f 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -7,6 +7,7 @@ menuconfig ARCH_TEGRA
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if SMP
 	select PINCTRL
+	select PM_OPP
 	select ARCH_HAS_RESET_CONTROLLER
 	select RESET_CONTROLLER
 	select SOC_BUS
diff --git a/drivers/clk/tegra/cvb.c b/drivers/clk/tegra/cvb.c
new file mode 100644
index 0000000..69c74ee
--- /dev/null
+++ b/drivers/clk/tegra/cvb.c
@@ -0,0 +1,133 @@
+/*
+ * Utility functions for parsing Tegra CVB voltage tables
+ *
+ * Copyright (C) 2012-2014 NVIDIA Corporation.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/pm_opp.h>
+
+#include "cvb.h"
+
+/* cvb_mv = ((c2 * speedo / s_scale + c1) * speedo / s_scale + c0) */
+static inline int get_cvb_voltage(int speedo, int s_scale,
+				  const struct cvb_coefficients *cvb)
+{
+	int mv;
+
+	/* apply only speedo scale: output mv = cvb_mv * v_scale */
+	mv = DIV_ROUND_CLOSEST(cvb->c2 * speedo, s_scale);
+	mv = DIV_ROUND_CLOSEST((mv + cvb->c1) * speedo, s_scale) + cvb->c0;
+	return mv;
+}
+
+static int round_cvb_voltage(int mv, int v_scale,
+			     const struct rail_alignment *align)
+{
+	/* combined: apply voltage scale and round to cvb alignment step */
+	int uv;
+	int step = (align->step_uv ? : 1000) * v_scale;
+	int offset = align->offset_uv * v_scale;
+
+	uv = max(mv * 1000, offset) - offset;
+	uv = DIV_ROUND_UP(uv, step) * align->step_uv + align->offset_uv;
+	return uv / 1000;
+}
+
+enum {
+	DOWN,
+	UP
+};
+
+static int round_voltage(int mv, const struct rail_alignment *align, int up)
+{
+	if (align->step_uv) {
+		int uv;
+
+		uv = max(mv * 1000, align->offset_uv) - align->offset_uv;
+		uv = (uv + (up ? align->step_uv - 1 : 0)) / align->step_uv;
+		return (uv * align->step_uv + align->offset_uv) / 1000;
+	}
+	return mv;
+}
+
+static int build_opp_table(const struct cvb_table *d,
+			   int speedo_value,
+			   unsigned long max_freq,
+			   struct device *opp_dev)
+{
+	int i, ret, dfll_mv, min_mv, max_mv;
+	const struct cvb_table_freq_entry *table = NULL;
+	const struct rail_alignment *align = &d->alignment;
+
+	min_mv = round_voltage(d->min_millivolts, align, UP);
+	max_mv = round_voltage(d->max_millivolts, align, DOWN);
+
+	for (i = 0; i < MAX_DVFS_FREQS; i++) {
+		table = &d->cvb_table[i];
+		if (!table->freq || (table->freq > max_freq))
+			break;
+
+		dfll_mv = get_cvb_voltage(
+			speedo_value, d->speedo_scale, &table->coefficients);
+		dfll_mv = round_cvb_voltage(dfll_mv, d->voltage_scale, align);
+		dfll_mv = clamp(dfll_mv, min_mv, max_mv);
+
+		ret = dev_pm_opp_add(opp_dev, table->freq, dfll_mv * 1000);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * tegra_cvb_build_opp_table - build OPP table from Tegra CVB tables
+ * @cvb_tables: array of CVB tables
+ * @sz: size of the previously mentioned array
+ * @process_id: process id of the HW module
+ * @speedo_id: speedo id of the HW module
+ * @speedo_value: speedo value of the HW module
+ * @max_rate: highest safe clock rate
+ * @opp_dev: the struct device * for which the OPP table is built
+ *
+ * On Tegra, a CVB table encodes the relationship between operating voltage
+ * and safe maximal frequency for a given module (e.g. GPU or CPU). This
+ * function calculates the optimal voltage-frequency operating points
+ * for the given arguments and exports them via the OPP library for the
+ * given @opp_dev. Returns a pointer to the struct cvb_table that matched
+ * or an ERR_PTR on failure.
+ */
+const struct cvb_table *tegra_cvb_build_opp_table(
+		const struct cvb_table *cvb_tables,
+		size_t sz, int process_id,
+		int speedo_id, int speedo_value,
+		unsigned long max_rate,
+		struct device *opp_dev)
+{
+	int i, ret;
+
+	for (i = 0; i < sz; i++) {
+		const struct cvb_table *d = &cvb_tables[i];
+
+		if (d->speedo_id != -1 && d->speedo_id != speedo_id)
+			continue;
+		if (d->process_id != -1 && d->process_id != process_id)
+			continue;
+
+		ret = build_opp_table(d, speedo_value, max_rate, opp_dev);
+		return ret ? ERR_PTR(ret) : d;
+	}
+
+	return ERR_PTR(-EINVAL);
+}
diff --git a/drivers/clk/tegra/cvb.h b/drivers/clk/tegra/cvb.h
new file mode 100644
index 0000000..f62cdc4
--- /dev/null
+++ b/drivers/clk/tegra/cvb.h
@@ -0,0 +1,67 @@
+/*
+ * Utility functions for parsing Tegra CVB voltage tables
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef __DRIVERS_CLK_TEGRA_CVB_H
+#define __DRIVERS_CLK_TEGRA_CVB_H
+
+#include <linux/types.h>
+
+struct device;
+
+#define MAX_DVFS_FREQS	40
+
+struct rail_alignment {
+	int offset_uv;
+	int step_uv;
+};
+
+struct cvb_coefficients {
+	int c0;
+	int c1;
+	int c2;
+};
+
+struct cvb_table_freq_entry {
+	unsigned long freq;
+	struct cvb_coefficients coefficients;
+};
+
+struct cvb_cpu_dfll_data {
+	u32 tune0_low;
+	u32 tune0_high;
+	u32 tune1;
+};
+
+struct cvb_table {
+	int speedo_id;
+	int process_id;
+
+	int min_millivolts;
+	int max_millivolts;
+	struct rail_alignment alignment;
+
+	int speedo_scale;
+	int voltage_scale;
+	struct cvb_table_freq_entry cvb_table[MAX_DVFS_FREQS];
+	struct cvb_cpu_dfll_data cpu_dfll_data;
+};
+
+const struct cvb_table *tegra_cvb_build_opp_table(
+		const struct cvb_table *cvb_tables,
+		size_t sz, int process_id,
+		int speedo_id, int speedo_value,
+		unsigned long max_rate,
+		struct device *opp_dev);
+
+#endif
-- 
1.8.1.5

