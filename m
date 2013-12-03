Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3LCIyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:54:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab3LCIwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:52:12 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 10/15] mm: numa: Avoid unnecessary work on the failure path
Date: Tue,  3 Dec 2013 08:51:57 +0000
Message-Id: <1386060721-3794-11-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386060721-3794-1-git-send-email-mgorman@suse.de>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a PMD changes during a THP migration then migration aborts but the
failure path is doing more work than is necessary.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/migrate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 3a87511..e429206 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1774,7 +1774,8 @@ fail_putback:
 		putback_lru_page(page);
 		mod_zone_page_state(page_zone(page),
 			 NR_ISOLATED_ANON + page_lru, -HPAGE_PMD_NR);
-		goto out_fail;
+
+		goto out_unlock;
 	}
 
 	/*
@@ -1848,6 +1849,7 @@ out_dropref:
 	}
 	spin_unlock(&mm->page_table_lock);
 
+out_unlock:
 	unlock_page(page);
 	put_page(page);
 	return 0;
-- 
1.8.4

