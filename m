Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaKCNFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:05:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbaKCNCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:02:14 -0500
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V6 08/18] x86: Use new cache mode type in mm/iomap_32.c
Date: Mon,  3 Nov 2014 14:01:54 +0100
Message-Id: <1415019724-4317-9-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1415019724-4317-1-git-send-email-jgross@suse.com>
References: <1415019724-4317-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of directly using the cache mode bits in the pte switch to
using the cache mode type. This requires to change
io_reserve_memtype() as well.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/pat.h |  2 +-
 arch/x86/mm/iomap_32.c     | 12 +++++++-----
 arch/x86/mm/pat.c          | 18 ++++++++++--------
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
index e2c1668..a8438bc 100644
--- a/arch/x86/include/asm/pat.h
+++ b/arch/x86/include/asm/pat.h
@@ -20,7 +20,7 @@ extern int kernel_map_sync_memtype(u64 base, unsigned long size,
 		unsigned long flag);
 
 int io_reserve_memtype(resource_size_t start, resource_size_t end,
-			unsigned long *type);
+			enum page_cache_mode *pcm);
 
 void io_free_memtype(resource_size_t start, resource_size_t end);
 
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index 7b179b49..9ca35fc 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -33,17 +33,17 @@ static int is_io_mapping_possible(resource_size_t base, unsigned long size)
 
 int iomap_create_wc(resource_size_t base, unsigned long size, pgprot_t *prot)
 {
-	unsigned long flag = _PAGE_CACHE_WC;
+	enum page_cache_mode pcm = _PAGE_CACHE_MODE_WC;
 	int ret;
 
 	if (!is_io_mapping_possible(base, size))
 		return -EINVAL;
 
-	ret = io_reserve_memtype(base, base + size, &flag);
+	ret = io_reserve_memtype(base, base + size, &pcm);
 	if (ret)
 		return ret;
 
-	*prot = __pgprot(__PAGE_KERNEL | flag);
+	*prot = __pgprot(__PAGE_KERNEL | cachemode2protval(pcm));
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iomap_create_wc);
@@ -82,8 +82,10 @@ iomap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot)
 	 * MTRR is UC or WC.  UC_MINUS gets the real intention, of the
 	 * user, which is "WC if the MTRR is WC, UC if you can't do that."
 	 */
-	if (!pat_enabled && pgprot_val(prot) == pgprot_val(PAGE_KERNEL_WC))
-		prot = PAGE_KERNEL_UC_MINUS;
+	if (!pat_enabled && pgprot_val(prot) ==
+	    (__PAGE_KERNEL | cachemode2protval(_PAGE_CACHE_MODE_WC)))
+		prot = __pgprot(__PAGE_KERNEL |
+				cachemode2protval(_PAGE_CACHE_MODE_UC_MINUS));
 
 	return (void __force __iomem *) kmap_atomic_prot_pfn(pfn, prot);
 }
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 47282c2..6d5a8e3 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -442,25 +442,27 @@ static unsigned long lookup_memtype(u64 paddr)
  * On failure, returns non-zero
  */
 int io_reserve_memtype(resource_size_t start, resource_size_t end,
-			unsigned long *type)
+			enum page_cache_mode *type)
 {
 	resource_size_t size = end - start;
-	unsigned long req_type = *type;
-	unsigned long new_type;
+	enum page_cache_mode req_type = *type;
+	enum page_cache_mode new_type;
+	unsigned long new_prot;
 	int ret;
 
 	WARN_ON_ONCE(iomem_map_sanity_check(start, size));
 
-	ret = reserve_memtype(start, end, req_type, &new_type);
+	ret = reserve_memtype(start, end, cachemode2protval(req_type),
+				&new_prot);
 	if (ret)
 		goto out_err;
 
-	if (!is_new_memtype_allowed(start, size,
-				    pgprot2cachemode(__pgprot(req_type)),
-				    pgprot2cachemode(__pgprot(new_type))))
+	new_type = pgprot2cachemode(__pgprot(new_prot));
+
+	if (!is_new_memtype_allowed(start, size, req_type, new_type))
 		goto out_free;
 
-	if (kernel_map_sync_memtype(start, size, new_type) < 0)
+	if (kernel_map_sync_memtype(start, size, new_prot) < 0)
 		goto out_free;
 
 	*type = new_type;
-- 
1.8.4.5

