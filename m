Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbaGOXsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:48:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933707AbaGOXN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.14 44/66] ext4: fix unjournalled bg descriptor while initializing inode bitmap
Date: Tue, 15 Jul 2014 16:17:38 -0700
Message-Id: <20140715231704.102786025@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231702.156040999@linuxfoundation.org>
References: <20140715231702.156040999@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ialloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

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


