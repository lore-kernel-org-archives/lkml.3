Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3L0KXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:23:32 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:52375 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab3L0KXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:23:31 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH] sched/auto_group: fix consume memory even if add 'noautogroup' in the cmdline
Date: Fri, 27 Dec 2013 18:22:31 +0800
Message-Id: <1388139751-19632-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122710-3864-0000-0000-00000BB27FC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a server which have 200 CPUs and 8G memory, there is auto_group creation 
which will almost consume 12MB memory even if add 'noautogroup' in the kernel 
boot parameter. In addtion, SLUB per cpu partial caches freeing that is local to 
a processor which requires the taking of locks at the price of more indeterminism 
in the latency of the free. This patch fix it by check noautogroup earlier to avoid 
free after unnecessary memory consumption.

cat /sys/kernel/slab/kmalloc-512/alloc_calls  
18000 .alloc_fair_sched_group+0xec/0x1e0 age=2579/19587/286617 pid=1-8462 cpus=0-1,5,9,21,26,29,41,61,
69,73,76-77,89,92-93,97,101,109,121,125,133,141,145,149,153,161,185 nodes=1
cat /sys/kernel/slab/kmalloc-192/alloc_calls
18000 .alloc_fair_sched_group+0x110/0x1e0 age=2637/19654/286688 pid=1-8462 cpus=0-1,5,9,21,26,29,41,61,
69,73,76-77,89,92-93,97,101,109,121,125,133,141,145,149,153,161,185 nodes=1

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/auto_group.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index 4a07353..748ebc9 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -145,15 +145,11 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 
 	p->signal->autogroup = autogroup_kref_get(ag);
 
-	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
-		goto out;
-
 	t = p;
 	do {
 		sched_move_task(t);
 	} while_each_thread(p, t);
 
-out:
 	unlock_task_sighand(p, &flags);
 	autogroup_kref_put(prev);
 }
@@ -161,7 +157,12 @@ out:
 /* Allocates GFP_KERNEL, cannot be called under any spinlock */
 void sched_autogroup_create_attach(struct task_struct *p)
 {
-	struct autogroup *ag = autogroup_create();
+	struct autogroup *ag;
+
+	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
+		return;
+
+	ag = autogroup_create();
 
 	autogroup_move_group(p, ag);
 	/* drop extra reference added by autogroup_create() */
-- 
1.8.3.2

