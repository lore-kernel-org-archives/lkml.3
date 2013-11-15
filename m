Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab3KOLnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:43:51 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35808 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab3KOLnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:43:33 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-pm@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rjw@rjwysocki.net,
        kgene.kim@samsung.com, tomasz.figa@gmail.com, yadi.brar01@gmail.com,
        sachin.kamat@linaro.org, myungjoo.ham@samsung.com,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [RFC v2 1/4] power: asv: Add common ASV support for Samsung SoCs
Date: Fri, 15 Nov 2013 17:11:28 +0530
Message-Id: <1384515691-26299-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384515691-26299-1-git-send-email-sachin.kamat@linaro.org>
References: <1384515691-26299-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yadwinder Singh Brar <yadi.brar@samsung.com>

This patch introduces a common ASV (Adaptive Supply Voltage) basic framework
for samsung SoCs. It provides common APIs (to be called by users to get ASV
values or init opp_table) and an interface for SoC specific drivers to
register ASV members (instances).

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/power/Kconfig            |    1 +
 drivers/power/Makefile           |    1 +
 drivers/power/asv/Kconfig        |   10 +++
 drivers/power/asv/Makefile       |    1 +
 drivers/power/asv/asv.c          |  176 ++++++++++++++++++++++++++++++++++++++
 include/linux/power/asv-driver.h |   62 ++++++++++++++
 include/linux/power/asv.h        |   37 ++++++++
 7 files changed, 288 insertions(+)
 create mode 100644 drivers/power/asv/Kconfig
 create mode 100644 drivers/power/asv/Makefile
 create mode 100644 drivers/power/asv/asv.c
 create mode 100644 include/linux/power/asv-driver.h
 create mode 100644 include/linux/power/asv.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 5e2054afe840..09da1fd730cd 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -385,3 +385,4 @@ source "drivers/power/reset/Kconfig"
 endif # POWER_SUPPLY
 
 source "drivers/power/avs/Kconfig"
+source "drivers/power/asv/Kconfig"
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 372b4e8ab598..788e36d37d24 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_CHARGER_BQ2415X)	+= bq2415x_charger.o
 obj-$(CONFIG_CHARGER_BQ24190)	+= bq24190_charger.o
 obj-$(CONFIG_CHARGER_BQ24735)	+= bq24735-charger.o
 obj-$(CONFIG_POWER_AVS)		+= avs/
+obj-$(CONFIG_POWER_ASV)		+= asv/
 obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
 obj-$(CONFIG_CHARGER_TPS65090)	+= tps65090-charger.o
 obj-$(CONFIG_POWER_RESET)	+= reset/
diff --git a/drivers/power/asv/Kconfig b/drivers/power/asv/Kconfig
new file mode 100644
index 000000000000..761119d9f7f8
--- /dev/null
+++ b/drivers/power/asv/Kconfig
@@ -0,0 +1,10 @@
+menuconfig POWER_ASV
+	bool "Adaptive Supply Voltage (ASV) support"
+	help
+	  ASV is a technique used on Samsung SoCs which provides the
+	  recommended supply voltage for some specific parts(like CPU, MIF, etc)
+	  that support DVFS. For a given operating frequency, the voltage is
+	  recommended based on SoCs ASV group. ASV group info is provided in the
+	  chip id info which depends on the chip manufacturing process.
+
+	  Say Y here to enable Adaptive Supply Voltage support.
diff --git a/drivers/power/asv/Makefile b/drivers/power/asv/Makefile
new file mode 100644
index 000000000000..366cb04f557b
--- /dev/null
+++ b/drivers/power/asv/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_POWER_ASV)			+= asv.o
diff --git a/drivers/power/asv/asv.c b/drivers/power/asv/asv.c
new file mode 100644
index 000000000000..3f2c31a0d3a9
--- /dev/null
+++ b/drivers/power/asv/asv.c
@@ -0,0 +1,176 @@
+/*
+ * ASV(Adaptive Supply Voltage) common core
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/io.h>
+#include <linux/pm_opp.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/power/asv-driver.h>
+
+static LIST_HEAD(asv_list);
+static DEFINE_MUTEX(asv_mutex);
+
+struct asv_member {
+	struct list_head		node;
+	struct asv_info *asv_info;
+};
+
+static void add_asv_member(struct asv_member *asv_mem)
+{
+	mutex_lock(&asv_mutex);
+	list_add_tail(&asv_mem->node, &asv_list);
+	mutex_unlock(&asv_mutex);
+}
+
+static struct asv_member *asv_get_mem(enum asv_type_id asv_type)
+{
+	struct asv_member *asv_mem;
+	struct asv_info *asv_info;
+
+	list_for_each_entry(asv_mem, &asv_list, node) {
+		asv_info = asv_mem->asv_info;
+		if (asv_type == asv_info->type)
+			return asv_mem;
+	}
+
+	return NULL;
+}
+
+unsigned int asv_get_volt(enum asv_type_id target_type,
+						unsigned int target_freq)
+{
+	struct asv_member *asv_mem = asv_get_mem(target_type);
+	struct asv_freq_table *dvfs_table;
+	struct asv_info *asv_info;
+	unsigned int i;
+
+	if (!asv_mem)
+		return 0;
+
+	asv_info = asv_mem->asv_info;
+	dvfs_table = asv_info->dvfs_table;
+
+	for (i = 0; i < asv_info->nr_dvfs_level; i++) {
+		if (dvfs_table[i].freq == target_freq)
+			return dvfs_table[i].volt;
+	}
+
+	return 0;
+}
+
+int asv_init_opp_table(struct device *dev, enum asv_type_id target_type)
+{
+	struct asv_member *asv_mem = asv_get_mem(target_type);
+	struct asv_info *asv_info;
+	struct asv_freq_table *dvfs_table;
+	unsigned int i;
+
+	if (!asv_mem)
+		return -EINVAL;
+
+	asv_info = asv_mem->asv_info;
+	dvfs_table = asv_info->dvfs_table;
+
+	for (i = 0; i < asv_info->nr_dvfs_level; i++) {
+		if (dev_pm_opp_add(dev, dvfs_table[i].freq * 1000,
+			dvfs_table[i].volt)) {
+			dev_warn(dev, "Failed to add OPP %d\n",
+				 dvfs_table[i].freq);
+			continue;
+		}
+	}
+
+	return 0;
+}
+
+static struct asv_member *asv_init_member(struct asv_info *asv_info)
+{
+	struct asv_member *asv_mem;
+	int ret = 0;
+
+	if (!asv_info) {
+		pr_err("No ASV info provided\n");
+		return NULL;
+	}
+
+	asv_mem = kzalloc(sizeof(*asv_mem), GFP_KERNEL);
+	if (!asv_mem) {
+		pr_err("Allocation failed for member: %s\n", asv_info->name);
+		return NULL;
+	}
+
+	asv_mem->asv_info = kmemdup(asv_info, sizeof(*asv_info), GFP_KERNEL);
+	if (!asv_mem->asv_info) {
+		pr_err("Copying asv_info failed for member: %s\n",
+			asv_info->name);
+		kfree(asv_mem);
+		return NULL;
+	}
+	asv_info = asv_mem->asv_info;
+
+	if (asv_info->ops->get_asv_group) {
+		ret = asv_info->ops->get_asv_group(asv_info);
+		if (ret) {
+			pr_err("get_asv_group failed for %s : %d\n",
+				asv_info->name, ret);
+			goto err;
+		}
+	}
+
+	if (asv_info->ops->init_asv)
+		ret = asv_info->ops->init_asv(asv_info);
+		if (ret) {
+			pr_err("asv_init failed for %s : %d\n",
+				asv_info->name, ret);
+			goto err;
+		}
+
+	/* In case of parsing table from DT, we may need to add flag to identify
+	DT supporting members and call init_asv_table from asv_init_opp_table(
+	after getting dev_node from dev,if required), instead of calling here.
+	*/
+
+	if (asv_info->ops->init_asv_table) {
+		ret = asv_info->ops->init_asv_table(asv_info);
+		if (ret) {
+			pr_err("init_asv_table failed for %s : %d\n",
+				asv_info->name, ret);
+			goto err;
+		}
+	}
+
+	if (!asv_info->nr_dvfs_level || !asv_info->dvfs_table) {
+		pr_err("No dvfs_table for %s\n", asv_info->name);
+		goto err;
+	}
+
+	pr_info("Registered asv member: %s with group: %d",
+		asv_info->name, asv_info->asv_grp);
+
+	return asv_mem;
+err:
+	kfree(asv_mem->asv_info);
+	kfree(asv_mem);
+	return NULL;
+}
+
+void register_asv_member(struct asv_info *list, unsigned int nr_member)
+{
+	struct asv_member *asv_mem;
+	int cnt;
+
+	for (cnt = 0; cnt < nr_member; cnt++) {
+		asv_mem = asv_init_member(&list[cnt]);
+
+		if (asv_mem)
+			add_asv_member(asv_mem);
+	}
+}
diff --git a/include/linux/power/asv-driver.h b/include/linux/power/asv-driver.h
new file mode 100644
index 000000000000..afe072cbd451
--- /dev/null
+++ b/include/linux/power/asv-driver.h
@@ -0,0 +1,62 @@
+/*
+ * Adaptive Supply Voltage Driver Header File
+ *
+ * copyright (c) 2013 samsung electronics co., ltd.
+ *		http://www.samsung.com/
+ *
+ * this program is free software; you can redistribute it and/or modify
+ * it under the terms of the gnu general public license version 2 as
+ * published by the free software foundation.
+*/
+
+#ifndef __ASV_D_H
+#define __ASV_D_H __FILE__
+
+#include <linux/power/asv.h>
+
+struct asv_freq_table {
+	unsigned int	freq;	/* KHz */
+	unsigned int	volt;	/* uV */
+};
+
+/* struct asv_info - information of ASV member for intialisation
+ *
+ * Each member to be registered should be described using this struct
+ * intialised with all required information for that member.
+ *
+ * @name: Name to use for member.
+ * @asv_type_id: Type to identify particular member.
+ * @asv_ops: Callbacks which can be used for SoC specific operations.
+ * @nr_dvfs_level: Number of dvfs levels supported by member.
+ * @dvfs_table: Table containing supported ASV freqs and corresponding volts.
+ * @asv_grp: ASV group of member.
+ * @flags: ASV flags
+ */
+struct asv_info {
+	const char		*name;
+	enum asv_type_id	type;
+	struct asv_ops		*ops;
+	unsigned int		nr_dvfs_level;
+	struct asv_freq_table	*dvfs_table;
+	unsigned int		asv_grp;
+	unsigned int		flags;
+};
+
+/* struct asv_ops - SoC specific operation for ASV members
+ * @get_asv_group - Calculates and initializes asv_grp of asv_info.
+ * @init_asv - SoC specific initialisation (if required) based on asv_grp.
+ * @init_asv_table - Initializes linear array(dvfs_table) for corresponding
+ *			asv_grp.
+ *
+ * All ops should return 0 on sucess.
+ */
+struct asv_ops {
+	int (*init_asv)(struct asv_info *);
+	int (*get_asv_group)(struct asv_info *);
+	int (*init_asv_table)(struct asv_info *);
+};
+
+/* function for registering ASV members */
+void register_asv_member(struct asv_info *list, unsigned int nr_member);
+
+#endif /* __ASV_D_H */
diff --git a/include/linux/power/asv.h b/include/linux/power/asv.h
new file mode 100644
index 000000000000..bfc4e4fa8719
--- /dev/null
+++ b/include/linux/power/asv.h
@@ -0,0 +1,37 @@
+/*
+ * Adaptive Supply Voltage Header File
+ *
+ * copyright (c) 2013 samsung electronics co., ltd.
+ *		http://www.samsung.com/
+ *
+ * this program is free software; you can redistribute it and/or modify
+ * it under the terms of the gnu general public license version 2 as
+ * published by the free software foundation.
+*/
+
+#ifndef __ASV_H
+#define __ASV_H __FILE__
+
+enum asv_type_id {
+	ASV_ARM,
+	ASV_INT,
+	ASV_MIF,
+	ASV_G3D,
+};
+
+#ifdef CONFIG_POWER_ASV
+/* asv_get_volt - get the ASV for target_freq for particular target_type.
+ *	returns 0 if target_freq is not supported
+ */
+extern unsigned int asv_get_volt(enum asv_type_id target_type,
+					unsigned int target_freq);
+extern int asv_init_opp_table(struct device *dev,
+					enum asv_type_id target_type);
+#else
+static inline unsigned int asv_get_volt(enum asv_type_id target_type,
+				unsigned int target_freq) { return 0; }
+static int asv_init_opp_table(struct device *dev, enum asv_type_id target_type)
+	{ return 0; }
+
+#endif /* CONFIG_POWER_EXYNOS_AVS */
+#endif /* __ASV_H */
-- 
1.7.9.5

