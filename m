Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbaGORVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:21:47 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35065 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbaGORCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:10 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 31/94] ext4: fix unjournalled bg descriptor while initializing inode bitmap
Date: Tue, 15 Jul 2014 20:00:46 +0300
Message-Id: <1405443709-15288-31-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

The first time that we allocate from an uninitialized inode allocation
bitmap, if the block allocation bitmap is also uninitalized, we need
to get write access to the block group descriptor before we start
modifying the block group descriptor flags and updating the free block
count, etc.  Otherwise, there is the potential of a bad journal
checksum (if journal checksums are enabled), and of the file system
becoming inconsistent if we crash at exactly the wrong time.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 fs/ext4/ialloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a87455d..0840bf3 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -874,6 +874,13 @@ got:
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
@@ -910,13 +917,6 @@ got:
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
1.7.10.4

