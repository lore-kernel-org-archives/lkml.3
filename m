Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3CLWdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:33:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab3CLWci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Subash Patel <subash.rp@samsung.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 004/100] ARM: 7654/1: Preserve L_PTE_VALID in pte_modify()
Date: Tue, 12 Mar 2013 15:30:49 -0700
Message-Id: <20130312223123.379378133@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 69dde4c52dbac2891b49ff9723d9c84efc5baf6f upstream.

Following commit 26ffd0d4 (ARM: mm: introduce present, faulting entries
for PAGE_NONE), if a page has been mapped as PROT_NONE, the L_PTE_VALID
bit is cleared by the set_pte_ext() code. With LPAE the software and
hardware pte share the same location and subsequent modifications of pte
range (change_protection()) will leave the L_PTE_VALID bit cleared.

This patch adds the L_PTE_VALID bit to the newprot mask in pte_modify().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Subash Patel <subash.rp@samsung.com>
Tested-by: Subash Patel <subash.rp@samsung.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/pgtable.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -240,7 +240,8 @@ static inline pte_t pte_mkspecial(pte_t
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
-	const pteval_t mask = L_PTE_XN | L_PTE_RDONLY | L_PTE_USER | L_PTE_NONE;
+	const pteval_t mask = L_PTE_XN | L_PTE_RDONLY | L_PTE_USER |
+		L_PTE_NONE | L_PTE_VALID;
 	pte_val(pte) = (pte_val(pte) & ~mask) | (pgprot_val(newprot) & mask);
 	return pte;
 }


