Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbaBDVCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:02:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933412AbaBDVCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 3.10 072/104] bcache: Data corruption fix
Date: Tue,  4 Feb 2014 13:02:15 -0800
Message-Id: <20140204210224.753302761@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit ef71ec00002d92a08eb27e9d036e3d48835b6597 upstream.

The code that handles overlapping extents that we've just read back in from disk
was depending on the behaviour of the code that handles overlapping extents as
we're inserting into a btree node in the case of an insert that forced an
existing extent to be split: on insert, if we had to split we'd also insert a
new extent to represent the top part of the old extent - and then that new
extent would get written out.

The code that read the extents back in thus not bother with splitting extents -
if it saw an extent that ovelapped in the middle of an older extent, it would
trim the old extent to only represent the bottom part, assuming that the
original insert would've inserted a new extent to represent the top part.

I still haven't figured out _how_ it can happen, but I'm now pretty convinced
(and testing has confirmed) that there's some kind of an obscure corner case
(probably involving extent merging, and multiple overwrites in different sets)
that breaks this. The fix is to change the mergesort fixup code to split extents
itself when required.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/bset.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -927,7 +927,7 @@ static void sort_key_next(struct btree_i
 		*i = iter->data[--iter->used];
 }
 
-static void btree_sort_fixup(struct btree_iter *iter)
+static struct bkey *btree_sort_fixup(struct btree_iter *iter, struct bkey *tmp)
 {
 	while (iter->used > 1) {
 		struct btree_iter_set *top = iter->data, *i = top + 1;
@@ -955,9 +955,22 @@ static void btree_sort_fixup(struct btre
 		} else {
 			/* can't happen because of comparison func */
 			BUG_ON(!bkey_cmp(&START_KEY(top->k), &START_KEY(i->k)));
-			bch_cut_back(&START_KEY(i->k), top->k);
+
+			if (bkey_cmp(i->k, top->k) < 0) {
+				bkey_copy(tmp, top->k);
+
+				bch_cut_back(&START_KEY(i->k), tmp);
+				bch_cut_front(i->k, top->k);
+				heap_sift(iter, 0, btree_iter_cmp);
+
+				return tmp;
+			} else {
+				bch_cut_back(&START_KEY(i->k), top->k);
+			}
 		}
 	}
+
+	return NULL;
 }
 
 static void btree_mergesort(struct btree *b, struct bset *out,
@@ -965,15 +978,20 @@ static void btree_mergesort(struct btree
 			    bool fixup, bool remove_stale)
 {
 	struct bkey *k, *last = NULL;
+	BKEY_PADDED(k) tmp;
 	bool (*bad)(struct btree *, const struct bkey *) = remove_stale
 		? bch_ptr_bad
 		: bch_ptr_invalid;
 
 	while (!btree_iter_end(iter)) {
 		if (fixup && !b->level)
-			btree_sort_fixup(iter);
+			k = btree_sort_fixup(iter, &tmp.k);
+		else
+			k = NULL;
+
+		if (!k)
+			k = bch_btree_iter_next(iter);
 
-		k = bch_btree_iter_next(iter);
 		if (bad(b, k))
 			continue;
 


