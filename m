Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaHTQwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaHTQwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:52:07 -0400
Date: Wed, 20 Aug 2014 18:49:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Ungerer <gerg@uclinux.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/2] proc/maps: replace proc_maps_private->pid with
	"struct inode *inode"
Message-ID: <20140820164952.GB17589@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140820164922.GA17589@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820164922.GA17589@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m_start() can use get_proc_task() instead, and "struct inode *"
provides more potentially useful info, see the next changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/internal.h   |    2 +-
 fs/proc/task_mmu.c   |    4 ++--
 fs/proc/task_nommu.c |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index d271828..aa7a0ee 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -268,7 +268,7 @@ extern int proc_remount(struct super_block *, int *, char *);
  * task_[no]mmu.c
  */
 struct proc_maps_private {
-	struct pid *pid;
+	struct inode *inode;
 	struct task_struct *task;
 	struct mm_struct *mm;
 #ifdef CONFIG_MMU
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index aceff2d..828ff49 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -164,7 +164,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	if (last_addr == -1UL)
 		return NULL;
 
-	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
+	priv->task = get_proc_task(priv->inode);
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
@@ -231,7 +231,7 @@ static int proc_maps_open(struct inode *inode, struct file *file,
 	if (!priv)
 		return -ENOMEM;
 
-	priv->pid = proc_pid(inode);
+	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
 	if (IS_ERR(priv->mm)) {
 		int err = PTR_ERR(priv->mm);
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 8f157e4..f1cc304 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -212,7 +212,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	loff_t n = *pos;
 
 	/* pin the task and mm whilst we play with them */
-	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
+	priv->task = get_proc_task(priv->inode);
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
@@ -275,7 +275,7 @@ static int maps_open(struct inode *inode, struct file *file,
 	if (!priv)
 		return -ENOMEM;
 
-	priv->pid = proc_pid(inode);
+	priv->inode = inode;
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
 	if (IS_ERR(priv->mm)) {
 		int err = PTR_ERR(priv->mm);
-- 
1.5.5.1


