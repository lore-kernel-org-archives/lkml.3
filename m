Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaEWM5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:57:19 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:39107 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaEWMvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:51:11 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v2 2/2] of: Stop naming platform_device using dcr address
Date: Fri, 23 May 2014 08:36:09 +0900
Message-Id: <1400801769-4506-3-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400801769-4506-1-git-send-email-grant.likely@linaro.org>
References: <1400801769-4506-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is now a way to ensure all platform devices get a unique name when
populated from the device tree, and the DCR_NATIVE code path is broken
anyway. PowerPC Cell (PS3) is the only platform that actually uses this
path.  Most likely nobody will notice if it is killed. Remove the code
and associated ugly #ifdef.

The user-visible impact of this patch is that any DCR device on Cell
will get a new name in the /sys/devices hierarchy.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/dcr-mmio.h |  4 ----
 arch/powerpc/sysdev/dcr.c           |  6 +++---
 drivers/of/platform.c               | 24 ------------------------
 3 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/arch/powerpc/include/asm/dcr-mmio.h b/arch/powerpc/include/asm/dcr-mmio.h
index acd491dbd45a..93a68b28e695 100644
--- a/arch/powerpc/include/asm/dcr-mmio.h
+++ b/arch/powerpc/include/asm/dcr-mmio.h
@@ -51,10 +51,6 @@ static inline void dcr_write_mmio(dcr_host_mmio_t host,
 	out_be32(host.token + ((host.base + dcr_n) * host.stride), value);
 }
 
-extern u64 of_translate_dcr_address(struct device_node *dev,
-				    unsigned int dcr_n,
-				    unsigned int *stride);
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_DCR_MMIO_H */
 
diff --git a/arch/powerpc/sysdev/dcr.c b/arch/powerpc/sysdev/dcr.c
index 1bd0eba4d355..e9056e438575 100644
--- a/arch/powerpc/sysdev/dcr.c
+++ b/arch/powerpc/sysdev/dcr.c
@@ -152,9 +152,9 @@ EXPORT_SYMBOL_GPL(dcr_resource_len);
 
 #ifdef CONFIG_PPC_DCR_MMIO
 
-u64 of_translate_dcr_address(struct device_node *dev,
-			     unsigned int dcr_n,
-			     unsigned int *out_stride)
+static u64 of_translate_dcr_address(struct device_node *dev,
+				    unsigned int dcr_n,
+				    unsigned int *out_stride)
 {
 	struct device_node *dp;
 	const u32 *p;
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 95c133a0554b..52780a72d09d 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -51,10 +51,6 @@ struct platform_device *of_find_device_by_node(struct device_node *np)
 }
 EXPORT_SYMBOL(of_find_device_by_node);
 
-#if defined(CONFIG_PPC_DCR)
-#include <asm/dcr.h>
-#endif
-
 #ifdef CONFIG_OF_ADDRESS
 /*
  * The following routines scan a subtree and registers a device for
@@ -78,26 +74,6 @@ void of_device_make_bus_id(struct device *dev)
 	const __be32 *reg;
 	u64 addr;
 
-#ifdef CONFIG_PPC_DCR
-	/*
-	 * If it's a DCR based device, use 'd' for native DCRs
-	 * and 'D' for MMIO DCRs.
-	 */
-	reg = of_get_property(node, "dcr-reg", NULL);
-	if (reg) {
-#ifdef CONFIG_PPC_DCR_NATIVE
-		dev_set_name(dev, "d%x.%s", *reg, node->name);
-#else /* CONFIG_PPC_DCR_NATIVE */
-		u64 addr = of_translate_dcr_address(node, *reg, NULL);
-		if (addr != OF_BAD_ADDR) {
-			dev_set_name(dev, "D%llx.%s",
-				     (unsigned long long)addr, node->name);
-			return;
-		}
-#endif /* !CONFIG_PPC_DCR_NATIVE */
-	}
-#endif /* CONFIG_PPC_DCR */
-
 	/* Construct the name, using parent nodes if necessary to ensure uniqueness */
 	while (node->parent) {
 		/*
-- 
1.9.1

