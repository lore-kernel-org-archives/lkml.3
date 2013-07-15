Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab3GOQRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:17:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24302 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613Ab3GOQRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:17:22 -0400
Date: Mon, 15 Jul 2013 19:17:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] Squashfs: sanity check information from disk
Message-ID: <20130715161058.GA23687@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent-mail-2013-07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We read the size of the name from the disk, but a larger name than
expected would cause memory corruption.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I don't know this code very well, but to me it looks like there is an
off by one bug here as well.

We say:

	size = le32_to_cpu(index->size) + 1;

The "+ 1" is presumably for the NUL terminator.  Then we do:

	index->name[size] = '\0';

That means we are putting a NUL character one space beyond the end of
the array.  Presumably the first character of the next thing saved to
the disk is usually zero so that's why we don't notice that we are
reading a extra character when we read "size" number of bytes.

diff --git a/fs/squashfs/namei.c b/fs/squashfs/namei.c
index 7834a51..bc1334c 100644
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -79,7 +79,8 @@ static int get_dir_index_using_name(struct super_block *sb,
 			int len)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int i, size, length = 0, err;
+	int i, length = 0, err;
+	unsigned int size;
 	struct squashfs_dir_index *index;
 	char *str;
 
@@ -103,6 +104,10 @@ static int get_dir_index_using_name(struct super_block *sb,
 
 
 		size = le32_to_cpu(index->size) + 1;
+		if (size >= SQUASHFS_NAME_LEN + 1) {
+			err = -EINVAL;
+			break;
+		}
 
 		err = squashfs_read_metadata(sb, index->name, &index_start,
 					&index_offset, size);
