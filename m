Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965994AbaGRNcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:32:35 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17807 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761045AbaGRNPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 133/170] cpuset,mempolicy: fix sleeping function called from invalid context
Date: Fri, 18 Jul 2014 14:12:18 +0200
Message-Id: <208b6b11ac4951091f792c661610fdcdc64f74fb.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 391acf970d21219a2a5446282d3b20eace0c0d7a upstream.

When runing with the kernel(3.15-rc7+), the follow bug occurs:
[ 9969.258987] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:586
[ 9969.359906] in_atomic(): 1, irqs_disabled(): 0, pid: 160655, name: python
[ 9969.441175] INFO: lockdep is turned off.
[ 9969.488184] CPU: 26 PID: 160655 Comm: python Tainted: G       A      3.15.0-rc7+ #85
[ 9969.581032] Hardware name: FUJITSU-SV PRIMEQUEST 1800E/SB, BIOS PRIMEQUEST 1000 Series BIOS Version 1.39 11/16/2012
[ 9969.706052]  ffffffff81a20e60 ffff8803e941fbd0 ffffffff8162f523 ffff8803e941fd18
[ 9969.795323]  ffff8803e941fbe0 ffffffff8109995a ffff8803e941fc58 ffffffff81633e6c
[ 9969.884710]  ffffffff811ba5dc ffff880405c6b480 ffff88041fdd90a0 0000000000002000
[ 9969.974071] Call Trace:
[ 9970.003403]  [<ffffffff8162f523>] dump_stack+0x4d/0x66
[ 9970.065074]  [<ffffffff8109995a>] __might_sleep+0xfa/0x130
[ 9970.130743]  [<ffffffff81633e6c>] mutex_lock_nested+0x3c/0x4f0
[ 9970.200638]  [<ffffffff811ba5dc>] ? kmem_cache_alloc+0x1bc/0x210
[ 9970.272610]  [<ffffffff81105807>] cpuset_mems_allowed+0x27/0x140
[ 9970.344584]  [<ffffffff811b1303>] ? __mpol_dup+0x63/0x150
[ 9970.409282]  [<ffffffff811b1385>] __mpol_dup+0xe5/0x150
[ 9970.471897]  [<ffffffff811b1303>] ? __mpol_dup+0x63/0x150
[ 9970.536585]  [<ffffffff81068c86>] ? copy_process.part.23+0x606/0x1d40
[ 9970.613763]  [<ffffffff810bf28d>] ? trace_hardirqs_on+0xd/0x10
[ 9970.683660]  [<ffffffff810ddddf>] ? monotonic_to_bootbased+0x2f/0x50
[ 9970.759795]  [<ffffffff81068cf0>] copy_process.part.23+0x670/0x1d40
[ 9970.834885]  [<ffffffff8106a598>] do_fork+0xd8/0x380
[ 9970.894375]  [<ffffffff81110e4c>] ? __audit_syscall_entry+0x9c/0xf0
[ 9970.969470]  [<ffffffff8106a8c6>] SyS_clone+0x16/0x20
[ 9971.030011]  [<ffffffff81642009>] stub_clone+0x69/0x90
[ 9971.091573]  [<ffffffff81641c29>] ? system_call_fastpath+0x16/0x1b

The cause is that cpuset_mems_allowed() try to take
mutex_lock(&callback_mutex) under the rcu_read_lock(which was hold in
__mpol_dup()). And in cpuset_mems_allowed(), the access to cpuset is
under rcu_read_lock, so in __mpol_dup, we can reduce the rcu_read_lock
protection region to protect the access to cpuset only in
current_cpuset_is_being_rebound(). So that we can avoid this bug.

This patch is a temporary solution that just addresses the bug
mentioned above, can not fix the long-standing issue about cpuset.mems
rebinding on fork():

"When the forker's task_struct is duplicated (which includes
 ->mems_allowed) and it races with an update to cpuset_being_rebound
 in update_tasks_nodemask() then the task's mems_allowed doesn't get
 updated. And the child task's mems_allowed can be wrong if the
 cpuset's nodemask changes before the child has been added to the
 cgroup's tasklist."

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/cpuset.c | 8 +++++++-
 mm/mempolicy.c  | 2 --
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 5ae9f950e024..0b29c52479a6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1236,7 +1236,13 @@ done:
 
 int current_cpuset_is_being_rebound(void)
 {
-	return task_cs(current) == cpuset_being_rebound;
+	int ret;
+
+	rcu_read_lock();
+	ret = task_cs(current) == cpuset_being_rebound;
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 945316989352..0437f3595b32 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2146,7 +2146,6 @@ struct mempolicy *__mpol_dup(struct mempolicy *old)
 	} else
 		*new = *old;
 
-	rcu_read_lock();
 	if (current_cpuset_is_being_rebound()) {
 		nodemask_t mems = cpuset_mems_allowed(current);
 		if (new->flags & MPOL_F_REBINDING)
@@ -2154,7 +2153,6 @@ struct mempolicy *__mpol_dup(struct mempolicy *old)
 		else
 			mpol_rebind_policy(new, &mems, MPOL_REBIND_ONCE);
 	}
-	rcu_read_unlock();
 	atomic_set(&new->refcnt, 1);
 	return new;
 }
-- 
2.0.0

