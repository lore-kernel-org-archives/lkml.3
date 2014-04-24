Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaDXIwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:52:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46274 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaDXIwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Whitney <enwlinux@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 013/182] ext4: fix error return from ext4_ext_handle_uninitialized_extents()
Date: Thu, 24 Apr 2014 09:48:58 +0100
Message-Id: <1398329507-5911-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Whitney <enwlinux@gmail.com>

commit ce37c42919608e96ade3748fe23c3062a0a966c5 upstream.

Commit 3779473246 breaks the return of error codes from
ext4_ext_handle_uninitialized_extents() in ext4_ext_map_blocks().  A
portion of the patch assigns that function's signed integer return
value to an unsigned int.  Consequently, negatively valued error codes
are lost and can be treated as a bogus allocated block count.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/extents.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9b2d6e6..79ace91 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4055,7 +4055,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_extent newex, *ex, *ex2;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t newblock = 0;
-	int free_on_err = 0, err = 0, depth;
+	int free_on_err = 0, err = 0, depth, ret;
 	unsigned int allocated = 0, offset = 0;
 	unsigned int allocated_clusters = 0;
 	struct ext4_allocation_request ar;
@@ -4116,9 +4116,13 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			if (!ext4_ext_is_uninitialized(ex))
 				goto out;
 
-			allocated = ext4_ext_handle_uninitialized_extents(
+			ret = ext4_ext_handle_uninitialized_extents(
 				handle, inode, map, path, flags,
 				allocated, newblock);
+			if (ret < 0)
+				err = ret;
+			else
+				allocated = ret;
 			goto out3;
 		}
 	}
-- 
1.9.1

