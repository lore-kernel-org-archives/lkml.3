Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbaEMHmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:42:20 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:54945 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaEMHmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:42:18 -0400
From: Simon Horman <horms+renesas@verge.net.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <paul.mundt@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH] drivers: sh: compile drivers/sh/pm_runtime.c if ARCH_SHMOBILE_MULTI
Date: Tue, 13 May 2014 16:42:05 +0900
Message-Id: <3c90c55dcde745bed81f6447f24ba96bda43d984.1399966519.git.horms+renesas@verge.net.au>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <cover.1399966519.git.horms+renesas@verge.net.au>
References: <cover.1399966519.git.horms+renesas@verge.net.au>
In-Reply-To: <cover.1399966519.git.horms+renesas@verge.net.au>
References: <cover.1399966519.git.horms+renesas@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

If the kernel is built to support multi-ARM configuration with shmobile
support built in, then drivers/sh is not built. This contains the PM
runtime code in drivers/sh/pm_runtime.c, which implicitly enables the
module clocks for all devices, and thus is quite essential.
Without this, the state of clocks depends on implicit reset state, or on
the bootloader.

If ARCH_SHMOBILE_MULTI then build the drivers/sh directory, but ensure that
bits that may conflict (drivers/sh/clk if the common clock framework is
enabled) or are not used (drivers/sh/intc), are not built.
Also, only enable the PM runtime code when actually running on a shmobile
SoCs that needs it.

ARCH_SHMOBILE_MULTI was added a while ago by commit
efacfce5f8a523457e9419a25d52fe39db00b26a ("ARM: shmobile: Introduce
ARCH_SHMOBILE_MULTI"), but drivers/sh was compiled for both
ARCH_SHMOBILE_LEGACY and ARCH_SHMOBILE_MULTI until commit
bf98c1eac1d4a6bcf00532e4fa41d8126cd6c187 ("ARM: Rename ARCH_SHMOBILE to
ARCH_SHMOBILE_LEGACY").

Inspired by a patch from Ben Dooks <ben.dooks@codethink.co.uk>.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/Makefile        |  2 +-
 drivers/sh/Makefile     | 14 ++++++++------
 drivers/sh/pm_runtime.c | 20 +++++++++++++++++++-
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index e3ced91..c033798 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -119,7 +119,7 @@ obj-$(CONFIG_SGI_SN)		+= sn/
 obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
-obj-$(CONFIG_ARCH_SHMOBILE_LEGACY)	+= sh/
+obj-$(CONFIG_ARCH_SHMOBILE)	+= sh/
 ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 obj-y				+= clocksource/
 endif
diff --git a/drivers/sh/Makefile b/drivers/sh/Makefile
index fc67f56..788ed9b 100644
--- a/drivers/sh/Makefile
+++ b/drivers/sh/Makefile
@@ -1,10 +1,12 @@
 #
 # Makefile for the SuperH specific drivers.
 #
-obj-y	:= intc/
+obj-$(CONFIG_SUPERH)			+= intc/
+obj-$(CONFIG_ARCH_SHMOBILE_LEGACY)	+= intc/
+ifneq ($(CONFIG_COMMON_CLK),y)
+obj-$(CONFIG_HAVE_CLK)			+= clk/
+endif
+obj-$(CONFIG_MAPLE)			+= maple/
+obj-$(CONFIG_SUPERHYWAY)		+= superhyway/
 
-obj-$(CONFIG_HAVE_CLK)		+= clk/
-obj-$(CONFIG_MAPLE)		+= maple/
-obj-$(CONFIG_SUPERHYWAY)	+= superhyway/
-
-obj-y				+= pm_runtime.o
+obj-y					+= pm_runtime.o
diff --git a/drivers/sh/pm_runtime.c b/drivers/sh/pm_runtime.c
index 8afa5a4..10c65eb 100644
--- a/drivers/sh/pm_runtime.c
+++ b/drivers/sh/pm_runtime.c
@@ -50,8 +50,25 @@ static struct pm_clk_notifier_block platform_bus_notifier = {
 	.con_ids = { NULL, },
 };
 
+static bool default_pm_on;
+
 static int __init sh_pm_runtime_init(void)
 {
+	if (IS_ENABLED(CONFIG_ARCH_SHMOBILE_MULTI)) {
+		if (!of_machine_is_compatible("renesas,emev2") &&
+		    !of_machine_is_compatible("renesas,r7s72100") &&
+		    !of_machine_is_compatible("renesas,r8a73a4") &&
+		    !of_machine_is_compatible("renesas,r8a7740") &&
+		    !of_machine_is_compatible("renesas,r8a7778") &&
+		    !of_machine_is_compatible("renesas,r8a7779") &&
+		    !of_machine_is_compatible("renesas,r8a7790") &&
+		    !of_machine_is_compatible("renesas,r8a7791") &&
+		    !of_machine_is_compatible("renesas,sh7372") &&
+		    !of_machine_is_compatible("renesas,sh73a0"))
+			return 0;
+	}
+
+	default_pm_on = true;
 	pm_clk_add_notifier(&platform_bus_type, &platform_bus_notifier);
 	return 0;
 }
@@ -59,7 +76,8 @@ core_initcall(sh_pm_runtime_init);
 
 static int __init sh_pm_runtime_late_init(void)
 {
-	pm_genpd_poweroff_unused();
+	if (default_pm_on)
+		pm_genpd_poweroff_unused();
 	return 0;
 }
 late_initcall(sh_pm_runtime_late_init);
-- 
1.8.5.2

