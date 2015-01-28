Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbbA1ByW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:54:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbbA1Bia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Theodore Tso <tytso@mit.edu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 51/77] mm: page_alloc: only check the zone id check if pages are buddies
Date: Tue, 27 Jan 2015 17:27:29 -0800
Message-Id: <20150128012747.501606482@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit d34c5fa06fade08a689fc171bf756fba2858ae73 upstream.

A node/zone index is used to check if pages are compatible for merging
but this happens unconditionally even if the buddy page is not free. Defer
the calculation as long as possible. Ideally we would check the zone boundary
but nodes can overlap.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -508,16 +508,26 @@ static inline int page_is_buddy(struct p
 	if (!pfn_valid_within(page_to_pfn(buddy)))
 		return 0;
 
-	if (page_zone_id(page) != page_zone_id(buddy))
-		return 0;
-
 	if (page_is_guard(buddy) && page_order(buddy) == order) {
 		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
+
+		if (page_zone_id(page) != page_zone_id(buddy))
+			return 0;
+
 		return 1;
 	}
 
 	if (PageBuddy(buddy) && page_order(buddy) == order) {
 		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
+
+		/*
+		 * zone check is done late to avoid uselessly
+		 * calculating zone/node ids for pages that could
+		 * never merge.
+		 */
+		if (page_zone_id(page) != page_zone_id(buddy))
+			return 0;
+
 		return 1;
 	}
 	return 0;


