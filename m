Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbbAOJAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:00:54 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:48117 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbbAOI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:58:19 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 2/8] ppc/hugetlbfs: Replace ACCESS_ONCE with READ_ONCE
Date: Thu, 15 Jan 2015 09:58:28 +0100
Message-Id: <1421312314-72330-3-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421312314-72330-1-git-send-email-borntraeger@de.ibm.com>
References: <1421312314-72330-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011508-0029-0000-0000-000002D00B20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Change the ppc/hugetlbfs code to replace ACCESS_ONCE with READ_ONCE.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/powerpc/mm/hugetlbpage.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 5ff4e07..620d0ec 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -978,7 +978,7 @@ pte_t *find_linux_pte_or_hugepte(pgd_t *pgdir, unsigned long ea, unsigned *shift
 		 */
 		pdshift = PUD_SHIFT;
 		pudp = pud_offset(&pgd, ea);
-		pud  = ACCESS_ONCE(*pudp);
+		pud  = READ_ONCE(*pudp);
 
 		if (pud_none(pud))
 			return NULL;
@@ -990,7 +990,7 @@ pte_t *find_linux_pte_or_hugepte(pgd_t *pgdir, unsigned long ea, unsigned *shift
 		else {
 			pdshift = PMD_SHIFT;
 			pmdp = pmd_offset(&pud, ea);
-			pmd  = ACCESS_ONCE(*pmdp);
+			pmd  = READ_ONCE(*pmdp);
 			/*
 			 * A hugepage collapse is captured by pmd_none, because
 			 * it mark the pmd none and do a hpte invalidate.
-- 
1.9.3

