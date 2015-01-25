Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbbAYS0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:26:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbbAYSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.18 168/183] ARM: omap5/dra7xx: Enable booting secondary CPU in HYP mode
Date: Sun, 25 Jan 2015 10:08:10 -0800
Message-Id: <20150125180817.467241721@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

commit 999f934de195a1506089b52c77429fdba25da688 upstream.

If the boot loader enables HYP mode on the boot CPU, the secondary CPU
also needs to call into the ROM to switch to HYP mode before booting.
The firmwares on the omap5 and dra7xx unfortunately do not take care
of this, so it has to be handled by the kernel.

This patch is based on "[PATCH 2/2] ARM: OMAP5: Add HYP mode entry support
for secondary CPUs" by Santosh Shilimkar <santosh.shilimkar@ti.com>,
except this version does not require a compile time CONFIG to control
if it should enable HYP mode or not, it simply does it based on the mode
of the boot CPU, so it works whether the CPU boots in SVC or HYP mode,
and should even work as a guest kernel inside kvm if qemu decides to
support emulating the omap5 or dra7xx.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/common.h       |    1 +
 arch/arm/mach-omap2/omap-headsmp.S |   21 +++++++++++++++++++++
 arch/arm/mach-omap2/omap-smp.c     |   13 +++++++++++--
 3 files changed, 33 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -249,6 +249,7 @@ extern void omap4_cpu_die(unsigned int c
 extern struct smp_operations omap4_smp_ops;
 
 extern void omap5_secondary_startup(void);
+extern void omap5_secondary_hyp_startup(void);
 #endif
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PM)
--- a/arch/arm/mach-omap2/omap-headsmp.S
+++ b/arch/arm/mach-omap2/omap-headsmp.S
@@ -22,6 +22,7 @@
 
 /* Physical address needed since MMU not enabled yet on secondary core */
 #define AUX_CORE_BOOT0_PA			0x48281800
+#define API_HYP_ENTRY				0x102
 
 /*
  * OMAP5 specific entry point for secondary CPU to jump from ROM
@@ -41,6 +42,26 @@ wait:	ldr	r2, =AUX_CORE_BOOT0_PA	@ read
 	b	secondary_startup
 ENDPROC(omap5_secondary_startup)
 /*
+ * Same as omap5_secondary_startup except we call into the ROM to
+ * enable HYP mode first.  This is called instead of
+ * omap5_secondary_startup if the primary CPU was put into HYP mode by
+ * the boot loader.
+ */
+ENTRY(omap5_secondary_hyp_startup)
+wait_2:	ldr	r2, =AUX_CORE_BOOT0_PA	@ read from AuxCoreBoot0
+	ldr	r0, [r2]
+	mov	r0, r0, lsr #5
+	mrc	p15, 0, r4, c0, c0, 5
+	and	r4, r4, #0x0f
+	cmp	r0, r4
+	bne	wait_2
+	ldr	r12, =API_HYP_ENTRY
+	adr	r0, hyp_boot
+	smc	#0
+hyp_boot:
+	b	secondary_startup
+ENDPROC(omap5_secondary_hyp_startup)
+/*
  * OMAP4 specific entry point for secondary CPU to jump from ROM
  * code.  This routine also provides a holding flag into which
  * secondary core is held until we're ready for it to initialise.
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -22,6 +22,7 @@
 #include <linux/irqchip/arm-gic.h>
 
 #include <asm/smp_scu.h>
+#include <asm/virt.h>
 
 #include "omap-secure.h"
 #include "omap-wakeupgen.h"
@@ -227,8 +228,16 @@ static void __init omap4_smp_prepare_cpu
 	if (omap_secure_apis_support())
 		omap_auxcoreboot_addr(virt_to_phys(startup_addr));
 	else
-		writel_relaxed(virt_to_phys(omap5_secondary_startup),
-			       base + OMAP_AUX_CORE_BOOT_1);
+		/*
+		 * If the boot CPU is in HYP mode then start secondary
+		 * CPU in HYP mode as well.
+		 */
+		if ((__boot_cpu_mode & MODE_MASK) == HYP_MODE)
+			writel_relaxed(virt_to_phys(omap5_secondary_hyp_startup),
+				       base + OMAP_AUX_CORE_BOOT_1);
+		else
+			writel_relaxed(virt_to_phys(omap5_secondary_startup),
+				       base + OMAP_AUX_CORE_BOOT_1);
 
 }
 


