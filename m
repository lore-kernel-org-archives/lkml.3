Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaHCQrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 12:47:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbaHCQrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 12:47:19 -0400
Date: Sun, 3 Aug 2014 18:44:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH, RESEND] procfs: silence lockdep warning about read vs.
	exec seq_file
Message-ID: <20140803164452.GA14626@redhat.com>
References: <1407010227-2269-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407010227-2269-1-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay,

On 08/02, Kirill A. Shutemov wrote:
>
> +/*
> + * proc_pid_personality() and proc_pid_stack() take cred_guard_mutex via
> + * lock_trace()

And at first glance they lock_trace() can die. But lets temporary ignore,
m_start() is trickier.

> +static struct lock_class_key pid_maps_seq_file_lock;
> +
>  void task_mem(struct seq_file *m, struct mm_struct *mm)
>  {
>  	unsigned long data, text, lib, swap;
> @@ -242,6 +254,7 @@ static int do_maps_open(struct inode *inode, struct file *file,
>  		ret = seq_open(file, ops);
>  		if (!ret) {
>  			struct seq_file *m = file->private_data;
> +			lockdep_set_class(&m->lock, &pid_maps_seq_file_lock);

Perhaps lockdep_set_subclass() would be better... But this doesn't matter.

The question is, why m_start() calls mm_access(). This is not even
strictly correct if the task execs between m_stop() + m_start().

Can't we do something like below? The patch is obviously horrible and
incomplete, just to explain what I meant. Basically this is what
proc_mem_operations does.

Oleg.


diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 3ab6d14..c16b70e 100644
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
index cfa63ee..9b88248 100644
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
 
 	tail_vma = get_gate_vma(priv->task->mm);
@@ -231,6 +231,27 @@ static void m_stop(struct seq_file *m, void *v)
 		put_task_struct(priv->task);
 }
 
+// TODO: change __mem_open() to use this helper
+static struct mm_struct *xxx(struct inode *inode, struct file *file, unsigned int mode)
+{
+	struct task_struct *task = get_proc_task(inode);
+	struct mm_struct *mm = ERR_PTR(-ESRCH);
+
+	if (task) {
+		mm = mm_access(task, mode);
+		put_task_struct(task);
+
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
 static int do_maps_open(struct inode *inode, struct file *file,
 			const struct seq_operations *ops)
 {
@@ -239,17 +260,38 @@ static int do_maps_open(struct inode *inode, struct file *file,
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv) {
 		priv->pid = proc_pid(inode);
+		priv->mm = xxx(inode, file, PTRACE_MODE_READ);
+
+		// XXX cleanup me
+		if (IS_ERR(priv->mm)) {
+			ret = -EACCES;
+			goto free;
+		}
+
 		ret = seq_open(file, ops);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
 			m->private = priv;
 		} else {
+			// XXX cleanup me
+			if (priv->mm)
+				mmdrop(priv->mm);
+ free:
 			kfree(priv);
 		}
 	}
 	return ret;
 }
 
+static int xxx_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct proc_maps_private *priv = seq->private;
+	if (priv->mm)
+		mmdrop(priv->mm);
+	return 0;
+}
+
 static void
 show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 {
@@ -399,14 +441,14 @@ const struct file_operations proc_pid_maps_operations = {
 	.open		= pid_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= xxx_release,
 };
 
 const struct file_operations proc_tid_maps_operations = {
 	.open		= tid_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= xxx_release,
 };
 
 /*
@@ -682,14 +724,14 @@ const struct file_operations proc_pid_smaps_operations = {
 	.open		= pid_smaps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= xxx_release,
 };
 
 const struct file_operations proc_tid_smaps_operations = {
 	.open		= tid_smaps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= xxx_release,
 };
 
 /*

