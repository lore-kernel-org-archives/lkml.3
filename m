Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094Ab3GCTDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:03:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965047Ab3GCTAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:32 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=4TAXsHUxBEcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=T8t_PCEUtHcA:10 a=VnNF1IyMAAAA:8 a=1XWaLZrsAAAA:8 a=wMNdZWldAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=UTB_XpHje0EA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184049.892591791@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [032/141] mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0032-mm-THP-use-pmd_populate-to-update-the-pmd-with-pgtab.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

[ Upstream commit 7c3425123ddfdc5f48e7913ff59d908789712b18 ]

We should not use set_pmd_at to update pmd_t with pgtable_t pointer.
set_pmd_at is used to set pmd with huge pte entries and architectures
like ppc64, clear few flags from the pte when saving a new entry.
Without this change we observe bad pte errors like below on ppc64 with
THP enabled.

  BUG: Bad page map in process ld mm=0xc000001ee39f4780 pte:7fc3f37848000001 pmd:c000001ec0000000

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/huge_memory.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 141dbb6..29301d4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1954,7 +1954,12 @@ static void collapse_huge_page(struct mm_struct *mm,
 		pte_unmap(pte);
 		spin_lock(&mm->page_table_lock);
 		BUG_ON(!pmd_none(*pmd));
-		set_pmd_at(mm, address, pmd, _pmd);
+		/*
+		 * We can only use set_pmd_at when establishing
+		 * hugepmds and never for establishing regular pmds that
+		 * points to regular pagetables. Use pmd_populate for that
+		 */
+		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		spin_unlock(&mm->page_table_lock);
 		anon_vma_unlock(vma->anon_vma);
 		goto out;
-- 
1.7.10.4


