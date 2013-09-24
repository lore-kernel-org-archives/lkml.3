Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3IXGSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:18:48 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58096 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3IXGSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:18:45 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Kent Overstreet <kmo@daterainc.com>,
        stable@vger.kernel.org
Subject: [PATCH 04/11] bcache: Fix for when no journal entries are found
Date: Mon, 23 Sep 2013 23:17:29 -0700
Message-Id: <1380003456-19938-5-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The journal replay code didn't handle this case, causing it to go into
an infinite loop...

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/journal.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index c0017ca..f5203df 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -153,7 +153,8 @@ int bch_journal_read(struct cache_set *c, struct list_head *list,
 		bitmap_zero(bitmap, SB_JOURNAL_BUCKETS);
 		pr_debug("%u journal buckets", ca->sb.njournal_buckets);
 
-		/* Read journal buckets ordered by golden ratio hash to quickly
+		/*
+		 * Read journal buckets ordered by golden ratio hash to quickly
 		 * find a sequence of buckets with valid journal entries
 		 */
 		for (i = 0; i < ca->sb.njournal_buckets; i++) {
@@ -166,18 +167,20 @@ int bch_journal_read(struct cache_set *c, struct list_head *list,
 				goto bsearch;
 		}
 
-		/* If that fails, check all the buckets we haven't checked
+		/*
+		 * If that fails, check all the buckets we haven't checked
 		 * already
 		 */
 		pr_debug("falling back to linear search");
 
-		for (l = 0; l < ca->sb.njournal_buckets; l++) {
-			if (test_bit(l, bitmap))
-				continue;
-
+		for (l = find_first_zero_bit(bitmap, ca->sb.njournal_buckets);
+		     l < ca->sb.njournal_buckets;
+		     l = find_next_zero_bit(bitmap, ca->sb.njournal_buckets, l + 1))
 			if (read_bucket(l))
 				goto bsearch;
-		}
+
+		if (list_empty(list))
+			continue;
 bsearch:
 		/* Binary search */
 		m = r = find_next_bit(bitmap, ca->sb.njournal_buckets, l + 1);
@@ -197,10 +200,12 @@ bsearch:
 				r = m;
 		}
 
-		/* Read buckets in reverse order until we stop finding more
+		/*
+		 * Read buckets in reverse order until we stop finding more
 		 * journal entries
 		 */
-		pr_debug("finishing up");
+		pr_debug("finishing up: m %u njournal_buckets %u",
+			 m, ca->sb.njournal_buckets);
 		l = m;
 
 		while (1) {
@@ -228,9 +233,10 @@ bsearch:
 			}
 	}
 
-	c->journal.seq = list_entry(list->prev,
-				    struct journal_replay,
-				    list)->j.seq;
+	if (!list_empty(list))
+		c->journal.seq = list_entry(list->prev,
+					    struct journal_replay,
+					    list)->j.seq;
 
 	return 0;
 #undef read_bucket
-- 
1.8.4.rc3

