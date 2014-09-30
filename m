Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaI3M03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:26:29 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:40362 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaI3M01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:26:27 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC v2 1/4] ARM: hw_breakpoint: Add arm_dbg_regs_available flag
Date: Tue, 30 Sep 2014 14:26:24 +0200
Message-Id: <1412079987-1827-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412079987-1827-1-git-send-email-geert+renesas@glider.be>
References: <1412079987-1827-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If power area D4, which contains the Coresight-ETM hardware block, is
powered down on R-Mobile A1 (r8a7740), the kernel crashes when
suspending from s2ram with:

    Internal error: Oops - undefined instruction: 0 [#1] ARM

This happens because dbg_cpu_pm_notify() calls reset_ctrl_regs(), which
can't access the debug registers as the debug module is powered down.

As suggested by Russell King, track whether the ETM block is powered down
to fix this.

The availability of the debug registers depends on the platform and its
state.  Hence provide a mechanism for platform code to indicate that the
debug registers are available or not, using a boolean flag that defaults
to true.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - New

 arch/arm/include/asm/hw_breakpoint.h | 2 ++
 arch/arm/kernel/hw_breakpoint.c      | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/hw_breakpoint.h b/arch/arm/include/asm/hw_breakpoint.h
index 8e427c7b44257d2d..51ffdae41bfe3754 100644
--- a/arch/arm/include/asm/hw_breakpoint.h
+++ b/arch/arm/include/asm/hw_breakpoint.h
@@ -110,6 +110,8 @@ static inline void decode_ctrl_reg(u32 reg,
 	asm volatile("mcr p14, 0, %0, " #N "," #M ", " #OP2 : : "r" (VAL));\
 } while (0)
 
+extern bool arm_dbg_regs_available;
+
 struct notifier_block;
 struct perf_event;
 struct pmu;
diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index b5b452f90f761bd2..96193c0165fbe5ca 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -38,6 +38,8 @@
 #include <asm/traps.h>
 #include <asm/hardware/coresight.h>
 
+bool arm_dbg_regs_available = true;
+
 /* Breakpoint currently in use for each BRP. */
 static DEFINE_PER_CPU(struct perf_event *, bp_on_reg[ARM_MAX_BRP]);
 
@@ -931,6 +933,11 @@ static void reset_ctrl_regs(void *unused)
 	int i, raw_num_brps, err = 0, cpu = smp_processor_id();
 	u32 val;
 
+	if (!arm_dbg_regs_available) {
+		pr_warn_once("Debug registers are not available\n");
+		return;
+	}
+
 	/*
 	 * v7 debug contains save and restore registers so that debug state
 	 * can be maintained across low-power modes without leaving the debug
-- 
1.9.1

