Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaFDN6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:58:33 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:33993 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaFDN6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:58:31 -0400
Date: Wed, 4 Jun 2014 15:58:24 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Anatol Pomozov <anatol.pomozov@gmail.com>
cc: Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        Kent Overstreet <kmo@daterainc.com>, Tejun Heo <tj@kernel.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] percpu-refcount: fix usage of this_cpu_ops (was Re: hanging
 aio process)
In-Reply-To: <CAOMFOmXXHBicH38onWgVAWhEXe2sE_RMiJXi=iMjJB15o7mOLQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1406041540520.21183@denkbrett>
References: <alpine.LFD.2.11.1405191908450.1847@denkbrett> <20140519180851.GD2915@kvack.org> <alpine.LFD.2.11.1405200950480.1606@denkbrett> <alpine.LFD.2.11.1405201508450.1606@denkbrett> <CAOMFOmWfQ2naF+1BE0wSQXpBoyxV6MPm021hY77B4sDpZNZ-Dw@mail.gmail.com>
 <alpine.LFD.2.11.1405201945280.1631@denkbrett> <CAOMFOmUT-WGbV57qDafM-NJ+=s1OzX-2Q6G6hAh6EV8Vt9yBZw@mail.gmail.com> <alpine.LFD.2.11.1405210954110.1579@denkbrett> <alpine.LFD.2.11.1405211042350.1579@denkbrett> 
 <CAOMFOmXXHBicH38onWgVAWhEXe2sE_RMiJXi=iMjJB15o7mOLQ@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060413-0542-0000-0000-0000094D770B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, 21 May 2014, Anatol Pomozov wrote:
> Hi
> 
> On Wed, May 21, 2014 at 1:48 AM, Sebastian Ott
> <sebott@linux.vnet.ibm.com> wrote:
> > On Wed, 21 May 2014, Sebastian Ott wrote:
> >> On Tue, 20 May 2014, Anatol Pomozov wrote:
> >> > On Tue, May 20, 2014 at 11:09 AM, Sebastian Ott
> >> > <sebott@linux.vnet.ibm.com> wrote:
> >> > > On Tue, 20 May 2014, Anatol Pomozov wrote:
> >> > >> On Tue, May 20, 2014 at 6:16 AM, Sebastian Ott
> >> > >> <sebott@linux.vnet.ibm.com> wrote:
> >> > >> > On Tue, 20 May 2014, Sebastian Ott wrote:
> >> > >> >> On Mon, 19 May 2014, Benjamin LaHaise wrote:
> >> > >> >> > It is entirely possible the bug isn't
> >> > >> >> > caused by the referenced commit, as the commit you're pointing to merely
> >> > >> >> > makes io_destroy() syscall wait for all aio outstanding to complete
> >> > >> >> > before returning.
> >> > >> >>
> >> > >> >> I cannot reproduce this when I revert said commit (on top of 14186fe). If
> >> > >> >> that matters - the arch is s390.
> >> > >> >
> >> > >> > Hm, ok - maybe that commit is really just highlighting a refcounting bug.
> >> > >> > I just compared traces for a good and a few bad cases. The good case:
> >> > >> > # tracer: function
> >> > >> > #
> >> > >> > # entries-in-buffer/entries-written: 16/16   #P:4
> >> > >> > #
> >> > >> > #                              _-----=> irqs-off
> >> > >> > #                             / _----=> need-resched
> >> > >> > #                            | / _---=> hardirq/softirq
> >> > >> > #                            || / _--=> preempt-depth
> >> > >> > #                            ||| /     delay
> >> > >> > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> >> > >> > #              | |       |   ||||       |         |
> >> > >> >              fio-732   [003] ....    17.989315: kill_ioctx <-SyS_io_destroy
> >> > >> >              fio-739   [003] ....    18.000563: kill_ioctx <-SyS_io_destroy
> >> > >> >      ksoftirqd/3-19    [003] ..s.    18.031673: free_ioctx_users <-percpu_ref_kill_rcu
> >> > >> >      ksoftirqd/3-19    [003] ..s.    18.031679: free_ioctx_users <-percpu_ref_kill_rcu
> >> > >> >              fio-737   [003] ....    18.038765: kill_ioctx <-SyS_io_destroy
> >> > >> >      ksoftirqd/3-19    [003] ..s.    18.062488: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> > >> >      ksoftirqd/3-19    [003] ..s.    18.062494: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> > >> >      kworker/3:1-57    [003] ....    18.062499: free_ioctx <-process_one_work
> >> > >> >      kworker/3:1-57    [003] ....    18.062506: free_ioctx <-process_one_work
> >> > >> >      ksoftirqd/3-19    [003] ..s.    18.072275: free_ioctx_users <-percpu_ref_kill_rcu
> >> > >> >              fio-738   [003] ....    18.102419: kill_ioctx <-SyS_io_destroy
> >> > >> >           <idle>-0     [003] .ns.    18.111668: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> > >> >      kworker/3:1-57    [003] ....    18.111675: free_ioctx <-process_one_work
> >> > >> >      ksoftirqd/3-19    [003] ..s.    18.138035: free_ioctx_users <-percpu_ref_kill_rcu
> >> > >> >           <idle>-0     [003] .ns.    18.191665: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> > >> >      kworker/3:1-57    [003] ....    18.191671: free_ioctx <-process_one_work
> >> > >> >
> >> > >> > (4 fio workers, free_ioctx_reqs is called 4 times)
> >> > >> >
> >> > >> > One of the bad cases:
> >> > >> > # tracer: function
> >> > >> > #
> >> > >> > # entries-in-buffer/entries-written: 14/14   #P:4
> >> > >> > #
> >> > >> > #                              _-----=> irqs-off
> >> > >> > #                             / _----=> need-resched
> >> > >> > #                            | / _---=> hardirq/softirq
> >> > >> > #                            || / _--=> preempt-depth
> >> > >> > #                            ||| /     delay
> >> > >> > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> >> > >> > #              | |       |   ||||       |         |
> >> > >> >              fio-834   [000] ....    51.127359: kill_ioctx <-SyS_io_destroy
> >> > >> >           <idle>-0     [000] ..s.    51.170237: free_ioctx_users <-percpu_ref_kill_rcu
> >> > >> >              fio-828   [001] ....    51.189717: kill_ioctx <-SyS_io_destroy
> >> > >> >              fio-833   [001] ..s.    51.220178: free_ioctx_users <-percpu_ref_kill_rcu
> >> > >> >           <idle>-0     [000] .ns.    51.220230: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> > >> >      kworker/0:3-661   [000] ....    51.220238: free_ioctx <-process_one_work
> >> > >> >           <idle>-0     [001] .ns.    51.260188: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> > >> >      kworker/1:2-103   [001] ....    51.260198: free_ioctx <-process_one_work
> >> > >> >              fio-833   [002] ....    51.287602: kill_ioctx <-SyS_io_destroy
> >> > >> >            udevd-868   [002] ..s1    51.332519: free_ioctx_users <-percpu_ref_kill_rcu
> >> > >> >           <idle>-0     [002] .ns.    51.450180: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> > >> >      kworker/2:2-191   [002] ....    51.450191: free_ioctx <-process_one_work
> >> > >> >              fio-835   [003] ....    51.907530: kill_ioctx <-SyS_io_destroy
> >> > >> >      ksoftirqd/3-19    [003] ..s.    52.000232: free_ioctx_users <-percpu_ref_kill_rcu
> >> > >> >
> >> > >> > (1 fio worker in D state, free_ioctx_reqs is called 3 times)
> >> > >>
> >> > >>
> >> > >> Looking at the second trace: the first 3 io_destroy() calls cause
> >> > >> free_ioctx_reqs(), but the last one does not call free_ioctx_reqs().
> >> > >> Do you have more logs after the last line?
> >> > >
> >> > > Nope that was all.
> >> > >
> >> > >> If there is no more
> >> > >> free_ioctx_reqs() then it means something keeps ctx->reqs refcounter.
> >> > >> I suggest to add some logging to kernel to figure out what is the
> >> > >> refcount value at this moment.
> >> > >
> >> > > Jep, I did that this morning (via atomic_read(&ctx->reqs.count) in
> >> > > free_ioctx_users before percpu_ref_kill(&ctx->reqs); is called) and
> >> > > the value was always the same
> >> > >         1 + (1UL << 31)
> >> > > even for the free_ioctx_users invocations that were not followed by
> >> > > free_ioctx_reqs.
> >> >
> >> > Could you add atomic_read(&ctx->reqs.count) *after* the
> >> > percpu_ref_kill(&ctx->reqs)?
> >>
> >> I already did that and it didn't change, always 1 + (1UL << 31) in all
> >> cases, before and after percpu_ref_kill(&ctx->reqs). I'm not really
> >> familiar with this percpu_ref stuff but it looks like the initial
> >> reference is dropped asynchronous.
> >
> >
> > cat /sys/kernel/debug/tracing/trace
> > # tracer: function
> > #
> > # entries-in-buffer/entries-written: 25/25   #P:4
> > #
> > #                              _-----=> irqs-off
> > #                             / _----=> need-resched
> > #                            | / _---=> hardirq/softirq
> > #                            || / _--=> preempt-depth
> > #                            ||| /     delay
> > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> > #              | |       |   ||||       |         |
> >              fio-856   [001] ....   160.876428: SyS_io_destroy: 0000000074a18000
> >              fio-856   [001] ....   160.876430: kill_ioctx <-SyS_io_destroy
> >              fio-855   [000] ....   160.887737: SyS_io_destroy: 0000000074f40600
> >              fio-855   [000] ....   160.887738: kill_ioctx <-SyS_io_destroy
> >              fio-849   [001] ..s.   160.911948: free_ioctx_users <-percpu_ref_kill_rcu
> >      ksoftirqd/0-3     [000] ..s.   160.932488: free_ioctx_users <-percpu_ref_kill_rcu
> >              fio-854   [001] ....   160.938881: SyS_io_destroy: 0000000074ac0600
> >              fio-854   [001] ....   160.938881: kill_ioctx <-SyS_io_destroy
> >      ksoftirqd/1-11    [001] ..s.   160.942016: aio_confirm_reqs: 0000000074a18000 reqs=1
> >      ksoftirqd/1-11    [001] ..s.   160.942016: free_ioctx_reqs <-percpu_ref_kill_rcu
> >      kworker/1:2-465   [001] ....   160.942021: free_ioctx <-process_one_work
> >              fio-856   [002] ....   160.942033: SyS_io_destroy: 0000000074a18000 done
> >              fio-849   [002] ....   160.942641: SyS_io_destroy: 0000000074f28600
> >              fio-849   [002] ....   160.942641: kill_ioctx <-SyS_io_destroy
> >      ksoftirqd/1-11    [001] ..s.   160.961981: free_ioctx_users <-percpu_ref_kill_rcu
> >           <idle>-0     [000] .ns.   160.962010: aio_confirm_reqs: 0000000074f40600 reqs=1
> >           <idle>-0     [000] .ns.   160.962011: free_ioctx_reqs <-percpu_ref_kill_rcu
> >      kworker/0:0-4     [000] ....   160.962016: free_ioctx <-process_one_work
> >              fio-855   [001] ....   160.962017: SyS_io_destroy: 0000000074f40600 done
> >      ksoftirqd/2-15    [002] ..s.   160.971998: free_ioctx_users <-percpu_ref_kill_rcu
> >      ksoftirqd/1-11    [001] ..s.   160.994552: aio_confirm_reqs: 0000000074ac0600 reqs=2
> 
> Here it is. aio context 0000000074ac0600 has refcount == 2 (one for
> initial refcount and one grabbed by someone). You need to find the one
> who grabbed the refcount and figure out why it does not drop it.

I did some more debugging with a minimal testcase using just one cpu. The
traces showed some totally wrong values in the percpu refcounter when
switching between softirq and process context happens. Heiko found and
fixed the bug leading to that.

Regards,
Sebastian

>From 82295633cad58c7d6b9af4e470e3168ed43a6779 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 4 Jun 2014 12:53:19 +0200
Subject: [PATCH] percpu-refcount: fix usage of this_cpu_ops

The percpu-refcount infrastructure uses the underscore variants of
this_cpu_ops in order to modify percpu reference counters.
(e.g. __this_cpu_inc()).

However the underscore variants do not atomically update the percpu
variable, instead they may be implemented using read-modify-write
semantics (more than one instruction).  Therefore it is only safe to
use the underscore variant if the context is always the same (process,
softirq, or hardirq). Otherwise it is possible to lose updates.

This problem is something that Sebastian has seen within the aio
subsystem which uses percpu refcounters both in process and softirq
context leading to reference counts that never dropped to zeroes; even
though the number of "get" and "put" calls matched.

Fix this by using the non-underscore this_cpu_ops variant which
provides correct per cpu atomic semantics and fixes the corrupted
reference counts.

Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org> # v3.11+
Reported-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/percpu-refcount.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 95961f0bf62d..0afb48fd449d 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -110,7 +110,7 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);

 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
-		__this_cpu_inc(*pcpu_count);
+		this_cpu_inc(*pcpu_count);
 	else
 		atomic_inc(&ref->count);

@@ -139,7 +139,7 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);

 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR)) {
-		__this_cpu_inc(*pcpu_count);
+		this_cpu_inc(*pcpu_count);
 		ret = true;
 	}

@@ -164,7 +164,7 @@ static inline void percpu_ref_put(struct percpu_ref *ref)
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);

 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
-		__this_cpu_dec(*pcpu_count);
+		this_cpu_dec(*pcpu_count);
 	else if (unlikely(atomic_dec_and_test(&ref->count)))
 		ref->release(ref);

-- 
1.8.5.5

