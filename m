Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3CQVuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 17:50:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48860 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755785Ab3CQVuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 17:50:11 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 1/2] alpha: irq: run all handlers with interrupts disabled
Date: Sun, 17 Mar 2013 21:49:55 +0000
Message-Id: <1363556996-21180-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux has expected that interrupt handlers are executed with local
interrupts disabled for a while now, so ensure that this is the case on
Alpha even for non-device interrupts such as IPIs.

Without this patch, secondary boot results in the following backtrace:

------------[ cut here ]------------
warning: at kernel/softirq.c:139 __local_bh_enable+0xb8/0xd0()
modules linked in:
fffffc0000867c70 fffffc0000876618 fffffc0000330628 0000000000000200
       fffffc000088e1b0 fffffc0000868000 0000000000000000 0000000000000000
       fffffc0000331594 fffffc00008c79a0 fffffc000085fac0 0000000000000001
       fffffc00003597e0 0000000000000008 fffffc000031b3b4 0000000000000001
       0000000000000001 0000000000000000 fffffc0000315c4c fffffc00008b88f8
       fffffc0000856e20 fffffc0000856b00 fffffc0001a060c0 0000000000000007
trace:
[<fffffc0000330628>] __local_bh_enable+0xb8/0xd0
[<fffffc0000331594>] irq_enter+0x74/0xa0
[<fffffc00003597e0>] scheduler_ipi+0x50/0x100
[<fffffc000031b3b4>] handle_ipi+0x84/0x260
[<fffffc0000315c4c>] do_entint+0x1ac/0x2e0
[<fffffc0000331620>] irq_exit+0x60/0xa0
[<fffffc00003159e8>] handle_irq+0x98/0x100
[<fffffc0000315d68>] do_entint+0x2c8/0x2e0
[<fffffc0000310d80>] ret_from_sys_call+0x0/0x10
[<fffffc0000365124>] load_balance+0x3e4/0x870
[<fffffc0000312bd4>] cpu_idle+0x24/0x80
[<fffffc0000391bd0>] rcu_eqs_enter_common.isra.38+0x0/0x120
[<fffffc0000312bf0>] cpu_idle+0x40/0x80
[<fffffc0000715030>] rest_init+0xc0/0xe0
[<fffffc000031001c>] _stext+0x1c/0x20

---[ end trace 5bbac1dc3a0ec32e ]---

A similar dump occurs if you try to reboot using magic-sysrq.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/alpha/kernel/irq.c       | 7 -------
 arch/alpha/kernel/irq_alpha.c | 9 ++++++++-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index 2872acc..7b2be25 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -117,13 +117,6 @@ handle_irq(int irq)
 		return;
 	}
 
-	/*
-	 * From here we must proceed with IPL_MAX. Note that we do not
-	 * explicitly enable interrupts afterwards - some MILO PALcode
-	 * (namely LX164 one) seems to have severe problems with RTI
-	 * at IPL 0.
-	 */
-	local_irq_disable();
 	irq_enter();
 	generic_handle_irq_desc(irq, desc);
 	irq_exit();
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index 772ddfdb..1216dfb 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -45,6 +45,14 @@ do_entInt(unsigned long type, unsigned long vector,
 	  unsigned long la_ptr, struct pt_regs *regs)
 {
 	struct pt_regs *old_regs;
+
+	/*
+	 * Disable interrupts during IRQ handling.
+	 * Note that there is no matching local_irq_enable() due to
+	 * severe problems with RTI at IPL0 and some MILO PALcode
+	 * (namely LX164).
+	 */
+	local_irq_disable();
 	switch (type) {
 	case 0:
 #ifdef CONFIG_SMP
@@ -62,7 +70,6 @@ do_entInt(unsigned long type, unsigned long vector,
 	  {
 		long cpu;
 
-		local_irq_disable();
 		smp_percpu_timer_interrupt(regs);
 		cpu = smp_processor_id();
 		if (cpu != boot_cpuid) {
-- 
1.8.0

