Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaHESmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:42:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbaHESOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.15 42/42] x86/espfix/xen: Fix allocation of pages for paravirt page tables
Date: Tue,  5 Aug 2014 11:13:56 -0700
Message-Id: <20140805181322.294199824@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181321.018370988@linuxfoundation.org>
References: <20140805181321.018370988@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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

---
 arch/x86/kernel/espfix_64.c |    5 ++---
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
 


