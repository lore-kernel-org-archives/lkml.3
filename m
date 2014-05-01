Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaEAApe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:45:34 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:47945 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaEAApa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:45:30 -0400
Date: Wed, 30 Apr 2014 17:45:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 2/2] mm, compaction: return failed migration target pages
 back to freelist
In-Reply-To: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1404301744400.8415@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory compaction works by having a "freeing scanner" scan from one end of a 
zone which isolates pages as migration targets while another "migrating scanner" 
scans from the other end of the same zone which isolates pages for migration.

When page migration fails for an isolated page, the target page is returned to 
the system rather than the freelist built by the freeing scanner.  This may 
require the freeing scanner to continue scanning memory after suitable migration 
targets have already been returned to the system needlessly.

This patch returns destination pages to the freeing scanner freelist when page 
migration fails.  This prevents unnecessary work done by the freeing scanner but 
also encourages memory to be as compacted as possible at the end of the zone.

Reported-by: Greg Thelen <gthelen@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/compaction.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -797,6 +797,19 @@ static struct page *compaction_alloc(struct page *migratepage,
 }
 
 /*
+ * This is a migrate-callback that "frees" freepages back to the isolated
+ * freelist.  All pages on the freelist are from the same zone, so there is no
+ * special handling needed for NUMA.
+ */
+static void compaction_free(struct page *page, unsigned long data)
+{
+	struct compact_control *cc = (struct compact_control *)data;
+
+	list_add(&page->lru, &cc->freepages);
+	cc->nr_freepages++;
+}
+
+/*
  * We cannot control nr_migratepages and nr_freepages fully when migration is
  * running as migrate_pages() has no knowledge of compact_control. When
  * migration is complete, we count the number of pages on the lists by hand.
@@ -1023,8 +1036,8 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 		}
 
 		nr_migrate = cc->nr_migratepages;
-		err = migrate_pages(&cc->migratepages, compaction_alloc, NULL,
-				(unsigned long)cc,
+		err = migrate_pages(&cc->migratepages, compaction_alloc,
+				compaction_free, (unsigned long)cc,
 				cc->sync ? MIGRATE_SYNC_LIGHT : MIGRATE_ASYNC,
 				MR_COMPACTION);
 		update_nr_listpages(cc);
