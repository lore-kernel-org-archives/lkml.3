Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaHMItd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:49:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:11365 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaHMIta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:49:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,855,1400050800"; 
   d="scan'208";a="468204498"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] perf/x86/uncore: modularize Intel uncore driver
Date: Wed, 13 Aug 2014 16:49:14 +0800
Message-Id: <1407919754-10421-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for building Intel uncore driver as module.
It adds clean-up code and config option for the Intel uncore driver.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/Makefile                  |  6 ++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 48 ++++++++++++++++++++++++---
 init/Kconfig                                  | 15 +++++++++
 3 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 7e1fd4e..2ef37fb 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -36,9 +36,11 @@ obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd_iommu.o
 endif
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o perf_event_intel_uncore_snb.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore_snbep.o perf_event_intel_uncore_nhmex.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_rapl.o
+
+obj-$(CONFIG_PERF_X86_INTEL_UNCORE)	+= perf_x86_intel_uncore.o
+perf_x86_intel_uncore-y			+= perf_event_intel_uncore.o perf_event_intel_uncore_snb.o
+perf_x86_intel_uncore-y			+= perf_event_intel_uncore_snbep.o perf_event_intel_uncore_nhmex.o
 endif
 
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 4785ee8..81bee5f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -667,6 +667,7 @@ static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
 
 	if (!pmu->type->pmu) {
 		pmu->pmu = (struct pmu) {
+			.module		= THIS_MODULE,
 			.attr_groups	= pmu->type->attr_groups,
 			.task_ctx_nr	= perf_invalid_context,
 			.event_init	= uncore_pmu_event_init,
@@ -678,6 +679,7 @@ static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
 		};
 	} else {
 		pmu->pmu = *pmu->type->pmu;
+		pmu->pmu.module = THIS_MODULE;
 		pmu->pmu.attr_groups = pmu->type->attr_groups;
 	}
 
@@ -695,7 +697,7 @@ static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
 	return ret;
 }
 
-static void __init uncore_type_exit(struct intel_uncore_type *type)
+static void uncore_type_exit(struct intel_uncore_type *type)
 {
 	int i;
 
@@ -707,7 +709,7 @@ static void __init uncore_type_exit(struct intel_uncore_type *type)
 	type->events_group = NULL;
 }
 
-static void __init uncore_types_exit(struct intel_uncore_type **types)
+static void uncore_types_exit(struct intel_uncore_type **types)
 {
 	int i;
 	for (i = 0; types[i]; i++)
@@ -916,7 +918,7 @@ static int __init uncore_pci_init(void)
 	return ret;
 }
 
-static void __init uncore_pci_exit(void)
+static void uncore_pci_exit(void)
 {
 	if (pcidrv_registered) {
 		pcidrv_registered = false;
@@ -1287,4 +1289,42 @@ static int __init intel_uncore_init(void)
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
+	for (i = 0; uncore_msr_uncores[i]; i++) {
+		type = uncore_msr_uncores[i];
+		for (j = 0; j < type->num_boxes; j++) {
+			pmu = &type->pmus[j];
+			perf_pmu_unregister(&pmu->pmu);
+		}
+	}
+
+	for (i = 0; uncore_pci_uncores[i]; i++) {
+		type = uncore_pci_uncores[i];
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
+	uncore_types_exit(uncore_msr_uncores);
+}
+
+module_init(intel_uncore_init);
+module_exit(intel_uncore_exit);
+MODULE_DESCRIPTION("Intel Uncore Performance Monitoring driver");
+MODULE_LICENSE("GPL");
diff --git a/init/Kconfig b/init/Kconfig
index 41066e4..6719207 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1553,6 +1553,21 @@ config PERF_EVENTS
 
 	  Say Y if unsure.
 
+config PERF_X86_INTEL_UNCORE
+	default n
+	tristate "Intel uncore performance monitoring support"
+	depends on PERF_EVENTS && CPU_SUP_INTEL && PCI
+	help
+	  This option allows kernel to access the Uncore performance
+	  monitoring units of Intel processors. The Uncore in Intel
+	  processors refers to subsystems in the physical processor
+	  package that are shared by multiple processor cores. Some
+	  of the subsystems in the uncore include the L3 cache, Intel
+	  QuickPath Interconnect link logic, and integrated memory
+	  controller.
+
+	  Say N if unsure.
+
 config DEBUG_PERF_USE_VMALLOC
 	default n
 	bool "Debug: use vmalloc to back perf mmap() buffers"
-- 
1.9.3

