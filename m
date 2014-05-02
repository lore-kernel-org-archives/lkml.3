Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaEBPos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:44:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44123 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbaEBPoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:44:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 044/151] arm64: Do not synchronise I and D caches for special ptes
Date: Fri,  2 May 2014 08:37:12 -0700
Message-Id: <1399045139-4531-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 71fdb6bf61bf0692f004f9daf5650392c0cfe300 upstream.

Special pte mappings are not intended to be executable and do not even
have an associated struct page. This patch ensures that we do not call
__sync_icache_dcache() on such ptes.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Steve Capper <Steve.Capper@arm.com>
Tested-by: Laura Abbott <lauraa@codeaurora.org>
Tested-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a08be42..322fe5b 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -168,7 +168,7 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte)
 {
 	if (pte_valid_user(pte)) {
-		if (pte_exec(pte))
+		if (!pte_special(pte) && pte_exec(pte))
 			__sync_icache_dcache(pte, addr);
 		if (!pte_dirty(pte))
 			pte = pte_wrprotect(pte);
-- 
1.9.1

