Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab3JGQaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:30:35 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:33763 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab3JGQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:30:29 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 21/29] arm64: set initrd_start/initrd_end for fdt scan
Date: Mon,  7 Oct 2013 11:29:29 -0500
Message-Id: <1381163377-21044-22-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

In order to unify the initrd scanning for DT across architectures, make
arm64 use initrd_start and initrd_end instead of the physical addresses.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/mm/init.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index de2de5d..8261f4e 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -39,17 +39,9 @@
 
 #include "mm.h"
 
-static unsigned long phys_initrd_start __initdata = 0;
-static unsigned long phys_initrd_size __initdata = 0;
-
 phys_addr_t memstart_addr __read_mostly = 0;
 
-void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
-{
-	phys_initrd_start = start;
-	phys_initrd_size = end - start;
-}
-
+#ifdef CONFIG_BLK_DEV_INITRD
 static int __init early_initrd(char *p)
 {
 	unsigned long start, size;
@@ -59,12 +51,13 @@ static int __init early_initrd(char *p)
 	if (*endp == ',') {
 		size = memparse(endp + 1, NULL);
 
-		phys_initrd_start = start;
-		phys_initrd_size = size;
+		initrd_start = (unsigned long)__va(start);
+		initrd_end = (unsigned long)__va(start + size);
 	}
 	return 0;
 }
 early_param("initrd", early_initrd);
+#endif
 
 #define MAX_DMA32_PFN ((4UL * 1024 * 1024 * 1024) >> PAGE_SHIFT)
 
@@ -137,13 +130,8 @@ void __init arm64_memblock_init(void)
 	/* Register the kernel text, kernel data and initrd with memblock */
 	memblock_reserve(__pa(_text), _end - _text);
 #ifdef CONFIG_BLK_DEV_INITRD
-	if (phys_initrd_size) {
-		memblock_reserve(phys_initrd_start, phys_initrd_size);
-
-		/* Now convert initrd to virtual addresses */
-		initrd_start = __phys_to_virt(phys_initrd_start);
-		initrd_end = initrd_start + phys_initrd_size;
-	}
+	if (initrd_start)
+		memblock_reserve(__virt_to_phys(initrd_start), initrd_end - initrd_start);
 #endif
 
 	/*
-- 
1.8.1.2

