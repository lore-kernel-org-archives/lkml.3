Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3FRBsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:48:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab3FRBsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:48:13 -0400
Subject: [PATCH] amd_iommu: Fix leak in free_pagetable()
To: joro@8bytes.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Jun 2013 19:48:08 -0600
Message-ID: <20130618014459.20440.73844.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD IOMMU initializes domains with a 3 level page table by default
and will dynamically size it up to a 6 level page table.  Sadly,
free_pagetable() ignores this feature and statically frees as if
it's a 3 level page table.  Recurse through all the levels to
free everything.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org
---

This is obviously a version rewritten to be recursive.  I'll also
post a flat version, take your pick.

 drivers/iommu/amd_iommu.c |   36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 565c745..5496025 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1906,32 +1906,26 @@ static void domain_id_free(int id)
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
 
-static void free_pagetable(struct protection_domain *domain)
+static void free_pagetable_level(int level, int max_level, u64 *pt)
 {
-	int i, j;
-	u64 *p1, *p2, *p3;
+	if (level < max_level) {
+		int i;
+		for (i = 0; i < 512; ++i) {
+			if (IOMMU_PTE_PRESENT(pt[i]))
+				free_pagetable_level(level + 1, max_level,
+						     IOMMU_PTE_PAGE(pt[i]));
+		}
+	}
 
-	p1 = domain->pt_root;
+	free_page((unsigned long)pt);
+}
 
-	if (!p1)
+static void free_pagetable(struct protection_domain *domain)
+{
+	if (!domain->pt_root)
 		return;
 
-	for (i = 0; i < 512; ++i) {
-		if (!IOMMU_PTE_PRESENT(p1[i]))
-			continue;
-
-		p2 = IOMMU_PTE_PAGE(p1[i]);
-		for (j = 0; j < 512; ++j) {
-			if (!IOMMU_PTE_PRESENT(p2[j]))
-				continue;
-			p3 = IOMMU_PTE_PAGE(p2[j]);
-			free_page((unsigned long)p3);
-		}
-
-		free_page((unsigned long)p2);
-	}
-
-	free_page((unsigned long)p1);
+	free_pagetable_level(PAGE_MODE_1_LEVEL, domain->mode, domain->pt_root);
 
 	domain->pt_root = NULL;
 }

