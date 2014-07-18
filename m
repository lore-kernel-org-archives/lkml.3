Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161111AbaGRNPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:15:36 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17822 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161093AbaGRNPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 156/170] ext4: fix unjournalled bg descriptor while initializing inode bitmap
Date: Fri, 18 Jul 2014 14:12:41 +0200
Message-Id: <f289a188e9a2df6d4bd79cfb4082cc423c7ca0c5.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 61c219f5814277ecb71d64cb30297028d6665979 upstream.

The first time that we allocate from an uninitialized inode allocation
bitmap, if the block allocation bitmap is also uninitalized, we need
to get write access to the block group descriptor before we start
modifying the block group descriptor flags and updating the free block
count, etc.  Otherwise, there is the potential of a bad journal
checksum (if journal checksums are enabled), and of the file system
becoming inconsistent if we crash at exactly the wrong time.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/ialloc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 137193ff389b..5b5971c20af1 100644
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
2.0.0

