Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675Ab3GZVax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:30:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759921Ab3GZUsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 47/79] fuse: readdirplus: sanity checks
Date: Fri, 26 Jul 2013 13:47:37 -0700
Message-Id: <20130726204727.416142495@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit a28ef45cbb1e7fadd5159deb17b02de15c6e4aaf upstream.

Add sanity checks before adding or updating an entry with data received
from readdirplus.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1225,6 +1225,12 @@ static int fuse_direntplus_link(struct f
 		if (name.name[1] == '.' && name.len == 2)
 			return 0;
 	}
+
+	if (invalid_nodeid(o->nodeid))
+		return -EIO;
+	if (!fuse_valid_type(o->attr.mode))
+		return -EIO;
+
 	fc = get_fuse_conn(dir);
 
 	name.hash = full_name_hash(name.name, name.len);
@@ -1233,10 +1239,14 @@ static int fuse_direntplus_link(struct f
 		inode = dentry->d_inode;
 		if (!inode) {
 			d_drop(dentry);
-		} else if (get_node_id(inode) != o->nodeid) {
+		} else if (get_node_id(inode) != o->nodeid ||
+			   ((o->attr.mode ^ inode->i_mode) & S_IFMT)) {
 			err = d_invalidate(dentry);
 			if (err)
 				goto out;
+		} else if (is_bad_inode(inode)) {
+			err = -EIO;
+			goto out;
 		} else {
 			struct fuse_inode *fi;
 			fi = get_fuse_inode(inode);


