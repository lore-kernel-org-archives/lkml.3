Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbaEMMKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:10:42 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:33654 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759338AbaEMMKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:10:41 -0400
Date: Tue, 13 May 2014 14:11:31 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [BUG] sched_setattr() SCHED_DEADLINE hangs system
Message-Id: <20140513141131.20d944f81633ee937f256385@gmail.com>
In-Reply-To: <20140513104307.GZ30445@twins.programming.kicks-ass.net>
References: <536F8F0E.7020301@gmail.com>
	<53707007.3080003@gmail.com>
	<20140512084727.GN30445@twins.programming.kicks-ass.net>
	<CAKgNAkiGt6xV0JaddmC8pLeTe+fSEu79DNvzg8XbA-MPo_zXyg@mail.gmail.com>
	<20140512123032.GC13467@laptop.programming.kicks-ass.net>
	<20140513115749.ebf3eebc64e44aac6f183410@gmail.com>
	<20140513104307.GZ30445@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 12:43:07 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, May 13, 2014 at 11:57:49AM +0200, Juri Lelli wrote:
> >  static bool
> >  __checkparam_dl(const struct sched_attr *attr)
> >  {
> >  	return attr && attr->sched_deadline != 0 &&
> >  		(attr->sched_period == 0 ||
> > -		(s64)(attr->sched_period   - attr->sched_deadline) >= 0) &&
> > -		(s64)(attr->sched_deadline - attr->sched_runtime ) >= 0  &&
> > -		attr->sched_runtime >= (2 << (DL_SCALE - 1));
> > +		(attr->sched_period >= attr->sched_deadline)) &&
> > +		(attr->sched_deadline >= attr->sched_runtime) &&
> > +		attr->sched_runtime >= (1ULL << DL_SCALE) &&
> > +		(attr->sched_deadline < (1ULL << 63) &&
> > +		attr->sched_period < (1ULL << 63));
> >  }
> 
> Could we maybe rewrite that function to look less like a ioccc.org
> submission?
> 

Right.

> static bool
> __checkparam_dl(const struct sched_attr *attr)
> {
> 	if (!attr) /* possible at all? */
> 		return false;
> 

I'd say no, removed.

> 	/* runtime <= deadline <= period */
> 	if (attr->sched_period   < attr->sched_deadline ||
> 	    attr->sched_deadline < attr->sched_runtime)
> 		return false;
> 
> 	/*
> 	 * Since we truncate DL_SCALE bits make sure we're at least that big,
> 	 * if runtime > (1 << DL_SCALE), so must the others be per the above
> 	 */
> 	if (attr->sched_runtime <= (1ULL << DL_SCALE))
> 		return false;
> 
> 	/*
> 	 * Since we use the MSB for wrap-around and sign issues, make
> 	 * sure its not set, if period < 2^63, so must the others be.
> 	 */
> 	if (attr->sched_period & (1ULL << 63))
> 		return false;
> 
> 	return true;
> }
> 
> Did I miss anything?

period can be 0, so we have to check also sched_deadline for MSB set.

Thanks,

- Juri

---
>From e0c44d7614127f8dfbafc08c30681cb8098271e8 Mon Sep 17 00:00:00 2001
From: Juri Lelli <juri.lelli@gmail.com>
Date: Tue, 13 May 2014 10:15:59 +0200
Subject: [PATCH] sched/deadline: restrict user params max value to 2^63 ns

Michael Kerrisk noticed that creating SCHED_DEADLINE reservations
with certain parameters (e.g, a runtime of something near 2^64 ns)
can cause a system freeze for some amount of time.

The problem is that in the interface we have

 u64 sched_runtime;

while internally we need to have a signed runtime (to cope with
budget overruns)

 s64 runtime;

At the time we setup a new dl_entity we copy the first value in
the second. The cast turns out with negative values when
sched_runtime is too big, and this causes the scheduler to go crazy
right from the start.

Moreover, considering how we deal with deadlines wraparound

 (s64)(a - b) < 0

we also have to restrict acceptable values for sched_{deadline,period}.

This patch fixes the thing checking that user parameters are always
below 2^63 ns (still large enough for everyone).

It also rewrites other conditions that we check, since in
__checkparam_dl we don't have to deal with deadline wraparounds
and what we have now erroneously fails when the difference between
values is too big.

Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/core.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d9d8ece..682a986 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3188,17 +3188,40 @@ __getparam_dl(struct task_struct *p, struct sched_attr *attr)
  * We ask for the deadline not being zero, and greater or equal
  * than the runtime, as well as the period of being zero or
  * greater than deadline. Furthermore, we have to be sure that
- * user parameters are above the internal resolution (1us); we
- * check sched_runtime only since it is always the smaller one.
+ * user parameters are above the internal resolution of 1us (we
+ * check sched_runtime only since it is always the smaller one) and
+ * below 2^63 ns (we have to check both sched_deadline and
+ * sched_period, as the latter can be zero).
  */
 static bool
 __checkparam_dl(const struct sched_attr *attr)
 {
-	return attr && attr->sched_deadline != 0 &&
-		(attr->sched_period == 0 ||
-		(s64)(attr->sched_period   - attr->sched_deadline) >= 0) &&
-		(s64)(attr->sched_deadline - attr->sched_runtime ) >= 0  &&
-		attr->sched_runtime >= (2 << (DL_SCALE - 1));
+	/* deadline != 0 */
+	if (attr->sched_deadline == 0)
+		return false;
+
+	/*
+	 * Since we truncate DL_SCALE bits, make sure we're at least
+	 * that big.
+	 */
+	if (attr->sched_runtime < (1ULL << DL_SCALE))
+		return false;
+
+	/*
+	 * Since we use the MSB for wrap-around and sign issues, make
+	 * sure it's not set (mind that period can be equal to zero).
+	 */
+	if (attr->sched_deadline & (1ULL << 63) ||
+	    attr->sched_period & (1ULL << 63))
+		return false;
+
+	/* runtime <= deadline <= period (if period != 0) */
+	if ((attr->sched_period != 0 &&
+	     attr->sched_period < attr->sched_deadline) ||
+	    attr->sched_deadline < attr->sched_runtime)
+		return false;
+
+	return true;
 }
 
 /*
-- 
1.7.9.5
