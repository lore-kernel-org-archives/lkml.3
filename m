Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbaFZJNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:13:31 -0400
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:37906 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbaFZJNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:13:30 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <53ABE422.1000000@jp.fujitsu.com>
Date: Thu, 26 Jun 2014 18:13:06 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 5/8] cputime, ia64: update iowait accounting
References: <53ABE28F.6010402@jp.fujitsu.com>
In-Reply-To: <53ABE28F.6010402@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using VIRT_CPU_ACCOUNTING, ia64 utilize "timestamp at end of iowait"
like s390.

Not-Tested-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/ia64/include/asm/cputime.h |    2 +
 arch/ia64/kernel/time.c         |   43 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/cputime.h b/arch/ia64/include/asm/cputime.h
index e2d3f5b..6089cbd 100644
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -24,6 +24,8 @@
 # include <asm/processor.h>
 # include <asm-generic/cputime_nsecs.h>
 extern void arch_vtime_task_switch(struct task_struct *tsk);
+extern void ia64_record_iowait_exit(int cpu);
+# define arch_record_iowait_exit(cpu) ia64_record_iowait_exit(cpu)
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 #endif /* __IA64_CPUTIME_H */
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 71c52bc..37c907d 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -138,9 +138,50 @@ void vtime_account_system(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(vtime_account_system);
 
+/*
+ * Nasty trick to account iowait time as defined
+ */
+DEFINE_PER_CPU(u64, ia64_iowait_exit);
+
+void ia64_record_iowait_exit(int cpu)
+{
+	/* FIXME: ITC might not synchronized between cpus/sockets */
+        per_cpu(ia64_iowait_exit, cpu) = ia64_get_itc();
+}
+
 void vtime_account_idle(struct task_struct *tsk)
 {
-	account_idle_time(vtime_delta(tsk));
+	struct thread_info *ti = task_thread_info(tsk);
+	cputime_t delta_stime, iowait_time;
+	__u64 now;
+
+	WARN_ON_ONCE(!irqs_disabled());
+
+	now = ia64_get_itc();
+
+	/*
+	 * tsk must be idle process: its runtime is accumulated as system time
+	 * (ac_utime must be 0) so convert it to idle time for accounting.
+	 *
+	 * in cycles:
+	 *		              iowait_exit
+	 *  (idle_enter)              |   ac_stamp   now(=idle_exit)
+	 * -------+-------------------*------+------->
+	 *         <------- ac_stime ------->
+	 *
+	 * in cputime:
+	 *       (0)
+	 * -------+-------------------*------+------->
+	 *         <----------- delta_stime --------->
+	 *         <-- iowait_time -->
+	 */
+	delta_stime = cycle_to_cputime(ti->ac_stime + (now - ti->ac_stamp));
+	iowait_time = cycle_to_cputime(ti->ac_stime +
+			__ia64_per_cpu_var(ia64_iowait_exit) - ti->ac_stamp);
+	ti->ac_stime = 0;
+	ti->ac_stamp = now;
+
+	account_idle_and_iowait(0, iowait_time, delta_stime);
 }
 
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
-- 
1.7.1


