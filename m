Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3C0Rna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:43:30 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63196 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab3C0Rkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:36 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 15/22] block: Kill bio_iovec_idx(), __bio_iovec()
Date: Wed, 27 Mar 2013 10:39:45 -0700
Message-Id: <1364405992-28424-16-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio_iovec_idx() doesn't have any valid uses anymore - code which was
using it has been converted to bio_iovec_iter().

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 include/linux/bio.h | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index d6c646b..1967b64 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -61,9 +61,6 @@
  * various member access, note that bio_data should of course not be used
  * on highmem page vectors
  */
-#define bio_iovec_idx(bio, idx)	(&((bio)->bi_io_vec[(idx)]))
-#define __bio_iovec(bio)	bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
-
 #define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
 
 #define bvec_iter_page(bvec, iter)				\
@@ -138,11 +135,11 @@ static inline void *bio_data(struct bio *bio)
  * permanent PIO fall back, user is probably better off disabling highmem
  * I/O completely on that queue (see ide-dma for example)
  */
-#define __bio_kmap_atomic(bio, idx, kmtype)				\
-	(kmap_atomic(bio_iovec_idx((bio), (idx))->bv_page) +	\
-		bio_iovec_idx((bio), (idx))->bv_offset)
+#define __bio_kmap_atomic(bio, iter)				\
+	(kmap_atomic(bio_iovec_iter((bio), (iter)).bv_page) +	\
+		bio_iovec_iter((bio), (iter)).bv_offset)
 
-#define __bio_kunmap_atomic(addr, kmtype) kunmap_atomic(addr)
+#define __bio_kunmap_atomic(addr)	kunmap_atomic(addr)
 
 /*
  * merge helpers etc
@@ -172,9 +169,7 @@ static inline void *bio_data(struct bio *bio)
  * before it got to the driver and the driver won't own all of it
  */
 #define bio_for_each_segment_all(bvl, bio, i)				\
-	for (i = 0;							\
-	     bvl = bio_iovec_idx((bio), (i)), i < (bio)->bi_vcnt;	\
-	     i++)
+	for (i = 0, bvl = (bio)->bi_io_vec; i < (bio)->bi_vcnt; i++, bvl++)
 
 static inline void bvec_iter_advance(struct bio_vec *bv, struct bvec_iter *iter,
 				     unsigned bytes)
@@ -426,15 +421,15 @@ static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 }
 #endif
 
-static inline char *__bio_kmap_irq(struct bio *bio, unsigned short idx,
+static inline char *__bio_kmap_irq(struct bio *bio, struct bvec_iter iter,
 				   unsigned long *flags)
 {
-	return bvec_kmap_irq(bio_iovec_idx(bio, idx), flags);
+	return bvec_kmap_irq(&bio_iovec_iter(bio, iter), flags);
 }
 #define __bio_kunmap_irq(buf, flags)	bvec_kunmap_irq(buf, flags)
 
 #define bio_kmap_irq(bio, flags) \
-	__bio_kmap_irq((bio), (bio)->bi_iter.bi_idx, (flags))
+	__bio_kmap_irq((bio), (bio)->bi_iter, (flags))
 #define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
 
 static inline bool bio_is_rw(struct bio *bio)
-- 
1.8.1.3

