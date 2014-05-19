Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbaESNI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:08:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59312 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbaESNIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:08:54 -0400
Date: Mon, 19 May 2014 06:07:42 -0700
From: tip-bot for Lai Jiangshan <tipbot@zytor.com>
Message-ID: <tip-b961b5eea6f90e269bfdec7cd0dac98b008ae817@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <53758B12.8060609@cn.fujitsu.com>
References: <53758B12.8060609@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix hotplug vs set_cpus_allowed_ptr()
Git-Commit-ID: b961b5eea6f90e269bfdec7cd0dac98b008ae817
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b961b5eea6f90e269bfdec7cd0dac98b008ae817
Gitweb:     http://git.kernel.org/tip/b961b5eea6f90e269bfdec7cd0dac98b008ae817
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Fri, 16 May 2014 11:50:42 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 21:47:34 +0900

sched: Fix hotplug vs set_cpus_allowed_ptr()

Lai found that:

  WARNING: CPU: 1 PID: 13 at arch/x86/kernel/smp.c:124 native_smp_send_reschedule+0x2d/0x4b()
  ...
  migration_cpu_stop+0x1d/0x22

was caused by set_cpus_allowed_ptr() assuming that cpu_active_mask is
always a sub-set of cpu_online_mask.

This isn't true since 5fbd036b552f ("sched: Cleanup cpu_active
madness").

So set active and online at the same time to avoid this particular
problem.

Fixes: 5fbd036b552f ("sched: Cleanup cpu_active madness")
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/53758B12.8060609@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/cpu.c        | 6 ++++--
 kernel/sched/core.c | 1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index a9e710e..247979a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -726,10 +726,12 @@ void set_cpu_present(unsigned int cpu, bool present)
 
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
index 44e00ab..86f3890 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5076,7 +5076,6 @@ static int sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_STARTING:
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;
