Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbaICJ44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:56:56 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57382 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932103AbaICJ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:56:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 01/56] bcache: Minor journal fix
Date: Wed,  3 Sep 2014 11:26:20 +0200
Message-Id: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b3fa7e77e67e647db3db2166b65083a427d84ed3 upstream.

The real fix is where we check the bytes we need against how much is
remaining - we also need to check for a journal entry bigger than our
buffer, we'll never write those and it would be bad if we tried to read
one.

Also improve the diagnostic messages.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/bcache/journal.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 8435f81e5d85..c4943793cb86 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -42,11 +42,11 @@ static int journal_read_bucket(struct cache *ca, struct list_head *list,
 	int ret = 0;
 	sector_t bucket = bucket_to_sector(ca->set, ca->sb.d[bucket_index]);
 
-	pr_debug("reading %llu", (uint64_t) bucket);
+	pr_debug("reading %u", bucket_index);
 
 	while (offset < ca->sb.bucket_size) {
 reread:		left = ca->sb.bucket_size - offset;
-		len = min_t(unsigned, left, PAGE_SECTORS * 8);
+		len = min_t(unsigned, left, PAGE_SECTORS << JSET_BITS);
 
 		bio_reset(bio);
 		bio->bi_sector	= bucket + offset;
@@ -72,17 +72,26 @@ reread:		left = ca->sb.bucket_size - offset;
 			struct list_head *where;
 			size_t blocks, bytes = set_bytes(j);
 
-			if (j->magic != jset_magic(ca->set))
+			if (j->magic != jset_magic(ca->set)) {
+				pr_debug("%u: bad magic", bucket_index);
 				return ret;
+			}
 
-			if (bytes > left << 9)
+			if (bytes > left << 9 ||
+			    bytes > PAGE_SIZE << JSET_BITS) {
+				pr_info("%u: too big, %zu bytes, offset %u",
+					bucket_index, bytes, offset);
 				return ret;
+			}
 
 			if (bytes > len << 9)
 				goto reread;
 
-			if (j->csum != csum_set(j))
+			if (j->csum != csum_set(j)) {
+				pr_info("%u: bad csum, %zu bytes, offset %u",
+					bucket_index, bytes, offset);
 				return ret;
+			}
 
 			blocks = set_blocks(j, ca->set);
 
-- 
2.1.0

