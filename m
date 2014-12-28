Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaL1Uua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 15:50:30 -0500
Received: from mout.web.de ([212.227.15.14]:50944 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaL1Uu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 15:50:27 -0500
Message-ID: <54A06D0A.6050706@users.sourceforge.net>
Date: Sun, 28 Dec 2014 21:50:18 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 8/8] fs/9p: Less function calls in v9fs_vfs_mknod_dotl() after
 error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A01326.3050306@users.sourceforge.net>
In-Reply-To: <54A01326.3050306@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:W8OSQMf3uBlY0iX6LD2OEnewhniWhR4d+A7/IPA0geCOSECgzuU
 KQHX9FbSaw12WnTxKkXghOCM203+CsBLD015REHiUQu38zvaRUCMIYx5i7DQHmFQr/cTe39
 uncN99PT/rK2Sve9ohnkjgju+/lOBARO6UgxZaGEXrHjrLFh/3lDRZE4jPOteAgicSaTg1j
 E4dtpvQdpsEh6jxvw7i5w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 28 Dec 2014 13:36:28 +0100

The p9_client_clunk() function was called in four cases by the
v9fs_vfs_mknod_dotl() function during error handling even if the passed
variable "fid" contained a null pointer. The v9fs_put_acl() function could
also be unnecessarily called with null pointers.

* This implementation detail could be improved by the introduction of
  two jump labels.

* Let us delete also two unnecessary variable assignments there.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/9p/vfs_inode_dotl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 3b38dda..ff3c26a 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -832,8 +832,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	if (IS_ERR(dfid)) {
 		err = PTR_ERR(dfid);
 		p9_debug(P9_DEBUG_VFS, "fid lookup failed %d\n", err);
-		dfid = NULL;
-		goto error;
+		goto exit;
 	}
 
 	gid = v9fs_get_fsgid_for_create(dir);
@@ -843,13 +842,13 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	if (err) {
 		p9_debug(P9_DEBUG_VFS, "Failed to get acl values in mknod %d\n",
 			 err);
-		goto error;
+		goto exit;
 	}
 	name = (char *) dentry->d_name.name;
 
 	err = p9_client_mknod_dotl(dfid, name, mode, rdev, gid, &qid);
 	if (err < 0)
-		goto error;
+		goto put_acl;
 
 	v9fs_invalidate_inode_attr(dir);
 	fid = p9_client_walk(dfid, 1, &name, 1);
@@ -857,8 +856,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 		err = PTR_ERR(fid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n",
 			 err);
-		fid = NULL;
-		goto error;
+		goto put_acl;
 	}
 
 	/* instantiate inode and assign the unopened fid to the dentry */
@@ -890,7 +888,9 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 	}
 error:
 	p9_client_clunk(fid);
+put_acl:
 	v9fs_put_acl(dacl, pacl);
+exit:
 	return err;
 }
 
-- 
2.2.1

