Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaHKRDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:03:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbaHKRDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:03:02 -0400
Date: Mon, 11 Aug 2014 19:00:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>
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
Subject: [PATCH 2/3] fs/proc/task_nommu.c: shift mm_access() from m_start()
	to proc_maps_open()
Message-ID: <20140811170035.GA24800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811170008.GA24629@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy-and-paste the changes from "fs/proc/task_mmu.c: shift mm_access()
from m_start() to proc_maps_open()" into task_nommu.c.

Change maps_open() to initialize priv->mm using proc_mem_open(), m_start()
can rely on atomic_inc_not_zero(mm_users) like task_mmu.c does.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_nommu.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index c12eab3..003f2be 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -216,11 +216,11 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = mm_access(priv->task, PTRACE_MODE_READ);
-	if (!mm || IS_ERR(mm)) {
+	mm = priv->mm;
+	if (!mm || !atomic_inc_not_zero(&mm->mm_users)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
-		return mm;
+		return NULL;
 	}
 	down_read(&mm->mmap_sem);
 
@@ -274,9 +274,28 @@ static int maps_open(struct inode *inode, struct file *file,
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
 
+
+static int map_release(struct inode *inode, struct file *file)
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
 static int pid_maps_open(struct inode *inode, struct file *file)
 {
 	return maps_open(inode, file, &proc_pid_maps_ops);
@@ -291,13 +310,13 @@ const struct file_operations proc_pid_maps_operations = {
 	.open		= pid_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= map_release,
 };
 
 const struct file_operations proc_tid_maps_operations = {
 	.open		= tid_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= map_release,
 };
 
-- 
1.5.5.1

