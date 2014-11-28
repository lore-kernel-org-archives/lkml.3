Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaK1SY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:26 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:40474 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaK1SYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:22 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 07/30] cputime: Convert kcpustat to nsecs
Date: Fri, 28 Nov 2014 19:23:37 +0100
Message-Id: <1417199040-21044-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel cpu stats are stored in cputime_t which is an architecture
defined type, and hence a bit opaque and requiring accessors and mutators
for any operation.

Converting them to nsecs simplifies the code a little bit.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/s390/appldata/appldata_os.c   | 16 ++++-----
 drivers/cpufreq/cpufreq.c          |  6 ++--
 drivers/cpufreq/cpufreq_governor.c | 14 ++------
 drivers/macintosh/rack-meter.c     |  2 +-
 fs/proc/stat.c                     | 68 +++++++++++++++++++-------------------
 fs/proc/uptime.c                   |  6 ++--
 kernel/sched/cputime.c             | 35 ++++++++++----------
 7 files changed, 69 insertions(+), 78 deletions(-)

diff --git a/arch/s390/appldata/appldata_os.c b/arch/s390/appldata/appldata_os.c
index 69b23b2..08b9e94 100644
--- a/arch/s390/appldata/appldata_os.c
+++ b/arch/s390/appldata/appldata_os.c
@@ -113,21 +113,21 @@ static void appldata_get_os_data(void *data)
 	j = 0;
 	for_each_online_cpu(i) {
 		os_data->os_cpu[j].per_cpu_user =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_USER]);
+			nsecs_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_USER]);
 		os_data->os_cpu[j].per_cpu_nice =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_NICE]);
+			nsecs_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_NICE]);
 		os_data->os_cpu[j].per_cpu_system =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM]);
+			nsecs_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM]);
 		os_data->os_cpu[j].per_cpu_idle =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IDLE]);
+			nsecs_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IDLE]);
 		os_data->os_cpu[j].per_cpu_irq =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IRQ]);
+			nsecs_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IRQ]);
 		os_data->os_cpu[j].per_cpu_softirq =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ]);
+			nsecs_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ]);
 		os_data->os_cpu[j].per_cpu_iowait =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IOWAIT]);
+			nsecs_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IOWAIT]);
 		os_data->os_cpu[j].per_cpu_steal =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_STEAL]);
+			nsecs_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_STEAL]);
 		os_data->os_cpu[j].cpu_id = i;
 		j++;
 	}
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 4473eba..e7df764 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -117,7 +117,7 @@ static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
 	u64 cur_wall_time;
 	u64 busy_time;
 
-	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
+	cur_wall_time = jiffies64_to_nsecs(get_jiffies_64());
 
 	busy_time = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
 	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
@@ -128,9 +128,9 @@ static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
 
 	idle_time = cur_wall_time - busy_time;
 	if (wall)
-		*wall = cputime_to_usecs(cur_wall_time);
+		*wall = div_u64(cur_wall_time, NSEC_PER_USEC);
 
-	return cputime_to_usecs(idle_time);
+	return div_u64(idle_time, NSEC_PER_USEC);
 }
 
 u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy)
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 1b44496..75f9a389 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -92,20 +92,12 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 
 		if (ignore_nice) {
 			u64 cur_nice;
-			unsigned long cur_nice_jiffies;
 
 			cur_nice = kcpustat_cpu(j).cpustat[CPUTIME_NICE] -
-					 cdbs->prev_cpu_nice;
-			/*
-			 * Assumption: nice time between sampling periods will
-			 * be less than 2^32 jiffies for 32 bit sys
-			 */
-			cur_nice_jiffies = (unsigned long)
-					cputime64_to_jiffies64(cur_nice);
+				  cdbs->prev_cpu_nice;
 
-			cdbs->prev_cpu_nice =
-				kcpustat_cpu(j).cpustat[CPUTIME_NICE];
-			idle_time += jiffies_to_usecs(cur_nice_jiffies);
+			cdbs->prev_cpu_nice = kcpustat_cpu(j).cpustat[CPUTIME_NICE];
+			idle_time += div_u64(cur_nice, NSEC_PER_USEC);
 		}
 
 		if (unlikely(!wall_time || wall_time < idle_time))
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index 4192901..6c5fb49 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -91,7 +91,7 @@ static inline cputime64_t get_cpu_idle_time(unsigned int cpu)
 	if (rackmeter_ignore_nice)
 		retval += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
 
-	return retval;
+	return nsecs_to_cputime64(retval);
 }
 
 static void rackmeter_setup_i2s(struct rackmeter *rm)
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index bf2d03f..9726e01 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -21,23 +21,23 @@
 
 #ifdef arch_idle_time
 
-static cputime64_t get_idle_time(int cpu)
+static u64 get_idle_time(int cpu)
 {
-	cputime64_t idle;
+	u64 idle;
 
 	idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
 	if (cpu_online(cpu) && !nr_iowait_cpu(cpu))
-		idle += arch_idle_time(cpu);
+		idle += cputime64_to_nsecs(arch_idle_time(cpu));
 	return idle;
 }
 
-static cputime64_t get_iowait_time(int cpu)
+static u64 get_iowait_time(int cpu)
 {
-	cputime64_t iowait;
+	u64 iowait;
 
 	iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
 	if (cpu_online(cpu) && nr_iowait_cpu(cpu))
-		iowait += arch_idle_time(cpu);
+		iowait += cputime64_to_nsecs(arch_idle_time(cpu));
 	return iowait;
 }
 
@@ -45,32 +45,32 @@ static cputime64_t get_iowait_time(int cpu)
 
 static u64 get_idle_time(int cpu)
 {
-	u64 idle, idle_time = -1ULL;
+	u64 idle, idle_usecs = -1ULL;
 
 	if (cpu_online(cpu))
-		idle_time = get_cpu_idle_time_us(cpu, NULL);
+		idle_usecs = get_cpu_idle_time_us(cpu, NULL);
 
-	if (idle_time == -1ULL)
+	if (idle_usecs == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
 		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
 	else
-		idle = usecs_to_cputime64(idle_time);
+		idle = idle_usecs * NSEC_PER_USEC;
 
 	return idle;
 }
 
 static u64 get_iowait_time(int cpu)
 {
-	u64 iowait, iowait_time = -1ULL;
+	u64 iowait, iowait_usecs = -1ULL;
 
 	if (cpu_online(cpu))
-		iowait_time = get_cpu_iowait_time_us(cpu, NULL);
+		iowait_usecs = get_cpu_iowait_time_us(cpu, NULL);
 
-	if (iowait_time == -1ULL)
+	if (iowait_usecs == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.iowait */
 		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
 	else
-		iowait = usecs_to_cputime64(iowait_time);
+		iowait = iowait_usecs * NSEC_PER_USEC;
 
 	return iowait;
 }
@@ -118,16 +118,16 @@ static int show_stat(struct seq_file *p, void *v)
 	sum += arch_irq_stat();
 
 	seq_puts(p, "cpu ");
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(system));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(idle));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(iowait));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(irq));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(softirq));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
+	seq_put_decimal_ull(p, ' ', nsec_to_clock_t(user));
+	seq_put_decimal_ull(p, ' ', nsec_to_clock_t(nice));
+	seq_put_decimal_ull(p, ' ', nsec_to_clock_t(system));
+	seq_put_decimal_ull(p, ' ', nsec_to_clock_t(idle));
+	seq_put_decimal_ull(p, ' ', nsec_to_clock_t(iowait));
+	seq_put_decimal_ull(p, ' ', nsec_to_clock_t(irq));
+	seq_put_decimal_ull(p, ' ', nsec_to_clock_t(softirq));
+	seq_put_decimal_ull(p, ' ', nsec_to_clock_t(steal));
+	seq_put_decimal_ull(p, ' ', nsec_to_clock_t(guest));
+	seq_put_decimal_ull(p, ' ', nsec_to_clock_t(guest_nice));
 	seq_putc(p, '\n');
 
 	for_each_online_cpu(i) {
@@ -143,16 +143,16 @@ static int show_stat(struct seq_file *p, void *v)
 		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
 		seq_printf(p, "cpu%d", i);
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(system));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(idle));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(iowait));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(irq));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(softirq));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
+		seq_put_decimal_ull(p, ' ', nsec_to_clock_t(user));
+		seq_put_decimal_ull(p, ' ', nsec_to_clock_t(nice));
+		seq_put_decimal_ull(p, ' ', nsec_to_clock_t(system));
+		seq_put_decimal_ull(p, ' ', nsec_to_clock_t(idle));
+		seq_put_decimal_ull(p, ' ', nsec_to_clock_t(iowait));
+		seq_put_decimal_ull(p, ' ', nsec_to_clock_t(irq));
+		seq_put_decimal_ull(p, ' ', nsec_to_clock_t(softirq));
+		seq_put_decimal_ull(p, ' ', nsec_to_clock_t(steal));
+		seq_put_decimal_ull(p, ' ', nsec_to_clock_t(guest));
+		seq_put_decimal_ull(p, ' ', nsec_to_clock_t(guest_nice));
 		seq_putc(p, '\n');
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 33de567..812a7f9 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -11,17 +11,15 @@ static int uptime_proc_show(struct seq_file *m, void *v)
 {
 	struct timespec uptime;
 	struct timespec idle;
-	u64 idletime;
 	u64 nsec;
 	u32 rem;
 	int i;
 
-	idletime = 0;
+	nsec = 0;
 	for_each_possible_cpu(i)
-		idletime += (__force u64) kcpustat_cpu(i).cpustat[CPUTIME_IDLE];
+		nsec += (__force u64) kcpustat_cpu(i).cpustat[CPUTIME_IDLE];
 
 	get_monotonic_boottime(&uptime);
-	nsec = cputime64_to_jiffies64(idletime) * TICK_NSEC;
 	idle.tv_sec = div_u64_rem(nsec, NSEC_PER_SEC, &rem);
 	idle.tv_nsec = rem;
 	seq_printf(m, "%lu.%02lu %lu.%02lu\n",
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 8394b1e..6cfdc2b 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -76,7 +76,7 @@ void irqtime_account_irq(struct task_struct *curr)
 }
 EXPORT_SYMBOL_GPL(irqtime_account_irq);
 
-static int irqtime_account_hi_update(void)
+static int irqtime_account_hi_update(u64 threshold)
 {
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	unsigned long flags;
@@ -85,13 +85,13 @@ static int irqtime_account_hi_update(void)
 
 	local_irq_save(flags);
 	latest_ns = this_cpu_read(cpu_hardirq_time);
-	if (nsecs_to_cputime64(latest_ns) > cpustat[CPUTIME_IRQ])
+	if (latest_ns - cpustat[CPUTIME_IRQ] > threshold)
 		ret = 1;
 	local_irq_restore(flags);
 	return ret;
 }
 
-static int irqtime_account_si_update(void)
+static int irqtime_account_si_update(u64 threshold)
 {
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	unsigned long flags;
@@ -100,7 +100,7 @@ static int irqtime_account_si_update(void)
 
 	local_irq_save(flags);
 	latest_ns = this_cpu_read(cpu_softirq_time);
-	if (nsecs_to_cputime64(latest_ns) > cpustat[CPUTIME_SOFTIRQ])
+	if (latest_ns - cpustat[CPUTIME_SOFTIRQ] > threshold)
 		ret = 1;
 	local_irq_restore(flags);
 	return ret;
@@ -145,7 +145,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	index = (task_nice(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
 
 	/* Add user time to cpustat. */
-	task_group_account_field(p, index, (__force u64) cputime);
+	task_group_account_field(p, index, cputime_to_nsecs(cputime));
 
 	/* Account for user time used */
 	acct_account_cputime(p);
@@ -170,11 +170,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
 	/* Add guest time to cpustat. */
 	if (task_nice(p) > 0) {
-		cpustat[CPUTIME_NICE] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
+		cpustat[CPUTIME_NICE] += cputime_to_nsecs(cputime);
+		cpustat[CPUTIME_GUEST_NICE] += cputime_to_nsecs(cputime);
 	} else {
-		cpustat[CPUTIME_USER] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST] += (__force u64) cputime;
+		cpustat[CPUTIME_USER] += cputime_to_nsecs(cputime);
+		cpustat[CPUTIME_GUEST] += cputime_to_nsecs(cputime);
 	}
 }
 
@@ -195,7 +195,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 	account_group_system_time(p, cputime);
 
 	/* Add system time to cpustat. */
-	task_group_account_field(p, index, (__force u64) cputime);
+	task_group_account_field(p, index, cputime_to_nsecs(cputime));
 
 	/* Account for system time used */
 	acct_account_cputime(p);
@@ -236,7 +236,7 @@ void account_steal_time(cputime_t cputime)
 {
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
-	cpustat[CPUTIME_STEAL] += (__force u64) cputime;
+	cpustat[CPUTIME_STEAL] += cputime_to_nsecs(cputime);
 }
 
 /*
@@ -249,9 +249,9 @@ void account_idle_time(cputime_t cputime)
 	struct rq *rq = this_rq();
 
 	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat[CPUTIME_IOWAIT] += (__force u64) cputime;
+		cpustat[CPUTIME_IOWAIT] += cputime_to_nsecs(cputime);
 	else
-		cpustat[CPUTIME_IDLE] += (__force u64) cputime;
+		cpustat[CPUTIME_IDLE] += cputime_to_nsecs(cputime);
 }
 
 static __always_inline bool steal_account_process_tick(void)
@@ -341,6 +341,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 {
 	cputime_t scaled = cputime_to_scaled(cputime_one_jiffy);
 	u64 cputime = (__force u64) cputime_one_jiffy;
+	u64 nsec = cputime_to_nsecs(cputime); //TODO: make that build time
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	if (steal_account_process_tick())
@@ -349,10 +350,10 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 	cputime *= ticks;
 	scaled *= ticks;
 
-	if (irqtime_account_hi_update()) {
-		cpustat[CPUTIME_IRQ] += cputime;
-	} else if (irqtime_account_si_update()) {
-		cpustat[CPUTIME_SOFTIRQ] += cputime;
+	if (irqtime_account_hi_update(nsec)) {
+		cpustat[CPUTIME_IRQ] += nsec;
+	} else if (irqtime_account_si_update(nsec)) {
+		cpustat[CPUTIME_SOFTIRQ] += nsec;
 	} else if (this_cpu_ksoftirqd() == p) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
-- 
2.1.3

