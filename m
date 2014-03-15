Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaCOKsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 06:48:23 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34937 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbaCOKsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 06:48:21 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: benh@kernel.crashing.org, paulus@samba.org, Rik van Riel <riel@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] powerpc/mm: Make sure a local_irq_disable prevent a parallel THP split
Date: Sat, 15 Mar 2014 16:17:58 +0530
Message-Id: <1394880478-770-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.2
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031510-3864-0000-0000-00000CFAA251
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

We have generic code like the one in get_futex_key that assume that
a local_irq_disable prevents a parallel THP split. Support that by
adding a dummy smp call function after setting _PAGE_SPLITTING. Code
paths like get_user_pages_fast still need to check for _PAGE_SPLITTING
after disabling IRQ which indicate that a parallel THP splitting is
ongoing. Now if they don't find _PAGE_SPLITTING set, then we can be
sure that parallel split will now block in pmdp_splitting flush
until we enables IRQ

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/powerpc/mm/pgtable_64.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/mm/pgtable_64.c b/arch/powerpc/mm/pgtable_64.c
index 62bf5e8e78da..f6ce1f111f5b 100644
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -647,6 +647,11 @@ void pmdp_splitting_flush(struct vm_area_struct *vma,
 		if (old & _PAGE_HASHPTE)
 			hpte_do_hugepage_flush(vma->vm_mm, address, pmdp);
 	}
+	/*
+	 * This ensures that generic code that rely on IRQ disabling
+	 * to prevent a parallel THP split work as expected.
+	 */
+	kick_all_cpus_sync();
 }
 
 /*
-- 
1.8.3.2

