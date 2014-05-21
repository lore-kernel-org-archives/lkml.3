Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaEUIH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:07:29 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:38769 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaEUIHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:07:21 -0400
Date: Wed, 21 May 2014 10:07:12 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Anatol Pomozov <anatol.pomozov@gmail.com>
cc: Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hanging aio process
In-Reply-To: <CAOMFOmUT-WGbV57qDafM-NJ+=s1OzX-2Q6G6hAh6EV8Vt9yBZw@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1405210954110.1579@denkbrett>
References: <alpine.LFD.2.11.1405191908450.1847@denkbrett> <20140519180851.GD2915@kvack.org> <alpine.LFD.2.11.1405200950480.1606@denkbrett> <alpine.LFD.2.11.1405201508450.1606@denkbrett> <CAOMFOmWfQ2naF+1BE0wSQXpBoyxV6MPm021hY77B4sDpZNZ-Dw@mail.gmail.com>
 <alpine.LFD.2.11.1405201945280.1631@denkbrett>  <CAOMFOmUT-WGbV57qDafM-NJ+=s1OzX-2Q6G6hAh6EV8Vt9yBZw@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052108-4966-0000-0000-000000194C76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Anatol Pomozov wrote:
> On Tue, May 20, 2014 at 11:09 AM, Sebastian Ott
> <sebott@linux.vnet.ibm.com> wrote:
> > On Tue, 20 May 2014, Anatol Pomozov wrote:
> >> On Tue, May 20, 2014 at 6:16 AM, Sebastian Ott
> >> <sebott@linux.vnet.ibm.com> wrote:
> >> > On Tue, 20 May 2014, Sebastian Ott wrote:
> >> >> On Mon, 19 May 2014, Benjamin LaHaise wrote:
> >> >> > It is entirely possible the bug isn't
> >> >> > caused by the referenced commit, as the commit you're pointing to merely
> >> >> > makes io_destroy() syscall wait for all aio outstanding to complete
> >> >> > before returning.
> >> >>
> >> >> I cannot reproduce this when I revert said commit (on top of 14186fe). If
> >> >> that matters - the arch is s390.
> >> >
> >> > Hm, ok - maybe that commit is really just highlighting a refcounting bug.
> >> > I just compared traces for a good and a few bad cases. The good case:
> >> > # tracer: function
> >> > #
> >> > # entries-in-buffer/entries-written: 16/16   #P:4
> >> > #
> >> > #                              _-----=> irqs-off
> >> > #                             / _----=> need-resched
> >> > #                            | / _---=> hardirq/softirq
> >> > #                            || / _--=> preempt-depth
> >> > #                            ||| /     delay
> >> > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> >> > #              | |       |   ||||       |         |
> >> >              fio-732   [003] ....    17.989315: kill_ioctx <-SyS_io_destroy
> >> >              fio-739   [003] ....    18.000563: kill_ioctx <-SyS_io_destroy
> >> >      ksoftirqd/3-19    [003] ..s.    18.031673: free_ioctx_users <-percpu_ref_kill_rcu
> >> >      ksoftirqd/3-19    [003] ..s.    18.031679: free_ioctx_users <-percpu_ref_kill_rcu
> >> >              fio-737   [003] ....    18.038765: kill_ioctx <-SyS_io_destroy
> >> >      ksoftirqd/3-19    [003] ..s.    18.062488: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> >      ksoftirqd/3-19    [003] ..s.    18.062494: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> >      kworker/3:1-57    [003] ....    18.062499: free_ioctx <-process_one_work
> >> >      kworker/3:1-57    [003] ....    18.062506: free_ioctx <-process_one_work
> >> >      ksoftirqd/3-19    [003] ..s.    18.072275: free_ioctx_users <-percpu_ref_kill_rcu
> >> >              fio-738   [003] ....    18.102419: kill_ioctx <-SyS_io_destroy
> >> >           <idle>-0     [003] .ns.    18.111668: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> >      kworker/3:1-57    [003] ....    18.111675: free_ioctx <-process_one_work
> >> >      ksoftirqd/3-19    [003] ..s.    18.138035: free_ioctx_users <-percpu_ref_kill_rcu
> >> >           <idle>-0     [003] .ns.    18.191665: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> >      kworker/3:1-57    [003] ....    18.191671: free_ioctx <-process_one_work
> >> >
> >> > (4 fio workers, free_ioctx_reqs is called 4 times)
> >> >
> >> > One of the bad cases:
> >> > # tracer: function
> >> > #
> >> > # entries-in-buffer/entries-written: 14/14   #P:4
> >> > #
> >> > #                              _-----=> irqs-off
> >> > #                             / _----=> need-resched
> >> > #                            | / _---=> hardirq/softirq
> >> > #                            || / _--=> preempt-depth
> >> > #                            ||| /     delay
> >> > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> >> > #              | |       |   ||||       |         |
> >> >              fio-834   [000] ....    51.127359: kill_ioctx <-SyS_io_destroy
> >> >           <idle>-0     [000] ..s.    51.170237: free_ioctx_users <-percpu_ref_kill_rcu
> >> >              fio-828   [001] ....    51.189717: kill_ioctx <-SyS_io_destroy
> >> >              fio-833   [001] ..s.    51.220178: free_ioctx_users <-percpu_ref_kill_rcu
> >> >           <idle>-0     [000] .ns.    51.220230: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> >      kworker/0:3-661   [000] ....    51.220238: free_ioctx <-process_one_work
> >> >           <idle>-0     [001] .ns.    51.260188: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> >      kworker/1:2-103   [001] ....    51.260198: free_ioctx <-process_one_work
> >> >              fio-833   [002] ....    51.287602: kill_ioctx <-SyS_io_destroy
> >> >            udevd-868   [002] ..s1    51.332519: free_ioctx_users <-percpu_ref_kill_rcu
> >> >           <idle>-0     [002] .ns.    51.450180: free_ioctx_reqs <-percpu_ref_kill_rcu
> >> >      kworker/2:2-191   [002] ....    51.450191: free_ioctx <-process_one_work
> >> >              fio-835   [003] ....    51.907530: kill_ioctx <-SyS_io_destroy
> >> >      ksoftirqd/3-19    [003] ..s.    52.000232: free_ioctx_users <-percpu_ref_kill_rcu
> >> >
> >> > (1 fio worker in D state, free_ioctx_reqs is called 3 times)
> >>
> >>
> >> Looking at the second trace: the first 3 io_destroy() calls cause
> >> free_ioctx_reqs(), but the last one does not call free_ioctx_reqs().
> >> Do you have more logs after the last line?
> >
> > Nope that was all.
> >
> >> If there is no more
> >> free_ioctx_reqs() then it means something keeps ctx->reqs refcounter.
> >> I suggest to add some logging to kernel to figure out what is the
> >> refcount value at this moment.
> >
> > Jep, I did that this morning (via atomic_read(&ctx->reqs.count) in
> > free_ioctx_users before percpu_ref_kill(&ctx->reqs); is called) and
> > the value was always the same
> >         1 + (1UL << 31)
> > even for the free_ioctx_users invocations that were not followed by
> > free_ioctx_reqs.
> 
> Could you add atomic_read(&ctx->reqs.count) *after* the
> percpu_ref_kill(&ctx->reqs)?

I already did that and it didn't change, always 1 + (1UL << 31) in all
cases, before and after percpu_ref_kill(&ctx->reqs). I'm not really
familiar with this percpu_ref stuff but it looks like the initial
reference is dropped asynchronous.

Regards,
Sebastian

> 
> before percpu_ref_kill() the refcounter is per-CPU one and correctly
> calculate the real value you need to take &ctx->reqs.pcpu_count into
> account. But after percpu_ref_kill() the reqs.count become the normal
> shared refcounter.
> 
> >
> >>
> >> But *if* there was one more free_ioctx_reqs() that does not
> >> complete(ctx->requests_done) then it means the thread does not see
> >> value of requests_done field. It would make me believe there is a
> >> problem with memory reordering. I do not know whether s390 reorders
> >> stores, but anyway, could you please check this patch?
> >
> > Nope s390 doesn't reorder stores - I tried the patch anyway, but it didn't
> > help.
> >
> > Regards,
> > Sebastian
> >>
> >> anatol:linux $ git diff
> >> diff --git a/fs/aio.c b/fs/aio.c
> >> index a0ed6c7..6e3c0bb 100644
> >> --- a/fs/aio.c
> >> +++ b/fs/aio.c
> >> @@ -514,6 +514,7 @@ static void free_ioctx_reqs(struct percpu_ref *ref)
> >>         struct kioctx *ctx = container_of(ref, struct kioctx, reqs);
> >>
> >>         /* At this point we know that there are no any in-flight requests */
> >> +       rmb();
> >>         if (ctx->requests_done)
> >>                 complete(ctx->requests_done);
> >>
> >> @@ -758,6 +759,7 @@ static void kill_ioctx(struct mm_struct *mm,
> >> struct kioctx *ctx,
> >>                         vm_munmap(ctx->mmap_base, ctx->mmap_size);
> >>
> >>                 ctx->requests_done = requests_done;
> >> +               wmb();
> >>                 percpu_ref_kill(&ctx->users);
> >>         } else {
> >>                 if (requests_done)
> >>
> >>
> >
> 
> 

