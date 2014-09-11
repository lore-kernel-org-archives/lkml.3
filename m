Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaIKMeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:34:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51476 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 11 Sep 2014 13:32:14 +0100
Message-ID: <lsq.1410438734.230798163@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 130/131] x86/espfix/xen: Fix allocation of pages for
 paravirt  page tables
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

commit 8762e5092828c4dc0f49da5a47a644c670df77f3 upstream.

init_espfix_ap() is currently off by one level when informing hypervisor
that allocated pages will be used for ministacks' page tables.

The most immediate effect of this on a PV guest is that if
'stack_page = __get_free_page()' returns a non-zeroed-out page the hypervisor
will refuse to use it for a page table (which it shouldn't be anyway). This will
result in warnings by both Xen and Linux.

More importantly, a subsequent write to that page (again, by a PV guest) is
likely to result in fatal page fault.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: http://lkml.kernel.org/r/1404926298-5565-1-git-send-email-boris.ostrovsky@oracle.com
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/espfix_64.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/espfix_64.c
+++ b/arch/x86/kernel/espfix_64.c
@@ -175,7 +175,7 @@ void init_espfix_ap(void)
 	if (!pud_present(pud)) {
 		pmd_p = (pmd_t *)__get_free_page(PGALLOC_GFP);
 		pud = __pud(__pa(pmd_p) | (PGTABLE_PROT & ptemask));
-		paravirt_alloc_pud(&init_mm, __pa(pmd_p) >> PAGE_SHIFT);
+		paravirt_alloc_pmd(&init_mm, __pa(pmd_p) >> PAGE_SHIFT);
 		for (n = 0; n < ESPFIX_PUD_CLONES; n++)
 			set_pud(&pud_p[n], pud);
 	}
@@ -185,7 +185,7 @@ void init_espfix_ap(void)
 	if (!pmd_present(pmd)) {
 		pte_p = (pte_t *)__get_free_page(PGALLOC_GFP);
 		pmd = __pmd(__pa(pte_p) | (PGTABLE_PROT & ptemask));
-		paravirt_alloc_pmd(&init_mm, __pa(pte_p) >> PAGE_SHIFT);
+		paravirt_alloc_pte(&init_mm, __pa(pte_p) >> PAGE_SHIFT);
 		for (n = 0; n < ESPFIX_PMD_CLONES; n++)
 			set_pmd(&pmd_p[n], pmd);
 	}
@@ -193,7 +193,6 @@ void init_espfix_ap(void)
 	pte_p = pte_offset_kernel(&pmd, addr);
 	stack_page = (void *)__get_free_page(GFP_KERNEL);
 	pte = __pte(__pa(stack_page) | (__PAGE_KERNEL_RO & ptemask));
-	paravirt_alloc_pte(&init_mm, __pa(stack_page) >> PAGE_SHIFT);
 	for (n = 0; n < ESPFIX_PTE_CLONES; n++)
 		set_pte(&pte_p[n*PTE_STRIDE], pte);
 

