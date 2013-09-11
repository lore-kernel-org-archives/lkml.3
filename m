Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3IKCzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:55:21 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37318 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab3IKCzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:55:17 -0400
Subject: [PATCH V3 6/6] cpuidle/ppc: Nominate new broadcast cpu on hotplug
 of the old
To: benh@kernel.crashing.org, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, galak@kernel.crashing.org,
        fweisbec@gmail.com, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 08:22:26 +0530
Message-ID: <20130911025226.27726.71053.stgit@preeti.in.ibm.com>
In-Reply-To: <20130911024906.27726.4735.stgit@preeti.in.ibm.com>
References: <20130911024906.27726.4735.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091102-5806-0000-0000-000022B1D569
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On hotplug of the broadcast cpu, cancel the hrtimer queued to do
broadcast and nominate a new broadcast cpu to be the first cpu in the
broadcast mask which includes all the cpus that have notified the broadcast
framework about entering deep idle state.

Since the new broadcast cpu is one of the cpus in deep idle, send an ipi to
wake it up to continue the duty of broadcast. The new broadcast cpu needs to
find out if it woke up to resume broadcast. If so it needs to restart the
broadcast hrtimer on itself.

Its possible that the old broadcast cpu was hotplugged out when the broadcast
hrtimer was about to fire on it. Therefore the newly nominated broadcast cpu
should set the broadcast hrtimer on itself to expire immediately so as to not
miss wakeups under such scenarios.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/time.h     |    1 +
 arch/powerpc/kernel/time.c          |    1 +
 drivers/cpuidle/cpuidle-ibm-power.c |   22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 38341fa..3bc0205 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -31,6 +31,7 @@ struct rtc_time;
 extern void to_tm(int tim, struct rtc_time * tm);
 extern void GregorianDay(struct rtc_time *tm);
 extern void decrementer_timer_interrupt(void);
+extern void broadcast_irq_entry(void);
 
 extern void generic_calibrate_decr(void);
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 44a76de..0ac2e11 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -853,6 +853,7 @@ void decrementer_timer_interrupt(void)
 {
 	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
 
+	broadcast_irq_entry();
 	*next_tb = get_tb_or_rtc();
 	__timer_interrupt();
 }
diff --git a/drivers/cpuidle/cpuidle-ibm-power.c b/drivers/cpuidle/cpuidle-ibm-power.c
index ae47a0a..580ea04 100644
--- a/drivers/cpuidle/cpuidle-ibm-power.c
+++ b/drivers/cpuidle/cpuidle-ibm-power.c
@@ -282,6 +282,12 @@ static int longnap_loop(struct cpuidle_device *dev,
 	return index;
 }
 
+void broadcast_irq_entry(void)
+{
+	if (smp_processor_id() == bc_cpu)
+		hrtimer_start(bc_hrtimer, ns_to_ktime(0), HRTIMER_MODE_REL_PINNED);
+}
+
 /*
  * States for dedicated partition case.
  */
@@ -360,6 +366,7 @@ static int power_cpuidle_add_cpu_notifier(struct notifier_block *n,
 			unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
+	unsigned long flags;
 	struct cpuidle_device *dev =
 			per_cpu(cpuidle_devices, hotcpu);
 
@@ -372,6 +379,21 @@ static int power_cpuidle_add_cpu_notifier(struct notifier_block *n,
 			cpuidle_resume_and_unlock();
 			break;
 
+		case CPU_DYING:
+		case CPU_DYING_FROZEN:
+			spin_lock_irqsave(&longnap_idle_lock, flags);
+			if (hotcpu == bc_cpu) {
+				bc_cpu = -1;
+				hrtimer_cancel(bc_hrtimer);
+				if (!cpumask_empty(tick_get_broadcast_oneshot_mask())) {
+					bc_cpu = cpumask_first(
+							tick_get_broadcast_oneshot_mask());
+					arch_send_tick_broadcast(cpumask_of(bc_cpu));
+				}
+			}
+			spin_unlock_irqrestore(&longnap_idle_lock, flags);
+			break;
+
 		case CPU_DEAD:
 		case CPU_DEAD_FROZEN:
 			cpuidle_pause_and_lock();

