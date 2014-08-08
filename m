Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbaHHTAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:00:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757933AbaHHTAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:00:21 -0400
Date: Fri, 8 Aug 2014 20:58:03 +0200
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
Subject: [RFC PATCH 5/5] proc: unify proc_pid_*maps* stuff
Message-ID: <20140808185803.GA798@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808185732.GA760@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A single seq_operations/file_operations pair can handle maps, smaps,
and numa_maps files. Just the generic ->open() needs to look at
pid_entry_name() and initialize priv->show() accordingly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c     |    8 ++--
 fs/proc/internal.h |    3 +-
 fs/proc/task_mmu.c |  123 +++++++++++++++++++++-------------------------------
 3 files changed, 54 insertions(+), 80 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 81d372c..4018a86 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2585,7 +2585,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
 #ifdef CONFIG_NUMA
-	REG("numa_maps",  S_IRUGO, proc_pid_numa_maps_operations),
+	REG("numa_maps",  S_IRUGO, proc_pid_maps_operations),
 #endif
 	REG("mem",        S_IRUSR|S_IWUSR, proc_mem_operations),
 	LNK("cwd",        proc_cwd_link),
@@ -2596,7 +2596,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("mountstats", S_IRUSR, proc_mountstats_operations),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
-	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
+	REG("smaps",      S_IRUGO, proc_pid_maps_operations),
 	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
@@ -2924,7 +2924,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("children",  S_IRUGO, proc_tid_children_operations),
 #endif
 #ifdef CONFIG_NUMA
-	REG("numa_maps", S_IRUGO, proc_pid_numa_maps_operations),
+	REG("numa_maps", S_IRUGO, proc_pid_maps_operations),
 #endif
 	REG("mem",       S_IRUSR|S_IWUSR, proc_mem_operations),
 	LNK("cwd",       proc_cwd_link),
@@ -2934,7 +2934,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("mountinfo",  S_IRUGO, proc_mountinfo_operations),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
-	REG("smaps",     S_IRUGO, proc_pid_smaps_operations),
+	REG("smaps",     S_IRUGO, proc_pid_maps_operations),
 	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index c162db2..17091c9 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -270,6 +270,7 @@ extern int proc_remount(struct super_block *, int *, char *);
 struct proc_maps_private {
 	struct pid *pid;
 	bool is_tgid;
+	int (*show)(struct seq_file *m, void *v);
 	struct task_struct *task;
 	struct mm_struct *mm;
 #ifdef CONFIG_MMU
@@ -283,8 +284,6 @@ struct proc_maps_private {
 struct mm_struct *proc_mem_open(struct inode *inode, unsigned int mode);
 
 extern const struct file_operations proc_pid_maps_operations;
-extern const struct file_operations proc_pid_numa_maps_operations;
-extern const struct file_operations proc_pid_smaps_operations;
 extern const struct file_operations proc_clear_refs_operations;
 extern const struct file_operations proc_pagemap_operations;
 
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7618ef8..4ef991a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -222,26 +222,6 @@ static void m_stop(struct seq_file *m, void *v)
 	}
 }
 
-static int proc_maps_open(struct inode *inode, struct file *file,
-			const struct seq_operations *ops, int psize)
-{
-	struct proc_maps_private *priv = __seq_open_private(file, ops, psize);
-
-	if (!priv)
-		return -ENOMEM;
-
-	priv->pid = proc_pid(inode);
-	priv->is_tgid = is_tgid_pid_entry(PROC_I(inode)->pid_entry);
-	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR(priv->mm)) {
-		int err = PTR_ERR(priv->mm);
-		seq_release_private(inode, file);
-		return err;
-	}
-
-	return 0;
-}
-
 static int proc_map_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
@@ -352,30 +332,9 @@ done:
 static int show_pid_map(struct seq_file *m, void *v)
 {
 	show_map_vma(m, v);
-	m_cache_vma(m, v);
 	return 0;
 }
 
-static const struct seq_operations proc_pid_maps_op = {
-	.start	= m_start,
-	.next	= m_next,
-	.stop	= m_stop,
-	.show	= show_pid_map
-};
-
-static int pid_maps_open(struct inode *inode, struct file *file)
-{
-	return proc_maps_open(inode, file, &proc_pid_maps_op,
-				sizeof(struct proc_maps_private));
-}
-
-const struct file_operations proc_pid_maps_operations = {
-	.open		= pid_maps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= proc_map_release,
-};
-
 /*
  * Proportional Set Size(PSS): my share of RSS.
  *
@@ -602,30 +561,9 @@ static int show_pid_smap(struct seq_file *m, void *v)
 				mss.nonlinear >> 10);
 
 	show_smap_vma_flags(m, vma);
-	m_cache_vma(m, vma);
 	return 0;
 }
 
-static const struct seq_operations proc_pid_smaps_op = {
-	.start	= m_start,
-	.next	= m_next,
-	.stop	= m_stop,
-	.show	= show_pid_smap
-};
-
-static int pid_smaps_open(struct inode *inode, struct file *file)
-{
-	return proc_maps_open(inode, file, &proc_pid_smaps_op,
-				sizeof(struct proc_maps_private));
-}
-
-const struct file_operations proc_pid_smaps_operations = {
-	.open		= pid_smaps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= proc_map_release,
-};
-
 /*
  * We do not want to have constant page-shift bits sitting in
  * pagemap entries and are about to reuse them some time soon.
@@ -1406,27 +1344,64 @@ static int show_pid_numa_map(struct seq_file *m, void *v)
 			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
 out:
 	seq_putc(m, '\n');
-	m_cache_vma(m, vma);
 	return 0;
 }
+#endif /* CONFIG_NUMA */
 
-static const struct seq_operations proc_pid_numa_maps_op = {
-	.start  = m_start,
-	.next   = m_next,
-	.stop   = m_stop,
-	.show   = show_pid_numa_map,
+static int m_show(struct seq_file *m, void *v)
+{
+	struct proc_maps_private *priv = m->private;
+	priv->show(m, v);
+	m_cache_vma(m, v);
+	return 0;
+}
+
+static const struct seq_operations proc_pid_maps_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= m_show,
 };
 
-static int pid_numa_maps_open(struct inode *inode, struct file *file)
+static int proc_maps_open(struct inode *inode, struct file *file)
 {
-	return proc_maps_open(inode, file, &proc_pid_numa_maps_op,
-				sizeof(struct numa_maps_private));
+	const char *name = pid_entry_name(PROC_I(inode)->pid_entry);
+	int psize = sizeof(struct proc_maps_private);
+	int (*show)(struct seq_file *m, void *v);
+	struct proc_maps_private *priv;
+
+	if (strcmp(name, "maps") == 0)
+		show = show_pid_map;
+	else if (strcmp(name, "smaps") == 0)
+		show = show_pid_smap;
+	else if (strcmp(name, "numa_maps") == 0) {
+		show = show_pid_numa_map;
+		psize = sizeof(struct numa_maps_private);
+	}
+	else
+		BUG();
+
+	priv = __seq_open_private(file, &proc_pid_maps_op, psize);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->show = show;
+	priv->pid = proc_pid(inode);
+	priv->is_tgid = is_tgid_pid_entry(PROC_I(inode)->pid_entry);
+	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR(priv->mm)) {
+		int err = PTR_ERR(priv->mm);
+		seq_release_private(inode, file);
+		return err;
+	}
+
+	return 0;
 }
 
-const struct file_operations proc_pid_numa_maps_operations = {
-	.open		= pid_numa_maps_open,
+const struct file_operations proc_pid_maps_operations = {
+	.open		= proc_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= proc_map_release,
 };
-#endif /* CONFIG_NUMA */
+
-- 
1.5.5.1

