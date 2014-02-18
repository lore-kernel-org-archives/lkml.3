Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaBRXOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:14:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaBRWql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Salter <msalter@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.12 11/32] arm64: Invalidate the TLB when replacing pmd entries during boot
Date: Tue, 18 Feb 2014 14:47:11 -0800
Message-Id: <20140218224500.424811126@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224500.101465031@linuxfoundation.org>
References: <20140218224500.101465031@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/mmu.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -203,10 +203,18 @@ static void __init alloc_init_pmd(pud_t
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


