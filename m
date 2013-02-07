Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab3BGQOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:14:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166Ab3BGQOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:14:19 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>
Cc: gong.chen@linux.intel.com, Wu Fengguang <fengguang.wu@intel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HWPOISON: change order of error_states[]'s elements
Date: Thu,  7 Feb 2013 11:14:06 -0500
Message-Id: <1360253646-10331-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

error_states[] has two separate states "unevictable LRU page" and
"mlocked LRU page", and the former one has the higher priority now.
But because of that the latter one is rarely chosen because pages with
PageMlocked highly likely have PG_unevictable set. On the other hand,
PG_unevictable without PageMlocked is common for ramfs or SHM_LOCKed
shared memory, so reversing the priority of these two states helps us
clearly distinguish them.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/memory-failure.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git v3.8-rc5.orig/mm/memory-failure.c v3.8-rc5/mm/memory-failure.c
index e6d6022..837bce2 100644
--- v3.8-rc5.orig/mm/memory-failure.c
+++ v3.8-rc5/mm/memory-failure.c
@@ -856,12 +856,12 @@ static struct page_state {
 	{ sc|dirty,	sc|dirty,	"dirty swapcache",	me_swapcache_dirty },
 	{ sc|dirty,	sc,		"clean swapcache",	me_swapcache_clean },
 
-	{ unevict|dirty, unevict|dirty,	"dirty unevictable LRU", me_pagecache_dirty },
-	{ unevict,	unevict,	"clean unevictable LRU", me_pagecache_clean },
-
 	{ mlock|dirty,	mlock|dirty,	"dirty mlocked LRU",	me_pagecache_dirty },
 	{ mlock,	mlock,		"clean mlocked LRU",	me_pagecache_clean },
 
+	{ unevict|dirty, unevict|dirty,	"dirty unevictable LRU", me_pagecache_dirty },
+	{ unevict,	unevict,	"clean unevictable LRU", me_pagecache_clean },
+
 	{ lru|dirty,	lru|dirty,	"dirty LRU",	me_pagecache_dirty },
 	{ lru|dirty,	lru,		"clean LRU",	me_pagecache_clean },
 
-- 
1.7.11.7

