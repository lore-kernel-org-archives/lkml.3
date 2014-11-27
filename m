Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106AbaK0Oue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:50:34 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:46157 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaK0Ouc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:50:32 -0500
Message-ID: <54773A35.30109@gmail.com>
Date: Thu, 27 Nov 2014 16:50:29 +0200
From: Crestez Dan Leonard <cdleonard@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Sorin Dumitru <sdumitru@ixiacom.com>
Subject: [RFC] Poor free_percpu performance with small objects.
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It seems that free_percpu performance is very bad when working with small objects. The easiest way to reproduce this is to allocate and then free a large number of percpu int counters in order. Small objects (int refcounters and pointers) are common users of alloc_percpu and I think this should be fast.

The problem seems to be pcpu_chunk keeps an array of all alocated areas. At free time pcpu_free_area will delete items from that array linearly, using memmove. This has worst-case quadratic complexity in the number of areas per chunk. This gets really bad if areas are small.

One way to fix this is to merge free areas in a separate function and hope that multiple frees are handled at once. There is a patch below which does this, but I don't like it and I suspect it's incorrect. Maybe the merging should be done when map_free < map_used with a certain margin? Or only as part of the async balance work?

It might also be possible to work around this by tweaking the size of chunks. If pcpu_unit_size is clamped to <64K it might be possible to make pcpu_chunk->map an array of unsigned shorts instead.

diff --git a/mm/percpu.c b/mm/percpu.c
index 014bab6..07c1e62 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -375,6 +375,63 @@ static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
 }
 
 /**
+ * percpu_merge_free_spaces - merge spaces in a chunk
+ * @chunk: chunk of interest
+ *
+ * This function should merge a continous region of free
+ * spaces into a single one.
+ *
+ * CONTEXT:
+ * pcpu_lock.
+ */
+static void pcpu_merge_free_spaces(struct pcpu_chunk *chunk)
+{
+	int start;
+	int i, j;
+
+	/* We copy from map[i] into map[j] while merging free spaces. */
+	i = j = chunk->first_free;
+	/* In case first_free points to something busy */
+	if (chunk->map[i] & 1)
+		goto eat_busy;
+
+eat_free:
+	/* Look for busy space
+	 * Last chunk is always busy, no need to check map_used
+	 */
+	for (start = i; !(chunk->map[i] & 1); ++i);
+
+	/* Collapse */
+	if (j != start) {
+		chunk->map[j] = chunk->map[start];
+	}
+	++j;
+
+	chunk->contig_hint = max(chunk->contig_hint,
+		(chunk->map[i] & ~1) - chunk->map[start]);
+
+eat_busy:
+	/* Look for free space */
+	for (start = i; i <= chunk->map_used && (chunk->map[i] & 1); ++i);
+
+	/* Move stuff if appropriate */
+	if (j != start) {
+		memmove(chunk->map + j, chunk->map + start, (i - start) * sizeof(*chunk->map));
+	}
+	j += i - start;
+
+	if (i > chunk->map_used)
+		goto end;
+	else
+		goto eat_free;
+
+end:
+	/* Done */
+	chunk->map_used = j - 1;
+	QP_PRINT_RATELIMIT("after chunk=%p first_free=%d map_used=%d\n", chunk, chunk->first_free, chunk->map_used);
+}
+
+/**
  * pcpu_need_to_extend - determine whether chunk area map needs to be extended
  * @chunk: chunk of interest
  * @is_atomic: the allocation context
@@ -408,6 +465,8 @@ static int pcpu_need_to_extend(struct pcpu_chunk *chunk, bool is_atomic)
 		margin = PCPU_ATOMIC_MAP_MARGIN_HIGH;
 	}
 
+	pcpu_merge_free_spaces(chunk);
+
 	if (chunk->map_alloc >= chunk->map_used + margin)
 		return 0;
 
@@ -674,7 +733,6 @@ static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme,
 	int oslot = pcpu_chunk_slot(chunk);
 	int off = 0;
 	unsigned i, j;
-	int to_free = 0;
 	int *p;
 
 	freeme |= 1;	/* we are searching for <given offset, in use> pair */
@@ -700,24 +758,6 @@ static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme,
 	*p = off &= ~1;
 	chunk->free_size += (p[1] & ~1) - off;
 
-	*occ_pages_p = pcpu_count_occupied_pages(chunk, i);
-
-	/* merge with next? */
-	if (!(p[1] & 1))
-		to_free++;
-	/* merge with previous? */
-	if (i > 0 && !(p[-1] & 1)) {
-		to_free++;
-		i--;
-		p--;
-	}
-	if (to_free) {
-		chunk->map_used -= to_free;
-		memmove(p + 1, p + 1 + to_free,
-			(chunk->map_used - i) * sizeof(chunk->map[0]));
-	}
-
-	chunk->contig_hint = max(chunk->map[i + 1] - chunk->map[i] - 1, chunk->contig_hint);
 	pcpu_chunk_relocate(chunk, oslot);
 }
