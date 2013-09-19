Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3ISLm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:42:59 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:37287 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3ISLm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:42:58 -0400
Date: Thu, 19 Sep 2013 13:42:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Vince Weaver <vince@deater.net>,
        hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, eranian@googlemail.com
Subject: [PATCH, v4] perf: Fix capabilities bitfield compatibility in 'struct
 perf_event_mmap_page'
Message-ID: <20130919114254.GA22807@gmail.com>
References: <alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy>
 <20130918154224.GK9326@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181556370.26402@pianoman.cluster.toy>
 <20130919081642.GL9326@twins.programming.kicks-ass.net>
 <20130919091452.GB14112@gmail.com>
 <20130919101240.GN9326@twins.programming.kicks-ass.net>
 <20130919102818.GA23487@gmail.com>
 <20130919103550.GO9326@twins.programming.kicks-ass.net>
 <20130919104056.GA18991@gmail.com>
 <523ADD8D.1030607@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523ADD8D.1030607@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Hunter <adrian.hunter@intel.com> wrote:

> >  		struct {
> > -			__u64	cap_usr_time		: 1,
> > -				cap_usr_rdpmc		: 1,
> > -				cap_usr_time_zero	: 1,
> > -				cap_____res		: 61;
> > +			__u64	cap_bit0		: 1, /* Always 0, deprecated, see commit 860f085b74e9 */
> > +				cap_bit0_is_deprecated	: 1, /* Always 1, signals that bit 0 is zero */
> > +
> > +				cap_user_rdpmc		: 1, /* The RDPMC instruction can be used to read counts */
> > +				cap_user_time		: 1, /* The time_* fields are used */
> > +				cap_user_time_zero	: 1, /* The time_zero field is used */
> > +				cap_____res		: 59;
> >  		};

> Please consider adding:

indeed - added. I also build-tested it all and added a changelog - see the 
updated patch below.

Thanks,

	Ingo

--------------------->
Subject: perf: Fix capabilities bitfield compatibility in 'struct perf_event_mmap_page'
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 19 Sep 2013 10:16:42 +0200

Solve the problems around the broken definition of perf_event_mmap_page::
cap_usr_time and cap_usr_rdpmc fields which used to overlap, partially
fixed by:

  860f085b74e9 ("perf: Fix broken union in 'struct perf_event_mmap_page'")

The problem with the fix (merged in v3.12-rc1 and not yet released
officially), noticed by Vince Weaver is that the new behavior is
not detectable by new user-space, and that due to the reuse of the
field names it's easy to mis-compile a binary if old headers are used
on a new kernel or new headers are used on an old kernel.

To solve all that make this change explicit, detectable and self-contained,
by iterating the ABI the following way:

 - Always clear bit 0, and rename it to usrpage->cap_bit0, to at least not
   confuse old user-space binaries. RDPMC will be marked as unavailable
   to old binaries but that's within the ABI, this is a capability bit.

 - Rename bit 1 to ->cap_bit0_is_deprecated and always set it to 1, so new
   libraries can reliably detect that bit 0 is deprecated and perma-zero
   without having to check the kernel version.

 - Use bits 2, 3, 4 for the newly defined, correct functionality:

	cap_user_rdpmc		: 1, /* The RDPMC instruction can be used to read counts */
	cap_user_time		: 1, /* The time_* fields are used */
	cap_user_time_zero	: 1, /* The time_zero field is used */

 - Rename all the bitfield names in perf_event.h to be different from the
   old names, to make sure it's not possible to mis-compile it
   accidentally with old assumptions.

The 'size' field can then be used in the future to add new fields and it
will act as a natural ABI version indicator as well.

Also adjust tools/perf/ userspace for the new definitions, noticed by
Adrian Hunter.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Also-Fixed-by: Adrian Hunter <adrian.hunter@intel.com>
Link: http://lkml.kernel.org/n/tip-zr03yxjrpXesOzzupszqglbv@git.kernel.org
[ Restructured it, using Peter's original patches. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |   10 +++++-----
 include/uapi/linux/perf_event.h  |   14 +++++++++-----
 kernel/events/core.c             |   21 +++++++++++++++++++++
 tools/perf/arch/x86/util/tsc.c   |    6 +++---
 4 files changed, 38 insertions(+), 13 deletions(-)

Index: tip/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/perf_event.c
+++ tip/arch/x86/kernel/cpu/perf_event.c
@@ -1883,9 +1883,9 @@ static struct pmu pmu = {
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
-	userpg->cap_usr_time = 0;
-	userpg->cap_usr_time_zero = 0;
-	userpg->cap_usr_rdpmc = x86_pmu.attr_rdpmc;
+	userpg->cap_user_time = 0;
+	userpg->cap_user_time_zero = 0;
+	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
@@ -1894,13 +1894,13 @@ void arch_perf_update_userpage(struct pe
 	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
 		return;
 
-	userpg->cap_usr_time = 1;
+	userpg->cap_user_time = 1;
 	userpg->time_mult = this_cpu_read(cyc2ns);
 	userpg->time_shift = CYC2NS_SCALE_FACTOR;
 	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
 
 	if (sched_clock_stable && !check_tsc_disabled()) {
-		userpg->cap_usr_time_zero = 1;
+		userpg->cap_user_time_zero = 1;
 		userpg->time_zero = this_cpu_read(cyc2ns_offset);
 	}
 }
Index: tip/include/uapi/linux/perf_event.h
===================================================================
--- tip.orig/include/uapi/linux/perf_event.h
+++ tip/include/uapi/linux/perf_event.h
@@ -380,10 +380,13 @@ struct perf_event_mmap_page {
 	union {
 		__u64	capabilities;
 		struct {
-			__u64	cap_usr_time		: 1,
-				cap_usr_rdpmc		: 1,
-				cap_usr_time_zero	: 1,
-				cap_____res		: 61;
+			__u64	cap_bit0		: 1, /* Always 0, deprecated, see commit 860f085b74e9 */
+				cap_bit0_is_deprecated	: 1, /* Always 1, signals that bit 0 is zero */
+
+				cap_user_rdpmc		: 1, /* The RDPMC instruction can be used to read counts */
+				cap_user_time		: 1, /* The time_* fields are used */
+				cap_user_time_zero	: 1, /* The time_zero field is used */
+				cap_____res		: 59;
 		};
 	};
 
@@ -442,12 +445,13 @@ struct perf_event_mmap_page {
 	 *               ((rem * time_mult) >> time_shift);
 	 */
 	__u64	time_zero;
+	__u32	size;			/* Header size up to __reserved[] fields. */
 
 		/*
 		 * Hole for extension of the self monitor capabilities
 		 */
 
-	__u64	__reserved[119];	/* align to 1k */
+	__u8	__reserved[118*8+4];	/* align to 1k. */
 
 	/*
 	 * Control data for the mmap() data buffer.
Index: tip/kernel/events/core.c
===================================================================
--- tip.orig/kernel/events/core.c
+++ tip/kernel/events/core.c
@@ -3660,6 +3660,26 @@ static void calc_timer_values(struct per
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
+	userpg->size = offsetof(struct perf_event_mmap_page, __reserved);
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
Index: tip/tools/perf/arch/x86/util/tsc.c
===================================================================
--- tip.orig/tools/perf/arch/x86/util/tsc.c
+++ tip/tools/perf/arch/x86/util/tsc.c
@@ -32,7 +32,7 @@ u64 tsc_to_perf_time(u64 cyc, struct per
 int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 			     struct perf_tsc_conversion *tc)
 {
-	bool cap_usr_time_zero;
+	bool cap_user_time_zero;
 	u32 seq;
 	int i = 0;
 
@@ -42,7 +42,7 @@ int perf_read_tsc_conversion(const struc
 		tc->time_mult = pc->time_mult;
 		tc->time_shift = pc->time_shift;
 		tc->time_zero = pc->time_zero;
-		cap_usr_time_zero = pc->cap_usr_time_zero;
+		cap_user_time_zero = pc->cap_user_time_zero;
 		rmb();
 		if (pc->lock == seq && !(seq & 1))
 			break;
@@ -52,7 +52,7 @@ int perf_read_tsc_conversion(const struc
 		}
 	}
 
-	if (!cap_usr_time_zero)
+	if (!cap_user_time_zero)
 		return -EOPNOTSUPP;
 
 	return 0;
