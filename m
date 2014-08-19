Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaHSO0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:26:47 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46026 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaHSO0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:26:45 -0400
Message-ID: <1408458401.18505.31.camel@marge.simpson.net>
Subject: Re: [PATCH v2 2/3] time,signal: protect resource use statistics
 with seqlock
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, akpm@linux-foundation.org,
        srao@redhat.com, lwoodman@redhat.com, atheurer@redhat.com
Date: Tue, 19 Aug 2014 16:26:41 +0200
In-Reply-To: <53F207B4.6070908@redhat.com>
References: <1408133138-22048-1-git-send-email-riel@redhat.com>
	 <1408133138-22048-3-git-send-email-riel@redhat.com>
	 <20140816141159.GA8709@redhat.com>
	 <20140816134010.26a9b572@annuminas.surriel.com>
	 <20140816175002.GA24994@redhat.com>
	 <1408337089.5570.16.camel@marge.simpson.net> <53F207B4.6070908@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-18 at 10:03 -0400, Rik van Riel wrote: 
> On 08/18/2014 12:44 AM, Mike Galbraith wrote:
> > On Sat, 2014-08-16 at 19:50 +0200, Oleg Nesterov wrote:
> >> On 08/16, Rik van Riel wrote:
> >>>
> >>> +	do {
> >>> +		seq = nextseq;
> >>> +		read_seqbegin_or_lock(&sig->stats_lock, &seq);
> >>> +		times->utime = sig->utime;
> >>> +		times->stime = sig->stime;
> >>> +		times->sum_exec_runtime = sig->sum_sched_runtime;
> >>> +
> >>> +		for_each_thread(tsk, t) {
> >>> +			task_cputime(t, &utime, &stime);
> >>> +			times->utime += utime;
> >>> +			times->stime += stime;
> >>> +			times->sum_exec_runtime += task_sched_runtime(t);
> >>> +		}
> >>> +		/* If lockless access failed, take the lock. */
> >>> +		nextseq = 1;
> >>
> >> Yes, thanks, this answers my concerns.
> >>
> >> Cough... can't resist, and I still think that we should take rcu_read_lock()
> >> only around for_each_thread() and the patch expands the critical section for
> >> no reason. But this is minor, I won't insist.
> >
> > Hm.  Should traversal not also disable preemption to preserve the error
> > bound Peter mentioned?
> 
> The second traversal takes the spinlock, which automatically
> disables preemption.

According to my testing, a PREEMPT kernel can get all the way through
thread_group_cputime() lockless, preemption can/does happen during
traversal, the call can and does then take more than ticks * CPUs (can
take LOTS more if you get silly), so Peter's bound appears to be toast
for PREEMPT.

Not that I really care mind you, just seemed the folks who don't do
zillion threads, would never feel the pain you're alleviating, now get
some accuracy loss if running PREEMPT.

BTW, something else that doesn't matter one bit but I was curious about,
as noted, clock_gettime() used to use the tasklist_lock, which is loads
better than siglock, at least on a modest box.  On a 64 core box with
200 threads, crusty old 3.0 kernel is faster than patched up master, and
configs are both NOPREEMPT tune-for-maximum-bloat.

('course what zillion cores + zillion threads does with tasklist_lock
ain't _at all_ pretty, but it doesn't demolish modest boxen)

patched master 
vogelweide:/abuild/mike/:[0]# time ./pound_clock_gettime

real    0m2.953s
user    0m0.036s
sys     3m2.588s
vogelweide:/abuild/mike/:[0]# time ./pound_clock_gettime

real    0m2.930s
user    0m0.076s
sys     3m1.800s
vogelweide:/abuild/mike/:[0]# time ./pound_clock_gettime

real    0m2.988s
user    0m0.052s
sys     3m5.208s

sle11-sp3 (3.0.101)
vogelweide:/abuild/mike/:[0]# time ./pound_clock_gettime

real    0m1.521s
user    0m0.072s
sys     0m8.397s
vogelweide:/abuild/mike/:[0]# time ./pound_clock_gettime

real    0m1.260s
user    0m0.032s
sys     0m6.244s
vogelweide:/abuild/mike/:[0]# time ./pound_clock_gettime

real    0m1.391s
user    0m0.020s
sys     0m7.016s

