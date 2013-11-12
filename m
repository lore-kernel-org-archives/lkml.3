Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3KLK5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:57:02 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34339 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3KLK47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:56:59 -0500
Date: Tue, 12 Nov 2013 16:25:47 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mikey@neuling.org
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/fair: Fix group power_orig computation
Message-ID: <20131112105547.GA27310@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111210-8236-0000-0000-000003B07FBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With Commit-id 863bffc80898 (sched/fair: Fix group power_orig computation)
which is part of latest tip/master, numa machine may fail to boot both
on powerpc and x86_64.

On powerpc

[    0.710162] Unable to handle kernel paging request for data at address 0x00000010
[    0.710170] Faulting instruction address: 0xc0000000000f3db4
[    0.710177] Oops: Kernel access of bad area, sig: 11 [#1]
[    0.710182] SMP NR_CPUS=1024 NUMA pSeries
[    0.710190] Modules linked in:
[    0.710199] CPU: 53 PID: 1 Comm: swapper/53 Not tainted 3.12.0-tip_master+ #1
[    0.710205] task: c000001713980000 ti: c000001713a00000 task.ti: c000001713a00000
[    0.710211] NIP: c0000000000f3db4 LR: c0000000000f3de0 CTR: 0000000000000000
[    0.710217] REGS: c000001713a036d0 TRAP: 0300   Not tainted  (3.12.0-tip_master+)
[    0.710223] MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 48002044  XER: 20000003
[    0.710243] SOFTE: 1
[    0.710246] CFAR: c00000000000908c
[    0.710250] DAR: 0000000000000010, DSISR: 40000000
[    0.710254]
GPR00: c000000000e85e00 c000001713a03950 c0000000015a7a58 0000000000000030
GPR04: 0000000000000030 0000000000000000 0000000000000400 000000001dcd6500
GPR08: 0000000000000000 0000000000000000 0000000000000000 c00000000160c958
GPR12: 0000000000000000 c000000007edb980 c0000007e2e374a8 c000000001607a58
GPR16: c000001ef38f8f58 0000000000000180 c000000001770258 0000000000000001
GPR20: 000000000000005f c000001ef38f8f40 0000000000000001 c0000000014b9acf
GPR24: 0000000000000000 c000001712884a40 c000000001607a58 c000000000e87a58
GPR28: c00000000160fc54 c000001712884a58 0000000000000000 0000000000000000
[    0.710349] NIP [c0000000000f3db4] .update_group_power+0xd4/0x2e0
[    0.710355] LR [c0000000000f3de0] .update_group_power+0x100/0x2e0
[    0.710360] Call Trace:
[    0.710364] [c000001713a03950] [c0000000000f3d28] .update_group_power+0x48/0x2e0 (unreliable)
[    0.710375] [c000001713a03a00] [c0000000000ed73c] .build_sched_domains+0xadc/0xd90
[    0.710385] [c000001713a03b70] [c000000000bf39b0] .sched_init_smp+0x528/0x66c
[    0.710394] [c000001713a03ce0] [c000000000bd46a8] .kernel_init_freeable+0x200/0x398
[    0.710405] [c000001713a03db0] [c00000000000bc04] .kernel_init+0x24/0x140
[    0.710413] [c000001713a03e30] [c00000000000a16c] .ret_from_kernel_thread+0x5c/0x70
[    0.710419] Instruction dump:
[    0.710424] 3bb90018 3bc00000 3be00000 3860ffff 3f62ff8e 48000034 60000000 397a4f00
[    0.710439] 381be3a8 7d2b482a 7d204a14 e9290950 <e9290010> e9290010 81690004 80090008
[    0.710465] ---[ end trace b5091a0959b24fe3 ]---
[    0.710469]
[    2.710530] Kernel panic - not syncing: Fatal exception
[    2.710943] Rebooting in 10 seconds..

On x86_64

CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-tip_v312+ #5
Hardware name: IBM System x3750 M4 -[8722C1A]-/00D1432, BIOS -[KOE116JUS-1.10]- 09/25/2012
task: ffff8810373a6040 ti: ffff8810373a8000 task.ti: ffff8810373a8000
RIP: 0010:[<ffffffff8108aa53>]  [<ffffffff8108aa53>] update_group_power+0xa3/0x130
RSP: 0000:ffff8810373a9db8  EFLAGS: 00010283
RAX: 0000000000000008 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000040 RDI: 0000000000000040
RBP: ffff8810373a9de8 R08: ffff88203632f818 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: 00000000001d3cc0 R14: ffff88203632f818 R15: ffff88203632f800
FS:  0000000000000000(0000) GS:ffff88103de00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 0000000001a0b000 CR4: 00000000000407f0
Stack:
 ffff8810373a9dd8 ffff881035aa0c00 ffff88203632f800 ffff8820362fa800
 0000000000000008 0000000000000008 ffff8810373a9e58 ffffffff8108627b
 ffff8810373a9e18 ffffffff8129fcf8 00000000373a76e0 000000000000003f
Call Trace:
 [<ffffffff8108627b>] build_sched_domains+0x37b/0x3f0
 [<ffffffff8129fcf8>] ? alloc_cpumask_var_node+0x58/0x80
 [<ffffffff81d59783>] sched_init_smp+0x8f/0x13c
 [<ffffffff81d3db78>] kernel_init_freeable+0x27b/0x303
 [<ffffffff81593c6e>] ? kernel_init+0xe/0xf0
 [<ffffffff810a0ead>] ? trace_hardirqs_on_caller+0xfd/0x1c0
 [<ffffffff81593c60>] ? rest_init+0xd0/0xd0
 [<ffffffff81593c6e>] kernel_init+0xe/0xf0
 [<ffffffff815a9eac>] ret_from_fork+0x7c/0xb0
 [<ffffffff81593c60>] ? rest_init+0xd0/0xd0
Code: ad 00 4d 8d 77 18 45 31 e4 31 db b8 ff ff ff ff eb 2d 66 0f 1f 44 00 00 48 63 d0 48 8b 14 d5 
c0 9d b4 81 49 8b 94 15 50 09 00 00 <48> 8b 52 10 48 8b 52 10 8b 4a 08 8b 52 04 49 01 cc 48 01 d3 8
3
RIP  [<ffffffff8108aa53>] update_group_power+0xa3/0x130
 RSP <ffff8810373a9db8>
CR2: 0000000000000010
---[ end trace cd8cb7fb261d7bea ]---
Kernel panic - not syncing: Fatal exception

This can be fixed by a simple check below.

-- 
Thanks and Regards
Srikar Dronamraju

-------->8---------------------------------------------
>From bfc5dced04472c6c499aa3c6773ddef42d83fefc Mon Sep 17 00:00:00 2001
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 12 Nov 2013 03:05:31 -0500
Subject: [PATCH] sched: Check sched_domain before computing group power.

After Commit-id 863bffc80898 (sched/fair: Fix group power_orig
computation), we might end up computing group power before the
sched_domain for a cpu is updated.

Check for rq->sd before updating group power.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df77c60..f86f704 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5354,8 +5354,13 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		 */
 
 		for_each_cpu(cpu, sched_group_cpus(sdg)) {
-			struct sched_group *sg = cpu_rq(cpu)->sd->groups;
+			struct rq *rq = cpu_rq(cpu);
+			struct sched_group *sg;
 
+			if (!rq->sd)
+				continue;
+
+			sg = rq->sd->groups;
 			power_orig += sg->sgp->power_orig;
 			power += sg->sgp->power;
 		}
-- 
1.7.1

