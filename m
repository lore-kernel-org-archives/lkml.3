Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbaJCVui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:50:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbaJCVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:45:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH 3.16 210/357] KVM: s390/mm: try a cow on read only pages for key ops
Date: Fri,  3 Oct 2014 14:29:56 -0700
Message-Id: <20141003212939.841311506@linuxfoundation.org>
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

commit ab3f285f227fec62868037e9b1b1fd18294a83b8 upstream.

The PFMF instruction handler  blindly wrote the storage key even if
the page was mapped R/O in the host. Lets try a COW before continuing
and bail out in case of errors.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/mm/pgtable.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -986,11 +986,21 @@ int set_guest_storage_key(struct mm_stru
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


