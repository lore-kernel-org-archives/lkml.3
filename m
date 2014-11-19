Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469AbaKSVdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:33:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934439AbaKSVdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:33:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 113/122] mm, compaction: terminate async compaction when rescheduling
Date: Wed, 19 Nov 2014 12:52:43 -0800
Message-Id: <20141119205212.598753470@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit aeef4b83806f49a0c454b7d4578671b71045bee2 upstream.

Async compaction terminates prematurely when need_resched(), see
compact_checklock_irqsave().  This can never trigger, however, if the
cond_resched() in isolate_migratepages_range() always takes care of the
scheduling.

If the cond_resched() actually triggers, then terminate this pageblock
scan for async compaction as well.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -494,8 +494,13 @@ isolate_migratepages_range(struct zone *
 			return 0;
 	}
 
+	if (cond_resched()) {
+		/* Async terminates prematurely on need_resched() */
+		if (cc->mode == MIGRATE_ASYNC)
+			return 0;
+	}
+
 	/* Time to isolate some pages for migration */
-	cond_resched();
 	for (; low_pfn < end_pfn; low_pfn++) {
 		/* give a chance to irqs before checking need_resched() */
 		if (locked && !(low_pfn % SWAP_CLUSTER_MAX)) {


