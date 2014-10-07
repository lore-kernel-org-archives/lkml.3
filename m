Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbaJGX2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:28:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbaJGXUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 28/37] mm, compaction: determine isolation mode only once
Date: Tue,  7 Oct 2014 16:19:45 -0700
Message-Id: <20141007231827.921630538@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit da1c67a76f7cf2b3404823d24f9f10fa91aa5dc5 upstream.

The conditions that control the isolation mode in
isolate_migratepages_range() do not change during the iteration, so
extract them out and only define the value once.

This actually does have an effect, gcc doesn't optimize it itself because
of cc->sync.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -460,12 +460,13 @@ isolate_migratepages_range(struct zone *
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
-	isolate_mode_t mode = 0;
 	struct lruvec *lruvec;
 	unsigned long flags;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
 	bool skipped_async_unsuitable = false;
+	const isolate_mode_t mode = (!cc->sync ? ISOLATE_ASYNC_MIGRATE : 0) |
+				    (unevictable ? ISOLATE_UNEVICTABLE : 0);
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -608,12 +609,6 @@ isolate_migratepages_range(struct zone *
 			continue;
 		}
 
-		if (!cc->sync)
-			mode |= ISOLATE_ASYNC_MIGRATE;
-
-		if (unevictable)
-			mode |= ISOLATE_UNEVICTABLE;
-
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 
 		/* Try isolate the page */


