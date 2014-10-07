Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbaJGXUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:20:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219AbaJGXUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 23/37] mm/compaction: do not call suitable_migration_target() on every page
Date: Tue,  7 Oct 2014 16:19:40 -0700
Message-Id: <20141007231827.772180887@linuxfoundation.org>
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

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

commit 01ead5340bcf5f3a1cd2452c75516d0ef4d908d7 upstream.

suitable_migration_target() checks that pageblock is suitable for
migration target.  In isolate_freepages_block(), it is called on every
page and this is inefficient.  So make it called once per pageblock.

suitable_migration_target() also checks if page is highorder or not, but
it's criteria for highorder is pageblock order.  So calling it once
within pageblock range has no problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -244,6 +244,7 @@ static unsigned long isolate_freepages_b
 	struct page *cursor, *valid_page = NULL;
 	unsigned long flags;
 	bool locked = false;
+	bool checked_pageblock = false;
 
 	cursor = pfn_to_page(blockpfn);
 
@@ -275,8 +276,16 @@ static unsigned long isolate_freepages_b
 			break;
 
 		/* Recheck this is a suitable migration target under lock */
-		if (!strict && !suitable_migration_target(page))
-			break;
+		if (!strict && !checked_pageblock) {
+			/*
+			 * We need to check suitability of pageblock only once
+			 * and this isolate_freepages_block() is called with
+			 * pageblock range, so just check once is sufficient.
+			 */
+			checked_pageblock = true;
+			if (!suitable_migration_target(page))
+				break;
+		}
 
 		/* Recheck this is a buddy page under lock */
 		if (!PageBuddy(page))


