Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaCEDuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:50:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49125 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901AbaCEDuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:50:10 -0500
Date: Wed, 5 Mar 2014 03:50:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 2/5][RFC][CFT] fold pcpu_split_block() into the only caller
Message-ID: <20140305035009.GB26528@ZenIV.linux.org.uk>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305034751.GW18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and clean it up a bit

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/percpu.c |   58 ++++++++++++----------------------------------------------
 1 file changed, 12 insertions(+), 46 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 4469fbd..383801e 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -419,47 +419,6 @@ out_unlock:
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
-			     int head, int size, int tail)
-{
-	int nr_extra = !!head + !!tail;
-	int off;
-
-	BUG_ON(chunk->map_alloc <= chunk->map_used + nr_extra);
-
-	/* insert new subblocks */
-	memmove(&chunk->map[i + nr_extra] + 1, &chunk->map[i] + 1,
-		sizeof(chunk->map[0]) * (chunk->map_used - i));
-	chunk->map_used += nr_extra;
-
-	off = chunk->map[i];
-
-	if (head)
-		chunk->map[++i] = off += head;
-	if (tail)
-		chunk->map[++i] = off += size;
-}
-
-/**
  * pcpu_alloc_area - allocate area from a pcpu_chunk
  * @chunk: chunk of interest
  * @size: wanted size in bytes
@@ -530,19 +489,26 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 
 		/* split if warranted */
 		if (head || tail) {
-			pcpu_split_block(chunk, i, head, size, tail);
+			int nr_extra = !!head + !!tail;
+
+			/* insert new subblocks */
+			memmove(p + nr_extra + 1, p + 1,
+				sizeof(chunk->map[0]) * (chunk->map_used - i));
+			chunk->map_used += nr_extra;
+
 			if (head) {
 				if (!seen_free) {
 					chunk->first_free = i;
 					seen_free = 1;
 				}
-				i++;
-				p++;
-				off += head;
+				*++p = off += head;
+				++i;
 				max_contig = max(head, max_contig);
 			}
-			if (tail)
+			if (tail) {
+				p[1] = off + size;
 				max_contig = max(tail, max_contig);
+			}
 		}
 
 		if (!seen_free)
-- 
1.7.10.4

