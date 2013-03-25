Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3CYBX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:23:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34073 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066Ab3CYBQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:14 -0400
Message-Id: <20130325010529.244383592@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:14 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Zheng Liu <wenqing.lz@taobao.com>,
        "Theodore Tso" <tytso@mit.edu>, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [ 050/104] ext4: fix the wrong number of the allocated blocks in
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
 ext4_split_extent()
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/extents.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2960,6 +2960,7 @@ static int ext4_split_extent(handle_t *h
 	int err = 0;
 	int uninitialized;
 	int split_flag1, flags1;
+	int allocated = map->m_len;
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -2979,6 +2980,8 @@ static int ext4_split_extent(handle_t *h
 				map->m_lblk + map->m_len, split_flag1, flags1);
 		if (err)
 			goto out;
+	} else {
+		allocated = ee_len - (map->m_lblk - ee_block);
 	}
 
 	ext4_ext_drop_refs(path);
@@ -3001,7 +3004,7 @@ static int ext4_split_extent(handle_t *h
 
 	ext4_ext_show_leaf(inode, path);
 out:
-	return err ? err : map->m_len;
+	return err ? err : allocated;
 }
 
 #define EXT4_EXT_ZERO_LEN 7
@@ -3663,6 +3666,7 @@ out:
 					allocated - map->m_len);
 		allocated = map->m_len;
 	}
+	map->m_len = allocated;
 
 	/*
 	 * If we have done fallocate with the offset that is already


