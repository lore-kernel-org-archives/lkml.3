Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbaLHP4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:56:23 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:47411 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbaLHP4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:56:20 -0500
Date: Mon, 8 Dec 2014 07:56:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141208155614.GL25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <54813C03.8040009@oracle.com>
 <CA+55aFyZOo=HzB_n3gLqswFsN1FcMdumaKLBk+fbhDD3wrvXnA@mail.gmail.com>
 <5481C92E.6020805@oracle.com>
 <CA+55aFxnCxJcg7NgNeqn_P_TugpcHTUk+v21Td25Aw6+2Z8=YA@mail.gmail.com>
 <54846B06.8050906@oracle.com>
 <20141207182420.GG25340@linux.vnet.ibm.com>
 <20141207194304.GA17810@linux.vnet.ibm.com>
 <5484E2AB.1070503@oracle.com>
 <20141208052048.GJ25340@linux.vnet.ibm.com>
 <5485B6B9.7010800@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5485B6B9.7010800@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120815-0009-0000-0000-000006F4DDC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 09:33:29AM -0500, Sasha Levin wrote:
> On 12/08/2014 12:20 AM, Paul E. McKenney wrote:
> > I have seen this caused by lost IPIs, but you have to lose two of them,
> > which seems less than fully likely.
> 
> It does seem that it can cause full blown stalls as well, just pretty
> rarely (notice the lack of any prints before):

This is back in the TLB-flush and free-pagef arena.  But unless you
have an extremely large process, I wouldn't expect this to take 30K
jiffies.

> [11373.032327] audit: type=1326 audit(1397703594.974:502): auid=4294967295 uid=7884781 gid=0 ses=4294967295 pid=9853 comm="trinity-c768" exe="/trinity/trinity" sig=9 arch=c0000
> 03e syscall=96 compat=0 ip=0x7fff2c3fee47 code=0x0
> [11374.565881] audit: type=1326 audit(1397703596.504:503): auid=4294967295 uid=32 gid=0
>  ses=4294967295 pid=9801 comm="trinity-c710" exe="/trinity/trinity" sig=9 arch=c000003e syscall=96 compat=0 ip=0x7fff2c3fee47 code=0x0
> [11839.353539] Hangcheck: hangcheck value past margin!
> [12040.010128] INFO: rcu_sched detected stalls on CPUs/tasks:
> [12040.012072]  (detected by 4, t=213513 jiffies, g=-222, c=-223, q=0)
> [12040.014200] INFO: Stall ended before state dump start
> [12159.730069] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [12159.730069]  (detected by 3, t=396537 jiffies, g=24095, c=24094, q=1346)
> [12159.730069] INFO: Stall ended before state dump start
> [12602.162439] Hangcheck: hangcheck value past margin!
> [12655.560806] INFO: rcu_sched detected stalls on CPUs/tasks:
> [12655.560806]  0: (3 ticks this GP) idle=bc3/140000000000002/0 softirq=26674/26674 last_accelerate: b2a8/da68, nonlazy_posted: 20893, ..

And the above is what I was looking for from RCU_CPU_STALL_INFO, thank you!

This CPU only saw three scheduling-clock ticks during this grace period,
which suggests that your workload is not very intense or that you are
running NO_HZ_FULL with this CPU having a single CPU-bound userspace task.

The CPU is currently not idle (no surprise).  There has been no softirq
activity during this grace period.  There was at least one callback
acceleration during this grace period (irrelevant to this bug), and there
have been more than 26K non-lazy callbacks posted during this grace
period (no surprise, given that the grace period has been in force for
more than 30K jiffies).

							Thanx, Paul

> [12655.602171]  (detected by 13, t=30506 jiffies, g=-219, c=-220, q=0)
> [12655.602171] Task dump for CPU 0:
> [12655.602171] trinity-c39     R  running task    11904  6558  26120 0x0008000c
> [12655.602171]  ffffffff81593bf7 ffff8808d5d58d40 0000000000000282 ffffffff9ef40538
> [12655.602171]  ffff880481400000 ffff8808d5dcb638 ffffffff83f2ed2b ffffffff9eaa1718
> [12655.602171]  ffff8808d5d58d08 00000b820c44b0ae 0000000000000000 0000000000000001
> [12655.602171] Call Trace:
> [12655.602171]  [<ffffffff81593bf7>] ? trace_hardirqs_on_caller+0x677/0x900
> [12655.602171]  [<ffffffff83f2ed2b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [12655.602171]  [<ffffffff91677ffb>] ? retint_restore_args+0x13/0x13
> [12655.602171]  [<ffffffff91676612>] ? _raw_spin_unlock_irqrestore+0xa2/0xf0
> [12655.602171]  [<ffffffff83f93705>] ? __debug_check_no_obj_freed+0x2f5/0xd90
> [12655.602171]  [<ffffffff81593bf7>] ? trace_hardirqs_on_caller+0x677/0x900
> [12655.602171]  [<ffffffff83f95ba9>] ? debug_check_no_obj_freed+0x19/0x20
> [12655.602171]  [<ffffffff819049bf>] ? free_pages_prepare+0x5bf/0x1000
> [12655.602171]  [<ffffffff83f90fe3>] ? __this_cpu_preempt_check+0x13/0x20
> [12655.602171]  [<ffffffff8190cacd>] ? __free_pages_ok+0x3d/0x360
> [12655.602171]  [<ffffffff8190ce7d>] ? free_compound_page+0x8d/0xd0
> [12655.602171]  [<ffffffff81929986>] ? __put_compound_page+0x46/0x70
> [12655.602171]  [<ffffffff8192b395>] ? put_compound_page+0xf5/0x10e0
> [12655.602171]  [<ffffffff814d99ab>] ? preempt_count_sub+0x11b/0x1d0
> [12655.602171]  [<ffffffff8192da4d>] ? release_pages+0x41d/0x6f0
> [12655.602171]  [<ffffffff81a0188b>] ? free_pages_and_swap_cache+0x11b/0x1a0
> [12655.602171]  [<ffffffff819a6b92>] ? tlb_flush_mmu_free+0x72/0x180
> [12655.602171]  [<ffffffff819ace76>] ? unmap_single_vma+0x1326/0x2170
> [12655.602171]  [<ffffffff83f90fe3>] ? __this_cpu_preempt_check+0x13/0x20
> [12655.602171]  [<ffffffff819b0644>] ? unmap_vmas+0xd4/0x250
> [12655.602171]  [<ffffffff819d62c9>] ? exit_mmap+0x169/0x610
> [12655.602171]  [<ffffffff81a678fd>] ? kmem_cache_free+0x7cd/0xbb0
> [12655.602171]  [<ffffffff814095b2>] ? mmput+0xd2/0x2c0
> [12655.602171]  [<ffffffff81423551>] ? do_exit+0x7e1/0x39c0
> [12655.602171]  [<ffffffff81456fb2>] ? get_signal+0x7a2/0x2130
> [12655.602171]  [<ffffffff81426891>] ? do_group_exit+0x101/0x490
> [12655.602171]  [<ffffffff814d99ab>] ? preempt_count_sub+0x11b/0x1d0
> [12655.602171]  [<ffffffff81456f4e>] ? get_signal+0x73e/0x2130
> [12655.602171]  [<ffffffff811d59f1>] ? sched_clock+0x31/0x50
> [12655.602171]  [<ffffffff81585ded>] ? get_lock_stats+0x1d/0x100
> [12655.602171]  [<ffffffff811ac828>] ? do_signal+0x28/0x3750
> [12655.602171]  [<ffffffff814f7f73>] ? vtime_account_user+0x173/0x220
> [12655.602171]  [<ffffffff814d96c1>] ? get_parent_ip+0x11/0x50
> [12655.602171]  [<ffffffff83f90fe3>] ? __this_cpu_preempt_check+0x13/0x20
> [12655.602171]  [<ffffffff81593bf7>] ? trace_hardirqs_on_caller+0x677/0x900
> [12655.602171]  [<ffffffff81593e8d>] ? trace_hardirqs_on+0xd/0x10
> [12655.602171]  [<ffffffff811affb9>] ? do_notify_resume+0x69/0x100
> [12655.602171]  [<ffffffff9167744f>] ? int_signal+0x12/0x17
> 
> 
> Thanks,
> Sasha
> 

