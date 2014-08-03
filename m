Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaHCVWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 17:22:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbaHCVWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 17:22:45 -0400
Date: Sun, 3 Aug 2014 23:20:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 4/5] fs/proc/task_mmu.c: introduce the "stable"
	proc_maps_private->mm
Message-ID: <20140803212027.GE13330@redhat.com>
References: <1407010227-2269-1-git-send-email-kirill@shutemov.name> <20140803164452.GA14626@redhat.com> <20140803211843.GA13330@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140803211843.GA13330@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A separate change to simplify the review of the next one.

Add the new "mm_struct *mm" member into struct proc_maps_private, it is
initialized by proc_maps_open() at "open" time.

This obviously means that proc_maps_open() users should additionally do
mmdrop() in fop->release(), add the new helper, proc_map_release().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/internal.h |    1 +
 fs/proc/task_mmu.c |   31 +++++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 6 deletions(-)

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
index 794aeb6..1cc623d 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
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


