Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3K2KrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:47:01 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:52791 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3K2Kq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:46:58 -0500
Subject: [PATCH V4 8/9] cpuidle/ppc: Nominate new broadcast cpu on hotplug
 of the old
To: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, galak@kernel.crashing.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Fri, 29 Nov 2013 16:13:35 +0530
Message-ID: <20131129104335.651.56689.stgit@preeti.in.ibm.com>
In-Reply-To: <20131129104010.651.23117.stgit@preeti.in.ibm.com>
References: <20131129104010.651.23117.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112910-1344-0000-0000-0000039F1EFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On hotplug of the broadcast cpu, cancel the hrtimer queued to do
broadcast and nominate a new broadcast cpu.

We choose the new broadcast cpu as one of the cpus in deep idle and thus
send an ipi to wake it up to continue the duty of broadcast. The new
broadcast cpu needs to find out if it woke up to resume broadcast.
If so it needs to restart the broadcast hrtimer on itself.

Its possible that the old broadcast cpu was hotplugged out when the broadcast
hrtimer was about to fire on it. Therefore the newly nominated broadcast cpu
should set the broadcast hrtimer on itself to expire immediately so as to not
miss wakeups under such scenarios.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/time.h          |    1 +
 arch/powerpc/kernel/time.c               |    1 +
 drivers/cpuidle/cpuidle-powerpc-book3s.c |   22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index a6604b7..e24ebb4 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -31,6 +31,7 @@ struct rtc_time;
 extern void to_tm(int tim, struct rtc_time * tm);
 extern void GregorianDay(struct rtc_time *tm);
 extern void tick_broadcast_ipi_handler(void);
+extern void broadcast_irq_entry(void);
 
 extern void generic_calibrate_decr(void);
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index f0603a0..021a5c5 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -852,6 +852,7 @@ void tick_broadcast_ipi_handler(void)
 {
 	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
 
+	broadcast_irq_entry();
 	*next_tb = get_tb_or_rtc();
 	__timer_interrupt();
 }
diff --git a/drivers/cpuidle/cpuidle-powerpc-book3s.c b/drivers/cpuidle/cpuidle-powerpc-book3s.c
index 649c330..59cd529 100644
--- a/drivers/cpuidle/cpuidle-powerpc-book3s.c
+++ b/drivers/cpuidle/cpuidle-powerpc-book3s.c
@@ -288,6 +288,12 @@ static int fastsleep_loop(struct cpuidle_device *dev,
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
@@ -366,6 +372,7 @@ static int powerpc_book3s_cpuidle_add_cpu_notifier(struct notifier_block *n,
 			unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
+	unsigned long flags;
 	struct cpuidle_device *dev =
 			per_cpu(cpuidle_devices, hotcpu);
 
@@ -378,6 +385,21 @@ static int powerpc_book3s_cpuidle_add_cpu_notifier(struct notifier_block *n,
 			cpuidle_resume_and_unlock();
 			break;
 
+		case CPU_DYING:
+		case CPU_DYING_FROZEN:
+			spin_lock_irqsave(&fastsleep_idle_lock, flags);
+			if (hotcpu == bc_cpu) {
+				bc_cpu = -1;
+				hrtimer_cancel(bc_hrtimer);
+				if (!cpumask_empty(tick_get_broadcast_oneshot_mask())) {
+					bc_cpu = cpumask_first(
+							tick_get_broadcast_oneshot_mask());
+					tick_broadcast(cpumask_of(bc_cpu));
+				}
+			}
+			spin_unlock_irqrestore(&fastsleep_idle_lock, flags);
+			break;
+
 		case CPU_DEAD:
 		case CPU_DEAD_FROZEN:
 			cpuidle_pause_and_lock();

