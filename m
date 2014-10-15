Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaJOUGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:06:44 -0400
Received: from mail-qg0-f73.google.com ([209.85.192.73]:35759 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaJOUGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:06:41 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2014 16:06:41 EDT
From: Jamie Liu <jamieliu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>
Cc: Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jamie Liu <jamieliu@google.com>
Subject: [PATCH] mm: vmscan: count only dirty pages as congested
Date: Wed, 15 Oct 2014 12:58:35 -0700
Message-Id: <1413403115-1551-1-git-send-email-jamieliu@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shrink_page_list() counts all pages with a mapping, including clean
pages, toward nr_congested if they're on a write-congested BDI.
shrink_inactive_list() then sets ZONE_CONGESTED if nr_dirty ==
nr_congested. Fix this apples-to-oranges comparison by only counting
pages for nr_congested if they count for nr_dirty.

Signed-off-by: Jamie Liu <jamieliu@google.com>
---
 mm/vmscan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index dcb4707..ad9cd9f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -875,7 +875,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		 * end of the LRU a second time.
 		 */
 		mapping = page_mapping(page);
-		if ((mapping && bdi_write_congested(mapping->backing_dev_info)) ||
+		if (((dirty || writeback) && mapping &&
+		     bdi_write_congested(mapping->backing_dev_info)) ||
 		    (writeback && PageReclaim(page)))
 			nr_congested++;
 
-- 
2.1.0.rc2.206.gedb03e5

