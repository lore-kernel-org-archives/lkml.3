Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3EFUHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:07:14 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41044 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839Ab3EFUHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:07:12 -0400
Date: Mon, 6 May 2013 13:06:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RCU init call bootmem allocation after slub us ready.
Message-ID: <20130506200656.GA26927@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAE9FiQUTV_e9De-6zCPs6OQrVAUJV2VLZDBmxFpJtnjNO3rKfw@mail.gmail.com>
 <20130506190611.GE3501@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130506190611.GE3501@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050620-9360-0000-0000-0000120CD057
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 12:06:11PM -0700, Paul E. McKenney wrote:
> On Mon, May 06, 2013 at 11:53:56AM -0700, Yinghai Lu wrote:
> > [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
> > CPUs=160, Nodes=8
> > [    0.000000] Hierarchical RCU implementation.
> > [    0.000000]  RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=160.
> > [    0.000000] ------------[ cut here ]------------
> > [    0.000000] WARNING: at mm/nobootmem.c:234
> > ___alloc_bootmem_nopanic+0x3a/0x7d()
> > [    0.000000] Modules linked in:
> > [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
> > 3.9.0-yh-10495-gfc7ffbc-dirty #1543
> > [    0.000000] Hardware name: Oracle Corporation  Sun Fire X4800 M2 /
> >    , BIOS 15013200    04/19/2012
> > [    0.000000]  0000000000000009 ffffffff82a01e58 ffffffff8209dc61
> > ffffffff82a01e98
> > [    0.000000]  ffffffff8108a9d0 0000000000000000 0000000000000000
> > 0000000000000200
> > [    0.000000]  ffffffffffffffff 0000000000000040 0000000000000000
> > ffffffff82a01ea8
> > [    0.000000] Call Trace:
> > [    0.000000]  [<ffffffff8209dc61>] dump_stack+0x19/0x1b
> > [    0.000000]  [<ffffffff8108a9d0>] warn_slowpath_common+0x70/0xa0
> > [    0.000000]  [<ffffffff8108aa1a>] warn_slowpath_null+0x1a/0x20
> > [    0.000000]  [<ffffffff82dd54cd>] ___alloc_bootmem_nopanic+0x3a/0x7d
> > [    0.000000]  [<ffffffff82dd5695>] __alloc_bootmem+0x12/0x38
> > [    0.000000]  [<ffffffff82de976a>] alloc_bootmem_cpumask_var+0x1a/0x21
> > [    0.000000]  [<ffffffff82dce4da>] rcu_init+0x66/0x283
> > [    0.000000]  [<ffffffff82dd15ed>] ? perf_event_init+0x136/0x15f
> > [    0.000000]  [<ffffffff82dabf95>] start_kernel+0x24a/0x423
> > [    0.000000]  [<ffffffff82dababe>] ? repair_env_string+0x5e/0x5e
> > [    0.000000]  [<ffffffff820936b6>] ? __memblock_reserve+0x81/0x89
> > [    0.000000]  [<ffffffff82dab5a8>] x86_64_start_reservations+0x2f/0x31
> > [    0.000000]  [<ffffffff82dab79e>] x86_64_start_kernel+0x1f4/0x1fc
> > [    0.000000] ---[ end trace 53ae8bb075006d8f ]---
> 
> Do you have commit fa0f93cd6a (rcu: Don't allocate bootmem from rcu_init())?
> If not, could you please try applying it?

As Dave Jones pointed out, this one is not yet in mainline.  Here is the
corresponding patch.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Don't allocate bootmem from rcu_init()

When rcu_init() is called we already have slab working, allocating
bootmem at that point results in warnings and an allocation from
slab.  This commit therefore changes alloc_bootmem_cpumask_var() to
alloc_cpumask_var() in rcu_bootup_announce_oddness(), which is called
from rcu_init().

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ca6e39c..44b0998 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -86,7 +86,7 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_RCU_NOCB_CPU
 #ifndef CONFIG_RCU_NOCB_CPU_NONE
 	if (!have_rcu_nocb_mask) {
-		alloc_bootmem_cpumask_var(&rcu_nocb_mask);
+		alloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
 		have_rcu_nocb_mask = true;
 	}
 #ifdef CONFIG_RCU_NOCB_CPU_ZERO

