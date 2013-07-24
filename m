Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3GXUgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:36:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51516 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3GXUgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:36:14 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] ARM: Fix deadlock scenario with smp_send_stop()
Date: Wed, 24 Jul 2013 13:36:10 -0700
Message-Id: <1374698170-26605-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
In-Reply-To: <20130724202148.GA24642@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one process calls sys_reboot and that process then stops other
CPUs while those CPUs are within a spin_lock() region we can
potentially encounter a deadlock scenario like below.

CPU 0                   CPU 1
-----                   -----
                        spin_lock(my_lock)
smp_send_stop()
 <send IPI>             handle_IPI()
                         disable_preemption/irqs
                          while(1);
 <PREEMPT>
spin_lock(my_lock) <--- Waits forever

We shouldn't attempt to run any other tasks after we send a stop
IPI to a CPU so disable preemption so that this task runs to
completion. We use local_irq_disable() here for cross-arch
consistency with x86.

Reported-by: Sundarajan Srinivasan <sundaraj@codeaurora.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Changes since v1:
 - Use local_irq_disable() instead of preempt_disable()

 arch/arm/kernel/process.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index d3ca4f6..08b47eb 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -197,6 +197,7 @@ void machine_shutdown(void)
  */
 void machine_halt(void)
 {
+	local_irq_disable();
 	smp_send_stop();
 
 	local_irq_disable();
@@ -211,6 +212,7 @@ void machine_halt(void)
  */
 void machine_power_off(void)
 {
+	local_irq_disable();
 	smp_send_stop();
 
 	if (pm_power_off)
@@ -230,6 +232,7 @@ void machine_power_off(void)
  */
 void machine_restart(char *cmd)
 {
+	local_irq_disable();
 	smp_send_stop();
 
 	arm_pm_restart(reboot_mode, cmd);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

