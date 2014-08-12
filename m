Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaHLSZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:25:59 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54530 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbaHLSZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:25:56 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Rabin Vincent <rabin@rab.in>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>, Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 2/7] arm: fixmap: implement __set_fixmap()
Date: Tue, 12 Aug 2014 11:24:24 -0700
Message-Id: <1407867869-5194-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407867869-5194-1-git-send-email-keescook@chromium.org>
References: <1407867869-5194-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used from set_fixmap() and clear_fixmap() via asm-generic/fixmap.h.
Also makes sure that the fixmap allocation fits into the expected range.

Based on patch by Rabin Vincent.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Rabin Vincent <rabin@rab.in>
---
 arch/arm/include/asm/fixmap.h |  2 ++
 arch/arm/mm/mmu.c             | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index a7add6f9315d..48935cc5004f 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -14,6 +14,8 @@ enum fixed_addresses {
 	__end_of_fixed_addresses
 };
 
+void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
+
 #include <asm-generic/fixmap.h>
 
 #endif
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 7fa0966cd15f..48ba2b1d7d8e 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -22,6 +22,7 @@
 #include <asm/cputype.h>
 #include <asm/sections.h>
 #include <asm/cachetype.h>
+#include <asm/fixmap.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/smp_plat.h>
@@ -392,6 +393,24 @@ SET_MEMORY_FN(rw, pte_set_rw)
 SET_MEMORY_FN(x, pte_set_x)
 SET_MEMORY_FN(nx, pte_set_nx)
 
+void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
+{
+	unsigned long vaddr = __fix_to_virt(idx);
+	pte_t *pte = pte_offset_kernel(pmd_off_k(FIXADDR_START), vaddr);
+
+	/* Make sure fixmap region does not exceed available allocation. */
+	BUILD_BUG_ON(FIXADDR_START + (__end_of_fixed_addresses * PAGE_SIZE) >
+		     FIXADDR_END);
+	BUG_ON(idx >= __end_of_fixed_addresses);
+
+	if (pgprot_val(prot))
+		set_pte_at(NULL, vaddr, pte,
+			pfn_pte(phys >> PAGE_SHIFT, prot));
+	else
+		pte_clear(NULL, vaddr, pte);
+	flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
+}
+
 /*
  * Adjust the PMD section entries according to the CPU in use.
  */
-- 
1.9.1

