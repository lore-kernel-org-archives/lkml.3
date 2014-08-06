Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbaHFTgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:36:31 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40277 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108AbaHFTfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:35:44 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Mark Salter <msalter@redhat.com>,
        Liu hua <sdu.liu@huawei.com>, Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh@kernel.org>,
        Doug Anderson <dianders@google.com>, Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/7] arm: use generic fixmap.h
Date: Wed,  6 Aug 2014 12:32:38 -0700
Message-Id: <1407353564-21478-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407353564-21478-1-git-send-email-keescook@chromium.org>
References: <1407353564-21478-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

ARM is different from other architectures in that fixmap pages are indexed
with a positive offset from FIXADDR_START.  Other architectures index with
a negative offset from FIXADDR_TOP.  In order to use the generic fixmap.h
definitions, this patch redefines FIXADDR_TOP to be inclusive of the
useable range.  That is, FIXADDR_TOP is the virtual address of the topmost
fixed page.  The newly defined FIXADDR_END is the first virtual address
past the fixed mappings.

Signed-off-by: Mark Salter <msalter@redhat.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
[update for "ARM: 8031/2: change fixmap mapping region to support 32 CPUs"]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/fixmap.h | 27 +++++++++------------------
 arch/arm/mm/init.c            |  2 +-
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index 74124b0d0d79..190142d174ee 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -2,27 +2,18 @@
 #define _ASM_FIXMAP_H
 
 #define FIXADDR_START		0xffc00000UL
-#define FIXADDR_TOP		0xffe00000UL
-#define FIXADDR_SIZE		(FIXADDR_TOP - FIXADDR_START)
+#define FIXADDR_END		0xffe00000UL
+#define FIXADDR_TOP		(FIXADDR_END - PAGE_SIZE)
+#define FIXADDR_SIZE		(FIXADDR_END - FIXADDR_START)
 
 #define FIX_KMAP_NR_PTES	(FIXADDR_SIZE >> PAGE_SHIFT)
 
-#define __fix_to_virt(x)	(FIXADDR_START + ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	(((x) - FIXADDR_START) >> PAGE_SHIFT)
+enum fixed_addresses {
+	FIX_KMAP_BEGIN,
+	FIX_KMAP_END = FIX_KMAP_NR_PTES - 1,
+	__end_of_fixed_addresses
+};
 
-extern void __this_fixmap_does_not_exist(void);
-
-static inline unsigned long fix_to_virt(const unsigned int idx)
-{
-	if (idx >= FIX_KMAP_NR_PTES)
-		__this_fixmap_does_not_exist();
-	return __fix_to_virt(idx);
-}
-
-static inline unsigned int virt_to_fix(const unsigned long vaddr)
-{
-	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
-	return __virt_to_fix(vaddr);
-}
+#include <asm-generic/fixmap.h>
 
 #endif
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 659c75d808dc..ad82c05bfc3a 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -570,7 +570,7 @@ void __init mem_init(void)
 			MLK(DTCM_OFFSET, (unsigned long) dtcm_end),
 			MLK(ITCM_OFFSET, (unsigned long) itcm_end),
 #endif
-			MLK(FIXADDR_START, FIXADDR_TOP),
+			MLK(FIXADDR_START, FIXADDR_END),
 			MLM(VMALLOC_START, VMALLOC_END),
 			MLM(PAGE_OFFSET, (unsigned long)high_memory),
 #ifdef CONFIG_HIGHMEM
-- 
1.9.1

