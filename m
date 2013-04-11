Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936089Ab3DKUv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:51:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11236 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab3DKUth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:37 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=t8-5Vf28k3MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=atEPYTPmo-wA:10 a=f-csgJdLAAAA:8 a=6rqHouBjAAAA:8 a=VwQbUJbxAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=CMowB-bsPn0A:10 a=TAmEwCHjoHMA:10 a=jeBq3FmKZ4MA:10 a=60JqbxLNycUOfjrR:21 a=01r44bwKV0uW3a9O:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202555.370678579@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Tso" <tytso@mit.edu>,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [ 056/171 ] ext4: fix the wrong number of the allocated blocks in
 ext4_split_extent()
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0056-ext4-fix-the-wrong-number-of-the-allocated-blocks-in.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Zheng Liu <wenqing.lz@taobao.com>

[ Upstream commit 3a2256702e47f68f921dfad41b1764d05c572329 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ext4/extents.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 741bb94..4f7d479 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3011,6 +3011,7 @@ static int ext4_split_extent(handle_t *handle,
 	int err = 0;
 	int uninitialized;
 	int split_flag1, flags1;
+	int allocated = map->m_len;
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3030,6 +3031,8 @@ static int ext4_split_extent(handle_t *handle,
 				map->m_lblk + map->m_len, split_flag1, flags1);
 		if (err)
 			goto out;
+	} else {
+		allocated = ee_len - (map->m_lblk - ee_block);
 	}
 
 	ext4_ext_drop_refs(path);
@@ -3052,7 +3055,7 @@ static int ext4_split_extent(handle_t *handle,
 
 	ext4_ext_show_leaf(inode, path);
 out:
-	return err ? err : map->m_len;
+	return err ? err : allocated;
 }
 
 #define EXT4_EXT_ZERO_LEN 7
@@ -3720,6 +3723,7 @@ out:
 					allocated - map->m_len);
 		allocated = map->m_len;
 	}
+	map->m_len = allocated;
 
 	/*
 	 * If we have done fallocate with the offset that is already
-- 
1.7.10.4


