Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934876Ab3IDOHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:07:45 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36817 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab3IDOF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:05:57 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk
Cc: bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        raven@themaw.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz
Subject: [PATCH 09/10] fuse: clean up return in fuse_dentry_revalidate()
Date: Wed,  4 Sep 2013 16:05:55 +0200
Message-Id: <1378303556-7220-10-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
References: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
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

