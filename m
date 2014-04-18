Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaDRCbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 22:31:08 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:65459 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaDRCaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 22:30:21 -0400
From: Alex Elder <elder@linaro.org>
To: bcm@fixthebug.org, mporter@linaro.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] ARM: bcm: clean up SMC code
Date: Thu, 17 Apr 2014 21:30:08 -0500
Message-Id: <1397788215-20279-4-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397788215-20279-1-git-send-email-elder@linaro.org>
References: <1397788215-20279-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just does some simple cleanup in "bcm_kona_smc.c":
    - Get rid of the secure_bridge_data structure.  Instead, just
      define two globals that record the physical and virtual
      addresses of the SMC arguments buffer.  Use "buffer" instead
      of "bounce" in their names.  Drop of the erroneous __iomem
      annotation for the physical address.
    - Get rid of the initialized flag and just use a non-null buffer
      address to indicate that.
    - Get the size of the memory region when fetching the SMC
      arguments buffer location from the device tree.  Use it to
      call ioremap() directly rather than requiring of_iomap() to
      go look it up again.
    - Do some additional validation on that memory region size.
    - Flush caches unconditionally in __bcm_kona_smc(); nothing
      supplies SSAPI_BRCM_START_VC_CORE as a service id.
    - Drop a needless initialization of "rc" in __bcm_kona_smc().

It also deletes most of the content of "bcm_kona_smc.h" because it's
never actually used and is of questionable value anyway.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <mporter@linaro.org>
---
 arch/arm/mach-bcm/bcm_kona_smc.c |   45 ++++++++++++++++++-------------------
 arch/arm/mach-bcm/bcm_kona_smc.h |   46 ++------------------------------------
 2 files changed, 24 insertions(+), 67 deletions(-)

diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
index ddc2f17..0d2bfe2 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.c
+++ b/arch/arm/mach-bcm/bcm_kona_smc.c
@@ -21,11 +21,8 @@
 
 #include "bcm_kona_smc.h"
 
-struct secure_bridge_data {
-	void __iomem *bounce;		/* virtual address */
-	u32 __iomem buffer_addr;	/* physical address */
-	int initialized;
-} bridge_data;
+static u32		bcm_smc_buffer_phys;	/* physical address */
+static void __iomem	*bcm_smc_buffer;	/* virtual address */
 
 struct bcm_kona_smc_data {
 	unsigned service_id;
@@ -41,31 +38,37 @@ static const struct of_device_id bcm_kona_smc_ids[] __initconst = {
 	{},
 };
 
-/* Map in the bounce area */
+/* Map in the args buffer area */
 int __init bcm_kona_smc_init(void)
 {
 	struct device_node *node;
 	const __be32 *prop_val;
+	u64 prop_size = 0;
+	unsigned long buffer_size;
+	u32 buffer_phys;
 
 	/* Read buffer addr and size from the device tree node */
 	node = of_find_matching_node(NULL, bcm_kona_smc_ids);
 	if (!node)
 		return -ENODEV;
 
-	/* Don't care about size or flags of the DT node */
-	prop_val = of_get_address(node, 0, NULL, NULL);
+	prop_val = of_get_address(node, 0, &prop_size, NULL);
 	if (!prop_val)
 		return -EINVAL;
 
-	bridge_data.buffer_addr = be32_to_cpu(*prop_val);
-	if (!bridge_data.buffer_addr)
+	/* We assume space for four 32-bit arguments */
+	if (prop_size < 4 * sizeof(u32) || prop_size > (u64)ULONG_MAX)
 		return -EINVAL;
+	buffer_size = (unsigned long)prop_size;
 
-	bridge_data.bounce = of_iomap(node, 0);
-	if (!bridge_data.bounce)
+	buffer_phys = be32_to_cpup(prop_val);
+	if (!buffer_phys)
+		return -EINVAL;
+
+	bcm_smc_buffer = ioremap(buffer_phys, buffer_size);
+	if (!bcm_smc_buffer)
 		return -ENOMEM;
-
-	bridge_data.initialized = 1;
+	bcm_smc_buffer_phys = buffer_phys;
 
 	pr_info("Kona Secure API initialized\n");
 
@@ -76,14 +79,11 @@ int __init bcm_kona_smc_init(void)
 static void __bcm_kona_smc(void *info)
 {
 	struct bcm_kona_smc_data *data = info;
-	u32 *args = bridge_data.bounce;
-	int rc = 0;
+	u32 *args = bcm_smc_buffer;
+	int rc;
 
-	/* Must run on CPU 0 */
 	BUG_ON(smp_processor_id() != 0);
-
-	/* Check map in the bounce area */
-	BUG_ON(!bridge_data.initialized);
+	BUG_ON(!args);
 
 	/* Copy the four 32 bit argument values into the bounce area */
 	writel_relaxed(data->arg0, args++);
@@ -92,11 +92,10 @@ static void __bcm_kona_smc(void *info)
 	writel(data->arg3, args);
 
 	/* Flush caches for input data passed to Secure Monitor */
-	if (data->service_id != SSAPI_BRCM_START_VC_CORE)
-		flush_cache_all();
+	flush_cache_all();
 
 	/* Trap into Secure Monitor */
-	rc = bcm_kona_smc_asm(data->service_id, bridge_data.buffer_addr);
+	rc = bcm_kona_smc_asm(data->service_id, bcm_smc_buffer_phys);
 
 	if (rc != SEC_ROM_RET_OK)
 		pr_err("Secure Monitor call failed (0x%x)!\n", rc);
diff --git a/arch/arm/mach-bcm/bcm_kona_smc.h b/arch/arm/mach-bcm/bcm_kona_smc.h
index d098a7e..629e64a 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.h
+++ b/arch/arm/mach-bcm/bcm_kona_smc.h
@@ -15,54 +15,12 @@
 #define BCM_KONA_SMC_H
 
 #include <linux/types.h>
-#define FLAGS	(SEC_ROM_ICACHE_ENABLE_MASK | SEC_ROM_DCACHE_ENABLE_MASK | \
-			SEC_ROM_IRQ_ENABLE_MASK | SEC_ROM_FIQ_ENABLE_MASK)
 
-/*!
- * Definitions for IRQ & FIQ Mask for ARM
- */
-
-#define FIQ_IRQ_MASK						0xC0
-#define FIQ_MASK						0x40
-#define IRQ_MASK						0x80
-
-/*!
- * Secure Mode FLAGs
- */
-
-/* When set, enables ICache within the secure mode */
-#define SEC_ROM_ICACHE_ENABLE_MASK                        0x00000001
-
-/* When set, enables DCache within the secure mode */
-#define SEC_ROM_DCACHE_ENABLE_MASK                        0x00000002
-
-/* When set, enables IRQ within the secure mode */
-#define SEC_ROM_IRQ_ENABLE_MASK                           0x00000004
-
-/* When set, enables FIQ within the secure mode */
-#define SEC_ROM_FIQ_ENABLE_MASK                           0x00000008
-
-/* When set, enables Unified L2 cache within the secure mode */
-#define SEC_ROM_UL2_CACHE_ENABLE_MASK                     0x00000010
-
-/* Broadcom Secure Service API Service IDs */
-#define SSAPI_DORMANT_ENTRY_SERV                          0x01000000
-#define SSAPI_PUBLIC_OTP_SERV                             0x01000001
-#define SSAPI_ENABLE_L2_CACHE                             0x01000002
-#define SSAPI_DISABLE_L2_CACHE                            0x01000003
-#define SSAPI_WRITE_SCU_STATUS                            0x01000004
-#define SSAPI_WRITE_PWR_GATE                              0x01000005
-
-/* Broadcom Secure Service API Return Codes */
+/* Broadcom Secure Service API service IDs, return codes, and exit codes */
+#define SSAPI_ENABLE_L2_CACHE		0x01000002
 #define SEC_ROM_RET_OK			0x00000001
-#define SEC_ROM_RET_FAIL		0x00000009
-
-#define SSAPI_RET_FROM_INT_SERV		0x4
 #define SEC_EXIT_NORMAL			0x1
 
-#define SSAPI_ROW_AES			0x0E000006
-#define SSAPI_BRCM_START_VC_CORE	0x0E000008
-
 #ifndef	__ASSEMBLY__
 extern int __init bcm_kona_smc_init(void);
 
-- 
1.7.9.5

