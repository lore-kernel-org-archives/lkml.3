Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3C0Rnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:43:35 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:39202 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3C0Rkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:33 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 12/22] umem: Convert to bvec_iter
Date: Wed, 27 Mar 2013 10:39:42 -0700
Message-Id: <1364405992-28424-13-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new primitives which respect bi_bvec_done.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/umem.c | 50 +++++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index dab4f1a..00145e8 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -108,8 +108,7 @@ struct cardinfo {
 				    * have been written
 				    */
 	struct bio	*bio, *currentbio, **biotail;
-	int		current_idx;
-	sector_t	current_sector;
+	struct bvec_iter current_iter;
 
 	struct request_queue *queue;
 
@@ -118,7 +117,7 @@ struct cardinfo {
 		struct mm_dma_desc	*desc;
 		int	 		cnt, headcnt;
 		struct bio		*bio, **biotail;
-		int			idx;
+		struct bvec_iter	iter;
 	} mm_pages[2];
 #define DESC_PER_PAGE ((PAGE_SIZE*2)/sizeof(struct mm_dma_desc))
 
@@ -344,16 +343,13 @@ static int add_bio(struct cardinfo *card)
 	dma_addr_t dma_handle;
 	int offset;
 	struct bio *bio;
-	struct bio_vec *vec;
-	int idx;
+	struct bio_vec vec;
 	int rw;
-	int len;
 
 	bio = card->currentbio;
 	if (!bio && card->bio) {
 		card->currentbio = card->bio;
-		card->current_idx = card->bio->bi_iter.bi_idx;
-		card->current_sector = card->bio->bi_iter.bi_sector;
+		card->current_iter = card->bio->bi_iter;
 		card->bio = card->bio->bi_next;
 		if (card->bio == NULL)
 			card->biotail = &card->bio;
@@ -362,18 +358,17 @@ static int add_bio(struct cardinfo *card)
 	}
 	if (!bio)
 		return 0;
-	idx = card->current_idx;
 
 	rw = bio_rw(bio);
 	if (card->mm_pages[card->Ready].cnt >= DESC_PER_PAGE)
 		return 0;
 
-	vec = bio_iovec_idx(bio, idx);
-	len = vec->bv_len;
+	vec = bio_iovec_iter(bio, card->current_iter);
+
 	dma_handle = pci_map_page(card->dev,
-				  vec->bv_page,
-				  vec->bv_offset,
-				  len,
+				  vec.bv_page,
+				  vec.bv_offset,
+				  vec.bv_len,
 				  (rw == READ) ?
 				  PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
 
@@ -381,7 +376,7 @@ static int add_bio(struct cardinfo *card)
 	desc = &p->desc[p->cnt];
 	p->cnt++;
 	if (p->bio == NULL)
-		p->idx = idx;
+		p->iter = card->current_iter;
 	if ((p->biotail) != &bio->bi_next) {
 		*(p->biotail) = bio;
 		p->biotail = &(bio->bi_next);
@@ -391,8 +386,8 @@ static int add_bio(struct cardinfo *card)
 	desc->data_dma_handle = dma_handle;
 
 	desc->pci_addr = cpu_to_le64((u64)desc->data_dma_handle);
-	desc->local_addr = cpu_to_le64(card->current_sector << 9);
-	desc->transfer_size = cpu_to_le32(len);
+	desc->local_addr = cpu_to_le64(card->current_iter.bi_sector << 9);
+	desc->transfer_size = cpu_to_le32(vec.bv_len);
 	offset = (((char *)&desc->sem_control_bits) - ((char *)p->desc));
 	desc->sem_addr = cpu_to_le64((u64)(p->page_dma+offset));
 	desc->zero1 = desc->zero2 = 0;
@@ -407,10 +402,9 @@ static int add_bio(struct cardinfo *card)
 		desc->control_bits |= cpu_to_le32(DMASCR_TRANSFER_READ);
 	desc->sem_control_bits = desc->control_bits;
 
-	card->current_sector += (len >> 9);
-	idx++;
-	card->current_idx = idx;
-	if (idx >= bio->bi_vcnt)
+
+	bio_advance_iter(bio, &card->current_iter, vec.bv_len);
+	if (!card->current_iter.bi_size)
 		card->currentbio = NULL;
 
 	return 1;
@@ -439,23 +433,25 @@ static void process_page(unsigned long data)
 		struct mm_dma_desc *desc = &page->desc[page->headcnt];
 		int control = le32_to_cpu(desc->sem_control_bits);
 		int last = 0;
-		int idx;
+		struct bio_vec vec;
 
 		if (!(control & DMASCR_DMA_COMPLETE)) {
 			control = dma_status;
 			last = 1;
 		}
+
 		page->headcnt++;
-		idx = page->idx;
-		page->idx++;
-		if (page->idx >= bio->bi_vcnt) {
+		vec = bio_iovec_iter(bio, page->iter);
+		bio_advance_iter(bio, &page->iter, vec.bv_len);
+
+		if (!page->iter.bi_size) {
 			page->bio = bio->bi_next;
 			if (page->bio)
-				page->idx = page->bio->bi_iter.bi_idx;
+				page->iter = page->bio->bi_iter;
 		}
 
 		pci_unmap_page(card->dev, desc->data_dma_handle,
-			       bio_iovec_idx(bio, idx)->bv_len,
+			       vec.bv_len,
 				 (control & DMASCR_TRANSFER_READ) ?
 				PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
 		if (control & DMASCR_HARD_ERROR) {
-- 
1.8.1.3

