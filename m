Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3EOH5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:57:45 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55995 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932Ab3EOH5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:57:43 -0400
Date: Wed, 15 May 2013 02:57:42 -0500
From: Robin Holt <holt@sgi.com>
To: "Paul E. McKenney" <paul.mckenney@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Commit 911af505 introduced a bootmem warning.
Message-ID: <20130515075742.GL3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

When we boot Linus' current kernel we get the following warning early
in boot:

----------------------------------------------------------------------
[    0.000000] Memory: 63081268k/99598336k available (4832k kernel code, 34651396k absent, 1865672k reserved, 6269k data,
1672k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=32.
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at mm/nobootmem.c:215 ___alloc_bootmem_nopanic+0x79/0x82()
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc1-uv-hz100-rja+ #3
[    0.000000] Hardware name: SGI UV2000/ROMLEY, BIOS SGI UV 2000/3000 series BIOS 01/15/2013
[    0.000000]  00000000000000d7 ffffffff81a01e38 ffffffff814a873c ffffffff81a01e78
[    0.000000]  ffffffff81045a7b ffffffff81ced5a2 0000000000000000 ffffffffffffffff
[    0.000000]  0000000000000040 0000000000000200 0000000067da2bfc ffffffff81a01e88
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff814a873c>] dump_stack+0x19/0x1d
[    0.000000]  [<ffffffff81045a7b>] warn_slowpath_common+0x6b/0xa0
[    0.000000]  [<ffffffff81045ac5>] warn_slowpath_null+0x15/0x20
[    0.000000]  [<ffffffff81b1793a>] ___alloc_bootmem_nopanic+0x79/0x82
[    0.000000]  [<ffffffff81b17a59>] ___alloc_bootmem+0x11/0x3c
[    0.000000]  [<ffffffff81b17aa4>] __alloc_bootmem+0x10/0x12
[    0.000000]  [<ffffffff81b233a7>] alloc_bootmem_cpumask_var+0x1d/0x27
[    0.000000]  [<ffffffff81b1119b>] rcu_bootup_announce_oddness+0xd0/0x153
[    0.000000]  [<ffffffff81b11735>] rcu_init+0x1e/0x1e6
[    0.000000]  [<ffffffff81aedf2f>] start_kernel+0x1e6/0x43c
[    0.000000]  [<ffffffff81aedb3b>] ? repair_env_string+0x58/0x58
[    0.000000]  [<ffffffff81aed4d1>] x86_64_start_reservations+0x1b/0x32
[    0.000000]  [<ffffffff81aed612>] x86_64_start_kernel+0x12a/0x131
[    0.000000] ---[ end trace c8b13488e92fad65 ]---
[    0.000000]  Experimental no-CBs for all CPUs
[    0.000000]  Experimental no-CBs CPUs: 0-31.
[    0.000000] NO_HZ: Full dynticks CPUs: 1-31.

$ grep RCU .config
# RCU Subsystem
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_USER_QS=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_ALL=y
# RCU Debugging
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set

$ git rev-parse HEAD
1f638766ffcd9f08209afcabb3e2df961552fe18

cca6f3931 (Paul E. McKenney    2012-05-08 21:00:28 -0700   86)  if (nr_cpu_ids != NR_CPUS)
cca6f3931 (Paul E. McKenney    2012-05-08 21:00:28 -0700   87)          printk(KERN_INFO "\tRCU restricting CPUs from NR_C
PUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
3fbfbf7a3 (Paul E. McKenney    2012-08-19 21:35:53 -0700   88) #ifdef CONFIG_RCU_NOCB_CPU
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800   89) #ifndef CONFIG_RCU_NOCB_CPU_NONE
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800   90)  if (!have_rcu_nocb_mask) {
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800   91)          alloc_bootmem_cpumask_var(&rcu_nocb_mask);
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800   92)          have_rcu_nocb_mask = true;
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800   93)  }
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800   94) #ifdef CONFIG_RCU_NOCB_CPU_ZERO
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800   95)  pr_info("\tExperimental no-CBs CPU 0\n");
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800   96)  cpumask_set_cpu(0, rcu_nocb_mask);
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800   97) #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800   98) #ifdef CONFIG_RCU_NOCB_CPU_ALL
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800   99)  pr_info("\tExperimental no-CBs for all CPUs\n");
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800  100)  cpumask_setall(rcu_nocb_mask);
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800  101) #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
911af505e (Paul E. McKenney    2013-02-11 10:23:27 -0800  102) #endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */


Thanks,
Robin Holt
