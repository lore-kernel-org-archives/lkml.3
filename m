Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3JCEOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:14:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab3JCEOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:14:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 05/52] bcache: Fix for when no journal entries are found
Date: Wed,  2 Oct 2013 21:05:23 -0700
Message-Id: <20131003040522.558684243@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit c426c4fd46f709ade2bddd51c5738729c7ae1db5 upstream.

The journal replay code didn't handle this case, causing it to go into
an infinite loop...

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/journal.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -151,7 +151,8 @@ int bch_journal_read(struct cache_set *c
 		bitmap_zero(bitmap, SB_JOURNAL_BUCKETS);
 		pr_debug("%u journal buckets", ca->sb.njournal_buckets);
 
-		/* Read journal buckets ordered by golden ratio hash to quickly
+		/*
+		 * Read journal buckets ordered by golden ratio hash to quickly
 		 * find a sequence of buckets with valid journal entries
 		 */
 		for (i = 0; i < ca->sb.njournal_buckets; i++) {
@@ -164,18 +165,20 @@ int bch_journal_read(struct cache_set *c
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
@@ -195,10 +198,12 @@ bsearch:
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
@@ -226,9 +231,10 @@ bsearch:
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


