Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab3CZXRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:17:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab3CZWwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zheng Liu <wenqing.lz@taobao.com>, "Theodore Tso" <tytso@mit.edu>,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [ 51/72] ext4: fix the wrong number of the allocated blocks in ext4_split_extent()
Date: Tue, 26 Mar 2013 15:51:34 -0700
Message-Id: <20130326224924.942958376@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2959,6 +2959,7 @@ static int ext4_split_extent(handle_t *h
 	int err = 0;
 	int uninitialized;
 	int split_flag1, flags1;
+	int allocated = map->m_len;
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -2978,6 +2979,8 @@ static int ext4_split_extent(handle_t *h
 				map->m_lblk + map->m_len, split_flag1, flags1);
 		if (err)
 			goto out;
+	} else {
+		allocated = ee_len - (map->m_lblk - ee_block);
 	}
 
 	ext4_ext_drop_refs(path);
@@ -3000,7 +3003,7 @@ static int ext4_split_extent(handle_t *h
 
 	ext4_ext_show_leaf(inode, path);
 out:
-	return err ? err : map->m_len;
+	return err ? err : allocated;
 }
 
 #define EXT4_EXT_ZERO_LEN 7
@@ -3668,6 +3671,7 @@ out:
 					allocated - map->m_len);
 		allocated = map->m_len;
 	}
+	map->m_len = allocated;
 
 	/*
 	 * If we have done fallocate with the offset that is already


