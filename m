Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaA1SiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:38:21 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:56697 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaA1SiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:38:20 -0500
Date: Tue, 28 Jan 2014 10:38:08 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Anton Blanchard <anton@samba.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Jan Kara <jack@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] kthread: ensure locality of task_struct allocations
Message-ID: <20140128183808.GB9315@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 3.11.0-15-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012818-9332-0000-0000-000002EA4945
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the presence of memoryless nodes, numa_node_id()/cpu_to_node() will
return the current CPU's NUMA node, but that may not be where we expect
to allocate from memory from. Instead, we should use
numa_mem_id()/cpu_to_mem(). On one ppc64 system with a memoryless Node
0, this ends up saving nearly 500M of slab due to less fragmentation.

Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

diff --git a/kernel/kthread.c b/kernel/kthread.c
index b5ae3ee..8573e4e 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -217,7 +217,7 @@ int tsk_fork_get_node(struct task_struct *tsk)
 	if (tsk == kthreadd_task)
 		return tsk->pref_node_fork;
 #endif
-	return numa_node_id();
+	return numa_mem_id();
 }
 
 static void create_kthread(struct kthread_create_info *create)
@@ -369,7 +369,7 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 {
 	struct task_struct *p;
 
-	p = kthread_create_on_node(threadfn, data, cpu_to_node(cpu), namefmt,
+	p = kthread_create_on_node(threadfn, data, cpu_to_mem(cpu), namefmt,
 				   cpu);
 	if (IS_ERR(p))
 		return p;

