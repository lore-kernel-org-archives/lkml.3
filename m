Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaI3VjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:39:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32925 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaI3VjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 079/103] KVM: s390/mm: try a cow on read only pages for key ops
Date: Tue, 30 Sep 2014 14:31:24 -0700
Message-Id: <1412112708-27356-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit ab3f285f227fec62868037e9b1b1fd18294a83b8 upstream.

The PFMF instruction handler  blindly wrote the storage key even if
the page was mapped R/O in the host. Lets try a COW before continuing
and bail out in case of errors.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/mm/pgtable.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index e794c88..9cffb96 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -810,11 +810,21 @@ int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
 	pte_t *ptep;
 
 	down_read(&mm->mmap_sem);
+retry:
 	ptep = get_locked_pte(current->mm, addr, &ptl);
 	if (unlikely(!ptep)) {
 		up_read(&mm->mmap_sem);
 		return -EFAULT;
 	}
+	if (!(pte_val(*ptep) & _PAGE_INVALID) &&
+	     (pte_val(*ptep) & _PAGE_PROTECT)) {
+			pte_unmap_unlock(*ptep, ptl);
+			if (fixup_user_fault(current, mm, addr, FAULT_FLAG_WRITE)) {
+				up_read(&mm->mmap_sem);
+				return -EFAULT;
+			}
+			goto retry;
+		}
 
 	new = old = pgste_get_lock(ptep);
 	pgste_val(new) &= ~(PGSTE_GR_BIT | PGSTE_GC_BIT |
-- 
1.9.1

