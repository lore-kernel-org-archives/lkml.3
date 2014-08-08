Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbaHHVVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:21:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaHHUvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 066/259] ext4: fix unjournalled bg descriptor while initializing inode bitmap
Date: Fri,  8 Aug 2014 13:38:09 -0700
Message-Id: <1407530482-4483-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/ialloc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 0ee59a6..64bb32f1 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -851,6 +851,13 @@ got:
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
@@ -887,13 +894,6 @@ got:
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

