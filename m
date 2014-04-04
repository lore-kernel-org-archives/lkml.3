Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaDDV2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 17:28:35 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:56118 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaDDV2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 17:28:24 -0400
From: Rabin Vincent <rabin@rab.in>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Laura Abbott <lauraa@codeaurora.org>, Jon Medhurst <tixy@linaro.org>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 1/2] arm: fixmap: implement __set_fixmap()
Date: Fri,  4 Apr 2014 23:27:49 +0200
Message-Id: <1396646870-29695-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used from set_fixmap() and clear_fixmap() via
asm-generic/fixmap.h.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
Needs "arm: use generic fixmap.h", available in linux-next.

 arch/arm/include/asm/fixmap.h | 2 ++
 arch/arm/mm/mmu.c             | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index 68ea615..55ed076 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -23,6 +23,8 @@ enum fixed_addresses {
 	__end_of_fixed_addresses
 };
 
+void __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t prot);
+
 #include <asm-generic/fixmap.h>
 
 #endif
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 3e16307..61bdfb1 100644
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
@@ -388,6 +389,12 @@ SET_MEMORY_FN(rw, pte_set_rw)
 SET_MEMORY_FN(x, pte_set_x)
 SET_MEMORY_FN(nx, pte_set_nx)
 
+void __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
+{
+	BUG_ON(idx >= __end_of_fixed_addresses);
+	set_top_pte(__fix_to_virt(idx), pfn_pte(__phys_to_pfn(phys), prot));
+}
+
 /*
  * Adjust the PMD section entries according to the CPU in use.
  */
-- 
1.9.1

