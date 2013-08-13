Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab3HMQ0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:26:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab3HMQ0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:44 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=KcOkYxrQj44A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=CT5frwdWrToA:10 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=lM-VaWlihCa-_fViJtcA:9 a=jeBq3FmKZ4MA:10 a=FUPFxQvgyuW5zaNw:21 a=KOFkYv-_n6wQEnW8:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155834.200047505@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Theodore Tso" <tytso@mit.edu>
Subject: [67/88] ext3,ext4: dont mess with dir_file->f_pos in
 htree_dirblock_to_tree()
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0067-ext3-ext4-don-t-mess-with-dir_file-f_pos-in-htree_di.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

[ Upstream commit 64cb927371cd2ec43758d8a094a003d27bc3d0dc ]

Both ext3 and ext4 htree_dirblock_to_tree() is just filling the
in-core rbtree for use by call_filldir().  All updates of ->f_pos are
done by the latter; bumping it here (on error) is obviously wrong - we
might very well have it nowhere near the block we'd found an error in.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ext3/namei.c |    7 ++-----
 fs/ext4/namei.c |    7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 8f4fdda..93e541b 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -573,11 +573,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 		if (!ext3_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
 					(block<<EXT3_BLOCK_SIZE_BITS(dir->i_sb))
 						+((char *)de - bh->b_data))) {
-			/* On error, skip the f_pos to the next block. */
-			dir_file->f_pos = (dir_file->f_pos |
-					(dir->i_sb->s_blocksize - 1)) + 1;
-			brelse (bh);
-			return count;
+			/* silently ignore the rest of the block */
+			break;
 		}
 		ext3fs_dirhash(de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d13873d..b1aaccc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -859,11 +859,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 				(block<<EXT4_BLOCK_SIZE_BITS(dir->i_sb))
 					 + ((char *)de - bh->b_data))) {
-			/* On error, skip the f_pos to the next block. */
-			dir_file->f_pos = (dir_file->f_pos |
-					(dir->i_sb->s_blocksize - 1)) + 1;
-			brelse(bh);
-			return count;
+			/* silently ignore the rest of the block */
+			break;
 		}
 		ext4fs_dirhash(de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
-- 
1.7.10.4


