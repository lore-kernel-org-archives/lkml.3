Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaCRI5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:57:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:59970 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741AbaCRI5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,676,1389772800"; 
   d="scan'208";a="474739840"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 4/4] perf/x86/uncore: modularize Intel uncore driver
Date: Tue, 18 Mar 2014 16:56:44 +0800
Message-Id: <1395133004-23205-4-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
References: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for building Intel uncore driver as module.
It adds clean-up code and config option for the Intel uncore driver

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/Kconfig                              |  7 ++++
 arch/x86/configs/i386_defconfig               |  1 +
 arch/x86/configs/x86_64_defconfig             |  1 +
 arch/x86/kernel/cpu/Makefile                  |  3 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 48 ++++++++++++++++++++++++---
 5 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..8e4e247 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1103,6 +1103,13 @@ config X86_CPUID
 	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
 	  /dev/cpu/31/cpuid.
 
+config X86_INTEL_UNCORE
+	tristate "Intel uncore performance monitoring support"
+	depends on CPU_SUP_INTEL
+	---help---
+	  This adds a driver to access the Uncore performance monitoring Units
+	  of Intel processors.
+
 choice
 	prompt "High Memory Support"
 	default HIGHMEM64G if X86_NUMAQ
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index a7fef26..15ad0c3 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -49,6 +49,7 @@ CONFIG_MICROCODE=y
 CONFIG_MICROCODE_AMD=y
 CONFIG_X86_MSR=y
 CONFIG_X86_CPUID=y
+CONFIG_X86_INTEL_UNCORE=y
 CONFIG_HIGHPTE=y
 CONFIG_X86_CHECK_BIOS_CORRUPTION=y
 # CONFIG_MTRR_SANITIZER is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index c1119d4..cc55ed8 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -47,6 +47,7 @@ CONFIG_MICROCODE=y
 CONFIG_MICROCODE_AMD=y
 CONFIG_X86_MSR=y
 CONFIG_X86_CPUID=y
+CONFIG_X86_INTEL_UNCORE=y
 CONFIG_NUMA=y
 CONFIG_X86_CHECK_BIOS_CORRUPTION=y
 # CONFIG_MTRR_SANITIZER is not set
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 7fd54f0..434af30 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -36,7 +36,8 @@ obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd_iommu.o
 endif
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o perf_event_intel_rapl.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_rapl.o
+obj-$(CONFIG_X86_INTEL_UNCORE)		+= perf_event_intel_uncore.o
 endif
 
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 618d502..fd5e883 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3643,6 +3643,7 @@ static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
 
 	if (!pmu->type->pmu) {
 		pmu->pmu = (struct pmu) {
+			.module		= THIS_MODULE,
 			.attr_groups	= pmu->type->attr_groups,
 			.task_ctx_nr	= perf_invalid_context,
 			.event_init	= uncore_pmu_event_init,
@@ -3654,6 +3655,7 @@ static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
 		};
 	} else {
 		pmu->pmu = *pmu->type->pmu;
+		pmu->pmu.module = THIS_MODULE;
 		pmu->pmu.attr_groups = pmu->type->attr_groups;
 	}
 
@@ -3671,7 +3673,7 @@ static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
 	return ret;
 }
 
-static void __init uncore_type_exit(struct intel_uncore_type *type)
+static void uncore_type_exit(struct intel_uncore_type *type)
 {
 	int i;
 
@@ -3683,7 +3685,7 @@ static void __init uncore_type_exit(struct intel_uncore_type *type)
 	type->events_group = NULL;
 }
 
-static void __init uncore_types_exit(struct intel_uncore_type **types)
+static void uncore_types_exit(struct intel_uncore_type **types)
 {
 	int i;
 	for (i = 0; types[i]; i++)
@@ -3910,7 +3912,7 @@ static int __init uncore_pci_init(void)
 	return ret;
 }
 
-static void __init uncore_pci_exit(void)
+static void uncore_pci_exit(void)
 {
 	if (pcidrv_registered) {
 		pcidrv_registered = false;
@@ -4293,4 +4295,42 @@ static int __init intel_uncore_init(void)
 fail:
 	return ret;
 }
-device_initcall(intel_uncore_init);
+
+static void __exit uncore_pmus_unregister(void)
+{
+	struct intel_uncore_pmu *pmu;
+	struct intel_uncore_type *type;
+	int i, j;
+
+	for (i = 0; msr_uncores[i]; i++) {
+		type = msr_uncores[i];
+		for (j = 0; j < type->num_boxes; j++) {
+			pmu = &type->pmus[j];
+			perf_pmu_unregister(&pmu->pmu);
+		}
+	}
+
+	for (i = 0; pci_uncores[i]; i++) {
+		type = pci_uncores[i];
+		for (j = 0; j < type->num_boxes; j++) {
+			pmu = &type->pmus[j];
+			perf_pmu_unregister(&pmu->pmu);
+		}
+	}
+}
+
+static void __exit intel_uncore_exit(void)
+{
+	uncore_pmus_unregister();
+
+	unregister_cpu_notifier(&uncore_cpu_nb);
+
+	uncore_pci_exit();
+
+	uncore_types_exit(msr_uncores);
+}
+
+module_init(intel_uncore_init);
+module_exit(intel_uncore_exit);
+MODULE_DESCRIPTION("Intel Uncore Performance Monitoring driver");
+MODULE_LICENSE("GPL");
-- 
1.8.5.3

