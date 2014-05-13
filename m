Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbaEMKk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:40:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60767 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760037AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 006/182] arm64: Do not synchronise I and D caches for special ptes
Date: Tue, 13 May 2014 11:25:58 +0200
Message-Id: <c2bcad79c8ece48206703aca4ada8f995342b103.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 71fdb6bf61bf0692f004f9daf5650392c0cfe300 upstream.

Special pte mappings are not intended to be executable and do not even
have an associated struct page. This patch ensures that we do not call
__sync_icache_dcache() on such ptes.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Steve Capper <Steve.Capper@arm.com>
Tested-by: Laura Abbott <lauraa@codeaurora.org>
Tested-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm64/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 82d95a7e9466..62713586d6e3 100644
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
1.9.3

