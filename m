Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3FPBPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 21:15:47 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:52150 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab3FPBPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 21:15:11 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 7/7] mm/pgtable: Don't accumulate addr during pgd prepopulate pmd
Date: Sun, 16 Jun 2013 09:14:50 +0800
Message-Id: <1371345290-19588-7-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371345290-19588-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1371345290-19588-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061601-9264-0000-0000-000003F3A4A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old codes accumulate addr to get right pmd, however,
currently pmds are preallocated and transfered as a parameter,
there is unnecessary to accumulate addr variable any more, this
patch remove it.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 arch/x86/mm/pgtable.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 17fda6a..cb787da 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -240,7 +240,6 @@ static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
 static void pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd, pmd_t *pmds[])
 {
 	pud_t *pud;
-	unsigned long addr;
 	int i;
 
 	if (PREALLOCATED_PMDS == 0) /* Work around gcc-3.4.x bug */
@@ -248,8 +247,7 @@ static void pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd, pmd_t *pmds[])
 
 	pud = pud_offset(pgd, 0);
 
- 	for (addr = i = 0; i < PREALLOCATED_PMDS;
-	     i++, pud++, addr += PUD_SIZE) {
+	for (i = 0; i < PREALLOCATED_PMDS; i++, pud++) {
 		pmd_t *pmd = pmds[i];
 
 		if (i >= KERNEL_PGD_BOUNDARY)
-- 
1.8.1.2

