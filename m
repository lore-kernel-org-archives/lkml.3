Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870Ab3LHOPO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 09:15:14 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:35769 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759626Ab3LHOOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 09:14:21 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 9/9] ARM: add initial support for Marvell Berlin SoCs
Date: Sun,  8 Dec 2013 15:14:06 +0100
Message-Id: <1386512047-874-10-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds initial support for the Marvell Berlin SoC family with
Armada 1500 (88DE3100) and Armada 1500-mini (88DE3005) SoCs.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reviewed-by: Jason Cooper <jason@lakedaemon.net>
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
Changelog:
v3->v4:
- move ARM_GIC to ARCH_BERLIN (Suggested by Jisheng Zhang)
- re-add 'if SMP' dependency for HAVE_ARM_TWD as it still depends on
  SMP
- Note: I did not move l2x0_of_init to init_early, as it is too early
  for current l2x0_of_init.
v2->v3:
- add Armada 1500-mini (BG2CD) Kconfig
v1->v2:
- replace 88DE3xxx numbering with SoC variant name
  (Requested by Jisheng Zhang)
- remove LOCAL_TIMERS dependency (Suggested by Dinh Nguyen)
RFCv2->v1:
- remove custom .init_time, adds dependency for arch-wide of_clk_init call
RFCv1->RFCv2:
- nuke .map_io (Reported by Arnd Bergmann)
- add copyright reference
- switch to mach-berlin instead of mach-mvebu

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/Kconfig              |  2 ++
 arch/arm/Makefile             |  1 +
 arch/arm/mach-berlin/Kconfig  | 29 +++++++++++++++++++++++++++++
 arch/arm/mach-berlin/Makefile |  1 +
 arch/arm/mach-berlin/berlin.c | 39 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 72 insertions(+)
 create mode 100644 arch/arm/mach-berlin/Kconfig
 create mode 100644 arch/arm/mach-berlin/Makefile
 create mode 100644 arch/arm/mach-berlin/berlin.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c1f1a7e..121153f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -911,6 +911,8 @@ source "arch/arm/mach-bcm/Kconfig"
 
 source "arch/arm/mach-bcm2835/Kconfig"
 
+source "arch/arm/mach-berlin/Kconfig"
+
 source "arch/arm/mach-clps711x/Kconfig"
 
 source "arch/arm/mach-cns3xxx/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index c99b108..483abc7 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -148,6 +148,7 @@ textofs-$(CONFIG_ARCH_MSM8960) := 0x00208000
 machine-$(CONFIG_ARCH_AT91)		+= at91
 machine-$(CONFIG_ARCH_BCM)		+= bcm
 machine-$(CONFIG_ARCH_BCM2835)		+= bcm2835
+machine-$(CONFIG_ARCH_BERLIN)		+= berlin
 machine-$(CONFIG_ARCH_CLPS711X)		+= clps711x
 machine-$(CONFIG_ARCH_CNS3XXX)		+= cns3xxx
 machine-$(CONFIG_ARCH_DAVINCI)		+= davinci
diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
new file mode 100644
index 0000000..7a02d22
--- /dev/null
+++ b/arch/arm/mach-berlin/Kconfig
@@ -0,0 +1,29 @@
+config ARCH_BERLIN
+	bool "Marvell Berlin SoCs" if ARCH_MULTI_V7
+	select ARM_GIC
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_IRQ_CHIP
+	select COMMON_CLK
+	select DW_APB_ICTL
+	select DW_APB_TIMER_OF
+
+if ARCH_BERLIN
+
+menu "Marvell Berlin SoC variants"
+
+config MACH_BERLIN_BG2
+	bool "Marvell Armada 1500 (BG2)"
+	select CACHE_L2X0
+	select CPU_PJ4B
+	select HAVE_ARM_TWD if SMP
+	select HAVE_SMP
+
+config MACH_BERLIN_BG2CD
+	bool "Marvell Armada 1500-mini (BG2CD)"
+	select CACHE_L2X0
+	select CPU_V7
+	select HAVE_ARM_TWD if SMP
+
+endmenu
+
+endif
diff --git a/arch/arm/mach-berlin/Makefile b/arch/arm/mach-berlin/Makefile
new file mode 100644
index 0000000..ab69fe9
--- /dev/null
+++ b/arch/arm/mach-berlin/Makefile
@@ -0,0 +1 @@
+obj-y += berlin.o
diff --git a/arch/arm/mach-berlin/berlin.c b/arch/arm/mach-berlin/berlin.c
new file mode 100644
index 0000000..025bcb5
--- /dev/null
+++ b/arch/arm/mach-berlin/berlin.c
@@ -0,0 +1,39 @@
+/*
+ * Device Tree support for Marvell Berlin SoCs.
+ *
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * based on GPL'ed 2.6 kernel sources
+ *  (c) Marvell International Ltd.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/of_platform.h>
+#include <asm/hardware/cache-l2x0.h>
+#include <asm/mach/arch.h>
+
+static void __init berlin_init_machine(void)
+{
+	/*
+	 * with DT probing for L2CCs, berlin_init_machine can be removed.
+	 * Note: 88DE3005 (Armada 1500-mini) uses pl310 l2cc
+	 */
+	l2x0_of_init(0x70c00000, 0xfeffffff);
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char * const berlin_dt_compat[] = {
+	"marvell,berlin",
+	NULL,
+};
+
+DT_MACHINE_START(BERLIN_DT, "Marvell Berlin")
+	.dt_compat	= berlin_dt_compat,
+	.init_machine	= berlin_init_machine,
+MACHINE_END
-- 
1.8.4.rc3

