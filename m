Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaBEVlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:41:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:57634 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbaBEVlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:41:19 -0500
Date: Wed, 5 Feb 2014 22:41:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
In-Reply-To: <52F1DDA8.90605@samsung.com>
Message-ID: <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de>
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com> <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com> <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de> <52F1DDA8.90605@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Alexey Perevalov wrote:
> On 02/04/2014 08:10 PM, Thomas Gleixner wrote:
> > On Mon, 27 Jan 2014, Alexey Perevalov wrote:
> > > On 01/21/2014 11:12 PM, John Stultz wrote:
> > > > Thomas: Any thought here? Should we be trying to unify the timerfd flags
> > > > and the posix timer flags (specifically things like TIMER_CANCEL_ON_SET,
> > > > which is currently timerfd-only)?  Should a deferrable flag be added to
> > > > the hrtimer core or left to the timer wheel?
> > The timer cancel on set was added only to timerfd because timerfd is a
> > non posix interface and we are halfways free to add stuff to
> > it. Adding extra flags to the real posix timer interfaces is a
> > different story.
> 
> And what about "deferrable" possibility for hrtimers, do you consider it
> reasonable?

In principle, I have no objections, but we need a proper technical
solution. Just adding a flag and keeping the timers in the same rbtree
like we do for the timer wheel timers is not going to happen.

The only feasible solution is to have separate clock ids,
e.g. CLOCK_*_DEFERRABLE, which would enable the deferrable
functionality for all user space interfaces. No need for magic flags
and complex search for non deferrable timers.

Though I really do not like the idea of adding more overhead to
hrtimer_interrupt, but we must die one sort of death and definitely
any solution which brings timer_list back into the game is the worst
of all choices.

We spent enough time to explain why the conversion to hrtimers is the
only sensible solution for user space interfaces. Even thinking about
exposing the timer wheel to user space again is a violation of good
taste.

It's not rocket science to avoid the overhead for hrtimer_interrupt
when there are no users of certain clock bases. We already have a flag
field which marks the active bases, we just do not make proper use of
it. Did you even think about that before hacking that timer_list based
crappola with completely unspecified and unextensible behaviour?

Find an untested (even uncompiled) POC patch below. It should work
somehow, but you can find the unresolved issues and the necessary
updates to other parts of hrtimer.c yourself. I might take the
properly split up result if you can prove that there is no downside on
this aside of a few bytes memory footprint when nothing is using the
new clocks.

Thanks,

	tglx
----
Subject: hrtimer-deferrable-hack.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 05 Feb 2014 21:44:31 +0100

[ Insert proper changelog ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h   |    3 ++
 include/uapi/linux/time.h |    3 ++
 kernel/hrtimer.c          |   62 ++++++++++++++++++++++++++++++++++++----------
 3 files changed, 55 insertions(+), 13 deletions(-)

Index: tip/include/linux/hrtimer.h
===================================================================
--- tip.orig/include/linux/hrtimer.h
+++ tip/include/linux/hrtimer.h
@@ -158,6 +158,9 @@ enum  hrtimer_base_type {
 	HRTIMER_BASE_REALTIME,
 	HRTIMER_BASE_BOOTTIME,
 	HRTIMER_BASE_TAI,
+	HRTIMER_BASE_MONOTONIC_DEFERRABLE,
+	HRTIMER_BASE_REALTIME_DEFERRABLE,
+	HRTIMER_BASE_BOOTTIME_DEFERRABLE,
 	HRTIMER_MAX_CLOCK_BASES,
 };
 
Index: tip/include/uapi/linux/time.h
===================================================================
--- tip.orig/include/uapi/linux/time.h
+++ tip/include/uapi/linux/time.h
@@ -56,6 +56,9 @@ struct itimerval {
 #define CLOCK_BOOTTIME_ALARM		9
 #define CLOCK_SGI_CYCLE			10	/* Hardware specific */
 #define CLOCK_TAI			11
+#define CLOCK_REALTIME_DEFERRABLE	12
+#define CLOCK_MONOTONIC_DEFERRABLE	13
+#define CLOCK_BOOTTIME_DEFERRABLE	14
 
 #define MAX_CLOCKS			16
 #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)
Index: tip/kernel/hrtimer.c
===================================================================
--- tip.orig/kernel/hrtimer.c
+++ tip/kernel/hrtimer.c
@@ -91,14 +91,35 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base,
 			.get_time = &ktime_get_clocktai,
 			.resolution = KTIME_LOW_RES,
 		},
+		{
+			.index = HRTIMER_BASE_MONOTONIC_DEFERRABLE,
+			.clockid = CLOCK_MONOTONIC_DEFERRABLE,
+			.get_time = &ktime_get,
+			.resolution = KTIME_LOW_RES,
+		},
+		{
+			.index = HRTIMER_BASE_REALTIME_DEFERRABLE,
+			.clockid = CLOCK_REALTIME_DEFERRABLE,
+			.get_time = &ktime_get_real,
+			.resolution = KTIME_LOW_RES,
+		},
+		{
+			.index = HRTIMER_BASE_BOOTTIME_DEFERRABLE,
+			.clockid = CLOCK_BOOTTIME_DEFERRABLE,
+			.get_time = &ktime_get_boottime,
+			.resolution = KTIME_LOW_RES,
+		},
 	}
 };
 
 static const int hrtimer_clock_to_base_table[MAX_CLOCKS] = {
-	[CLOCK_REALTIME]	= HRTIMER_BASE_REALTIME,
-	[CLOCK_MONOTONIC]	= HRTIMER_BASE_MONOTONIC,
-	[CLOCK_BOOTTIME]	= HRTIMER_BASE_BOOTTIME,
-	[CLOCK_TAI]		= HRTIMER_BASE_TAI,
+	[CLOCK_REALTIME]		= HRTIMER_BASE_REALTIME,
+	[CLOCK_MONOTONIC]		= HRTIMER_BASE_MONOTONIC,
+	[CLOCK_BOOTTIME]		= HRTIMER_BASE_BOOTTIME,
+	[CLOCK_TAI]			= HRTIMER_BASE_TAI,
+	[CLOCK_REALTIME_DEFERRABLE]	= HRTIMER_BASE_REALTIME_DEFERRABLE,
+	[CLOCK_MONOTONIC_DEFERRABLE]	= HRTIMER_BASE_MONOTONIC_DEFERRABLE,
+	[CLOCK_BOOTTIME_DEFERRABLE]	= HRTIMER_BASE_BOOTTIME_DEFERRABLE,
 };
 
 static inline int hrtimer_clockid_to_base(clockid_t clock_id)
@@ -193,7 +214,8 @@ hrtimer_check_target(struct hrtimer *tim
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t expires;
 
-	if (!new_base->cpu_base->hres_active)
+	if (!new_base->cpu_base->hres_active ||
+	    new_base->index >= HRTIMER_BASE_MONOTONIC_DEFERRABLE)
 		return 0;
 
 	expires = ktime_sub(hrtimer_get_expires(timer), new_base->offset);
@@ -555,7 +577,7 @@ hrtimer_force_reprogram(struct hrtimer_c
 
 	expires_next.tv64 = KTIME_MAX;
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
+	for (i = 0; i < HRTIMER_BASE_MONOTONIC_DEFERRABLE; i++, base++) {
 		struct hrtimer *timer;
 		struct timerqueue_node *next;
 
@@ -614,6 +636,13 @@ static int hrtimer_reprogram(struct hrti
 		return 0;
 
 	/*
+	 * Deferrable timers are not touching the underlying
+	 * hardware.
+	 */
+	if (base->index >= HRTIMER_BASE_MONOTONIC_DEFERRABLE)
+		return 0;
+
+	/*
 	 * CLOCK_REALTIME timer might be requested with an absolute
 	 * expiry time which is less than base->offset. Nothing wrong
 	 * about that, just avoid to call into the tick code, which
@@ -923,7 +952,10 @@ static void __remove_hrtimer(struct hrti
 
 			expires = ktime_sub(hrtimer_get_expires(timer),
 					    base->offset);
-			if (base->cpu_base->expires_next.tv64 == expires.tv64)
+
+			/* We only care about non deferrable timers here */
+			if (base->index <= HRTIMER_BASE_MONOTONIC_DEFERRABLE &&
+			    base->cpu_base->expires_next.tv64 == expires.tv64)
 				hrtimer_force_reprogram(base->cpu_base, 1);
 		}
 #endif
@@ -1151,7 +1183,7 @@ ktime_t hrtimer_get_next_event(void)
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
 	if (!hrtimer_hres_active()) {
-		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
+		for (i = 0; i < HRTIMER_BASE_MONOTONIC_DEFERRABLE; i++, base++) {
 			struct hrtimer *timer;
 			struct timerqueue_node *next;
 
@@ -1283,7 +1315,8 @@ void hrtimer_interrupt(struct clock_even
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	ktime_t expires_next, now, entry_time, delta;
-	int i, retries = 0;
+	unsigned long bases;
+	int retries = 0;
 
 	BUG_ON(!cpu_base->hres_active);
 	cpu_base->nr_events++;
@@ -1301,14 +1334,16 @@ retry:
 	 * this CPU.
 	 */
 	cpu_base->expires_next.tv64 = KTIME_MAX;
+	bases = cpu_base->active_bases;
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
+	while (bases) {
 		struct hrtimer_clock_base *base;
 		struct timerqueue_node *node;
 		ktime_t basenow;
+		int i;
 
-		if (!(cpu_base->active_bases & (1 << i)))
-			continue;
+		i = __ffs(bases);
+		bases &= ~(1 << i);
 
 		base = cpu_base->clock_base + i;
 		basenow = ktime_add(now, base->offset);
@@ -1338,7 +1373,8 @@ retry:
 						    base->offset);
 				if (expires.tv64 < 0)
 					expires.tv64 = KTIME_MAX;
-				if (expires.tv64 < expires_next.tv64)
+				if (expires.tv64 < expires_next.tv64 &&
+				    base->index <= HRTIMER_BASE_MONOTONIC_DEFERRABLE)
 					expires_next = expires;
 				break;
 			}




