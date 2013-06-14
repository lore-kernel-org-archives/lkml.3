Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3FNTYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:24:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48893 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab3FNTYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:24:17 -0400
From: Richard Yao <ryao@gentoo.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel@gentoo.org
Subject: [PATCH 2/2] btrfs: Cleanup llseek()
Date: Fri, 14 Jun 2013 15:23:34 -0400
Message-Id: <1371237814-59365-3-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1371237814-59365-1-git-send-email-ryao@gentoo.org>
References: <1371237814-59365-1-git-send-email-ryao@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are multiple issues with the custom llseek implemented in btrfs
for implementing SEEK_HOLE/SEEK_DATA.

1. It takes the inode->i_mutex lock before calling
generic_file_llseek(), which is unnecessary.

2. It fails to take the filp->f_lock spinlock before modifying
filp->f_pos and filp->f_version, which differs from
generic_file_llseek().

3. It does a offset > inode->i_sb->s_maxbytes check that is dead code
because the the offset >= i_size_read(inode) will evaluate to true and
return ENXIO whenever the former comparison evaluates to true.

4. The switch statement tries to cover all whence values when in reality
it should only care about SEEK_HOLE/SEEK_DATA. Any other cases should be
passsed to generic_file_llseek().

btrfs_file_llseek() and ocfs2_file_llseek() are extremely similar and
consequently, contain many of the same flaws. Li Dongyang filed a pull
request with ZFSOnLinux for SEEK_HOLE/SEEK_DATA support that included a
custom llseek function that appears to have been modelled after the one
in ocfs2. The similarity was strong enough that it suffered from many of
the same flaws, which I caught during review. I addressed the issues
with his patch with one that I wrote. I decided to adapt that code to
both btrfs and ocfs2 (separate patch) because a small percentage of
Gentoo Linux users are affected by these flaws.

Note that #3 would have been worse had it not been for commit
48802c8ae2a9d618ec734a61283d645ad527e06c by Jeff Liu at Oracle. Prior to
his commit, btrfs llseek() would permit seeking up to the maximum file
size possible on the btrfs filesystem, even when it is past the end of
the file. Seeking beyond that (if possible), would return EINVAL instead
of ENXIO. That was the same behavior that the ocfs2 llseek had.
corrected that issue. However, the ocfs2 code was not fortunate enough
to have had this corrected at that time.

Signed-off-by: Richard Yao <ryao@gentoo.org>
---
 fs/btrfs/file.c | 49 ++++++++++++++++++++-----------------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 4205ba7..1f437d8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2400,48 +2400,39 @@ out:
 	return ret;
 }
 
-static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
+static loff_t btrfs_file_llseek(struct file *filp, loff_t offset, int whence)
 {
-	struct inode *inode = file->f_mapping->host;
-	int ret;
+	if (whence == SEEK_DATA || whence == SEEK_HOLE) {
+		struct inode *inode = filp->f_mapping->host;
+		int ret;
+
+		if (offset < 0 && !(filp->f_mode & FMODE_UNSIGNED_OFFSET))
+			return -EINVAL;
 
-	mutex_lock(&inode->i_mutex);
-	switch (whence) {
-	case SEEK_END:
-	case SEEK_CUR:
-		offset = generic_file_llseek(file, offset, whence);
-		goto out;
-	case SEEK_DATA:
-	case SEEK_HOLE:
 		if (offset >= i_size_read(inode)) {
-			mutex_unlock(&inode->i_mutex);
 			return -ENXIO;
 		}
 
+		mutex_lock(&inode->i_mutex);
 		ret = find_desired_extent(inode, &offset, whence);
+		mutex_unlock(&inode->i_mutex);
+
 		if (ret) {
-			mutex_unlock(&inode->i_mutex);
 			return ret;
 		}
-	}
 
-	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
-		offset = -EINVAL;
-		goto out;
-	}
-	if (offset > inode->i_sb->s_maxbytes) {
-		offset = -EINVAL;
-		goto out;
-	}
+		if (offset != filp->f_pos) {
+			spin_lock(&filp->f_lock);
+			filp->f_pos = offset;
+			filp->f_version = 0;
+			spin_unlock(&filp->f_lock);
+		}
 
-	/* Special lock needed here? */
-	if (offset != file->f_pos) {
-		file->f_pos = offset;
-		file->f_version = 0;
+		return offset;
 	}
-out:
-	mutex_unlock(&inode->i_mutex);
-	return offset;
+
+	return generic_file_llseek(filp, offset, whence);
+
 }
 
 const struct file_operations btrfs_file_operations = {
-- 
1.8.1.5

