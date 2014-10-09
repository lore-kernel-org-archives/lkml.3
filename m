Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbaJIVSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:18:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59638 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897AbaJIVLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 068/163] be careful with nd->inode in path_init() and follow_dotdot_rcu()
Date: Thu,  9 Oct 2014 14:01:33 -0700
Message-Id: <1412888588-26755-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 4023bfc9f351a7994fb6a7d515476c320f94a574 upstream.

in the former we simply check if dentry is still valid after picking
its ->d_inode; in the latter we fetch ->d_inode in the same places
where we fetch dentry and its ->d_seq, under the same checks.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/namei.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index aed3458..eaabb52 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1119,6 +1119,7 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 
 static int follow_dotdot_rcu(struct nameidata *nd)
 {
+	struct inode *inode = nd->inode;
 	if (!nd->root.mnt)
 		set_root_rcu(nd);
 
@@ -1132,6 +1133,7 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 			struct dentry *parent = old->d_parent;
 			unsigned seq;
 
+			inode = parent->d_inode;
 			seq = read_seqcount_begin(&parent->d_seq);
 			if (read_seqcount_retry(&old->d_seq, nd->seq))
 				goto failed;
@@ -1141,6 +1143,7 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 		}
 		if (!follow_up_rcu(&nd->path))
 			break;
+		inode = nd->path.dentry->d_inode;
 		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
 	}
 	while (d_mountpoint(nd->path.dentry)) {
@@ -1150,11 +1153,12 @@ static int follow_dotdot_rcu(struct nameidata *nd)
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
@@ -1883,7 +1887,14 @@ static int path_init(int dfd, const char *name, unsigned int flags,
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
1.9.1

