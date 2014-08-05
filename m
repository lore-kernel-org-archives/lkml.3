Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaHETtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:49:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbaHETtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:49:14 -0400
Date: Tue, 5 Aug 2014 21:46:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] proc: introduce proc_mem_open()
Message-ID: <20140805194652.GA30721@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194627.GA30693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the mm_access() code from __mem_open() into the new helper,
proc_mem_open(), the next patch will add another caller.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c     |   36 +++++++++++++++++++++---------------
 fs/proc/internal.h |    2 ++
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2d696b0..9aef9ac 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -667,29 +667,35 @@ static const struct file_operations proc_single_file_operations = {
 	.release	= single_release,
 };
 
-static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
+
+struct mm_struct *proc_mem_open(struct inode *inode, unsigned int mode)
 {
-	struct task_struct *task = get_proc_task(file_inode(file));
-	struct mm_struct *mm;
+	struct task_struct *task = get_proc_task(inode);
+	struct mm_struct *mm = ERR_PTR(-ESRCH);
 
-	if (!task)
-		return -ESRCH;
+	if (task) {
+		mm = mm_access(task, mode);
+		put_task_struct(task);
 
-	mm = mm_access(task, mode);
-	put_task_struct(task);
+		if (!IS_ERR_OR_NULL(mm)) {
+			/* ensure this mm_struct can't be freed */
+			atomic_inc(&mm->mm_count);
+			/* but do not pin its memory */
+			mmput(mm);
+		}
+	}
+
+	return mm;
+}
+
+static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
+{
+	struct mm_struct *mm = proc_mem_open(inode, mode);
 
 	if (IS_ERR(mm))
 		return PTR_ERR(mm);
 
-	if (mm) {
-		/* ensure this mm_struct can't be freed */
-		atomic_inc(&mm->mm_count);
-		/* but do not pin its memory */
-		mmput(mm);
-	}
-
 	file->private_data = mm;
-
 	return 0;
 }
 
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 3ab6d14..ba0c1c1 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -275,6 +275,8 @@ struct proc_maps_private {
 #endif
 };
 
+struct mm_struct *proc_mem_open(struct inode *inode, unsigned int mode);
+
 extern const struct file_operations proc_pid_maps_operations;
 extern const struct file_operations proc_tid_maps_operations;
 extern const struct file_operations proc_pid_numa_maps_operations;
-- 
1.5.5.1

