Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3AVRET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:04:19 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:7524 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab3AVRER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:04:17 -0500
Subject: [PATCH] proc: avoid extra pde_put() in proc_fill_super()
To: ebiederm@xmission.com
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, fengguang.wu@intel.com, devel@openvz.org
Date: Tue, 22 Jan 2013 21:03:26 +0400
Message-ID: <20130122170100.11323.13045.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If proc_get_inode() succeeded, but d_make_root() failed, pde_put() for
proc_root will be called twice: the first time due to iput() called from
d_make_root() and the second time directly in the end of proc_fill_super().

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/proc/inode.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 439ae688..c7f8b24 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -486,6 +486,8 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 
 int proc_fill_super(struct super_block *s)
 {
+	struct inode *root_inode;
+
 	s->s_flags |= MS_NODIRATIME | MS_NOSUID | MS_NOEXEC;
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
@@ -494,11 +496,18 @@ int proc_fill_super(struct super_block *s)
 	s->s_time_gran = 1;
 	
 	pde_get(&proc_root);
-	s->s_root = d_make_root(proc_get_inode(s, &proc_root));
-	if (s->s_root)
-		return 0;
+	root_inode = proc_get_inode(s, &proc_root);
+	if (!root_inode) {
+		printk(KERN_ERR "proc_fill_super: get root inode failed\n");
+		pde_put(&proc_root);
+		return -ENOMEM;
+	}
 
-	printk("proc_read_super: get root inode failed\n");
-	pde_put(&proc_root);
-	return -ENOMEM;
+	s->s_root = d_make_root(root_inode);
+	if (!s->s_root) {
+		printk(KERN_ERR "proc_fill_super: allocate dentry failed\n");
+		return -ENOMEM;
+	}
+
+	return 0;
 }

