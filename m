Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3JaQKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:10:39 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:33273 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab3JaQKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:10:34 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/6] arm: zynq: Invalidate L1 in secondary boot
Date: Thu, 31 Oct 2013 09:10:15 -0700
Message-Id: <1383235819-2552-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During boot, Linux initiates a clean-invalidate operation only, resulting
in faulty data to be written to the memory system during resume.
Therefore invalidate the L1 in the secondary boot path to avoid these
issues.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/mach-zynq/common.h  | 2 ++
 arch/arm/mach-zynq/headsmp.S | 6 +++++-
 arch/arm/mach-zynq/platsmp.c | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index 3040d219570f..c22c92cea8cb 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -17,6 +17,8 @@
 #ifndef __MACH_ZYNQ_COMMON_H__
 #define __MACH_ZYNQ_COMMON_H__
 
+void zynq_secondary_startup(void);
+
 extern int zynq_slcr_init(void);
 extern void zynq_slcr_system_reset(void);
 extern void zynq_slcr_cpu_stop(int cpu);
diff --git a/arch/arm/mach-zynq/headsmp.S b/arch/arm/mach-zynq/headsmp.S
index d4cd5f34fe5c..57a32869f0aa 100644
--- a/arch/arm/mach-zynq/headsmp.S
+++ b/arch/arm/mach-zynq/headsmp.S
@@ -18,5 +18,9 @@ zynq_secondary_trampoline_jump:
 	.word	/* cpu 1 */
 .globl zynq_secondary_trampoline_end
 zynq_secondary_trampoline_end:
-
 ENDPROC(zynq_secondary_trampoline)
+
+ENTRY(zynq_secondary_startup)
+	bl	v7_invalidate_l1
+	b	secondary_startup
+ENDPROC(zynq_secondary_startup)
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 2512624e657d..daed70682c54 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -95,7 +95,7 @@ EXPORT_SYMBOL(zynq_cpun_start);
 static int zynq_boot_secondary(unsigned int cpu,
 						struct task_struct *idle)
 {
-	return zynq_cpun_start(virt_to_phys(secondary_startup), cpu);
+	return zynq_cpun_start(virt_to_phys(zynq_secondary_startup), cpu);
 }
 
 /*
-- 
1.8.4.1

