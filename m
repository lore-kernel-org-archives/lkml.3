Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaL1Usm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 15:48:42 -0500
Received: from mout.web.de ([212.227.15.4]:59360 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaL1Usk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 15:48:40 -0500
Message-ID: <54A06C9B.7050109@users.sourceforge.net>
Date: Sun, 28 Dec 2014 21:48:27 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 7/8] fs/9p: One function call less in v9fs_vfs_symlink_dotl()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A01326.3050306@users.sourceforge.net>
In-Reply-To: <54A01326.3050306@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:HWKlTzCFKg8kUjlzT6RW3Xc4rgLREZzKwf1tgNvVD/sdVPEznE8
 eZ3L28ud8bq31Ux6RtjG0vEdesXWyS1qRkGMaV8gxXZa3gK1Jy2g69c+utoJsaxVBCJI/wC
 Vrr8pwZ6+qQCrUEPIXQIUHgUJ7LG6Mg2yz9MKRqPRCkiQMAYAIoK25/6TdAPzSVWYtL2LCo
 BfjpPDKkCnpzVixq7JQxw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 28 Dec 2014 13:00:54 +0100

The p9_client_clunk() function was called in two cases by the
v9fs_vfs_symlink_dotl() function during error handling even if the passed
variable "fid" contained a null pointer.

* This implementation detail could be improved by the introduction of another
  jump label.

* Let us delete also an unnecessary variable assignment there.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/9p/vfs_inode_dotl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 672d84f..3b38dda 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -701,7 +701,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 
 	if (err < 0) {
 		p9_debug(P9_DEBUG_VFS, "p9_client_symlink failed %d\n", err);
-		goto error;
+		goto exit;
 	}
 
 	v9fs_invalidate_inode_attr(dir);
@@ -712,8 +712,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 			err = PTR_ERR(fid);
 			p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n",
 				 err);
-			fid = NULL;
-			goto error;
+			goto exit;
 		}
 
 		/* instantiate inode and assign the unopened fid to dentry */
@@ -740,7 +739,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 
 error:
 	p9_client_clunk(fid);
-
+exit:
 	return err;
 }
 
-- 
2.2.1

