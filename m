Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab3C0PdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:33:14 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47422 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3C0PdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:33:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/4] nohz: New option to force all CPUs in full dynticks range
Date: Wed, 27 Mar 2013 16:32:39 +0100
Message-Id: <1364398359-21990-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a new kernel config that forces all CPUs to be part
of the full dynticks range, except the boot one for timekeeping.

This is helpful for those who don't need a finegrained range
of full dynticks CPU and also for automated testing.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/Kconfig      |   10 ++++++++++
 kernel/time/tick-sched.c |    5 +++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 5a87c03..407d771 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -98,6 +98,16 @@ config NO_HZ_EXTENDED
 
 	 Say N.
 
+config NO_HZ_EXTENDED_ALL
+       bool "Full dynticks system on all CPUs"
+       depends on NO_HZ_EXTENDED
+       help
+	 Force all CPUs to be full dynticks. The range specified in the
+	 nohz_extended boot option will then be ignored.
+
+	 Note the boot CPU will still be kept outside the range to handle
+	 the timekeeping duty.
+
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a76d95e..0a3952c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -161,10 +161,15 @@ static int __init tick_nohz_extended_setup(char *str)
 	int cpu;
 
 	alloc_bootmem_cpumask_var(&nohz_extended_mask);
+
+#ifdef CONFIG_NO_HZ_EXTENDED_ALL
+	cpumask_setall(nohz_extended_mask);
+#else
 	if (cpulist_parse(str, nohz_extended_mask) < 0) {
 		pr_warning("NOHZ: Incorrect nohz_extended cpumask\n");
 		return 1;
 	}
+#endif
 
 	cpu = smp_processor_id();
 	if (cpumask_test_cpu(cpu, nohz_extended_mask)) {
-- 
1.7.5.4

