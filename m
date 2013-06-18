Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3FRBwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:52:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab3FRBwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:52:18 -0400
Subject: [PATCH] amd_iommu: Fix leak in free_pagetable()
To: joro@8bytes.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Jun 2013 19:52:14 -0600
Message-ID: <20130618015116.20711.90269.stgit@bling.home>
In-Reply-To: <20130618014459.20440.73844.stgit@bling.home>
References: <20130618014459.20440.73844.stgit@bling.home>
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
it's a 3 level page table.  Add support for the extra levels.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org
---

Here's the flat version.  It's not terrible, but checkpatch whines
about the level of nesting.

 drivers/iommu/amd_iommu.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 565c745..95da421 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1908,23 +1908,47 @@ static void domain_id_free(int id)
 
 static void free_pagetable(struct protection_domain *domain)
 {
-	int i, j;
-	u64 *p1, *p2, *p3;
+	int i, j, k, l, m, depth = domain->mode;
+	u64 *p1, *p2, *p3, *p4, *p5, *p6;
 
 	p1 = domain->pt_root;
 
 	if (!p1)
 		return;
 
-	for (i = 0; i < 512; ++i) {
+	for (i = 0; depth > 1 && i < 512; ++i) {
 		if (!IOMMU_PTE_PRESENT(p1[i]))
 			continue;
 
 		p2 = IOMMU_PTE_PAGE(p1[i]);
-		for (j = 0; j < 512; ++j) {
+		for (j = 0; depth > 2 && j < 512; ++j) {
 			if (!IOMMU_PTE_PRESENT(p2[j]))
 				continue;
+
 			p3 = IOMMU_PTE_PAGE(p2[j]);
+			for (k = 0; depth > 3 && k < 512; ++k) {
+				if (!IOMMU_PTE_PRESENT(p3[k]))
+					continue;
+
+				p4 = IOMMU_PTE_PAGE(p3[k]);
+				for (l = 0; depth > 4 && l < 512; ++l) {
+					if (!IOMMU_PTE_PRESENT(p4[l]))
+						continue;
+
+					p5 = IOMMU_PTE_PAGE(p4[l]);
+					for (m = 0; depth > 5 && m < 512; ++m) {
+						if (!IOMMU_PTE_PRESENT(p5[m]))
+							continue;
+						p6 = IOMMU_PTE_PAGE(p5[m]);
+						free_page((unsigned long)p6);
+					}
+
+					free_page((unsigned long)p5);
+				}
+
+				free_page((unsigned long)p4);
+			}
+
 			free_page((unsigned long)p3);
 		}
 

