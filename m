Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab3AOXro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:47:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:45914 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932963Ab3AOWuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [ 058/171] ext4: check dioread_nolock on remount
Date: Tue, 15 Jan 2013 14:43:43 -0800
Message-Id: <20130115224317.605032605@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1599,9 +1599,7 @@ static int parse_options(char *options,
 			 unsigned int *journal_ioprio,
 			 int is_remount)
 {
-#ifdef CONFIG_QUOTA
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-#endif
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	int token;
@@ -1650,6 +1648,16 @@ static int parse_options(char *options,
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
 
@@ -3226,15 +3234,6 @@ static int ext4_fill_super(struct super_
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
 
@@ -3276,6 +3275,7 @@ static int ext4_fill_super(struct super_
 	if (!ext4_feature_set_ok(sb, (sb->s_flags & MS_RDONLY)))
 		goto failed_mount;
 
+	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
 	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
 	    blocksize > EXT4_MAX_BLOCK_SIZE) {
 		ext4_msg(sb, KERN_ERR,


