Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaDDRmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:42:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46157 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaDDRmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:42:42 -0400
X-IronPort-AV: E=Sophos;i="4.97,796,1389744000"; 
   d="scan'208";a="118094182"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Steven Noonan <steven@uplinklabs.net>,
        Elena Ufimtseva <ufimtseva@gmail.com>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH] x86: use pv-ops in {pte,pmd}_{set,clear}_flags()
Date: Fri, 4 Apr 2014 18:42:07 +0100
Message-ID: <1396633327-9070-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using native functions to operate on the PTEs in
pte_set_flags(), pte_clear_flags(), pmd_set_flags(), pmd_clear_flags()
use the PV aware ones.

This fixes a regression in Xen PV guests introduced by 1667918b6483
(mm: numa: clear numa hinting information on mprotect).

This has negligible performance impact on native since the pte_val()
and __pte() (etc.) calls are patched at runtime when running on bare
metal.  Measurements on a 3 GHz AMD 4284 give approx. 0.3 ns (~1 clock
cycle) of additional time for each function.

Xen PV guest page tables require that their entries use machine
addresses if the preset bit (_PAGE_PRESENT) is set, and (for
successful migration) non-present PTEs must use pseudo-physical
addresses.  This is because on migration MFNs only present PTEs are
translated to PFNs (canonicalised) so they may be translated back to
the new MFN in the destination domain (uncanonicalised).

pte_mknonnuma(), pmd_mknonnuma(), pte_mknuma() and pmd_mknuma() set
and clear the _PAGE_PRESENT bit using pte_set_flags(),
pte_clear_flags(), etc.

In a Xen PV guest, these functions must translate MFNs to PFNs when
clearing _PAGE_PRESENT and translate PFNs to MFNs when setting
_PAGE_PRESENT.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Steven Noonan <steven@uplinklabs.net>
Cc: Elena Ufimtseva <ufimtseva@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>        [3.12+]
---
 arch/x86/include/asm/pgtable.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index bbc8b12..323e5e2 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -174,16 +174,16 @@ static inline int has_transparent_hugepage(void)
 
 static inline pte_t pte_set_flags(pte_t pte, pteval_t set)
 {
-	pteval_t v = native_pte_val(pte);
+	pteval_t v = pte_val(pte);
 
-	return native_make_pte(v | set);
+	return __pte(v | set);
 }
 
 static inline pte_t pte_clear_flags(pte_t pte, pteval_t clear)
 {
-	pteval_t v = native_pte_val(pte);
+	pteval_t v = pte_val(pte);
 
-	return native_make_pte(v & ~clear);
+	return __pte(v & ~clear);
 }
 
 static inline pte_t pte_mkclean(pte_t pte)
@@ -248,14 +248,14 @@ static inline pte_t pte_mkspecial(pte_t pte)
 
 static inline pmd_t pmd_set_flags(pmd_t pmd, pmdval_t set)
 {
-	pmdval_t v = native_pmd_val(pmd);
+	pmdval_t v = pmd_val(pmd);
 
 	return __pmd(v | set);
 }
 
 static inline pmd_t pmd_clear_flags(pmd_t pmd, pmdval_t clear)
 {
-	pmdval_t v = native_pmd_val(pmd);
+	pmdval_t v = pmd_val(pmd);
 
 	return __pmd(v & ~clear);
 }
-- 
1.7.2.5

