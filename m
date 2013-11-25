Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab3KYQPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:15:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861Ab3KYQOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:14:45 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 03/11] arm: use generic fixmap.h
Date: Mon, 25 Nov 2013 11:13:57 -0500
Message-Id: <1385396045-15852-4-git-send-email-msalter@redhat.com>
In-Reply-To: <1385396045-15852-1-git-send-email-msalter@redhat.com>
References: <1385396045-15852-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is different from other architectures in that fixmap pages are
indexed with a positive offset from FIXADDR_START. Other architectures
index with a negative offset from FIXADDR_TOP. In order to use the
generic fixmap.h definitions, this patch redefines FIXADDR_TOP to be
inclusive of the useable range. That is, FIXADDR_TOP is the virtual
address of the topmost fixed page. The newly defined FIXADDR_END is
the first virtual address past the fixed mappings.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org
---
 arch/arm/include/asm/fixmap.h | 29 ++++++++---------------------
 arch/arm/mm/init.c            |  2 +-
 2 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index bbae919..68ea615 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -14,28 +14,15 @@
  */
 
 #define FIXADDR_START		0xfff00000UL
-#define FIXADDR_TOP		0xfffe0000UL
-#define FIXADDR_SIZE		(FIXADDR_TOP - FIXADDR_START)
+#define FIXADDR_END		0xfffe0000UL
+#define FIXADDR_TOP		(FIXADDR_END - PAGE_SIZE)
 
-#define FIX_KMAP_BEGIN		0
-#define FIX_KMAP_END		(FIXADDR_SIZE >> PAGE_SHIFT)
+enum fixed_addresses {
+	FIX_KMAP_BEGIN,
+	FIX_KMAP_END = (FIXADDR_TOP - FIXADDR_START) >> PAGE_SHIFT,
+	__end_of_fixed_addresses
+};
 
-#define __fix_to_virt(x)	(FIXADDR_START + ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	(((x) - FIXADDR_START) >> PAGE_SHIFT)
-
-extern void __this_fixmap_does_not_exist(void);
-
-static inline unsigned long fix_to_virt(const unsigned int idx)
-{
-	if (idx >= FIX_KMAP_END)
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
index ca907f8..fb61c29 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -632,7 +632,7 @@ void __init mem_init(void)
 			MLK(DTCM_OFFSET, (unsigned long) dtcm_end),
 			MLK(ITCM_OFFSET, (unsigned long) itcm_end),
 #endif
-			MLK(FIXADDR_START, FIXADDR_TOP),
+			MLK(FIXADDR_START, FIXADDR_END),
 			MLM(VMALLOC_START, VMALLOC_END),
 			MLM(PAGE_OFFSET, (unsigned long)high_memory),
 #ifdef CONFIG_HIGHMEM
-- 
1.8.3.1

