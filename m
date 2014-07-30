Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaG3Mnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:43:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36641 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbaG3MP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 17/94] fuse: timeout comparison fix
Date: Wed, 30 Jul 2014 14:14:06 +0200
Message-Id: <de6ab0e76a6d64e74128ee1286fec58da49268a0.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 126b9d4365b110c157bc4cbc32540dfa66c9c85a upstream.

As suggested by checkpatch.pl, use time_before64() instead of direct
comparison of jiffies64 values.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/fuse/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b7989f2ab4c4..0afbf93f5935 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -188,7 +188,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	inode = ACCESS_ONCE(entry->d_inode);
 	if (inode && is_bad_inode(inode))
 		goto invalid;
-	else if (fuse_dentry_time(entry) < get_jiffies_64()) {
+	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64())) {
 		int err;
 		struct fuse_entry_out outarg;
 		struct fuse_req *req;
@@ -945,7 +945,7 @@ int fuse_update_attributes(struct inode *inode, struct kstat *stat,
 	int err;
 	bool r;
 
-	if (fi->i_time < get_jiffies_64()) {
+	if (time_before64(fi->i_time, get_jiffies_64())) {
 		r = true;
 		err = fuse_do_getattr(inode, stat, file);
 	} else {
@@ -1131,7 +1131,7 @@ static int fuse_permission(struct inode *inode, int mask)
 	    ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))) {
 		struct fuse_inode *fi = get_fuse_inode(inode);
 
-		if (fi->i_time < get_jiffies_64()) {
+		if (time_before64(fi->i_time, get_jiffies_64())) {
 			refreshed = true;
 
 			err = fuse_perm_getattr(inode, mask);
-- 
2.0.1

