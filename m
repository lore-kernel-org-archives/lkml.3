Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbaEMJ5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:57:17 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:37060 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759891AbaEMJ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:57:13 -0400
Date: Tue, 13 May 2014 11:57:49 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [BUG] sched_setattr() SCHED_DEADLINE hangs system
Message-Id: <20140513115749.ebf3eebc64e44aac6f183410@gmail.com>
In-Reply-To: <20140512123032.GC13467@laptop.programming.kicks-ass.net>
References: <536F8F0E.7020301@gmail.com>
	<53707007.3080003@gmail.com>
	<20140512084727.GN30445@twins.programming.kicks-ass.net>
	<CAKgNAkiGt6xV0JaddmC8pLeTe+fSEu79DNvzg8XbA-MPo_zXyg@mail.gmail.com>
	<20140512123032.GC13467@laptop.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Mon, 12 May 2014 14:30:32 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, May 12, 2014 at 11:19:39AM +0200, Michael Kerrisk (man-pages) wrote:
> > Hi Peter,
> > 
> > On Mon, May 12, 2014 at 10:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Mon, May 12, 2014 at 08:53:59AM +0200, Michael Kerrisk (man-pages) wrote:
> > >> On 05/11/2014 04:54 PM, Michael Kerrisk (man-pages) wrote:
> > >
> > >> > $ time sudo ./t_sched_setattr d 18446744072 18446744072 18446744073
> > >>
> > >> I realize my speculation was completely off the mark. time(2) really
> > >> is reporting the truth, and the sched_setattr() call returns immediately.
> > >> But it looks like with these settings the deadline scheduler gets itself
> > >> into a confused state. The process chews up a vast amount of CPU time
> > >> for the few actions (including process teardown) that occur after
> > >> the sched_setattr() call, and since the SCHED_DEADLINE process has
> > >> priority over everything else, the system locks up.
> > >
> > > Yeah, its doing something weird alright.. let me see if I can get
> > > something useful out.
> > 
> > Thanks!
> 
> So I think its because the way we check wrapping
> 
>   (s64)(a - b) < 0
> 
> This means that its impossible to tell if time went fwd or bwd with
> 64bit increments. I've not entirely pinpointed where this is wrecking
> things, but it seems like a fair bet this is what's going wrong.
> 
> So I'm tempted to put a sanity check on all these values to make sure <=
> 2^63. That way the wrapping logic in the kernel keeps working.
> 
> And 2^63 [ns] should be plenty large enough for everyone (famous last
> words of course).
> 

Does the following fix the thing?

Thanks,

- Juri

---
>From 90a7603a0b6b620c9d07e3f375906b436dcc2230 Mon Sep 17 00:00:00 2001
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
 kernel/sched/core.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d9d8ece..96ba59d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3188,17 +3188,21 @@ __getparam_dl(struct task_struct *p, struct sched_attr *attr)
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
 	return attr && attr->sched_deadline != 0 &&
 		(attr->sched_period == 0 ||
-		(s64)(attr->sched_period   - attr->sched_deadline) >= 0) &&
-		(s64)(attr->sched_deadline - attr->sched_runtime ) >= 0  &&
-		attr->sched_runtime >= (2 << (DL_SCALE - 1));
+		(attr->sched_period >= attr->sched_deadline)) &&
+		(attr->sched_deadline >= attr->sched_runtime) &&
+		attr->sched_runtime >= (1ULL << DL_SCALE) &&
+		(attr->sched_deadline < (1ULL << 63) &&
+		attr->sched_period < (1ULL << 63));
 }
 
 /*
-- 
1.7.9.5
