Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab3EEKK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 06:10:59 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:47394 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3EEKK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 06:10:57 -0400
Date: Sun, 5 May 2013 12:10:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130505101051.GA4371@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 7cc23cd6c0c7d7f4bee057607e7ce01568925717 perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL

Misc fixes plus a small hw-enablement patch for Intel IB model 58 uncore 
events.

 Thanks,

	Ingo

------------------>
Jan-Simon Möller (1):
      perf/x86/intel: Fix unintended variable name reuse

Jiri Olsa (1):
      perf: Fix vmalloc ring buffer pages handling

Li Fei (1):
      x86: Eliminate irq_mis_count counted in arch_irq_stat

Peter Zijlstra (3):
      perf/x86: Blacklist all MEM_*_RETIRED events for Ivy Bridge
      perf/x86/intel/lbr: Fix LBR filter
      perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL

Vince Weaver (2):
      perf/x86/intel: Fix typo in perf_event_intel_uncore.c
      perf/x86/intel: Add support for IvyBridge model 58 Uncore


 arch/x86/kernel/cpu/perf_event_intel.c        | 13 +++++++++----
 arch/x86/kernel/cpu/perf_event_intel_lbr.c    | 27 ++++++++++++++++++++++-----
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 19 ++++++++++---------
 arch/x86/kernel/irq.c                         |  4 ----
 kernel/events/ring_buffer.c                   | 14 ++++++++++----
 5 files changed, 51 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index cc45deb..4a0a462 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -125,10 +125,15 @@ static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
 	INTEL_UEVENT_CONSTRAINT(0x08a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x0ca3, 0x4), /* CYCLE_ACTIVITY.STALLS_L1D_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
-	INTEL_EVENT_CONSTRAINT(0xd0, 0xf), /* MEM_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd1, 0xf), /* MEM_LOAD_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd3, 0xf), /*  MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+	/*
+	 * Errata BV98 -- MEM_*_RETIRED events can leak between counters of SMT
+	 * siblings; disable these events because they can corrupt unrelated
+	 * counters.
+	 */
+	INTEL_EVENT_CONSTRAINT(0xd0, 0x0), /* MEM_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd1, 0x0), /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd2, 0x0), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd3, 0x0), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index da02e9c..d978353 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -310,7 +310,7 @@ void intel_pmu_lbr_read(void)
  * - in case there is no HW filter
  * - in case the HW filter has errata or limitations
  */
-static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
+static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 {
 	u64 br_type = event->attr.branch_sample_type;
 	int mask = 0;
@@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	if (br_type & PERF_SAMPLE_BRANCH_USER)
 		mask |= X86_BR_USER;
 
-	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
+	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
+		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		mask |= X86_BR_KERNEL;
+	}
 
 	/* we ignore BRANCH_HV here */
 
@@ -339,6 +342,8 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	 * be used by fixup code for some CPU
 	 */
 	event->hw.branch_reg.reg = mask;
+
+	return 0;
 }
 
 /*
@@ -386,7 +391,9 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
 	/*
 	 * setup SW LBR filter
 	 */
-	intel_pmu_setup_sw_lbr_filter(event);
+	ret = intel_pmu_setup_sw_lbr_filter(event);
+	if (ret)
+		return ret;
 
 	/*
 	 * setup HW LBR filter, if any
@@ -442,8 +449,18 @@ static int branch_type(unsigned long from, unsigned long to)
 			return X86_BR_NONE;
 
 		addr = buf;
-	} else
-		addr = (void *)from;
+	} else {
+		/*
+		 * The LBR logs any address in the IP, even if the IP just
+		 * faulted. This means userspace can control the from address.
+		 * Ensure we don't blindy read any address by validating it is
+		 * a known text address.
+		 */
+		if (kernel_text_address(from))
+			addr = (void *)from;
+		else
+			return X86_BR_NONE;
+	}
 
 	/*
 	 * decoder needs to know the ABI especially
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index b43200d..45f6d13 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2428,7 +2428,7 @@ static void __init uncore_types_exit(struct intel_uncore_type **types)
 static int __init uncore_type_init(struct intel_uncore_type *type)
 {
 	struct intel_uncore_pmu *pmus;
-	struct attribute_group *events_group;
+	struct attribute_group *attr_group;
 	struct attribute **attrs;
 	int i, j;
 
@@ -2455,19 +2455,19 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 		while (type->event_descs[i].attr.attr.name)
 			i++;
 
-		events_group = kzalloc(sizeof(struct attribute *) * (i + 1) +
-					sizeof(*events_group), GFP_KERNEL);
-		if (!events_group)
+		attr_group = kzalloc(sizeof(struct attribute *) * (i + 1) +
+					sizeof(*attr_group), GFP_KERNEL);
+		if (!attr_group)
 			goto fail;
 
-		attrs = (struct attribute **)(events_group + 1);
-		events_group->name = "events";
-		events_group->attrs = attrs;
+		attrs = (struct attribute **)(attr_group + 1);
+		attr_group->name = "events";
+		attr_group->attrs = attrs;
 
 		for (j = 0; j < i; j++)
 			attrs[j] = &type->event_descs[j].attr.attr;
 
-		type->events_group = events_group;
+		type->events_group = attr_group;
 	}
 
 	type->pmu_group = &uncore_pmu_attr_group;
@@ -2853,11 +2853,12 @@ static int __init uncore_cpu_init(void)
 		msr_uncores = nhm_msr_uncores;
 		break;
 	case 42: /* Sandy Bridge */
+	case 58: /* Ivy Bridge */
 		if (snb_uncore_cbox.num_boxes > max_cores)
 			snb_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snb_msr_uncores;
 		break;
-	case 45: /* Sandy Birdge-EP */
+	case 45: /* Sandy Bridge-EP */
 		if (snbep_uncore_cbox.num_boxes > max_cores)
 			snbep_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snbep_msr_uncores;
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index e4595f1..84b7789 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -165,10 +165,6 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 u64 arch_irq_stat(void)
 {
 	u64 sum = atomic_read(&irq_err_count);
-
-#ifdef CONFIG_X86_IO_APIC
-	sum += atomic_read(&irq_mis_count);
-#endif
 	return sum;
 }
 
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 97fddb0..cd55144 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -326,11 +326,16 @@ void rb_free(struct ring_buffer *rb)
 }
 
 #else
+static int data_page_nr(struct ring_buffer *rb)
+{
+	return rb->nr_pages << page_order(rb);
+}
 
 struct page *
 perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
 {
-	if (pgoff > (1UL << page_order(rb)))
+	/* The '>' counts in the user page. */
+	if (pgoff > data_page_nr(rb))
 		return NULL;
 
 	return vmalloc_to_page((void *)rb->user_page + pgoff * PAGE_SIZE);
@@ -350,10 +355,11 @@ static void rb_free_work(struct work_struct *work)
 	int i, nr;
 
 	rb = container_of(work, struct ring_buffer, work);
-	nr = 1 << page_order(rb);
+	nr = data_page_nr(rb);
 
 	base = rb->user_page;
-	for (i = 0; i < nr + 1; i++)
+	/* The '<=' counts in the user page. */
+	for (i = 0; i <= nr; i++)
 		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
 
 	vfree(base);
@@ -387,7 +393,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 	rb->user_page = all_buf;
 	rb->data_pages[0] = all_buf + PAGE_SIZE;
 	rb->page_order = ilog2(nr_pages);
-	rb->nr_pages = 1;
+	rb->nr_pages = !!nr_pages;
 
 	ring_buffer_init(rb, watermark, flags);
 
