Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3IYUW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:22:59 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64725 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3IYUW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:22:56 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: hch@infradead.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 3/6] Introduce blk_max_segment()
Date: Wed, 25 Sep 2013 13:22:41 -0700
Message-Id: <1380140564-9030-4-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
References: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 arch/x86/include/asm/io.h |  3 +++
 block/blk-merge.c         | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/xen/biomerge.c    |  8 ++++++++
 include/linux/blkdev.h    |  1 +
 4 files changed, 63 insertions(+)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 34f69cb..4799845 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -335,6 +335,9 @@ extern bool is_early_ioremap_ptep(pte_t *ptep);
 #include <xen/xen.h>
 struct bio_vec;
 
+extern bool xen_page_phys_mergeable(const struct page *p1,
+				    const struct page *p2);
+
 extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
 				      const struct bio_vec *vec2);
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 7cebf46..c9c837b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -9,6 +9,57 @@
 
 #include "blk.h"
 
+static unsigned int __blk_max_segment(struct request_queue *q, struct bio_vec *bv)
+{
+	unsigned len = bv->bv_len;
+
+	len = min_t(unsigned, len, blk_queue_cluster(q)
+		    ? queue_max_segment_size(q)
+		    : PAGE_SIZE);
+
+	len = min_t(unsigned, len,
+		    queue_segment_boundary(q) + 1 -
+		    (bvec_to_phys(bv) & queue_segment_boundary(q)));
+
+	return len;
+}
+
+#ifdef CONFIG_XEN
+unsigned int blk_max_segment(struct request_queue *q, struct bio_vec *bv)
+{
+	unsigned len = __blk_max_segment(q, bv);
+	unsigned ret;
+	struct page *next, *prev;
+
+	if (!xen_domain())
+		return len;
+
+	ret = min_t(unsigned, len, PAGE_SIZE - bv->bv_offset);
+	prev = bv->bv_page;
+
+	while (ret < len) {
+		next = nth_page(prev, 1);
+
+		if (!xen_page_phys_mergeable(prev, next))
+			break;
+
+		ret += min_t(unsigned, len - ret, PAGE_SIZE);
+		prev = next;
+	}
+
+	return ret;
+}
+
+#else
+
+unsigned int blk_max_segment(struct request_queue *q, struct bio_vec *bv)
+{
+	return __blk_max_segment(q, bv);
+}
+
+#endif
+EXPORT_SYMBOL(blk_max_segment);
+
 static struct bio *blk_bio_discard_split(struct request_queue *q,
 					 struct bio *bio,
 					 struct bio_set *bs)
diff --git a/drivers/xen/biomerge.c b/drivers/xen/biomerge.c
index 0edb91c..d9fb598 100644
--- a/drivers/xen/biomerge.c
+++ b/drivers/xen/biomerge.c
@@ -3,6 +3,14 @@
 #include <linux/export.h>
 #include <xen/page.h>
 
+bool xen_page_phys_mergeable(const struct page *p1, const struct page *p2)
+{
+	unsigned long mfn1 = pfn_to_mfn(page_to_pfn(p1));
+	unsigned long mfn2 = pfn_to_mfn(page_to_pfn(p2));
+
+	return mfn1 + 1 == mfn2;
+}
+
 bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
 			       const struct bio_vec *vec2)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1afe1bb..4a45e35 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -746,6 +746,7 @@ extern void blk_rq_unprep_clone(struct request *rq);
 extern int blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
 extern void blk_delay_queue(struct request_queue *, unsigned long);
+extern unsigned int blk_max_segment(struct request_queue *, struct bio_vec *);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
 extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
 extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,
-- 
1.8.4.rc3

