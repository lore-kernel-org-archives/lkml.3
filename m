Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbaCEDtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:49:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49120 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbaCEDtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:49:20 -0500
Date: Wed, 5 Mar 2014 03:49:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 1/5][RFC][CFT] percpu fixes, part 1
Message-ID: <20140305034919.GA26528@ZenIV.linux.org.uk>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305034751.GW18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert ->map[] to array of offsets, cache the "no free areas among the
first N" in chunk.  Free/in-use is represented by the LSB, a sentry
element (<free = false, offset = total size of chunk>) is added in
the end.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/percpu.c |  165 +++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 103 insertions(+), 62 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 036cfe0..4469fbd 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -102,10 +102,11 @@ struct pcpu_chunk {
 	int			free_size;	/* free bytes in the chunk */
 	int			contig_hint;	/* max contiguous size hint */
 	void			*base_addr;	/* base address of this chunk */
-	int			map_used;	/* # of map entries used */
+	int			map_used;	/* # of map entries used before the sentry */
 	int			map_alloc;	/* # of map entries allocated */
 	int			*map;		/* allocation map */
 	void			*data;		/* chunk data */
+	int			first_free;	/* no free below this */
 	bool			immutable;	/* no [de]population allowed */
 	unsigned long		populated[];	/* populated bitmap */
 };
@@ -356,11 +357,11 @@ static int pcpu_need_to_extend(struct pcpu_chunk *chunk)
 {
 	int new_alloc;
 
-	if (chunk->map_alloc >= chunk->map_used + 2)
+	if (chunk->map_alloc >= chunk->map_used + 3)
 		return 0;
 
 	new_alloc = PCPU_DFL_MAP_ALLOC;
-	while (new_alloc < chunk->map_used + 2)
+	while (new_alloc < chunk->map_used + 3)
 		new_alloc *= 2;
 
 	return new_alloc;
@@ -438,25 +439,24 @@ out_unlock:
  * pcpu_lock.
  */
 static void pcpu_split_block(struct pcpu_chunk *chunk, int i,
-			     int head, int tail)
+			     int head, int size, int tail)
 {
 	int nr_extra = !!head + !!tail;
+	int off;
 
-	BUG_ON(chunk->map_alloc < chunk->map_used + nr_extra);
+	BUG_ON(chunk->map_alloc <= chunk->map_used + nr_extra);
 
 	/* insert new subblocks */
-	memmove(&chunk->map[i + nr_extra], &chunk->map[i],
+	memmove(&chunk->map[i + nr_extra] + 1, &chunk->map[i] + 1,
 		sizeof(chunk->map[0]) * (chunk->map_used - i));
 	chunk->map_used += nr_extra;
 
-	if (head) {
-		chunk->map[i + 1] = chunk->map[i] - head;
-		chunk->map[i++] = head;
-	}
-	if (tail) {
-		chunk->map[i++] -= tail;
-		chunk->map[i] = tail;
-	}
+	off = chunk->map[i];
+
+	if (head)
+		chunk->map[++i] = off += head;
+	if (tail)
+		chunk->map[++i] = off += size;
 }
 
 /**
@@ -483,19 +483,27 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 	int oslot = pcpu_chunk_slot(chunk);
 	int max_contig = 0;
 	int i, off;
+	int seen_free = 0;
+	int *p;
 
-	for (i = 0, off = 0; i < chunk->map_used; off += abs(chunk->map[i++])) {
-		bool is_last = i + 1 == chunk->map_used;
+	for (i = chunk->first_free, p = chunk->map + i; i < chunk->map_used; i++, p++) {
 		int head, tail;
+		int this_size;
+
+		off = *p;
+		if (off & 1)
+			continue;
 
 		/* extra for alignment requirement */
 		head = ALIGN(off, align) - off;
-		BUG_ON(i == 0 && head != 0);
 
-		if (chunk->map[i] < 0)
-			continue;
-		if (chunk->map[i] < head + size) {
-			max_contig = max(chunk->map[i], max_contig);
+		this_size = (p[1] & ~1) - off;
+		if (this_size < head + size) {
+			if (!seen_free) {
+				chunk->first_free = i;
+				seen_free = 1;
+			}
+			max_contig = max(this_size, max_contig);
 			continue;
 		}
 
@@ -505,44 +513,50 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 		 * than sizeof(int), which is very small but isn't too
 		 * uncommon for percpu allocations.
 		 */
-		if (head && (head < sizeof(int) || chunk->map[i - 1] > 0)) {
-			if (chunk->map[i - 1] > 0)
-				chunk->map[i - 1] += head;
-			else {
-				chunk->map[i - 1] -= head;
+		if (head && (head < sizeof(int) || !(p[-1] & 1))) {
+			if (p[-1] & 1)
 				chunk->free_size -= head;
-			}
-			chunk->map[i] -= head;
-			off += head;
+			*p = off += head;
+			this_size -= head;
 			head = 0;
 		}
 
 		/* if tail is small, just keep it around */
-		tail = chunk->map[i] - head - size;
-		if (tail < sizeof(int))
+		tail = this_size - head - size;
+		if (tail < sizeof(int)) {
 			tail = 0;
+			size = this_size - head;
+		}
 
 		/* split if warranted */
 		if (head || tail) {
-			pcpu_split_block(chunk, i, head, tail);
+			pcpu_split_block(chunk, i, head, size, tail);
 			if (head) {
+				if (!seen_free) {
+					chunk->first_free = i;
+					seen_free = 1;
+				}
 				i++;
+				p++;
 				off += head;
-				max_contig = max(chunk->map[i - 1], max_contig);
+				max_contig = max(head, max_contig);
 			}
 			if (tail)
-				max_contig = max(chunk->map[i + 1], max_contig);
+				max_contig = max(tail, max_contig);
 		}
 
+		if (!seen_free)
+			chunk->first_free = i + 1;
+
 		/* update hint and mark allocated */
-		if (is_last)
+		if (i + 1 == chunk->map_used)
 			chunk->contig_hint = max_contig; /* fully scanned */
 		else
 			chunk->contig_hint = max(chunk->contig_hint,
 						 max_contig);
 
-		chunk->free_size -= chunk->map[i];
-		chunk->map[i] = -chunk->map[i];
+		chunk->free_size -= size;
+		*p |= 1;
 
 		pcpu_chunk_relocate(chunk, oslot);
 		return off;
@@ -570,34 +584,50 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
 {
 	int oslot = pcpu_chunk_slot(chunk);
-	int i, off;
-
-	for (i = 0, off = 0; i < chunk->map_used; off += abs(chunk->map[i++]))
-		if (off == freeme)
-			break;
+	int off = 0;
+	unsigned i, j;
+	int to_free = 0;
+	int *p;
+
+	freeme |= 1;
+
+	i = 0;
+	j = chunk->map_used;
+	while (i != j) {
+		unsigned k = (i + j) / 2;
+		off = chunk->map[k];
+		if (off < freeme)
+			i = k + 1;
+		else if (off > freeme)
+			j = k;
+		else
+			i = j = k;
+	}
 	BUG_ON(off != freeme);
-	BUG_ON(chunk->map[i] > 0);
 
-	chunk->map[i] = -chunk->map[i];
-	chunk->free_size += chunk->map[i];
+	if (i < chunk->first_free)
+		chunk->first_free = i;
+
+	p = chunk->map + i;
+	*p = off &= ~1;
+	chunk->free_size += (p[1] & ~1) - off;
 
+	/* merge with next? */
+	if (!(p[1] & 1))
+		to_free++;
 	/* merge with previous? */
-	if (i > 0 && chunk->map[i - 1] >= 0) {
-		chunk->map[i - 1] += chunk->map[i];
-		chunk->map_used--;
-		memmove(&chunk->map[i], &chunk->map[i + 1],
-			(chunk->map_used - i) * sizeof(chunk->map[0]));
+	if (i > 0 && !(p[-1] & 1)) {
+		to_free++;
 		i--;
+		p--;
 	}
-	/* merge with next? */
-	if (i + 1 < chunk->map_used && chunk->map[i + 1] >= 0) {
-		chunk->map[i] += chunk->map[i + 1];
-		chunk->map_used--;
-		memmove(&chunk->map[i + 1], &chunk->map[i + 2],
-			(chunk->map_used - (i + 1)) * sizeof(chunk->map[0]));
+	if (to_free) {
+		chunk->map_used -= to_free;
+		memmove(p + 1, p + 1 + to_free, 
+			(chunk->map_used - i) * sizeof(chunk->map[0]));
 	}
 
-	chunk->contig_hint = max(chunk->map[i], chunk->contig_hint);
+	chunk->contig_hint = max(chunk->map[i + 1] - chunk->map[i] - 1, chunk->contig_hint);
 	pcpu_chunk_relocate(chunk, oslot);
 }
 
@@ -617,7 +647,9 @@ static struct pcpu_chunk *pcpu_alloc_chunk(void)
 	}
 
 	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
-	chunk->map[chunk->map_used++] = pcpu_unit_size;
+	chunk->map[0] = 0;
+	chunk->map[1] = pcpu_unit_size | 1;
+	chunk->map_used = 1;
 
 	INIT_LIST_HEAD(&chunk->list);
 	chunk->free_size = pcpu_unit_size;
@@ -713,6 +745,9 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 	unsigned long flags;
 	void __percpu *ptr;
 
+	if (unlikely(align < 2))
+		align = 2;
+
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
 		     "percpu allocation\n", size, align);
@@ -1343,9 +1378,13 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	}
 	schunk->contig_hint = schunk->free_size;
 
-	schunk->map[schunk->map_used++] = -ai->static_size;
+	schunk->map[0] = 1;
+	schunk->map[1] = ai->static_size;
+	schunk->map_used = 1;
 	if (schunk->free_size)
-		schunk->map[schunk->map_used++] = schunk->free_size;
+		schunk->map[++schunk->map_used] = 1 | (ai->static_size + schunk->free_size);
+	else
+		schunk->map[1] |= 1;
 
 	/* init dynamic chunk if necessary */
 	if (dyn_size) {
@@ -1358,8 +1397,10 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 		bitmap_fill(dchunk->populated, pcpu_unit_pages);
 
 		dchunk->contig_hint = dchunk->free_size = dyn_size;
-		dchunk->map[dchunk->map_used++] = -pcpu_reserved_chunk_limit;
-		dchunk->map[dchunk->map_used++] = dchunk->free_size;
+		dchunk->map[0] = 1;
+		dchunk->map[1] = pcpu_reserved_chunk_limit;
+		dchunk->map[2] = (pcpu_reserved_chunk_limit + dchunk->free_size) | 1;
+		dchunk->map_used = 2;
 	}
 
 	/* link the first chunk in */
-- 
1.7.10.4

