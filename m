Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072Ab3CMRvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:51:39 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45932 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132Ab3CMRvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:51:38 -0400
From: Artem Savkov <artem.savkov@gmail.com>
To: tj@kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH] workqueue: missing idr_preload_end() in worker_pool_assign_id()
Date: Wed, 13 Mar 2013 21:51:32 +0400
Message-Id: <1363197092-4832-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added missing idr_preload_end() call in worker_pool_assign_id().
Without it preemption stays disabled resulting in lots of "scheduling while
atomic" BUGs during boot.

[    0.167848] BUG: scheduling while atomic: swapper/0/1/0x10000009
[    0.167951] no locks held by swapper/0/1.
[    0.168046] Modules linked in:
[    0.168947] Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc2-next-20130313+ #299
[    0.169054] Call Trace:
[    0.169152]  [<c168369e>] __schedule_bug+0x59/0x6b
[    0.169254]  [<c168d0d8>] __schedule+0x858/0x8e0
[    0.169355]  [<c1066bbb>] __cond_resched+0x1b/0x30
[    0.169457]  [<c168d1d6>] _cond_resched+0x26/0x30
[    0.169555]  [<c168d20e>] wait_for_common+0x2e/0x120
[    0.169659]  [<c1068fc7>] ? try_to_wake_up+0x197/0x280
[    0.169760]  [<c168d317>] wait_for_completion+0x17/0x20
[    0.169860]  [<c105a2c6>] kthread_create_on_node+0x76/0xc0
[    0.169963]  [<c1052400>] ? rescuer_thread+0x220/0x220
[    0.170064]  [<c1090f72>] ? lockdep_init_map+0x92/0x4e0
[    0.170164]  [<c104fbc1>] create_worker+0xd1/0x1a0
[    0.170261]  [<c1052400>] ? rescuer_thread+0x220/0x220
[    0.170367]  [<c19d1fb9>] init_workqueues+0x12c/0x331
[    0.170468]  [<c19d1e8d>] ?  ftrace_define_fields_workqueue_queue_work+0x115/0x115
[    0.170620]  [<c1001222>] do_one_initcall+0x112/0x160
[    0.170723]  [<c19c7ce6>] ? native_smp_prepare_cpus+0x39a/0x3fd
[    0.170829]  [<c19bca94>] kernel_init_freeable+0x83/0x1b8
[    0.170931]  [<c106503b>] ? finish_task_switch+0x3b/0x100
[    0.171035]  [<c1676970>] kernel_init+0x10/0xd0
[    0.171133]  [<c1695b37>] ret_from_kernel_thread+0x1b/0x28
[    0.171234]  [<c1676960>] ? rest_init+0xd0/0xd0

Introduced in "workqueue: convert to idr_alloc()"

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
---
 kernel/workqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8462642..60d58ac 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -463,6 +463,7 @@ static int worker_pool_assign_id(struct worker_pool *pool)
 		if (ret >= 0)
 			pool->id = ret;
 		spin_unlock_irq(&workqueue_lock);
+		idr_preload_end();
 	} while (ret == -EAGAIN);
 
 	return ret < 0 ? ret : 0;
-- 
1.8.1.5

