Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934963AbaGXKAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:00:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55078 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628AbaGXJsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 096/128] ext4: fix unjournalled bg descriptor while initializing inode bitmap
Date: Thu, 24 Jul 2014 10:45:45 +0100
Message-Id: <1406195177-8656-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 61c219f5814277ecb71d64cb30297028d6665979 upstream.

The first time that we allocate from an uninitialized inode allocation
bitmap, if the block allocation bitmap is also uninitalized, we need
to get write access to the block group descriptor before we start
modifying the block group descriptor flags and updating the free block
count, etc.  Otherwise, there is the potential of a bad journal
checksum (if journal checksums are enabled), and of the file system
becoming inconsistent if we crash at exactly the wrong time.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/ialloc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 8bf5999875ee..0ecc14028477 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -781,6 +781,13 @@ got:
 		goto out;
 	}
 
+	BUFFER_TRACE(group_desc_bh, "get_write_access");
+	err = ext4_journal_get_write_access(handle, group_desc_bh);
+	if (err) {
+		ext4_std_error(sb, err);
+		goto out;
+	}
+
 	/* We may have to initialize the block bitmap if it isn't already */
 	if (ext4_has_group_desc_csum(sb) &&
 	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
@@ -817,13 +824,6 @@ got:
 		}
 	}
 
-	BUFFER_TRACE(group_desc_bh, "get_write_access");
-	err = ext4_journal_get_write_access(handle, group_desc_bh);
-	if (err) {
-		ext4_std_error(sb, err);
-		goto out;
-	}
-
 	/* Update the relevant bg descriptor fields */
 	if (ext4_has_group_desc_csum(sb)) {
 		int free;
-- 
1.9.1

