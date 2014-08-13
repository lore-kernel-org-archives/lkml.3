Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaHMBLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 21:11:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53138 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaHMBLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 21:11:46 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm64: smp: Update the topology masks before calling CPU_STARTING notifiers
Date: Tue, 12 Aug 2014 18:11:09 -0700
Message-Id: <1407892269-28650-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the CPU_STARTING notifiers would observe an incorrect sibling
mask since the notifier chain is called before the topology masks are updated
for the new cpu.
Update the topology masks before calling the notifier chain to fix this
problem.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/kernel/smp.c   | 4 ++--
 arch/arm64/kernel/smp.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 7c4fada..0e2237c 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -363,12 +363,12 @@ asmlinkage void secondary_start_kernel(void)
 	if (smp_ops.smp_secondary_init)
 		smp_ops.smp_secondary_init(cpu);
 
+	smp_store_cpu_info(cpu);
+
 	notify_cpu_starting(cpu);
 
 	calibrate_delay();
 
-	smp_store_cpu_info(cpu);
-
 	/*
 	 * OK, now it's safe to let the boot CPU continue.  Wait for
 	 * the CPU migration code to notice that the CPU is online
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 3e2f5eb..4ae78fe 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -163,10 +163,10 @@ asmlinkage void secondary_start_kernel(void)
 	/*
 	 * Enable GIC and timers.
 	 */
-	notify_cpu_starting(cpu);
-
 	smp_store_cpu_info(cpu);
 
+	notify_cpu_starting(cpu);
+
 	/*
 	 * OK, now it's safe to let the boot CPU continue.  Wait for
 	 * the CPU migration code to notice that the CPU is online
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

