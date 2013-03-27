Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab3C0Rne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:43:34 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:45670 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab3C0Rke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:34 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>,
        Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org
Subject: [PATCH 13/22] ceph: Convert to bvec_iter
Date: Wed, 27 Mar 2013 10:39:43 -0700
Message-Id: <1364405992-28424-14-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new primitives which respect bi_bvec_done.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Sage Weil <sage@inktank.com>
Cc: ceph-devel@vger.kernel.org
---
 include/linux/ceph/messenger.h |  3 ++-
 net/ceph/messenger.c           | 53 ++++++++++++++++++++++--------------------
 2 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 60903e0..dccf497 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -1,6 +1,7 @@
 #ifndef __FS_CEPH_MESSENGER_H
 #define __FS_CEPH_MESSENGER_H
 
+#include <linux/blk_types.h>
 #include <linux/kref.h>
 #include <linux/mutex.h>
 #include <linux/net.h>
@@ -86,7 +87,7 @@ struct ceph_msg {
 #ifdef CONFIG_BLOCK
 	struct bio  *bio;		/* instead of pages/pagelist */
 	struct bio  *bio_iter;		/* bio iterator */
-	int bio_seg;			/* current bio segment */
+	struct bvec_iter bvec_iter;	/* current bio segment */
 #endif /* CONFIG_BLOCK */
 	struct ceph_pagelist *trail;	/* the trailing part of the data */
 	bool front_is_vmalloc;
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 0c102ec..ee88ae4 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -697,27 +697,30 @@ static void con_out_kvec_add(struct ceph_connection *con,
 }
 
 #ifdef CONFIG_BLOCK
-static void init_bio_iter(struct bio *bio, struct bio **iter, int *seg)
+static void init_bio_iter(struct bio *bio, struct bio **iter,
+			  struct bvec_iter *bvec_iter)
 {
 	if (!bio) {
 		*iter = NULL;
-		*seg = 0;
 		return;
 	}
 	*iter = bio;
-	*seg = bio->bi_iter.bi_idx;
+	*bvec_iter = bio->bi_iter;
 }
 
-static void iter_bio_next(struct bio **bio_iter, int *seg)
+static void iter_bio_next(struct bio **bio_iter, struct bvec_iter *bvec_iter)
 {
+	struct bio_vec bv;
+
 	if (*bio_iter == NULL)
 		return;
 
-	BUG_ON(*seg >= (*bio_iter)->bi_vcnt);
+	BUG_ON(!bvec_iter->bi_size);
+	bv = bio_iovec_iter(*bio_iter, *bvec_iter);
 
-	(*seg)++;
-	if (*seg == (*bio_iter)->bi_vcnt)
-		init_bio_iter((*bio_iter)->bi_next, bio_iter, seg);
+	bio_advance_iter(*bio_iter, bvec_iter, bv.bv_len);
+	if (!bvec_iter->bi_size)
+		init_bio_iter((*bio_iter)->bi_next, bio_iter, bvec_iter);
 }
 #endif
 
@@ -736,7 +739,7 @@ static void prepare_write_message_data(struct ceph_connection *con)
 		con->out_msg_pos.page_pos = 0;
 #ifdef CONFIG_BLOCK
 	if (msg->bio)
-		init_bio_iter(msg->bio, &msg->bio_iter, &msg->bio_seg);
+		init_bio_iter(msg->bio, &msg->bio_iter, &msg->bvec_iter);
 #endif
 	con->out_msg_pos.data_pos = 0;
 	con->out_msg_pos.did_page_crc = false;
@@ -1047,7 +1050,7 @@ static void out_msg_pos_next(struct ceph_connection *con, struct page *page,
 			       &msg->pagelist->head);
 #ifdef CONFIG_BLOCK
 	else if (msg->bio)
-		iter_bio_next(&msg->bio_iter, &msg->bio_seg);
+		iter_bio_next(&msg->bio_iter, &msg->bvec_iter);
 #endif
 }
 
@@ -1103,12 +1106,12 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 						struct page, lru);
 #ifdef CONFIG_BLOCK
 		} else if (msg->bio) {
-			struct bio_vec *bv;
+			struct bio_vec bv;
 
-			bv = bio_iovec_idx(msg->bio_iter, msg->bio_seg);
-			page = bv->bv_page;
-			bio_offset = bv->bv_offset;
-			max_write = bv->bv_len;
+			bv = bio_iovec_iter(msg->bio_iter, msg->bvec_iter);
+			page = bv.bv_page;
+			bio_offset = bv.bv_offset;
+			max_write = bv.bv_len;
 #endif
 		} else {
 			page = zero_page;
@@ -1818,17 +1821,18 @@ static int read_partial_message_pages(struct ceph_connection *con,
 
 #ifdef CONFIG_BLOCK
 static int read_partial_message_bio(struct ceph_connection *con,
-				    struct bio **bio_iter, int *bio_seg,
+				    struct bio **bio_iter,
+				    struct bvec_iter *bvec_iter,
 				    unsigned int data_len, bool do_datacrc)
 {
-	struct bio_vec *bv = bio_iovec_idx(*bio_iter, *bio_seg);
+	struct bio_vec bv = bio_iovec_iter(*bio_iter, *bvec_iter);
 	void *p;
 	int ret, left;
 
 	left = min((int)(data_len - con->in_msg_pos.data_pos),
-		   (int)(bv->bv_len - con->in_msg_pos.page_pos));
+		   (int)(bv.bv_len - con->in_msg_pos.page_pos));
 
-	p = kmap(bv->bv_page) + bv->bv_offset;
+	p = kmap(bv.bv_page) + bv.bv_offset;
 
 	ret = ceph_tcp_recvmsg(con->sock, p + con->in_msg_pos.page_pos,
 			       left);
@@ -1836,14 +1840,14 @@ static int read_partial_message_bio(struct ceph_connection *con,
 		con->in_data_crc =
 			crc32c(con->in_data_crc,
 				  p + con->in_msg_pos.page_pos, ret);
-	kunmap(bv->bv_page);
+	kunmap(bv.bv_page);
 	if (ret <= 0)
 		return ret;
 	con->in_msg_pos.data_pos += ret;
 	con->in_msg_pos.page_pos += ret;
-	if (con->in_msg_pos.page_pos == bv->bv_len) {
+	if (con->in_msg_pos.page_pos == bv.bv_len) {
 		con->in_msg_pos.page_pos = 0;
-		iter_bio_next(bio_iter, bio_seg);
+		iter_bio_next(bio_iter, bvec_iter);
 	}
 
 	return ret;
@@ -1945,7 +1949,7 @@ static int read_partial_message(struct ceph_connection *con)
 
 #ifdef CONFIG_BLOCK
 		if (m->bio)
-			init_bio_iter(m->bio, &m->bio_iter, &m->bio_seg);
+			init_bio_iter(m->bio, &m->bio_iter, &m->bvec_iter);
 #endif
 	}
 
@@ -1975,7 +1979,7 @@ static int read_partial_message(struct ceph_connection *con)
 		} else if (m->bio) {
 			BUG_ON(!m->bio_iter);
 			ret = read_partial_message_bio(con,
-						 &m->bio_iter, &m->bio_seg,
+						 &m->bio_iter, &m->bvec_iter,
 						 data_len, do_datacrc);
 			if (ret <= 0)
 				return ret;
@@ -2720,7 +2724,6 @@ struct ceph_msg *ceph_msg_new(int type, int front_len, gfp_t flags,
 #ifdef	CONFIG_BLOCK
 	m->bio = NULL;
 	m->bio_iter = NULL;
-	m->bio_seg = 0;
 #endif	/* CONFIG_BLOCK */
 	m->trail = NULL;
 
-- 
1.8.1.3

