Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab3APQBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:01:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35935 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab3APQBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:01:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lukas Czerner <lczerner@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 061/222] ext4: fix possible use after free with metadata csum
Date: Wed, 16 Jan 2013 13:54:21 -0200
Message-Id: <1358351822-7675-62-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit aeb1e5d69a5be592e86a926be73efb38c55af404 upstream.

Commit fa77dcfafeaa introduces block bitmap checksum calculation into
ext4_new_inode() in the case that block group was uninitialized.
However we brelse() the bitmap buffer before we attempt to checksum it
so we have no guarantee that the buffer is still there.

Fix this by releasing the buffer after the possible checksum
computation.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ext4/ialloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 4418852..536ac65 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -754,7 +754,6 @@ got:
 
 		BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
 		err = ext4_handle_dirty_metadata(handle, NULL, block_bitmap_bh);
-		brelse(block_bitmap_bh);
 
 		/* recheck and clear flag under lock if we still need to */
 		ext4_lock_group(sb, group);
@@ -767,6 +766,7 @@ got:
 			ext4_group_desc_csum_set(sb, group, gdp);
 		}
 		ext4_unlock_group(sb, group);
+		brelse(block_bitmap_bh);
 
 		if (err)
 			goto fail;
-- 
1.7.9.5

