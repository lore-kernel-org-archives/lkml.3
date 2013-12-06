Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161885Ab3LFNEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:04:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44532 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161862Ab3LFNEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kent Overstreet <kmo@daterainc.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 205/272] bcache: Fix dirty_data accounting
Date: Fri,  6 Dec 2013 12:58:14 +0000
Message-Id: <1386334761-25517-206-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit 1fa8455deb92e9ec7756df23030e73b2d28eeca7 upstream.

Dirty data accounting wasn't quite right - firstly, we were adding the key we're
inserting after it could have merged with another dirty key already in the
btree, and secondly we could sometimes pass the wrong offset to
bcache_dev_sectors_dirty_add() for dirty data we were overwriting - which is
important when tracking dirty data by stripe.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/bcache/btree.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 391ba90..9e6c9f5 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1733,6 +1733,9 @@ static bool fix_overlapping_extents(struct btree *b,
 		if (bkey_cmp(insert, k) < 0) {
 			bch_cut_front(insert, k);
 		} else {
+			if (bkey_cmp(&START_KEY(insert), &START_KEY(k)) > 0)
+				old_offset = KEY_START(insert);
+
 			if (bkey_written(b, k) &&
 			    bkey_cmp(&START_KEY(insert), &START_KEY(k)) <= 0) {
 				/*
@@ -1794,6 +1797,10 @@ static bool btree_insert_key(struct btree *b, struct btree_op *op,
 		if (fix_overlapping_extents(b, k, &iter, op))
 			return false;
 
+		if (KEY_DIRTY(k))
+			bcache_dev_sectors_dirty_add(b->c, KEY_INODE(k),
+						     KEY_START(k), KEY_SIZE(k));
+
 		while (m != end(i) &&
 		       bkey_cmp(k, &START_KEY(m)) > 0)
 			prev = m, m = bkey_next(m);
@@ -1822,10 +1829,6 @@ static bool btree_insert_key(struct btree *b, struct btree_op *op,
 insert:	shift_keys(b, m, k);
 copy:	bkey_copy(m, k);
 merged:
-	if (KEY_DIRTY(k))
-		bcache_dev_sectors_dirty_add(b->c, KEY_INODE(k),
-					     KEY_START(k), KEY_SIZE(k));
-
 	bch_check_keys(b, "%u for %s", status, op_type(op));
 
 	if (b->level && !KEY_OFFSET(k))
-- 
1.8.3.2

