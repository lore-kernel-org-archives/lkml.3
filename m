Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3IZIJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:09:56 -0400
Received: from mail1.windriver.com ([147.11.146.13]:41655 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab3IZIJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:09:50 -0400
From: Ming Liu <ming.liu@windriver.com>
To: <akpm@linux-foundation.org>, <rientjes@google.com>, <mhocko@suse.cz>,
        <rusty@rustcorp.com.au>, <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V1] oom: avoid selecting threads sharing mm with init
Date: Thu, 26 Sep 2013 16:09:17 +0800
Message-ID: <1380182957-3231-1-git-send-email-ming.liu@windriver.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It won't help free memory for killing tasks sharing mm with init, we should
skip them in oom_unkillable_task(), or we may risk init process getting
killed because after selecting a task to kill, the oom killer iterates all
processes and kills all other user threads that share the same mm_struct
in different thread groups.

In some extreme cases, the selected task happens to be a vfork child of
init process sharing the same mm_struct with it, which causes kernel
panic on init getting killed. This panic is observed in a busybox shell that
busybox itself is init, with a kthread keeps consuming memories.

Signed-off-by: Ming Liu <ming.liu@windriver.com>
---
 mm/oom_kill.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 314e9d2..7e50a95 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -113,11 +113,22 @@ struct task_struct *find_lock_task_mm(struct task_struct *p)
 static bool oom_unkillable_task(struct task_struct *p,
 		const struct mem_cgroup *memcg, const nodemask_t *nodemask)
 {
+	struct task_struct *init_tsk;
+
 	if (is_global_init(p))
 		return true;
 	if (p->flags & PF_KTHREAD)
 		return true;
 
+	/* It won't help free memory if p is sharing mm with init */
+	rcu_read_lock();
+	init_tsk = find_task_by_pid_ns(1, &init_pid_ns);
+	if(p->mm == init_tsk->mm) {
+		rcu_read_unlock();
+		return true;
+	}
+	rcu_read_unlock();
+
 	/* When mem_cgroup_out_of_memory() and p is not member of the group */
 	if (memcg && !task_in_mem_cgroup(p, memcg))
 		return true;
-- 
1.7.0.4

