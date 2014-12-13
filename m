Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaLMSIC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 13:08:02 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:37598 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaLMSIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 13:08:00 -0500
Date: Sat, 13 Dec 2014 10:07:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, David Lang <david@lang.hm>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141213180752.GI25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <alpine.DEB.2.02.1412121157060.18579@nftneq.ynat.uz>
 <20141212203417.GE25340@linux.vnet.ibm.com>
 <548B5CEC.1040607@oracle.com>
 <20141213083055.GI32572@gmail.com>
 <548C60FF.9020607@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548C60FF.9020607@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121318-0013-0000-0000-0000070A8EB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 10:53:35AM -0500, Sasha Levin wrote:
> On 12/13/2014 03:30 AM, Ingo Molnar wrote:
> >> > This is my no_hz related config:
> >> > 
> >> > $ grep NO_HZ .config
> >> > CONFIG_NO_HZ_COMMON=y
> >> > # CONFIG_NO_HZ_IDLE is not set
> >> > CONFIG_NO_HZ_FULL=y
> >> > CONFIG_NO_HZ_FULL_ALL=y
> > Just curious, if you disable NO_HZ_FULL_ALL, does the bug change?
> 
> On 12/13/2014 07:08 AM, Paul E. McKenney wrote:
> > Alternatively, your could boot with nohz_full=2-27 (or maybe even
> > nohz_full=4-27).  This will override CONFIG_NO_HZ_FULL_ALL=y and will
> > provide two (or four with 4-27) housekeeping CPUs that are available to
> > run things like RCU grace-period kthreads and RCU callback processing.
> > This might allow RCU to get the CPU bandwidth it needs despite
> > competition from your workload.
> 
> I've tried both nohz_full=4-27 and disabling CONFIG_NO_HZ_FULL_ALL
> altogether, but I'm still seeing the stall:

And again looping in workqueues, despite the cond_resched_rcu_qs() there.
And the reason for that is that cond_resched_rcu_qs() currently only
provides quiescent states for tasks RCU.  I will put together something
that makes it work for other RCU flavors.

Not that this is likely to do much about Dave Jones's lockup, but one
thing at a time...

							Thanx, Paul

> [  725.670017] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [  725.670017]  0: (11 ticks this GP) idle=bbd/140000000000002/0 softirq=11529/11529 fqs=0 last_accelerate: 9d0e/a648, nonlazy_posted: 721357, ..
> [  725.670017]  (detected by 16, t=2102 jiffies, g=9857, c=9856, q=2581)
> [  725.670017] Task dump for CPU 0:
> [  725.670017] kworker/0:1     S ffff8800633abde8 13016   520      2 0x10080008
> [  725.670017]  ffffffffb03027a8 ffff880a70f24017 ffffffffb043ef40 ffff88005ffea310
> [  725.670017]  0000000000000000 dfffe90000000000 0000000000000000 1ffffffff63bcdeb
> [  725.670017]  ffff88006be15030 ffffffffb1de6f58 ffffffffffffff10 ffffffffb0301237
> [  725.670017] Call Trace:
> [  725.670017]  [<ffffffffb03027a8>] ? retint_restore_args+0x13/0x13
> [  725.670017]  [<ffffffffb0301237>] ? _raw_spin_unlock_irq+0x57/0x200
> [  725.670017]  [<ffffffffb0301203>] ? _raw_spin_unlock_irq+0x23/0x200
> [  725.670017]  [<ffffffffa04630cb>] ? worker_thread+0x15b/0x1680
> [  725.670017]  [<ffffffffb02effef>] ? __schedule+0xf6f/0x2fc0
> [  725.670017]  [<ffffffffa0462f70>] ? process_one_work+0x1650/0x1650
> [  725.670017]  [<ffffffffa047ae12>] ? kthread+0x1f2/0x2b0
> [  725.670017]  [<ffffffffa047ac20>] ? kthread_worker_fn+0x6a0/0x6a0
> [  725.670017]  [<ffffffffb03018bc>] ? ret_from_fork+0x7c/0xb0
> [  725.670017]  [<ffffffffa047ac20>] ? kthread_worker_fn+0x6a0/0x6a0
> 
> 
> Thanks,
> Sasha
> 

