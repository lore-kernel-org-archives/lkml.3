Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093Ab3CZPWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:22:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53823 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab3CZPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 064/150] ext4: fix the wrong number of the allocated blocks in ext4_split_extent()
Date: Tue, 26 Mar 2013 15:19:23 +0000
Message-Id: <1364311249-14454-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Liu <wenqing.lz@taobao.com>

commit 3a2256702e47f68f921dfad41b1764d05c572329 upstream.

This commit fixes a wrong return value of the number of the allocated
blocks in ext4_split_extent.  When the length of blocks we want to
allocate is greater than the length of the current extent, we return a
wrong number.  Let's see what happens in the following case when we
call ext4_split_extent().

  map: [48, 72]
  ex:  [32, 64, u]

'ex' will be split into two parts:
  ex1: [32, 47, u]
  ex2: [48, 64, w]

'map->m_len' is returned from this function, and the value is 24.  But
the real length is 16.  So it should be fixed.

Meanwhile in this commit we use right length of the allocated blocks
when get_reserved_cluster_alloc in ext4_ext_handle_uninitialized_extents
is called.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/extents.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d14487e..5101df2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3029,6 +3029,7 @@ static int ext4_split_extent(handle_t *handle,
 	int err = 0;
 	int uninitialized;
 	int split_flag1, flags1;
+	int allocated = map->m_len;
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3048,6 +3049,8 @@ static int ext4_split_extent(handle_t *handle,
 				map->m_lblk + map->m_len, split_flag1, flags1);
 		if (err)
 			goto out;
+	} else {
+		allocated = ee_len - (map->m_lblk - ee_block);
 	}
 
 	ext4_ext_drop_refs(path);
@@ -3070,7 +3073,7 @@ static int ext4_split_extent(handle_t *handle,
 
 	ext4_ext_show_leaf(inode, path);
 out:
-	return err ? err : map->m_len;
+	return err ? err : allocated;
 }
 
 #define EXT4_EXT_ZERO_LEN 7
@@ -3738,6 +3741,7 @@ out:
 					allocated - map->m_len);
 		allocated = map->m_len;
 	}
+	map->m_len = allocated;
 
 	/*
 	 * If we have done fallocate with the offset that is already
-- 
1.8.1.2

