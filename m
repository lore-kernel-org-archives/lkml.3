Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaCTGEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 02:04:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:17573 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaCTGD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 02:03:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,692,1389772800"; 
   d="scan'208";a="476176918"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v2 4/4] perf/x86/uncore: modularize Intel uncore driver
Date: Thu, 20 Mar 2014 14:03:46 +0800
Message-Id: <1395295426-12391-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for building Intel uncore driver as module.
It adds clean-up code and config option for the Intel uncore driver

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
Changes since v1:
 move config option to "General setup/Kernel Performance Events and Counters"

 arch/x86/kernel/cpu/Makefile                  |  3 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 48 ++++++++++++++++++++++++---
 init/Kconfig                                  | 10 ++++++
 3 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 7fd54f0..5d3da70 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -36,7 +36,8 @@ obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd_iommu.o
 endif
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o perf_event_intel_rapl.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_rapl.o
+obj-$(CONFIG_PERF_X86_INTEL_UNCORE)	+= perf_event_intel_uncore.o
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
diff --git a/init/Kconfig b/init/Kconfig
index 009a797..751e06c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1502,6 +1502,16 @@ config PERF_EVENTS
 
 	  Say Y if unsure.
 
+config PERF_X86_INTEL_UNCORE
+	default y
+	tristate "Intel uncore performance monitoring support"
+	depends on PERF_EVENTS && CPU_SUP_INTEL && PCI
+	help
+	  This option allows kernel to access the Uncore performance
+	  monitoring units of Intel processors.
+
+	  Say Y if unsure.
+
 config DEBUG_PERF_USE_VMALLOC
 	default n
 	bool "Debug: use vmalloc to back perf mmap() buffers"
-- 
1.8.5.3

