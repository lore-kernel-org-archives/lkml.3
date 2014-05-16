Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbaEPVn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:43:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:20987 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbaEPVnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:43:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1069,1389772800"; 
   d="scan'208";a="512987834"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/8] x86: Out of line get_dma_ops
Date: Fri, 16 May 2014 14:43:12 -0700
Message-Id: <1400276595-6965-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Out of lining the complex version of get_dma_ops saves about 6.8k on
my kernel.

14101415	2004040	1507328	17612783	10cbfef	vmlinux-before-dma
14094629	2004040	1507328	17605997	10ca56d	vmlinux-dma

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/dma-mapping.h |  7 +++----
 arch/x86/lib/Makefile              |  2 ++
 arch/x86/lib/dma.c                 | 11 +++++++++++
 3 files changed, 16 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/lib/dma.c

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 808dae6..314e4bd 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -29,15 +29,14 @@ extern int panic_on_overflow;
 
 extern struct dma_map_ops *dma_ops;
 
+struct dma_map_ops *__get_dma_ops(struct device *dev);
+
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 #ifndef CONFIG_X86_DEV_DMA_OPS
 	return dma_ops;
 #else
-	if (unlikely(!dev) || !dev->archdata.dma_ops)
-		return dma_ops;
-	else
-		return dev->archdata.dma_ops;
+	return __get_dma_ops(dev);
 #endif
 }
 
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index eabcb6e..44dae40 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -44,3 +44,5 @@ else
         lib-y += copy_user_64.o copy_user_nocache_64.o
 	lib-y += cmpxchg16b_emu.o
 endif
+
+lib-y += dma.o
diff --git a/arch/x86/lib/dma.c b/arch/x86/lib/dma.c
new file mode 100644
index 0000000..c97b5ae
--- /dev/null
+++ b/arch/x86/lib/dma.c
@@ -0,0 +1,11 @@
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+
+struct dma_map_ops *__get_dma_ops(struct device *dev)
+{
+	if (unlikely(!dev) || !dev->archdata.dma_ops)
+		return dma_ops;
+	else
+		return dev->archdata.dma_ops;
+}
+EXPORT_SYMBOL(__get_dma_ops);
-- 
1.9.0

