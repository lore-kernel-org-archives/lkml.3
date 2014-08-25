Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaHYBJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 21:09:11 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:36322 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaHYBJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 21:09:08 -0400
From: Simon Horman <horms+renesas@verge.net.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH] sh: intc: Confine SH_INTC to platforms that need it
Date: Mon, 25 Aug 2014 10:08:56 +0900
Message-Id: <049d28048be595e0a10a58fe1c104b153c386633.1408928574.git.horms+renesas@verge.net.au>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1408928574.git.horms+renesas@verge.net.au>
References: <cover.1408928574.git.horms+renesas@verge.net.au>
In-Reply-To: <cover.1408928574.git.horms+renesas@verge.net.au>
References: <cover.1408928574.git.horms+renesas@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Currently the sh-intc driver is compiled on all SuperH and
non-multiplatform SH-Mobile platforms, while it's only used on a limited
number of platforms:
  - SuperH: SH2(A), SH3(A), SH4(A)(L) (all but SH5)
  - ARM: sh7372, sh73a0

Drop the "default y" on SH_INTC, make all CPU platforms that use it
select it, and protect all sub-options by "if SH_INTC" to fix this.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Magnus Damm <damm+renesas@opensource.se>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 arch/arm/mach-shmobile/Kconfig | 2 ++
 arch/sh/Kconfig                | 3 +++
 drivers/sh/Makefile            | 3 +--
 drivers/sh/intc/Kconfig        | 6 +++++-
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index e15dff7..1e6c51c 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -75,6 +75,7 @@ config ARCH_SH7372
 	select ARM_CPU_SUSPEND if PM || CPU_IDLE
 	select CPU_V7
 	select SH_CLK_CPG
+	select SH_INTC
 	select SYS_SUPPORTS_SH_CMT
 	select SYS_SUPPORTS_SH_TMU
 
@@ -85,6 +86,7 @@ config ARCH_SH73A0
 	select CPU_V7
 	select I2C
 	select SH_CLK_CPG
+	select SH_INTC
 	select RENESAS_INTC_IRQPIN
 	select SYS_SUPPORTS_SH_CMT
 	select SYS_SUPPORTS_SH_TMU
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 453fa5c..b319846 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -172,6 +172,7 @@ menu "System type"
 #
 config CPU_SH2
 	bool
+	select SH_INTC
 
 config CPU_SH2A
 	bool
@@ -182,6 +183,7 @@ config CPU_SH3
 	bool
 	select CPU_HAS_INTEVT
 	select CPU_HAS_SR_RB
+	select SH_INTC
 	select SYS_SUPPORTS_SH_TMU
 
 config CPU_SH4
@@ -189,6 +191,7 @@ config CPU_SH4
 	select CPU_HAS_INTEVT
 	select CPU_HAS_SR_RB
 	select CPU_HAS_FPU if !CPU_SH4AL_DSP
+	select SH_INTC
 	select SYS_SUPPORTS_SH_TMU
 	select SYS_SUPPORTS_HUGETLBFS if MMU
 
diff --git a/drivers/sh/Makefile b/drivers/sh/Makefile
index 788ed9b..114203f 100644
--- a/drivers/sh/Makefile
+++ b/drivers/sh/Makefile
@@ -1,8 +1,7 @@
 #
 # Makefile for the SuperH specific drivers.
 #
-obj-$(CONFIG_SUPERH)			+= intc/
-obj-$(CONFIG_ARCH_SHMOBILE_LEGACY)	+= intc/
+obj-$(CONFIG_SH_INTC)			+= intc/
 ifneq ($(CONFIG_COMMON_CLK),y)
 obj-$(CONFIG_HAVE_CLK)			+= clk/
 endif
diff --git a/drivers/sh/intc/Kconfig b/drivers/sh/intc/Kconfig
index 60228fa..6a1b05d 100644
--- a/drivers/sh/intc/Kconfig
+++ b/drivers/sh/intc/Kconfig
@@ -1,7 +1,9 @@
 config SH_INTC
-	def_bool y
+	bool
 	select IRQ_DOMAIN
 
+if SH_INTC
+
 comment "Interrupt controller options"
 
 config INTC_USERIMASK
@@ -37,3 +39,5 @@ config INTC_MAPPING_DEBUG
 	  between system IRQs and the per-controller id tables.
 
 	  If in doubt, say N.
+
+endif
-- 
2.0.1

