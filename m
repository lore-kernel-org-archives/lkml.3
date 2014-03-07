Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaCGCwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 21:52:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37439 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaCGCwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:52:10 -0500
Date: Fri, 7 Mar 2014 02:52:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 1/5][RFC][CFT] percpu fixes, part 1
Message-ID: <20140307025206.GB18016@ZenIV.linux.org.uk>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
 <20140305034919.GA26528@ZenIV.linux.org.uk>
 <20140306192026.GA14033@htj.dyndns.org>
 <20140306203030.GA18016@ZenIV.linux.org.uk>
 <20140306204726.GE14033@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <20140306204726.GE14033@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 06, 2014 at 03:47:26PM -0500, Tejun Heo wrote:

> Not much, but it should at least help bisection if something goes
> wrong, I think.

OK.  It looks better when folding pcpu_split_block() into the caller
is done as the first step.  See the attached 3 patches - combination
is the same, modulo comment addition and switching seen_free to bool.

--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-perpcu-fold-pcpu_split_block-into-the-only-caller.patch"

>From c58e32c7b5d750ae7caa5369a4a817e66fbd96c2 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 6 Mar 2014 21:08:24 -0500
Subject: [PATCH 1/3] perpcu: fold pcpu_split_block() into the only caller

... and simplify the results a bit.  Makes the next step easier
to deal with - we will be changing the data representation for
chunk->map[] and it's easier to do if the code in question is
not split between pcpu_alloc_area() and pcpu_split_block().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/percpu.c |   63 +++++++++++++++--------------------------------------------
 1 file changed, 16 insertions(+), 47 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 036cfe0..592f289 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -418,48 +418,6 @@ out_unlock:
 }
 
 /**
- * pcpu_split_block - split a map block
- * @chunk: chunk of interest
- * @i: index of map block to split
- * @head: head size in bytes (can be 0)
- * @tail: tail size in bytes (can be 0)
- *
- * Split the @i'th map block into two or three blocks.  If @head is
- * non-zero, @head bytes block is inserted before block @i moving it
- * to @i+1 and reducing its size by @head bytes.
- *
- * If @tail is non-zero, the target block, which can be @i or @i+1
- * depending on @head, is reduced by @tail bytes and @tail byte block
- * is inserted after the target block.
- *
- * @chunk->map must have enough free slots to accommodate the split.
- *
- * CONTEXT:
- * pcpu_lock.
- */
-static void pcpu_split_block(struct pcpu_chunk *chunk, int i,
-			     int head, int tail)
-{
-	int nr_extra = !!head + !!tail;
-
-	BUG_ON(chunk->map_alloc < chunk->map_used + nr_extra);
-
-	/* insert new subblocks */
-	memmove(&chunk->map[i + nr_extra], &chunk->map[i],
-		sizeof(chunk->map[0]) * (chunk->map_used - i));
-	chunk->map_used += nr_extra;
-
-	if (head) {
-		chunk->map[i + 1] = chunk->map[i] - head;
-		chunk->map[i++] = head;
-	}
-	if (tail) {
-		chunk->map[i++] -= tail;
-		chunk->map[i] = tail;
-	}
-}
-
-/**
  * pcpu_alloc_area - allocate area from a pcpu_chunk
  * @chunk: chunk of interest
  * @size: wanted size in bytes
@@ -524,14 +482,25 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 
 		/* split if warranted */
 		if (head || tail) {
-			pcpu_split_block(chunk, i, head, tail);
+			int nr_extra = !!head + !!tail;
+
+			/* insert new subblocks */
+			memmove(&chunk->map[i + nr_extra], &chunk->map[i],
+				sizeof(chunk->map[0]) * (chunk->map_used - i));
+			chunk->map_used += nr_extra;
+
 			if (head) {
-				i++;
+				chunk->map[i + 1] = chunk->map[i] - head;
+				chunk->map[i] = head;
 				off += head;
-				max_contig = max(chunk->map[i - 1], max_contig);
+				i++;
+				max_contig = max(head, max_contig);
+			}
+			if (tail) {
+				chunk->map[i] -= tail;
+				chunk->map[i + 1] = tail;
+				max_contig = max(tail, max_contig);
 			}
-			if (tail)
-				max_contig = max(chunk->map[i + 1], max_contig);
 		}
 
 		/* update hint and mark allocated */
-- 
1.7.10.4


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-percpu-store-offsets-instead-of-lengths-in-map.patch"

>From d9b884b48114b60da0be9bc2fe35f6a5b1456520 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 6 Mar 2014 21:13:18 -0500
Subject: [PATCH 2/3] percpu: store offsets instead of lengths in ->map[]

Current code keeps +-length for each area in chunk->map[].  It has
several unpleasant consequences:
	* even if we know that first 50 areas are all in use, allocation
still needs to go through all those areas just to sum their sizes, just
to get the offset of free one.
	* freeing needs to find the array entry refering to the area
in question; again, the need to sum the sizes until we reach the offset
we are interested in.  Note that offsets are monotonous, so simple
binary search would do here.

	New data representation: array of <offset,in-use flag> pairs.
Each pair is represented by one int - we use offset|1 for <offset, in use>
and offset for <offset, free> (we make sure that all offsets are even).
In the end we put a sentry entry - <total size, in use>.  The first
entry is <0, flag>; it would be possible to store together the flag
for Nth area and offset for N+1st, but that leads to much hairier code.

In other words, where the old variant would have
	4, -8, -4, 4, -12, 100
(4 bytes free, 8 in use, 4 in use, 4 free, 12 in use, 100 free) we store
	<0,0>, <4,1>, <12,1>, <16,0>, <20,1>, <32,0>, <132,1>
i.e.
	0, 5, 13, 16, 21, 32, 133

This commit switches to new data representation and takes care of a couple
of low-hanging fruits in free_pcpu_area() - one is the switch to binary
search, another is not doing two memmove() when one would do.  Speeding
the alloc side up (by keeping track of how many areas in the beginning are
known to be all in use) also becomes possible - that'll be done in the next
commit.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/percpu.c |  136 +++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 81 insertions(+), 55 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 592f289..f82cc21 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -102,7 +102,7 @@ struct pcpu_chunk {
 	int			free_size;	/* free bytes in the chunk */
 	int			contig_hint;	/* max contiguous size hint */
 	void			*base_addr;	/* base address of this chunk */
-	int			map_used;	/* # of map entries used */
+	int			map_used;	/* # of map entries used before the sentry */
 	int			map_alloc;	/* # of map entries allocated */
 	int			*map;		/* allocation map */
 	void			*data;		/* chunk data */
@@ -356,11 +356,11 @@ static int pcpu_need_to_extend(struct pcpu_chunk *chunk)
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
@@ -441,19 +441,22 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 	int oslot = pcpu_chunk_slot(chunk);
 	int max_contig = 0;
 	int i, off;
+	int *p;
 
-	for (i = 0, off = 0; i < chunk->map_used; off += abs(chunk->map[i++])) {
-		bool is_last = i + 1 == chunk->map_used;
+	for (i = 0, p = chunk->map; i < chunk->map_used; i++, p++) {
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
+			max_contig = max(this_size, max_contig);
 			continue;
 		}
 
@@ -463,55 +466,50 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
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
 			int nr_extra = !!head + !!tail;
 
 			/* insert new subblocks */
-			memmove(&chunk->map[i + nr_extra], &chunk->map[i],
+			memmove(p + nr_extra + 1, p + 1,
 				sizeof(chunk->map[0]) * (chunk->map_used - i));
 			chunk->map_used += nr_extra;
 
 			if (head) {
-				chunk->map[i + 1] = chunk->map[i] - head;
-				chunk->map[i] = head;
-				off += head;
-				i++;
+				*++p = off += head;
+				++i;
 				max_contig = max(head, max_contig);
 			}
 			if (tail) {
-				chunk->map[i] -= tail;
-				chunk->map[i + 1] = tail;
+				p[1] = off + size;
 				max_contig = max(tail, max_contig);
 			}
 		}
 
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
@@ -539,34 +537,47 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
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
+	freeme |= 1;	/* we are searching for <given offset, in use> pair */
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
 
@@ -586,7 +597,9 @@ static struct pcpu_chunk *pcpu_alloc_chunk(void)
 	}
 
 	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
-	chunk->map[chunk->map_used++] = pcpu_unit_size;
+	chunk->map[0] = 0;
+	chunk->map[1] = pcpu_unit_size | 1;
+	chunk->map_used = 1;
 
 	INIT_LIST_HEAD(&chunk->list);
 	chunk->free_size = pcpu_unit_size;
@@ -682,6 +695,13 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 	unsigned long flags;
 	void __percpu *ptr;
 
+	/*
+	 * We want the lowest bit of offset available for in-use/free
+	 * indicator.
+	 */
+	if (unlikely(align < 2))
+		align = 2;
+
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
 		     "percpu allocation\n", size, align);
@@ -1312,9 +1332,13 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
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
@@ -1327,8 +1351,10 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
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


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0003-percpu-speed-alloc_pcpu_area-up.patch"

>From 76ffa9a3ed635a860a1b7de612f2552fbf46a775 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 6 Mar 2014 20:52:32 -0500
Subject: [PATCH 3/3] percpu: speed alloc_pcpu_area() up

If we know that first N areas are all in use, we can obviously skip
them when searching for a free one.  And that kind of hint is very
easy to maintain.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/percpu.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index f82cc21..5bb658a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -106,6 +106,7 @@ struct pcpu_chunk {
 	int			map_alloc;	/* # of map entries allocated */
 	int			*map;		/* allocation map */
 	void			*data;		/* chunk data */
+	int			first_free;	/* no free below this */
 	bool			immutable;	/* no [de]population allowed */
 	unsigned long		populated[];	/* populated bitmap */
 };
@@ -441,9 +442,10 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 	int oslot = pcpu_chunk_slot(chunk);
 	int max_contig = 0;
 	int i, off;
+	bool seen_free = false;
 	int *p;
 
-	for (i = 0, p = chunk->map; i < chunk->map_used; i++, p++) {
+	for (i = chunk->first_free, p = chunk->map + i; i < chunk->map_used; i++, p++) {
 		int head, tail;
 		int this_size;
 
@@ -456,6 +458,10 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 
 		this_size = (p[1] & ~1) - off;
 		if (this_size < head + size) {
+			if (!seen_free) {
+				chunk->first_free = i;
+				seen_free = true;
+			}
 			max_contig = max(this_size, max_contig);
 			continue;
 		}
@@ -491,6 +497,10 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 			chunk->map_used += nr_extra;
 
 			if (head) {
+				if (!seen_free) {
+					chunk->first_free = i;
+					seen_free = true;
+				}
 				*++p = off += head;
 				++i;
 				max_contig = max(head, max_contig);
@@ -501,6 +511,9 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 			}
 		}
 
+		if (!seen_free)
+			chunk->first_free = i + 1;
+
 		/* update hint and mark allocated */
 		if (i + 1 == chunk->map_used)
 			chunk->contig_hint = max_contig; /* fully scanned */
@@ -558,6 +571,9 @@ static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
 	}
 	BUG_ON(off != freeme);
 
+	if (i < chunk->first_free)
+		chunk->first_free = i;
+
 	p = chunk->map + i;
 	*p = off &= ~1;
 	chunk->free_size += (p[1] & ~1) - off;
-- 
1.7.10.4


--kfjH4zxOES6UT95V--
