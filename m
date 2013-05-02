Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761845Ab3EBXth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 19:49:37 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:37109 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3EBXtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 19:49:07 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] ARM: dove: move DT boards to orion irqchip driver
Date: Fri,  3 May 2013 01:48:38 +0200
Message-Id: <1367538519-23940-5-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367538519-23940-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1367538519-23940-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With legacy devices mapping their irqs, we can now switch DT enabled
boards to orion irqchip driver.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- split off DT changes (Suggested by Jason Cooper)
- use irqchip_init (Suggested by Jason Gunthorpe)

Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-dove/Kconfig    |    1 +
 arch/arm/mach-dove/Makefile   |    4 ++--
 arch/arm/mach-dove/board-dt.c |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-dove/Kconfig b/arch/arm/mach-dove/Kconfig
index 36469d8..60d72b4 100644
--- a/arch/arm/mach-dove/Kconfig
+++ b/arch/arm/mach-dove/Kconfig
@@ -22,6 +22,7 @@ config MACH_CM_A510
 
 config MACH_DOVE_DT
 	bool "Marvell Dove Flattened Device Tree"
+	select IRQCHIP_ORION
 	select MVEBU_CLK_CORE
 	select MVEBU_CLK_GATING
 	select REGULATOR
diff --git a/arch/arm/mach-dove/Makefile b/arch/arm/mach-dove/Makefile
index 3f0a858..4780f78 100644
--- a/arch/arm/mach-dove/Makefile
+++ b/arch/arm/mach-dove/Makefile
@@ -1,5 +1,5 @@
-obj-y				+= common.o addr-map.o irq.o
-obj-$(CONFIG_DOVE_LEGACY)	+= mpp.o
+obj-y				+= common.o addr-map.o
+obj-$(CONFIG_DOVE_LEGACY)	+= irq.o mpp.o
 obj-$(CONFIG_PCI)		+= pcie.o
 obj-$(CONFIG_MACH_DOVE_DB)	+= dove-db-setup.o
 obj-$(CONFIG_MACH_DOVE_DT)	+= board-dt.o
diff --git a/arch/arm/mach-dove/board-dt.c b/arch/arm/mach-dove/board-dt.c
index cea65b7..404c993 100644
--- a/arch/arm/mach-dove/board-dt.c
+++ b/arch/arm/mach-dove/board-dt.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/clk-provider.h>
 #include <linux/clk/mvebu.h>
+#include <linux/irqchip.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -20,7 +21,6 @@
 #include <asm/mach/arch.h>
 #include <mach/pm.h>
 #include <plat/common.h>
-#include <plat/irq.h>
 #include <plat/time.h>
 #include "common.h"
 
@@ -143,7 +143,7 @@ static const char * const dove_dt_board_compat[] = {
 
 DT_MACHINE_START(DOVE_DT, "Marvell Dove (Flattened Device Tree)")
 	.map_io		= dove_map_io,
-	.init_irq	= orion_dt_init_irq,
+	.init_irq	= irqchip_init,
 	.init_time	= dove_legacy_timer_init,
 	.init_machine	= dove_dt_init,
 	.restart	= dove_restart,
-- 
1.7.10.4

