Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3ISJO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:14:59 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:34928 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab3ISJO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:14:56 -0400
Date: Thu, 19 Sep 2013 11:14:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vince@deater.net>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        eranian@googlemail.com
Subject: [PATCH] perf: Always set bit 0 in the capabilities field of 'struct
 perf_event_mmap_page' to 0, to maintain the ABI
Message-ID: <20130919091452.GB14112@gmail.com>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
 <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
 <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
 <20130918085722.GL12926@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy>
 <20130918154224.GK9326@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181556370.26402@pianoman.cluster.toy>
 <20130919081642.GL9326@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919081642.GL9326@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Sep 18, 2013 at 04:07:52PM -0400, Vince Weaver wrote:
>
> > It would be nice if there was some way to detect this change; I liked 
> > the idea of a "cap_usr_fixed" bit.
> 
> How about we start using the version field for this? Arguably we should 
> have incremented that value every time we changed the thing but we might 
> as well start now.

But version fields are really fragile, the way we usually iterate ABIs is 
a self-maintaining size field - which is missing here.

So I think the best solution would be to make it all explicit and 
self-contained:

 - always clear bit 0, and rename it to usrpage->cap_bit0, to at least not 
   confuse old user-space binaries. RDPMC will be marked as unavailable 
   to old binaries but that's within the ABI.

 - rename bit 1 to ->cap_bit0_is_deprecated and always set it to 1, so new
   libraries can reliably detect that bit 0 is deprecated and perma-zero
   without having to check the kernel version.

 - use bits 2, 3, 4 for the newly defined, correct functionality.

 - rename all the bitfield names in perf_event.h to be different from the
   old names, to make sure it's not possible to mis-compile it
   accidentally with old assumptions.

I.e. something like the patch below. (untested)

The 'size' field can then be used in the future to add new fields and it 
will act as a natural ABI version indicator as well.

Thanks,

	Ingo

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8355c84..3ab624c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1883,9 +1883,9 @@ static struct pmu pmu = {
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
-	userpg->cap_usr_time = 0;
-	userpg->cap_usr_time_zero = 0;
-	userpg->cap_usr_rdpmc = x86_pmu.attr_rdpmc;
+	userpg->cap_usr_time_used = 0;
+	userpg->cap_usr_time_zero_used = 0;
+	userpg->cap_usr_rdpmc_available = x86_pmu.attr_rdpmc;
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
@@ -1894,13 +1894,13 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
 		return;
 
-	userpg->cap_usr_time = 1;
+	userpg->cap_usr_time_used = 1;
 	userpg->time_mult = this_cpu_read(cyc2ns);
 	userpg->time_shift = CYC2NS_SCALE_FACTOR;
 	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
 
 	if (sched_clock_stable && !check_tsc_disabled()) {
-		userpg->cap_usr_time_zero = 1;
+		userpg->cap_usr_time_zero_used = 1;
 		userpg->time_zero = this_cpu_read(cyc2ns_offset);
 	}
 }
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 40a1fb8..515d7d2 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -380,10 +380,13 @@ struct perf_event_mmap_page {
 	union {
 		__u64	capabilities;
 		struct {
-			__u64	cap_usr_time		: 1,
-				cap_usr_rdpmc		: 1,
-				cap_usr_time_zero	: 1,
-				cap_____res		: 61;
+			__u64	cap_bit0		: 1, /* Deprecated, always zero, see commit 860f085b74e9 */
+				cap_bit0_is_deprecated	: 1, /* Always 1, signals that bit 0 is zero */
+
+				cap_usr_rdpmc_available	: 1, /* The RDPMC instruction can be used to read counts */
+				cap_usr_time_used	: 1, /* The time_* fields are uses */
+				cap_usr_time_zero_used	: 1, /* The time_zero field is used */
+				cap_____res		: 59;
 		};
 	};
 
@@ -442,12 +445,14 @@ struct perf_event_mmap_page {
 	 *               ((rem * time_mult) >> time_shift);
 	 */
 	__u64	time_zero;
+	__u32	size;			/* Header size up to this point */
+	__u32	__reserved0;		/* 4 byte hole */
 
 		/*
 		 * Hole for extension of the self monitor capabilities
 		 */
 
-	__u64	__reserved[119];	/* align to 1k */
+	__u64	__reserved[118];	/* align to 1k */
 
 	/*
 	 * Control data for the mmap() data buffer.
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dd236b6..27d339f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3660,6 +3660,26 @@ static void calc_timer_values(struct perf_event *event,
 	*running = ctx_time - event->tstamp_running;
 }
 
+static void perf_event_init_userpage(struct perf_event *event)
+{
+	struct perf_event_mmap_page *userpg;
+	struct ring_buffer *rb;
+
+	rcu_read_lock();
+	rb = rcu_dereference(event->rb);
+	if (!rb)
+		goto unlock;
+
+	userpg = rb->user_page;
+
+	/* Allow new userspace to detect that bit 0 is deprecated */
+	userpg->cap_bit0_is_deprecated = 1;
+	userpg->size = offsetof(struct perf_event_mmap_page, size);
+
+unlock:
+	rcu_read_unlock();
+}
+
 void __weak arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
 }
@@ -4044,6 +4064,7 @@ again:
 	ring_buffer_attach(event, rb);
 	rcu_assign_pointer(event->rb, rb);
 
+	perf_event_init_userpage(event);
 	perf_event_update_userpage(event);
 
 unlock:
