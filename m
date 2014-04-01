Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaDAIoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:44:39 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42238 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaDAIoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:44:34 -0400
Date: Tue, 1 Apr 2014 10:44:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timers/nohz changes for v3.15
Message-ID: <20140401084429.GA23964@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-nohz-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-nohz-for-linus

   # HEAD: 073d8224d299528778e90773becd1e890953443c arch: Remove stub cputime.h headers

The main purpose is to fix a full dynticks bug related to 
virtualization, where steal time accounting appears to be zero in 
/proc/stat even after a few seconds of competing guests running busy 
loops in a same host CPU. It's not a regression though as it was there 
since the beginning.

The other commits are preparatory work to fix the bug and various 
cleanups.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (6):
      cputime: Fix nsecs_to_cputime() return type cast
      cputime: Default implementation of nsecs -> cputime conversion
      cputime: Bring cputime -> nsecs conversion
      cputime: Fix jiffies based cputime assumption on steal accounting
      sched: Remove needless round trip nsecs <-> tick conversion of steal time
      arch: Remove stub cputime.h headers


 arch/alpha/include/asm/Kbuild         |  1 +
 arch/alpha/include/asm/cputime.h      |  6 ------
 arch/cris/include/asm/Kbuild          |  1 +
 arch/cris/include/asm/cputime.h       |  6 ------
 arch/frv/include/asm/Kbuild           |  1 +
 arch/frv/include/asm/cputime.h        |  6 ------
 arch/m32r/include/asm/Kbuild          |  1 +
 arch/m32r/include/asm/cputime.h       |  6 ------
 arch/microblaze/include/asm/Kbuild    |  1 +
 arch/microblaze/include/asm/cputime.h |  1 -
 arch/mn10300/include/asm/Kbuild       |  1 +
 arch/mn10300/include/asm/cputime.h    |  1 -
 arch/score/include/asm/Kbuild         |  1 +
 arch/score/include/asm/cputime.h      |  6 ------
 arch/x86/include/asm/Kbuild           |  1 +
 arch/x86/include/asm/cputime.h        |  1 -
 drivers/cpufreq/cpufreq_stats.c       |  2 +-
 drivers/s390/cio/cio.c                |  2 +-
 fs/proc/stat.c                        |  2 +-
 fs/proc/uptime.c                      |  2 +-
 include/asm-generic/cputime_jiffies.h |  4 +++-
 include/asm-generic/cputime_nsecs.h   |  5 ++++-
 include/linux/cputime.h               | 16 ++++++++++++++++
 include/linux/kernel_stat.h           |  2 +-
 include/linux/sched.h                 |  2 +-
 kernel/sched/core.c                   |  6 ------
 kernel/sched/cputime.c                | 16 +++++++++++-----
 kernel/sched/sched.h                  | 10 ----------
 28 files changed, 48 insertions(+), 62 deletions(-)
 delete mode 100644 arch/alpha/include/asm/cputime.h
 delete mode 100644 arch/cris/include/asm/cputime.h
 delete mode 100644 arch/frv/include/asm/cputime.h
 delete mode 100644 arch/m32r/include/asm/cputime.h
 delete mode 100644 arch/microblaze/include/asm/cputime.h
 delete mode 100644 arch/mn10300/include/asm/cputime.h
 delete mode 100644 arch/score/include/asm/cputime.h
 delete mode 100644 arch/x86/include/asm/cputime.h
 create mode 100644 include/linux/cputime.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index 7736f42..96e54be 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
 generic-y += mcs_spinlock.h
diff --git a/arch/alpha/include/asm/cputime.h b/arch/alpha/include/asm/cputime.h
deleted file mode 100644
index 19577fd..0000000
--- a/arch/alpha/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ALPHA_CPUTIME_H
-#define __ALPHA_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __ALPHA_CPUTIME_H */
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 056027f..afff510 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -5,6 +5,7 @@ header-y += arch-v32/
 
 generic-y += barrier.h
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
 generic-y += kvm_para.h
diff --git a/arch/cris/include/asm/cputime.h b/arch/cris/include/asm/cputime.h
deleted file mode 100644
index 4446a65..0000000
--- a/arch/cris/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __CRIS_CPUTIME_H
-#define __CRIS_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __CRIS_CPUTIME_H */
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index babb933..87b95eb 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -1,5 +1,6 @@
 
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
 generic-y += mcs_spinlock.h
diff --git a/arch/frv/include/asm/cputime.h b/arch/frv/include/asm/cputime.h
deleted file mode 100644
index f6c373a..0000000
--- a/arch/frv/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_CPUTIME_H
-#define _ASM_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* _ASM_CPUTIME_H */
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 5825a35..67779a7 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -1,5 +1,6 @@
 
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
 generic-y += mcs_spinlock.h
diff --git a/arch/m32r/include/asm/cputime.h b/arch/m32r/include/asm/cputime.h
deleted file mode 100644
index 0a47550..0000000
--- a/arch/m32r/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __M32R_CPUTIME_H
-#define __M32R_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __M32R_CPUTIME_H */
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index 1f590ab..c98ed95 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 generic-y += barrier.h
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
 generic-y += mcs_spinlock.h
diff --git a/arch/microblaze/include/asm/cputime.h b/arch/microblaze/include/asm/cputime.h
deleted file mode 100644
index 6d68ad7..0000000
--- a/arch/microblaze/include/asm/cputime.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/cputime.h>
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index cbc6b9b..654d5ba 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 generic-y += barrier.h
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
 generic-y += mcs_spinlock.h
diff --git a/arch/mn10300/include/asm/cputime.h b/arch/mn10300/include/asm/cputime.h
deleted file mode 100644
index 6d68ad7..0000000
--- a/arch/mn10300/include/asm/cputime.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/cputime.h>
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index 4630cf2..2f947ab 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -4,6 +4,7 @@ header-y +=
 
 generic-y += barrier.h
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += hash.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
diff --git a/arch/score/include/asm/cputime.h b/arch/score/include/asm/cputime.h
deleted file mode 100644
index 1fced99..0000000
--- a/arch/score/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_CPUTIME_H
-#define _ASM_SCORE_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* _ASM_SCORE_CPUTIME_H */
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index a8fee07..4acddc4 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -5,4 +5,5 @@ genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
+generic-y += cputime.h
 generic-y += mcs_spinlock.h
diff --git a/arch/x86/include/asm/cputime.h b/arch/x86/include/asm/cputime.h
deleted file mode 100644
index 6d68ad7..0000000
--- a/arch/x86/include/asm/cputime.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/cputime.h>
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 5793e14..79911a2 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -13,7 +13,7 @@
 #include <linux/cpufreq.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <asm/cputime.h>
+#include <linux/cputime.h>
 
 static spinlock_t cpufreq_stats_lock;
 
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 88e35d8..5154513 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -28,7 +28,7 @@
 #include <asm/chpid.h>
 #include <asm/airq.h>
 #include <asm/isc.h>
-#include <asm/cputime.h>
+#include <linux/cputime.h>
 #include <asm/fcx.h>
 #include <asm/nmi.h>
 #include <asm/crw.h>
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 6f599c6..9d231e9 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -9,7 +9,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/irqnr.h>
-#include <asm/cputime.h>
+#include <linux/cputime.h>
 #include <linux/tick.h>
 
 #ifndef arch_irq_stat_cpu
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 7141b8d..33de567 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -5,7 +5,7 @@
 #include <linux/seq_file.h>
 #include <linux/time.h>
 #include <linux/kernel_stat.h>
-#include <asm/cputime.h>
+#include <linux/cputime.h>
 
 static int uptime_proc_show(struct seq_file *m, void *v)
 {
diff --git a/include/asm-generic/cputime_jiffies.h b/include/asm-generic/cputime_jiffies.h
index 272ecba..d5cb78f5 100644
--- a/include/asm-generic/cputime_jiffies.h
+++ b/include/asm-generic/cputime_jiffies.h
@@ -15,8 +15,10 @@ typedef u64 __nocast cputime64_t;
 
 
 /*
- * Convert nanoseconds to cputime
+ * Convert nanoseconds <-> cputime
  */
+#define cputime_to_nsecs(__ct)		\
+	jiffies_to_nsecs(cputime_to_jiffies(__ct))
 #define nsecs_to_cputime64(__nsec)	\
 	jiffies64_to_cputime64(nsecs_to_jiffies64(__nsec))
 #define nsecs_to_cputime(__nsec)	\
diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
index 2c9e62c..4e81760 100644
--- a/include/asm-generic/cputime_nsecs.h
+++ b/include/asm-generic/cputime_nsecs.h
@@ -44,7 +44,10 @@ typedef u64 __nocast cputime64_t;
 /*
  * Convert cputime <-> nanoseconds
  */
-#define nsecs_to_cputime(__nsecs)	((__force u64)(__nsecs))
+#define cputime_to_nsecs(__ct)		\
+	(__force u64)(__ct)
+#define nsecs_to_cputime(__nsecs)	\
+	(__force cputime_t)(__nsecs)
 
 
 /*
diff --git a/include/linux/cputime.h b/include/linux/cputime.h
new file mode 100644
index 0000000..f2eb2ee
--- /dev/null
+++ b/include/linux/cputime.h
@@ -0,0 +1,16 @@
+#ifndef __LINUX_CPUTIME_H
+#define __LINUX_CPUTIME_H
+
+#include <asm/cputime.h>
+
+#ifndef cputime_to_nsecs
+# define cputime_to_nsecs(__ct)	\
+	(cputime_to_usecs(__ct) * NSEC_PER_USEC)
+#endif
+
+#ifndef nsecs_to_cputime
+# define nsecs_to_cputime(__nsecs)	\
+	usecs_to_cputime((__nsecs) / NSEC_PER_USEC)
+#endif
+
+#endif /* __LINUX_CPUTIME_H */
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 51c72be..d7c6131 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -9,7 +9,7 @@
 #include <linux/sched.h>
 #include <linux/vtime.h>
 #include <asm/irq.h>
-#include <asm/cputime.h>
+#include <linux/cputime.h>
 
 /*
  * 'kernel_stat.h' contains the definitions needed for doing
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 68a0e84..1ac566c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -27,7 +27,7 @@ struct sched_param {
 
 #include <asm/page.h>
 #include <asm/ptrace.h>
-#include <asm/cputime.h>
+#include <linux/cputime.h>
 
 #include <linux/smp.h>
 #include <linux/sem.h>
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..b14a188 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -823,19 +823,13 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #endif
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
 	if (static_key_false((&paravirt_steal_rq_enabled))) {
-		u64 st;
-
 		steal = paravirt_steal_clock(cpu_of(rq));
 		steal -= rq->prev_steal_time_rq;
 
 		if (unlikely(steal > delta))
 			steal = delta;
 
-		st = steal_ticks(steal);
-		steal = st * TICK_NSEC;
-
 		rq->prev_steal_time_rq += steal;
-
 		delta -= steal;
 	}
 #endif
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 9994791..c91b097 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -258,16 +258,22 @@ static __always_inline bool steal_account_process_tick(void)
 {
 #ifdef CONFIG_PARAVIRT
 	if (static_key_false(&paravirt_steal_enabled)) {
-		u64 steal, st = 0;
+		u64 steal;
+		cputime_t steal_ct;
 
 		steal = paravirt_steal_clock(smp_processor_id());
 		steal -= this_rq()->prev_steal_time;
 
-		st = steal_ticks(steal);
-		this_rq()->prev_steal_time += st * TICK_NSEC;
+		/*
+		 * cputime_t may be less precise than nsecs (eg: if it's
+		 * based on jiffies). Lets cast the result to cputime
+		 * granularity and account the rest on the next rounds.
+		 */
+		steal_ct = nsecs_to_cputime(steal);
+		this_rq()->prev_steal_time += cputime_to_nsecs(steal_ct);
 
-		account_steal_time(st);
-		return st;
+		account_steal_time(steal_ct);
+		return steal_ct;
 	}
 #endif
 	return false;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c2119fd..5ec9910 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1214,16 +1214,6 @@ extern void update_idle_cpu_load(struct rq *this_rq);
 
 extern void init_task_runnable_average(struct task_struct *p);
 
-#ifdef CONFIG_PARAVIRT
-static inline u64 steal_ticks(u64 steal)
-{
-	if (unlikely(steal > NSEC_PER_SEC))
-		return div_u64(steal, TICK_NSEC);
-
-	return __iter_div_u64_rem(steal, TICK_NSEC, &steal);
-}
-#endif
-
 static inline void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
