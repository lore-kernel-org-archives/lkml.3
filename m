Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab3HMQ0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:26:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab3HMQ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:47 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=l0b5215T_VwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=tbM7y9LzYVoA:10 a=vNManNb1N3hIac-wmrEA:9 a=jeBq3FmKZ4MA:10 a=mQV6_iV8zlKW05aN:21 a=hCchlur7wagdQYV6:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155836.979357944@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [83/88] ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit
 archs
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0083-ext4-fix-data-offset-overflow-in-ext4_xattr_fiemap-o.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit a60697f411eb365fb09e639e6f183fe33d1eb796 ]

On 32-bit architectures with 32-bit sector_t computation of data offset
in ext4_xattr_fiemap() can overflow resulting in reporting bogus data
location. Fix the problem by typing block number to proper type before
shifting.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ext4/extents.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4f7d479..345442f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4767,7 +4767,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 		error = ext4_get_inode_loc(inode, &iloc);
 		if (error)
 			return error;
-		physical = iloc.bh->b_blocknr << blockbits;
+		physical = (__u64)iloc.bh->b_blocknr << blockbits;
 		offset = EXT4_GOOD_OLD_INODE_SIZE +
 				EXT4_I(inode)->i_extra_isize;
 		physical += offset;
@@ -4775,7 +4775,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 		flags |= FIEMAP_EXTENT_DATA_INLINE;
 		brelse(iloc.bh);
 	} else { /* external block */
-		physical = EXT4_I(inode)->i_file_acl << blockbits;
+		physical = (__u64)EXT4_I(inode)->i_file_acl << blockbits;
 		length = inode->i_sb->s_blocksize;
 	}
 
-- 
1.7.10.4


