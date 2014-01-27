Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaA0GYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:24:16 -0500
Received: from relais.videotron.ca ([24.201.245.36]:51663 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaA0GYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:24:13 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jan 2014 01:24:12 EST
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 1/9] ARM: get rid of arch_cpu_idle_prepare()
Date: Mon, 27 Jan 2014 01:08:16 -0500
Message-id: <1390802904-28399-2-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM and ARM64 are the only two architectures implementing
arch_cpu_idle_prepare() simply to call local_fiq_enable().

We have secondary_start_kernel() already calling local_fiq_enable() and
this is done a second time in arch_cpu_idle_prepare() in that case. And
enabling FIQs has nothing to do with idling the CPU to start with.

So let's introduce init_fiq_boot_cpu() to take care of FIQs on the boot
CPU and remove arch_cpu_idle_prepare(). This is now done a bit earlier
at late_initcall time but this shouldn't make a difference in practice
i.e. when FIQs are actually used.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/kernel/process.c | 5 -----
 arch/arm/kernel/setup.c   | 7 +++++++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 92f7b15dd2..725b8c95e0 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -142,11 +142,6 @@ static void default_idle(void)
 	local_irq_enable();
 }
 
-void arch_cpu_idle_prepare(void)
-{
-	local_fiq_enable();
-}
-
 void arch_cpu_idle_enter(void)
 {
 	ledtrig_cpu(CPU_LED_IDLE_START);
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 987a7f5bce..d027b1a6fe 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -789,6 +789,13 @@ static int __init init_machine_late(void)
 }
 late_initcall(init_machine_late);
 
+static int __init init_fiq_boot_cpu(void)
+{
+	local_fiq_enable();
+	return 0;
+}
+late_initcall(init_fiq_boot_cpu);
+
 #ifdef CONFIG_KEXEC
 static inline unsigned long long get_total_mem(void)
 {
-- 
1.8.4.108.g55ea5f6

