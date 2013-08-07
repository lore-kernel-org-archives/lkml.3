Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab3HGVzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:55:33 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:43129 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933728Ab3HGVzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:55:21 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Sage Weil <sage@inktank.com>,
        ceph-devel@vger.kernel.org
Subject: [PATCH 13/22] ceph: Convert to immutable biovecs
Date: Wed,  7 Aug 2013 14:54:22 -0700
Message-Id: <1375912471-5106-14-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc1
In-Reply-To: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've got a mechanism for immutable biovecs -
bi_iter.bi_bvec_done - we need to convert drivers to use primitives that
respect it instead of using the bvec array directly.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sage Weil <sage@inktank.com>
Cc: ceph-devel@vger.kernel.org
---
 include/linux/ceph/messenger.h |  4 ++--
 net/ceph/messenger.c           | 43 +++++++++++++++++-------------------------
 2 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 7c1420b..091fdb6 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -1,6 +1,7 @@
 #ifndef __FS_CEPH_MESSENGER_H
 #define __FS_CEPH_MESSENGER_H
 
+#include <linux/blk_types.h>
 #include <linux/kref.h>
 #include <linux/mutex.h>
 #include <linux/net.h>
@@ -119,8 +120,7 @@ struct ceph_msg_data_cursor {
 #ifdef CONFIG_BLOCK
 		struct {				/* bio */
 			struct bio	*bio;		/* bio from list */
-			unsigned int	vector_index;	/* vector from bio */
-			unsigned int	vector_offset;	/* bytes from vector */
+			struct bvec_iter bvec_iter;
 		};
 #endif /* CONFIG_BLOCK */
 		struct {				/* pages */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index eb0a46a..86d336e 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -777,13 +777,12 @@ static void ceph_msg_data_bio_cursor_init(struct ceph_msg_data_cursor *cursor,
 
 	bio = data->bio;
 	BUG_ON(!bio);
-	BUG_ON(!bio->bi_vcnt);
 
 	cursor->resid = min(length, data->bio_length);
 	cursor->bio = bio;
-	cursor->vector_index = 0;
-	cursor->vector_offset = 0;
-	cursor->last_piece = length <= bio->bi_io_vec[0].bv_len;
+	cursor->bvec_iter = bio->bi_iter;
+	cursor->last_piece =
+		cursor->resid <= bio_iter_len(bio, cursor->bvec_iter);
 }
 
 static struct page *ceph_msg_data_bio_next(struct ceph_msg_data_cursor *cursor,
@@ -792,71 +791,63 @@ static struct page *ceph_msg_data_bio_next(struct ceph_msg_data_cursor *cursor,
 {
 	struct ceph_msg_data *data = cursor->data;
 	struct bio *bio;
-	struct bio_vec *bio_vec;
-	unsigned int index;
+	struct bio_vec bio_vec;
 
 	BUG_ON(data->type != CEPH_MSG_DATA_BIO);
 
 	bio = cursor->bio;
 	BUG_ON(!bio);
 
-	index = cursor->vector_index;
-	BUG_ON(index >= (unsigned int) bio->bi_vcnt);
+	bio_vec = bio_iter_iovec(bio, cursor->bvec_iter);
 
-	bio_vec = &bio->bi_io_vec[index];
-	BUG_ON(cursor->vector_offset >= bio_vec->bv_len);
-	*page_offset = (size_t) (bio_vec->bv_offset + cursor->vector_offset);
+	*page_offset = (size_t) bio_vec.bv_offset;
 	BUG_ON(*page_offset >= PAGE_SIZE);
 	if (cursor->last_piece) /* pagelist offset is always 0 */
 		*length = cursor->resid;
 	else
-		*length = (size_t) (bio_vec->bv_len - cursor->vector_offset);
+		*length = (size_t) bio_vec.bv_len;
 	BUG_ON(*length > cursor->resid);
 	BUG_ON(*page_offset + *length > PAGE_SIZE);
 
-	return bio_vec->bv_page;
+	return bio_vec.bv_page;
 }
 
 static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
 					size_t bytes)
 {
 	struct bio *bio;
-	struct bio_vec *bio_vec;
-	unsigned int index;
+	struct bio_vec bio_vec;
 
 	BUG_ON(cursor->data->type != CEPH_MSG_DATA_BIO);
 
 	bio = cursor->bio;
 	BUG_ON(!bio);
 
-	index = cursor->vector_index;
-	BUG_ON(index >= (unsigned int) bio->bi_vcnt);
-	bio_vec = &bio->bi_io_vec[index];
+	bio_vec = bio_iter_iovec(bio, cursor->bvec_iter);
 
 	/* Advance the cursor offset */
 
 	BUG_ON(cursor->resid < bytes);
 	cursor->resid -= bytes;
-	cursor->vector_offset += bytes;
-	if (cursor->vector_offset < bio_vec->bv_len)
+
+	bio_advance_iter(bio, &cursor->bvec_iter, bytes);
+
+	if (bytes < bio_vec.bv_len)
 		return false;	/* more bytes to process in this segment */
-	BUG_ON(cursor->vector_offset != bio_vec->bv_len);
 
 	/* Move on to the next segment, and possibly the next bio */
 
-	if (++index == (unsigned int) bio->bi_vcnt) {
+	if (!cursor->bvec_iter.bi_size) {
 		bio = bio->bi_next;
-		index = 0;
+		cursor->bvec_iter = bio->bi_iter;
 	}
 	cursor->bio = bio;
-	cursor->vector_index = index;
-	cursor->vector_offset = 0;
 
 	if (!cursor->last_piece) {
 		BUG_ON(!cursor->resid);
 		BUG_ON(!bio);
 		/* A short read is OK, so use <= rather than == */
-		if (cursor->resid <= bio->bi_io_vec[index].bv_len)
+		if (cursor->resid <= bio_iter_len(bio, cursor->bvec_iter))
 			cursor->last_piece = true;
 	}
 
-- 
1.8.4.rc1

