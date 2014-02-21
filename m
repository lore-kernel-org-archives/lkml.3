Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbaBUNwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:52:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46821 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbaBUMtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 027/121] arm64: Invalidate the TLB when replacing pmd entries during boot
Date: Fri, 21 Feb 2014 12:47:31 +0000
Message-Id: <1392986945-9693-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit a55f9929a9b257f84b6cc7b2397379cabd744a22 upstream.

With the 64K page size configuration, __create_page_tables in head.S
maps enough memory to get started but using 64K pages rather than 512M
sections with a single pgd/pud/pmd entry pointing to a pte table.
create_mapping() may override the pgd/pud/pmd table entry with a block
(section) one if the RAM size is more than 512MB and aligned correctly.
For the end of this block to be accessible, the old TLB entry must be
invalidated.

Reported-by: Mark Salter <msalter@redhat.com>
Tested-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/mm/mmu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a8d1059..49961d1f 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -203,10 +203,18 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 	do {
 		next = pmd_addr_end(addr, end);
 		/* try section mapping first */
-		if (((addr | next | phys) & ~SECTION_MASK) == 0)
+		if (((addr | next | phys) & ~SECTION_MASK) == 0) {
+			pmd_t old_pmd =*pmd;
 			set_pmd(pmd, __pmd(phys | prot_sect_kernel));
-		else
+			/*
+			 * Check for previous table entries created during
+			 * boot (__create_page_tables) and flush them.
+			 */
+			if (!pmd_none(old_pmd))
+				flush_tlb_all();
+		} else {
 			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys));
+		}
 		phys += next - addr;
 	} while (pmd++, addr = next, addr != end);
 }
-- 
1.9.0

