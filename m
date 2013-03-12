Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab3CLPoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:44:01 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:56019 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934Ab3CLPmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:42:40 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz,
        Robin Dong <hao.bigrat@gmail.com>, Robin Dong <sanbai@taobao.com>
Subject: [PATCH 10/13] overlayfs-create-new-inode-in-ovl_link
Date: Tue, 12 Mar 2013 16:41:45 +0100
Message-Id: <1363102908-28956-11-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Dong <hao.bigrat@gmail.com>

Imaging using ext4 as upperdir which has a file "hello" and lowdir is
totally empty.

1. mount -t overlayfs overlayfs -o lowerdir=/lower,upperdir=/upper /overlay
2. cd /overlay
3. ln hello bye

then the overlayfs code will call vfs_link to create a real ext4
dentry for "bye" and create
a new overlayfs dentry point to overlayfs inode (which standed for
"hello"). That means:
	two overlayfs dentries and only one overlayfs inode.

and then

4. umount /overlay
5. mount -t overlayfs overlayfs -o lowerdir=/lower,upperdir=/upper
/overlay (again)
6. cd /overlay
7. ls hello bye

the overlayfs will create two inodes(one for the "hello", another
for the "bye") and two dentries (each point a inode).That means:
	two dentries and two inodes.

As above, with different order of "create link" and "mount", the
result is not the same.

In order to make the behavior coherent, we need to create inode in ovl_link.

Signed-off-by: Robin Dong <sanbai@taobao.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/dir.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 6fc5aa5..d8f6ee0 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -417,6 +417,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	struct dentry *olddentry;
 	struct dentry *newdentry;
 	struct dentry *upperdir;
+	struct inode *newinode;
 
 	err = ovl_copy_up(old);
 	if (err)
@@ -441,13 +442,17 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 			err = -ENOENT;
 			goto out_unlock;
 		}
+		newinode = ovl_new_inode(old->d_sb, newdentry->d_inode->i_mode,
+				new->d_fsdata);
+		if (!newinode)
+			goto link_fail;
 
 		ovl_dentry_version_inc(new->d_parent);
 		ovl_dentry_update(new, newdentry);
 
-		ihold(old->d_inode);
-		d_instantiate(new, old->d_inode);
+		d_instantiate(new, newinode);
 	} else {
+link_fail:
 		if (ovl_dentry_is_opaque(new))
 			ovl_whiteout(upperdir, new);
 		dput(newdentry);
-- 
1.7.10.4

