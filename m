Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbaLOGdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:33:41 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34816 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaLOGdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:33:40 -0500
Date: Sun, 14 Dec 2014 22:33:31 -0800
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
Message-ID: <20141215063331.GL5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.02.1412121157060.18579@nftneq.ynat.uz>
 <20141212203417.GE25340@linux.vnet.ibm.com>
 <548B5CEC.1040607@oracle.com>
 <20141213083055.GI32572@gmail.com>
 <548C60FF.9020607@oracle.com>
 <20141213180752.GI25340@linux.vnet.ibm.com>
 <20141214175007.GA6927@linux.vnet.ibm.com>
 <548E214D.6040706@oracle.com>
 <20141215001123.GK5310@linux.vnet.ibm.com>
 <548E374D.1040003@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <548E374D.1040003@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121506-0017-0000-0000-0000071D6E61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 08:20:13PM -0500, Sasha Levin wrote:
> On 12/14/2014 07:11 PM, Paul E. McKenney wrote:
> >> Does it depend on anything not currently in -next? My build fails with
> >> > 
> >> > kernel/rcu/tree.c: In function ‘rcu_report_qs_rdp’:
> >> > kernel/rcu/tree.c:2099:6: error: ‘struct rcu_data’ has no member named ‘gpwrap’
> >> >    rdp->gpwrap) {
> > Indeed it does.  Please see below for a port to current mainline.
> 
> With the patch:
> 
> 
> [  620.340045] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [  620.341087]  (detected by 22, t=8407 jiffies, g=10452, c=10451, q=3622)
> [  620.342154] All QSes seen, last rcu_preempt kthread activity 4294990929/4294999330, jiffies_till_next_fqs=1

OK, 8401 jiffies since the grace-period kthread ran.  This is without
the "Run grace-period kthreads at real-time priority" patch?

> [  643.710049] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [  643.710073] INFO: rcu_sched detected stalls on CPUs/tasks:
> [  643.710093]  0: (6 ticks this GP) idle=bd5/140000000000002/0 softirq=12421/12421 fqs=0 last_accelerate: 5283/8643, nonlazy_posted: 643841, ..
> [  643.710110]  (detected by 1, t=2102 jiffies, g=-292, c=-293, q=0)

But this one is real.

> [  643.710112] Task dump for CPU 0:
> [  643.710129] kworker/0:1     R  running task    13016   628      2 0x10080008
> [  643.710148] Workqueue: events vmstat_update
> [  643.710156]  ffffffffb0301dc4 ffff88006be15000 ffff880060ba1c70 0000000000000000
> [  643.710161]  ffff88006be10680 ffff8800633efde8 ffffffffa0461f1b ffff88006a776000
> [  643.710166]  ffff880060ba1cb8 ffff880060ba1c78 ffff880060ba1c80 ffff880060ba1c90
> [  643.710168] Call Trace:
> [  643.710181]  [<ffffffffb0301dc4>] ? _raw_spin_unlock_irq+0x64/0x200
> [  643.710191]  [<ffffffffa0461f1b>] ? process_one_work+0x5fb/0x1660
> [  643.710197]  [<ffffffffa0463545>] ? worker_thread+0x5c5/0x1680
> [  643.710205]  [<ffffffffb02f0b6f>] ? __schedule+0xf6f/0x2fc0
> [  643.710211]  [<ffffffffa0462f80>] ? process_one_work+0x1660/0x1660
> [  643.710216]  [<ffffffffa047ae22>] ? kthread+0x1f2/0x2b0
> [  643.710221]  [<ffffffffa047ac30>] ? kthread_worker_fn+0x6a0/0x6a0
> [  643.710226]  [<ffffffffb030243c>] ? ret_from_fork+0x7c/0xb0
> [  643.710233]  [<ffffffffa047ac30>] ? kthread_worker_fn+0x6a0/0x6a0

Which in theory should have been addressed by the "Make
cond_resched_rcu_qs() apply to normal RCU flavors" patch,
given that this is CPU 0, which should be taking scheduling
clock interrupts.  Well, I guess that theory and practice
are only the same in theory.  :-/

Will dig into it more.

							Thanx, Paul

> [  643.711486]
> [  643.711486]  (detected by 22, t=2104 jiffies, g=10453, c=10452, q=1570)
> [  643.711486] All QSes seen, last rcu_preempt kthread activity 4294999565/4295001669, jiffies_till_next_fqs=1
> 
> 
> Thanks,
> Sasha
> 

