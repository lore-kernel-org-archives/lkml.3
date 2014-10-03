Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaJCVuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:50:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbaJCVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:45:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.16 211/357] KVM: s390/mm: Fix storage key corruption during swapping
Date: Fri,  3 Oct 2014 14:29:57 -0700
Message-Id: <20141003212939.869998199@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 3e03d4c46daa849880837d802e41c14132a03ef9 upstream.

Since 3.12 or more precisely  commit 0944fe3f4a32 ("s390/mm:
implement software referenced bits") guest storage keys get
corrupted during paging. This commit added another valid->invalid
translation for page tables - namely ptep_test_and_clear_young.
We have to transfer the storage key into the pgste in that case.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/pgtable.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1115,7 +1115,7 @@ static inline int ptep_test_and_clear_yo
 					    unsigned long addr, pte_t *ptep)
 {
 	pgste_t pgste;
-	pte_t pte;
+	pte_t pte, oldpte;
 	int young;
 
 	if (mm_has_pgste(vma->vm_mm)) {
@@ -1123,12 +1123,13 @@ static inline int ptep_test_and_clear_yo
 		pgste = pgste_ipte_notify(vma->vm_mm, ptep, pgste);
 	}
 
-	pte = *ptep;
+	oldpte = pte = *ptep;
 	ptep_flush_direct(vma->vm_mm, addr, ptep);
 	young = pte_young(pte);
 	pte = pte_mkold(pte);
 
 	if (mm_has_pgste(vma->vm_mm)) {
+		pgste = pgste_update_all(&oldpte, pgste, vma->vm_mm);
 		pgste = pgste_set_pte(ptep, pgste, pte);
 		pgste_set_unlock(ptep, pgste);
 	} else


