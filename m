Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbaGOROg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:14:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45217 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbaGORCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:13 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 44/94] ARM: OMAP2+: create dsp device only on OMAP3 SoCs
Date: Tue, 15 Jul 2014 20:00:59 +0300
Message-Id: <1405443709-15288-44-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

The DSP platform device for TI DSP/Bridge is currently
created unconditionally whenever CONFIG_TIDSPBRIDGE is
enabled. This device should only be created on OMAP34xx/
OMAP36xx SoCs, and not for other OMAP3 derived SoCs or when
booting multi-arch images on other SoCs. So, add a check for
the SoC family both before creating the device and allocating
the carveout memory for the device.

Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/mach-omap2/dsp.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/mach-omap2/dsp.c b/arch/arm/mach-omap2/dsp.c
index b8208b4..f7492df 100644
--- a/arch/arm/mach-omap2/dsp.c
+++ b/arch/arm/mach-omap2/dsp.c
@@ -29,6 +29,7 @@
 #ifdef CONFIG_TIDSPBRIDGE_DVFS
 #include "omap-pm.h"
 #endif
+#include "soc.h"
 
 #include <linux/platform_data/dsp-omap.h>
 
@@ -59,6 +60,9 @@ void __init omap_dsp_reserve_sdram_memblock(void)
 	phys_addr_t size = CONFIG_TIDSPBRIDGE_MEMPOOL_SIZE;
 	phys_addr_t paddr;
 
+	if (!cpu_is_omap34xx())
+		return;
+
 	if (!size)
 		return;
 
@@ -83,6 +87,9 @@ static int __init omap_dsp_init(void)
 	int err = -ENOMEM;
 	struct omap_dsp_platform_data *pdata = &omap_dsp_pdata;
 
+	if (!cpu_is_omap34xx())
+		return 0;
+
 	pdata->phys_mempool_base = omap_dsp_get_mempool_base();
 
 	if (pdata->phys_mempool_base) {
@@ -115,6 +122,9 @@ module_init(omap_dsp_init);
 
 static void __exit omap_dsp_exit(void)
 {
+	if (!cpu_is_omap34xx())
+		return;
+
 	platform_device_unregister(omap_dsp_pdev);
 }
 module_exit(omap_dsp_exit);
-- 
1.7.10.4

