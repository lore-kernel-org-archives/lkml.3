Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3IXGTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:19:18 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46306 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab3IXGTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:19:14 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 10/11] bcache: Fix for handling overlapping extents when reading in a btree node
Date: Mon, 23 Sep 2013 23:17:35 -0700
Message-Id: <1380003456-19938-11-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btree_sort_fixup() was overly clever, because it was trying to avoid
pulling a key off the btree iterator in more than one place.

This led to a really obscure bug where we'd break early from the loop in
btree_sort_fixup() if the current key overlapped with keys in more than
one older set, and the next key it overlapped with was zero size.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/bset.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 8010eed..22d1ae7 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -926,28 +926,45 @@ struct bkey *bch_next_recurse_key(struct btree *b, struct bkey *search)
 
 /* Mergesort */
 
+static void sort_key_next(struct btree_iter *iter,
+			  struct btree_iter_set *i)
+{
+	i->k = bkey_next(i->k);
+
+	if (i->k == i->end)
+		*i = iter->data[--iter->used];
+}
+
 static void btree_sort_fixup(struct btree_iter *iter)
 {
 	while (iter->used > 1) {
 		struct btree_iter_set *top = iter->data, *i = top + 1;
-		struct bkey *k;
 
 		if (iter->used > 2 &&
 		    btree_iter_cmp(i[0], i[1]))
 			i++;
 
-		for (k = i->k;
-		     k != i->end && bkey_cmp(top->k, &START_KEY(k)) > 0;
-		     k = bkey_next(k))
-			if (top->k > i->k)
-				__bch_cut_front(top->k, k);
-			else if (KEY_SIZE(k))
-				bch_cut_back(&START_KEY(k), top->k);
-
-		if (top->k < i->k || k == i->k)
+		if (bkey_cmp(top->k, &START_KEY(i->k)) <= 0)
 			break;
 
-		heap_sift(iter, i - top, btree_iter_cmp);
+		if (!KEY_SIZE(i->k)) {
+			sort_key_next(iter, i);
+			heap_sift(iter, i - top, btree_iter_cmp);
+			continue;
+		}
+
+		if (top->k > i->k) {
+			if (bkey_cmp(top->k, i->k) >= 0)
+				sort_key_next(iter, i);
+			else
+				bch_cut_front(top->k, i->k);
+
+			heap_sift(iter, i - top, btree_iter_cmp);
+		} else {
+			/* can't happen because of comparison func */
+			BUG_ON(!bkey_cmp(&START_KEY(top->k), &START_KEY(i->k)));
+			bch_cut_back(&START_KEY(i->k), top->k);
+		}
 	}
 }
 
-- 
1.8.4.rc3

