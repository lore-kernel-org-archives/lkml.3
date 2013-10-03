Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3JCERE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:17:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab3JCERB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:17:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 10/57] bcache: Fix for handling overlapping extents when reading in a btree node
Date: Wed,  2 Oct 2013 21:08:36 -0700
Message-Id: <20131003040637.309476274@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit 84786438ed17978d72eeced580ab757e4da8830b upstream.

btree_sort_fixup() was overly clever, because it was trying to avoid
pulling a key off the btree iterator in more than one place.

This led to a really obscure bug where we'd break early from the loop in
btree_sort_fixup() if the current key overlapped with keys in more than
one older set, and the next key it overlapped with was zero size.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/bset.c |   39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -926,28 +926,45 @@ struct bkey *bch_next_recurse_key(struct
 
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
 


