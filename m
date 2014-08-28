Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaH1ShE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:37:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbaH1Sg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:57 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 68/97] mm: page_alloc: do not update zlc unless the zlc is active
Date: Thu, 28 Aug 2014 19:35:16 +0100
Message-Id: <1409250945-30874-69-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 65bb371984d6a2c909244eb749e482bb40b72e36 upstream.

The zlc is used on NUMA machines to quickly skip over zones that are full.
 However it is always updated, even for the first zone scanned when the
zlc might not even be active.  As it's a write to a bitmap that
potentially bounces cache line it's deceptively expensive and most
machines will not care.  Only update the zlc if it was active.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7139ed7..2834c31 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2034,7 +2034,7 @@ try_this_zone:
 		if (page)
 			break;
 this_zone_full:
-		if (IS_ENABLED(CONFIG_NUMA))
+		if (IS_ENABLED(CONFIG_NUMA) && zlc_active)
 			zlc_mark_zone_full(zonelist, z);
 	}
 
-- 
1.8.4.5

