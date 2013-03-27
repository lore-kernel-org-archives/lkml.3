Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3C0Rkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:40:42 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52046 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3C0Rkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:31 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 11/22] dm-io: Convert DM_IO_BVEC -> DM_IO_BIO
Date: Wed, 27 Mar 2013 10:39:41 -0700
Message-Id: <1364405992-28424-12-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can't work with raw biovecs anymore - have to use the bvec_iter
primitives which respect bi_bvec_done.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-io.c    | 31 +++++++++++++++++--------------
 drivers/md/dm-raid1.c |  8 ++++----
 include/linux/dm-io.h |  4 ++--
 3 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index a6de5c9..c2a6c34 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -202,26 +202,29 @@ static void list_dp_init(struct dpages *dp, struct page_list *pl, unsigned offse
 /*
  * Functions for getting the pages from a bvec.
  */
-static void bvec_get_page(struct dpages *dp,
+static void bio_get_page(struct dpages *dp,
 		  struct page **p, unsigned long *len, unsigned *offset)
 {
-	struct bio_vec *bvec = (struct bio_vec *) dp->context_ptr;
-	*p = bvec->bv_page;
-	*len = bvec->bv_len;
-	*offset = bvec->bv_offset;
+	struct bio *bio = dp->context_ptr;
+	struct bio_vec bvec = bio_iovec(bio);
+	*p = bvec.bv_page;
+	*len = bvec.bv_len;
+	*offset = bvec.bv_offset;
 }
 
-static void bvec_next_page(struct dpages *dp)
+static void bio_next_page(struct dpages *dp)
 {
-	struct bio_vec *bvec = (struct bio_vec *) dp->context_ptr;
-	dp->context_ptr = bvec + 1;
+	struct bio *bio = dp->context_ptr;
+	struct bio_vec bvec = bio_iovec(bio);
+
+	bio_advance(bio, bvec.bv_len);
 }
 
-static void bvec_dp_init(struct dpages *dp, struct bio_vec *bvec)
+static void bio_dp_init(struct dpages *dp, struct bio *bio)
 {
-	dp->get_page = bvec_get_page;
-	dp->next_page = bvec_next_page;
-	dp->context_ptr = bvec;
+	dp->get_page = bio_get_page;
+	dp->next_page = bio_next_page;
+	dp->context_ptr = bio;
 }
 
 /*
@@ -459,8 +462,8 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
 		list_dp_init(dp, io_req->mem.ptr.pl, io_req->mem.offset);
 		break;
 
-	case DM_IO_BVEC:
-		bvec_dp_init(dp, io_req->mem.ptr.bvec);
+	case DM_IO_BIO:
+		bio_dp_init(dp, io_req->mem.ptr.bio);
 		break;
 
 	case DM_IO_VMA:
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index e3efb91..56e8844 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -526,8 +526,8 @@ static void read_async_bio(struct mirror *m, struct bio *bio)
 	struct dm_io_region io;
 	struct dm_io_request io_req = {
 		.bi_rw = READ,
-		.mem.type = DM_IO_BVEC,
-		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_iter.bi_idx,
+		.mem.type = DM_IO_BIO,
+		.mem.ptr.bio = bio,
 		.notify.fn = read_callback,
 		.notify.context = bio,
 		.client = m->ms->io_client,
@@ -629,8 +629,8 @@ static void do_write(struct mirror_set *ms, struct bio *bio)
 	struct mirror *m;
 	struct dm_io_request io_req = {
 		.bi_rw = WRITE | (bio->bi_rw & WRITE_FLUSH_FUA),
-		.mem.type = DM_IO_BVEC,
-		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_iter.bi_idx,
+		.mem.type = DM_IO_BIO,
+		.mem.ptr.bio = bio,
 		.notify.fn = write_callback,
 		.notify.context = bio,
 		.client = ms->io_client,
diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
index f4b0aa3..6cf1f62 100644
--- a/include/linux/dm-io.h
+++ b/include/linux/dm-io.h
@@ -29,7 +29,7 @@ typedef void (*io_notify_fn)(unsigned long error, void *context);
 
 enum dm_io_mem_type {
 	DM_IO_PAGE_LIST,/* Page list */
-	DM_IO_BVEC,	/* Bio vector */
+	DM_IO_BIO,
 	DM_IO_VMA,	/* Virtual memory area */
 	DM_IO_KMEM,	/* Kernel memory */
 };
@@ -41,7 +41,7 @@ struct dm_io_memory {
 
 	union {
 		struct page_list *pl;
-		struct bio_vec *bvec;
+		struct bio *bio;
 		void *vma;
 		void *addr;
 	} ptr;
-- 
1.8.1.3

