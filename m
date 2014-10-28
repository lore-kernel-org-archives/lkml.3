Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaJ1Dg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:36:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbaJ1DgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:36:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.17 006/146] btrfs: Fix and enhance merge_extent_mapping() to insert best fitted extent map
Date: Tue, 28 Oct 2014 11:32:28 +0800
Message-Id: <20141028033343.719599389@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

commit e6c4efd87ab04e5ead363f24e6ac35ed3506d401 upstream.

The following commit enhanced the merge_extent_mapping() to reduce
fragment in extent map tree, but it can't handle case which existing
lies before map_start:
51f39 btrfs: Use right extent length when inserting overlap extent map.

[BUG]
When existing extent map's start is before map_start,
the em->len will be minus, which will corrupt the extent map and fail to
insert the new extent map.
This will happen when someone get a large extent map, but when it is
going to insert it into extent map tree, some one has already commit
some write and split the huge extent into small parts.

[REPRODUCER]
It is very easy to tiger using filebench with randomrw personality.
It is about 100% to reproduce when using 8G preallocated file in 60s
randonrw test.

[FIX]
This patch can now handle any existing extent position.
Since it does not directly use existing->start, now it will find the
previous and next extent around map_start.
So the old existing->start < map_start bug will never happen again.

[ENHANCE]
This patch will insert the best fitted extent map into extent map tree,
other than the oldest [map_start, map_start + sectorsize) or the
relatively newer but not perfect [map_start, existing->start).

The patch will first search existing extent that does not intersects with
the desired map range [map_start, map_start + len).
The existing extent will be either before or behind map_start, and based
on the existing extent, we can find out the previous and next extent
around map_start.

So the best fitted extent would be [prev->end, next->start).
For prev or next is not found, em->start would be prev->end and em->end
wold be next->start.

With this patch, the fragment in extent map tree should be reduced much
more than the 51f39 commit and reduce an unneeded extent map tree search.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   79 +++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 22 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6191,21 +6191,60 @@ out_fail_inode:
 	goto out_fail;
 }
 
+/* Find next extent map of a given extent map, caller needs to ensure locks */
+static struct extent_map *next_extent_map(struct extent_map *em)
+{
+	struct rb_node *next;
+
+	next = rb_next(&em->rb_node);
+	if (!next)
+		return NULL;
+	return container_of(next, struct extent_map, rb_node);
+}
+
+static struct extent_map *prev_extent_map(struct extent_map *em)
+{
+	struct rb_node *prev;
+
+	prev = rb_prev(&em->rb_node);
+	if (!prev)
+		return NULL;
+	return container_of(prev, struct extent_map, rb_node);
+}
+
 /* helper for btfs_get_extent.  Given an existing extent in the tree,
+ * the existing extent is the nearest extent to map_start,
  * and an extent that you want to insert, deal with overlap and insert
- * the new extent into the tree.
+ * the best fitted new extent into the tree.
  */
 static int merge_extent_mapping(struct extent_map_tree *em_tree,
 				struct extent_map *existing,
 				struct extent_map *em,
 				u64 map_start)
 {
+	struct extent_map *prev;
+	struct extent_map *next;
+	u64 start;
+	u64 end;
 	u64 start_diff;
 
 	BUG_ON(map_start < em->start || map_start >= extent_map_end(em));
-	start_diff = map_start - em->start;
-	em->start = map_start;
-	em->len = existing->start - em->start;
+
+	if (existing->start > map_start) {
+		next = existing;
+		prev = prev_extent_map(next);
+	} else {
+		prev = existing;
+		next = next_extent_map(prev);
+	}
+
+	start = prev ? extent_map_end(prev) : em->start;
+	start = max_t(u64, start, em->start);
+	end = next ? next->start : extent_map_end(em);
+	end = min_t(u64, end, extent_map_end(em));
+	start_diff = start - em->start;
+	em->start = start;
+	em->len = end - start;
 	if (em->block_start < EXTENT_MAP_LAST_BYTE &&
 	    !test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
 		em->block_start += start_diff;
@@ -6482,25 +6521,21 @@ insert:
 
 		ret = 0;
 
-		existing = lookup_extent_mapping(em_tree, start, len);
-		if (existing && (existing->start > start ||
-		    existing->start + existing->len <= start)) {
+		existing = search_extent_mapping(em_tree, start, len);
+		/*
+		 * existing will always be non-NULL, since there must be
+		 * extent causing the -EEXIST.
+		 */
+		if (start >= extent_map_end(existing) ||
+		    start + len <= existing->start) {
+			/*
+			 * The existing extent map is the one nearest to
+			 * the [start, start + len) range which overlaps
+			 */
+			err = merge_extent_mapping(em_tree, existing,
+						   em, start);
 			free_extent_map(existing);
-			existing = NULL;
-		}
-		if (!existing) {
-			existing = lookup_extent_mapping(em_tree, em->start,
-							 em->len);
-			if (existing) {
-				err = merge_extent_mapping(em_tree, existing,
-							   em, start);
-				free_extent_map(existing);
-				if (err) {
-					free_extent_map(em);
-					em = NULL;
-				}
-			} else {
-				err = -EIO;
+			if (err) {
 				free_extent_map(em);
 				em = NULL;
 			}


