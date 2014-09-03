Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbaICFyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:54:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16629 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaICFyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:54:51 -0400
X-AuditID: cbfee61a-f79e46d00000134f-d5-5406ad2af914
From: Chao Yu <chao2.yu@samsung.com>
To: sjennings@variantweb.net
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] zbud: avoid accessing in last unused freelist
Date: Wed, 03 Sep 2014 13:54:09 +0800
Message-id: <000001cfc73b$9340d050$b9c270f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/GkM97fakRAueGTyKj+0UV31wp3Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t9jAV2ttWwhBjcmK1pc3jWHzeLemv+s
	Fp+OPmJzYPbY9GkSu8f1b0UenzfJBTBHcdmkpOZklqUW6dslcGUc2rOIveCUUMWnictZGxh/
	8nUxcnJICJhI3D/ayghhi0lcuLeerYuRi0NIYBGjxJ4vr5khnB+MEjNPzWEDqWITUJFY3vGf
	CcQWEZCR2L99DzuIzQwyqfUhK4gtLGAn8evQaZYuRg4OFgFVicvzjUFMXgFLie87s0EqeAUE
	JX5MvscC0aklsX7ncSYIW15i85q3zBD3KEjsOPuaEWKTnsTnf91sEDXiEhuP3GKZwCgwC8mo
	WUhGzUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgoP3mdQOxpUNFocYBTgY
	lXh4FwSwhQixJpYVV+YeYpTgYFYS4fVNBArxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgk
	kJ5YkpqdmlqQWgSTZeLglGpgjD2gW7Dp8xsRFta2D1fUZhx4cux6p3SsWZirPpM6f+099pxQ
	xY+c5r4OpivTixcFabo8tjm5dcb8f3FPDGLe3sl8cpelZ7ft1L8r+Xe2yS5Im+Qz583sVqXk
	vNNNzwT769zl2qYI1l+RnWWsVczAZ7TPRUXkSyuPSFP4uefX91aecUqskmVWYinOSDTUYi4q
	TgQA2K5061oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now, there are NCHUNKS of 64 freelists in zbud_pool, the last unbuddied[63]
freelist linked with all zbud pages which have free chunks of 63. Calculating
according to context of num_free_chunks(), our max chunk number of unbuddied
zbud page is 62, so none of zbud pages will be added/removed in last freelist,
but still we will try to find an unbuddied zbud page in the last unused
freelist, it is unneeded.

This patch redefines NCHUNKS to 63 as free chunk number in one zbud page, hence
we can decrease size of zpool and avoid accessing the last unused freelist
whenever failing to allocate zbud from freelist in zbud_alloc.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 mm/zbud.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index f26e7fc..ecf1dbe 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -60,15 +60,17 @@
  * NCHUNKS_ORDER determines the internal allocation granularity, effectively
  * adjusting internal fragmentation.  It also determines the number of
  * freelists maintained in each pool. NCHUNKS_ORDER of 6 means that the
- * allocation granularity will be in chunks of size PAGE_SIZE/64, and there
- * will be 64 freelists per pool.
+ * allocation granularity will be in chunks of size PAGE_SIZE/64. As one chunk
+ * in allocated page is occupied by zbud header, NCHUNKS will be calculated to
+ * 63 which shows the max number of free chunks in zbud page, also there will be
+ * 63 freelists per pool.
  */
 #define NCHUNKS_ORDER	6
 
 #define CHUNK_SHIFT	(PAGE_SHIFT - NCHUNKS_ORDER)
 #define CHUNK_SIZE	(1 << CHUNK_SHIFT)
-#define NCHUNKS		(PAGE_SIZE >> CHUNK_SHIFT)
 #define ZHDR_SIZE_ALIGNED CHUNK_SIZE
+#define NCHUNKS		((PAGE_SIZE - ZHDR_SIZE_ALIGNED) >> CHUNK_SHIFT)
 
 /**
  * struct zbud_pool - stores metadata for each zbud pool
@@ -268,10 +270,9 @@ static int num_free_chunks(struct zbud_header *zhdr)
 {
 	/*
 	 * Rather than branch for different situations, just use the fact that
-	 * free buddies have a length of zero to simplify everything. -1 at the
-	 * end for the zbud header.
+	 * free buddies have a length of zero to simplify everything.
 	 */
-	return NCHUNKS - zhdr->first_chunks - zhdr->last_chunks - 1;
+	return NCHUNKS - zhdr->first_chunks - zhdr->last_chunks;
 }
 
 /*****************
-- 
2.0.1.474.g72c7794


