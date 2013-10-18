Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab3JRRg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:36:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61656 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab3JRRgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:36:24 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-e7-526171977d48
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dan.j.williams@intel.com
Cc: vinod.koul@intel.com, dave.jiang@intel.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        Dan Williams <djbw@fb.com>
Subject: [PATCH v2 07/13] async_xor_val: convert to dmaengine_unmap_data
Date: Fri, 18 Oct 2013 19:35:27 +0200
Message-id: <1382117733-16720-8-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAd3phYlBBodmcFlsnLGe1WL61AuM
	FiduNrJZbO5/wGZxtukNu8XlXXPYLG5f5rVYP+M1i8XLvv0sDpweLc09bB4Tm9+xeyze85LJ
	o2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDL297EVzJesmPJwL0sD4yaRLkZODgkBE4mJUyYy
	QdhiEhfurWfrYuTiEBJYxChxcm8zlNPFJPHx9WYWkCo2ASuJie2rGEFsEQEZiQ3/tzODFDEL
	nGeUWH1gJVhCWMBD4sWnnWANLAKqEge+7AJbwQsU/7x6CiPEOnmJp/f72EBsTgFPiWn7loPZ
	QkA15868ZJvAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCgPZPewbiqweIQowAH
	oxIPb4dNYpAQa2JZcWXuIUYJDmYlEd4yZ6AQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFC
	AumJJanZqakFqUUwWSYOTqkGxqVa1koiZ5s2mn07zxt0urh1DuPnk59uRW1ewOh58155VHpV
	4ZPk02Luh9dFlCi3/OeyfnGyzl5rd9V9g58J67+0XYvnEciQPZHx4o71/k0LrONqjsVaRYcf
	tjhd6PXYx+rczmKePZN+lHicEXh1zkrUOpIh5H9Wnev7wzxWy/TX6rMmnxc6ocRSnJFoqMVc
	VJwIABfdjH4wAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <djbw@fb.com>

Use the generic unmap object to unmap dma buffers.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Dan Williams <djbw@fb.com>
[bzolnier: minor cleanups]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_xor.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index f092fa1..d2cc77d 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -275,18 +275,17 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 	struct dma_chan *chan = xor_val_chan(submit, dest, src_list, src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
-	dma_addr_t *dma_src = NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(src_cnt <= 1);
 
-	if (submit->scribble)
-		dma_src = submit->scribble;
-	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
-		dma_src = (dma_addr_t *) src_list;
+	if (device)
+		unmap = dmaengine_get_unmap_data(device->dev, src_cnt, GFP_NOIO);
 
-	if (dma_src && device && src_cnt <= device->max_xor &&
+	if (unmap && src_cnt <= device->max_xor &&
 	    is_dma_xor_aligned(device, offset, 0, len)) {
-		unsigned long dma_prep_flags = 0;
+		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+					       DMA_COMPL_SKIP_DEST_UNMAP;
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
@@ -295,11 +294,15 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_prep_flags |= DMA_PREP_FENCE;
-		for (i = 0; i < src_cnt; i++)
-			dma_src[i] = dma_map_page(device->dev, src_list[i],
-						  offset, len, DMA_TO_DEVICE);
 
-		tx = device->device_prep_dma_xor_val(chan, dma_src, src_cnt,
+		for (i = 0; i < src_cnt; i++) {
+			unmap->addr[i] = dma_map_page(device->dev, src_list[i],
+						      offset, len, DMA_TO_DEVICE);
+			unmap->to_cnt++;
+		}
+		unmap->len = len;
+
+		tx = device->device_prep_dma_xor_val(chan, unmap->addr, src_cnt,
 						     len, result,
 						     dma_prep_flags);
 		if (unlikely(!tx)) {
@@ -308,11 +311,11 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 			while (!tx) {
 				dma_async_issue_pending(chan);
 				tx = device->device_prep_dma_xor_val(chan,
-					dma_src, src_cnt, len, result,
+					unmap->addr, src_cnt, len, result,
 					dma_prep_flags);
 			}
 		}
-
+		dma_set_unmap(tx, unmap);
 		async_tx_submit(chan, tx, submit);
 	} else {
 		enum async_tx_flags flags_orig = submit->flags;
@@ -334,6 +337,7 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 		async_tx_sync_epilog(submit);
 		submit->flags = flags_orig;
 	}
+	dmaengine_unmap_put(unmap);
 
 	return tx;
 }
-- 
1.8.2.3

