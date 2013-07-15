Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab3GONKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:10:32 -0400
Received: from teakhout.nixpanic.net ([83.161.152.167]:41767 "EHLO
	ndevos-laptop.usersys.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756078Ab3GONKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:10:31 -0400
X-Greylist: delayed 650 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2013 09:10:31 EDT
From: Niels de Vos <ndevos@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Niels de Vos <ndevos@redhat.com>
Subject: [PATCH] fuse: fix occasional dentry leak when readdirplus is used
Date: Mon, 15 Jul 2013 14:59:20 +0200
Message-Id: <1373893160-30601-1-git-send-email-ndevos@redhat.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case d_lookup() returns a dentry with d_inode == NULL, the dentry is
not returned with dput(). This results in triggering a BUG() in
shrink_dcache_for_umount_subtree():

  BUG: Dentry ...{i=0,n=...} still in use (1) [unmount of fuse fuse]

Reported-by: Justin Clift <jclift@redhat.com>
Signed-off-by: Niels de Vos <ndevos@redhat.com>

--
Reproducing the BUG() on kernels with fuse that support READDIRPLUS can
be done with the GlusterFS tests:
- http://www.gluster.org/community/documentation/index.php/Using_the_Gluster_Test_Framework

After some stressing of the VFS and fuse mountpoints, bug-860663.t will
hit the BUG(). It does not happen on running this test stand-alone.
---
 fs/fuse/dir.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 0eda527..da67a15 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1246,7 +1246,9 @@ static int fuse_direntplus_link(struct file *file,
 		if (err)
 			goto out;
 		dput(dentry);
-		dentry = NULL;
+	} else if (dentry) {
+		/* this dentry does not have a d_inode, just drop it */
+		dput(dentry);
 	}
 
 	dentry = d_alloc(parent, &name);
-- 
1.7.1

