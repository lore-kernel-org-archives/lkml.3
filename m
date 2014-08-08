Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbaHHUrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:47:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40587 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063AbaHHUrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 191/259] ARM: fix alignment of keystone page table fixup
Date: Fri,  8 Aug 2014 13:40:14 -0700
Message-Id: <1407530482-4483-192-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 823a19cd3b91b0729d7417f1848413846be61712 upstream.

If init_mm.brk is not section aligned, the LPAE fixup code will miss
updating the final PMD.  Fix this by aligning map_end.

Fixes: a77e0c7b2774 ("ARM: mm: Recreate kernel mappings in early_paging_init()")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mm/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index dd0949f..b8c90c5 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1352,8 +1352,8 @@ void __init early_paging_init(const struct machine_desc *mdesc,
 		return;
 
 	/* remap kernel code and data */
-	map_start = init_mm.start_code;
-	map_end   = init_mm.brk;
+	map_start = init_mm.start_code & PMD_MASK;
+	map_end   = ALIGN(init_mm.brk, PMD_SIZE);
 
 	/* get a handle on things... */
 	pgd0 = pgd_offset_k(0);
@@ -1388,7 +1388,7 @@ void __init early_paging_init(const struct machine_desc *mdesc,
 	}
 
 	/* remap pmds for kernel mapping */
-	phys = __pa(map_start) & PMD_MASK;
+	phys = __pa(map_start);
 	do {
 		*pmdk++ = __pmd(phys | pmdprot);
 		phys += PMD_SIZE;
-- 
1.9.1

