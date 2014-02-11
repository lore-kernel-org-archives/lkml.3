Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaBKMTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:19:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaBKMTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:19:37 -0500
Date: Tue, 11 Feb 2014 04:17:42 -0800
From: tip-bot for Nicolas Pitre <tipbot@zytor.com>
Message-ID: <tip-af8cd8ef726f335815233d03b8723e9c52041edd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        olof@lixom.net, torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, lethal@linux-sh.org,
        benh@kernel.crashing.org, linux@arm.linux.org.uk,
        preeti@linux.vnet.ibm.com, nico@linaro.org, rjw@rjwysocki.net,
        tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        olof@lixom.net, torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, lethal@linux-sh.org,
        benh@kernel.crashing.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, nico@linaro.org, tglx@linutronix.de,
        rjw@rjwysocki.net, daniel.lezcano@linaro.org
In-Reply-To: <alpine.LFD.2.11.1401291526320.1652@knanqh.ubzr>
References: <alpine.LFD.2.11.1401291526320.1652@knanqh.ubzr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle:
  Move the cpuidle entry point to the generic idle loop
Git-Commit-ID: af8cd8ef726f335815233d03b8723e9c52041edd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:17:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af8cd8ef726f335815233d03b8723e9c52041edd
Gitweb:     http://git.kernel.org/tip/af8cd8ef726f335815233d03b8723e9c52041edd
Author:     Nicolas Pitre <nicolas.pitre@linaro.org>
AuthorDate: Wed, 29 Jan 2014 15:31:36 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Feb 2014 09:58:20 +0100

sched/idle: Move the cpuidle entry point to the generic idle loop

In order to integrate cpuidle with the scheduler, we must have a better
proximity in the core code with what cpuidle is doing and not delegate
such interaction to arch code.

Architectures implementing arch_cpu_idle() should simply enter
a cheap idle mode in the absence of a proper cpuidle driver.

In both cases i.e. whether it is a cpuidle driver or the default
arch_cpu_idle(), the calling convention expects IRQs to be disabled
on entry and enabled on exit. There is a warning in place already but
let's add a forced IRQ enable here as well.  This will allow for
removing the forced IRQ enable some implementations do locally and
allowing for the warning to trig.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/alpine.LFD.2.11.1401291526320.1652@knanqh.ubzr
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/cpu/idle.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 277f494..b7976a1 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -3,6 +3,7 @@
  */
 #include <linux/sched.h>
 #include <linux/cpu.h>
+#include <linux/cpuidle.h>
 #include <linux/tick.h>
 #include <linux/mm.h>
 #include <linux/stackprotector.h>
@@ -95,8 +96,10 @@ static void cpu_idle_loop(void)
 				if (!current_clr_polling_and_test()) {
 					stop_critical_timings();
 					rcu_idle_enter();
-					arch_cpu_idle();
-					WARN_ON_ONCE(irqs_disabled());
+					if (cpuidle_idle_call())
+						arch_cpu_idle();
+					if (WARN_ON_ONCE(irqs_disabled()))
+						local_irq_enable();
 					rcu_idle_exit();
 					start_critical_timings();
 				} else {
