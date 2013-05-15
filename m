Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab3EOOhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:37:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48384 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991Ab3EOOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:37:04 -0400
Date: Wed, 15 May 2013 07:32:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Robin Holt <holt@sgi.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Commit 911af505 introduced a bootmem warning.
Message-ID: <20130515143249.GH4442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130515075742.GL3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515075742.GL3658@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051514-7282-0000-0000-00001733D540
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 02:57:42AM -0500, Robin Holt wrote:
> Paul,
> 
> When we boot Linus' current kernel we get the following warning early
> in boot:
> 
> ----------------------------------------------------------------------
> [    0.000000] Memory: 63081268k/99598336k available (4832k kernel code, 34651396k absent, 1865672k reserved, 6269k data,
> 1672k init)
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=32.
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at mm/nobootmem.c:215 ___alloc_bootmem_nopanic+0x79/0x82()
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc1-uv-hz100-rja+ #3
> [    0.000000] Hardware name: SGI UV2000/ROMLEY, BIOS SGI UV 2000/3000 series BIOS 01/15/2013
> [    0.000000]  00000000000000d7 ffffffff81a01e38 ffffffff814a873c ffffffff81a01e78
> [    0.000000]  ffffffff81045a7b ffffffff81ced5a2 0000000000000000 ffffffffffffffff
> [    0.000000]  0000000000000040 0000000000000200 0000000067da2bfc ffffffff81a01e88
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff814a873c>] dump_stack+0x19/0x1d
> [    0.000000]  [<ffffffff81045a7b>] warn_slowpath_common+0x6b/0xa0
> [    0.000000]  [<ffffffff81045ac5>] warn_slowpath_null+0x15/0x20
> [    0.000000]  [<ffffffff81b1793a>] ___alloc_bootmem_nopanic+0x79/0x82
> [    0.000000]  [<ffffffff81b17a59>] ___alloc_bootmem+0x11/0x3c
> [    0.000000]  [<ffffffff81b17aa4>] __alloc_bootmem+0x10/0x12
> [    0.000000]  [<ffffffff81b233a7>] alloc_bootmem_cpumask_var+0x1d/0x27
> [    0.000000]  [<ffffffff81b1119b>] rcu_bootup_announce_oddness+0xd0/0x153
> [    0.000000]  [<ffffffff81b11735>] rcu_init+0x1e/0x1e6
> [    0.000000]  [<ffffffff81aedf2f>] start_kernel+0x1e6/0x43c
> [    0.000000]  [<ffffffff81aedb3b>] ? repair_env_string+0x58/0x58
> [    0.000000]  [<ffffffff81aed4d1>] x86_64_start_reservations+0x1b/0x32
> [    0.000000]  [<ffffffff81aed612>] x86_64_start_kernel+0x12a/0x131
> [    0.000000] ---[ end trace c8b13488e92fad65 ]---
> [    0.000000]  Experimental no-CBs for all CPUs
> [    0.000000]  Experimental no-CBs CPUs: 0-31.
> [    0.000000] NO_HZ: Full dynticks CPUs: 1-31.

Could you please try the following patch and let me know if it helps?

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

[paulmck: convert to zalloc_cpumask_var(), as suggested by Yinghai Lu.]

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a8c39c7..207844e 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -87,7 +87,7 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_RCU_NOCB_CPU
 #ifndef CONFIG_RCU_NOCB_CPU_NONE
 	if (!have_rcu_nocb_mask) {
-		alloc_bootmem_cpumask_var(&rcu_nocb_mask);
+		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
 		have_rcu_nocb_mask = true;
 	}
 #ifdef CONFIG_RCU_NOCB_CPU_ZERO

