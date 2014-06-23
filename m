Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaFWJPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:15:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:56207 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875AbaFWJMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:12:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael wang <wangyun@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Toshi Kani <toshi.kani@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 035/111] sched: Fix hotplug vs. set_cpus_allowed_ptr()
Date: Mon, 23 Jun 2014 10:31:10 +0200
Message-Id: <774f680a78bd9ac6ccac097e7826632e506046a9.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6acbfb96976fc3350e30d964acb1dbbdf876d55e upstream.

Lai found that:

  WARNING: CPU: 1 PID: 13 at arch/x86/kernel/smp.c:124 native_smp_send_reschedule+0x2d/0x4b()
  ...
  migration_cpu_stop+0x1d/0x22

was caused by set_cpus_allowed_ptr() assuming that cpu_active_mask is
always a sub-set of cpu_online_mask.

This isn't true since 5fbd036b552f ("sched: Cleanup cpu_active madness").

So set active and online at the same time to avoid this particular
problem.

Fixes: 5fbd036b552f ("sched: Cleanup cpu_active madness")
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Link: http://lkml.kernel.org/r/53758B12.8060609@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/cpu.c        | 6 ++++--
 kernel/sched/core.c | 1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index d7f07a2da5a6..92599d897125 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -695,10 +695,12 @@ void set_cpu_present(unsigned int cpu, bool present)
 
 void set_cpu_online(unsigned int cpu, bool online)
 {
-	if (online)
+	if (online) {
 		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
-	else
+		cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
+	} else {
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+	}
 }
 
 void set_cpu_active(unsigned int cpu, bool active)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a494ace683e3..07039cba59d9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4726,7 +4726,6 @@ static int sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_STARTING:
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;
-- 
2.0.0

