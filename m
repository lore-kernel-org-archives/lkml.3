Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3AMR5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:57:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34945 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab3AMRpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:23 -0500
Message-Id: <20130113174256.469802714@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:42:58 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [ 03/49] ext4: check dioread_nolock on remount
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/super.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1942,6 +1942,16 @@ set_qf_format:
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
 
@@ -3367,15 +3377,6 @@ static int ext4_fill_super(struct super_
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
 
@@ -3417,6 +3418,7 @@ static int ext4_fill_super(struct super_
 	if (!ext4_feature_set_ok(sb, (sb->s_flags & MS_RDONLY)))
 		goto failed_mount;
 
+	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
 	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
 	    blocksize > EXT4_MAX_BLOCK_SIZE) {
 		ext4_msg(sb, KERN_ERR,


