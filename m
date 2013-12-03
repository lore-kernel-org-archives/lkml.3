Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3LCIxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:53:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab3LCIwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:52:13 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 12/15] Clear numa on mprotect
Date: Tue,  3 Dec 2013 08:51:59 +0000
Message-Id: <1386060721-3794-13-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386060721-3794-1-git-send-email-mgorman@suse.de>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 mm/huge_memory.c | 2 ++
 mm/mprotect.c    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 98b6a79..fa277fa 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1484,6 +1484,8 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 
 		if (!prot_numa) {
 			entry = pmdp_get_and_clear(mm, addr, pmd);
+			if (pmd_numa(entry))
+				entry = pmd_mknonnuma(entry);
 			entry = pmd_modify(entry, newprot);
 			BUG_ON(pmd_write(entry));
 			set_pmd_at(mm, addr, pmd, entry);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index c53e332..510f138 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -54,6 +54,8 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
 			if (!prot_numa) {
 				ptent = ptep_modify_prot_start(mm, addr, pte);
+				if (pte_numa(ptent))
+					ptent = pte_mknonnuma(ptent);
 				ptent = pte_modify(ptent, newprot);
 				updated = true;
 			} else {
-- 
1.8.4

