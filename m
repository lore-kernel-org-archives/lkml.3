Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3LBUD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:03:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab3LBTRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 3.12 101/212] bcache: Fix dirty_data accounting
Date: Mon,  2 Dec 2013 11:14:52 -0800
Message-Id: <20131202191258.644237194@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit 1fa8455deb92e9ec7756df23030e73b2d28eeca7 upstream.

Dirty data accounting wasn't quite right - firstly, we were adding the key we're
inserting after it could have merged with another dirty key already in the
btree, and secondly we could sometimes pass the wrong offset to
bcache_dev_sectors_dirty_add() for dirty data we were overwriting - which is
important when tracking dirty data by stripe.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/btree.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1742,6 +1742,9 @@ static bool fix_overlapping_extents(stru
 		if (bkey_cmp(insert, k) < 0) {
 			bch_cut_front(insert, k);
 		} else {
+			if (bkey_cmp(&START_KEY(insert), &START_KEY(k)) > 0)
+				old_offset = KEY_START(insert);
+
 			if (bkey_written(b, k) &&
 			    bkey_cmp(&START_KEY(insert), &START_KEY(k)) <= 0) {
 				/*
@@ -1803,6 +1806,10 @@ static bool btree_insert_key(struct btre
 		if (fix_overlapping_extents(b, k, &iter, op))
 			return false;
 
+		if (KEY_DIRTY(k))
+			bcache_dev_sectors_dirty_add(b->c, KEY_INODE(k),
+						     KEY_START(k), KEY_SIZE(k));
+
 		while (m != end(i) &&
 		       bkey_cmp(k, &START_KEY(m)) > 0)
 			prev = m, m = bkey_next(m);
@@ -1831,10 +1838,6 @@ static bool btree_insert_key(struct btre
 insert:	shift_keys(b, m, k);
 copy:	bkey_copy(m, k);
 merged:
-	if (KEY_DIRTY(k))
-		bcache_dev_sectors_dirty_add(b->c, KEY_INODE(k),
-					     KEY_START(k), KEY_SIZE(k));
-
 	bch_check_keys(b, "%u for %s", status, op_type(op));
 
 	if (b->level && !KEY_OFFSET(k))


