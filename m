Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaIBQib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:38:31 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:46773 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaIBQi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:38:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,450,1406592000"; 
   d="scan'208";a="168376003"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 2/3] x86/xen: do not use _PAGE_IOMAP PTE flag for I/O mappings
Date: Tue, 2 Sep 2014 17:37:44 +0100
Message-ID: <1409675865-11608-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409675865-11608-1-git-send-email-david.vrabel@citrix.com>
References: <1409675865-11608-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since mfn_to_pfn() returns the correct PFN for identity mappings (as
used for MMIO regions), the use of _PAGE_IOMAP is not required in
pte_mfn_to_pfn().

Do not set the _PAGE_IOMAP flag in pte_pfn_to_mfn() and do not use it
in pte_mfn_to_pfn().

This will allow _PAGE_IOMAP to be removed, making it available for
future use.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   48 ++++--------------------------------------------
 1 file changed, 4 insertions(+), 44 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e8a1201..90e1d44 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -399,38 +399,14 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
 		if (unlikely(mfn == INVALID_P2M_ENTRY)) {
 			mfn = 0;
 			flags = 0;
-		} else {
-			/*
-			 * Paramount to do this test _after_ the
-			 * INVALID_P2M_ENTRY as INVALID_P2M_ENTRY &
-			 * IDENTITY_FRAME_BIT resolves to true.
-			 */
-			mfn &= ~FOREIGN_FRAME_BIT;
-			if (mfn & IDENTITY_FRAME_BIT) {
-				mfn &= ~IDENTITY_FRAME_BIT;
-				flags |= _PAGE_IOMAP;
-			}
-		}
+		} else
+			mfn &= ~(FOREIGN_FRAME_BIT | IDENTITY_FRAME_BIT);
 		val = ((pteval_t)mfn << PAGE_SHIFT) | flags;
 	}
 
 	return val;
 }
 
-static pteval_t iomap_pte(pteval_t val)
-{
-	if (val & _PAGE_PRESENT) {
-		unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
-		pteval_t flags = val & PTE_FLAGS_MASK;
-
-		/* We assume the pte frame number is a MFN, so
-		   just use it as-is. */
-		val = ((pteval_t)pfn << PAGE_SHIFT) | flags;
-	}
-
-	return val;
-}
-
 __visible pteval_t xen_pte_val(pte_t pte)
 {
 	pteval_t pteval = pte.pte;
@@ -441,9 +417,6 @@ __visible pteval_t xen_pte_val(pte_t pte)
 		pteval = (pteval & ~_PAGE_PAT) | _PAGE_PWT;
 	}
 #endif
-	if (xen_initial_domain() && (pteval & _PAGE_IOMAP))
-		return pteval;
-
 	return pte_mfn_to_pfn(pteval);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_pte_val);
@@ -481,7 +454,6 @@ void xen_set_pat(u64 pat)
 
 __visible pte_t xen_make_pte(pteval_t pte)
 {
-	phys_addr_t addr = (pte & PTE_PFN_MASK);
 #if 0
 	/* If Linux is trying to set a WC pte, then map to the Xen WC.
 	 * If _PAGE_PAT is set, then it probably means it is really
@@ -496,19 +468,7 @@ __visible pte_t xen_make_pte(pteval_t pte)
 			pte = (pte & ~(_PAGE_PCD | _PAGE_PWT)) | _PAGE_PAT;
 	}
 #endif
-	/*
-	 * Unprivileged domains are allowed to do IOMAPpings for
-	 * PCI passthrough, but not map ISA space.  The ISA
-	 * mappings are just dummy local mappings to keep other
-	 * parts of the kernel happy.
-	 */
-	if (unlikely(pte & _PAGE_IOMAP) &&
-	    (xen_initial_domain() || addr >= ISA_END_ADDRESS)) {
-		pte = iomap_pte(pte);
-	} else {
-		pte &= ~_PAGE_IOMAP;
-		pte = pte_pfn_to_mfn(pte);
-	}
+	pte = pte_pfn_to_mfn(pte);
 
 	return native_make_pte(pte);
 }
@@ -2094,7 +2054,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 
 	default:
 		/* By default, set_fixmap is used for hardware mappings */
-		pte = mfn_pte(phys, __pgprot(pgprot_val(prot) | _PAGE_IOMAP));
+		pte = mfn_pte(phys, prot);
 		break;
 	}
 
-- 
1.7.10.4

