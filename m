Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaKAWxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:53:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60149 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbaKAWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:28 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.665075121@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 051/102] vfs: Fold follow_mount_rcu() into
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

From: Ben Hutchings <ben@decadent.org.uk>

This is needed before commit 4023bfc9f351 ('be careful with nd->inode
in path_init() and follow_dotdot_rcu()').  A similar change was made
upstream as part of commit b37199e626b3 ('rcuwalk: recheck mount_lock
after mountpoint crossing attempts').

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -911,19 +911,6 @@ static bool __follow_mount_rcu(struct na
 	return true;
 }
 
-static void follow_mount_rcu(struct nameidata *nd)
-{
-	while (d_mountpoint(nd->path.dentry)) {
-		struct vfsmount *mounted;
-		mounted = __lookup_mnt(nd->path.mnt, nd->path.dentry, 1);
-		if (!mounted)
-			break;
-		nd->path.mnt = mounted;
-		nd->path.dentry = mounted->mnt_root;
-		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
-	}
-}
-
 static int follow_dotdot_rcu(struct nameidata *nd)
 {
 	if (!nd->root.mnt)
@@ -950,7 +937,15 @@ static int follow_dotdot_rcu(struct name
 			break;
 		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
 	}
-	follow_mount_rcu(nd);
+	while (d_mountpoint(nd->path.dentry)) {
+		struct vfsmount *mounted;
+		mounted = __lookup_mnt(nd->path.mnt, nd->path.dentry, 1);
+		if (!mounted)
+			break;
+		nd->path.mnt = mounted;
+		nd->path.dentry = mounted->mnt_root;
+		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
+	}
 	nd->inode = nd->path.dentry->d_inode;
 	return 0;
 

