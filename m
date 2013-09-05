Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935681Ab3IEJpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:45:52 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:52367 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935617Ab3IEJo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:44:59 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 10/11] fuse: clean up return in fuse_dentry_revalidate()
Date: Thu,  5 Sep 2013 11:44:43 +0200
Message-Id: <1378374284-1484-11-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

On errors unrelated to the filesystem's state (ENOMEM, ENOTCONN) return the
error itself from ->d_revalidate() insted of returning zero (invalid).

Also make a common label for invalidating the dentry.  This will be used by
the next patch.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dir.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 131d14b..25c6cfe 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -182,10 +182,11 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	struct inode *inode;
 	struct dentry *parent;
 	struct fuse_conn *fc;
+	int ret;
 
 	inode = ACCESS_ONCE(entry->d_inode);
 	if (inode && is_bad_inode(inode))
-		return 0;
+		goto invalid;
 	else if (fuse_dentry_time(entry) < get_jiffies_64()) {
 		int err;
 		struct fuse_entry_out outarg;
@@ -195,20 +196,23 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 
 		/* For negative dentries, always do a fresh lookup */
 		if (!inode)
-			return 0;
+			goto invalid;
 
+		ret = -ECHILD;
 		if (flags & LOOKUP_RCU)
-			return -ECHILD;
+			goto out;
 
 		fc = get_fuse_conn(inode);
 		req = fuse_get_req_nopages(fc);
+		ret = PTR_ERR(req);
 		if (IS_ERR(req))
-			return 0;
+			goto out;
 
 		forget = fuse_alloc_forget();
 		if (!forget) {
 			fuse_put_request(fc, req);
-			return 0;
+			ret = -ENOMEM;
+			goto out;
 		}
 
 		attr_version = fuse_get_attr_version(fc);
@@ -227,7 +231,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 			struct fuse_inode *fi = get_fuse_inode(inode);
 			if (outarg.nodeid != get_node_id(inode)) {
 				fuse_queue_forget(fc, forget, outarg.nodeid, 1);
-				return 0;
+				goto invalid;
 			}
 			spin_lock(&fc->lock);
 			fi->nlookup++;
@@ -235,7 +239,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 		}
 		kfree(forget);
 		if (err || (outarg.attr.mode ^ inode->i_mode) & S_IFMT)
-			return 0;
+			goto invalid;
 
 		fuse_change_attributes(inode, &outarg.attr,
 				       entry_attr_timeout(&outarg),
@@ -249,7 +253,13 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 			dput(parent);
 		}
 	}
-	return 1;
+	ret = 1;
+out:
+	return ret;
+
+invalid:
+	ret = 0;
+	goto out;
 }
 
 static int invalid_nodeid(u64 nodeid)
-- 
1.8.1.4

