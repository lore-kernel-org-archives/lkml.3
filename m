Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab3APQ1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:27:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab3APQIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:08:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 166/222] ext4: check dioread_nolock on remount
Date: Wed, 16 Jan 2013 13:56:06 -0200
Message-Id: <1358351822-7675-167-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 261cb20cb2f0737a247aaf08dff7eb065e3e5b66 upstream.

Currently we allow enabling dioread_nolock mount option on remount for
filesystems where blocksize < PAGE_CACHE_SIZE.  This isn't really
supported so fix the bug by moving the check for blocksize !=
PAGE_CACHE_SIZE into parse_options(). Change the original PAGE_SIZE to
PAGE_CACHE_SIZE along the way because that's what we are really
interested in.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ext4/super.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 993392b..b045207 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1656,9 +1656,7 @@ static int parse_options(char *options, struct super_block *sb,
 			 unsigned int *journal_ioprio,
 			 int is_remount)
 {
-#ifdef CONFIG_QUOTA
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-#endif
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	int token;
@@ -1707,6 +1705,16 @@ static int parse_options(char *options, struct super_block *sb,
 		}
 	}
 #endif
+	if (test_opt(sb, DIOREAD_NOLOCK)) {
+		int blocksize =
+			BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
+
+		if (blocksize < PAGE_CACHE_SIZE) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "dioread_nolock if block size != PAGE_SIZE");
+			return 0;
+		}
+	}
 	return 1;
 }
 
@@ -3410,15 +3418,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			clear_opt(sb, DELALLOC);
 	}
 
-	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
-	if (test_opt(sb, DIOREAD_NOLOCK)) {
-		if (blocksize < PAGE_SIZE) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "dioread_nolock if block size != PAGE_SIZE");
-			goto failed_mount;
-		}
-	}
-
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
 
@@ -3460,6 +3459,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ext4_feature_set_ok(sb, (sb->s_flags & MS_RDONLY)))
 		goto failed_mount;
 
+	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
 	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
 	    blocksize > EXT4_MAX_BLOCK_SIZE) {
 		ext4_msg(sb, KERN_ERR,
-- 
1.7.9.5

