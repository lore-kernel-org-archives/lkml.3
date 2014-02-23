Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaBWTBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 14:01:19 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:36881 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbaBWTBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 14:01:18 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmALAAZFClNR8dSK/2dsb2JhbABZgwY7qHkDmDyBBRd0glMTHCMYgQIkE4gJAccOjmSEPwSYMwGBMokfh1aDLjs
Date: Sun, 23 Feb 2014 20:01:15 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Tytso <tytso@mit.edu>
Subject: [PATCH 1/1] fs/ext4/inode.c: Add unlikely() to ext4_iget
Message-Id: <20140223200115.cd49762996b6bac6cbdd47bc@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isolate no memory and bad inode cases in ext4_iget.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/inode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6e39895..e11c30b9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4009,7 +4009,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	gid_t i_gid;
 
 	inode = iget_locked(sb, ino);
-	if (!inode)
+	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
 		return inode;
@@ -4018,14 +4018,14 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	iloc.bh = NULL;
 
 	ret = __ext4_get_inode_loc(inode, &iloc, 0);
-	if (ret < 0)
+	if (unlikely(ret < 0))
 		goto bad_inode;
 	raw_inode = ext4_raw_inode(&iloc);
 
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
-		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
-		    EXT4_INODE_SIZE(inode->i_sb)) {
+		if (unlikely(EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
+		    EXT4_INODE_SIZE(inode->i_sb))) {
 			EXT4_ERROR_INODE(inode, "bad extra_isize (%u != %u)",
 				EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize,
 				EXT4_INODE_SIZE(inode->i_sb));
@@ -4048,7 +4048,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 					      sizeof(gen));
 	}
 
-	if (!ext4_inode_csum_verify(inode, raw_inode, ei)) {
+	if (unlikely(!ext4_inode_csum_verify(inode, raw_inode, ei))) {
 		EXT4_ERROR_INODE(inode, "checksum invalid");
 		ret = -EIO;
 		goto bad_inode;
-- 
1.8.1.4
