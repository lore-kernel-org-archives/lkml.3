Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab3FEVgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:36:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab3FEVf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefky <schwidefsky@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [ 079/127] s390/pgtable: Fix check for pgste/storage key handling
Date: Wed,  5 Jun 2013 14:34:06 -0700
Message-Id: <20130605213226.934884205@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit b56433cb782d1cc7e44fc46d2ce3917fa75d2236 upstream.

pte_present might return true on PAGE_TYPE_NONE, even if
the invalid bit is on. Modify the existing check of the
pgste functions to avoid crashes.

[ Martin Schwidefsky: added ptep_modify_prot_[start|commit] bits ]

Reported-by: Martin Schwidefky <schwidefsky@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/pgtable.h |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -637,7 +637,7 @@ static inline pgste_t pgste_update_all(p
 	unsigned long address, bits;
 	unsigned char skey;
 
-	if (!pte_present(*ptep))
+	if (pte_val(*ptep) & _PAGE_INVALID)
 		return pgste;
 	address = pte_val(*ptep) & PAGE_MASK;
 	skey = page_get_storage_key(address);
@@ -671,7 +671,7 @@ static inline pgste_t pgste_update_young
 #ifdef CONFIG_PGSTE
 	int young;
 
-	if (!pte_present(*ptep))
+	if (pte_val(*ptep) & _PAGE_INVALID)
 		return pgste;
 	/* Get referenced bit from storage key */
 	young = page_reset_referenced(pte_val(*ptep) & PAGE_MASK);
@@ -697,7 +697,7 @@ static inline void pgste_set_key(pte_t *
 	unsigned long address;
 	unsigned long okey, nkey;
 
-	if (!pte_present(entry))
+	if (pte_val(entry) & _PAGE_INVALID)
 		return;
 	address = pte_val(entry) & PAGE_MASK;
 	okey = nkey = page_get_storage_key(address);
@@ -1072,6 +1072,9 @@ static inline pte_t ptep_modify_prot_sta
 	pte = *ptep;
 	if (!mm_exclusive(mm))
 		__ptep_ipte(address, ptep);
+
+	if (mm_has_pgste(mm))
+		pgste = pgste_update_all(&pte, pgste);
 	return pte;
 }
 
@@ -1079,9 +1082,13 @@ static inline void ptep_modify_prot_comm
 					   unsigned long address,
 					   pte_t *ptep, pte_t pte)
 {
+	pgste_t pgste;
+
 	if (mm_has_pgste(mm)) {
+		pgste = *(pgste_t *)(ptep + PTRS_PER_PTE);
+		pgste_set_key(ptep, pgste, pte);
 		pgste_set_pte(ptep, pte);
-		pgste_set_unlock(ptep, *(pgste_t *)(ptep + PTRS_PER_PTE));
+		pgste_set_unlock(ptep, pgste);
 	} else
 		*ptep = pte;
 }


