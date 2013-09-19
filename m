Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3ISK2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:28:23 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:34413 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3ISK2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:28:22 -0400
Date: Thu, 19 Sep 2013 12:28:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vince@deater.net>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        eranian@googlemail.com
Subject: Re: [PATCH] perf: Always set bit 0 in the capabilities field of
 'struct perf_event_mmap_page' to 0, to maintain the ABI
Message-ID: <20130919102818.GA23487@gmail.com>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
 <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
 <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
 <20130918085722.GL12926@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy>
 <20130918154224.GK9326@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181556370.26402@pianoman.cluster.toy>
 <20130919081642.GL9326@twins.programming.kicks-ass.net>
 <20130919091452.GB14112@gmail.com>
 <20130919101240.GN9326@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919101240.GN9326@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Sep 19, 2013 at 11:14:53AM +0200, Ingo Molnar wrote:
> > @@ -442,12 +445,14 @@ struct perf_event_mmap_page {
> >  	 *               ((rem * time_mult) >> time_shift);
> >  	 */
> >  	__u64	time_zero;
> > +	__u32	size;			/* Header size up to this point */
> > +	__u32	__reserved0;		/* 4 byte hole */
> >  
> >  		/*
> >  		 * Hole for extension of the self monitor capabilities
> >  		 */
> >  
> > -	__u64	__reserved[119];	/* align to 1k */
> > +	__u64	__reserved[118];	/* align to 1k */
> >  
> >  	/*
> >  	 * Control data for the mmap() data buffer.
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index dd236b6..27d339f 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -3660,6 +3660,26 @@ static void calc_timer_values(struct perf_event *event,
> >  	*running = ctx_time - event->tstamp_running;
> >  }
> >  
> > +static void perf_event_init_userpage(struct perf_event *event)
> > +{
> > +	struct perf_event_mmap_page *userpg;
> > +	struct ring_buffer *rb;
> > +
> > +	rcu_read_lock();
> > +	rb = rcu_dereference(event->rb);
> > +	if (!rb)
> > +		goto unlock;
> > +
> > +	userpg = rb->user_page;
> > +
> > +	/* Allow new userspace to detect that bit 0 is deprecated */
> > +	userpg->cap_bit0_is_deprecated = 1;
> > +	userpg->size = offsetof(struct perf_event_mmap_page, size);
> 
> This is fragile and I'm 100% sure we'll forget to update it.
> 
> 	userpg->size = offsetof(struct perf_event_mmap_page, __reserved);
> 
> Will auto update and mostly do the right thing.

Ah, yes, agreed 100% - that was my intention, just implemented it badly.

One detail: I think we want to track size with u8 granularity, to be able 
to detect when a new u32 (or u16) field gets added, right? Updated patch 
attached below.

Note that this way of writing the array size:

+	__u8	__reserved[118*8+4];	/* align to 1k. */

Makes it sure that we are aware of the current word alignment situation 
and makes it harder to break alignment in the future.

> Also, how will userspace know there's a valid size field way out there? 

The current value of the size field on old kernels is 0 so it easily 
detected by being nonzero.

> Shouldn't we bump the version field to indicate so? :-) After all, 
> running on old userspace this field will be 0.

Well, on old kernel this will be 0, right?

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
index 40a1fb8..e3514d1 100644
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
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dd236b6..cb4238e 100644
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
