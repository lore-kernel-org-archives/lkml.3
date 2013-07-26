Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab3GZVbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:31:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759984Ab3GZUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Justin Clift <jclift@redhat.com>, Niels de Vos <ndevos@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Brian Foster <bfoster@redhat.com>
Subject: [ 45/79] fuse: readdirplus: fix dentry leak
Date: Fri, 26 Jul 2013 13:47:35 -0700
Message-Id: <20130726204727.213036505@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niels de Vos <ndevos@redhat.com>

commit 53ce9a3364de0723b27d861de93bfc882f7db050 upstream.

In case d_lookup() returns a dentry with d_inode == NULL, the dentry is not
returned with dput(). This results in triggering a BUG() in
shrink_dcache_for_umount_subtree():

  BUG: Dentry ...{i=0,n=...} still in use (1) [unmount of fuse fuse]

[SzM: need to d_drop() as well]

Reported-by: Justin Clift <jclift@redhat.com>
Signed-off-by: Niels de Vos <ndevos@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Tested-by: Brian Foster <bfoster@redhat.com>
Tested-by: Niels de Vos <ndevos@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1229,9 +1229,15 @@ static int fuse_direntplus_link(struct f
 
 	name.hash = full_name_hash(name.name, name.len);
 	dentry = d_lookup(parent, &name);
-	if (dentry && dentry->d_inode) {
+	if (dentry) {
 		inode = dentry->d_inode;
-		if (get_node_id(inode) == o->nodeid) {
+		if (!inode) {
+			d_drop(dentry);
+		} else if (get_node_id(inode) != o->nodeid) {
+			err = d_invalidate(dentry);
+			if (err)
+				goto out;
+		} else {
 			struct fuse_inode *fi;
 			fi = get_fuse_inode(inode);
 			spin_lock(&fc->lock);
@@ -1244,9 +1250,6 @@ static int fuse_direntplus_link(struct f
 			 */
 			goto found;
 		}
-		err = d_invalidate(dentry);
-		if (err)
-			goto out;
 		dput(dentry);
 		dentry = NULL;
 	}


