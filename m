Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaAMPES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:04:18 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:36657 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaAMPEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:04:14 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Tero Kristo <t-kristo@ti.com>
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: OMAP4: sleep/smp: switch CPU to BE if compiled for BE
Date: Mon, 13 Jan 2014 17:04:06 +0200
Message-Id: <1389625447-24132-1-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Kamensky <victor.kamensky@linaro.org>

If kernel operates in BE mode on device that has LE bootloader/ROM code,
we need to switch CPU to operate in BE mode before it will start to
access BE data. Generic secondary_startup function that is called from
OMAP specific secondary startup code will do the switch, but we need
to do it earlier because OMAP's secondary_startup code works with BE data.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
This is a part of RFC series [1].
Based on v3.13-rc8.

[1] http://www.spinics.net/lists/linux-omap/msg99927.html

 arch/arm/mach-omap2/omap-headsmp.S |   13 +++++++++++++
 arch/arm/mach-omap2/sleep44xx.S    |    6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm/mach-omap2/omap-headsmp.S b/arch/arm/mach-omap2/omap-headsmp.S
index 75e9295..75c98d4 100644
--- a/arch/arm/mach-omap2/omap-headsmp.S
+++ b/arch/arm/mach-omap2/omap-headsmp.S
@@ -17,6 +17,7 @@
 
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <asm/assembler.h>
 
 #include "omap44xx.h"
 
@@ -58,6 +59,12 @@ hold:	ldr	r12,=0x103
 	bne	hold
 
 	/*
+	 * ROM code operates in little endian mode, when we get control we
+	 * need to switch it back to big endian mode.
+	 */
+ARM_BE8(setend be)
+
+	/*
 	 * we've been released from the wait loop,secondary_stack
 	 * should now contain the SVC stack for this core
 	 */
@@ -75,6 +82,12 @@ hold_2:	ldr	r12,=0x103
 	bne	hold_2
 
 	/*
+	 * ROM code operates in little endian mode, when we get control we
+	 * need to switch it back to big endian mode.
+	 */
+ARM_BE8(setend be)
+
+	/*
 	 * GIC distributor control register has changed between
 	 * CortexA9 r1pX and r2pX. The Control Register secure
 	 * banked version is now composed of 2 bits:
diff --git a/arch/arm/mach-omap2/sleep44xx.S b/arch/arm/mach-omap2/sleep44xx.S
index 9086ce0..e556c8b 100644
--- a/arch/arm/mach-omap2/sleep44xx.S
+++ b/arch/arm/mach-omap2/sleep44xx.S
@@ -249,6 +249,12 @@ ENDPROC(omap4_finish_suspend)
  */
 ENTRY(omap4_cpu_resume)
 	/*
+	 * ROM code operates in little endian mode, when we get control we
+	 * need to switch it back to big endian mode.
+	 */
+ARM_BE8(setend	be)
+
+	/*
 	 * Configure ACTRL and enable NS SMP bit access on CPU1 on HS device.
 	 * OMAP44XX EMU/HS devices - CPU0 SMP bit access is enabled in PPA
 	 * init and for CPU1, a secure PPA API provided. CPU0 must be ON
-- 
1.7.9.5

