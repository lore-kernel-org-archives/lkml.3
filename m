Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaF1CBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 22:01:05 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:38319 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbaF1CAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 22:00:52 -0400
From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: mgorman@suse.de, hpa@zytor.com, peterz@infraread.org, aarcange@redhat.com,
        riel@redhat.com, jweiner@redhat.com, torvalds@linux-foundation.org,
        Mark Hairgrove <mhairgrove@nvidia.com>,
        Jatin Kumar <jakumar@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>,
        Lucien Dunning <ldunning@nvidia.com>,
        Cameron Buschardt <cabuschardt@nvidia.com>,
        Arvind Gopalakrishnan <arvindg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>,
        Duncan Poole <dpoole@nvidia.com>, Oded Gabbay <Oded.Gabbay@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
Subject: [PATCH 2/6] mm: differentiate unmap for vmscan from other unmap.
Date: Fri, 27 Jun 2014 22:00:20 -0400
Message-Id: <1403920822-14488-3-git-send-email-j.glisse@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403920822-14488-1-git-send-email-j.glisse@gmail.com>
References: <1403920822-14488-1-git-send-email-j.glisse@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

New code will need to be able to differentiate between a regular unmap and
an unmap trigger by vmscan in which case we want to be as quick as possible.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
---
 include/linux/rmap.h | 15 ++++++++-------
 mm/memory-failure.c  |  2 +-
 mm/vmscan.c          |  4 ++--
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index be57450..eddbc07 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -72,13 +72,14 @@ struct anon_vma_chain {
 };
 
 enum ttu_flags {
-	TTU_UNMAP = 1,			/* unmap mode */
-	TTU_MIGRATION = 2,		/* migration mode */
-	TTU_MUNLOCK = 4,		/* munlock mode */
-
-	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
-	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
-	TTU_IGNORE_HWPOISON = (1 << 10),/* corrupted page is recoverable */
+	TTU_VMSCAN = 1,			/* unmap for vmscan */
+	TTU_POISON = 2,			/* unmap for poison */
+	TTU_MIGRATION = 4,		/* migration mode */
+	TTU_MUNLOCK = 8,		/* munlock mode */
+
+	TTU_IGNORE_MLOCK = (1 << 9),	/* ignore mlock */
+	TTU_IGNORE_ACCESS = (1 << 10),	/* don't age */
+	TTU_IGNORE_HWPOISON = (1 << 11),/* corrupted page is recoverable */
 };
 
 #ifdef CONFIG_MMU
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a7a89eb..ba176c4 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -887,7 +887,7 @@ static int page_action(struct page_state *ps, struct page *p,
 static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				  int trapno, int flags, struct page **hpagep)
 {
-	enum ttu_flags ttu = TTU_UNMAP | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
+	enum ttu_flags ttu = TTU_POISON | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	int ret;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6d24fd6..5a7d286 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1163,7 +1163,7 @@ unsigned long reclaim_clean_pages_from_list(struct zone *zone,
 	}
 
 	ret = shrink_page_list(&clean_pages, zone, &sc,
-			TTU_UNMAP|TTU_IGNORE_ACCESS,
+			TTU_VMSCAN|TTU_IGNORE_ACCESS,
 			&dummy1, &dummy2, &dummy3, &dummy4, &dummy5, true);
 	list_splice(&clean_pages, page_list);
 	mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
@@ -1518,7 +1518,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (nr_taken == 0)
 		return 0;
 
-	nr_reclaimed = shrink_page_list(&page_list, zone, sc, TTU_UNMAP,
+	nr_reclaimed = shrink_page_list(&page_list, zone, sc, TTU_VMSCAN,
 				&nr_dirty, &nr_unqueued_dirty, &nr_congested,
 				&nr_writeback, &nr_immediate,
 				false);
-- 
1.9.0

