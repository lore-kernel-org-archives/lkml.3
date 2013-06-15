Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3FORez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 13:34:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab3FORex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 13:34:53 -0400
Date: Sat, 15 Jun 2013 19:30:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>, Huang Ying <ying.huang@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] fput: turn "list_head delayed_fput_list" into
	llist_head
Message-ID: <20130615173039.GA15058@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130615172959.GA14656@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fput() and delayed_fput() can use llist and avoid the locking.

This is unlikely path, it is not that this change can improve
the performance, but this way the code looks simpler.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/file_table.c    |   25 ++++++++++---------------
 include/linux/fs.h |    2 ++
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 3a2bbc5..94b1bfa 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -265,18 +265,15 @@ static void __fput(struct file *file)
 	mntput(mnt);
 }
 
-static DEFINE_SPINLOCK(delayed_fput_lock);
-static LIST_HEAD(delayed_fput_list);
+static LLIST_HEAD(delayed_fput_list);
 static void delayed_fput(struct work_struct *unused)
 {
-	LIST_HEAD(head);
-	spin_lock_irq(&delayed_fput_lock);
-	list_splice_init(&delayed_fput_list, &head);
-	spin_unlock_irq(&delayed_fput_lock);
-	while (!list_empty(&head)) {
-		struct file *f = list_first_entry(&head, struct file, f_u.fu_list);
-		list_del_init(&f->f_u.fu_list);
-		__fput(f);
+	struct llist_node *node = llist_del_all(&delayed_fput_list);
+	struct llist_node *next;
+
+	for (; node; node = next) {
+		next = llist_next(node);
+		__fput(llist_entry(node, struct file, f_u.fu_llist));
 	}
 }
 
@@ -306,7 +303,6 @@ void fput(struct file *file)
 {
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		struct task_struct *task = current;
-		unsigned long flags;
 
 		file_sb_list_del(file);
 		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
@@ -320,10 +316,9 @@ void fput(struct file *file)
 			 * fput to avoid leaking *file.
 			 */
 		}
-		spin_lock_irqsave(&delayed_fput_lock, flags);
-		list_add(&file->f_u.fu_list, &delayed_fput_list);
-		schedule_work(&delayed_fput_work);
-		spin_unlock_irqrestore(&delayed_fput_lock, flags);
+
+		if (llist_add(&file->f_u.fu_llist, &delayed_fput_list))
+			schedule_work(&delayed_fput_work);
 	}
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 43db02e..8a60d99 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -10,6 +10,7 @@
 #include <linux/stat.h>
 #include <linux/cache.h>
 #include <linux/list.h>
+#include <linux/llist.h>
 #include <linux/radix-tree.h>
 #include <linux/rbtree.h>
 #include <linux/init.h>
@@ -767,6 +768,7 @@ struct file {
 	 */
 	union {
 		struct list_head	fu_list;
+		struct llist_node	fu_llist;
 		struct rcu_head 	fu_rcuhead;
 	} f_u;
 	struct path		f_path;
-- 
1.5.5.1

