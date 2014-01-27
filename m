Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaA0GZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:25:51 -0500
Received: from relais.videotron.ca ([24.201.245.36]:51663 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbaA0GYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:24:14 -0500
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
Subject: [PATCH 4/9] idle: move the cpuidle entry point to the generic idle loop
Date: Mon, 27 Jan 2014 01:08:19 -0500
Message-id: <1390802904-28399-5-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to integrate cpuidle with the scheduler, we must have a better
proximity in the core code with what cpuidle is doing and not delegate
such interaction to arch code.

Architectures implementing arch_cpu_idle() should simply enter
a cheap idle mode in the absence of a proper cpuidle driver.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 kernel/cpu/idle.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 4e327e211b..a6f40ad9f8 100644
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
@@ -94,7 +95,8 @@ static void cpu_idle_loop(void)
 				if (!current_clr_polling_and_test()) {
 					stop_critical_timings();
 					rcu_idle_enter();
-					arch_cpu_idle();
+					if (cpuidle_idle_call())
+						arch_cpu_idle();
 					WARN_ON_ONCE(irqs_disabled());
 					rcu_idle_exit();
 					start_critical_timings();
-- 
1.8.4.108.g55ea5f6

