Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbaD1Tyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:54:46 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:28259 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933161AbaD1Txc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:53:32 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 05/10] clk: versatile: Split config options for sp810 and vexpress_osc
Date: Mon, 28 Apr 2014 18:57:52 +0100
Message-Id: <1398707877-22596-6-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the Kconfig entry for Versatile (& Express) clock drivers
into a separate file and add individual options for sp810
and vexpress_osc drivers, as they are optional in some
configurations and may have separate dependencies.

Cc: Mike Turquette <mturquette@linaro.org> 
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/clk/Kconfig            |  9 +--------
 drivers/clk/versatile/Kconfig  | 26 ++++++++++++++++++++++++++
 drivers/clk/versatile/Makefile |  5 +++--
 3 files changed, 30 insertions(+), 10 deletions(-)
 create mode 100644 drivers/clk/versatile/Kconfig

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 6f56d3a..4fdfd6c 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -30,14 +30,7 @@ config COMMON_CLK_WM831X
           Supports the clocking subsystem of the WM831x/2x series of
 	  PMICs from Wolfson Microlectronics.
 
-config COMMON_CLK_VERSATILE
-	bool "Clock driver for ARM Reference designs"
-	depends on ARCH_INTEGRATOR || ARCH_REALVIEW || ARCH_VEXPRESS || ARM64
-	---help---
-          Supports clocking on ARM Reference designs:
-	  - Integrator/AP and Integrator/CP
-	  - RealView PB1176, EB, PB11MP and PBX
-	  - Versatile Express
+source "drivers/clk/versatile/Kconfig"
 
 config COMMON_CLK_MAX77686
 	tristate "Clock driver for Maxim 77686 MFD"
diff --git a/drivers/clk/versatile/Kconfig b/drivers/clk/versatile/Kconfig
new file mode 100644
index 0000000..1530c93
--- /dev/null
+++ b/drivers/clk/versatile/Kconfig
@@ -0,0 +1,26 @@
+config COMMON_CLK_VERSATILE
+	bool "Clock driver for ARM Reference designs"
+	depends on ARCH_INTEGRATOR || ARCH_REALVIEW || ARCH_VEXPRESS || ARM64
+	---help---
+          Supports clocking on ARM Reference designs:
+	  - Integrator/AP and Integrator/CP
+	  - RealView PB1176, EB, PB11MP and PBX
+	  - Versatile Express
+
+config CLK_SP810
+	bool "Clock driver for ARM SP810 System Controller"
+	depends on COMMON_CLK_VERSATILE
+	default y if ARCH_VEXPRESS
+	---help---
+	  Supports clock muxing (REFCLK/TIMCLK to TIMERCLKEN0-3) capabilities
+	  of the ARM SP810 System Controller cell.
+
+config CLK_VEXPRESS_OSC
+	bool "Clock driver for Versatile Express OSC clock generators"
+	depends on COMMON_CLK_VERSATILE
+	depends on VEXPRESS_CONFIG
+	default y if ARCH_VEXPRESS
+	---help---
+	  Simple regmap-based driver driving clock generators on Versatile
+	  Express platforms hidden behind its configuration infrastructure,
+	  commonly known as OSCs.
diff --git a/drivers/clk/versatile/Makefile b/drivers/clk/versatile/Makefile
index c16ca78..fd449f9 100644
--- a/drivers/clk/versatile/Makefile
+++ b/drivers/clk/versatile/Makefile
@@ -3,5 +3,6 @@ obj-$(CONFIG_ICST)		+= clk-icst.o
 obj-$(CONFIG_ARCH_INTEGRATOR)	+= clk-integrator.o
 obj-$(CONFIG_INTEGRATOR_IMPD1)	+= clk-impd1.o
 obj-$(CONFIG_ARCH_REALVIEW)	+= clk-realview.o
-obj-$(CONFIG_ARCH_VEXPRESS)	+= clk-vexpress.o clk-sp810.o
-obj-$(CONFIG_VEXPRESS_CONFIG)	+= clk-vexpress-osc.o
+obj-$(CONFIG_ARCH_VEXPRESS)	+= clk-vexpress.o
+obj-$(CONFIG_CLK_SP810)		+= clk-sp810.o
+obj-$(CONFIG_CLK_VEXPRESS_OSC)	+= clk-vexpress-osc.o
-- 
1.9.1

