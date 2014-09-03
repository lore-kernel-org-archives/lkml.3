Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935413AbaICXKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:10:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbaICWSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.16 058/125] KVM: s390/mm: Fix page table locking vs. split pmd lock
Date: Wed,  3 Sep 2014 15:06:55 -0700
Message-Id: <20140903220625.419757077@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 55e4283c3eb1d850893f645dd695c9c75d5fa1fc upstream.

commit ec66ad66a0de87866be347b5ecc83bd46427f53b (s390/mm: enable
split page table lock for PMD level) activated the split pmd lock
for s390. Turns out that we missed one place: We also have to take
the pmd lock instead of the page table lock when we reallocate the
page tables (==> changing entries in the PMD) during sie enablement.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/mm/pgtable.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -1279,6 +1279,7 @@ static unsigned long page_table_realloc_
 {
 	unsigned long next, *table, *new;
 	struct page *page;
+	spinlock_t *ptl;
 	pmd_t *pmd;
 
 	pmd = pmd_offset(pud, addr);
@@ -1296,7 +1297,7 @@ again:
 		if (!new)
 			return -ENOMEM;
 
-		spin_lock(&mm->page_table_lock);
+		ptl = pmd_lock(mm, pmd);
 		if (likely((unsigned long *) pmd_deref(*pmd) == table)) {
 			/* Nuke pmd entry pointing to the "short" page table */
 			pmdp_flush_lazy(mm, addr, pmd);
@@ -1310,7 +1311,7 @@ again:
 			page_table_free_rcu(tlb, table);
 			new = NULL;
 		}
-		spin_unlock(&mm->page_table_lock);
+		spin_unlock(ptl);
 		if (new) {
 			page_table_free_pgste(new);
 			goto again;


