Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3GQMUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:20:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38142 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab3GQMUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:20:37 -0400
Date: Wed, 17 Jul 2013 15:20:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] Squashfs: sanity check information from disk
Message-ID: <20130717122025.GA14232@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB3wodeBWvgF9oKb9OVXNABiafhvLticB=x8s=R81RRv9Yd6kA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We read the size of the name from the disk, but a larger name than
expected would cause memory corruption.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: style change

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
+		if (size > SQUASHFS_NAME_LEN) {
+			err = -EINVAL;
+			break;
+		}
 
 		err = squashfs_read_metadata(sb, index->name, &index_start,
 					&index_offset, size);

