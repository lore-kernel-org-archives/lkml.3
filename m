Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab3FEU6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:58:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab3FEUx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:53:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 22/33] mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer
Date: Wed,  5 Jun 2013 13:53:00 -0700
Message-Id: <20130605204707.463300361@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605204702.359510786@linuxfoundation.org>
References: <20130605204702.359510786@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/huge_memory.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1893,7 +1893,12 @@ static void collapse_huge_page(struct mm
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


