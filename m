Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaLVLuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:50:10 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50237 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbaLVLuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:50:04 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC PATCH 08/17] block: refactor __bio_copy_iov()
Date: Mon, 22 Dec 2014 12:48:35 +0100
Message-Id: <0b6ba533a64aec98e8447bfd30c6622d0729d12e.1419241597.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
 <f67d71b4a375ab504c2fc02e94a9d2a651686cab.1419241597.git.dongsu.park@profitbricks.com>
 <fe96db02d805ca6191dd605d03dac0d04c926fc1.1419241597.git.dongsu.park@profitbricks.com>
 <bb0051ceb5805896089ded26c0f7f06758b25105.1419241597.git.dongsu.park@profitbricks.com>
 <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
 <83a9ee8a309f8e08490c5dd715a608ea054f5c33.1419241597.git.dongsu.park@profitbricks.com>
 <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Rewrite __bio_copy_iov() to use copy_page_to_iter() or
copy_page_from_iter(), according to Al Viro's suggestions.

This commit should contain only literal replacements, without
functional changes.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 block/bio.c | 62 +++++++++++++++++++++++++------------------------------------
 1 file changed, 25 insertions(+), 37 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 4731c4a..524b401 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1022,45 +1022,34 @@ static struct bio_map_data *bio_alloc_map_data(unsigned int iov_count,
 }
 
 static int __bio_copy_iov(struct bio *bio, const struct iov_iter *iter,
-			  int to_user, int from_user, int do_free_page)
+			  int to_iov)
 {
-	int ret = 0, i;
+	int i;
 	struct bio_vec *bvec;
 	struct iov_iter iov_iter = *iter;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		char *bv_addr = page_address(bvec->bv_page);
-		unsigned int bv_len = bvec->bv_len;
-
-		while (bv_len && iov_iter.count) {
-			struct iovec iov = iov_iter_iovec(&iov_iter);
-			unsigned int bytes = min_t(unsigned int, bv_len,
-						   iov.iov_len);
-
-			if (!ret) {
-				if (to_user)
-					ret = copy_to_user(iov.iov_base,
-							   bv_addr, bytes);
-
-				if (from_user)
-					ret = copy_from_user(bv_addr,
-							     iov.iov_base,
-							     bytes);
-
-				if (ret)
-					ret = -EFAULT;
-			}
-
-			bv_len -= bytes;
-			bv_addr += bytes;
-			iov_iter_advance(&iov_iter, bytes);
-		}
+		ssize_t ret;
+
+		if (to_iov == WRITE)
+			ret = copy_page_to_iter(bvec->bv_page,
+						bvec->bv_offset,
+						bvec->bv_len,
+						&iov_iter);
+		else
+			ret = copy_page_from_iter(bvec->bv_page,
+						  bvec->bv_offset,
+						  bvec->bv_len,
+						  &iov_iter);
+
+		if (!iov_iter_count(&iov_iter))
+			break;
 
-		if (do_free_page)
-			__free_page(bvec->bv_page);
+		if (ret < bvec->bv_len)
+			return -EFAULT;
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -1081,11 +1070,10 @@ int bio_uncopy_user(struct bio *bio)
 		 * if we're in a workqueue, the request is orphaned, so
 		 * don't copy into a random user address space, just free.
 		 */
-		if (current->mm)
-			ret = __bio_copy_iov(bio, &bmd->iter,
-					     bio_data_dir(bio) == READ,
-					     0, bmd->is_our_pages);
-		else if (bmd->is_our_pages)
+		if (current->mm && bio_data_dir(bio) == READ)
+			ret = __bio_copy_iov(bio, &bmd->iter, WRITE);
+
+		if (bmd->is_our_pages)
 			bio_for_each_segment_all(bvec, bio, i)
 				__free_page(bvec->bv_page);
 	}
@@ -1208,7 +1196,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	 */
 	if ((!write_to_vm && (!map_data || !map_data->null_mapped)) ||
 	    (map_data && map_data->from_user)) {
-		ret = __bio_copy_iov(bio, iter, 0, 1, 0);
+		ret = __bio_copy_iov(bio, iter, READ);
 		if (ret)
 			goto cleanup;
 	}
-- 
2.1.0

