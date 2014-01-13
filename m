Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaAMPD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:03:58 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:40849 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaAMPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:03:52 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Tero Kristo <t-kristo@ti.com>
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: OMAP4: sleep: byteswap data for big-endian
Date: Mon, 13 Jan 2014 17:03:19 +0200
Message-Id: <1389625399-24087-1-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Kamensky <victor.kamensky@linaro.org>

Assembler functions defined in sleep44xx.S need to byteswap values
after read / before write from h/w register if code compiled in big
endian mode. Simple change to do 'rev x, x' before str instruction
and after ldr instruction that deals with h/w registers.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
This is a part of RFC series [1].
Based on v3.13-rc8.

[1] http://www.spinics.net/lists/linux-omap/msg99927.html

 arch/arm/mach-omap2/sleep44xx.S |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/mach-omap2/sleep44xx.S b/arch/arm/mach-omap2/sleep44xx.S
index 9086ce0..8017016 100644
--- a/arch/arm/mach-omap2/sleep44xx.S
+++ b/arch/arm/mach-omap2/sleep44xx.S
@@ -12,6 +12,7 @@
 #include <linux/linkage.h>
 #include <asm/smp_scu.h>
 #include <asm/memory.h>
+#include <asm/assembler.h>
 #include <asm/hardware/cache-l2x0.h>
 
 #include "omap-secure.h"
@@ -74,6 +75,7 @@ ENTRY(omap4_finish_suspend)
 	 */
 	bl	omap4_get_sar_ram_base
 	ldr	r9, [r0, #OMAP_TYPE_OFFSET]
+ARM_BE8(rev	r9, r9)
 	cmp	r9, #0x1			@ Check for HS device
 	bne	skip_secure_l1_clean
 	mov	r0, #SCU_PM_NORMAL
@@ -113,12 +115,14 @@ skip_secure_l1_clean:
 	bl	omap4_get_sar_ram_base
 	mov	r8, r0
 	ldr	r9, [r8, #OMAP_TYPE_OFFSET]
+ARM_BE8(rev	r9, r9)
 	cmp	r9, #0x1			@ Check for HS device
 	bne	scu_gp_set
 	mrc	p15, 0, r0, c0, c0, 5		@ Read MPIDR
 	ands	r0, r0, #0x0f
 	ldreq	r0, [r8, #SCU_OFFSET0]
 	ldrne	r0, [r8, #SCU_OFFSET1]
+ARM_BE8(rev	r0, r0)
 	mov	r1, #0x00
 	stmfd   r13!, {r4-r12, r14}
 	ldr	r12, =OMAP4_MON_SCU_PWR_INDEX
@@ -130,6 +134,7 @@ scu_gp_set:
 	ands	r0, r0, #0x0f
 	ldreq	r1, [r8, #SCU_OFFSET0]
 	ldrne	r1, [r8, #SCU_OFFSET1]
+ARM_BE8(rev	r1, r1)
 	bl	omap4_get_scu_base
 	bl	scu_power_mode
 skip_scu_gp_set:
@@ -157,6 +162,7 @@ skip_scu_gp_set:
 	ands	r5, r5, #0x0f
 	ldreq	r0, [r8, #L2X0_SAVE_OFFSET0]	@ Retrieve L2 state from SAR
 	ldrne	r0, [r8, #L2X0_SAVE_OFFSET1]	@ memory.
+ARM_BE8(rev	r0, r0)
 	cmp	r0, #3
 	bne	do_WFI
 #ifdef CONFIG_PL310_ERRATA_727915
@@ -167,9 +173,11 @@ skip_scu_gp_set:
 	bl	omap4_get_l2cache_base
 	mov	r2, r0
 	ldr	r0, =0xffff
+ARM_BE8(rev	r0, r0)
 	str	r0, [r2, #L2X0_CLEAN_INV_WAY]
 wait:
 	ldr	r0, [r2, #L2X0_CLEAN_INV_WAY]
+ARM_BE8(rev	r0, r0)
 	ldr	r1, =0xffff
 	ands	r0, r0, r1
 	bne	wait
@@ -182,9 +190,11 @@ l2x_sync:
 	bl	omap4_get_l2cache_base
 	mov	r2, r0
 	mov	r0, #0x0
+ARM_BE8(rev	r0, r0)
 	str	r0, [r2, #L2X0_CACHE_SYNC]
 sync:
 	ldr	r0, [r2, #L2X0_CACHE_SYNC]
+ARM_BE8(rev	r0, r0)
 	ands	r0, r0, #0x1
 	bne	sync
 #endif
@@ -216,6 +226,7 @@ do_WFI:
 	bl	omap4_get_sar_ram_base
 	mov	r8, r0
 	ldr	r9, [r8, #OMAP_TYPE_OFFSET]
+ARM_BE8(rev	r9, r9)
 	cmp	r9, #0x1			@ Check for HS device
 	bne	scu_gp_clear
 	mov	r0, #SCU_PM_NORMAL
@@ -258,6 +269,7 @@ ENTRY(omap4_cpu_resume)
 	 */
 	ldr	r8, =OMAP44XX_SAR_RAM_BASE
 	ldr	r9, [r8, #OMAP_TYPE_OFFSET]
+ARM_BE8(rev	r9, r9)
 	cmp	r9, #0x1			@ Skip if GP device
 	bne	skip_ns_smp_enable
 	mrc     p15, 0, r0, c0, c0, 5
@@ -292,16 +304,19 @@ skip_ns_smp_enable:
 	 */
 	ldr	r2, =OMAP44XX_L2CACHE_BASE
 	ldr	r0, [r2, #L2X0_CTRL]
+ARM_BE8(rev	r0, r0)
 	and	r0, #0x0f
 	cmp	r0, #1
 	beq	skip_l2en			@ Skip if already enabled
 	ldr	r3, =OMAP44XX_SAR_RAM_BASE
 	ldr	r1, [r3, #OMAP_TYPE_OFFSET]
+ARM_BE8(rev	r1, r1)
 	cmp	r1, #0x1			@ Check for HS device
 	bne     set_gp_por
 	ldr     r0, =OMAP4_PPA_L2_POR_INDEX
 	ldr     r1, =OMAP44XX_SAR_RAM_BASE
 	ldr     r4, [r1, #L2X0_PREFETCH_CTRL_OFFSET]
+ARM_BE8(rev	r4, r4)
 	adr     r3, ppa_por_params
 	str     r4, [r3, #0x04]
 	mov	r1, #0x0			@ Process ID
@@ -313,11 +328,13 @@ skip_ns_smp_enable:
 set_gp_por:
 	ldr     r1, =OMAP44XX_SAR_RAM_BASE
 	ldr     r0, [r1, #L2X0_PREFETCH_CTRL_OFFSET]
+ARM_BE8(rev	r0, r0)
 	ldr	r12, =OMAP4_MON_L2X0_PREFETCH_INDEX	@ Setup L2 PREFETCH
 	DO_SMC
 set_aux_ctrl:
 	ldr     r1, =OMAP44XX_SAR_RAM_BASE
 	ldr	r0, [r1, #L2X0_AUXCTRL_OFFSET]
+ARM_BE8(rev	r0, r0)
 	ldr	r12, =OMAP4_MON_L2X0_AUXCTRL_INDEX	@ Setup L2 AUXCTRL
 	DO_SMC
 	mov	r0, #0x1
-- 
1.7.9.5

