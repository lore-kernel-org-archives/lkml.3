Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab3HMQ0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:26:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32930 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab3HMQ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:47 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=3X6558LbvFsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ojALGKljvAMA:10 a=HJjSp1d9RB5yKTmlI9kA:9 a=jeBq3FmKZ4MA:10 a=nHvdhx9J_PIOvjQ_:21 a=WGCN__9KUcDJKUas:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155837.133377315@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [84/88] ext4: fix overflow when counting used blocks on 32-bit architectures
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0084-ext4-fix-overflow-when-counting-used-blocks-on-32-bi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 8af8eecc1331dbf5e8c662022272cf667e213da5 ]

The arithmetics adding delalloc blocks to the number of used blocks in
ext4_getattr() can easily overflow on 32-bit archs as we first multiply
number of blocks by blocksize and then divide back by 512. Make the
arithmetics more clever and also use proper type (unsigned long long
instead of unsigned long).

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ext4/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 72c9d8d..b65a0f8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4385,7 +4385,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
 	struct inode *inode;
-	unsigned long delalloc_blocks;
+	unsigned long long delalloc_blocks;
 
 	inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
@@ -4403,7 +4403,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	delalloc_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
 				EXT4_I(inode)->i_reserved_data_blocks);
 
-	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
+	stat->blocks += delalloc_blocks << (inode->i_sb->s_blocksize_bits-9);
 	return 0;
 }
 
-- 
1.7.10.4


