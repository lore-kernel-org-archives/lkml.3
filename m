Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaKCNFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:05:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaKCNCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:02:14 -0500
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V6 06/18] x86: Use new cache mode type in arch/x86/mm/init_64.c
Date: Mon,  3 Nov 2014 14:01:52 +0100
Message-Id: <1415019724-4317-7-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1415019724-4317-1-git-send-email-jgross@suse.com>
References: <1415019724-4317-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of directly using the cache mode bits in the pte switch to
using the cache mode type.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/init_64.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4cb8763..5390a5f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -338,12 +338,15 @@ pte_t * __init populate_extra_pte(unsigned long vaddr)
  * Create large page table mappings for a range of physical addresses.
  */
 static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
-						pgprot_t prot)
+					enum page_cache_mode cache)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
+	pgprot_t prot;
 
+	pgprot_val(prot) = pgprot_val(PAGE_KERNEL_LARGE) |
+		pgprot_val(pgprot_4k_2_large(cachemode2pgprot(cache)));
 	BUG_ON((phys & ~PMD_MASK) || (size & ~PMD_MASK));
 	for (; size; phys += PMD_SIZE, size -= PMD_SIZE) {
 		pgd = pgd_offset_k((unsigned long)__va(phys));
@@ -366,12 +369,12 @@ static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
 
 void __init init_extra_mapping_wb(unsigned long phys, unsigned long size)
 {
-	__init_extra_mapping(phys, size, PAGE_KERNEL_LARGE);
+	__init_extra_mapping(phys, size, _PAGE_CACHE_MODE_WB);
 }
 
 void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
 {
-	__init_extra_mapping(phys, size, PAGE_KERNEL_LARGE_NOCACHE);
+	__init_extra_mapping(phys, size, _PAGE_CACHE_MODE_UC);
 }
 
 /*
-- 
1.8.4.5

