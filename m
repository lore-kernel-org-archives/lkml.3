Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab3ASBgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:36:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:56239 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473Ab3ASBRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:17:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 04/33] arm64: mm: only wrprotect clean ptes if they are present
Date: Fri, 18 Jan 2013 17:16:29 -0800
Message-Id: <20130119010347.330247690@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 02522463c84748b3b8ad770f9424bcfa70a5b4c4 upstream.

Marking non-present ptes as read-only can corrupt file ptes, breaking
things like swap and file mappings.

This patch ensures that we only manipulate user pte bits when the pte
is marked present.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/pgtable.h |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -132,9 +132,8 @@ extern struct page *empty_zero_page;
 #define pte_write(pte)		(!(pte_val(pte) & PTE_RDONLY))
 #define pte_exec(pte)		(!(pte_val(pte) & PTE_UXN))
 
-#define pte_present_exec_user(pte) \
-	((pte_val(pte) & (PTE_VALID | PTE_USER | PTE_UXN)) == \
-	 (PTE_VALID | PTE_USER))
+#define pte_present_user(pte) \
+	((pte_val(pte) & (PTE_VALID | PTE_USER)) == (PTE_VALID | PTE_USER))
 
 #define PTE_BIT_FUNC(fn,op) \
 static inline pte_t pte_##fn(pte_t pte) { pte_val(pte) op; return pte; }
@@ -157,10 +156,13 @@ extern void __sync_icache_dcache(pte_t p
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte)
 {
-	if (pte_present_exec_user(pte))
-		__sync_icache_dcache(pte, addr);
-	if (!pte_dirty(pte))
-		pte = pte_wrprotect(pte);
+	if (pte_present_user(pte)) {
+		if (pte_exec(pte))
+			__sync_icache_dcache(pte, addr);
+		if (!pte_dirty(pte))
+			pte = pte_wrprotect(pte);
+	}
+
 	set_pte(ptep, pte);
 }
 


