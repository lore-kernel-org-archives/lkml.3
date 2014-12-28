Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaL1Urb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 15:47:31 -0500
Received: from mout.web.de ([212.227.17.12]:61392 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaL1Ur2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 15:47:28 -0500
Message-ID: <54A06C55.7060409@users.sourceforge.net>
Date: Sun, 28 Dec 2014 21:47:17 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 6/8] fs/9p: Less function calls in v9fs_vfs_mkdir_dotl() after
 error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A01326.3050306@users.sourceforge.net>
In-Reply-To: <54A01326.3050306@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Y26laGP6QGg3epYjhqO81MGpsbnwot7ifo3TLCWNdXpYQTwwsOc
 WIuL46/2BZ7EFiqTbc4/oUrjKpduFUg+NjNrmPxqnMAq55+seXY4+FF2RCmPm/q5nlHzwSg
 nYlbOkSDvgQkzaVtUpfieHCxgORnCqTDw1DfbAs5Wx52g3mG6lQLCBnWcNKzK11WQFFI+kH
 Zgl7ZRXK0kTvbr/QGa1Mw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 28 Dec 2014 12:44:22 +0100

The p9_client_clunk() function was called in some cases by the
v9fs_vfs_mkdir_dotl() function during error handling even if the passed
variable "fid" contained a null pointer.

* Corresponding details could be improved by the introduction of another
  jump label.

* Let us delete also two unnecessary variable assignments there.

* Return from this implementation directly after failure detection for
  the function calls "v9fs_fid_lookup" and "v9fs_acl_mode".

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/9p/vfs_inode_dotl.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index ce1f5bb..672d84f 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -403,8 +403,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 	if (IS_ERR(dfid)) {
 		err = PTR_ERR(dfid);
 		p9_debug(P9_DEBUG_VFS, "fid lookup failed %d\n", err);
-		dfid = NULL;
-		goto error;
+		return err;
 	}
 
 	gid = v9fs_get_fsgid_for_create(dir);
@@ -414,20 +413,19 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 	if (err) {
 		p9_debug(P9_DEBUG_VFS, "Failed to get acl values in mkdir %d\n",
 			 err);
-		goto error;
+		return err;
 	}
 	name = (char *) dentry->d_name.name;
 	err = p9_client_mkdir_dotl(dfid, name, mode, gid, &qid);
 	if (err < 0)
-		goto error;
+		goto put_acl;
 
 	fid = p9_client_walk(dfid, 1, &name, 1);
 	if (IS_ERR(fid)) {
 		err = PTR_ERR(fid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n",
 			 err);
-		fid = NULL;
-		goto error;
+		goto put_acl;
 	}
 
 	/* instantiate inode and assign the unopened fid to the dentry */
@@ -462,6 +460,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 	v9fs_invalidate_inode_attr(dir);
 error:
 	p9_client_clunk(fid);
+put_acl:
 	v9fs_put_acl(dacl, pacl);
 	return err;
 }
-- 
2.2.1

