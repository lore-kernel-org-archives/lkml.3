Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab3EFXOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:14:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab3EFXOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:14:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 094/104] ext4: fix big-endian bug in metadata checksum calculations
Date: Mon,  6 May 2013 16:12:53 -0700
Message-Id: <20130506230053.291089521@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 171a7f21a76a0958c225b97c00a97a10390d40ee upstream.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    8 ++++----
 fs/ext4/mmp.c   |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -55,21 +55,21 @@ static __u32 ext4_inode_csum(struct inod
 	__u16 csum_hi = 0;
 	__u32 csum;
 
-	csum_lo = raw->i_checksum_lo;
+	csum_lo = le16_to_cpu(raw->i_checksum_lo);
 	raw->i_checksum_lo = 0;
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
 	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi)) {
-		csum_hi = raw->i_checksum_hi;
+		csum_hi = le16_to_cpu(raw->i_checksum_hi);
 		raw->i_checksum_hi = 0;
 	}
 
 	csum = ext4_chksum(sbi, ei->i_csum_seed, (__u8 *)raw,
 			   EXT4_INODE_SIZE(inode->i_sb));
 
-	raw->i_checksum_lo = csum_lo;
+	raw->i_checksum_lo = cpu_to_le16(csum_lo);
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
 	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
-		raw->i_checksum_hi = csum_hi;
+		raw->i_checksum_hi = cpu_to_le16(csum_hi);
 
 	return csum;
 }
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -7,7 +7,7 @@
 #include "ext4.h"
 
 /* Checksumming functions */
-static __u32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
+static __le32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int offset = offsetof(struct mmp_struct, mmp_checksum);


