Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaKKFou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:44:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbaKKFoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:44:00 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V3 8/8] xen: Speed up set_phys_to_machine() by using read-only mappings
Date: Tue, 11 Nov 2014 06:43:46 +0100
Message-Id: <1415684626-18590-9-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1415684626-18590-1-git-send-email-jgross@suse.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
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
---
 arch/x86/xen/p2m.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 7df446d..58cf04c 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -70,6 +70,7 @@
 
 #include <asm/cache.h>
 #include <asm/setup.h>
+#include <asm/uaccess.h>
 
 #include <asm/xen/page.h>
 #include <asm/xen/hypercall.h>
@@ -313,9 +314,9 @@ static void __init xen_rebuild_p2m_list(unsigned long *p2m)
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
@@ -362,7 +363,7 @@ static void __init xen_rebuild_p2m_list(unsigned long *p2m)
 				p2m_missing : p2m_identity;
 			ptep = populate_extra_pte((unsigned long)(p2m + pfn));
 			set_pte(ptep,
-				pfn_pte(PFN_DOWN(__pa(mfns)), PAGE_KERNEL));
+				pfn_pte(PFN_DOWN(__pa(mfns)), PAGE_KERNEL_RO));
 			continue;
 		}
 
@@ -621,6 +622,9 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 		return true;
 	}
 
+	if (likely(!__put_user(mfn, xen_p2m_addr + pfn)))
+		return true;
+
 	ptep = lookup_address((unsigned long)(xen_p2m_addr + pfn), &level);
 	BUG_ON(!ptep || level != PG_LEVEL_4K);
 
@@ -630,9 +634,7 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
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

