Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbaHVQzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:55:54 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:53956 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487AbaHVQxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:43 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/15] percpu: make pcpu_alloc_area() capable of allocating only from populated areas
Date: Fri, 22 Aug 2014 12:53:13 -0400
Message-Id: <1408726399-4436-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update pcpu_alloc_area() so that it can skip unpopulated areas if the
new parameter @pop_only is true.  This is implemented by a new
function, pcpu_fit_in_area(), which determines the amount of head
padding considering the alignment and populated state.

@pop_only is currently always false but this will be used to implement
atomic allocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 7 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 507afc0..7f2858c 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -400,10 +400,60 @@ out_unlock:
 }
 
 /**
+ * pcpu_fit_in_area - try to fit the requested allocation in a candidate area
+ * @chunk: chunk the candidate area belongs to
+ * @off: the offset to the start of the candidate area
+ * @this_size: the size of the candidate area
+ * @size: the size of the target allocation
+ * @align: the alignment of the target allocation
+ * @pop_only: only allocate from already populated region
+ *
+ * We're trying to allocate @size bytes aligned at @align.  @chunk's area
+ * at @off sized @this_size is a candidate.  This function determines
+ * whether the target allocation fits in the candidate area and returns the
+ * number of bytes to pad after @off.  If the target area doesn't fit, -1
+ * is returned.
+ *
+ * If @pop_only is %true, this function only considers the already
+ * populated part of the candidate area.
+ */
+static int pcpu_fit_in_area(struct pcpu_chunk *chunk, int off, int this_size,
+			    int size, int align, bool pop_only)
+{
+	int cand_off = off;
+
+	while (true) {
+		int head = ALIGN(cand_off, align) - off;
+		int page_start, page_end, rs, re;
+
+		if (this_size < head + size)
+			return -1;
+
+		if (!pop_only)
+			return head;
+
+		/*
+		 * If the first unpopulated page is beyond the end of the
+		 * allocation, the whole allocation is populated;
+		 * otherwise, retry from the end of the unpopulated area.
+		 */
+		page_start = PFN_DOWN(head + off);
+		page_end = PFN_UP(head + off + size);
+
+		rs = page_start;
+		pcpu_next_unpop(chunk, &rs, &re, PFN_UP(off + this_size));
+		if (rs >= page_end)
+			return head;
+		cand_off = re * PAGE_SIZE;
+	}
+}
+
+/**
  * pcpu_alloc_area - allocate area from a pcpu_chunk
  * @chunk: chunk of interest
  * @size: wanted size in bytes
  * @align: wanted align
+ * @pop_only: allocate only from the populated area
  *
  * Try to allocate @size bytes area aligned at @align from @chunk.
  * Note that this function only allocates the offset.  It doesn't
@@ -418,7 +468,8 @@ out_unlock:
  * Allocated offset in @chunk on success, -1 if no matching area is
  * found.
  */
-static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
+static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align,
+			   bool pop_only)
 {
 	int oslot = pcpu_chunk_slot(chunk);
 	int max_contig = 0;
@@ -434,11 +485,11 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 		if (off & 1)
 			continue;
 
-		/* extra for alignment requirement */
-		head = ALIGN(off, align) - off;
-
 		this_size = (p[1] & ~1) - off;
-		if (this_size < head + size) {
+
+		head = pcpu_fit_in_area(chunk, off, this_size, size, align,
+					pop_only);
+		if (head < 0) {
 			if (!seen_free) {
 				chunk->first_free = i;
 				seen_free = true;
@@ -730,7 +781,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 			spin_lock_irqsave(&pcpu_lock, flags);
 		}
 
-		off = pcpu_alloc_area(chunk, size, align);
+		off = pcpu_alloc_area(chunk, size, align, false);
 		if (off >= 0)
 			goto area_found;
 
@@ -761,7 +812,7 @@ restart:
 				goto restart;
 			}
 
-			off = pcpu_alloc_area(chunk, size, align);
+			off = pcpu_alloc_area(chunk, size, align, false);
 			if (off >= 0)
 				goto area_found;
 		}
-- 
1.9.3

