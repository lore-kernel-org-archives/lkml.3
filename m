Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaEFV0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:26:32 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:57213 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaEFV0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:26:30 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v4] drivers: sh: compile drivers/sh/pm_runtime.c if ARCH_SHMOBILE_MULTI
Date: Tue,  6 May 2014 23:26:19 +0200
Message-Id: <1399411579-10681-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
This is a minimal solution to fix the issue for multi-platform shmobile
kernels in a multi-platform-friendly way.
As it touches drivers/sh-specific code only, Simom should still be able to
get it in v3.15, and backported to v3.14-stable.

Tested on Koelsch (legacy, reference, shmobile, and shmobile+bbb kernels)
and BeagleBone Black (shmobile+bbb). Will test on more hardware tomorrow.
Without this patch, (1) removing the clk_enables[] causes the thermal
sensor to fail, and (2) disabling all MSTP clocks on bootup causes the
thermal sensor, RSPI, MSIOF, and SH_ETH to fail.

v4:
  - Re-add lost "static" to sh_pm_runtime_init,
  - Use IS_ENABLED() instead of #ifdef, to increase compile coverage
    (as suggested by Ben Dooks),
v3:
  - Add of_machine_is_compatible() checks for multi-platform
  - Remove Reviewed-by, Tested-by, as too much has changed,
  - Assumed authorship, as not much is left from the original patch from
    Ben (Ben: is that OK?),
v2:
  - Add Reviewed-by, Tested-by.
---
 drivers/Makefile        |    2 +-
 drivers/sh/Makefile     |   14 ++++++++------
 drivers/sh/pm_runtime.c |   20 +++++++++++++++++++-
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index d05d81b19b50..7183b6af5dac 100644
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
index fc67f564f02c..788ed9b59b4e 100644
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
index 8afa5a4589f2..10c65eb51f85 100644
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
1.7.9.5

