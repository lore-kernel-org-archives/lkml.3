Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab3FDRIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:08:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48508 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158Ab3FDRCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:02:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 52/75] mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer
Date: Tue,  4 Jun 2013 09:55:36 -0700
Message-Id: <1370364959-9475-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit 7c3425123ddfdc5f48e7913ff59d908789712b18 upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b795dcf..9459edd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2366,7 +2366,12 @@ static void collapse_huge_page(struct mm_struct *mm,
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
 		anon_vma_unlock_write(vma->anon_vma);
 		goto out;
-- 
1.8.1.2

