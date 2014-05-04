Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbaEDRBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:01:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaEDPlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <Steve.Capper@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Bharat Bhushan <Bharat.Bhushan@freescale.com>
Subject: [PATCH 3.14 001/158] arm64: Do not synchronise I and D caches for special ptes
Date: Sun,  4 May 2014 11:38:30 -0400
Message-Id: <20140504154030.195840317@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -199,7 +199,7 @@ static inline void set_pte_at(struct mm_
 			      pte_t *ptep, pte_t pte)
 {
 	if (pte_valid_user(pte)) {
-		if (pte_exec(pte))
+		if (!pte_special(pte) && pte_exec(pte))
 			__sync_icache_dcache(pte, addr);
 		if (pte_dirty(pte) && pte_write(pte))
 			pte_val(pte) &= ~PTE_RDONLY;


