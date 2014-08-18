Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaHRJdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:33:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42410 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaHRJde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miklos Szeredi <mszeredi@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 006/137] fuse: timeout comparison fix
Date: Mon, 18 Aug 2014 10:31:07 +0100
Message-Id: <1408354398-10226-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 126b9d4365b110c157bc4cbc32540dfa66c9c85a upstream.

As suggested by checkpatch.pl, use time_before64() instead of direct
comparison of jiffies64 values.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/fuse/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 8fec28ff4a0d..ac00468b93d5 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -186,7 +186,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	inode = ACCESS_ONCE(entry->d_inode);
 	if (inode && is_bad_inode(inode))
 		return 0;
-	else if (fuse_dentry_time(entry) < get_jiffies_64()) {
+	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64())) {
 		int err;
 		struct fuse_entry_out outarg;
 		struct fuse_req *req;
@@ -937,7 +937,7 @@ int fuse_update_attributes(struct inode *inode, struct kstat *stat,
 	int err;
 	bool r;
 
-	if (fi->i_time < get_jiffies_64()) {
+	if (time_before64(fi->i_time, get_jiffies_64())) {
 		r = true;
 		err = fuse_do_getattr(inode, stat, file);
 	} else {
@@ -1121,7 +1121,7 @@ static int fuse_permission(struct inode *inode, int mask)
 	    ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))) {
 		struct fuse_inode *fi = get_fuse_inode(inode);
 
-		if (fi->i_time < get_jiffies_64()) {
+		if (time_before64(fi->i_time, get_jiffies_64())) {
 			refreshed = true;
 
 			err = fuse_perm_getattr(inode, mask);
-- 
1.9.1

