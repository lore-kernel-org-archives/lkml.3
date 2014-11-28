Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaK1Kyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:54:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaK1KyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:54:09 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andrew.cooper3@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4 10/10] xen: Speed up set_phys_to_machine() by using read-only mappings
Date: Fri, 28 Nov 2014 11:53:59 +0100
Message-Id: <1417172039-8627-11-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417172039-8627-1-git-send-email-jgross@suse.com>
References: <1417172039-8627-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of checking at each call of set_phys_to_machine() whether a
new p2m page has to be allocated due to writing an entry in a large
invalid or identity area, just map those areas read only and react
to a page fault on write by allocating the new page.

This change will make the common path with no allocation much
faster as it only requires a single write of the new mfn instead
of walking the address translation tables and checking for the
special cases.

Suggested-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 7d84473..8b5db51 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -70,6 +70,7 @@
 
 #include <asm/cache.h>
 #include <asm/setup.h>
+#include <asm/uaccess.h>
 
 #include <asm/xen/page.h>
 #include <asm/xen/hypercall.h>
@@ -316,9 +317,9 @@ static void __init xen_rebuild_p2m_list(unsigned long *p2m)
 	paravirt_alloc_pte(&init_mm, __pa(p2m_identity_pte) >> PAGE_SHIFT);
 	for (i = 0; i < PTRS_PER_PTE; i++) {
 		set_pte(p2m_missing_pte + i,
-			pfn_pte(PFN_DOWN(__pa(p2m_missing)), PAGE_KERNEL));
+			pfn_pte(PFN_DOWN(__pa(p2m_missing)), PAGE_KERNEL_RO));
 		set_pte(p2m_identity_pte + i,
-			pfn_pte(PFN_DOWN(__pa(p2m_identity)), PAGE_KERNEL));
+			pfn_pte(PFN_DOWN(__pa(p2m_identity)), PAGE_KERNEL_RO));
 	}
 
 	for (pfn = 0; pfn < xen_max_p2m_pfn; pfn += chunk) {
@@ -365,7 +366,7 @@ static void __init xen_rebuild_p2m_list(unsigned long *p2m)
 				p2m_missing : p2m_identity;
 			ptep = populate_extra_pte((unsigned long)(p2m + pfn));
 			set_pte(ptep,
-				pfn_pte(PFN_DOWN(__pa(mfns)), PAGE_KERNEL));
+				pfn_pte(PFN_DOWN(__pa(mfns)), PAGE_KERNEL_RO));
 			continue;
 		}
 
@@ -624,6 +625,9 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 		return true;
 	}
 
+	if (likely(!__put_user(mfn, xen_p2m_addr + pfn)))
+		return true;
+
 	ptep = lookup_address((unsigned long)(xen_p2m_addr + pfn), &level);
 	BUG_ON(!ptep || level != PG_LEVEL_4K);
 
@@ -633,9 +637,7 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	if (pte_pfn(*ptep) == PFN_DOWN(__pa(p2m_identity)))
 		return mfn == IDENTITY_FRAME(pfn);
 
-	xen_p2m_addr[pfn] = mfn;
-
-	return true;
+	return false;
 }
 
 bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
-- 
2.1.2

