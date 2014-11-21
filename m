Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbaKUN6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:58:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758718AbaKUN6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:58:02 -0500
From: Mel Gorman <mgorman@suse.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 08/10] x86: mm: Restore original pte_special check
Date: Fri, 21 Nov 2014 13:57:46 +0000
Message-Id: <1416578268-19597-9-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1416578268-19597-1-git-send-email-mgorman@suse.de>
References: <1416578268-19597-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b38af4721f59 ("x86,mm: fix pte_special versus pte_numa") adjusted
the pte_special check to take into account that a special pte had SPECIAL
and neither PRESENT nor PROTNONE. Now that NUMA hinting PTEs are no
longer modifying _PAGE_PRESENT it should be safe to restore the original
pte_special behaviour.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/include/asm/pgtable.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index cf428a7..0dd5be3 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -136,13 +136,7 @@ static inline int pte_exec(pte_t pte)
 
 static inline int pte_special(pte_t pte)
 {
-	/*
-	 * See CONFIG_NUMA_BALANCING pte_numa in include/asm-generic/pgtable.h.
-	 * On x86 we have _PAGE_BIT_NUMA == _PAGE_BIT_GLOBAL+1 ==
-	 * __PAGE_BIT_SOFTW1 == _PAGE_BIT_SPECIAL.
-	 */
-	return (pte_flags(pte) & _PAGE_SPECIAL) &&
-		(pte_flags(pte) & (_PAGE_PRESENT|_PAGE_PROTNONE));
+	return pte_flags(pte) & _PAGE_SPECIAL;
 }
 
 static inline unsigned long pte_pfn(pte_t pte)
-- 
2.1.2

