Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab3IJJcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:32:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3IJJcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:32:51 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 17/50] mm: Do not flush TLB during protection change if !pte_present && !migration_entry
Date: Tue, 10 Sep 2013 10:31:57 +0100
Message-Id: <1378805550-29949-18-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378805550-29949-1-git-send-email-mgorman@suse.de>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMA PTE scanning is expensive both in terms of the scanning itself and
the TLB flush if there are any updates. Currently non-present PTEs are
accounted for as an update and incurring a TLB flush where it is only
necessary for anonymous migration entries. This patch addresses the
problem and should reduce TLB flushes.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/mprotect.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 1f9b54b..1e9cef0 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -109,8 +109,9 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 				make_migration_entry_read(&entry);
 				set_pte_at(mm, addr, pte,
 					swp_entry_to_pte(entry));
+
+				pages++;
 			}
-			pages++;
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
-- 
1.8.1.4

