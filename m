Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaHETvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:51:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbaHETtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:49:19 -0400
Date: Tue, 5 Aug 2014 21:46:55 +0200
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
Subject: [PATCH v2 4/7] fs/proc/task_mmu.c: shift mm_access() from
	m_start() to proc_maps_open()
Message-ID: <20140805194655.GA30728@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194627.GA30693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple test-case from Kirill Shutemov

	cat /proc/self/maps >/dev/null
	chmod +x /proc/self/net/packet
	exec /proc/self/net/packet

makes lockdep unhappy, cat/exec take seq_file->lock + cred_guard_mutex in
the opposite order.

It's a false positive and probably we should not allow "chmod +x" on proc
files. Still I think that we should avoid mm_access() and cred_guard_mutex
in sys_read() paths, security checking should happen at open time. Besides,
this doesn't even look right if the task changes its ->mm between m_stop()
and m_start().

Add the new "mm_struct *mm" member into struct proc_maps_private and change
proc_maps_open() to initialize it using proc_mem_open(). Change m_start() to
use priv->mm if atomic_inc_not_zero(mm_users) succeeds or return NULL (eof)
otherwise.

The only complication is that proc_maps_open() users should additionally do
mmdrop() in fop->release(), add the new proc_map_release() helper for that.

Note: this is the user-visible change, if the task execs after open("maps")
the new ->mm won't be visible via this file. I hope this is fine, and this
matches /proc/pid/mem bahaviour.

Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/internal.h |    1 +
 fs/proc/task_mmu.c |   37 ++++++++++++++++++++++++++++---------
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index ba0c1c1..78784cd 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -267,6 +267,7 @@ extern int proc_remount(struct super_block *, int *, char *);
 struct proc_maps_private {
 	struct pid *pid;
 	struct task_struct *task;
+	struct mm_struct *mm;
 #ifdef CONFIG_MMU
 	struct vm_area_struct *tail_vma;
 #endif
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 794aeb6..7ec8eb5 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -165,9 +165,9 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = mm_access(priv->task, PTRACE_MODE_READ);
-	if (!mm || IS_ERR(mm))
-		return mm;
+	mm = priv->mm;
+	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
+		return NULL;
 	down_read(&mm->mmap_sem);
 
 	tail_vma = get_gate_vma(mm);
@@ -240,9 +240,28 @@ static int proc_maps_open(struct inode *inode, struct file *file,
 		return -ENOMEM;
 
 	priv->pid = proc_pid(inode);
+	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR(priv->mm)) {
+		int err = PTR_ERR(priv->mm);
+		seq_release_private(inode, file);
+		return err;
+	}
+
 	return 0;
 }
 
+static int proc_map_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct proc_maps_private *priv = seq->private;
+
+	if (priv->mm)
+		mmdrop(priv->mm);
+
+	return seq_release_private(inode, file);
+}
+
+
 static int do_maps_open(struct inode *inode, struct file *file,
 			const struct seq_operations *ops)
 {
@@ -398,14 +417,14 @@ const struct file_operations proc_pid_maps_operations = {
 	.open		= pid_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= proc_map_release,
 };
 
 const struct file_operations proc_tid_maps_operations = {
 	.open		= tid_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= proc_map_release,
 };
 
 /*
@@ -680,14 +699,14 @@ const struct file_operations proc_pid_smaps_operations = {
 	.open		= pid_smaps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= proc_map_release,
 };
 
 const struct file_operations proc_tid_smaps_operations = {
 	.open		= tid_smaps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= proc_map_release,
 };
 
 /*
@@ -1520,13 +1539,13 @@ const struct file_operations proc_pid_numa_maps_operations = {
 	.open		= pid_numa_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= proc_map_release,
 };
 
 const struct file_operations proc_tid_numa_maps_operations = {
 	.open		= tid_numa_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= proc_map_release,
 };
 #endif /* CONFIG_NUMA */
-- 
1.5.5.1

