Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750818Ab3IFEDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:03:18 -0400
Received: from mdfmta010.mxout.tch.inty.net ([91.221.169.51]:47129 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750754Ab3IFEDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:03:14 -0400
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 4/5] Squashfs: add corruption check in get_dir_index_using_offset()
Date: Fri,  6 Sep 2013 04:54:40 +0100
Message-Id: <1378439682-12830-5-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1378439682-12830-1-git-send-email-phillip@squashfs.org.uk>
References: <1378439682-12830-1-git-send-email-phillip@squashfs.org.uk>
X-MDF-HostID: 19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We read the size (of the name) field from disk.  This value should
be sanity checked for correctness to avoid blindly reading
huge amounts of unnecessary data from disk on corruption.

Note, here we're not actually reading the name into a buffer, but
skipping it, and so corruption doesn't cause buffer overflow, merely
lots of unnecessary amounts of data to be read.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/dir.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/squashfs/dir.c b/fs/squashfs/dir.c
index 1192084..bd7155b 100644
--- a/fs/squashfs/dir.c
+++ b/fs/squashfs/dir.c
@@ -54,6 +54,7 @@ static int get_dir_index_using_offset(struct super_block *sb,
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	int err, i, index, length = 0;
+	unsigned int size;
 	struct squashfs_dir_index dir_index;
 
 	TRACE("Entered get_dir_index_using_offset, i_count %d, f_pos %lld\n",
@@ -81,8 +82,14 @@ static int get_dir_index_using_offset(struct super_block *sb,
 			 */
 			break;
 
+		size = le32_to_cpu(dir_index.size) + 1;
+
+		/* size should never be larger than SQUASHFS_NAME_LEN */
+		if (size > SQUASHFS_NAME_LEN)
+			break;
+
 		err = squashfs_read_metadata(sb, NULL, &index_start,
-				&index_offset, le32_to_cpu(dir_index.size) + 1);
+				&index_offset, size);
 		if (err < 0)
 			break;
 
-- 
1.8.3.2

