Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667Ab3LHOO1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 09:14:27 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:37689 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759429Ab3LHOOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 09:14:18 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/9] ARM: l2x0: add Marvell Tauros3 support
Date: Sun,  8 Dec 2013 15:14:00 +0100
Message-Id: <1386512047-874-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the Marvell Tauros3 cache controller which
is compatible with pl310 cache controller but broadcasts L1 cache
operations to L2 cache. While updating the binding documentation,
clean up the list of possible compatibles. Also reorder driver
compatibles in alphabetical order.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
Changelog:
v3->v4:
- reorder compatibles alphabetically (see [1])
  [1] http://www.kernelhub.org/?msg=372182&p=2
v2->v3:
- none
v1->v2:
- add tauros3 data without outer cache ops (Suggested by Jisheng Zhang)
- reorder compatibles to allow derivates to be compatible with ARM
  controllers (Suggested by Mark Rutland)

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: devicetree@vger.kernel.org 
Cc: linux-doc@vger.kernel.org 
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/devicetree/bindings/arm/l2cc.txt | 23 ++++++------
 arch/arm/include/asm/hardware/cache-l2x0.h     |  1 +
 arch/arm/mm/cache-l2x0.c                       | 48 +++++++++++++++++++++-----
 arch/arm/mm/cache-tauros3.h                    | 41 ++++++++++++++++++++++
 4 files changed, 94 insertions(+), 19 deletions(-)
 create mode 100644 arch/arm/mm/cache-tauros3.h

diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
index c0c7626..b513cb8 100644
--- a/Documentation/devicetree/bindings/arm/l2cc.txt
+++ b/Documentation/devicetree/bindings/arm/l2cc.txt
@@ -7,20 +7,21 @@ The ARM L2 cache representation in the device tree should be done as follows:
 Required properties:
 
 - compatible : should be one of:
-	"arm,pl310-cache"
-	"arm,l220-cache"
-	"arm,l210-cache"
-	"marvell,aurora-system-cache": Marvell Controller designed to be
+  "arm,pl310-cache"
+  "arm,l220-cache"
+  "arm,l210-cache"
+  "bcm,bcm11351-a2-pl310-cache": DEPRECATED by "brcm,bcm11351-a2-pl310-cache"
+  "brcm,bcm11351-a2-pl310-cache": For Broadcom bcm11351 chipset where an
+     offset needs to be added to the address before passing down to the L2
+     cache controller
+  "marvell,aurora-system-cache": Marvell Controller designed to be
      compatible with the ARM one, with system cache mode (meaning
      maintenance operations on L1 are broadcasted to the L2 and L2
      performs the same operation).
-	"marvell,"aurora-outer-cache: Marvell Controller designed to be
-	 compatible with the ARM one with outer cache mode.
-	"brcm,bcm11351-a2-pl310-cache": For Broadcom bcm11351 chipset where an
-	offset needs to be added to the address before passing down to the L2
-	cache controller
-	"bcm,bcm11351-a2-pl310-cache": DEPRECATED by
-	                               "brcm,bcm11351-a2-pl310-cache"
+  "marvell,aurora-outer-cache": Marvell Controller designed to be
+     compatible with the ARM one with outer cache mode.
+  "marvell,tauros3-cache": Marvell Tauros3 cache controller, compatible
+     with arm,pl310-cache controller.
 - cache-unified : Specifies the cache is a unified cache.
 - cache-level : Should be set to 2 for a level 2 cache.
 - reg : Physical base address and size of cache controller's memory mapped
diff --git a/arch/arm/include/asm/hardware/cache-l2x0.h b/arch/arm/include/asm/hardware/cache-l2x0.h
index 3b2c40b..6795ff7 100644
--- a/arch/arm/include/asm/hardware/cache-l2x0.h
+++ b/arch/arm/include/asm/hardware/cache-l2x0.h
@@ -131,6 +131,7 @@ struct l2x0_regs {
 	unsigned long prefetch_ctrl;
 	unsigned long pwr_ctrl;
 	unsigned long ctrl;
+	unsigned long aux2_ctrl;
 };
 
 extern struct l2x0_regs l2x0_saved_regs;
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 447da6f..7abde2c 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -25,6 +25,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
+#include "cache-tauros3.h"
 #include "cache-aurora-l2.h"
 
 #define CACHE_LINE_SIZE		32
@@ -767,6 +768,14 @@ static void aurora_save(void)
 	l2x0_saved_regs.aux_ctrl = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
 }
 
+static void __init tauros3_save(void)
+{
+	l2x0_saved_regs.aux2_ctrl =
+		readl_relaxed(l2x0_base + TAUROS3_AUX2_CTRL);
+	l2x0_saved_regs.prefetch_ctrl =
+		readl_relaxed(l2x0_base + L2X0_PREFETCH_CTRL);
+}
+
 static void l2x0_resume(void)
 {
 	if (!(readl_relaxed(l2x0_base + L2X0_CTRL) & L2X0_CTRL_EN)) {
@@ -821,6 +830,18 @@ static void aurora_resume(void)
 	}
 }
 
+static void tauros3_resume(void)
+{
+	if (!(readl_relaxed(l2x0_base + L2X0_CTRL) & L2X0_CTRL_EN)) {
+		writel_relaxed(l2x0_saved_regs.aux2_ctrl,
+			       l2x0_base + TAUROS3_AUX2_CTRL);
+		writel_relaxed(l2x0_saved_regs.prefetch_ctrl,
+			       l2x0_base + L2X0_PREFETCH_CTRL);
+	}
+
+	l2x0_resume();
+}
+
 static void __init aurora_broadcast_l2_commands(void)
 {
 	__u32 u;
@@ -906,6 +927,15 @@ static const struct l2x0_of_data aurora_no_outer_data = {
 	},
 };
 
+static const struct l2x0_of_data tauros3_data = {
+	.setup = NULL,
+	.save  = tauros3_save,
+	/* Tauros3 broadcasts L1 cache operations to L2 */
+	.outer_cache = {
+		.resume      = tauros3_resume,
+	},
+};
+
 static const struct l2x0_of_data bcm_l2x0_data = {
 	.setup = pl310_of_setup,
 	.save  = pl310_save,
@@ -922,17 +952,19 @@ static const struct l2x0_of_data bcm_l2x0_data = {
 };
 
 static const struct of_device_id l2x0_ids[] __initconst = {
-	{ .compatible = "arm,pl310-cache", .data = (void *)&pl310_data },
-	{ .compatible = "arm,l220-cache", .data = (void *)&l2x0_data },
 	{ .compatible = "arm,l210-cache", .data = (void *)&l2x0_data },
-	{ .compatible = "marvell,aurora-system-cache",
-	  .data = (void *)&aurora_no_outer_data},
-	{ .compatible = "marvell,aurora-outer-cache",
-	  .data = (void *)&aurora_with_outer_data},
-	{ .compatible = "brcm,bcm11351-a2-pl310-cache",
-	  .data = (void *)&bcm_l2x0_data},
+	{ .compatible = "arm,l220-cache", .data = (void *)&l2x0_data },
+	{ .compatible = "arm,pl310-cache", .data = (void *)&pl310_data },
 	{ .compatible = "bcm,bcm11351-a2-pl310-cache", /* deprecated name */
 	  .data = (void *)&bcm_l2x0_data},
+	{ .compatible = "brcm,bcm11351-a2-pl310-cache",
+	  .data = (void *)&bcm_l2x0_data},
+	{ .compatible = "marvell,aurora-outer-cache",
+	  .data = (void *)&aurora_with_outer_data},
+	{ .compatible = "marvell,aurora-system-cache",
+	  .data = (void *)&aurora_no_outer_data},
+	{ .compatible = "marvell,tauros3-cache",
+	  .data = (void *)&tauros3_data },
 	{}
 };
 
diff --git a/arch/arm/mm/cache-tauros3.h b/arch/arm/mm/cache-tauros3.h
new file mode 100644
index 0000000..02c0a97
--- /dev/null
+++ b/arch/arm/mm/cache-tauros3.h
@@ -0,0 +1,41 @@
+/*
+ * Marvell Tauros3 cache controller includes
+ *
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * based on GPL'ed 2.6 kernel sources
+ *  (c) Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#ifndef __ASM_ARM_HARDWARE_TAUROS3_H
+#define __ASM_ARM_HARDWARE_TAUROS3_H
+
+/*
+ * Marvell Tauros3 L2CC is compatible with PL310 r0p0
+ * but with PREFETCH_CTRL (r2p0) and an additional event counter.
+ * Also, there is AUX2_CTRL for some Marvell specific control.
+ */
+
+#define TAUROS3_EVENT_CNT2_CFG		0x224
+#define TAUROS3_EVENT_CNT2_VAL		0x228
+#define TAUROS3_INV_ALL			0x780
+#define TAUROS3_CLEAN_ALL		0x784
+#define TAUROS3_AUX2_CTRL		0x820
+
+/* Registers shifts and masks */
+#define TAUROS3_AUX2_CTRL_LINEFILL_BURST8_EN	(1 << 2)
+
+#endif
-- 
1.8.4.rc3

