Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaKPWBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:01:11 -0500
Received: from 1wt.eu ([62.212.114.60]:47948 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbaKPWBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:01:04 -0500
Message-Id: <20141116215328.898179262@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:34 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 06/48] fix autofs/afs/etc. magic mountpoint breakage
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

We end up trying to kfree() nd.last.name on open("/mnt/tmp", O_CREAT)
if /mnt/tmp is an autofs direct mount.  The reason is that nd.last_type
is bogus here; we want LAST_BIND for everything of that kind and we
get LAST_NORM left over from finding parent directory.

So make sure that it *is* set properly; set to LAST_BIND before
doing ->follow_link() - for normal symlinks it will be changed
by __vfs_follow_link() and everything else needs it set that way.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
(cherry picked from commit 86acdca1b63e6890540fa19495cfc708beff3d8b)
[wt: fixes CVE-2014-0203]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/namei.c     | 1 +
 fs/proc/base.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index b0afbd4..0d766d2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -635,6 +635,7 @@ static __always_inline int __do_follow_link(struct path *path, struct nameidata
 		dget(dentry);
 	}
 	mntget(path->mnt);
+	nd->last_type = LAST_BIND;
 	cookie = dentry->d_inode->i_op->follow_link(dentry, nd);
 	error = PTR_ERR(cookie);
 	if (!IS_ERR(cookie)) {
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 67f7dc0..c75c5cd 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1381,7 +1381,6 @@ static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 		goto out;
 
 	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path);
-	nd->last_type = LAST_BIND;
 out:
 	return ERR_PTR(error);
 }
-- 
1.7.12.2.21.g234cd45.dirty



