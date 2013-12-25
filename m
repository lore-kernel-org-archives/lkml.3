Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3LYXOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 18:14:04 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:51963 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3LYXOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 18:14:02 -0500
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: tomi.valkeinen@ti.com
Cc: tony@atomide.com, linux@arm.linux.org.uk, pali.rohar@gmail.com,
        pavel@ucw.cz, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: [PATCH] ARM: omapfb: Add early framebuffer memory allocator
Date: Thu, 26 Dec 2013 01:12:39 +0200
Message-Id: <1388013159-3036-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
In-Reply-To: <52A062A0.3070005@ti.com>
References: <52A062A0.3070005@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivaylo Dimitrov <freemangordon@abv.bg>

On memory limited devices, CMA fails easily when asked to allocate big
chunks of memory like framebuffer memory needed for video playback.

Add boot parameter "omapfb_memsize" which allocates memory to be used
as dma coherent memory, so dma_alloc_attrs won't hit CMA allocator when
trying to allocate memory for the framebuffers

Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
---
 arch/arm/mach-omap2/common.c |    1 +
 arch/arm/mach-omap2/common.h |    2 +
 arch/arm/mach-omap2/fb.c     |   46 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/common.c b/arch/arm/mach-omap2/common.c
index 2dabb9e..9beecde 100644
--- a/arch/arm/mach-omap2/common.c
+++ b/arch/arm/mach-omap2/common.c
@@ -33,4 +33,5 @@ void __init omap_reserve(void)
 	omap_dsp_reserve_sdram_memblock();
 	omap_secure_ram_reserve_memblock();
 	omap_barrier_reserve_memblock();
+	omap_fb_reserve_memblock();
 }
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index e30ef67..21afdc0 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -304,6 +304,8 @@ extern void omap_reserve(void);
 struct omap_hwmod;
 extern int omap_dss_reset(struct omap_hwmod *);
 
+extern void omap_fb_reserve_memblock(void);
+
 /* SoC specific clock initializer */
 extern int (*omap_clk_init)(void);
 
diff --git a/arch/arm/mach-omap2/fb.c b/arch/arm/mach-omap2/fb.c
index 26e28e9..0eacbe9 100644
--- a/arch/arm/mach-omap2/fb.c
+++ b/arch/arm/mach-omap2/fb.c
@@ -30,6 +30,7 @@
 #include <linux/dma-mapping.h>
 
 #include <asm/mach/map.h>
+#include <asm/memblock.h>
 
 #include "soc.h"
 #include "display.h"
@@ -106,10 +107,53 @@ static struct platform_device omap_fb_device = {
 	.num_resources = 0,
 };
 
+static phys_addr_t omapfb_mem_base __initdata;
+static phys_addr_t omapfb_mem_size __initdata;
+
+void __init omap_fb_reserve_memblock(void)
+{
+	if (omapfb_mem_size) {
+		omapfb_mem_base = arm_memblock_steal(omapfb_mem_size, SZ_1M);
+		if (omapfb_mem_base)
+			pr_info("omapfb: reserved %u bytes at %x\n",
+				omapfb_mem_size, omapfb_mem_base);
+		else
+			pr_err("omapfb: arm_memblock_steal failed\n");
+	}
+}
+
 int __init omap_init_fb(void)
 {
-	return platform_device_register(&omap_fb_device);
+	int ret;
+
+	ret = platform_device_register(&omap_fb_device);
+
+	if (ret)
+		return ret;
+
+	if (!omapfb_mem_base)
+		return 0;
+
+	ret = dma_declare_coherent_memory(&omap_fb_device.dev,
+					  omapfb_mem_base, omapfb_mem_base,
+					  omapfb_mem_size, DMA_MEMORY_MAP |
+					  DMA_MEMORY_EXCLUSIVE);
+	if (!(ret & DMA_MEMORY_MAP))
+		pr_err("omapfb: dma_declare_coherent_memory failed\n");
+
+	return 0;
+}
+
+static int __init early_omapfb_memsize(char *p)
+{
+	omapfb_mem_size = ALIGN(memparse(p, &p), SZ_1M);
+
+	if(!omapfb_mem_size)
+		pr_err("omapfb: bad memsize parameter\n");
+
+	return 0;
 }
+early_param("omapfb_memsize", early_omapfb_memsize);
 #else
 int __init omap_init_fb(void) { return 0; }
 #endif
-- 
1.5.6.1

