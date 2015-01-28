Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452AbbA1ADY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:03:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:39631 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbbA1ABv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:01:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,477,1418112000"; 
   d="scan'208";a="677052493"
From: Vikas Shivappa <vikas.shivappa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vikas.shivappa@intel.com, vikas.shivappa@linux.intel.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        peterz@infradead.org, matt.fleming@intel.com, will.auld@intel.com
Subject: [PATCH 1/6] x86/intel_cat: Intel Cache Allocation Technology detection
Date: Tue, 27 Jan 2015 16:00:04 -0800
Message-Id: <1422403209-15533-2-git-send-email-vikas.shivappa@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
References: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the new Cache Allocation Technology (CAT)
feature found in future Intel Xeon processors.  It includes CPUID
enumeration routines for CAT and new values to track CAT resources to
the cpuinfo_x86 structure.

Cache Allocation Technology(CAT) provides a way for the Software
(OS/VMM) to restrict cache allocation to a defined 'subset' of cache
which may be overlapping with other 'subsets'.  This feature is used
when allocating a line in cache ie when pulling new data into the cache.
The programming of the h/w is done via programming  MSRs.

More information about CAT be found in the Intel (R) x86 Architecture
Software Developer Manual, section 17.15.

Signed-off-by: Vikas Shivappa <vikas.shivappa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |  6 ++++-
 arch/x86/include/asm/processor.h  |  3 +++
 arch/x86/kernel/cpu/Makefile      |  1 +
 arch/x86/kernel/cpu/common.c      | 16 ++++++++++++
 arch/x86/kernel/cpu/intel_cat.c   | 51 +++++++++++++++++++++++++++++++++++++++
 init/Kconfig                      | 11 +++++++++
 6 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/cpu/intel_cat.c

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 54fd8eb..358b15b 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -12,7 +12,7 @@
 #include <asm/disabled-features.h>
 #endif
 
-#define NCAPINTS	13	/* N 32-bit words worth of info */
+#define NCAPINTS	14	/* N 32-bit words worth of info */
 #define NBUGINTS	1	/* N 32-bit bug flags */
 
 /*
@@ -227,6 +227,7 @@
 #define X86_FEATURE_RTM		( 9*32+11) /* Restricted Transactional Memory */
 #define X86_FEATURE_CQM		( 9*32+12) /* Cache QoS Monitoring */
 #define X86_FEATURE_MPX		( 9*32+14) /* Memory Protection Extension */
+#define X86_FEATURE_CAT		( 9*32+15) /* Cache QOS Enforcement */
 #define X86_FEATURE_AVX512F	( 9*32+16) /* AVX-512 Foundation */
 #define X86_FEATURE_RDSEED	( 9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		( 9*32+19) /* The ADCX and ADOX instructions */
@@ -248,6 +249,9 @@
 /* Intel-defined CPU QoS Sub-leaf, CPUID level 0x0000000F:1 (edx), word 12 */
 #define X86_FEATURE_CQM_OCCUP_LLC (12*32+ 0) /* LLC occupancy monitoring if 1 */
 
+/* Intel-defined CPU features, CPUID level 0x00000010:0 (ebx), word 13 */
+#define X86_FEATURE_CAT_L3	(13*32 + 1) /*Cache QOS Enforcement L3*/
+
 /*
  * BUG word(s)
  */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 242ceed..62863e9 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -112,6 +112,9 @@ struct cpuinfo_x86 {
 	/* Cache QoS architectural values: */
 	int			x86_cache_max_rmid;	/* max index */
 	int			x86_cache_occ_scale;	/* scale to bytes */
+	/* Cache Allocation Technology values */
+	int			x86_cat_cbmlength;
+	int			x86_cat_closs;
 	int			x86_power;
 	unsigned long		loops_per_jiffy;
 	/* cpuid returned max cores value: */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6c1ca13..f008cd8 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_PERF_EVENTS_INTEL_UNCORE)	+= perf_event_intel_uncore.o \
 					   perf_event_intel_uncore_nhmex.o
 endif
 
+obj-$(CONFIG_CGROUP_CAT) 		+=intel_cat.o
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9b0fb70..18e8d75 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -668,6 +668,22 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		}
 	}
 
+	/* Additional Intel-defined flags: level 0x00000010 */
+	if (c->cpuid_level >= 0x00000010) {
+		u32 eax, ebx, ecx, edx;
+
+		cpuid_count(0x00000010, 0, &eax, &ebx, &ecx, &edx);
+		c->x86_capability[13] = ebx;
+
+		if (cpu_has(c, X86_FEATURE_CAT) &&
+			   cpu_has(c, X86_FEATURE_CAT_L3)) {
+
+			cpuid_count(0x00000010, 1, &eax, &ebx, &ecx, &edx);
+			c->x86_cat_closs = (edx & 0xffff) + 1;
+			c->x86_cat_cbmlength = (eax & 0xf) + 1;
+		}
+	}
+
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;
diff --git a/arch/x86/kernel/cpu/intel_cat.c b/arch/x86/kernel/cpu/intel_cat.c
new file mode 100644
index 0000000..2f4b19b
--- /dev/null
+++ b/arch/x86/kernel/cpu/intel_cat.c
@@ -0,0 +1,51 @@
+/*
+ * Processor Cache Allocation Technology(CAT) code
+ *
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * 2014-09-10 Written by Vikas Shivappa
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * More information about CAT be found in the Intel (R) x86 Architecture
+ * Software Developer Manual, section 17.15.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+
+static inline bool cat_supported(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_CAT_L3))
+		return true;
+
+	return false;
+}
+
+static int __init cat_late_init(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	int maxid, cbmlen;
+
+	if (!cat_supported(c))
+		return -ENODEV;
+
+	maxid = c->x86_cat_closs;
+	cbmlen = c->x86_cat_cbmlength;
+
+	pr_info("cbmlength:%u,Closs: %u\n", cbmlen, maxid);
+
+	return 0;
+}
+
+late_initcall(cat_late_init);
diff --git a/init/Kconfig b/init/Kconfig
index 9afb971..475b7b7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -961,6 +961,17 @@ config CPUSETS
 
 	  Say N if unsure.
 
+config CGROUP_CAT
+  bool "Cache Allocation Technology cgroup subsystem"
+  depends on X86_64
+	help
+	  This option provides framework to allocate cache lines when
+	  applications fill cache.
+	  This can be used by users to configure how much cache that can be
+	  allocated to different PIDs.
+
+	  Say N if unsure.
+
 config PROC_PID_CPUSET
 	bool "Include legacy /proc/<pid>/cpuset file"
 	depends on CPUSETS
-- 
1.9.1

