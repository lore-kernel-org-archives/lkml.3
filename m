Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaBFKv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:51:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:28140 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837AbaBFKv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:51:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="470754175"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v1 10/11] x86: perf: intel_bts: Add BTS PMU driver
Date: Thu,  6 Feb 2014 12:50:33 +0200
Message-Id: <1391683834-29868-11-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Branch Trace Store (BTS) via kernel perf/itrace event
infrastructure. The difference with the existing implementation of BTS
support is that this one is a separate PMU that exports events' trace
buffers to userspace the same way as Intel PT PMU does. The immediate
benefit is that the buffer size can be much bigger, resulting in fewer
interrupts and no kernel side copying is involved. Also, of the kernel
code is possible. Additionally, it is now possible to include BTS traces
into process core dumps.

The old way of collecting BTS traces still works.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 arch/x86/kernel/cpu/Makefile               |   2 +-
 arch/x86/kernel/cpu/perf_event.h           |   6 +
 arch/x86/kernel/cpu/perf_event_intel.c     |   6 +-
 arch/x86/kernel/cpu/perf_event_intel_bts.c | 478 +++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   3 +-
 5 files changed, 492 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_bts.c

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index cb69de3..29f7f32 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -37,7 +37,7 @@ endif
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o perf_event_intel_rapl.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_pt.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_pt.o perf_event_intel_bts.o
 endif
 
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index c1a8618..00b1ffb 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -702,6 +702,12 @@ void intel_pmu_lbr_init_snb(void);
 
 int intel_pmu_setup_lbr_filter(struct perf_event *event);
 
+int intel_bts_interrupt(void);
+
+void intel_bts_enable_local(void);
+
+void intel_bts_disable_local(void);
+
 int p4_pmu_init(void);
 
 int p6_pmu_init(void);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 28b5023..e447972 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1052,6 +1052,8 @@ static void intel_pmu_disable_all(void)
 
 	if (test_bit(INTEL_PMC_IDX_FIXED_BTS, cpuc->active_mask))
 		intel_pmu_disable_bts();
+	else
+		intel_bts_disable_local();
 
 	intel_pmu_pebs_disable_all();
 	intel_pmu_lbr_disable_all();
@@ -1074,7 +1076,8 @@ static void intel_pmu_enable_all(int added)
 			return;
 
 		intel_pmu_enable_bts(event->hw.config);
-	}
+	} else
+		intel_bts_enable_local();
 }
 
 /*
@@ -1362,6 +1365,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 		apic_write(APIC_LVTPC, APIC_DM_NMI);
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
+	handled += intel_bts_interrupt();
 	status = intel_pmu_get_status();
 	if (!status) {
 		intel_pmu_enable_all(0);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_bts.c b/arch/x86/kernel/cpu/perf_event_intel_bts.c
new file mode 100644
index 0000000..0a08969
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_bts.c
@@ -0,0 +1,478 @@
+/*
+ * BTS PMU driver for perf
+ * Copyright (c) 2013-2014, Intel Corporation.
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
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#undef DEBUG
+
+#include <linux/bitops.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/coredump.h>
+#include <linux/itrace.h>
+
+#include <asm-generic/sizes.h>
+#include <asm/perf_event.h>
+
+#include "perf_event.h"
+
+static struct dentry *bts_dir_dent;
+static struct dentry *bts_poison_dent;
+
+static u32 poison;
+
+struct bts_ctx {
+	raw_spinlock_t		lock;
+	struct perf_event	*event;
+	struct debug_store	ds_back;
+};
+
+static DEFINE_PER_CPU(struct bts_ctx, bts_ctx);
+
+#define BTS_RECORD_SIZE		24
+
+struct bts_buffer {
+	void		*buf;
+	void		**data_pages;
+	size_t		size;		/* multiple of PAGE_SIZE */
+	size_t		real_size;	/* multiple of BTS_RECORD_SIZE */
+	unsigned long	round;
+	unsigned long	index;
+	unsigned long	watermark;
+	bool		snapshot;
+	local64_t	head;
+	struct perf_event_mmap_page	*user_page;
+};
+
+static struct dentry *bts_poison_dent;
+struct itrace_pmu bts_pmu;
+
+void intel_pmu_enable_bts(u64 config);
+void intel_pmu_disable_bts(void);
+
+/* add tsc to the bts buffer for the benefit of the decoder */
+#define BTS_SYNTH_TSC	BIT(1)
+#define BTS_CONFIG_MASK	BTS_SYNTH_TSC
+
+PMU_FORMAT_ATTR(tsc,		"itrace_config:1"	);
+
+static struct attribute *bts_formats_attr[] = {
+	&format_attr_tsc.attr,
+	NULL,
+};
+
+static struct attribute_group bts_format_group = {
+	.name	= "format",
+	.attrs	= bts_formats_attr,
+};
+
+static const struct attribute_group *bts_attr_groups[] = {
+	&bts_format_group,
+	NULL,
+};
+
+static void *
+bts_buffer_itrace_alloc(int cpu, int nr_pages, bool overwrite, void **pages,
+			struct perf_event_mmap_page **user_page)
+{
+	struct bts_buffer *buf;
+	struct page *up = NULL, *page;
+	int node = (cpu == -1) ? cpu : cpu_to_node(cpu);
+	size_t size = nr_pages << PAGE_SHIFT;
+	int i, order;
+
+	if (!is_power_of_2(nr_pages))
+		return NULL;
+
+	buf = kzalloc(sizeof(struct bts_buffer), GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->snapshot = overwrite;
+
+	buf->size = size;
+	buf->real_size = size - size % BTS_RECORD_SIZE;
+	order = get_order(buf->size);
+
+	if (user_page) {
+		*user_page = NULL;
+		up = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+		if (!up)
+			goto err_buf;
+	}
+
+	buf->data_pages = pages;
+
+	page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_NORETRY, order);
+	if (!page)
+		goto err_up;
+
+	buf->buf = page_address(page);
+	split_page(page, order);
+
+	for (i = 0; i < nr_pages; i++)
+		buf->data_pages[i] = buf->buf + PAGE_SIZE * i;
+
+	if (!overwrite)
+		buf->watermark = buf->real_size / 2;
+	if (user_page) {
+		buf->user_page = page_address(up);
+		*user_page = page_address(up);
+	}
+
+	return buf;
+
+err_up:
+	__free_page(up);
+err_buf:
+	kfree(buf);
+
+	return NULL;
+}
+
+static void bts_buffer_itrace_free(void *data)
+{
+	struct bts_buffer *buf = data;
+	int i;
+
+	for (i = 0; i < buf->size >> PAGE_SHIFT; i++) {
+		struct page *page = virt_to_page(buf->data_pages[i]);
+		page->mapping = NULL;
+		__free_page(page);
+	}
+	if (buf->user_page) {
+		struct page *up = virt_to_page(buf->user_page);
+
+		up->mapping = NULL;
+		__free_page(up);
+	}
+
+	kfree(buf);
+}
+
+static void
+bts_config_buffer(int cpu, void *buf, size_t size, unsigned long thresh,
+		  unsigned long index)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+
+	ds->bts_buffer_base = (u64)buf;
+	ds->bts_index = ds->bts_buffer_base + index;
+	ds->bts_absolute_maximum = ds->bts_buffer_base + size;
+	ds->bts_interrupt_threshold = thresh
+		? ds->bts_buffer_base + thresh - 0x180 /* arbitrary */
+		: ds->bts_absolute_maximum + BTS_RECORD_SIZE;
+}
+
+static bool bts_buffer_is_full(struct bts_buffer *buf)
+{
+	unsigned long tailoff, headoff = local64_read(&buf->head);
+
+	if (buf->snapshot)
+		return false;
+
+	tailoff = ACCESS_ONCE(buf->user_page->data_tail);
+	smp_mb();
+
+	if (headoff <= tailoff || headoff - tailoff < buf->real_size)
+		return false;
+
+	return true;
+}
+
+static void bts_wake_up(struct perf_event *event)
+{
+	struct bts_buffer *buf = itrace_priv(event);
+
+	if (!buf || buf->snapshot)
+		return;
+	if (bts_buffer_is_full(buf)) {
+		event->pending_disable = 1;
+		event->pending_kill = POLL_IN;
+		event->pending_wakeup = 1;
+		event->hw.state = PERF_HES_STOPPED;
+	}
+
+	if (event->pending_disable || event->pending_kill)
+		itrace_wake_up(event);
+}
+
+static void bts_update(struct perf_event *event)
+{
+	int cpu = raw_smp_processor_id();
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+	struct bts_buffer *buf = itrace_priv(event);
+	unsigned long index = ds->bts_index - ds->bts_buffer_base;
+	int lost = 0;
+
+	if (WARN_ONCE(!buf, "no buffer\n"))
+		return;
+
+	smp_wmb();
+	if (buf->snapshot)
+		local64_set(&buf->head, index);
+	else {
+		if (index >= buf->real_size) {
+			buf->round++;
+			index = 0;
+			lost++;
+		}
+
+		local64_set(&buf->head, buf->round * buf->real_size + index);
+		if (lost)
+			itrace_lost_data(event, local64_read(&buf->head));
+	}
+
+	if (buf->user_page) {
+		buf->user_page->data_head = local64_read(&buf->head);
+		smp_wmb();
+	}
+}
+
+static void bts_timestamp(struct perf_event *event)
+{
+	struct debug_store *ds = __get_cpu_var(cpu_hw_events).ds;
+	u64 tsc, *wp = (void *)ds->bts_index;
+
+	rdtscll(tsc);
+	*wp++ = 0xffffffffull;
+	*wp++ = tsc;
+	*wp++ = 1;
+	ds->bts_index += BTS_RECORD_SIZE;
+	bts_update(event);
+	bts_wake_up(event);
+}
+
+static void bts_event_start(struct perf_event *event, int flags)
+{
+	struct bts_buffer *buf = itrace_priv(event);
+	int cpu = raw_smp_processor_id();
+	unsigned long index, thresh = 0;
+	u64 config = 0;
+
+	if (!buf) {
+		event->hw.state = PERF_HES_STOPPED;
+		return;
+	}
+
+	event->hw.state = 0;
+
+	if (!buf->snapshot)
+		config |= ARCH_PERFMON_EVENTSEL_INT;
+	if (!event->attr.exclude_kernel)
+		config |= ARCH_PERFMON_EVENTSEL_OS;
+	if (!event->attr.exclude_user)
+		config |= ARCH_PERFMON_EVENTSEL_USR;
+
+	index = local64_read(&buf->head) % buf->real_size;
+	if (buf->watermark)
+		thresh = ((index + buf->watermark) / buf->watermark) * buf->watermark;
+	else
+		thresh = buf->real_size;
+
+	bts_config_buffer(cpu, buf->buf, thresh, buf->snapshot ? 0 : thresh,
+			  index);
+
+	if (event->attr.itrace_config & BTS_SYNTH_TSC) {
+		bts_timestamp(event);
+		if (event->hw.state == PERF_HES_STOPPED)
+			return;
+	}
+
+	wmb();
+
+	intel_pmu_enable_bts(config);
+}
+
+static void bts_event_stop(struct perf_event *event, int flags)
+{
+	if (event->hw.state == PERF_HES_STOPPED)
+		return;
+
+	event->hw.state = PERF_HES_STOPPED;
+	intel_pmu_disable_bts();
+
+	if (flags & PERF_EF_UPDATE) {
+		bts_update(event);
+		bts_wake_up(event);
+	}
+}
+
+void intel_bts_enable_local(void)
+{
+	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
+
+	if (bts->event)
+		bts_event_start(bts->event, 0);
+}
+
+void intel_bts_disable_local(void)
+{
+	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
+
+	if (bts->event)
+		bts_event_stop(bts->event, 0);
+}
+
+int intel_bts_interrupt(void)
+{
+	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
+	struct bts_buffer *buf;
+	s64 old_head;
+
+	if (!bts->event)
+		return 0;
+
+	buf = itrace_priv(bts->event);
+	if (WARN_ONCE(!buf, "no buffer"))
+		return 0;
+
+	old_head = local64_read(&buf->head);
+	bts_update(bts->event);
+	if (old_head != local64_read(&buf->head)) {
+		bts_wake_up(bts->event);
+		return 1;
+	}
+
+	return 0;
+}
+
+static void bts_event_del(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
+
+	bts_event_stop(event, PERF_EF_UPDATE);
+
+	raw_spin_lock(&bts->lock);
+	bts->event = NULL;
+	cpuc->ds->bts_index = bts->ds_back.bts_buffer_base;
+	cpuc->ds->bts_buffer_base = bts->ds_back.bts_buffer_base;
+	cpuc->ds->bts_absolute_maximum = bts->ds_back.bts_absolute_maximum;
+	cpuc->ds->bts_interrupt_threshold = bts->ds_back.bts_interrupt_threshold;
+	raw_spin_unlock(&bts->lock);
+
+	itrace_event_put(event);
+}
+
+static int bts_event_add(struct perf_event *event, int flags)
+{
+	struct bts_buffer *buf;
+	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+	int ret = 0;
+
+	if (test_bit(INTEL_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
+		hwc->state = PERF_HES_STOPPED;
+		return -EINVAL;
+	}
+
+	buf = itrace_event_get_priv(event);
+	if (!buf) {
+		hwc->state = PERF_HES_STOPPED;
+		return -EINVAL;
+	}
+
+	raw_spin_lock(&bts->lock);
+	if (bts->event) {
+		raw_spin_unlock(&bts->lock);
+		itrace_event_put(event);
+		ret = -EBUSY;
+		event->hw.state = PERF_HES_STOPPED;
+		goto out;
+	}
+
+	bts->event = event;
+	bts->ds_back.bts_buffer_base = cpuc->ds->bts_buffer_base;
+	bts->ds_back.bts_absolute_maximum = cpuc->ds->bts_absolute_maximum;
+	bts->ds_back.bts_interrupt_threshold = cpuc->ds->bts_interrupt_threshold;
+	raw_spin_unlock(&bts->lock);
+
+	hwc->state = !(flags & PERF_EF_START);
+	if (!hwc->state) {
+		bts_event_start(event, 0);
+		if (hwc->state == PERF_HES_STOPPED) {
+			bts_event_del(event, 0);
+			bts_wake_up(event);
+			ret = -EBUSY;
+		}
+	}
+
+out:
+	return ret;
+}
+
+static int bts_event_init(struct perf_event *event)
+{
+	u64 config = event->attr.itrace_config;
+
+	if (event->attr.type != bts_pmu.pmu.type)
+		return -ENOENT;
+
+	if ((config & BTS_CONFIG_MASK) != config)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void bts_event_read(struct perf_event *event)
+{
+}
+
+static __init int bts_init(void)
+{
+	int ret, cpu;
+
+	if (!boot_cpu_has(X86_FEATURE_DTES64) || !x86_pmu.bts)
+		return -ENODEV;
+
+	get_online_cpus();
+	for_each_possible_cpu(cpu) {
+		raw_spin_lock_init(&per_cpu(bts_ctx, cpu).lock);
+	}
+	put_online_cpus();
+
+	bts_pmu.pmu.attr_groups		= bts_attr_groups;
+	bts_pmu.pmu.task_ctx_nr		= perf_hw_context;
+	bts_pmu.pmu.event_init		= bts_event_init;
+	bts_pmu.pmu.add			= bts_event_add;
+	bts_pmu.pmu.del			= bts_event_del;
+	bts_pmu.pmu.start		= bts_event_start;
+	bts_pmu.pmu.stop		= bts_event_stop;
+	bts_pmu.pmu.read		= bts_event_read;
+	bts_pmu.alloc_buffer		= bts_buffer_itrace_alloc;
+	bts_pmu.free_buffer		= bts_buffer_itrace_free;
+	bts_pmu.name			= "intel_bts";
+
+	ret = itrace_pmu_register(&bts_pmu);
+	if (ret)
+		return ret;
+
+	bts_dir_dent = debugfs_create_dir("intel_bts", NULL);
+	bts_poison_dent = debugfs_create_bool("poison", S_IRUSR | S_IWUSR,
+					      bts_dir_dent, &poison);
+
+	if (IS_ERR(bts_dir_dent) || IS_ERR(bts_poison_dent))
+		pr_warn("Can't create debugfs entries.\n");
+
+	return 0;
+}
+
+module_init(bts_init);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ae96cfa..21f799f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -444,7 +444,8 @@ void intel_pmu_enable_bts(u64 config)
 
 	debugctlmsr |= DEBUGCTLMSR_TR;
 	debugctlmsr |= DEBUGCTLMSR_BTS;
-	debugctlmsr |= DEBUGCTLMSR_BTINT;
+	if (config & ARCH_PERFMON_EVENTSEL_INT)
+		debugctlmsr |= DEBUGCTLMSR_BTINT;
 
 	if (!(config & ARCH_PERFMON_EVENTSEL_OS))
 		debugctlmsr |= DEBUGCTLMSR_BTS_OFF_OS;
-- 
1.8.5.2

