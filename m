Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaKKLyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:54:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57386 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaKKLJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 059/170] be careful with nd->inode in path_init() and follow_dotdot_rcu()
Date: Tue, 11 Nov 2014 11:06:58 +0000
Message-Id: <1415704129-12709-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 4023bfc9f351a7994fb6a7d515476c320f94a574 upstream.

in the former we simply check if dentry is still valid after picking
its ->d_inode; in the latter we fetch ->d_inode in the same places
where we fetch dentry and its ->d_seq, under the same checks.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/namei.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d4ca42085e1d..8a3bdeae730c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1135,6 +1135,7 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 
 static int follow_dotdot_rcu(struct nameidata *nd)
 {
+	struct inode *inode = nd->inode;
 	if (!nd->root.mnt)
 		set_root_rcu(nd);
 
@@ -1148,6 +1149,7 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 			struct dentry *parent = old->d_parent;
 			unsigned seq;
 
+			inode = parent->d_inode;
 			seq = read_seqcount_begin(&parent->d_seq);
 			if (read_seqcount_retry(&old->d_seq, nd->seq))
 				goto failed;
@@ -1157,6 +1159,7 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 		}
 		if (!follow_up_rcu(&nd->path))
 			break;
+		inode = nd->path.dentry->d_inode;
 		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
 	}
 	while (d_mountpoint(nd->path.dentry)) {
@@ -1166,11 +1169,12 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 			break;
 		nd->path.mnt = &mounted->mnt;
 		nd->path.dentry = mounted->mnt.mnt_root;
+		inode = nd->path.dentry->d_inode;
 		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
 		if (!read_seqretry(&mount_lock, nd->m_seq))
 			goto failed;
 	}
-	nd->inode = nd->path.dentry->d_inode;
+	nd->inode = inode;
 	return 0;
 
 failed:
@@ -1899,7 +1903,14 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 	}
 
 	nd->inode = nd->path.dentry->d_inode;
-	return 0;
+	if (!(flags & LOOKUP_RCU))
+		return 0;
+	if (likely(!read_seqcount_retry(&nd->path.dentry->d_seq, nd->seq)))
+		return 0;
+	if (!(nd->flags & LOOKUP_ROOT))
+		nd->root.mnt = NULL;
+	rcu_read_unlock();
+	return -ECHILD;
 }
 
 static inline int lookup_last(struct nameidata *nd, struct path *path)
-- 
2.1.0

