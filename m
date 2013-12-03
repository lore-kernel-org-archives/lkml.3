Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3LCIyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:54:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab3LCIwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:52:11 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 09/15] mm: numa: Ensure anon_vma is locked to prevent parallel THP splits
Date: Tue,  3 Dec 2013 08:51:56 +0000
Message-Id: <1386060721-3794-10-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386060721-3794-1-git-send-email-mgorman@suse.de>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The anon_vma lock prevents parallel THP splits and any associated complexity
that arises when handling splits during THP migration. This patch checks
if the lock was successfully acquired and bails from THP migration if it
failed for any reason.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d6c3bf4..98b6a79 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1342,6 +1342,13 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
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

