Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaAMTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:09:26 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50400 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaAMTJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:09:23 -0500
X-IronPort-AV: E=Sophos;i="4.95,654,1384300800"; 
   d="scan'208";a="90295181"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH v2 1/2] xen/grant-table: Avoid m2p_override during mapping
Date: Mon, 13 Jan 2014 19:08:38 +0000
Message-ID: <1389640119-7936-2-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389640119-7936-1-git-send-email-zoltan.kiss@citrix.com>
References: <1389640119-7936-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does the following:
- move the m2p_override part from grant_[un]map_refs to gntdev, where it is
  needed after mapping operations
- but move set_phys_to_machine from m2p_override to grant_[un]map_refs,
  because it is needed always

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Suggested-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/p2m.c        |    5 ---
 drivers/xen/gntdev.c      |   62 ++++++++++++++++++++++++++++++++++---
 drivers/xen/grant-table.c |   75 +++++++++++++++------------------------------
 3 files changed, 83 insertions(+), 59 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 2ae8699..b1e9407 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -891,10 +891,6 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 	WARN_ON(PagePrivate(page));
 	SetPagePrivate(page);
 	set_page_private(page, mfn);
-	page->index = pfn_to_mfn(pfn);
-
-	if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
-		return -ENOMEM;
 
 	if (kmap_op != NULL) {
 		if (!PageHighMem(page)) {
@@ -962,7 +958,6 @@ int m2p_remove_override(struct page *page,
 	WARN_ON(!PagePrivate(page));
 	ClearPagePrivate(page);
 
-	set_phys_to_machine(pfn, page->index);
 	if (kmap_op != NULL) {
 		if (!PageHighMem(page)) {
 			struct multicall_space mcs;
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index e41c79c..b89aaa2 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -250,6 +250,9 @@ static int find_grant_ptes(pte_t *pte, pgtable_t token,
 static int map_grant_pages(struct grant_map *map)
 {
 	int i, err = 0;
+	bool lazy = false;
+	pte_t *pte;
+	unsigned long mfn;
 
 	if (!use_ptemod) {
 		/* Note: it could already be mapped */
@@ -284,8 +287,37 @@ static int map_grant_pages(struct grant_map *map)
 	}
 
 	pr_debug("map %d+%d\n", map->index, map->count);
-	err = gnttab_map_refs(map->map_ops, use_ptemod ? map->kmap_ops : NULL,
-			map->pages, map->count);
+	err = gnttab_map_refs(map->map_ops, NULL, map->pages, map->count);
+	if (err)
+		return err;
+
+	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
+		arch_enter_lazy_mmu_mode();
+		lazy = true;
+	}
+
+	for (i = 0; i < map->count; i++) {
+		/* Do not add to override if the map failed. */
+		if (map->map_ops[i].status)
+			continue;
+
+		if (map->map_ops[i].flags & GNTMAP_contains_pte) {
+			pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map->map_ops[i].host_addr)) +
+				(map->map_ops[i].host_addr & ~PAGE_MASK));
+			mfn = pte_mfn(*pte);
+		} else {
+			mfn = PFN_DOWN(map->map_ops[i].dev_bus_addr);
+		}
+		err = m2p_add_override(mfn,
+				       map->pages[i],
+				       use_ptemod ? &map->kmap_ops[i] : NULL);
+		if (err)
+			break;
+	}
+
+	if (lazy)
+		arch_leave_lazy_mmu_mode();
+
 	if (err)
 		return err;
 
@@ -304,6 +336,7 @@ static int map_grant_pages(struct grant_map *map)
 static int __unmap_grant_pages(struct grant_map *map, int offset, int pages)
 {
 	int i, err = 0;
+	bool lazy = false;
 
 	if (map->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
 		int pgno = (map->notify.addr >> PAGE_SHIFT);
@@ -316,8 +349,29 @@ static int __unmap_grant_pages(struct grant_map *map, int offset, int pages)
 	}
 
 	err = gnttab_unmap_refs(map->unmap_ops + offset,
-			use_ptemod ? map->kmap_ops + offset : NULL, map->pages + offset,
-			pages);
+				NULL,
+				map->pages + offset,
+				pages);
+	if (err)
+		return err;
+
+	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
+		arch_enter_lazy_mmu_mode();
+		lazy = true;
+	}
+
+	for (i = 0; i < pages; i++) {
+		err = m2p_remove_override((map->pages + offset)[i],
+					  use_ptemod ?
+					  &(map->kmap_ops + offset)[i] :
+					  NULL);
+		if (err)
+			break;
+	}
+
+	if (lazy)
+		arch_leave_lazy_mmu_mode();
+
 	if (err)
 		return err;
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index aa846a4..ad281e4 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -885,7 +885,6 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		    struct page **pages, unsigned int count)
 {
 	int i, ret;
-	bool lazy = false;
 	pte_t *pte;
 	unsigned long mfn;
 
@@ -904,40 +903,29 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		for (i = 0; i < count; i++) {
 			if (map_ops[i].status)
 				continue;
-			set_phys_to_machine(map_ops[i].host_addr >> PAGE_SHIFT,
-					map_ops[i].dev_bus_addr >> PAGE_SHIFT);
+			if (unlikely(!set_phys_to_machine(map_ops[i].host_addr >> PAGE_SHIFT,
+							  map_ops[i].dev_bus_addr >> PAGE_SHIFT)))
+				return -ENOMEM;
 		}
-		return ret;
-	}
-
-	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
-		arch_enter_lazy_mmu_mode();
-		lazy = true;
-	}
-
-	for (i = 0; i < count; i++) {
-		/* Do not add to override if the map failed. */
-		if (map_ops[i].status)
-			continue;
-
-		if (map_ops[i].flags & GNTMAP_contains_pte) {
-			pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map_ops[i].host_addr)) +
-				(map_ops[i].host_addr & ~PAGE_MASK));
-			mfn = pte_mfn(*pte);
-		} else {
-			mfn = PFN_DOWN(map_ops[i].dev_bus_addr);
+	} else {
+		for (i = 0; i < count; i++) {
+			if (map_ops[i].status)
+				continue;
+			if (map_ops[i].flags & GNTMAP_contains_pte) {
+				pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map_ops[i].host_addr)) +
+					(map_ops[i].host_addr & ~PAGE_MASK));
+				mfn = pte_mfn(*pte);
+			} else {
+				mfn = PFN_DOWN(map_ops[i].dev_bus_addr);
+			}
+			pages[i]->index = pfn_to_mfn(page_to_pfn(pages[i]));
+			if (unlikely(!set_phys_to_machine(page_to_pfn(pages[i]),
+							  FOREIGN_FRAME(mfn))))
+				return -ENOMEM;
 		}
-		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
-				       &kmap_ops[i] : NULL);
-		if (ret)
-			goto out;
 	}
 
- out:
-	if (lazy)
-		arch_leave_lazy_mmu_mode();
-
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(gnttab_map_refs);
 
@@ -946,7 +934,6 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		      struct page **pages, unsigned int count)
 {
 	int i, ret;
-	bool lazy = false;
 
 	ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
 	if (ret)
@@ -958,26 +945,14 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 			set_phys_to_machine(unmap_ops[i].host_addr >> PAGE_SHIFT,
 					INVALID_P2M_ENTRY);
 		}
-		return ret;
-	}
-
-	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
-		arch_enter_lazy_mmu_mode();
-		lazy = true;
-	}
-
-	for (i = 0; i < count; i++) {
-		ret = m2p_remove_override(pages[i], kmap_ops ?
-				       &kmap_ops[i] : NULL);
-		if (ret)
-			goto out;
+	} else {
+		for (i = 0; i < count; i++) {
+				set_phys_to_machine(page_to_pfn(pages[i]),
+						    pages[i]->index);
+		}
 	}
 
- out:
-	if (lazy)
-		arch_leave_lazy_mmu_mode();
-
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
 
