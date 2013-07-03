Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965676Ab3GCUWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:22:25 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:17461 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965659Ab3GCUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:22:19 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 23/25] cgroup: Change how dentry's d_lock field is accessed
Date: Wed,  3 Jul 2013 16:22:06 -0400
Message-Id: <1372882926-23239-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that
use the d_lock field of the dentry structure need to be changed
accordingly. All the d_lock's spin_lock() and spin_unlock() calls
are replaced by the corresponding d_lock() and d_unlock() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/cgroup.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a7c9e6d..8935c05 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -974,11 +974,11 @@ static void cgroup_d_remove_dir(struct dentry *dentry)
 	cgroup_clear_directory(dentry, true, root->subsys_mask);
 
 	parent = dentry->d_parent;
-	spin_lock(&parent->d_lock);
-	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+	d_lock(parent);
+	d_lock_nested(dentry, DENTRY_D_LOCK_NESTED);
 	list_del_init(&dentry->d_u.d_child);
-	spin_unlock(&dentry->d_lock);
-	spin_unlock(&parent->d_lock);
+	d_unlock(dentry);
+	d_unlock(parent);
 	remove_dir(dentry);
 }
 
@@ -1783,7 +1783,7 @@ static struct kobject *cgroup_kobj;
  * Writes path of cgroup into buf.  Returns 0 on success, -errno on error.
  *
  * We can't generate cgroup path using dentry->d_name, as accessing
- * dentry->name must be protected by irq-unsafe dentry->d_lock or parent
+ * dentry->name must be protected by irq-unsafe d_ret_lock(dentry) or parent
  * inode's i_mutex, while on the other hand cgroup_path() can be called
  * with some irq-safe spinlocks held.
  */
-- 
1.7.1

