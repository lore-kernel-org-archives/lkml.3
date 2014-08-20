Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaHTMpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:45:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:58164 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbaHTMp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:45:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,902,1400050800"; 
   d="scan'208";a="561071549"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v4 15/22] x86: perf: intel_bts: Add BTS PMU driver
Date: Wed, 20 Aug 2014 15:36:12 +0300
Message-Id: <1408538179-792-16-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Branch Trace Store (BTS) via kernel perf event infrastructure.
The difference with the existing implementation of BTS support is that this
one is a separate PMU that exports events' trace buffers to userspace by means
of AUX area of the perf buffer, which is zero-copy mapped into userspace.

The immediate benefit is that the buffer size can be much bigger, resulting in
fewer interrupts and no kernel side copying is involved and little to no trace
data loss. Also, kernel code can be traced with this driver.

The old way of collecting BTS traces still works.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 arch/x86/kernel/cpu/Makefile               |   2 +-
 arch/x86/kernel/cpu/perf_event.h           |   6 +
 arch/x86/kernel/cpu/perf_event_intel.c     |   6 +-
 arch/x86/kernel/cpu/perf_event_intel_bts.c | 501 +++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   3 +-
 5 files changed, 515 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_bts.c

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 00d40f889d..387223c716 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -39,7 +39,7 @@ obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o per
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o perf_event_intel_uncore_snb.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore_snbep.o perf_event_intel_uncore_nhmex.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_rapl.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_pt.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_pt.o perf_event_intel_bts.o
 endif
 
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 2f41d0db42..73424d3139 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -751,6 +751,12 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event);
 
 void intel_pt_interrupt(void);
 
+int intel_bts_interrupt(void);
+
+void intel_bts_enable_local(void);
+
+void intel_bts_disable_local(void);
+
 int p4_pmu_init(void);
 
 int p6_pmu_init(void);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6f8025053d..2f54bcfd6f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1051,6 +1051,8 @@ static void intel_pmu_disable_all(void)
 
 	if (test_bit(INTEL_PMC_IDX_FIXED_BTS, cpuc->active_mask))
 		intel_pmu_disable_bts();
+	else
+		intel_bts_disable_local();
 
 	intel_pmu_pebs_disable_all();
 	intel_pmu_lbr_disable_all();
@@ -1073,7 +1075,8 @@ static void intel_pmu_enable_all(int added)
 			return;
 
 		intel_pmu_enable_bts(event->hw.config);
-	}
+	} else
+		intel_bts_enable_local();
 }
 
 /*
@@ -1359,6 +1362,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 		apic_write(APIC_LVTPC, APIC_DM_NMI);
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
+	handled += intel_bts_interrupt();
 	status = intel_pmu_get_status();
 	if (!status)
 		goto done;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_bts.c b/arch/x86/kernel/cpu/perf_event_intel_bts.c
new file mode 100644
index 0000000000..d0b749b719
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_bts.c
@@ -0,0 +1,501 @@
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
+ */
+
+#undef DEBUG
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/bitops.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/coredump.h>
+
+#include <asm-generic/sizes.h>
+#include <asm/perf_event.h>
+
+#include "perf_event.h"
+
+struct bts_ctx {
+	raw_spinlock_t			lock;
+	struct perf_output_handle	handle;
+	struct debug_store		ds_back;
+};
+
+static DEFINE_PER_CPU(struct bts_ctx, bts_ctx);
+
+#define BTS_RECORD_SIZE		24
+#define BTS_SAFETY_MARGIN	4080
+
+struct bts_phys {
+	struct page	*page;
+	unsigned long	size;
+	unsigned long	offset;
+	unsigned long	displacement;
+};
+
+struct bts_buffer {
+	size_t		real_size;	/* multiple of BTS_RECORD_SIZE */
+	unsigned int	nr_pages;
+	unsigned int	nr_bufs;
+	unsigned int	cur_buf;
+	unsigned long	index;
+	bool		snapshot;
+	local_t		data_size;
+	local_t		lost;
+	local_t		head;
+	unsigned long	end;
+	void		**data_pages;
+	struct bts_phys	buf[0];
+};
+
+struct pmu bts_pmu;
+
+void intel_pmu_enable_bts(u64 config);
+void intel_pmu_disable_bts(void);
+
+static size_t buf_size(struct page *page)
+{
+	return 1 << (PAGE_SHIFT + page_private(page));
+}
+
+static void *
+bts_buffer_setup_aux(int cpu, void **pages, int nr_pages, bool overwrite)
+{
+	struct bts_buffer *buf;
+	struct page *page;
+	int node = (cpu == -1) ? cpu : cpu_to_node(cpu);
+	unsigned long offset;
+	size_t size = nr_pages << PAGE_SHIFT;
+	int pg, nbuf, pad;
+
+	/* count all the high order buffers */
+	for (pg = 0, nbuf = 0; pg < nr_pages;) {
+		page = virt_to_page(pages[pg]);
+		if (WARN_ON_ONCE(!PagePrivate(page) && nr_pages > 1))
+			return NULL;
+		pg += 1 << page_private(page);
+		nbuf++;
+	}
+
+	/*
+	 * to avoid interrupts in overwrite mode, only allow one physical
+	 */
+	if (overwrite && nbuf > 1)
+		return NULL;
+
+	buf = kzalloc_node(offsetof(struct bts_buffer, buf[nbuf]), GFP_KERNEL, node);
+	if (!buf)
+		return NULL;
+
+	buf->nr_pages = nr_pages;
+	buf->nr_bufs = nbuf;
+	buf->snapshot = overwrite;
+	buf->data_pages = pages;
+	buf->real_size = size - size % BTS_RECORD_SIZE;
+
+	for (pg = 0, nbuf = 0, offset = 0, pad = 0; nbuf < buf->nr_bufs; nbuf++) {
+		unsigned int __nr_pages;
+
+		page = virt_to_page(pages[pg]);
+		__nr_pages = PagePrivate(page) ? 1 << page_private(page) : 1;
+		buf->buf[nbuf].page = page;
+		buf->buf[nbuf].offset = offset;
+		buf->buf[nbuf].displacement = (pad ? BTS_RECORD_SIZE - pad : 0);
+		buf->buf[nbuf].size = buf_size(page) - buf->buf[nbuf].displacement;
+		pad = buf->buf[nbuf].size % BTS_RECORD_SIZE;
+		buf->buf[nbuf].size -= pad;
+
+		pg += __nr_pages;
+		offset += __nr_pages << PAGE_SHIFT;
+	}
+
+	return buf;
+}
+
+static void bts_buffer_free_aux(void *data)
+{
+	kfree(data);
+}
+
+static unsigned long bts_buffer_offset(struct bts_buffer *buf, unsigned int idx)
+{
+	return buf->buf[idx].offset + buf->buf[idx].displacement;
+}
+
+static unsigned long
+bts_buffer_advance(struct bts_buffer *buf, unsigned long head)
+{
+	buf->cur_buf++;
+	if (buf->cur_buf == buf->nr_bufs) {
+		buf->cur_buf = 0;
+		head = 0;
+	} else {
+		head = bts_buffer_offset(buf, buf->cur_buf);
+	}
+
+	return head;
+}
+
+static void
+bts_config_buffer(struct bts_buffer *buf)
+{
+	int cpu = raw_smp_processor_id();
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+	struct bts_phys *phys = &buf->buf[buf->cur_buf];
+	unsigned long index, thresh = 0, end = phys->size;
+	struct page *page = phys->page;
+
+	index = local_read(&buf->head);
+
+	if (!buf->snapshot) {
+		if (buf->end < phys->offset + buf_size(page))
+			end = buf->end - phys->offset - phys->displacement;
+
+		index -= phys->offset + phys->displacement;
+
+		thresh = end - BTS_RECORD_SIZE;
+		if (end - index > BTS_SAFETY_MARGIN)
+			thresh -= BTS_SAFETY_MARGIN;
+	}
+
+	ds->bts_buffer_base = (u64)page_address(page) + phys->displacement;
+	ds->bts_index = ds->bts_buffer_base + index;
+	ds->bts_absolute_maximum = ds->bts_buffer_base + end;
+	ds->bts_interrupt_threshold = !buf->snapshot
+		? ds->bts_buffer_base + thresh
+		: ds->bts_absolute_maximum + BTS_RECORD_SIZE;
+}
+
+static bool bts_buffer_is_full(struct bts_buffer *buf, struct bts_ctx *bts)
+{
+	if (buf->snapshot)
+		return false;
+
+	if (local_read(&buf->data_size) >= bts->handle.size ||
+	    bts->handle.size - local_read(&buf->data_size) < BTS_RECORD_SIZE)
+		return true;
+
+	return false;
+}
+
+static void bts_update(struct bts_ctx *bts)
+{
+	int cpu = raw_smp_processor_id();
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+	struct bts_buffer *buf = perf_get_aux(&bts->handle);
+	unsigned long index = ds->bts_index - ds->bts_buffer_base, old, head;
+
+	if (!buf)
+		return;
+
+	head = index + bts_buffer_offset(buf, buf->cur_buf);
+
+	if (!buf->snapshot) {
+		struct bts_phys *phys = &buf->buf[buf->cur_buf];
+		int advance = 0;
+
+		if (phys->size - index < BTS_RECORD_SIZE) {
+			advance++;
+			local_inc(&buf->lost);
+		} else if (phys->size - index < BTS_SAFETY_MARGIN) {
+			advance++;
+			memset((void *)ds->bts_index, 0, phys->size - index);
+		}
+
+		if (advance)
+			head = bts_buffer_advance(buf, head);
+
+		old = local_xchg(&buf->head, head);
+		if (!head)
+		  head = buf->real_size;
+
+		local_add(head - old, &buf->data_size);
+	} else {
+		local_set(&buf->data_size, head);
+	}
+}
+
+static void bts_event_start(struct perf_event *event, int flags)
+{
+	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
+	struct bts_buffer *buf = perf_get_aux(&bts->handle);
+	u64 config = 0;
+
+	if (!buf || bts_buffer_is_full(buf, bts)) {
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
+	bts_config_buffer(buf);
+
+	wmb();
+
+	intel_pmu_enable_bts(config);
+}
+
+static void bts_event_stop(struct perf_event *event, int flags)
+{
+	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
+
+	if (event->hw.state == PERF_HES_STOPPED)
+		return;
+
+	event->hw.state = PERF_HES_STOPPED;
+	intel_pmu_disable_bts();
+
+	if (flags & PERF_EF_UPDATE)
+		bts_update(bts);
+}
+
+void intel_bts_enable_local(void)
+{
+	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
+
+	if (bts->handle.event)
+		bts_event_start(bts->handle.event, 0);
+}
+
+void intel_bts_disable_local(void)
+{
+	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
+
+	if (bts->handle.event)
+		bts_event_stop(bts->handle.event, 0);
+}
+
+static int
+bts_buffer_reset(struct bts_buffer *buf, struct perf_output_handle *handle)
+{
+	unsigned long pad, size;
+	struct bts_phys *phys;
+	int ret, little_room = 0;
+
+	handle->head &= ((buf->nr_pages << PAGE_SHIFT) - 1);
+	pad = (buf->nr_pages << PAGE_SHIFT) - handle->head;
+	if (pad > BTS_RECORD_SIZE) {
+		pad = handle->head % BTS_RECORD_SIZE;
+		if (pad)
+			pad = BTS_RECORD_SIZE - pad;
+	}
+
+	if (pad) {
+		ret = perf_aux_output_skip(handle, pad);
+		if (ret)
+			return ret;
+		handle->head &= ((buf->nr_pages << PAGE_SHIFT) - 1);
+	}
+
+	if (handle->wakeup - handle->head < BTS_RECORD_SIZE)
+		size = handle->size;
+	else
+		size = handle->wakeup - handle->head;
+	size = (size / BTS_RECORD_SIZE) * BTS_RECORD_SIZE;
+
+	if (size < BTS_SAFETY_MARGIN)
+		little_room++;
+
+	/* figure out index offset in the current buffer */
+	for (buf->cur_buf = 0, phys = &buf->buf[buf->cur_buf];
+	     handle->head >= phys->offset + phys->displacement + phys->size;
+	     phys = &buf->buf[++buf->cur_buf])
+		;
+	if (WARN_ON_ONCE(buf->cur_buf == buf->nr_bufs))
+		return -EINVAL;
+
+	pad = phys->offset + phys->displacement + phys->size - handle->head;
+	if (!little_room && pad < BTS_SAFETY_MARGIN) {
+		memset(page_address(phys->page) + phys->displacement + handle->head, 0, pad);
+		ret = perf_aux_output_skip(handle, pad);
+		if (ret)
+			return ret;
+		handle->head = bts_buffer_advance(buf, handle->head);
+	}
+
+	local_set(&buf->data_size, 0);
+	local_set(&buf->head, handle->head);
+	buf->end = min(handle->head + size, buf->real_size);
+
+	return 0;
+}
+
+int intel_bts_interrupt(void)
+{
+	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
+	struct perf_event *event = bts->handle.event;
+	struct bts_buffer *buf;
+	s64 old_head;
+	int err;
+
+	if (!event)
+		return 0;
+
+	buf = perf_get_aux(&bts->handle);
+	/*
+	 * Skip snapshot counters: they don't use the interrupt, but
+	 * there's no other way of telling, because the pointer will
+	 * keep moving
+	 */
+	if (!buf || buf->snapshot)
+		return 0;
+
+	old_head = local_read(&buf->head);
+	bts_update(bts);
+
+	perf_aux_output_end(&bts->handle, local_xchg(&buf->data_size, 0),
+			    !!local_xchg(&buf->lost, 0));
+	if (old_head == local_read(&buf->head))
+		return 0;
+
+	buf = perf_aux_output_begin(&bts->handle, event);
+	if (!buf) {
+		event->hw.state = PERF_HES_STOPPED;
+		return 1;
+	}
+
+	err = bts_buffer_reset(buf, &bts->handle);
+	if (err) {
+		event->hw.state = PERF_HES_STOPPED;
+		perf_aux_output_end(&bts->handle, 0, true);
+	}
+
+	return 1;
+}
+
+static void bts_event_del(struct perf_event *event, int mode)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
+	struct bts_buffer *buf = perf_get_aux(&bts->handle);
+	unsigned long flags;
+
+	bts_event_stop(event, PERF_EF_UPDATE);
+
+	raw_spin_lock_irqsave(&bts->lock, flags);
+	if (bts->handle.event)
+		perf_aux_output_end(&bts->handle, local_xchg(&buf->data_size, 0),
+				    !!local_xchg(&buf->lost, 0));
+	cpuc->ds->bts_index = bts->ds_back.bts_buffer_base;
+	cpuc->ds->bts_buffer_base = bts->ds_back.bts_buffer_base;
+	cpuc->ds->bts_absolute_maximum = bts->ds_back.bts_absolute_maximum;
+	cpuc->ds->bts_interrupt_threshold = bts->ds_back.bts_interrupt_threshold;
+	raw_spin_unlock_irqrestore(&bts->lock, flags);
+}
+
+static int bts_event_add(struct perf_event *event, int mode)
+{
+	struct bts_buffer *buf;
+	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned long flags;
+	int ret = -EBUSY;
+
+	if (test_bit(INTEL_PMC_IDX_FIXED_BTS, cpuc->active_mask))
+		goto err;
+
+	if (cpuc->pt_enabled)
+		goto err;
+
+	raw_spin_lock_irqsave(&bts->lock, flags);
+	if (bts->handle.event)
+		goto err_unlock;
+
+	buf = perf_aux_output_begin(&bts->handle, event);
+	if (!buf) {
+		ret = -EINVAL;
+		goto err_unlock;
+	}
+
+	ret = bts_buffer_reset(buf, &bts->handle);
+	if (ret) {
+		perf_aux_output_end(&bts->handle, 0, true);
+		goto err_unlock;
+	}
+
+	bts->ds_back.bts_buffer_base = cpuc->ds->bts_buffer_base;
+	bts->ds_back.bts_absolute_maximum = cpuc->ds->bts_absolute_maximum;
+	bts->ds_back.bts_interrupt_threshold = cpuc->ds->bts_interrupt_threshold;
+	raw_spin_unlock_irqrestore(&bts->lock, flags);
+
+	hwc->state = !(mode & PERF_EF_START);
+	if (!hwc->state) {
+		bts_event_start(event, 0);
+		if (hwc->state == PERF_HES_STOPPED) {
+			bts_event_del(event, 0);
+			ret = -EBUSY;
+			goto err;
+		}
+	}
+
+	return 0;
+
+err_unlock:
+	raw_spin_unlock(&bts->lock);
+err:
+	hwc->state = PERF_HES_STOPPED;
+
+	return ret;
+}
+
+static int bts_event_init(struct perf_event *event)
+{
+	if (event->attr.type != bts_pmu.type)
+		return -ENOENT;
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
+	int cpu;
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
+	bts_pmu.capabilities	= PERF_PMU_CAP_AUX_NO_SG | PERF_PMU_CAP_ITRACE;
+	bts_pmu.task_ctx_nr	= perf_hw_context;
+	bts_pmu.event_init	= bts_event_init;
+	bts_pmu.add		= bts_event_add;
+	bts_pmu.del		= bts_event_del;
+	bts_pmu.start		= bts_event_start;
+	bts_pmu.stop		= bts_event_stop;
+	bts_pmu.read		= bts_event_read;
+	bts_pmu.setup_aux	= bts_buffer_setup_aux;
+	bts_pmu.free_aux	= bts_buffer_free_aux;
+
+	return perf_pmu_register(&bts_pmu, "intel_bts", -1);
+}
+
+module_init(bts_init);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 5ae212af23..f069f1f536 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -466,7 +466,8 @@ void intel_pmu_enable_bts(u64 config)
 
 	debugctlmsr |= DEBUGCTLMSR_TR;
 	debugctlmsr |= DEBUGCTLMSR_BTS;
-	debugctlmsr |= DEBUGCTLMSR_BTINT;
+	if (config & ARCH_PERFMON_EVENTSEL_INT)
+		debugctlmsr |= DEBUGCTLMSR_BTINT;
 
 	if (!(config & ARCH_PERFMON_EVENTSEL_OS))
 		debugctlmsr |= DEBUGCTLMSR_BTS_OFF_OS;
-- 
2.1.0

