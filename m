Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaGBUsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:48:47 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:7611 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbaGBUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:48:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicIANBvtFNXQBPR/2dsb2JhbABagw2sbgEBAQEBAQUBbgGZZwGBBhd1hAQBBScvIxBROR4ZiEYBx2QXhXCJMgeEQwWQBYpoi0qIQINFOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, sasha.levin@oracle.com, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/4] FS/CRAMFS: convert printk to pr_foo()
Date: Wed,  2 Jul 2014 22:47:12 +0200
Message-Id: <1404334035-7027-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404334035-7027-1-git-send-email-fabf@skynet.be>
References: <1404334035-7027-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use current logging functions.
no level printk converted to pr_err

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cramfs/inode.c      | 14 +++++++-------
 fs/cramfs/uncompress.c |  6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index ddcfe59..480fcb8 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -277,7 +277,7 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 		/* check for wrong endianness */
 		if (super.magic == CRAMFS_MAGIC_WEND) {
 			if (!silent)
-				printk(KERN_ERR "cramfs: wrong endianness\n");
+				pr_err("cramfs: wrong endianness\n");
 			return -EINVAL;
 		}
 
@@ -287,22 +287,22 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 		mutex_unlock(&read_mutex);
 		if (super.magic != CRAMFS_MAGIC) {
 			if (super.magic == CRAMFS_MAGIC_WEND && !silent)
-				printk(KERN_ERR "cramfs: wrong endianness\n");
+				pr_err("cramfs: wrong endianness\n");
 			else if (!silent)
-				printk(KERN_ERR "cramfs: wrong magic\n");
+				pr_err("cramfs: wrong magic\n");
 			return -EINVAL;
 		}
 	}
 
 	/* get feature flags first */
 	if (super.flags & ~CRAMFS_SUPPORTED_FLAGS) {
-		printk(KERN_ERR "cramfs: unsupported filesystem features\n");
+		pr_err("cramfs: unsupported filesystem features\n");
 		return -EINVAL;
 	}
 
 	/* Check that the root inode is in a sane state */
 	if (!S_ISDIR(super.root.mode)) {
-		printk(KERN_ERR "cramfs: root is not a directory\n");
+		pr_err("cramfs: root is not a directory\n");
 		return -EINVAL;
 	}
 	/* correct strange, hard-coded permissions of mkcramfs */
@@ -321,12 +321,12 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->magic=super.magic;
 	sbi->flags=super.flags;
 	if (root_offset == 0)
-		printk(KERN_INFO "cramfs: empty filesystem");
+		pr_info("cramfs: empty filesystem");
 	else if (!(super.flags & CRAMFS_FLAG_SHIFTED_ROOT_OFFSET) &&
 		 ((root_offset != sizeof(struct cramfs_super)) &&
 		  (root_offset != 512 + sizeof(struct cramfs_super))))
 	{
-		printk(KERN_ERR "cramfs: bad root offset %lu\n", root_offset);
+		pr_err("cramfs: bad root offset %lu\n", root_offset);
 		return -EINVAL;
 	}
 
diff --git a/fs/cramfs/uncompress.c b/fs/cramfs/uncompress.c
index 1760c1b..76428cc 100644
--- a/fs/cramfs/uncompress.c
+++ b/fs/cramfs/uncompress.c
@@ -37,7 +37,7 @@ int cramfs_uncompress_block(void *dst, int dstlen, void *src, int srclen)
 
 	err = zlib_inflateReset(&stream);
 	if (err != Z_OK) {
-		printk("zlib_inflateReset error %d\n", err);
+		pr_err("zlib_inflateReset error %d\n", err);
 		zlib_inflateEnd(&stream);
 		zlib_inflateInit(&stream);
 	}
@@ -48,8 +48,8 @@ int cramfs_uncompress_block(void *dst, int dstlen, void *src, int srclen)
 	return stream.total_out;
 
 err:
-	printk("Error %d while decompressing!\n", err);
-	printk("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
+	pr_err("Error %d while decompressing!\n", err);
+	pr_err("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
 	return -EIO;
 }
 
-- 
1.8.4.5

