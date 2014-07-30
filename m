Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaG3HWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:22:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:51911 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbaG3HWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:22:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="581054823"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 1/4] perf/x86/uncore: declare some functions and variables
Date: Wed, 30 Jul 2014 15:22:12 +0800
Message-Id: <1406704935-27708-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare for moving hardware specific code to seperate files

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 149 +++++++++++++-------------
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |  32 ++++--
 2 files changed, 98 insertions(+), 83 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index cfc6f9d..cfe2353 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1,24 +1,33 @@
 #include "perf_event_intel_uncore.h"
 
 static struct intel_uncore_type *empty_uncore[] = { NULL, };
-static struct intel_uncore_type **msr_uncores = empty_uncore;
-static struct intel_uncore_type **pci_uncores = empty_uncore;
-/* pci bus to socket mapping */
-static int pcibus_to_physid[256] = { [0 ... 255] = -1, };
+struct intel_uncore_type **uncore_msr_uncores = empty_uncore;
+struct intel_uncore_type **uncore_pci_uncores = empty_uncore;
 
-static struct pci_dev *extra_pci_dev[UNCORE_SOCKET_MAX][UNCORE_EXTRA_PCI_DEV_MAX];
+static bool pcidrv_registered;
+struct pci_driver *uncore_pci_driver;
+/* pci bus to socket mapping */
+int uncore_pcibus_to_physid[256] = { [0 ... 255] = -1, };
+struct pci_dev *uncore_extra_pci_dev[UNCORE_SOCKET_MAX][UNCORE_EXTRA_PCI_DEV_MAX];
 
 static DEFINE_RAW_SPINLOCK(uncore_box_lock);
-
 /* mask of cpus that collect uncore events */
 static cpumask_t uncore_cpu_mask;
 
 /* constraint for the fixed counter */
-static struct event_constraint constraint_fixed =
+static struct event_constraint uncore_constraint_fixed =
 	EVENT_CONSTRAINT(~0ULL, 1 << UNCORE_PMC_IDX_FIXED, ~0ULL);
-static struct event_constraint constraint_empty =
+struct event_constraint uncore_constraint_empty =
 	EVENT_CONSTRAINT(0, 0, 0);
 
+ssize_t uncore_event_show(struct kobject *kobj,
+			  struct kobj_attribute *attr, char *buf)
+{
+	struct uncore_event_desc *event =
+		container_of(attr, struct uncore_event_desc, attr);
+	return sprintf(buf, "%s", event->config);
+}
+
 #define __BITS_VALUE(x, i, n)  ((typeof(x))(((x) >> ((i) * (n))) & \
 				((1ULL << (n)) - 1)))
 
@@ -66,18 +75,12 @@ DEFINE_UNCORE_FORMAT_ATTR(mask_vnw, mask_vnw, "config2:3-4");
 DEFINE_UNCORE_FORMAT_ATTR(mask0, mask0, "config2:0-31");
 DEFINE_UNCORE_FORMAT_ATTR(mask1, mask1, "config2:32-63");
 
-static void uncore_pmu_start_hrtimer(struct intel_uncore_box *box);
-static void uncore_pmu_cancel_hrtimer(struct intel_uncore_box *box);
-static void uncore_perf_event_update(struct intel_uncore_box *box, struct perf_event *event);
-static void uncore_pmu_event_read(struct perf_event *event);
-
-static struct intel_uncore_pmu *uncore_event_to_pmu(struct perf_event *event)
+struct intel_uncore_pmu *uncore_event_to_pmu(struct perf_event *event)
 {
 	return container_of(event->pmu, struct intel_uncore_pmu, pmu);
 }
 
-static struct intel_uncore_box *
-uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
+struct intel_uncore_box *uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
 {
 	struct intel_uncore_box *box;
 
@@ -98,7 +101,7 @@ uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
 	return *per_cpu_ptr(pmu->box, cpu);
 }
 
-static struct intel_uncore_box *uncore_event_to_box(struct perf_event *event)
+struct intel_uncore_box *uncore_event_to_box(struct perf_event *event)
 {
 	/*
 	 * perf core schedules event on the basis of cpu, uncore events are
@@ -107,7 +110,7 @@ static struct intel_uncore_box *uncore_event_to_box(struct perf_event *event)
 	return uncore_pmu_to_box(uncore_event_to_pmu(event), smp_processor_id());
 }
 
-static u64 uncore_msr_read_counter(struct intel_uncore_box *box, struct perf_event *event)
+u64 uncore_msr_read_counter(struct intel_uncore_box *box, struct perf_event *event)
 {
 	u64 count;
 
@@ -119,7 +122,7 @@ static u64 uncore_msr_read_counter(struct intel_uncore_box *box, struct perf_eve
 /*
  * generic get constraint function for shared match/mask registers.
  */
-static struct event_constraint *
+struct event_constraint *
 uncore_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct intel_uncore_extra_reg *er;
@@ -154,10 +157,10 @@ uncore_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
 		return NULL;
 	}
 
-	return &constraint_empty;
+	return &uncore_constraint_empty;
 }
 
-static void uncore_put_constraint(struct intel_uncore_box *box, struct perf_event *event)
+void uncore_put_constraint(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct intel_uncore_extra_reg *er;
 	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
@@ -178,7 +181,7 @@ static void uncore_put_constraint(struct intel_uncore_box *box, struct perf_even
 	reg1->alloc = 0;
 }
 
-static u64 uncore_shared_reg_config(struct intel_uncore_box *box, int idx)
+u64 uncore_shared_reg_config(struct intel_uncore_box *box, int idx)
 {
 	struct intel_uncore_extra_reg *er;
 	unsigned long flags;
@@ -627,7 +630,7 @@ fail:
 		if (alloc & (0x1 << i))
 			atomic_sub(1 << (i * 6), &er->ref);
 	}
-	return &constraint_empty;
+	return &uncore_constraint_empty;
 }
 
 static u64 snbep_cbox_filter_mask(int fields)
@@ -746,7 +749,7 @@ again:
 			config1 = snbep_pcu_alter_er(event, idx, false);
 			goto again;
 		}
-		return &constraint_empty;
+		return &uncore_constraint_empty;
 	}
 
 	if (!uncore_box_is_fake(box)) {
@@ -841,7 +844,7 @@ static void snbep_qpi_enable_event(struct intel_uncore_box *box, struct perf_eve
 
 	if (reg1->idx != EXTRA_REG_NONE) {
 		int idx = box->pmu->pmu_idx + SNBEP_PCI_QPI_PORT0_FILTER;
-		struct pci_dev *filter_pdev = extra_pci_dev[box->phys_id][idx];
+		struct pci_dev *filter_pdev = uncore_extra_pci_dev[box->phys_id][idx];
 		WARN_ON_ONCE(!filter_pdev);
 		if (filter_pdev) {
 			pci_write_config_dword(filter_pdev, reg1->reg,
@@ -1035,7 +1038,7 @@ static int snbep_pci2phy_map_init(int devid)
 		 */
 		for (i = 0; i < 8; i++) {
 			if (nodeid == ((config >> (3 * i)) & 0x7)) {
-				pcibus_to_physid[bus] = i;
+				uncore_pcibus_to_physid[bus] = i;
 				break;
 			}
 		}
@@ -1048,10 +1051,10 @@ static int snbep_pci2phy_map_init(int devid)
 		 */
 		i = -1;
 		for (bus = 255; bus >= 0; bus--) {
-			if (pcibus_to_physid[bus] >= 0)
-				i = pcibus_to_physid[bus];
+			if (uncore_pcibus_to_physid[bus] >= 0)
+				i = uncore_pcibus_to_physid[bus];
 			else
-				pcibus_to_physid[bus] = i;
+				uncore_pcibus_to_physid[bus] = i;
 		}
 	}
 
@@ -1939,7 +1942,7 @@ static int snb_pci2phy_map_init(int devid)
 
 	bus = dev->bus->number;
 
-	pcibus_to_physid[bus] = 0;
+	uncore_pcibus_to_physid[bus] = 0;
 
 	pci_dev_put(dev);
 
@@ -2639,7 +2642,7 @@ fail:
 		nhmex_mbox_put_shared_reg(box, idx[0]);
 	if (alloc & 0x2)
 		nhmex_mbox_put_shared_reg(box, idx[1]);
-	return &constraint_empty;
+	return &uncore_constraint_empty;
 }
 
 static void nhmex_mbox_put_constraint(struct intel_uncore_box *box, struct perf_event *event)
@@ -2963,7 +2966,7 @@ again:
 		}
 		return NULL;
 	}
-	return &constraint_empty;
+	return &uncore_constraint_empty;
 }
 
 static void nhmex_rbox_put_constraint(struct intel_uncore_box *box, struct perf_event *event)
@@ -3140,7 +3143,7 @@ static void uncore_assign_hw_event(struct intel_uncore_box *box, struct perf_eve
 	hwc->event_base  = uncore_perf_ctr(box, hwc->idx);
 }
 
-static void uncore_perf_event_update(struct intel_uncore_box *box, struct perf_event *event)
+void uncore_perf_event_update(struct intel_uncore_box *box, struct perf_event *event)
 {
 	u64 prev_count, new_count, delta;
 	int shift;
@@ -3201,14 +3204,14 @@ static enum hrtimer_restart uncore_pmu_hrtimer(struct hrtimer *hrtimer)
 	return HRTIMER_RESTART;
 }
 
-static void uncore_pmu_start_hrtimer(struct intel_uncore_box *box)
+void uncore_pmu_start_hrtimer(struct intel_uncore_box *box)
 {
 	__hrtimer_start_range_ns(&box->hrtimer,
 			ns_to_ktime(box->hrtimer_duration), 0,
 			HRTIMER_MODE_REL_PINNED, 0);
 }
 
-static void uncore_pmu_cancel_hrtimer(struct intel_uncore_box *box)
+void uncore_pmu_cancel_hrtimer(struct intel_uncore_box *box)
 {
 	hrtimer_cancel(&box->hrtimer);
 }
@@ -3291,7 +3294,7 @@ uncore_get_event_constraint(struct intel_uncore_box *box, struct perf_event *eve
 	}
 
 	if (event->attr.config == UNCORE_FIXED_EVENT)
-		return &constraint_fixed;
+		return &uncore_constraint_fixed;
 
 	if (type->constraints) {
 		for_each_event_constraint(c, type->constraints) {
@@ -3496,7 +3499,7 @@ static void uncore_pmu_event_del(struct perf_event *event, int flags)
 	event->hw.last_tag = ~0ULL;
 }
 
-static void uncore_pmu_event_read(struct perf_event *event)
+void uncore_pmu_event_read(struct perf_event *event)
 {
 	struct intel_uncore_box *box = uncore_event_to_box(event);
 	uncore_perf_event_update(box, event);
@@ -3758,9 +3761,6 @@ fail:
 	return ret;
 }
 
-static struct pci_driver *uncore_pci_driver;
-static bool pcidrv_registered;
-
 /*
  * add a pci uncore device
  */
@@ -3771,17 +3771,18 @@ static int uncore_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id
 	struct intel_uncore_type *type;
 	int phys_id;
 
-	phys_id = pcibus_to_physid[pdev->bus->number];
+	phys_id = uncore_pcibus_to_physid[pdev->bus->number];
 	if (phys_id < 0)
 		return -ENODEV;
 
 	if (UNCORE_PCI_DEV_TYPE(id->driver_data) == UNCORE_EXTRA_PCI_DEV) {
-		extra_pci_dev[phys_id][UNCORE_PCI_DEV_IDX(id->driver_data)] = pdev;
+		int idx = UNCORE_PCI_DEV_IDX(id->driver_data);
+		uncore_extra_pci_dev[phys_id][idx] = pdev;
 		pci_set_drvdata(pdev, NULL);
 		return 0;
 	}
 
-	type = pci_uncores[UNCORE_PCI_DEV_TYPE(id->driver_data)];
+	type = uncore_pci_uncores[UNCORE_PCI_DEV_TYPE(id->driver_data)];
 	box = uncore_alloc_box(type, NUMA_NO_NODE);
 	if (!box)
 		return -ENOMEM;
@@ -3813,13 +3814,13 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 {
 	struct intel_uncore_box *box = pci_get_drvdata(pdev);
 	struct intel_uncore_pmu *pmu;
-	int i, cpu, phys_id = pcibus_to_physid[pdev->bus->number];
+	int i, cpu, phys_id = uncore_pcibus_to_physid[pdev->bus->number];
 
 	box = pci_get_drvdata(pdev);
 	if (!box) {
 		for (i = 0; i < UNCORE_EXTRA_PCI_DEV_MAX; i++) {
-			if (extra_pci_dev[phys_id][i] == pdev) {
-				extra_pci_dev[phys_id][i] = NULL;
+			if (uncore_extra_pci_dev[phys_id][i] == pdev) {
+				uncore_extra_pci_dev[phys_id][i] = NULL;
 				break;
 			}
 		}
@@ -3857,28 +3858,28 @@ static int __init uncore_pci_init(void)
 		ret = snbep_pci2phy_map_init(0x3ce0);
 		if (ret)
 			return ret;
-		pci_uncores = snbep_pci_uncores;
+		uncore_pci_uncores = snbep_pci_uncores;
 		uncore_pci_driver = &snbep_uncore_pci_driver;
 		break;
 	case 62: /* IvyTown */
 		ret = snbep_pci2phy_map_init(0x0e1e);
 		if (ret)
 			return ret;
-		pci_uncores = ivt_pci_uncores;
+		uncore_pci_uncores = ivt_pci_uncores;
 		uncore_pci_driver = &ivt_uncore_pci_driver;
 		break;
 	case 42: /* Sandy Bridge */
 		ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_SNB_IMC);
 		if (ret)
 			return ret;
-		pci_uncores = snb_pci_uncores;
+		uncore_pci_uncores = snb_pci_uncores;
 		uncore_pci_driver = &snb_uncore_pci_driver;
 		break;
 	case 58: /* Ivy Bridge */
 		ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_IVB_IMC);
 		if (ret)
 			return ret;
-		pci_uncores = snb_pci_uncores;
+		uncore_pci_uncores = snb_pci_uncores;
 		uncore_pci_driver = &ivb_uncore_pci_driver;
 		break;
 	case 60: /* Haswell */
@@ -3886,14 +3887,14 @@ static int __init uncore_pci_init(void)
 		ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_HSW_IMC);
 		if (ret)
 			return ret;
-		pci_uncores = snb_pci_uncores;
+		uncore_pci_uncores = snb_pci_uncores;
 		uncore_pci_driver = &hsw_uncore_pci_driver;
 		break;
 	default:
 		return 0;
 	}
 
-	ret = uncore_types_init(pci_uncores);
+	ret = uncore_types_init(uncore_pci_uncores);
 	if (ret)
 		return ret;
 
@@ -3904,7 +3905,7 @@ static int __init uncore_pci_init(void)
 	if (ret == 0)
 		pcidrv_registered = true;
 	else
-		uncore_types_exit(pci_uncores);
+		uncore_types_exit(uncore_pci_uncores);
 
 	return ret;
 }
@@ -3914,7 +3915,7 @@ static void __init uncore_pci_exit(void)
 	if (pcidrv_registered) {
 		pcidrv_registered = false;
 		pci_unregister_driver(uncore_pci_driver);
-		uncore_types_exit(pci_uncores);
+		uncore_types_exit(uncore_pci_uncores);
 	}
 }
 
@@ -3940,8 +3941,8 @@ static void uncore_cpu_dying(int cpu)
 	struct intel_uncore_box *box;
 	int i, j;
 
-	for (i = 0; msr_uncores[i]; i++) {
-		type = msr_uncores[i];
+	for (i = 0; uncore_msr_uncores[i]; i++) {
+		type = uncore_msr_uncores[i];
 		for (j = 0; j < type->num_boxes; j++) {
 			pmu = &type->pmus[j];
 			box = *per_cpu_ptr(pmu->box, cpu);
@@ -3961,8 +3962,8 @@ static int uncore_cpu_starting(int cpu)
 
 	phys_id = topology_physical_package_id(cpu);
 
-	for (i = 0; msr_uncores[i]; i++) {
-		type = msr_uncores[i];
+	for (i = 0; uncore_msr_uncores[i]; i++) {
+		type = uncore_msr_uncores[i];
 		for (j = 0; j < type->num_boxes; j++) {
 			pmu = &type->pmus[j];
 			box = *per_cpu_ptr(pmu->box, cpu);
@@ -4002,8 +4003,8 @@ static int uncore_cpu_prepare(int cpu, int phys_id)
 	struct intel_uncore_box *box;
 	int i, j;
 
-	for (i = 0; msr_uncores[i]; i++) {
-		type = msr_uncores[i];
+	for (i = 0; uncore_msr_uncores[i]; i++) {
+		type = uncore_msr_uncores[i];
 		for (j = 0; j < type->num_boxes; j++) {
 			pmu = &type->pmus[j];
 			if (pmu->func_id < 0)
@@ -4083,8 +4084,8 @@ static void uncore_event_exit_cpu(int cpu)
 	if (target >= 0)
 		cpumask_set_cpu(target, &uncore_cpu_mask);
 
-	uncore_change_context(msr_uncores, cpu, target);
-	uncore_change_context(pci_uncores, cpu, target);
+	uncore_change_context(uncore_msr_uncores, cpu, target);
+	uncore_change_context(uncore_pci_uncores, cpu, target);
 }
 
 static void uncore_event_init_cpu(int cpu)
@@ -4099,8 +4100,8 @@ static void uncore_event_init_cpu(int cpu)
 
 	cpumask_set_cpu(cpu, &uncore_cpu_mask);
 
-	uncore_change_context(msr_uncores, -1, cpu);
-	uncore_change_context(pci_uncores, -1, cpu);
+	uncore_change_context(uncore_msr_uncores, -1, cpu);
+	uncore_change_context(uncore_pci_uncores, -1, cpu);
 }
 
 static int uncore_cpu_notifier(struct notifier_block *self,
@@ -4168,18 +4169,18 @@ static int __init uncore_cpu_init(void)
 	case 30:
 	case 37: /* Westmere */
 	case 44:
-		msr_uncores = nhm_msr_uncores;
+		uncore_msr_uncores = nhm_msr_uncores;
 		break;
 	case 42: /* Sandy Bridge */
 	case 58: /* Ivy Bridge */
 		if (snb_uncore_cbox.num_boxes > max_cores)
 			snb_uncore_cbox.num_boxes = max_cores;
-		msr_uncores = snb_msr_uncores;
+		uncore_msr_uncores = snb_msr_uncores;
 		break;
 	case 45: /* Sandy Bridge-EP */
 		if (snbep_uncore_cbox.num_boxes > max_cores)
 			snbep_uncore_cbox.num_boxes = max_cores;
-		msr_uncores = snbep_msr_uncores;
+		uncore_msr_uncores = snbep_msr_uncores;
 		break;
 	case 46: /* Nehalem-EX */
 		uncore_nhmex = true;
@@ -4188,19 +4189,19 @@ static int __init uncore_cpu_init(void)
 			nhmex_uncore_mbox.event_descs = wsmex_uncore_mbox_events;
 		if (nhmex_uncore_cbox.num_boxes > max_cores)
 			nhmex_uncore_cbox.num_boxes = max_cores;
-		msr_uncores = nhmex_msr_uncores;
+		uncore_msr_uncores = nhmex_msr_uncores;
 		break;
 	case 62: /* IvyTown */
 		if (ivt_uncore_cbox.num_boxes > max_cores)
 			ivt_uncore_cbox.num_boxes = max_cores;
-		msr_uncores = ivt_msr_uncores;
+		uncore_msr_uncores = ivt_msr_uncores;
 		break;
 
 	default:
 		return 0;
 	}
 
-	ret = uncore_types_init(msr_uncores);
+	ret = uncore_types_init(uncore_msr_uncores);
 	if (ret)
 		return ret;
 
@@ -4213,16 +4214,16 @@ static int __init uncore_pmus_register(void)
 	struct intel_uncore_type *type;
 	int i, j;
 
-	for (i = 0; msr_uncores[i]; i++) {
-		type = msr_uncores[i];
+	for (i = 0; uncore_msr_uncores[i]; i++) {
+		type = uncore_msr_uncores[i];
 		for (j = 0; j < type->num_boxes; j++) {
 			pmu = &type->pmus[j];
 			uncore_pmu_register(pmu);
 		}
 	}
 
-	for (i = 0; pci_uncores[i]; i++) {
-		type = pci_uncores[i];
+	for (i = 0; uncore_pci_uncores[i]; i++) {
+		type = uncore_pci_uncores[i];
 		for (j = 0; j < type->num_boxes; j++) {
 			pmu = &type->pmus[j];
 			uncore_pmu_register(pmu);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 90236f0..e5b5fd7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -505,6 +505,9 @@ struct uncore_event_desc {
 	const char *config;
 };
 
+ssize_t uncore_event_show(struct kobject *kobj,
+			  struct kobj_attribute *attr, char *buf);
+
 #define INTEL_UNCORE_EVENT_DESC(_name, _config)			\
 {								\
 	.attr	= __ATTR(_name, 0444, uncore_event_show, NULL),	\
@@ -522,15 +525,6 @@ static ssize_t __uncore_##_var##_show(struct kobject *kobj,		\
 static struct kobj_attribute format_attr_##_var =			\
 	__ATTR(_name, 0444, __uncore_##_var##_show, NULL)
 
-
-static ssize_t uncore_event_show(struct kobject *kobj,
-				struct kobj_attribute *attr, char *buf)
-{
-	struct uncore_event_desc *event =
-		container_of(attr, struct uncore_event_desc, attr);
-	return sprintf(buf, "%s", event->config);
-}
-
 static inline unsigned uncore_pci_box_ctl(struct intel_uncore_box *box)
 {
 	return box->pmu->type->box_ctl;
@@ -694,3 +688,23 @@ static inline bool uncore_box_is_fake(struct intel_uncore_box *box)
 {
 	return (box->phys_id < 0);
 }
+
+struct intel_uncore_pmu *uncore_event_to_pmu(struct perf_event *event);
+struct intel_uncore_box *uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu);
+struct intel_uncore_box *uncore_event_to_box(struct perf_event *event);
+u64 uncore_msr_read_counter(struct intel_uncore_box *box, struct perf_event *event);
+void uncore_pmu_start_hrtimer(struct intel_uncore_box *box);
+void uncore_pmu_cancel_hrtimer(struct intel_uncore_box *box);
+void uncore_pmu_event_read(struct perf_event *event);
+void uncore_perf_event_update(struct intel_uncore_box *box, struct perf_event *event);
+struct event_constraint *
+uncore_get_constraint(struct intel_uncore_box *box, struct perf_event *event);
+void uncore_put_constraint(struct intel_uncore_box *box, struct perf_event *event);
+u64 uncore_shared_reg_config(struct intel_uncore_box *box, int idx);
+
+extern struct intel_uncore_type **uncore_msr_uncores;
+extern struct intel_uncore_type **uncore_pci_uncores;
+extern struct pci_driver *uncore_pci_driver;
+extern int uncore_pcibus_to_physid[256];
+extern struct pci_dev *uncore_extra_pci_dev[UNCORE_SOCKET_MAX][UNCORE_EXTRA_PCI_DEV_MAX];
+extern struct event_constraint uncore_constraint_empty;
-- 
1.9.3

