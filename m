Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3CQI1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:27:09 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:60187 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3CQI1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:27:00 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 3/5] f2fs: fix return values from validate superblock
Date: Sun, 17 Mar 2013 17:26:53 +0900
Message-Id: <1363508813-2886-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

validate super block is not returning with proper values.
When failure from sb_bread it should reflect there is an EIO otherwise
it should return of EINVAL.
Returning, '1' is not conveying proper message as the return type.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/super.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 2bb6951..a8573c8 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -474,7 +474,7 @@ static int validate_superblock(struct super_block *sb,
 	if (!*raw_super_buf) {
 		f2fs_msg(sb, KERN_ERR, "unable to read %s superblock",
 				super);
-		return 1;
+		return -EIO;
 	}
 
 	*raw_super = (struct f2fs_super_block *)
@@ -486,7 +486,7 @@ static int validate_superblock(struct super_block *sb,
 
 	f2fs_msg(sb, KERN_ERR, "Can't find a valid F2FS filesystem "
 				"in %s superblock", super);
-	return 1;
+	return -EINVAL;
 }
 
 static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
@@ -509,9 +509,12 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		goto free_sbi;
 	}
 
-	if (validate_superblock(sb, &raw_super, &raw_super_buf, 0)) {
+	err = validate_superblock(sb, &raw_super, &raw_super_buf, 0);
+	if (err) {
 		brelse(raw_super_buf);
-		if (validate_superblock(sb, &raw_super, &raw_super_buf, 1))
+		/* check secondary superblock when primary failed */
+		err = validate_superblock(sb, &raw_super, &raw_super_buf, 1);
+		if (err)
 			goto free_sb_buf;
 	}
 	/* init some FS parameters */
-- 
1.7.9.5

