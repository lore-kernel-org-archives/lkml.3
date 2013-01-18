Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab3ARJdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 04:33:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab3ARJdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 04:33:36 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Define set_pmd_at for numabalance for CONFIG_PARAVIRT
Date: Fri, 18 Jan 2013 10:33:24 +0100
Message-Id: <1358501604-6797-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_PARAVIRT defines set_pmd_at only for CONFIG_TRANSPARENT_HUGEPAGE
which leads to the following compile errors when randconfig selected
CONFIG_NUMA_BALANCING && CONFIG_PARAVIRT && !CONFIG_TRANSPARENT_HUGEPAGE:

mm/mprotect.c: In function ‘change_pmd_protnuma’:
mm/mprotect.c:120: error: implicit declaration of function ‘set_pmd_at’

mm/memory.c: In function ‘do_pmd_numa_page’:
mm/memory.c:3529: error: implicit declaration of function ‘set_pmd_at’

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 arch/x86/include/asm/paravirt.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a0facf3..f551e89 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -528,7 +528,7 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 		PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, pte.pte);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_NUMA_BALANCING)
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
-- 
1.7.10.4

