Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaFZJPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:15:06 -0400
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:57503 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbaFZJPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:15:04 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <53ABE47E.8030504@jp.fujitsu.com>
Date: Thu, 26 Jun 2014 18:14:38 +0900
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
Subject: [PATCH 6/8] cputime, ppc: update iowait accounting
References: <53ABE28F.6010402@jp.fujitsu.com>
In-Reply-To: <53ABE28F.6010402@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like s390 and ia64, ppc also has VIRT_CPU_ACCOUNTING.
Check "timestamp at end of iowait" for idle/iowait accounting.

Not-Tested-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/powerpc/include/asm/cputime.h |    3 +++
 arch/powerpc/kernel/time.c         |   21 +++++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index 607559a..f33a801 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -230,6 +230,9 @@ static inline cputime_t clock_t_to_cputime(const unsigned long clk)
 
 static inline void arch_vtime_task_switch(struct task_struct *tsk) { }
 
+void ppc_record_iowait_exit(int cpu);
+#define arch_record_iowait_exit(cpu) ppc_record_iowait_exit(cpu)
+
 #endif /* __KERNEL__ */
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 #endif /* __POWERPC_CPUTIME_H */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 9fff9cd..879d97a 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -293,7 +293,7 @@ static inline u64 calculate_stolen_time(u64 stop_tb)
  * or soft irq state.
  */
 static u64 vtime_delta(struct task_struct *tsk,
-			u64 *sys_scaled, u64 *stolen)
+			u64 *sys_scaled, u64 *stolen, u64 *stamp)
 {
 	u64 now, nowscaled, deltascaled;
 	u64 udelta, delta, user_scaled;
@@ -336,6 +336,9 @@ static u64 vtime_delta(struct task_struct *tsk,
 	}
 	get_paca()->user_time_scaled += user_scaled;
 
+	if (stamp)
+		*stamp = now;
+
 	return delta;
 }
 
@@ -343,19 +346,29 @@ void vtime_account_system(struct task_struct *tsk)
 {
 	u64 delta, sys_scaled, stolen;
 
-	delta = vtime_delta(tsk, &sys_scaled, &stolen);
+	delta = vtime_delta(tsk, &sys_scaled, &stolen, NULL);
 	account_system_time(tsk, 0, delta, sys_scaled);
 	if (stolen)
 		account_steal_time(stolen);
 }
 EXPORT_SYMBOL_GPL(vtime_account_system);
 
+DEFINE_PER_CPU(u64, vtime_iowait_exit);
+
+void ppc_record_iowait_exit(int cpu)
+{
+	per_cpu(vtime_iowait_exit, cpu) = mftb();
+}
+
 void vtime_account_idle(struct task_struct *tsk)
 {
 	u64 delta, sys_scaled, stolen;
+	u64 now;
 
-	delta = vtime_delta(tsk, &sys_scaled, &stolen);
-	account_idle_time(delta + stolen);
+	delta = vtime_delta(tsk, &sys_scaled, &stolen, &now);
+	delta += stolen;
+	account_idle_and_iowait(0, delta + per_cpu_var(vtime_iowait_exit) - now,
+				delta);
 }
 
 /*
-- 
1.7.1


