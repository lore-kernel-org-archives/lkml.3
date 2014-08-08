Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbaHHTAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:00:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbaHHTAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:00:11 -0400
Date: Fri, 8 Aug 2014 20:57:47 +0200
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
Subject: [RFC PATCH 1/5] proc: intoduce proc_inode->pid_entry and
	is_tgid_pid_entry()
Message-ID: <20140808185747.GA774@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808185732.GA760@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new "struct pid_entry *" member into struct proc_inode, and
the new helper, is_tgid_pid_entry(), it can be used by *base_stuff
to figure out whether we need tgid or tid info.

Note: this obviously blows struct proc_inode, but I think it is
simple to put ->fd, ->sysctl/sysctl_entry, and the new member in
the union, the only complication is that proc_evict_inode() should
be carefull with ->sysctl.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c     |   16 +++++++++++++++-
 fs/proc/inode.c    |    1 +
 fs/proc/internal.h |    4 ++++
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9aef9ac..ea11bf1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2124,6 +2124,9 @@ static int proc_pident_instantiate(struct inode *dir,
 		goto out;
 
 	ei = PROC_I(inode);
+	ei->pid_entry = p;
+	ei->op = p->op;
+
 	inode->i_mode = p->mode;
 	if (S_ISDIR(inode->i_mode))
 		set_nlink(inode, 2);	/* Use getattr to fix if necessary */
@@ -2131,7 +2134,7 @@ static int proc_pident_instantiate(struct inode *dir,
 		inode->i_op = p->iop;
 	if (p->fop)
 		inode->i_fop = p->fop;
-	ei->op = p->op;
+
 	d_set_d_op(dentry, &pid_dentry_operations);
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
@@ -2978,6 +2981,17 @@ static const struct pid_entry tid_base_stuff[] = {
 #endif
 };
 
+bool is_tgid_pid_entry(const struct pid_entry *p)
+{
+	if (p >= tgid_base_stuff &&
+	    p <  tgid_base_stuff + ARRAY_SIZE(tgid_base_stuff))
+		return true;
+	if (p >= tid_base_stuff &&
+	    p <  tid_base_stuff + ARRAY_SIZE(tid_base_stuff))
+		return false;
+	BUG();
+}
+
 static int proc_tid_base_readdir(struct file *file, struct dir_context *ctx)
 {
 	return proc_pident_readdir(file, ctx,
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 0adbc02..45ad621 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -73,6 +73,7 @@ static struct inode *proc_alloc_inode(struct super_block *sb)
 	ei->pde = NULL;
 	ei->sysctl = NULL;
 	ei->sysctl_entry = NULL;
+	ei->pid_entry = NULL;
 	ei->ns.ns = NULL;
 	ei->ns.ns_ops = NULL;
 	inode = &ei->vfs_inode;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 78784cd..2e310b6 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -15,6 +15,7 @@
 #include <linux/atomic.h>
 #include <linux/binfmts.h>
 
+struct pid_entry;
 struct ctl_table_header;
 struct mempolicy;
 
@@ -65,6 +66,7 @@ struct proc_inode {
 	struct proc_dir_entry *pde;
 	struct ctl_table_header *sysctl;
 	struct ctl_table *sysctl_entry;
+	const struct pid_entry *pid_entry;
 	struct proc_ns ns;
 	struct inode vfs_inode;
 };
@@ -147,6 +149,8 @@ out:
  */
 extern const struct file_operations proc_tid_children_operations;
 
+extern bool is_tgid_pid_entry(const struct pid_entry *p);
+
 extern int proc_tid_stat(struct seq_file *, struct pid_namespace *,
 			 struct pid *, struct task_struct *);
 extern int proc_tgid_stat(struct seq_file *, struct pid_namespace *,
-- 
1.5.5.1

