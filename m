Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbaBUVOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:14:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59006 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbaBUVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:14:10 -0500
Date: Fri, 21 Feb 2014 13:13:36 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-b9e1ab6d4c0582cad97699285a6b3cf992251b00@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1392132015-14521-7-git-send-email-eranian@google.com>
References: <1392132015-14521-7-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/uncore: add SNB/IVB/
 HSW client uncore memory controller support
Git-Commit-ID: b9e1ab6d4c0582cad97699285a6b3cf992251b00
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9e1ab6d4c0582cad97699285a6b3cf992251b00
Gitweb:     http://git.kernel.org/tip/b9e1ab6d4c0582cad97699285a6b3cf992251b00
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 11 Feb 2014 16:20:12 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:49:08 +0100

perf/x86/uncore: add SNB/IVB/HSW client uncore memory controller support

This patch adds a new uncore PMU for Intel SNB/IVB/HSW client
CPUs. It adds the Integrated Memory Controller (IMC) PMU. This
new PMU provides a set of events to measure memory bandwidth utilization.

The IMC on those processor is PCI-space based. This patch
exposes a new uncore PMU on those processor: uncore_imc

Two new events are defined:
  - name: data_reads
  - code: 0x1
  - unit: 64 bytes
  - number of full cacheline read requests to the IMC

  - name: data_writes
  - code: 0x2
  - unit: 64 bytes
  - number of full cacheline write requests to the IMC

Documentation available at:
http://software.intel.com/en-us/articles/monitoring-integrated-memory-controller-requests-in-the-2nd-3rd-and-4th-generation-intel

Cc: mingo@elte.hu
Cc: acme@redhat.com
Cc: ak@linux.intel.com
Cc: zheng.z.yan@intel.com
Cc: peterz@infradead.org
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392132015-14521-7-git-send-email-eranian@google.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 365 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   1 +
 2 files changed, 366 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index acbbdde..66ce5e5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -66,6 +66,11 @@ DEFINE_UNCORE_FORMAT_ATTR(mask_vnw, mask_vnw, "config2:3-4");
 DEFINE_UNCORE_FORMAT_ATTR(mask0, mask0, "config2:0-31");
 DEFINE_UNCORE_FORMAT_ATTR(mask1, mask1, "config2:32-63");
 
+static void uncore_pmu_start_hrtimer(struct intel_uncore_box *box);
+static void uncore_pmu_cancel_hrtimer(struct intel_uncore_box *box);
+static void uncore_perf_event_update(struct intel_uncore_box *box, struct perf_event *event);
+static void uncore_pmu_event_read(struct perf_event *event);
+
 static struct intel_uncore_pmu *uncore_event_to_pmu(struct perf_event *event)
 {
 	return container_of(event->pmu, struct intel_uncore_pmu, pmu);
@@ -1667,6 +1672,344 @@ static struct intel_uncore_type *snb_msr_uncores[] = {
 	&snb_uncore_cbox,
 	NULL,
 };
+
+enum {
+	SNB_PCI_UNCORE_IMC,
+};
+
+static struct uncore_event_desc snb_uncore_imc_events[] = {
+	INTEL_UNCORE_EVENT_DESC(data_reads,  "event=0x01"),
+	INTEL_UNCORE_EVENT_DESC(data_reads.scale, "64"),
+	INTEL_UNCORE_EVENT_DESC(data_reads.unit, "bytes"),
+
+	INTEL_UNCORE_EVENT_DESC(data_writes, "event=0x02"),
+	INTEL_UNCORE_EVENT_DESC(data_writes.scale, "64"),
+	INTEL_UNCORE_EVENT_DESC(data_writes.unit, "bytes"),
+
+	{ /* end: all zeroes */ },
+};
+
+#define SNB_UNCORE_PCI_IMC_EVENT_MASK		0xff
+#define SNB_UNCORE_PCI_IMC_BAR_OFFSET		0x48
+
+/* page size multiple covering all config regs */
+#define SNB_UNCORE_PCI_IMC_MAP_SIZE		0x6000
+
+#define SNB_UNCORE_PCI_IMC_DATA_READS		0x1
+#define SNB_UNCORE_PCI_IMC_DATA_READS_BASE	0x5050
+#define SNB_UNCORE_PCI_IMC_DATA_WRITES		0x2
+#define SNB_UNCORE_PCI_IMC_DATA_WRITES_BASE	0x5054
+#define SNB_UNCORE_PCI_IMC_CTR_BASE		SNB_UNCORE_PCI_IMC_DATA_READS_BASE
+
+static struct attribute *snb_uncore_imc_formats_attr[] = {
+	&format_attr_event.attr,
+	NULL,
+};
+
+static struct attribute_group snb_uncore_imc_format_group = {
+	.name = "format",
+	.attrs = snb_uncore_imc_formats_attr,
+};
+
+static void snb_uncore_imc_init_box(struct intel_uncore_box *box)
+{
+	struct pci_dev *pdev = box->pci_dev;
+	u32 addr_lo, addr_hi;
+	resource_size_t addr;
+
+	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET, &addr_lo);
+	addr = addr_lo;
+
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET+4, &addr_hi);
+	addr = ((resource_size_t)addr_hi << 32) | addr_lo;
+#endif
+
+	addr &= ~(PAGE_SIZE - 1);
+
+	box->io_addr = ioremap(addr, SNB_UNCORE_PCI_IMC_MAP_SIZE);
+}
+
+static void snb_uncore_imc_enable_box(struct intel_uncore_box *box)
+{}
+
+static void snb_uncore_imc_disable_box(struct intel_uncore_box *box)
+{}
+
+static void snb_uncore_imc_enable_event(struct intel_uncore_box *box, struct perf_event *event)
+{}
+
+static void snb_uncore_imc_disable_event(struct intel_uncore_box *box, struct perf_event *event)
+{}
+
+static u64 snb_uncore_imc_read_counter(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	return (u64)*(unsigned int *)(box->io_addr + hwc->event_base);
+}
+
+/*
+ * custom event_init() function because we define our own fixed, free
+ * running counters, so we do not want to conflict with generic uncore
+ * logic. Also simplifies processing
+ */
+static int snb_uncore_imc_event_init(struct perf_event *event)
+{
+	struct intel_uncore_pmu *pmu;
+	struct intel_uncore_box *box;
+	struct hw_perf_event *hwc = &event->hw;
+	u64 cfg = event->attr.config & SNB_UNCORE_PCI_IMC_EVENT_MASK;
+	int idx, base;
+
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	pmu = uncore_event_to_pmu(event);
+	/* no device found for this pmu */
+	if (pmu->func_id < 0)
+		return -ENOENT;
+
+	/* Sampling not supported yet */
+	if (hwc->sample_period)
+		return -EINVAL;
+
+	/* unsupported modes and filters */
+	if (event->attr.exclude_user   ||
+	    event->attr.exclude_kernel ||
+	    event->attr.exclude_hv     ||
+	    event->attr.exclude_idle   ||
+	    event->attr.exclude_host   ||
+	    event->attr.exclude_guest  ||
+	    event->attr.sample_period) /* no sampling */
+		return -EINVAL;
+
+	/*
+	 * Place all uncore events for a particular physical package
+	 * onto a single cpu
+	 */
+	if (event->cpu < 0)
+		return -EINVAL;
+
+	/* check only supported bits are set */
+	if (event->attr.config & ~SNB_UNCORE_PCI_IMC_EVENT_MASK)
+		return -EINVAL;
+
+	box = uncore_pmu_to_box(pmu, event->cpu);
+	if (!box || box->cpu < 0)
+		return -EINVAL;
+
+	event->cpu = box->cpu;
+
+	event->hw.idx = -1;
+	event->hw.last_tag = ~0ULL;
+	event->hw.extra_reg.idx = EXTRA_REG_NONE;
+	event->hw.branch_reg.idx = EXTRA_REG_NONE;
+	/*
+	 * check event is known (whitelist, determines counter)
+	 */
+	switch (cfg) {
+	case SNB_UNCORE_PCI_IMC_DATA_READS:
+		base = SNB_UNCORE_PCI_IMC_DATA_READS_BASE;
+		idx = UNCORE_PMC_IDX_FIXED;
+		break;
+	case SNB_UNCORE_PCI_IMC_DATA_WRITES:
+		base = SNB_UNCORE_PCI_IMC_DATA_WRITES_BASE;
+		idx = UNCORE_PMC_IDX_FIXED + 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* must be done before validate_group */
+	event->hw.event_base = base;
+	event->hw.config = cfg;
+	event->hw.idx = idx;
+
+	/* no group validation needed, we have free running counters */
+
+	return 0;
+}
+
+static int snb_uncore_imc_hw_config(struct intel_uncore_box *box, struct perf_event *event)
+{
+	return 0;
+}
+
+static void snb_uncore_imc_event_start(struct perf_event *event, int flags)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+	u64 count;
+
+	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
+		return;
+
+	event->hw.state = 0;
+	box->n_active++;
+
+	list_add_tail(&event->active_entry, &box->active_list);
+
+	count = snb_uncore_imc_read_counter(box, event);
+	local64_set(&event->hw.prev_count, count);
+
+	if (box->n_active == 1)
+		uncore_pmu_start_hrtimer(box);
+}
+
+static void snb_uncore_imc_event_stop(struct perf_event *event, int flags)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (!(hwc->state & PERF_HES_STOPPED)) {
+		box->n_active--;
+
+		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
+		hwc->state |= PERF_HES_STOPPED;
+
+		list_del(&event->active_entry);
+
+		if (box->n_active == 0)
+			uncore_pmu_cancel_hrtimer(box);
+	}
+
+	if ((flags & PERF_EF_UPDATE) && !(hwc->state & PERF_HES_UPTODATE)) {
+		/*
+		 * Drain the remaining delta count out of a event
+		 * that we are disabling:
+		 */
+		uncore_perf_event_update(box, event);
+		hwc->state |= PERF_HES_UPTODATE;
+	}
+}
+
+static int snb_uncore_imc_event_add(struct perf_event *event, int flags)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (!box)
+		return -ENODEV;
+
+	hwc->state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+	if (!(flags & PERF_EF_START))
+		hwc->state |= PERF_HES_ARCH;
+
+	snb_uncore_imc_event_start(event, 0);
+
+	box->n_events++;
+
+	return 0;
+}
+
+static void snb_uncore_imc_event_del(struct perf_event *event, int flags)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+	int i;
+
+	snb_uncore_imc_event_stop(event, PERF_EF_UPDATE);
+
+	for (i = 0; i < box->n_events; i++) {
+		if (event == box->event_list[i]) {
+			--box->n_events;
+			break;
+		}
+	}
+}
+
+static int snb_pci2phy_map_init(int devid)
+{
+	struct pci_dev *dev = NULL;
+	int bus;
+
+	dev = pci_get_device(PCI_VENDOR_ID_INTEL, devid, dev);
+	if (!dev)
+		return -ENOTTY;
+
+	bus = dev->bus->number;
+
+	pcibus_to_physid[bus] = 0;
+
+	pci_dev_put(dev);
+
+	return 0;
+}
+
+static struct pmu snb_uncore_imc_pmu = {
+	.task_ctx_nr	= perf_invalid_context,
+	.event_init	= snb_uncore_imc_event_init,
+	.add		= snb_uncore_imc_event_add,
+	.del		= snb_uncore_imc_event_del,
+	.start		= snb_uncore_imc_event_start,
+	.stop		= snb_uncore_imc_event_stop,
+	.read		= uncore_pmu_event_read,
+};
+
+static struct intel_uncore_ops snb_uncore_imc_ops = {
+	.init_box	= snb_uncore_imc_init_box,
+	.enable_box	= snb_uncore_imc_enable_box,
+	.disable_box	= snb_uncore_imc_disable_box,
+	.disable_event	= snb_uncore_imc_disable_event,
+	.enable_event	= snb_uncore_imc_enable_event,
+	.hw_config	= snb_uncore_imc_hw_config,
+	.read_counter	= snb_uncore_imc_read_counter,
+};
+
+static struct intel_uncore_type snb_uncore_imc = {
+	.name		= "imc",
+	.num_counters   = 2,
+	.num_boxes	= 1,
+	.fixed_ctr_bits	= 32,
+	.fixed_ctr	= SNB_UNCORE_PCI_IMC_CTR_BASE,
+	.event_descs	= snb_uncore_imc_events,
+	.format_group	= &snb_uncore_imc_format_group,
+	.perf_ctr	= SNB_UNCORE_PCI_IMC_DATA_READS_BASE,
+	.event_mask	= SNB_UNCORE_PCI_IMC_EVENT_MASK,
+	.ops		= &snb_uncore_imc_ops,
+	.pmu		= &snb_uncore_imc_pmu,
+};
+
+static struct intel_uncore_type *snb_pci_uncores[] = {
+	[SNB_PCI_UNCORE_IMC]	= &snb_uncore_imc,
+	NULL,
+};
+
+static DEFINE_PCI_DEVICE_TABLE(snb_uncore_pci_ids) = {
+	{ /* IMC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SNB_IMC),
+		.driver_data = UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
+	},
+};
+
+static DEFINE_PCI_DEVICE_TABLE(ivb_uncore_pci_ids) = {
+	{ /* IMC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IVB_IMC),
+		.driver_data = UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
+	},
+};
+
+static DEFINE_PCI_DEVICE_TABLE(hsw_uncore_pci_ids) = {
+	{ /* IMC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_HSW_IMC),
+		.driver_data = UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
+	},
+};
+
+static struct pci_driver snb_uncore_pci_driver = {
+	.name		= "snb_uncore",
+	.id_table	= snb_uncore_pci_ids,
+};
+
+static struct pci_driver ivb_uncore_pci_driver = {
+	.name		= "ivb_uncore",
+	.id_table	= ivb_uncore_pci_ids,
+};
+
+static struct pci_driver hsw_uncore_pci_driver = {
+	.name		= "hsw_uncore",
+	.id_table	= hsw_uncore_pci_ids,
+};
+
 /* end of Sandy Bridge uncore support */
 
 /* Nehalem uncore support */
@@ -3501,6 +3844,28 @@ static int __init uncore_pci_init(void)
 		pci_uncores = ivt_pci_uncores;
 		uncore_pci_driver = &ivt_uncore_pci_driver;
 		break;
+	case 42: /* Sandy Bridge */
+		ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_SNB_IMC);
+		if (ret)
+			return ret;
+		pci_uncores = snb_pci_uncores;
+		uncore_pci_driver = &snb_uncore_pci_driver;
+		break;
+	case 58: /* Ivy Bridge */
+		ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_IVB_IMC);
+		if (ret)
+			return ret;
+		pci_uncores = snb_pci_uncores;
+		uncore_pci_driver = &ivb_uncore_pci_driver;
+		break;
+	case 60: /* Haswell */
+	case 69: /* Haswell Celeron */
+		ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_HSW_IMC);
+		if (ret)
+			return ret;
+		pci_uncores = snb_pci_uncores;
+		uncore_pci_driver = &hsw_uncore_pci_driver;
+		break;
 	default:
 		return 0;
 	}
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 7efd298..fbf45a0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -492,6 +492,7 @@ struct intel_uncore_box {
 	u64 hrtimer_duration; /* hrtimer timeout for this box */
 	struct hrtimer hrtimer;
 	struct list_head list;
+	void *io_addr;
 	struct intel_uncore_extra_reg shared_regs[0];
 };
 
