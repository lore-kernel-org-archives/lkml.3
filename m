Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbaEEMur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:50:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41024 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932305AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 39/50] ext4: fix error return from ext4_ext_handle_uninitialized_extents()
Date: Mon,  5 May 2014 14:43:21 +0200
Message-Id: <e3794f95677d19a6c31d7716c277ad8fb3f53884.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Whitney <enwlinux@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ce37c42919608e96ade3748fe23c3062a0a966c5 upstream.

Commit 3779473246 breaks the return of error codes from
ext4_ext_handle_uninitialized_extents() in ext4_ext_map_blocks().  A
portion of the patch assigns that function's signed integer return
value to an unsigned int.  Consequently, negatively valued error codes
are lost and can be treated as a bogus allocated block count.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/extents.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e678549ec994..bd048b6addad 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4159,7 +4159,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_extent newex, *ex, *ex2;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t newblock = 0;
-	int free_on_err = 0, err = 0, depth;
+	int free_on_err = 0, err = 0, depth, ret;
 	unsigned int allocated = 0, offset = 0;
 	unsigned int allocated_clusters = 0;
 	struct ext4_allocation_request ar;
@@ -4220,9 +4220,13 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
1.9.2

