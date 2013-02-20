Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904Ab3BTRKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:10:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:55552 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663Ab3BTRKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:10:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,702,1355126400"; 
   d="scan'208";a="293695582"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] events: always do slow path when trying to find a pmu
Date: Wed, 20 Feb 2013 19:09:36 +0200
Message-Id: <1361380176-15081-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of PMU-less systems we have got the following traceback.

[    7.720687] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    7.727743] IP: [<c10ae57c>] perf_init_event+0x5e/0x150
[    7.732961] *pdpt = 0000000035257001 *pde = 0000000000000000
[    7.738700] Oops: 0000 [#1] PREEMPT SMP

Entering kdb (current=0xf6c58000, pid 1) on processor 1 Oops: (null)
due to oops @ 0xc10ae57c
dPid: 1, comm: init Not tainted 3.8.0-next-20130220-00036-gbceb0e3-dirty #57
dEIP: 0060:[<c10ae57c>] EFLAGS: 00010246 CPU: 1
EIP is at perf_init_event+0x5e/0x150
dEAX: 00000000 EBX: 00000000 ECX: c17efaa4 EDX: 00000005
dESI: f52e44b0 EDI: 00000005 EBP: f6c61df8 ESP: f6c61de4
d DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
dCR0: 8005003b CR2: 00000000 CR3: 35256000 CR4: 000007f0
dDR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
dDR6: ffff0ff0 DR7: 00000400
0Process init (pid: 1, ti=f6c60000 task=f6c58000 task.ti=f6c60000)
0Stack:
 00000000 c104762b 00000001 f52e45f8 f52e4588 f6c61e24 c10ae8df f6c58405
 00000006 00000007 f6c58000 f6c61e84 f52e44b0 00000000 c18aed5c 00000000
 f6c61e4c c10aec35 f52e44b0 00000000 00000000 00000000 00000000 00000000
0Call Trace:
0 [<c104762b>] ? __mutex_init+0x3f/0x44
0 [<c10ae8df>] perf_event_alloc+0x271/0x39a
0 [<c10aec35>] perf_event_create_kernel_counter+0x1a/0xb3
0 [<c10b02d7>] register_wide_hw_breakpoint+0x56/0xd9
0 [<c101f20e>] kgdb_arch_late+0x7a/0x112
0 [<c101eaca>] ? kgdb_set_hw_break+0x15e/0x15e
0 [<c1086f13>] kgdb_register_io_module+0x9b/0x121
0 [<c12c4b50>] configure_kgdboc+0xf1/0x126
0 [<c12c4c0f>] param_set_kgdboc_var+0x8a/0x8f
0 [<c10434b0>] param_attr_store+0x2a/0x47
0 [<c1043486>] ? __kernel_param_lock+0x11/0x11
0 [<c10433c7>] module_attr_store+0x17/0x26
0 [<c112dfc9>] sysfs_write_file+0xab/0xe6
0 [<c112df1e>] ? sysfs_chmod_file+0x82/0x82
0 [<c10e1834>] vfs_write+0x66/0xa7
0 [<c10e19b0>] sys_write+0x37/0x60
0 [<c1547741>] sysenter_do_call+0x12/0x32
0Code: ff ff 8b 7e 78 8b 1d 94 12 e5 c1 e8 5c 49 f9 ff 83 c4 0c 85 c0 74 0e 80 3d 28 05 84 c1 00 75 05 e8 99 9c ff ff 89 f8 89 fa 30 c0 <3b> 03 75 26 81 e2 ff 00 00 00 83 c2 08 8b 5c 93 04 e8 2b 49 f9

The guilty commit is cc5b5f6 "events: convert to idr_alloc()" together with
f49318a "idr: implement lookup hint". In our case the idr_alloc is never called, but idr_find is. The hint field is never initialized and could not be dereferenced.

The proposed fix uses the idr_slowpath call which reflects old behaviour.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 624e53f..20421ea 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6076,7 +6076,7 @@ struct pmu *perf_init_event(struct perf_event *event)
 	idx = srcu_read_lock(&pmus_srcu);
 
 	rcu_read_lock();
-	pmu = idr_find(&pmu_idr, event->attr.type);
+	pmu = idr_find_slowpath(&pmu_idr, event->attr.type);
 	rcu_read_unlock();
 	if (pmu) {
 		event->pmu = pmu;
-- 
1.8.2.rc0.22.gb3600c3

