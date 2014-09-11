Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbaIKUy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:54:56 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:48292 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437AbaIKUyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:54:54 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 03/10] zsmalloc: always update lru ordering of each zspage
Date: Thu, 11 Sep 2014 16:53:54 -0400
Message-Id: <1410468841-320-4-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
References: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update ordering of a changed zspage in its fullness group LRU list,
even if it has not moved to a different fullness group.

This is needed by zsmalloc shrinking, which partially relies on each
class fullness group list to be kept in LRU order, so the oldest can
be reclaimed first.  Currently, LRU ordering is only updated when
a zspage changes fullness groups.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index fedb70f..51db622 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -467,16 +467,14 @@ static enum fullness_group fix_fullness_group(struct zs_pool *pool,
 	BUG_ON(!is_first_page(page));
 
 	get_zspage_mapping(page, &class_idx, &currfg);
-	newfg = get_fullness_group(page);
-	if (newfg == currfg)
-		goto out;
-
 	class = &pool->size_class[class_idx];
+	newfg = get_fullness_group(page);
+	/* Need to do this even if currfg == newfg, to update lru */
 	remove_zspage(page, class, currfg);
 	insert_zspage(page, class, newfg);
-	set_zspage_mapping(page, class_idx, newfg);
+	if (currfg != newfg)
+		set_zspage_mapping(page, class_idx, newfg);
 
-out:
 	return newfg;
 }
 
-- 
1.8.3.1

