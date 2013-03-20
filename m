Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab3CTSD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:03:59 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:41662 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab3CTSD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:03:56 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 4/5] x86-64: use vmemmap_populate_basepages() for !pse setups
Date: Wed, 20 Mar 2013 14:03:31 -0400
Message-Id: <1363802612-32127-5-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363802612-32127-1-git-send-email-hannes@cmpxchg.org>
References: <1363802612-32127-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have generic code to allocate vmemmap with regular pages,
use it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/x86/mm/init_64.c | 81 ++++++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 43 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1acba7e..134c85d 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1282,17 +1282,15 @@ static long __meminitdata addr_start, addr_end;
 static void __meminitdata *p_start, *p_end;
 static int __meminitdata node_start;
 
-int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
+static int __meminit vmemmap_populate_hugepages(unsigned long start,
+						unsigned long end, int node)
 {
 	unsigned long addr;
-	unsigned long next;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 
-	for (addr = start; addr < end; addr = next) {
-		void *p = NULL;
-
+	for (addr = start; addr < end; addr += PMD_SIZE) {
 		pgd = vmemmap_pgd_populate(addr, node);
 		if (!pgd)
 			return -ENOMEM;
@@ -1301,53 +1299,50 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
 		if (!pud)
 			return -ENOMEM;
 
-		if (!cpu_has_pse) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			pmd = vmemmap_pmd_populate(pud, addr, node);
-
-			if (!pmd)
-				return -ENOMEM;
-
-			p = vmemmap_pte_populate(pmd, addr, node);
+		pmd = pmd_offset(pud, addr);
+		if (pmd_none(*pmd)) {
+			pte_t entry;
+			void *p;
 
+			p = vmemmap_alloc_block_buf(PMD_SIZE, node);
 			if (!p)
 				return -ENOMEM;
-		} else {
-			next = pmd_addr_end(addr, end);
 
-			pmd = pmd_offset(pud, addr);
-			if (pmd_none(*pmd)) {
-				pte_t entry;
-
-				p = vmemmap_alloc_block_buf(PMD_SIZE, node);
-				if (!p)
-					return -ENOMEM;
-
-				entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
-						PAGE_KERNEL_LARGE);
-				set_pmd(pmd, __pmd(pte_val(entry)));
-
-				/* check to see if we have contiguous blocks */
-				if (p_end != p || node_start != node) {
-					if (p_start)
-						printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
-						       addr_start, addr_end-1, p_start, p_end-1, node_start);
-					addr_start = addr;
-					node_start = node;
-					p_start = p;
-				}
-
-				addr_end = addr + PMD_SIZE;
-				p_end = p + PMD_SIZE;
-			} else
-				vmemmap_verify((pte_t *)pmd, node, addr, next);
-		}
+			entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
+					PAGE_KERNEL_LARGE);
+			set_pmd(pmd, __pmd(pte_val(entry)));
+
+			/* check to see if we have contiguous blocks */
+			if (p_end != p || node_start != node) {
+				if (p_start)
+					printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
+					       addr_start, addr_end-1, p_start, p_end-1, node_start);
+				addr_start = addr;
+				node_start = node;
+				p_start = p;
+			}
 
+			addr_end = addr + PMD_SIZE;
+			p_end = p + PMD_SIZE;
+		} else
+			vmemmap_verify((pte_t *)pmd, node, addr, next);
 	}
-	sync_global_pgds(start, end - 1);
 	return 0;
 }
 
+int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
+{
+	int err;
+
+	if (cpu_has_pse)
+		err = vmemmap_populate_hugepages(start, end, node);
+	else
+		err = vmemmap_populate_basepages(start, end, node);
+	if (!err)
+		sync_global_pgds(start, end - 1);
+	return err;
+}
+
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HAVE_BOOTMEM_INFO_NODE)
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
-- 
1.7.11.7

