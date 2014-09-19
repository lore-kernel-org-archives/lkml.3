Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbaISEce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 00:32:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:12395 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbaISEcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 00:32:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,552,1406617200"; 
   d="scan'208";a="602007056"
From: jun.zhang@intel.com
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, zhang jun <jun.zhang@intel.com>
Subject: [PATCH] workqueue: give a protection when get_work_pwq return NULL.
Date: Fri, 19 Sep 2014 12:12:04 +0800
Message-Id: <1411099924-11554-1-git-send-email-jun.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: zhang jun <jun.zhang@intel.com>

if pwq==NULL, system could panic. next is the panic log.
[12973.660792] BUG: unable to handle kernel NULL pointer dereference at 00000004
[12973.668787] IP: [<c125b8ab>] process_one_work+0x2b/0x3e0
[12973.674735] *pdpt = 00000000304b0001 *pde = 0000000000000000
[12973.681167] Oops: 0000 [#1] PREEMPT SMP
[12973.685557] Modules linked in: atomisp_css2400b0_v21 lm3554 ov2722 imx1x5 libmsrlisthelper atmel_mxt_ts vxd392 videobuf_vmalloc videobuf_core lm_dump(O) bcm_bt_lpm hdmi_audio bcm4334x(O)
[12973.704154] CPU: 0 PID: 26284 Comm: kworker/0:0 Tainted: G        W  O 3.10.20-263108-g04ac390 #1
[12973.714070] Hardware name: Intel Corp. VALLEYVIEW C0 PLATFORM/BYT-T FFD8, BIOS BLAKFF81.86C.0099.R41.1406121403 FFD8_IA32_R_2014_24_4_01 06/12/2014
[12973.728846] task: c6e4f620 ti: eda0a000 task.ti: eda0a000
[12973.734878] EIP: 0060:[<c125b8ab>] EFLAGS: 00010046 CPU: 0
[12973.741010] EIP is at process_one_work+0x2b/0x3e0
[12973.746263] EAX: f364f4c0 EBX: c5267dc8 ECX: 00000000 EDX: 00000000
[12973.753264] ESI: f06fc840 EDI: f06fc840 EBP: eda0bf28 ESP: eda0bef8
[12973.760265]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[12973.766294] CR0: 8005003b CR2: 00000078 CR3: 30798000 CR4: 001007f0
[12973.773295] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[12973.780296] DR6: ffff0ff0 DR7: 00000400
[12973.784578] Stack:
[12973.786820]  f364f4c0 f06fc840 eda0bf1c c1a9d81d c1a9d715 00000000 00000000 00000000
[12973.793547]  f364f4c0[12973.793548]  f06fc858[12973.793549]  f364f4c0[12973.793550]  f06fc840[12973.793551]  eda0bf54[12973.793552]  c125c036[12973.793553]  c1a9a337[12973.793554]  c6e4f620[12973.793555]
[12973.793555]  f364f4c0[12973.793556]  c6e4f620[12973.793557]  c6e4f620[12973.793558]  f364f4e0[12973.793559]  e73cde84[12973.793560]  f06fc840[12973.793561]  c125bf40[12973.793562]  eda0bfac[12973.793563]
[12973.793564] Call Trace:
[12973.793567] [12973.793574]  [<c1a9d81d>] ? add_preempt_count+0x7d/0xf0
[12973.793575] [12973.793577]  [<c1a9d715>] ? sub_preempt_count+0x55/0xe0
[12973.793579] [12973.793583]  [<c125c036>] worker_thread+0xf6/0x310
[12973.793584] [12973.793586]  [<c1a9a337>] ? _raw_spin_unlock_irqrestore+0x47/0x50
[12973.793588] [12973.793590]  [<c125bf40>] ? rescuer_thread+0x2b0/0x2b0
[12973.793591] [12973.793594]  [<c1261bf4>] kthread+0x94/0xa0
[12973.793596] [12973.793598]  [<c1a9d715>] ? sub_preempt_count+0x55/0xe0
[12973.793600] [12973.793602]  [<c1aa0b77>] ret_from_kernel_thread+0x1b/0x28
[12973.793603] [12973.793606]  [<c1261b60>] ? kthread_create_on_node+0xc0/0xc0

Signed-off-by: zhang jun <jun.zhang@intel.com>
---
 kernel/workqueue.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5dbe22a..e3baa55 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1947,9 +1947,19 @@ __acquires(&pool->lock)
 {
 	struct pool_workqueue *pwq = get_work_pwq(work);
 	struct worker_pool *pool = worker->pool;
-	bool cpu_intensive = pwq->wq->flags & WQ_CPU_INTENSIVE;
 	int work_color;
 	struct worker *collision;
+
+	if (pwq == NULL) {
+		pr_err("BUG: pwq is NULL. data: 0x%08lx @ work: 0x%p\n",
+			atomic_long_read(&work->data), work);
+		WARN_ON(1);
+		move_linked_works(work, &worker->scheduled, NULL);
+		return;
+	}
+
+	bool cpu_intensive = pwq->wq->flags & WQ_CPU_INTENSIVE;
+
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * It is permissible to free the struct work_struct from
-- 
1.7.9.5

