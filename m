Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495AbaFIW6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:58:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755AbaFIWp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael wang <wangyun@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Toshi Kani <toshi.kani@hp.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.10 19/40] sched: Fix hotplug vs. set_cpus_allowed_ptr()
Date: Mon,  9 Jun 2014 15:48:50 -0700
Message-Id: <20140609224839.814100625@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cpu.c        |    6 ++++--
 kernel/sched/core.c |    1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -698,10 +698,12 @@ void set_cpu_present(unsigned int cpu, b
 
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
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5270,7 +5270,6 @@ static int __cpuinit sched_cpu_active(st
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_STARTING:
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;


