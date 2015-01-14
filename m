Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbbANJcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:32:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbbANJcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:32:45 -0500
Subject: [RFC PATCH 1/5] nsproxy - refactor setns()
From: Ian Kent <ikent@redhat.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Oleg Nesterov <onestero@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jeff Layton <jeff.layton@primarydata.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 14 Jan 2015 17:32:29 +0800
Message-ID: <20150114093228.30252.30091.stgit@pluto.fritz.box>
In-Reply-To: <20150114092704.30252.60446.stgit@pluto.fritz.box>
References: <20150114092704.30252.60446.stgit@pluto.fritz.box>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For usermode helpers to execute within a namspace a slightly different
entry point to setns() that takes a namspace inode is needed.

Signed-off-by: Ian Kent <ikent@redhat.com>
Cc: Benjamin Coddington <bcodding@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Oleg Nesterov <onestero@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jeff Layton <jeff.layton@primarydata.com>
---
 include/linux/nsproxy.h |    1 +
 kernel/nsproxy.c        |   21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index 35fa08f..c75bf12 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -62,6 +62,7 @@ extern struct nsproxy init_nsproxy;
  *
  */
 
+int setns_inode(struct inode *inode, int nstype);
 int copy_namespaces(unsigned long flags, struct task_struct *tsk);
 void exit_task_namespaces(struct task_struct *tsk);
 void switch_task_namespaces(struct task_struct *tsk, struct nsproxy *new);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 49746c8..27cc544 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -218,20 +218,15 @@ void exit_task_namespaces(struct task_struct *p)
 	switch_task_namespaces(p, NULL);
 }
 
-SYSCALL_DEFINE2(setns, int, fd, int, nstype)
+int setns_inode(struct inode *inode, int nstype)
 {
 	struct task_struct *tsk = current;
 	struct nsproxy *new_nsproxy;
-	struct file *file;
 	struct ns_common *ns;
 	int err;
 
-	file = proc_ns_fget(fd);
-	if (IS_ERR(file))
-		return PTR_ERR(file);
-
 	err = -EINVAL;
-	ns = get_proc_ns(file_inode(file));
+	ns = get_proc_ns(inode);
 	if (nstype && (ns->ops->type != nstype))
 		goto out;
 
@@ -248,6 +243,18 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
 	}
 	switch_task_namespaces(tsk, new_nsproxy);
 out:
+	return err;
+}
+
+SYSCALL_DEFINE2(setns, int, fd, int, nstype)
+{
+	struct file *file;
+	int err;
+
+	file = proc_ns_fget(fd);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+	err = setns_inode(file_inode(file), nstype);
 	fput(file);
 	return err;
 }

