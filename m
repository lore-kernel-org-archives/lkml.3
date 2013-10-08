Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3JHMZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:25:25 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:33201 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3JHMYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:24:48 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] ARM: add initial support for Marvell Berlin SoCs
Date: Tue,  8 Oct 2013 14:24:33 +0200
Message-Id: <1381235073-17134-9-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds initial support for the Marvell Berlin (88DE3xxx) SoC family
and basic machine setup for Armada 1500 (88DE3100) SoCs.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reviewed-by: Jason Cooper <jason@lakedaemon.net>
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
Changelog:
RFCv2->v1:
- remove custom .init_time, adds dependency for arch-wide of_clk_init call
RFCv1->RFCv2:
- nuke .map_io (Reported by Arnd Bergmann)
- add copyright reference
- switch to mach-berlin instead of mach-mvebu

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/Kconfig              |    2 ++
 arch/arm/Makefile             |    1 +
 arch/arm/mach-berlin/Kconfig  |   24 ++++++++++++++++++++++++
 arch/arm/mach-berlin/Makefile |    1 +
 arch/arm/mach-berlin/berlin.c |   39 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 67 insertions(+)
 create mode 100644 arch/arm/mach-berlin/Kconfig
 create mode 100644 arch/arm/mach-berlin/Makefile
 create mode 100644 arch/arm/mach-berlin/berlin.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ad6fb6..5692426 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -932,6 +932,8 @@ source "arch/arm/mach-bcm/Kconfig"
 
 source "arch/arm/mach-bcm2835/Kconfig"
 
+source "arch/arm/mach-berlin/Kconfig"
+
 source "arch/arm/mach-clps711x/Kconfig"
 
 source "arch/arm/mach-cns3xxx/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index a37a50f..3ba332b 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -147,6 +147,7 @@ textofs-$(CONFIG_ARCH_MSM8960) := 0x00208000
 machine-$(CONFIG_ARCH_AT91)		+= at91
 machine-$(CONFIG_ARCH_BCM)		+= bcm
 machine-$(CONFIG_ARCH_BCM2835)		+= bcm2835
+machine-$(CONFIG_ARCH_BERLIN)		+= berlin
 machine-$(CONFIG_ARCH_CLPS711X)		+= clps711x
 machine-$(CONFIG_ARCH_CNS3XXX)		+= cns3xxx
 machine-$(CONFIG_ARCH_DAVINCI)		+= davinci
diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
new file mode 100644
index 0000000..56a671e
--- /dev/null
+++ b/arch/arm/mach-berlin/Kconfig
@@ -0,0 +1,24 @@
+config ARCH_BERLIN
+	bool "Marvell Berlin (88DE3xxx) SoCs" if ARCH_MULTI_V7
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_IRQ_CHIP
+	select COMMON_CLK
+	select DW_APB_ICTL
+	select DW_APB_TIMER_OF
+
+if ARCH_BERLIN
+
+menu "Marvell Berlin (88DE3xxx) SoC variants"
+
+config MACH_MV88DE3100
+	bool "Marvell 88DE3100 (Armada 1500)"
+	select ARM_GIC
+	select CACHE_L2X0
+	select CPU_PJ4B
+	select HAVE_ARM_TWD if LOCAL_TIMERS
+	select HAVE_SMP
+	select LOCAL_TIMERS if SMP
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
index 0000000..54b3ba7
--- /dev/null
+++ b/arch/arm/mach-berlin/berlin.c
@@ -0,0 +1,39 @@
+/*
+ * Device Tree support for Marvell Berlin (88DE3xxx) platforms.
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
+DT_MACHINE_START(BERLIN_DT, "Marvell Berlin (88DE3xxx)")
+	.dt_compat      = berlin_dt_compat,
+	.init_machine   = berlin_init_machine,
+MACHINE_END
-- 
1.7.10.4

