Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3LJP4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:56:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab3LJPvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:51:42 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 07/18] mm: numa: Avoid unnecessary work on the failure path
Date: Tue, 10 Dec 2013 15:51:25 +0000
Message-Id: <1386690695-27380-8-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386690695-27380-1-git-send-email-mgorman@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a PMD changes during a THP migration then migration aborts but the
failure path is doing more work than is necessary.

Cc: stable@vger.kernel.org
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/migrate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index be787d5..a987525 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1780,7 +1780,8 @@ fail_putback:
 		putback_lru_page(page);
 		mod_zone_page_state(page_zone(page),
 			 NR_ISOLATED_ANON + page_lru, -HPAGE_PMD_NR);
-		goto out_fail;
+
+		goto out_unlock;
 	}
 
 	/*
@@ -1854,6 +1855,7 @@ out_dropref:
 	}
 	spin_unlock(ptl);
 
+out_unlock:
 	unlock_page(page);
 	put_page(page);
 	return 0;
-- 
1.8.4

