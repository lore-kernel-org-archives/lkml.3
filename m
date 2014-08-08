Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbaHHTAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:00:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068AbaHHTAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:00:16 -0400
Date: Fri, 8 Aug 2014 20:57:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/5] proc: kill *_tid_*maps* stuff
Message-ID: <20140808185755.GA784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808185732.GA760@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill *_tid_*maps* data/functions. proc_maps_open() can use
is_tgid_pid_entry() and initialize priv->is_tgid for ->show()
methods.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c     |    6 +-
 fs/proc/internal.h |    4 +-
 fs/proc/task_mmu.c |  140 ++++++++--------------------------------------------
 3 files changed, 25 insertions(+), 125 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9d47fe0..368f6fe 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2919,12 +2919,12 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_pid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
-	REG("maps",      S_IRUGO, proc_tid_maps_operations),
+	REG("maps",      S_IRUGO, proc_pid_maps_operations),
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("children",  S_IRUGO, proc_tid_children_operations),
 #endif
 #ifdef CONFIG_NUMA
-	REG("numa_maps", S_IRUGO, proc_tid_numa_maps_operations),
+	REG("numa_maps", S_IRUGO, proc_pid_numa_maps_operations),
 #endif
 	REG("mem",       S_IRUSR|S_IWUSR, proc_mem_operations),
 	LNK("cwd",       proc_cwd_link),
@@ -2934,7 +2934,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("mountinfo",  S_IRUGO, proc_mountinfo_operations),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
-	REG("smaps",     S_IRUGO, proc_tid_smaps_operations),
+	REG("smaps",     S_IRUGO, proc_pid_smaps_operations),
 	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index c7bb0e3..46500af 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -268,6 +268,7 @@ extern int proc_remount(struct super_block *, int *, char *);
  */
 struct proc_maps_private {
 	struct pid *pid;
+	bool is_tgid;
 	struct task_struct *task;
 	struct mm_struct *mm;
 #ifdef CONFIG_MMU
@@ -281,11 +282,8 @@ struct proc_maps_private {
 struct mm_struct *proc_mem_open(struct inode *inode, unsigned int mode);
 
 extern const struct file_operations proc_pid_maps_operations;
-extern const struct file_operations proc_tid_maps_operations;
 extern const struct file_operations proc_pid_numa_maps_operations;
-extern const struct file_operations proc_tid_numa_maps_operations;
 extern const struct file_operations proc_pid_smaps_operations;
-extern const struct file_operations proc_tid_smaps_operations;
 extern const struct file_operations proc_clear_refs_operations;
 extern const struct file_operations proc_pagemap_operations;
 
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4ec6b72..7618ef8 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -231,6 +231,7 @@ static int proc_maps_open(struct inode *inode, struct file *file,
 		return -ENOMEM;
 
 	priv->pid = proc_pid(inode);
+	priv->is_tgid = is_tgid_pid_entry(PROC_I(inode)->pid_entry);
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
 	if (IS_ERR(priv->mm)) {
 		int err = PTR_ERR(priv->mm);
@@ -252,16 +253,7 @@ static int proc_map_release(struct inode *inode, struct file *file)
 	return seq_release_private(inode, file);
 }
 
-
-static int do_maps_open(struct inode *inode, struct file *file,
-			const struct seq_operations *ops)
-{
-	return proc_maps_open(inode, file, ops,
-				sizeof(struct proc_maps_private));
-}
-
-static void
-show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
+static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
@@ -331,15 +323,15 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 			goto done;
 		}
 
-		tid = vm_is_stack(task, vma, is_pid);
-
+		tid = vm_is_stack(task, vma, priv->is_tgid);
 		if (tid != 0) {
 			/*
 			 * Thread stack in /proc/PID/task/TID/maps or
 			 * the main process stack.
 			 */
-			if (!is_pid || (vma->vm_start <= mm->start_stack &&
-			    vma->vm_end >= mm->start_stack)) {
+			if (!priv->is_tgid ||
+			    (vma->vm_start <= mm->start_stack &&
+			     vma->vm_end >= mm->start_stack)) {
 				name = "[stack]";
 			} else {
 				/* Thread stack in /proc/PID/maps */
@@ -357,23 +349,13 @@ done:
 	seq_putc(m, '\n');
 }
 
-static int show_map(struct seq_file *m, void *v, int is_pid)
+static int show_pid_map(struct seq_file *m, void *v)
 {
-	show_map_vma(m, v, is_pid);
+	show_map_vma(m, v);
 	m_cache_vma(m, v);
 	return 0;
 }
 
-static int show_pid_map(struct seq_file *m, void *v)
-{
-	return show_map(m, v, 1);
-}
-
-static int show_tid_map(struct seq_file *m, void *v)
-{
-	return show_map(m, v, 0);
-}
-
 static const struct seq_operations proc_pid_maps_op = {
 	.start	= m_start,
 	.next	= m_next,
@@ -381,21 +363,10 @@ static const struct seq_operations proc_pid_maps_op = {
 	.show	= show_pid_map
 };
 
-static const struct seq_operations proc_tid_maps_op = {
-	.start	= m_start,
-	.next	= m_next,
-	.stop	= m_stop,
-	.show	= show_tid_map
-};
-
 static int pid_maps_open(struct inode *inode, struct file *file)
 {
-	return do_maps_open(inode, file, &proc_pid_maps_op);
-}
-
-static int tid_maps_open(struct inode *inode, struct file *file)
-{
-	return do_maps_open(inode, file, &proc_tid_maps_op);
+	return proc_maps_open(inode, file, &proc_pid_maps_op,
+				sizeof(struct proc_maps_private));
 }
 
 const struct file_operations proc_pid_maps_operations = {
@@ -405,13 +376,6 @@ const struct file_operations proc_pid_maps_operations = {
 	.release	= proc_map_release,
 };
 
-const struct file_operations proc_tid_maps_operations = {
-	.open		= tid_maps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= proc_map_release,
-};
-
 /*
  * Proportional Set Size(PSS): my share of RSS.
  *
@@ -584,7 +548,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 	seq_putc(m, '\n');
 }
 
-static int show_smap(struct seq_file *m, void *v, int is_pid)
+static int show_pid_smap(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
@@ -600,7 +564,7 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
 
-	show_map_vma(m, vma, is_pid);
+	show_map_vma(m, vma);
 
 	seq_printf(m,
 		   "Size:           %8lu kB\n"
@@ -642,16 +606,6 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 	return 0;
 }
 
-static int show_pid_smap(struct seq_file *m, void *v)
-{
-	return show_smap(m, v, 1);
-}
-
-static int show_tid_smap(struct seq_file *m, void *v)
-{
-	return show_smap(m, v, 0);
-}
-
 static const struct seq_operations proc_pid_smaps_op = {
 	.start	= m_start,
 	.next	= m_next,
@@ -659,21 +613,10 @@ static const struct seq_operations proc_pid_smaps_op = {
 	.show	= show_pid_smap
 };
 
-static const struct seq_operations proc_tid_smaps_op = {
-	.start	= m_start,
-	.next	= m_next,
-	.stop	= m_stop,
-	.show	= show_tid_smap
-};
-
 static int pid_smaps_open(struct inode *inode, struct file *file)
 {
-	return do_maps_open(inode, file, &proc_pid_smaps_op);
-}
-
-static int tid_smaps_open(struct inode *inode, struct file *file)
-{
-	return do_maps_open(inode, file, &proc_tid_smaps_op);
+	return proc_maps_open(inode, file, &proc_pid_smaps_op,
+				sizeof(struct proc_maps_private));
 }
 
 const struct file_operations proc_pid_smaps_operations = {
@@ -683,13 +626,6 @@ const struct file_operations proc_pid_smaps_operations = {
 	.release	= proc_map_release,
 };
 
-const struct file_operations proc_tid_smaps_operations = {
-	.open		= tid_smaps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= proc_map_release,
-};
-
 /*
  * We do not want to have constant page-shift bits sitting in
  * pagemap entries and are about to reuse them some time soon.
@@ -1382,7 +1318,7 @@ static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 /*
  * Display pages allocated per node and memory policy via /proc.
  */
-static int show_numa_map(struct seq_file *m, void *v, int is_pid)
+static int show_pid_numa_map(struct seq_file *m, void *v)
 {
 	struct numa_maps_private *numa_priv = m->private;
 	struct proc_maps_private *proc_priv = &numa_priv->proc_maps;
@@ -1421,14 +1357,15 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
 		seq_puts(m, " heap");
 	} else {
-		pid_t tid = vm_is_stack(task, vma, is_pid);
+		pid_t tid = vm_is_stack(task, vma, proc_priv->is_tgid);
 		if (tid != 0) {
 			/*
 			 * Thread stack in /proc/PID/task/TID/maps or
 			 * the main process stack.
 			 */
-			if (!is_pid || (vma->vm_start <= mm->start_stack &&
-			    vma->vm_end >= mm->start_stack))
+			if (!proc_priv->is_tgid ||
+			    (vma->vm_start <= mm->start_stack &&
+			     vma->vm_end >= mm->start_stack))
 				seq_puts(m, " stack");
 			else
 				seq_printf(m, " stack:%d", tid);
@@ -1473,16 +1410,6 @@ out:
 	return 0;
 }
 
-static int show_pid_numa_map(struct seq_file *m, void *v)
-{
-	return show_numa_map(m, v, 1);
-}
-
-static int show_tid_numa_map(struct seq_file *m, void *v)
-{
-	return show_numa_map(m, v, 0);
-}
-
 static const struct seq_operations proc_pid_numa_maps_op = {
 	.start  = m_start,
 	.next   = m_next,
@@ -1490,28 +1417,10 @@ static const struct seq_operations proc_pid_numa_maps_op = {
 	.show   = show_pid_numa_map,
 };
 
-static const struct seq_operations proc_tid_numa_maps_op = {
-	.start  = m_start,
-	.next   = m_next,
-	.stop   = m_stop,
-	.show   = show_tid_numa_map,
-};
-
-static int numa_maps_open(struct inode *inode, struct file *file,
-			  const struct seq_operations *ops)
-{
-	return proc_maps_open(inode, file, ops,
-				sizeof(struct numa_maps_private));
-}
-
 static int pid_numa_maps_open(struct inode *inode, struct file *file)
 {
-	return numa_maps_open(inode, file, &proc_pid_numa_maps_op);
-}
-
-static int tid_numa_maps_open(struct inode *inode, struct file *file)
-{
-	return numa_maps_open(inode, file, &proc_tid_numa_maps_op);
+	return proc_maps_open(inode, file, &proc_pid_numa_maps_op,
+				sizeof(struct numa_maps_private));
 }
 
 const struct file_operations proc_pid_numa_maps_operations = {
@@ -1520,11 +1429,4 @@ const struct file_operations proc_pid_numa_maps_operations = {
 	.llseek		= seq_lseek,
 	.release	= proc_map_release,
 };
-
-const struct file_operations proc_tid_numa_maps_operations = {
-	.open		= tid_numa_maps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= proc_map_release,
-};
 #endif /* CONFIG_NUMA */
-- 
1.5.5.1

