Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240AbaLBWtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:49:52 -0500
Received: from mail-bl2on0085.outbound.protection.outlook.com ([65.55.169.85]:32784
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933086AbaLBWtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:49:50 -0500
Message-ID: <547E3E57.3040908@ixiacom.com>
Date: Wed, 3 Dec 2014 00:33:59 +0200
From: Leonard Crestez <lcrestez@ixiacom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        "Christoph Lameter" <cl@linux-foundation.org>,
        Sorin Dumitru <sdumitru@ixiacom.com>
Subject: [RFC v2] percpu: Add a separate function to merge free areas
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [205.168.23.154]
X-ClientProxiedBy: CO2PR06CA052.namprd06.prod.outlook.com (10.141.242.52) To
 CY1PR0601MB1163.namprd06.prod.outlook.com (25.160.167.20)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0601MB1163;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0601MB1163;
X-Forefront-PRVS: 0413C9F1ED
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(199003)(189002)(23746002)(99396003)(122386002)(105586002)(87976001)(120916001)(40100003)(102836001)(15975445006)(83506001)(33656002)(80316001)(77096005)(19580405001)(95666004)(97736003)(68736005)(2351001)(19580395003)(86362001)(92566001)(92726001)(106356001)(107046002)(101416001)(110136001)(46102003)(229853001)(87266999)(54356999)(65816999)(50986999)(21056001)(66066001)(31966008)(4396001)(50466002)(42186005)(62966003)(64126003)(47776003)(20776003)(59896002)(64706001)(36756003)(77156002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0601MB1163;H:[10.205.20.121];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0601MB1163;
X-OriginatorOrg: ixiacom.com
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 205.168.23.154
X-MS-Exchange-CrossPremises-AuthSource: CY1PR0601MB1163.namprd06.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-AVStamp-Service: 1.0
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: CY1PR0601MB1163.namprd06.prod.outlook.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It seems that free_percpu performance is very bad when working with small 
objects. The easiest way to reproduce this is to allocate and then free a large 
number of percpu int counters in order. Small objects (reference counters and 
pointers) are common users of alloc_percpu and I think this should be fast.
This particular issue can be encountered with very large number of net_device
structs.

The problem seems to be that pcpu_chunk keeps an array of all alocated areas. At 
free time pcpu_free_area will delete items from that array linearly, using 
memmove. This has worst-case quadratic complexity in the number of areas per 
chunk. This gets really bad if the areas are small and are allocated and freed in order.

One way to fix this is to merge free areas in a separate function and handle
multiple frees at once. There is a patch below which does this, but
I'm not sure it's correct.

Instead of merging free areas on every free we only do it when 2/3 of
the slots in the map are used. This should hopefully amortize to linear
complexity instead of quadratic.

I've posted an earlier version of this to lkml earlier but got no response. That
was probably because I only posted to lkml. I now sent to linux-mm and the people
reported by "get_maintainer.pl". Here's a link to the older post:

https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg777188.html

That version of the patch is incorrect. Never updating contig_hint on free means
that once a chunk's contig_hint reaches 0 (when completely allocated) that chunk
will never be considered for allocation again. It also doesn't amortize the frees.

Entirely different solutions could be considered. For example it might make sense to
make chunks smaller (they are about ~40K on the system I care about). Or maybe even
write an entirely custom allocator for very small fixed-size percpu objects.

Signed-off-by: Crestez Dan Leonard <lcrestez@ixiacom.com>
---
 mm/percpu.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 78 insertions(+), 22 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 014bab6..9d85198 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -109,6 +109,7 @@ struct pcpu_chunk {
 
 	int			map_used;	/* # of map entries used before the sentry */
 	int			map_alloc;	/* # of map entries allocated */
+	int			map_free_count;	/* # of map entries freed but not merged */
 	int			*map;		/* allocation map */
 	struct work_struct	map_extend_work;/* async ->map[] extension */
 
@@ -375,6 +376,69 @@ static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
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
+	chunk->map_free_count = 0;
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
+	if (j != start)
+		chunk->map[j] = chunk->map[start];
+	++chunk->map_free_count;
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
+	if (j != start)
+		memmove(chunk->map + j, chunk->map + start, (i - start) * sizeof(*chunk->map));
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
+}
+
+static inline void pcpu_check_merge_free_spaces(struct pcpu_chunk *chunk)
+{
+	if (chunk->map_free_count * 3 >= chunk->map_used * 2)
+		pcpu_merge_free_spaces(chunk);
+}
+
+/**
  * pcpu_need_to_extend - determine whether chunk area map needs to be extended
  * @chunk: chunk of interest
  * @is_atomic: the allocation context
@@ -623,10 +687,12 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align,
 				*++p = off += head;
 				++i;
 				max_contig = max(head, max_contig);
+				chunk->map_free_count++;
 			}
 			if (tail) {
 				p[1] = off + size;
 				max_contig = max(tail, max_contig);
+				chunk->map_free_count++;
 			}
 		}
 
@@ -641,6 +707,7 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align,
 						 max_contig);
 
 		chunk->free_size -= size;
+		chunk->map_free_count--;
 		*p |= 1;
 
 		*occ_pages_p = pcpu_count_occupied_pages(chunk, i);
@@ -674,8 +741,7 @@ static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme,
 	int oslot = pcpu_chunk_slot(chunk);
 	int off = 0;
 	unsigned i, j;
-	int to_free = 0;
-	int *p;
+	int this_size;
 
 	freeme |= 1;	/* we are searching for <given offset, in use> pair */
 
@@ -696,28 +762,15 @@ static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme,
 	if (i < chunk->first_free)
 		chunk->first_free = i;
 
-	p = chunk->map + i;
-	*p = off &= ~1;
-	chunk->free_size += (p[1] & ~1) - off;
-
+	/* Mark this area as free */
+	chunk->map[i] &= ~1;
+	this_size = (chunk->map[i + 1] & ~1) - chunk->map[i];
+	chunk->free_size += this_size;
 	*occ_pages_p = pcpu_count_occupied_pages(chunk, i);
+	chunk->contig_hint = max(chunk->contig_hint, this_size);
+	chunk->map_free_count++;
 
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
+	pcpu_check_merge_free_spaces(chunk);
 	pcpu_chunk_relocate(chunk, oslot);
 }
 
@@ -740,6 +793,7 @@ static struct pcpu_chunk *pcpu_alloc_chunk(void)
 	chunk->map[0] = 0;
 	chunk->map[1] = pcpu_unit_size | 1;
 	chunk->map_used = 1;
+	chunk->map_free_count = 1;
 
 	INIT_LIST_HEAD(&chunk->list);
 	INIT_WORK(&chunk->map_extend_work, pcpu_map_extend_workfn);
@@ -1669,6 +1723,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	schunk->map[0] = 1;
 	schunk->map[1] = ai->static_size;
 	schunk->map_used = 1;
+	schunk->map_free_count = 1;
 	if (schunk->free_size)
 		schunk->map[++schunk->map_used] = 1 | (ai->static_size + schunk->free_size);
 	else
@@ -1691,6 +1746,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 		dchunk->map[1] = pcpu_reserved_chunk_limit;
 		dchunk->map[2] = (pcpu_reserved_chunk_limit + dchunk->free_size) | 1;
 		dchunk->map_used = 2;
+		dchunk->map_free_count = 1;
 	}
 
 	/* link the first chunk in */
-- 
2.1.3

