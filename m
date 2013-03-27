Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3C0PdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:33:04 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:62734 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3C0Pc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:32:59 -0400
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
Subject: [PATCH 2/4] nohz: Print final full dynticks CPUs range on boot
Date: Wed, 27 Mar 2013 16:32:37 +0100
Message-Id: <1364398359-21990-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that we are applying a few restrictions on the
full dynticks CPUs range (boot CPU excluded, then
soon the RCU nocb subset requirement), let's print
the final resulting range of full dynticks CPUs to
the user so that he knows what's really going to run.

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
 kernel/time/tick-sched.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 74bc7f1..1eb0e35 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -196,12 +196,24 @@ static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
+/*
+ * Worst case string length in chunks of CPU range seems 2 steps
+ * separations: 0,2,4,6,...
+ * This is NR_CPUS + sizeof('\0')
+ */
+static char __initdata nohz_ext_buf[NR_CPUS + 1];
+
 static int __init init_tick_nohz_extended(void)
 {
 	int cpu;
 
-	if (have_nohz_extended_mask)
-		cpu_notifier(tick_nohz_cpu_down_callback, 0);
+	if (!have_nohz_extended_mask)
+		return 0;
+
+	cpu_notifier(tick_nohz_cpu_down_callback, 0);
+
+	cpulist_scnprintf(nohz_ext_buf, sizeof(nohz_ext_buf), nohz_extended_mask);
+	pr_info("NO_HZ: Experimental full dynticks CPUs: %s.\n", nohz_ext_buf);
 
 	return 0;
 }
-- 
1.7.5.4

