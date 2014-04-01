Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaDAEKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:10:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaDAEKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:10:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.13 02/22] rcuwalk: recheck mount_lock after mountpoint crossing attempts
Date: Mon, 31 Mar 2014 21:08:32 -0700
Message-Id: <20140401040703.502846264@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140401040703.045139933@linuxfoundation.org>
References: <20140401040703.045139933@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit b37199e626b31e1175fb06764c5d1d687723aac2 upstream.

We can get false negative from __lookup_mnt() if an unrelated vfsmount
gets moved.  In that case legitimize_mnt() is guaranteed to fail,
and we will fall back to non-RCU walk... unless we end up running
into a hard error on a filesystem object we wouldn't have reached
if not for that false negative.  IOW, delaying that check until
the end of pathname resolution is wrong - we should recheck right
after we attempt to cross the mountpoint.  We don't need to recheck
unless we see d_mountpoint() being true - in that case even if
we have just raced with mount/umount, we can simply go on as if
we'd come at the moment when the sucker wasn't a mountpoint; if we
run into a hard error as the result, it was a legitimate outcome.
__lookup_mnt() returning NULL is different in that respect, since
it might've happened due to operation on completely unrelated
mountpoint.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1098,7 +1098,7 @@ static bool __follow_mount_rcu(struct na
 			return false;
 
 		if (!d_mountpoint(path->dentry))
-			break;
+			return true;
 
 		mounted = __lookup_mnt(path->mnt, path->dentry);
 		if (!mounted)
@@ -1114,20 +1114,7 @@ static bool __follow_mount_rcu(struct na
 		 */
 		*inode = path->dentry->d_inode;
 	}
-	return true;
-}
-
-static void follow_mount_rcu(struct nameidata *nd)
-{
-	while (d_mountpoint(nd->path.dentry)) {
-		struct mount *mounted;
-		mounted = __lookup_mnt(nd->path.mnt, nd->path.dentry);
-		if (!mounted)
-			break;
-		nd->path.mnt = &mounted->mnt;
-		nd->path.dentry = mounted->mnt.mnt_root;
-		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
-	}
+	return read_seqretry(&mount_lock, nd->m_seq);
 }
 
 static int follow_dotdot_rcu(struct nameidata *nd)
@@ -1155,7 +1142,17 @@ static int follow_dotdot_rcu(struct name
 			break;
 		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
 	}
-	follow_mount_rcu(nd);
+	while (d_mountpoint(nd->path.dentry)) {
+		struct mount *mounted;
+		mounted = __lookup_mnt(nd->path.mnt, nd->path.dentry);
+		if (!mounted)
+			break;
+		nd->path.mnt = &mounted->mnt;
+		nd->path.dentry = mounted->mnt.mnt_root;
+		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
+		if (!read_seqretry(&mount_lock, nd->m_seq))
+			goto failed;
+	}
 	nd->inode = nd->path.dentry->d_inode;
 	return 0;
 


