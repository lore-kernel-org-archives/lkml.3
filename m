Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaDXLaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:30:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46457 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbaDXIxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 047/182] arm64: Do not synchronise I and D caches for special ptes
Date: Thu, 24 Apr 2014 09:49:32 +0100
Message-Id: <1398329507-5911-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 5dee621..b2d597b 100644
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

