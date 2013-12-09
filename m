Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765Ab3LIHKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:10:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760602Ab3LIHJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:09:20 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 06/18] mm: numa: Ensure anon_vma is locked to prevent parallel THP splits
Date: Mon,  9 Dec 2013 07:09:00 +0000
Message-Id: <1386572952-1191-7-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386572952-1191-1-git-send-email-mgorman@suse.de>
References: <1386572952-1191-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The anon_vma lock prevents parallel THP splits and any associated complexity
that arises when handling splits during THP migration. This patch checks
if the lock was successfully acquired and bails from THP migration if it
failed for any reason.

Cc: stable@vger.kernel.org
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5a5da50..0f00b96 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1359,6 +1359,13 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out_unlock;
 	}
 
+	/* Bail if we fail to protect against THP splits for any reason */
+	if (unlikely(!anon_vma)) {
+		put_page(page);
+		page_nid = -1;
+		goto clear_pmdnuma;
+	}
+
 	/*
 	 * Migrate the THP to the requested node, returns with page unlocked
 	 * and pmd_numa cleared.
-- 
1.8.4

