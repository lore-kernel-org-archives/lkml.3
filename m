Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937398Ab3DKAGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:06:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57948 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937108Ab3DKAGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 04/30] ARM: samsung: move mfc device definition to s5p-dev-mfc.c
Date: Thu, 11 Apr 2013 02:04:46 +0200
Message-Id: <1365638712-1028578-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:sI5MiYmgdHUEaL4qu9OerW6LN8PprQwbxjDi/k8iRzB
 WcUvNYcW4KJ7BZcudPkJKxvtFoVUxv7qKGhFb5XyVGiGkOpdSv
 oKKc2S6b9qTpo/8SHqK9fmcyA/8dZvC812rzC9paghBqtcNkdU
 hngInzM5t4Uo9cLmea+uBNkQnyl/SfST8/nEHL1U1hVICWve33
 rD3XkfYltxFJ+0QNul/zWZo1P98U6mCuSTQadCWEAb3AJoVeq6
 oPGdoC9q+IRvc7AdKCmdcwDJ5nKmtAFP6bZMmr7X9KC6mzBOty
 CGeVbpAdJfkq/79H00G2/2aMMGnCi0D/ARhI7weji2I0UzSprW
 gKZYaAyHFiXAFm+7LA7E45rQTngaiC6THhEwKe9wwC2dmyCmXG
 pzNoTkE2LlBKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a DT-only build we don't want to compile devs.c, but we do need
the mfc device, which is also referenced by the DT based platforms,
so move it all into one place.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/plat-samsung/devs.c        | 45 -------------------------------------
 arch/arm/plat-samsung/s5p-dev-mfc.c | 42 +++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 46 deletions(-)

diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index e1124d9..4cf660e 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -878,51 +878,6 @@ void __init s3c24xx_fb_set_platdata(struct s3c2410fb_mach_info *pd)
 }
 #endif /* CONFIG_PLAT_S3C24XX */
 
-/* MFC */
-
-#ifdef CONFIG_S5P_DEV_MFC
-static struct resource s5p_mfc_resource[] = {
-	[0] = DEFINE_RES_MEM(S5P_PA_MFC, SZ_64K),
-	[1] = DEFINE_RES_IRQ(IRQ_MFC),
-};
-
-struct platform_device s5p_device_mfc = {
-	.name		= "s5p-mfc",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(s5p_mfc_resource),
-	.resource	= s5p_mfc_resource,
-};
-
-/*
- * MFC hardware has 2 memory interfaces which are modelled as two separate
- * platform devices to let dma-mapping distinguish between them.
- *
- * MFC parent device (s5p_device_mfc) must be registered before memory
- * interface specific devices (s5p_device_mfc_l and s5p_device_mfc_r).
- */
-
-struct platform_device s5p_device_mfc_l = {
-	.name		= "s5p-mfc-l",
-	.id		= -1,
-	.dev		= {
-		.parent			= &s5p_device_mfc.dev,
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
-struct platform_device s5p_device_mfc_r = {
-	.name		= "s5p-mfc-r",
-	.id		= -1,
-	.dev		= {
-		.parent			= &s5p_device_mfc.dev,
-		.dma_mask		= &samsung_device_dma_mask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
-#endif /* CONFIG_S5P_DEV_MFC */
-
 /* MIPI CSIS */
 
 #ifdef CONFIG_S5P_DEV_CSIS0
diff --git a/arch/arm/plat-samsung/s5p-dev-mfc.c b/arch/arm/plat-samsung/s5p-dev-mfc.c
index 5ec104b..a93fb6f 100644
--- a/arch/arm/plat-samsung/s5p-dev-mfc.c
+++ b/arch/arm/plat-samsung/s5p-dev-mfc.c
@@ -18,10 +18,50 @@
 #include <linux/of.h>
 
 #include <mach/map.h>
+#include <mach/irqs.h>
 #include <plat/devs.h>
-#include <plat/irqs.h>
 #include <plat/mfc.h>
 
+static struct resource s5p_mfc_resource[] = {
+	[0] = DEFINE_RES_MEM(S5P_PA_MFC, SZ_64K),
+	[1] = DEFINE_RES_IRQ(IRQ_MFC),
+};
+
+struct platform_device s5p_device_mfc = {
+	.name		= "s5p-mfc",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(s5p_mfc_resource),
+	.resource	= s5p_mfc_resource,
+};
+
+/*
+ * MFC hardware has 2 memory interfaces which are modelled as two separate
+ * platform devices to let dma-mapping distinguish between them.
+ *
+ * MFC parent device (s5p_device_mfc) must be registered before memory
+ * interface specific devices (s5p_device_mfc_l and s5p_device_mfc_r).
+ */
+
+struct platform_device s5p_device_mfc_l = {
+	.name		= "s5p-mfc-l",
+	.id		= -1,
+	.dev		= {
+		.parent			= &s5p_device_mfc.dev,
+		.dma_mask		= &s5p_device_mfc_l.dev.coherent_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+struct platform_device s5p_device_mfc_r = {
+	.name		= "s5p-mfc-r",
+	.id		= -1,
+	.dev		= {
+		.parent			= &s5p_device_mfc.dev,
+		.dma_mask		= &s5p_device_mfc_r.dev.coherent_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
 struct s5p_mfc_reserved_mem {
 	phys_addr_t	base;
 	unsigned long	size;
-- 
1.8.1.2

