Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbaHFTeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:34:31 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51332 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474AbaHFTea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:34:30 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Rabin Vincent <rabin@rab.in>,
        Liu hua <sdu.liu@huawei.com>, Mark Salter <msalter@redhat.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh@kernel.org>,
        Doug Anderson <dianders@google.com>, Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/7] arm: fixmap: implement __set_fixmap()
Date: Wed,  6 Aug 2014 12:32:39 -0700
Message-Id: <1407353564-21478-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407353564-21478-1-git-send-email-keescook@chromium.org>
References: <1407353564-21478-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used from set_fixmap() and clear_fixmap() via
asm-generic/fixmap.h.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Rabin Vincent <rabin@rab.in>
---
 arch/arm/include/asm/fixmap.h |  2 ++
 arch/arm/mm/mmu.c             | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index 190142d174ee..8ee7cb4f62ca 100644
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
index 6e3ba8d112a2..b005a3337bc1 100644
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
@@ -392,6 +393,21 @@ SET_MEMORY_FN(rw, pte_set_rw)
 SET_MEMORY_FN(x, pte_set_x)
 SET_MEMORY_FN(nx, pte_set_nx)
 
+void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
+{
+	unsigned long vaddr = __fix_to_virt(idx);
+	pte_t *pte = pte_offset_kernel(pmd_off_k(FIXADDR_START), vaddr);
+
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

