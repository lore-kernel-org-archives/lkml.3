Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaHTQw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:52:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaHTQwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:52:25 -0400
Date: Wed, 20 Aug 2014 18:50:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Ungerer <gerg@uclinux.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/2] proc/maps: make vm_is_stack() logic
	namespace-friendly
Message-ID: <20140820165012.GC17589@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140820164922.GA17589@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820164922.GA17589@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Rename vm_is_stack() to task_of_stack() and change it to return
  "struct task_struct *" rather than the global (and thus wrong in
  general) pid_t.

- Add the new pid_of_stack() helper which calls task_of_stack() and
  uses the right namespace to report the correct pid_t.

  Unfortunately we need to define this helper twice, in task_mmu.c
  and in task_nommu.c. perhaps it makes sense to add fs/proc/util.c
  and move at least pid_of_stack/task_of_stack there to avoid the
  code duplication.

- Change show_map_vma() and show_numa_map() to use the new helper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c   |   25 +++++++++++++++++++++----
 fs/proc/task_nommu.c |   21 ++++++++++++++++++++-
 include/linux/mm.h   |    4 ++--
 mm/util.c            |   23 ++++++++---------------
 4 files changed, 51 insertions(+), 22 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 828ff49..9d7a9a6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -262,13 +262,31 @@ static int do_maps_open(struct inode *inode, struct file *file,
 				sizeof(struct proc_maps_private));
 }
 
+static pid_t pid_of_stack(struct proc_maps_private *priv,
+				struct vm_area_struct *vma, bool is_pid)
+{
+	struct inode *inode = priv->inode;
+	struct task_struct *task;
+	pid_t ret = 0;
+
+	rcu_read_lock();
+	task = pid_task(proc_pid(inode), PIDTYPE_PID);
+	if (task) {
+		task = task_of_stack(task, vma, is_pid);
+		if (task)
+			ret = task_pid_nr_ns(task, inode->i_sb->s_fs_info);
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static void
 show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
 	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
 	vm_flags_t flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
@@ -333,8 +351,7 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 			goto done;
 		}
 
-		tid = vm_is_stack(task, vma, is_pid);
-
+		tid = pid_of_stack(priv, vma, is_pid);
 		if (tid != 0) {
 			/*
 			 * Thread stack in /proc/PID/task/TID/maps or
@@ -1438,7 +1455,7 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
 		seq_puts(m, " heap");
 	} else {
-		pid_t tid = vm_is_stack(task, vma, is_pid);
+		pid_t tid = pid_of_stack(proc_priv, vma, is_pid);
 		if (tid != 0) {
 			/*
 			 * Thread stack in /proc/PID/task/TID/maps or
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index f1cc304..0283e5c 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -123,6 +123,25 @@ unsigned long task_statm(struct mm_struct *mm,
 	return size;
 }
 
+static pid_t pid_of_stack(struct proc_maps_private *priv,
+				struct vm_area_struct *vma, bool is_pid)
+{
+	struct inode *inode = priv->inode;
+	struct task_struct *task;
+	pid_t ret = 0;
+
+	rcu_read_lock();
+	task = pid_task(proc_pid(inode), PIDTYPE_PID);
+	if (task) {
+		task = task_of_stack(task, vma, is_pid);
+		if (task)
+			ret = task_pid_nr_ns(task, inode->i_sb->s_fs_info);
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 /*
  * display a single VMA to a sequenced file
  */
@@ -163,7 +182,7 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma,
 		seq_pad(m, ' ');
 		seq_path(m, &file->f_path, "");
 	} else if (mm) {
-		pid_t tid = vm_is_stack(priv->task, vma, is_pid);
+		pid_t tid = pid_of_stack(priv, vma, is_pid);
 
 		if (tid != 0) {
 			seq_pad(m, ' ');
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8981cc8..1c05bd8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1247,8 +1247,8 @@ static inline int stack_guard_page_end(struct vm_area_struct *vma,
 		!vma_growsup(vma->vm_next, addr);
 }
 
-extern pid_t
-vm_is_stack(struct task_struct *task, struct vm_area_struct *vma, int in_group);
+extern struct task_struct *task_of_stack(struct task_struct *task,
+				struct vm_area_struct *vma, bool in_group);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
diff --git a/mm/util.c b/mm/util.c
index 093c973..fec39d4 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -170,32 +170,25 @@ static int vm_is_stack_for_task(struct task_struct *t,
 /*
  * Check if the vma is being used as a stack.
  * If is_group is non-zero, check in the entire thread group or else
- * just check in the current task. Returns the pid of the task that
- * the vma is stack for.
+ * just check in the current task. Returns the task_struct of the task
+ * that the vma is stack for. Must be called under rcu_read_lock().
  */
-pid_t vm_is_stack(struct task_struct *task,
-		  struct vm_area_struct *vma, int in_group)
+struct task_struct *task_of_stack(struct task_struct *task,
+				struct vm_area_struct *vma, bool in_group)
 {
-	pid_t ret = 0;
-
 	if (vm_is_stack_for_task(task, vma))
-		return task->pid;
+		return task;
 
 	if (in_group) {
 		struct task_struct *t;
 
-		rcu_read_lock();
 		for_each_thread(task, t) {
-			if (vm_is_stack_for_task(t, vma)) {
-				ret = t->pid;
-				goto done;
-			}
+			if (vm_is_stack_for_task(t, vma))
+				return t;
 		}
-done:
-		rcu_read_unlock();
 	}
 
-	return ret;
+	return NULL;
 }
 
 #if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
-- 
1.5.5.1


