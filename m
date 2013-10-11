Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab3JKLI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:08:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58415 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692Ab3JKKmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 020/100] isofs: Refuse RW mount of the filesystem instead of making it RO
Date: Fri, 11 Oct 2013 11:40:50 +0100
Message-Id: <1381488130-30235-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 17b7f7cf58926844e1dd40f5eb5348d481deca6a upstream.

Refuse RW mount of isofs filesystem. So far we just silently changed it
to RO mount but when the media is writeable, block layer won't notice
this change and thus will think device is used RW and will block eject
button of the drive. That is unexpected by users because for
non-writeable media eject button works just fine.

Userspace mount(8) command handles this just fine and retries mounting
with MS_RDONLY set so userspace shouldn't see any regression.  Plus any
tool mounting isofs is likely confronted with the case of read-only
media where block layer already refuses to mount the filesystem without
MS_RDONLY set so our behavior shouldn't be anything new for it.

Reported-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/isofs/inode.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 29037c3..e92a342 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -119,8 +119,8 @@ static void destroy_inodecache(void)
 
 static int isofs_remount(struct super_block *sb, int *flags, char *data)
 {
-	/* we probably want a lot more here */
-	*flags |= MS_RDONLY;
+	if (!(*flags & MS_RDONLY))
+		return -EROFS;
 	return 0;
 }
 
@@ -769,15 +769,6 @@ root_found:
 	 */
 	s->s_maxbytes = 0x80000000000LL;
 
-	/*
-	 * The CDROM is read-only, has no nodes (devices) on it, and since
-	 * all of the files appear to be owned by root, we really do not want
-	 * to allow suid.  (suid or devices will not show up unless we have
-	 * Rock Ridge extensions)
-	 */
-
-	s->s_flags |= MS_RDONLY /* | MS_NODEV | MS_NOSUID */;
-
 	/* Set this for reference. Its not currently used except on write
 	   which we don't have .. */
 
@@ -1536,6 +1527,9 @@ struct inode *isofs_iget(struct super_block *sb,
 static struct dentry *isofs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
+	/* We don't support read-write mounts */
+	if (!(flags & MS_RDONLY))
+		return ERR_PTR(-EACCES);
 	return mount_bdev(fs_type, flags, dev_name, data, isofs_fill_super);
 }
 
-- 
1.8.3.2

