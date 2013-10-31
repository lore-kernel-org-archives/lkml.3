Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3JaQLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:11:43 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40077 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3JaQLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:11:15 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 5/6] arm: zynq: Set proper GIC flags
Date: Thu, 31 Oct 2013 09:10:18 -0700
Message-Id: <1383235819-2552-6-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zynq is able to wake up on any IRQ, so flag it with
IRQCHIP_SKIP_SET_WAKE, and we want to mask off the IRQs when
going to suspend to avoid transient effects so also flag
this with IRQCHIP_MASK_ON_SUSPEND.

This is essentially, making the same changes as commit
'ARM: ux500: set proper GIC flags'
(sha1: 7e1f97ea8ffa66679252520dbbbd6ec413ecae68) for Zynq.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/mach-zynq/common.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 5690925519bf..eb59bae37c04 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -25,6 +25,8 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/of.h>
+#include <linux/irqchip.h>
+#include <linux/irqchip/arm-gic.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -86,6 +88,12 @@ static void __init zynq_map_io(void)
 	zynq_scu_map_io();
 }
 
+static void __init zynq_irq_init(void)
+{
+	gic_arch_extn.flags = IRQCHIP_SKIP_SET_WAKE | IRQCHIP_MASK_ON_SUSPEND;
+	irqchip_init();
+}
+
 static void zynq_system_reset(enum reboot_mode mode, const char *cmd)
 {
 	zynq_slcr_system_reset();
@@ -99,6 +107,7 @@ static const char * const zynq_dt_match[] = {
 DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
 	.smp		= smp_ops(zynq_smp_ops),
 	.map_io		= zynq_map_io,
+	.init_irq	= zynq_irq_init,
 	.init_machine	= zynq_init_machine,
 	.init_time	= zynq_timer_init,
 	.dt_compat	= zynq_dt_match,
-- 
1.8.4.1

