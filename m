Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaKAWxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:53:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60135 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbaKAWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:28 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Al Viro" <viro@zeniv.linux.org.uk>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.460771772@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 052/102] be careful with nd->inode in path_init() and
 follow_dotdot_rcu()
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 4023bfc9f351a7994fb6a7d515476c320f94a574 upstream.

in the former we simply check if dentry is still valid after picking
its ->d_inode; in the latter we fetch ->d_inode in the same places
where we fetch dentry and its ->d_seq, under the same checks.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/namei.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -913,6 +913,7 @@ static bool __follow_mount_rcu(struct na
 
 static int follow_dotdot_rcu(struct nameidata *nd)
 {
+	struct inode *inode = nd->inode;
 	if (!nd->root.mnt)
 		set_root_rcu(nd);
 
@@ -926,6 +927,7 @@ static int follow_dotdot_rcu(struct name
 			struct dentry *parent = old->d_parent;
 			unsigned seq;
 
+			inode = parent->d_inode;
 			seq = read_seqcount_begin(&parent->d_seq);
 			if (read_seqcount_retry(&old->d_seq, nd->seq))
 				goto failed;
@@ -935,6 +937,7 @@ static int follow_dotdot_rcu(struct name
 		}
 		if (!follow_up_rcu(&nd->path))
 			break;
+		inode = nd->path.dentry->d_inode;
 		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
 	}
 	while (d_mountpoint(nd->path.dentry)) {
@@ -944,9 +947,10 @@ static int follow_dotdot_rcu(struct name
 			break;
 		nd->path.mnt = mounted;
 		nd->path.dentry = mounted->mnt_root;
+		inode = nd->path.dentry->d_inode;
 		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
 	}
-	nd->inode = nd->path.dentry->d_inode;
+	nd->inode = inode;
 	return 0;
 
 failed:
@@ -1556,7 +1560,14 @@ static int path_init(int dfd, const char
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
 
 fput_fail:
 	fput_light(file, fput_needed);

