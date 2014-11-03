Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaKCNFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:05:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbaKCNCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:02:15 -0500
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V6 09/18] x86: Use new cache mode type in track_pfn_remap() and track_pfn_insert()
Date: Mon,  3 Nov 2014 14:01:55 +0100
Message-Id: <1415019724-4317-10-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1415019724-4317-1-git-send-email-jgross@suse.com>
References: <1415019724-4317-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of directly using the cache mode bits in the pte switch to
using the cache mode type. As those are the main callers of
lookup_memtype(), change this as well.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/pat.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 6d5a8e3..2f3744f 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -394,12 +394,12 @@ int free_memtype(u64 start, u64 end)
  *
  * Only to be called when PAT is enabled
  *
- * Returns _PAGE_CACHE_WB, _PAGE_CACHE_WC, _PAGE_CACHE_UC_MINUS or
- * _PAGE_CACHE_UC
+ * Returns _PAGE_CACHE_MODE_WB, _PAGE_CACHE_MODE_WC, _PAGE_CACHE_MODE_UC_MINUS
+ * or _PAGE_CACHE_MODE_UC
  */
-static unsigned long lookup_memtype(u64 paddr)
+static enum page_cache_mode lookup_memtype(u64 paddr)
 {
-	int rettype = _PAGE_CACHE_WB;
+	enum page_cache_mode rettype = _PAGE_CACHE_MODE_WB;
 	struct memtype *entry;
 
 	if (x86_platform.is_untracked_pat_range(paddr, paddr + PAGE_SIZE))
@@ -408,13 +408,13 @@ static unsigned long lookup_memtype(u64 paddr)
 	if (pat_pagerange_is_ram(paddr, paddr + PAGE_SIZE)) {
 		struct page *page;
 		page = pfn_to_page(paddr >> PAGE_SHIFT);
-		rettype = get_page_memtype(page);
+		rettype = pgprot2cachemode(__pgprot(get_page_memtype(page)));
 		/*
 		 * -1 from get_page_memtype() implies RAM page is in its
 		 * default state and not reserved, and hence of type WB
 		 */
 		if (rettype == -1)
-			rettype = _PAGE_CACHE_WB;
+			rettype = _PAGE_CACHE_MODE_WB;
 
 		return rettype;
 	}
@@ -423,9 +423,9 @@ static unsigned long lookup_memtype(u64 paddr)
 
 	entry = rbt_memtype_lookup(paddr);
 	if (entry != NULL)
-		rettype = entry->type;
+		rettype = pgprot2cachemode(__pgprot(entry->type));
 	else
-		rettype = _PAGE_CACHE_UC_MINUS;
+		rettype = _PAGE_CACHE_MODE_UC_MINUS;
 
 	spin_unlock(&memtype_lock);
 	return rettype;
@@ -613,7 +613,7 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 		if (!pat_enabled)
 			return 0;
 
-		flags = lookup_memtype(paddr);
+		flags = cachemode2protval(lookup_memtype(paddr));
 		if (want_flags != flags) {
 			printk(KERN_WARNING "%s:%d map pfn RAM range req %s for [mem %#010Lx-%#010Lx], got %s\n",
 				current->comm, current->pid,
@@ -715,7 +715,7 @@ int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
 		    unsigned long pfn, unsigned long addr, unsigned long size)
 {
 	resource_size_t paddr = (resource_size_t)pfn << PAGE_SHIFT;
-	unsigned long flags;
+	enum page_cache_mode pcm;
 
 	/* reserve the whole chunk starting from paddr */
 	if (addr == vma->vm_start && size == (vma->vm_end - vma->vm_start)) {
@@ -734,18 +734,18 @@ int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
 	 * For anything smaller than the vma size we set prot based on the
 	 * lookup.
 	 */
-	flags = lookup_memtype(paddr);
+	pcm = lookup_memtype(paddr);
 
 	/* Check memtype for the remaining pages */
 	while (size > PAGE_SIZE) {
 		size -= PAGE_SIZE;
 		paddr += PAGE_SIZE;
-		if (flags != lookup_memtype(paddr))
+		if (pcm != lookup_memtype(paddr))
 			return -EINVAL;
 	}
 
 	*prot = __pgprot((pgprot_val(vma->vm_page_prot) & (~_PAGE_CACHE_MASK)) |
-			 flags);
+			 cachemode2protval(pcm));
 
 	return 0;
 }
@@ -753,15 +753,15 @@ int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
 int track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
 		     unsigned long pfn)
 {
-	unsigned long flags;
+	enum page_cache_mode pcm;
 
 	if (!pat_enabled)
 		return 0;
 
 	/* Set prot based on lookup */
-	flags = lookup_memtype((resource_size_t)pfn << PAGE_SHIFT);
+	pcm = lookup_memtype((resource_size_t)pfn << PAGE_SHIFT);
 	*prot = __pgprot((pgprot_val(vma->vm_page_prot) & (~_PAGE_CACHE_MASK)) |
-			 flags);
+			 cachemode2protval(pcm));
 
 	return 0;
 }
-- 
1.8.4.5

