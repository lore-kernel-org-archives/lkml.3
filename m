Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaA2Qwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:52:31 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58379 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaA2QvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:51:15 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/5] cpu: add generic support for CPU feature based module autoloading
Date: Wed, 29 Jan 2014 17:50:43 +0100
Message-Id: <1391014246-9715-3-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391014246-9715-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1391014246-9715-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for advertising optional CPU features over udev using
the modalias, and for declaring compatibility with/dependency upon such a
feature in a module.

This feature can be enabled by setting CONFIG_GENERIC_CPU_AUTOPROBE for the
architecture, and supplying a file <asm/cpufeature.h> which defines how the
numbers used in the modalias string map to actual CPU features.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/base/Kconfig              |  8 ++++++
 drivers/base/cpu.c                | 39 +++++++++++++++++++++----
 include/linux/cpufeature.h        | 60 +++++++++++++++++++++++++++++++++++++++
 include/linux/mod_devicetable.h   |  9 ++++++
 scripts/mod/devicetable-offsets.c |  3 ++
 scripts/mod/file2alias.c          | 10 +++++++
 6 files changed, 123 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/cpufeature.h

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index ec36e7772e57..3f0d3732df7f 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -185,6 +185,14 @@ config GENERIC_CPU_DEVICES
 	bool
 	default n
 
+config HAVE_CPU_AUTOPROBE
+	def_bool ARCH_HAS_CPU_AUTOPROBE
+
+config GENERIC_CPU_AUTOPROBE
+	bool
+	depends on !ARCH_HAS_CPU_AUTOPROBE
+	select HAVE_CPU_AUTOPROBE
+
 config SOC_BUS
 	bool
 
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 270649012e64..8a38bf8c792f 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -15,6 +15,7 @@
 #include <linux/percpu.h>
 #include <linux/acpi.h>
 #include <linux/of.h>
+#include <linux/cpufeature.h>
 
 #include "base.h"
 
@@ -286,12 +287,38 @@ static void cpu_device_release(struct device *dev)
 	 */
 }
 
-#ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
+#ifdef CONFIG_HAVE_CPU_AUTOPROBE
+#ifdef CONFIG_GENERIC_CPU_AUTOPROBE
+static ssize_t print_cpu_modalias(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	ssize_t n;
+	u32 i;
+
+	n = sprintf(buf, "cpu:type:" CPU_FEATURE_TYPEFMT ":feature:",
+		    CPU_FEATURE_TYPEVAL);
+
+	for (i = 0; i < MAX_CPU_FEATURES; i++)
+		if (cpu_have_feature(i)) {
+			if (PAGE_SIZE < n + sizeof(",XXXX\n")) {
+				WARN(1, "CPU features overflow page\n");
+				break;
+			}
+			n += sprintf(&buf[n], ",%04X", i);
+		}
+	buf[n++] = '\n';
+	return n;
+}
+#else
+#define print_cpu_modalias	arch_print_cpu_modalias
+#endif
+
 static int cpu_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (buf) {
-		arch_print_cpu_modalias(NULL, NULL, buf);
+		print_cpu_modalias(NULL, NULL, buf);
 		add_uevent_var(env, "MODALIAS=%s", buf);
 		kfree(buf);
 	}
@@ -319,7 +346,7 @@ int register_cpu(struct cpu *cpu, int num)
 	cpu->dev.offline_disabled = !cpu->hotpluggable;
 	cpu->dev.offline = !cpu_online(num);
 	cpu->dev.of_node = of_get_cpu_node(num, NULL);
-#ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
+#ifdef CONFIG_HAVE_CPU_AUTOPROBE
 	cpu->dev.bus->uevent = cpu_uevent;
 #endif
 	cpu->dev.groups = common_cpu_attr_groups;
@@ -343,8 +370,8 @@ struct device *get_cpu_device(unsigned cpu)
 }
 EXPORT_SYMBOL_GPL(get_cpu_device);
 
-#ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
-static DEVICE_ATTR(modalias, 0444, arch_print_cpu_modalias, NULL);
+#ifdef CONFIG_HAVE_CPU_AUTOPROBE
+static DEVICE_ATTR(modalias, 0444, print_cpu_modalias, NULL);
 #endif
 
 static struct attribute *cpu_root_attrs[] = {
@@ -357,7 +384,7 @@ static struct attribute *cpu_root_attrs[] = {
 	&cpu_attrs[2].attr.attr,
 	&dev_attr_kernel_max.attr,
 	&dev_attr_offline.attr,
-#ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
+#ifdef CONFIG_HAVE_CPU_AUTOPROBE
 	&dev_attr_modalias.attr,
 #endif
 	NULL
diff --git a/include/linux/cpufeature.h b/include/linux/cpufeature.h
new file mode 100644
index 000000000000..c4d4eb8ac9fe
--- /dev/null
+++ b/include/linux/cpufeature.h
@@ -0,0 +1,60 @@
+/*
+ * Copyright (C) 2014 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_CPUFEATURE_H
+#define __LINUX_CPUFEATURE_H
+
+#ifdef CONFIG_GENERIC_CPU_AUTOPROBE
+
+#include <linux/mod_devicetable.h>
+#include <asm/cpufeature.h>
+
+/*
+ * Macros imported from <asm/cpufeature.h>:
+ * - cpu_feature(x)		ordinal value of feature called 'x'
+ * - cpu_have_feature(u32 n)	whether feature #n is available
+ * - MAX_CPU_FEATURES		upper bound for feature ordinal values
+ * Optional:
+ * - CPU_FEATURE_TYPEFMT	format string fragment for printing the cpu type
+ * - CPU_FEATURE_TYPEVAL	set of values matching the format string above
+ */
+
+#ifndef CPU_FEATURE_TYPEFMT
+#define CPU_FEATURE_TYPEFMT	"%s"
+#endif
+
+#ifndef CPU_FEATURE_TYPEVAL
+#define CPU_FEATURE_TYPEVAL	ELF_PLATFORM
+#endif
+
+/*
+ * Use module_cpu_feature_match(feature, module_init_function) to
+ * declare that
+ * a) the module shall be probed upon discovery of CPU feature 'feature'
+ *    (typically at boot time using udev)
+ * b) the module must not be loaded if CPU feature 'feature' is not present
+ *    (not even by manual insmod).
+ *
+ * For a list of legal values for 'feature', please consult the file
+ * 'asm/cpufeature.h' of your favorite architecture.
+ */
+#define module_cpu_feature_match(x, __init)			\
+static struct cpu_feature const cpu_feature_match_ ## x[] =	\
+	{ { .feature = cpu_feature(x) }, { } };			\
+MODULE_DEVICE_TABLE(cpu, cpu_feature_match_ ## x);		\
+								\
+static int cpu_feature_match_ ## x ## _init(void)		\
+{								\
+	if (!cpu_have_feature(cpu_feature(x)))			\
+		return -ENODEV;					\
+	return __init();					\
+}								\
+module_init(cpu_feature_match_ ## x ## _init)
+
+#endif
+#endif
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 45e921401b06..f2ac87c613a5 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -564,6 +564,15 @@ struct x86_cpu_id {
 #define X86_MODEL_ANY  0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
+/*
+ * Generic table type for matching CPU features.
+ * @feature:	the bit number of the feature (0 - 65535)
+ */
+
+struct cpu_feature {
+	__u16	feature;
+};
+
 #define IPACK_ANY_FORMAT 0xff
 #define IPACK_ANY_ID (~0)
 struct ipack_device_id {
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index bb5d115ca671..f282516acc7b 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -174,6 +174,9 @@ int main(void)
 	DEVID_FIELD(x86_cpu_id, model);
 	DEVID_FIELD(x86_cpu_id, vendor);
 
+	DEVID(cpu_feature);
+	DEVID_FIELD(cpu_feature, feature);
+
 	DEVID(mei_cl_device_id);
 	DEVID_FIELD(mei_cl_device_id, name);
 
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 23708636b05c..8a69005228d8 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1135,6 +1135,16 @@ static int do_x86cpu_entry(const char *filename, void *symval,
 }
 ADD_TO_DEVTABLE("x86cpu", x86_cpu_id, do_x86cpu_entry);
 
+/* LOOKS like cpu:type:*:feature:*FEAT* */
+static int do_cpu_entry(const char *filename, void *symval, char *alias)
+{
+	DEF_FIELD(symval, cpu_feature, feature);
+
+	sprintf(alias, "cpu:type:*:feature:*%04X*", feature);
+	return 1;
+}
+ADD_TO_DEVTABLE("cpu", cpu_feature, do_cpu_entry);
+
 /* Looks like: mei:S */
 static int do_mei_entry(const char *filename, void *symval,
 			char *alias)
-- 
1.8.3.2

