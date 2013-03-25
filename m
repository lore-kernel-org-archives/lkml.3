Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3CYELM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 00:11:12 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42621 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3CYEKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 00:10:36 -0400
X-AuditID: 9c930197-b7c9dae000006959-6a-514fce399113
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [RFC PATCH 1/6] ARM, TCM: initialize TCM in paging_init(), instead of setup_arch()
Date: Mon, 25 Mar 2013 13:11:09 +0900
Message-Id: <1364184674-13798-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tcm_init() call iotable_init() and it use early_alloc variants which
do memblock allocation. Directly using memblock allocation after
initializing bootmem should not permitted, because bootmem can't know
where are additinally reserved.
So move tcm_init() to a safe place before initalizing bootmem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2..b3990a3 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -56,7 +56,6 @@
 #include <asm/virt.h>
 
 #include "atags.h"
-#include "tcm.h"
 
 
 #if defined(CONFIG_FPE_NWFPE) || defined(CONFIG_FPE_FASTFPE)
@@ -778,8 +777,6 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_crashkernel();
 
-	tcm_init();
-
 #ifdef CONFIG_MULTI_IRQ_HANDLER
 	handle_arch_irq = mdesc->handle_irq;
 #endif
diff --git a/arch/arm/kernel/tcm.c b/arch/arm/kernel/tcm.c
index 30ae6bb..f50f19e 100644
--- a/arch/arm/kernel/tcm.c
+++ b/arch/arm/kernel/tcm.c
@@ -17,7 +17,6 @@
 #include <asm/mach/map.h>
 #include <asm/memory.h>
 #include <asm/system_info.h>
-#include "tcm.h"
 
 static struct gen_pool *tcm_pool;
 static bool dtcm_present;
diff --git a/arch/arm/kernel/tcm.h b/arch/arm/kernel/tcm.h
deleted file mode 100644
index 8015ad4..0000000
--- a/arch/arm/kernel/tcm.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- * Copyright (C) 2008-2009 ST-Ericsson AB
- * License terms: GNU General Public License (GPL) version 2
- * TCM memory handling for ARM systems
- *
- * Author: Linus Walleij <linus.walleij@stericsson.com>
- * Author: Rickard Andersson <rickard.andersson@stericsson.com>
- */
-
-#ifdef CONFIG_HAVE_TCM
-void __init tcm_init(void);
-#else
-/* No TCM support, just blank inlines to be optimized out */
-inline void tcm_init(void)
-{
-}
-#endif
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e95a996..a7f127d 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -34,6 +34,7 @@
 #include <asm/mach/pci.h>
 
 #include "mm.h"
+#include "tcm.h"
 
 /*
  * empty_zero_page is a special page that is used for
@@ -1256,6 +1257,7 @@ void __init paging_init(struct machine_desc *mdesc)
 	dma_contiguous_remap();
 	devicemaps_init(mdesc);
 	kmap_init();
+	tcm_init();
 
 	top_pmd = pmd_off_k(0xffff0000);
 
diff --git a/arch/arm/mm/tcm.h b/arch/arm/mm/tcm.h
new file mode 100644
index 0000000..8015ad4
--- /dev/null
+++ b/arch/arm/mm/tcm.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2008-2009 ST-Ericsson AB
+ * License terms: GNU General Public License (GPL) version 2
+ * TCM memory handling for ARM systems
+ *
+ * Author: Linus Walleij <linus.walleij@stericsson.com>
+ * Author: Rickard Andersson <rickard.andersson@stericsson.com>
+ */
+
+#ifdef CONFIG_HAVE_TCM
+void __init tcm_init(void);
+#else
+/* No TCM support, just blank inlines to be optimized out */
+inline void tcm_init(void)
+{
+}
+#endif
-- 
1.7.9.5

