Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3DPLGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:06:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab3DPLF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:05:58 -0400
Date: Tue, 16 Apr 2013 13:06:51 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dave Hansen <dave@sr71.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: sched/cputime: sig->prev_stime underflow
Message-ID: <20130416110651.GB620@redhat.com>
References: <515DBB00.20208@sr71.net>
 <CAFTL4hxnNyWbn47PxPZDibzgOcqtw8v+t3EEzn+AM_pzFM=YeQ@mail.gmail.com>
 <5162E8DC.4080204@sr71.net>
 <20130411074529.GA1629@redhat.com>
 <51670549.70205@sr71.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <51670549.70205@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 11, 2013 at 11:47:37AM -0700, Dave Hansen wrote:
> On 04/11/2013 12:45 AM, Stanislaw Gruszka wrote:
> > On Mon, Apr 08, 2013 at 08:57:16AM -0700, Dave Hansen wrote:
> >> On 04/04/2013 04:41 PM, Frederic Weisbecker wrote:
> >>> Does this patch fix the issue for you?
> >>> https://lkml.org/lkml/2013/4/4/112
> >>
> >> Nope, that doesn't seem to make a difference.  I'm still seeing the
> >> underflow.  I'm pretty sure it's already gone to hell by the time it
> >> gets in to the loop that's patched there.
> > 
> > Perhaps this is glich introduced by commit 
> > 62188451f0d63add7ad0cd2a1ae269d600c1663d "cputime: Avoid multiplication
> > overflow on utime scaling" . Could you try to revert it and see if that
> > helps. If it does not, can you check if problem happen on 3.8 ?
> 
> I'll run a bit longer, but reverting
> 62188451f0d63add7ad0cd2a1ae269d600c1663d _does_ seem to make it happier.

Hmm, I supposed glitch in this commit because it something that was
changed recently and previously we did not have such bug reports. But
I do not see mistake there. Basically prev->stime should never be
bigger than rtime, since at any moment stime <= rtime and previous
rtime <= current rtime. So this looks like rtime decrease and for
some reason before 62188451f0d it does not manifest as a bug.

It can be fixed by comparing prev->stime < rtime or by something
like first attached patch. Not sure what will be better.

But since this (most likely) is rtime monotonicity problem it
is bug by itself and probably that should be fixed. Can you 
check second patch attached and see if it trigger the warning.

Note patches are not tested, I expect you'll fix them if they
do not do what expected :-)

Thanks
Stanislaw

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cputime_adjust_modify.patch"

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ed12cbb..63f2358 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -543,7 +543,7 @@ static void cputime_adjust(struct task_cputime *curr,
 			   struct cputime *prev,
 			   cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, stime, total;
+	cputime_t rtime, stime, utime, total;
 
 	stime = curr->stime;
 	total = stime + curr->utime;
@@ -560,10 +560,13 @@ static void cputime_adjust(struct task_cputime *curr,
 	 */
 	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
-	if (total)
+	if (total) {
 		stime = scale_stime(stime, rtime, total);
-	else
+		utime = rtime - stime;
+	} else {
 		stime = rtime;
+		utime = 0;
+	}
 
 	/*
 	 * If the tick based count grows faster than the scheduler one,
@@ -571,7 +574,7 @@ static void cputime_adjust(struct task_cputime *curr,
 	 * Let's enforce monotonicity.
 	 */
 	prev->stime = max(prev->stime, stime);
-	prev->utime = max(prev->utime, rtime - prev->stime);
+	prev->utime = max(prev->utime, utime);
 
 	*ut = prev->utime;
 	*st = prev->stime;

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="check_rtime.patch"

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..3f1c088 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -418,6 +418,7 @@ struct cpu_itimer {
 struct cputime {
 	cputime_t utime;
 	cputime_t stime;
+	cputime_t rtime;
 };
 
 /**
diff --git a/kernel/fork.c b/kernel/fork.c
index 1766d32..d67c219 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1235,6 +1235,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->utimescaled = p->stimescaled = 0;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	p->prev_cputime.utime = p->prev_cputime.stime = 0;
+	p->prev_cputime.rtime = 0;
 #endif
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 	seqlock_init(&p->vtime_seqlock);
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ed12cbb..146e5f1 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -560,6 +560,9 @@ static void cputime_adjust(struct task_cputime *curr,
 	 */
 	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
+	WARN_ON(prev->rtime > rtime);
+	prev->rtime = rtime;
+
 	if (total)
 		stime = scale_stime(stime, rtime, total);
 	else

--J2SCkAp4GZ/dPZZf--
