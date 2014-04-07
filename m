Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaDGFcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:32:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:64232 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaDGFcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:32:31 -0400
Message-ID: <1396848585.5218.27.camel@marge.simpson.net>
Subject: Re: [tip:sched/core] sched/numa: Move task_numa_free() to
 __put_task_struct()
From: Mike Galbraith <bitbucket@online.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, mgorman@suse.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, Dave Jones <davej@redhat.com>
Date: Mon, 07 Apr 2014 07:29:45 +0200
In-Reply-To: <5341A84C.4050902@oracle.com>
References: <1393568591.6018.27.camel@marge.simpson.net>
	 <tip-156654f491dd8d52687a5fbe1637f472a52ce75b@git.kernel.org>
	 <5341A84C.4050902@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:kN+dX/e3GDDcZJM1D3rmiDHjDcOnU45MJZyGRxcWdvc
 4HfoN8Qg8eZLoVqLNcQag5h7kjDhYrg2Y+PKlNhtDlwT82vHKe
 oOwqM0y7y+PHsQ8t3BU36w0yCLVwABfRjtVZZmYis1Us655JFT
 rhtMflEq4iyuqB0ZuKW0vEWjVMtXUZ3w95TCGEfjcLV1HyQFYc
 eVS3cZo2j5LNdoiKQMAlN47nVtpmCqc+feSmmi1uSpxUNczFtc
 JxlVcLl7ZIgLepGfcKByFqWKdhsETA98LyTMOg/63nOT06EykO
 sQw/A3X4ckEcxIoMS2gXQHk71n7mMHIgV2EKQODKJogRj8XByY
 c/VzfIdaEryewts6GEpxLq4jYwhgspWLx4iMRfMSL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 15:17 -0400, Sasha Levin wrote: 
> On 03/11/2014 08:40 AM, tip-bot for Mike Galbraith wrote:
> > Commit-ID:  156654f491dd8d52687a5fbe1637f472a52ce75b
> > Gitweb:     http://git.kernel.org/tip/156654f491dd8d52687a5fbe1637f472a52ce75b
> > Author:     Mike Galbraith <bitbucket@online.de>
> > AuthorDate: Fri, 28 Feb 2014 07:23:11 +0100
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Tue, 11 Mar 2014 12:05:43 +0100
> > 
> > sched/numa: Move task_numa_free() to __put_task_struct()
> > 
> > Bad idea on -rt:
> > 
> > [  908.026136]  [<ffffffff8150ad6a>] rt_spin_lock_slowlock+0xaa/0x2c0
> > [  908.026145]  [<ffffffff8108f701>] task_numa_free+0x31/0x130
> > [  908.026151]  [<ffffffff8108121e>] finish_task_switch+0xce/0x100
> > [  908.026156]  [<ffffffff81509c0a>] thread_return+0x48/0x4ae
> > [  908.026160]  [<ffffffff8150a095>] schedule+0x25/0xa0
> > [  908.026163]  [<ffffffff8150ad95>] rt_spin_lock_slowlock+0xd5/0x2c0
> > [  908.026170]  [<ffffffff810658cf>] get_signal_to_deliver+0xaf/0x680
> > [  908.026175]  [<ffffffff8100242d>] do_signal+0x3d/0x5b0
> > [  908.026179]  [<ffffffff81002a30>] do_notify_resume+0x90/0xe0
> > [  908.026186]  [<ffffffff81513176>] int_signal+0x12/0x17
> > [  908.026193]  [<00007ff2a388b1d0>] 0x7ff2a388b1cf
> > 
> > and since upstream does not mind where we do this, be a bit nicer ...
> > 
> > Signed-off-by: Mike Galbraith <bitbucket@online.de>
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > Cc: Mel Gorman <mgorman@suse.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Link: http://lkml.kernel.org/r/1393568591.6018.27.camel@marge.simpson.net
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> As it seems, upstream does mind:
> 
> [ 2590.260734] ======================================================
> [ 2590.261695] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> [ 2590.262748] 3.14.0-next-20140403-sasha-00022-g10224c0 #377 Tainted: G        W
> [ 2590.263846] ------------------------------------------------------
> [ 2590.264730] trinity-c244/1210 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> [ 2590.265783] (&(&grp->lock)->rlock){+.+...}, at: task_numa_free (kernel/sched/fair.c:1714)
> [ 2590.267179]
> [ 2590.267179] and this task is already holding:
> [ 2590.267996] (&(&new_timer->it_lock)->rlock){-.....}, at: exit_itimers (kernel/posix-timers.c:971 kernel/posix-timers.c:998)
> [ 2590.269381] which would create a new lock dependency:
> [ 2590.270067]  (&(&new_timer->it_lock)->rlock){-.....} -> (&(&grp->lock)->rlock){+.+...}

I'm not getting it.

I moved task_numa_free() from one interrupts enabled spot to another.
But, with numa=fake=4 and lockdep enabled, not only does lockdep gripe,
my little box locks up on splat.  Saying spin_lock/unlock_irq() did the
expected, just moved lockdep gripe to task_numa_fault().


> [ 2590.270067]  Possible interrupt unsafe locking scenario:
> [ 2590.270067]
> [ 2590.270067]        CPU0                    CPU1
> [ 2590.270067]        ----                    ----
> [ 2590.270067]   lock(&(&grp->lock)->rlock);
> [ 2590.270067]                                local_irq_disable();
> [ 2590.270067]                                lock(&(&new_timer->it_lock)->rlock);
> [ 2590.270067]                                lock(&(&grp->lock)->rlock);
> [ 2590.270067]   <Interrupt>
> [ 2590.270067]     lock(&(&new_timer->it_lock)->rlock);
> [ 2590.270067]
> [ 2590.270067]  *** DEADLOCK ***

Ok, so how did I manage that HARDIRQ-safe -> HARDIRQ-unsafe?

-Mike

