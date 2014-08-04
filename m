Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaHDRC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:02:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56554 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Miklos Szeredi" <mszeredi@suse.cz>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.786919181@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 39/94] fuse: timeout comparison fix
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 126b9d4365b110c157bc4cbc32540dfa66c9c85a upstream.

As suggested by checkpatch.pl, use time_before64() instead of direct
comparison of jiffies64 values.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -161,7 +161,7 @@ static int fuse_dentry_revalidate(struct
 	inode = ACCESS_ONCE(entry->d_inode);
 	if (inode && is_bad_inode(inode))
 		return 0;
-	else if (fuse_dentry_time(entry) < get_jiffies_64()) {
+	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64())) {
 		int err;
 		struct fuse_entry_out outarg;
 		struct fuse_conn *fc;
@@ -849,7 +849,7 @@ int fuse_update_attributes(struct inode
 	int err;
 	bool r;
 
-	if (fi->i_time < get_jiffies_64()) {
+	if (time_before64(fi->i_time, get_jiffies_64())) {
 		r = true;
 		err = fuse_do_getattr(inode, stat, file);
 	} else {
@@ -1009,7 +1009,7 @@ static int fuse_permission(struct inode
 	    ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))) {
 		struct fuse_inode *fi = get_fuse_inode(inode);
 
-		if (fi->i_time < get_jiffies_64()) {
+		if (time_before64(fi->i_time, get_jiffies_64())) {
 			refreshed = true;
 
 			err = fuse_perm_getattr(inode, mask);

