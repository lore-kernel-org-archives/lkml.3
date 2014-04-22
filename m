Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaDVFYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:24:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:33192 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaDVFYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:24:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,901,1389772800"; 
   d="scan'208";a="525148982"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: [Bugfix] sched: fix possible invalid memory access caused by CPU hot-addition
Date: Tue, 22 Apr 2014 13:27:15 +0800
Message-Id: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling kzalloc_node(size, flags, node), we should first check
whether node is onlined, otherwise it may cause invalid memory access
as below.

[ 3663.324476] BUG: unable to handle kernel paging request at 0000000000001f08
[ 3663.332348] IP: [<ffffffff81172219>] __alloc_pages_nodemask+0xb9/0x2d0
[ 3663.339719] PGD 82fe10067 PUD 82ebef067 PMD 0
[ 3663.344773] Oops: 0000 [#1] SMP
[ 3663.348455] Modules linked in: shpchp gpio_ich x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode joydev sb_edac edac_core lpc_ich ipmi_si tpm_tis ipmi_msghandler ioatdma wmi acpi_pad mac_hid lp parport ixgbe isci mpt2sas dca ahci ptp libsas libahci raid_class pps_core scsi_transport_sas mdio hid_generic usbhid hid
[ 3663.394393] CPU: 61 PID: 2416 Comm: cron Tainted: G        W    3.14.0-rc5+ #21
[ 3663.402643] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BRIVTIN1.86B.0047.F03.1403031049 03/03/2014
[ 3663.414299] task: ffff88082fe54b00 ti: ffff880845fba000 task.ti: ffff880845fba000
[ 3663.422741] RIP: 0010:[<ffffffff81172219>]  [<ffffffff81172219>] __alloc_pages_nodemask+0xb9/0x2d0
[ 3663.432857] RSP: 0018:ffff880845fbbcd0  EFLAGS: 00010246
[ 3663.439265] RAX: 0000000000001f00 RBX: 0000000000000000 RCX: 0000000000000000
[ 3663.447291] RDX: 0000000000000000 RSI: 0000000000000a8d RDI: ffffffff81a8d950
[ 3663.455318] RBP: ffff880845fbbd58 R08: ffff880823293400 R09: 0000000000000001
[ 3663.463345] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000002052d0
[ 3663.471363] R13: ffff880854c07600 R14: 0000000000000002 R15: 0000000000000000
[ 3663.479389] FS:  00007f2e8b99e800(0000) GS:ffff88105a400000(0000) knlGS:0000000000000000
[ 3663.488514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3663.495018] CR2: 0000000000001f08 CR3: 00000008237b1000 CR4: 00000000001407e0
[ 3663.503476] Stack:
[ 3663.505757]  ffffffff811bd74d ffff880854c01d98 ffff880854c01df0 ffff880854c01dd0
[ 3663.514167]  00000003208ca420 000000075a5d84d0 ffff88082fe54b00 ffffffff811bb35f
[ 3663.522567]  ffff880854c07600 0000000000000003 0000000000001f00 ffff880845fbbd48
[ 3663.530976] Call Trace:
[ 3663.533753]  [<ffffffff811bd74d>] ? deactivate_slab+0x41d/0x4f0
[ 3663.540421]  [<ffffffff811bb35f>] ? new_slab+0x3f/0x2d0
[ 3663.546307]  [<ffffffff811bb3c5>] new_slab+0xa5/0x2d0
[ 3663.552001]  [<ffffffff81768c97>] __slab_alloc+0x35d/0x54a
[ 3663.558185]  [<ffffffff810a4845>] ? local_clock+0x25/0x30
[ 3663.564686]  [<ffffffff8177a34c>] ? __do_page_fault+0x4ec/0x5e0
[ 3663.571356]  [<ffffffff810b0054>] ? alloc_fair_sched_group+0xc4/0x190
[ 3663.578609]  [<ffffffff810c77f1>] ? __raw_spin_lock_init+0x21/0x60
[ 3663.585570]  [<ffffffff811be476>] kmem_cache_alloc_node_trace+0xa6/0x1d0
[ 3663.593112]  [<ffffffff810b0054>] ? alloc_fair_sched_group+0xc4/0x190
[ 3663.600363]  [<ffffffff810b0054>] alloc_fair_sched_group+0xc4/0x190
[ 3663.607423]  [<ffffffff810a359f>] sched_create_group+0x3f/0x80
[ 3663.613994]  [<ffffffff810b611f>] sched_autogroup_create_attach+0x3f/0x1b0
[ 3663.621732]  [<ffffffff8108258a>] sys_setsid+0xea/0x110
[ 3663.628020]  [<ffffffff8177f42d>] system_call_fastpath+0x1a/0x1f
[ 3663.634780] Code: 00 44 89 e7 e8 b9 f8 f4 ff 41 f6 c4 10 74 18 31 d2 be 8d 0a 00 00 48 c7 c7 50 d9 a8 81 e8 70 6a f2 ff e8 db dd 5f 00 48 8b 45 c8 <48> 83 78 08 00 0f 84 b5 01 00 00 48 83 c0 08 44 89 75 c0 4d 89
[ 3663.657032] RIP  [<ffffffff81172219>] __alloc_pages_nodemask+0xb9/0x2d0
[ 3663.664491]  RSP <ffff880845fbbcd0>
[ 3663.668429] CR2: 0000000000001f08
[ 3663.672659] ---[ end trace df13f08ed9de18ad ]---

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 kernel/sched/fair.c |   12 +++++++-----
 kernel/sched/rt.c   |   11 +++++++----
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7e9bd0b1fa9e..1c093d213b0f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7485,7 +7485,7 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se;
-	int i;
+	int i, nid;
 
 	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->cfs_rq)
@@ -7499,13 +7499,15 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	init_cfs_bandwidth(tg_cfs_bandwidth(tg));
 
 	for_each_possible_cpu(i) {
-		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
-				      GFP_KERNEL, cpu_to_node(i));
+		nid = cpu_to_node(i);
+		if (nid != NUMA_NO_NODE && !node_online(nid))
+			nid = NUMA_NO_NODE;
+
+		cfs_rq = kzalloc_node(sizeof(struct cfs_rq), GFP_KERNEL, nid);
 		if (!cfs_rq)
 			goto err;
 
-		se = kzalloc_node(sizeof(struct sched_entity),
-				  GFP_KERNEL, cpu_to_node(i));
+		se = kzalloc_node(sizeof(struct sched_entity), GFP_KERNEL, nid);
 		if (!se)
 			goto err_free_rq;
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index d8cdf1618551..5a5a32e1115c 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -161,7 +161,7 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct rt_rq *rt_rq;
 	struct sched_rt_entity *rt_se;
-	int i;
+	int i, nid;
 
 	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->rt_rq)
@@ -174,13 +174,16 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
 
 	for_each_possible_cpu(i) {
-		rt_rq = kzalloc_node(sizeof(struct rt_rq),
-				     GFP_KERNEL, cpu_to_node(i));
+		nid = cpu_to_node(i);
+		if (nid != NUMA_NO_NODE && !node_online(nid))
+			nid = NUMA_NO_NODE;
+
+		rt_rq = kzalloc_node(sizeof(struct rt_rq), GFP_KERNEL, nid);
 		if (!rt_rq)
 			goto err;
 
 		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
-				     GFP_KERNEL, cpu_to_node(i));
+				     GFP_KERNEL, nid);
 		if (!rt_se)
 			goto err_free_rq;
 
-- 
1.7.10.4

