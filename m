Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaKPK42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:56:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34841 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbaKPK40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:56:26 -0500
Date: Sun, 16 Nov 2014 02:56:12 -0800
From: tip-bot for Juergen Gross <tipbot@zytor.com>
Message-ID: <tip-d85f33342a0f57acfbe078cdd0c4f590d5608bb7@git.kernel.org>
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com, jgross@suse.com,
        linux-kernel@vger.kernel.org, stefan.bader@canonical.com
Reply-To: hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        jgross@suse.com
In-Reply-To: <1415019724-4317-8-git-send-email-jgross@suse.com>
References: <1415019724-4317-8-git-send-email-jgross@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Use new cache mode type in asm/pgtable.h
Git-Commit-ID: d85f33342a0f57acfbe078cdd0c4f590d5608bb7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d85f33342a0f57acfbe078cdd0c4f590d5608bb7
Gitweb:     http://git.kernel.org/tip/d85f33342a0f57acfbe078cdd0c4f590d5608bb7
Author:     Juergen Gross <jgross@suse.com>
AuthorDate: Mon, 3 Nov 2014 14:01:53 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 16 Nov 2014 11:04:25 +0100

x86: Use new cache mode type in asm/pgtable.h

Instead of directly using the cache mode bits in the pte switch to
using the cache mode type. This requires changing some callers of
is_new_memtype_allowed() to be changed as well.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stefan.bader@canonical.com
Cc: xen-devel@lists.xensource.com
Cc: konrad.wilk@oracle.com
Cc: ville.syrjala@linux.intel.com
Cc: david.vrabel@citrix.com
Cc: jbeulich@suse.com
Cc: toshi.kani@hp.com
Cc: plagnioj@jcrosoft.com
Cc: tomi.valkeinen@ti.com
Cc: bhelgaas@google.com
Link: http://lkml.kernel.org/r/1415019724-4317-8-git-send-email-jgross@suse.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/pgtable.h | 19 ++++++++++---------
 arch/x86/mm/ioremap.c          |  3 ++-
 arch/x86/mm/pat.c              |  8 ++++++--
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index aa97a07..c112ea6 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -9,9 +9,10 @@
 /*
  * Macro to mark a page protection value as UC-
  */
-#define pgprot_noncached(prot)					\
-	((boot_cpu_data.x86 > 3)				\
-	 ? (__pgprot(pgprot_val(prot) | _PAGE_CACHE_UC_MINUS))	\
+#define pgprot_noncached(prot)						\
+	((boot_cpu_data.x86 > 3)					\
+	 ? (__pgprot(pgprot_val(prot) |					\
+		     cachemode2protval(_PAGE_CACHE_MODE_UC_MINUS)))	\
 	 : (prot))
 
 #ifndef __ASSEMBLY__
@@ -404,8 +405,8 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 #define canon_pgprot(p) __pgprot(massage_pgprot(p))
 
 static inline int is_new_memtype_allowed(u64 paddr, unsigned long size,
-					 unsigned long flags,
-					 unsigned long new_flags)
+					 enum page_cache_mode pcm,
+					 enum page_cache_mode new_pcm)
 {
 	/*
 	 * PAT type is always WB for untracked ranges, so no need to check.
@@ -419,10 +420,10 @@ static inline int is_new_memtype_allowed(u64 paddr, unsigned long size,
 	 * - request is uncached, return cannot be write-back
 	 * - request is write-combine, return cannot be write-back
 	 */
-	if ((flags == _PAGE_CACHE_UC_MINUS &&
-	     new_flags == _PAGE_CACHE_WB) ||
-	    (flags == _PAGE_CACHE_WC &&
-	     new_flags == _PAGE_CACHE_WB)) {
+	if ((pcm == _PAGE_CACHE_MODE_UC_MINUS &&
+	     new_pcm == _PAGE_CACHE_MODE_WB) ||
+	    (pcm == _PAGE_CACHE_MODE_WC &&
+	     new_pcm == _PAGE_CACHE_MODE_WB)) {
 		return 0;
 	}
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index af78e50..3a81eb9 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -142,7 +142,8 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 
 	if (prot_val != new_prot_val) {
 		if (!is_new_memtype_allowed(phys_addr, size,
-					    prot_val, new_prot_val)) {
+				pgprot2cachemode(__pgprot(prot_val)),
+				pgprot2cachemode(__pgprot(new_prot_val)))) {
 			printk(KERN_ERR
 		"ioremap error for 0x%llx-0x%llx, requested 0x%lx, got 0x%lx\n",
 				(unsigned long long)phys_addr,
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 6574388..47282c2 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -455,7 +455,9 @@ int io_reserve_memtype(resource_size_t start, resource_size_t end,
 	if (ret)
 		goto out_err;
 
-	if (!is_new_memtype_allowed(start, size, req_type, new_type))
+	if (!is_new_memtype_allowed(start, size,
+				    pgprot2cachemode(__pgprot(req_type)),
+				    pgprot2cachemode(__pgprot(new_type))))
 		goto out_free;
 
 	if (kernel_map_sync_memtype(start, size, new_type) < 0)
@@ -630,7 +632,9 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 
 	if (flags != want_flags) {
 		if (strict_prot ||
-		    !is_new_memtype_allowed(paddr, size, want_flags, flags)) {
+		    !is_new_memtype_allowed(paddr, size,
+				pgprot2cachemode(__pgprot(want_flags)),
+				pgprot2cachemode(__pgprot(flags)))) {
 			free_memtype(paddr, paddr + size);
 			printk(KERN_ERR "%s:%d map pfn expected mapping type %s"
 				" for [mem %#010Lx-%#010Lx], got %s\n",
