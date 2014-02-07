Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaBGQvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:51:22 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:42174 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaBGQvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:51:18 -0500
Date: Fri, 7 Feb 2014 11:51:13 -0500
From: Tejun Heo <tj@kernel.org>
To: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: Subject: Warning in workqueue.c
Message-ID: <20140207165113.GD3304@htj.dyndns.org>
References: <52F4F01C.1070800@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F4F01C.1070800@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing Lai as he knows a lot of workqueue code and quoting the whole
body for him)

Hmmm.... my memory is a bit rusty and nothing rings a bell
immediately.  Can you please try the patch at the end of this message
and report the debug message?  Let's first find out what's going on.

Thanks

On Fri, Feb 07, 2014 at 09:39:24AM -0500, Jason J. Herne wrote:
> I've been able to reproduce the following warning using several
> kernel versions on the S390 platform, including the latest master:
> 3.14-rc1 (38dbfb59d1175ef458d006556061adeaa8751b72).
> 
> [28718.212810] ------------[ cut here ]------------
> [28718.212819] WARNING: at kernel/workqueue.c:2156
> [28718.212822] Modules linked in: ipt_MASQUERADE iptable_nat
> nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
> nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc
> ip6table_filter ip6_tables ebtable_nat ebtables iscsi_tcp
> libiscsi_tcp libiscsi scsi_transport_iscsi tape_3590 qeth_l2 tape
> tape_class vhost_net tun vhost macvtap macvlan lcs dasd_eckd_mod
> dasd_mod qeth ccwgroup zfcp scsi_transport_fc scsi_tgt qdio
> dm_multipath [last unloaded: kvm]
> [28718.212857] CPU: 2 PID: 20 Comm: kworker/3:0 Not tainted 3.14.0-rc1 #1
> [28718.212862] task: 00000000f7b23260 ti: 00000000f7b2c000 task.ti:
> 00000000f7b2c000
> [28718.212874] Krnl PSW : 0404c00180000000 000000000015b0be
> (process_one_work+0x2e6/0x4c0)
> [28718.212881]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3
> CC:0 PM:0 EA:3
> Krnl GPRS: 0000000001727790 0000000000bc2a52 00000000f7f21900
> 0000000000b92500
> [28718.212883]            0000000000b92500 0000000000105b24
> 0000000000000000 0000000000bc2a4e
> [28718.212887]            0000000000000000 0000000084a2b500
> 0000000084a27000 0000000084a27018
> [28718.212888]            00000000f7f21900 0000000000b92500
> 00000000f7b2fdd0 00000000f7b2fd70
> [28718.212907] Krnl Code: 000000000015b0b2: 95001000		cli	0(%r1),0
>            000000000015b0b6: a774fece		brc	7,15ae52
>           #000000000015b0ba: a7f40001		brc	15,15b0bc
>           >000000000015b0be: 92011000		mvi	0(%r1),1
>            000000000015b0c2: a7f4fec8		brc	15,15ae52
>            000000000015b0c6: e31003180004	lg	%r1,792
>            000000000015b0cc: 58301024		l	%r3,36(%r1)
>            000000000015b0d0: a73a0001		ahi	%r3,1
> [28718.212937] Call Trace:
> [28718.212940] ([<000000000015b08c>] process_one_work+0x2b4/0x4c0)
> [28718.212944]  [<000000000015b858>] worker_thread+0x178/0x39c
> [28718.212949]  [<0000000000164652>] kthread+0x10e/0x128
> [28718.212956]  [<0000000000728c66>] kernel_thread_starter+0x6/0xc
> [28718.212960]  [<0000000000728c60>] kernel_thread_starter+0x0/0xc
> [28718.212962] Last Breaking-Event-Address:
> [28718.212965]  [<000000000015b0ba>] process_one_work+0x2e2/0x4c0
> [28718.212968] ---[ end trace 6d115577307998c2 ]---
> 
> The workload is:
> 2 processes onlining random cpus in a tight loop by using 'echo 1 >
> /sys/bus/cpu.../online'
> 2 processes offlining random cpus in a tight loop by using 'echo 0 >
> /sys/bus/cpu.../online'
> Otherwise, fairly idle system. load average: 5.82, 6.27, 6.27
> 
> The machine has 10 processors.
> The warning message some times hits within a few minutes on starting
> the workload. Other times it takes several hours.
> 
> The particular spot in the code is:
> 	/*
> 	 * Ensure we're on the correct CPU.  DISASSOCIATED test is
> 	 * necessary to avoid spurious warnings from rescuers servicing the
> 	 * unbound or a disassociated pool.
> 	 */
> 	WARN_ON_ONCE(!(worker->flags & WORKER_UNBOUND) &&
> 		     !(pool->flags & POOL_DISASSOCIATED) &&
> 		     raw_smp_processor_id() != pool->cpu);
> 
> I'm not familiar with scheduling or work queuing internals so I'm
> not sure how to further debug.
> I would be happy to run tests and/or collect debugging data.
> 
> -- 
> -- Jason J. Herne (jjherne@linux.vnet.ibm.com)
> 

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 82ef9f3..1cc6d05 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2151,9 +2151,12 @@ __acquires(&pool->lock)
 	 * necessary to avoid spurious warnings from rescuers servicing the
 	 * unbound or a disassociated pool.
 	 */
-	WARN_ON_ONCE(!(worker->flags & WORKER_UNBOUND) &&
-		     !(pool->flags & POOL_DISASSOCIATED) &&
-		     raw_smp_processor_id() != pool->cpu);
+	if (WARN_ON_ONCE(!(worker->flags & WORKER_UNBOUND) &&
+			 !(pool->flags & POOL_DISASSOCIATED) &&
+			 raw_smp_processor_id() != pool->cpu))
+		pr_warning("XXX: worker->flags=0x%x pool->flags=0x%x cpu=%d pool->cpu=%d\n",
+			   worker->flags, pool->flags, raw_smp_processor_id(),
+			   pool->cpu);
 
 	/*
 	 * A single work shouldn't be executed concurrently by
