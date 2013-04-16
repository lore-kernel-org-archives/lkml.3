Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab3DPP0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:26:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56005 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523Ab3DPP0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:26:30 -0400
From: Chris Redpath <Chris.Redpath@arm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "pjt@google.com" <pjt@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "toddpoynor@google.com" <toddpoynor@google.com>
Date: Tue, 16 Apr 2013 16:25:42 +0100
Subject: [RFC PATCH 1/3] ARM: (Experimental) Provide Estimated CPU Capacity
 measure
Thread-Topic: [RFC PATCH 1/3] ARM: (Experimental) Provide Estimated CPU
 Capacity measure
Thread-Index: Ac46tqjLSFCOaPOaQxOtQwxSu2lKKw==
Message-ID: <BF39C5705592B0469C55326EC158C01A7EC915D1E7@GEORGE.Emea.Arm.com>
References: <cover.1364298828.git.chris.redpath@arm.com>
In-Reply-To: <cover.1364298828.git.chris.redpath@arm.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
MIME-Version: 1.0
X-MC-Unique: 113041616262825101
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3GFQcmD003525

Bsed upon the CPU Power of a core, computes a capacity measure
between 0 and 1024 scaling in line with the frequency using a
simple linear scale derived from the maximum frequency reported
by CPUFreq.

Scaling CPU Power with frequency and estimated capacity gives an
estimate of the amount of potential compute capacity available to
a specific core relative to any other in the system.

Change-Id: I8048a23fe5999536b6325a5ec64549dd69f5a865
---
 arch/arm/Kconfig                  |   16 +++
 arch/arm/include/asm/topology.h   |    7 ++
 arch/arm/kernel/topology.c        |  216 ++++++++++++++++++++++++++++++++++++-
 drivers/base/topology.c           |   18 ++++
 linaro/configs/big-LITTLE-MP.conf |    3 +-
 5 files changed, 258 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 71d5b22..86ea8e8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1624,6 +1624,22 @@ config SCHED_SMT
          MultiThreading at a cost of slightly increased overhead in some
          places. If unsure say N here.

+config ARCH_SCALE_INVARIANT_CPU_CAPACITY
+       bool "Scale-Invariant CPU Compute Capacity Recording (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       depends on CPU_FREQ
+       help
+         Provides a new measure of maximum and instantaneous CPU compute
+         capacity, derived from a table of relative compute performance
+         for each core type present in the system. The table is an
+         estimate and specific core performance may be different for
+         any particular workload. The measure includes the relative
+         performance and a linear scale of current to maximum frequency
+         such that at maximum frequency (as expressed in the DTB) the
+         reported compute capacity will be equal to the estimated
+         performance from the table. Values range between 0 and 1023 where
+         1023 is the highest capacity available in the system.
+
 config HAVE_ARM_SCU
        bool
        help
diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
index 417cf43..3e3c1cd 100644
--- a/arch/arm/include/asm/topology.h
+++ b/arch/arm/include/asm/topology.h
@@ -19,6 +19,13 @@ extern struct cputopo_arm cpu_topology[NR_CPUS];
 #define topology_core_id(cpu)          (cpu_topology[cpu].core_id)
 #define topology_core_cpumask(cpu)     (&cpu_topology[cpu].core_sibling)
 #define topology_thread_cpumask(cpu)   (&cpu_topology[cpu].thread_sibling)
+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+extern unsigned long arch_get_max_cpu_capacity(int);
+extern unsigned long arch_get_cpu_capacity(int);
+
+#define topology_max_cpu_capacity(cpu) (arch_get_max_cpu_capacity(cpu))
+#define topology_cpu_capacity(cpu)     (arch_get_cpu_capacity(cpu))
+#endif

 #define mc_capable()   (cpu_topology[0].socket_id != -1)
 #define smt_capable()  (cpu_topology[0].thread_id != -1)
diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 354e279..8c4650a 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -40,12 +40,65 @@
  * rebalance_domains for all idle cores and the cpu_power can be updated
  * during this sequence.
  */
+
+/* when CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY is in use, a new measure of
+ * compute capacity is available. This is limited to a maximum of 1024 and
+ * scaled between 0 and 1023 according to frequency.
+ * Cores with different base CPU powers are scaled in line with this.
+ * CPU capacity for each core represents a comparable ratio to maximum
+ * achievable core compute capacity for a core in this system.
+ *
+ * e.g.1 If all cores in the system have a base CPU power of 1024 according to
+ * efficiency calculations and are DVFS scalable between 500MHz and 1GHz, the
+ * cores currently at 1GHz will have CPU power of 1024 whilst the cores
+ * currently at 500MHz will have CPU power of 512.
+ *
+ * e.g.2
+ * If core 0 has a base CPU power of 2048 and runs at 500MHz & 1GHz whilst
+ * core 1 has a base CPU power of 1024 and runs at 100MHz and 200MHz, then
+ * the following possibilities are available:
+ *
+ * cpu power\| 1GHz:100Mhz | 1GHz : 200MHz | 500MHz:100MHz | 500MHz:200MHz |
+ * ----------|-------------|---------------|---------------|---------------|
+ *    core 0 |    1024     |     1024      |     512       |     512       |
+ *    core 1 |     256     |      512      |     256       |     512       |
+ *
+ * This information may be useful to the scheduler when load balancing,
+ * so that the compute capacity of the core a task ran on can be baked into
+ * task load histories.
+ */
 static DEFINE_PER_CPU(unsigned long, cpu_scale);
+static DEFINE_PER_CPU(unsigned long, base_cpu_capacity);
+static DEFINE_PER_CPU(unsigned long, invariant_cpu_capacity);
+static DEFINE_PER_CPU(unsigned long, prescaled_cpu_capacity);
+
+static int frequency_invariant_power_enabled = 1;
+
+/* >0=1, <=0=0 */
+void set_invariant_power_enabled(int val)
+{
+       if(val>0)
+               frequency_invariant_power_enabled = 1;
+       else
+               frequency_invariant_power_enabled = 0;
+}

 unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
 {
        return per_cpu(cpu_scale, cpu);
 }
+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+unsigned long arch_get_cpu_capacity(int cpu)
+{
+       return per_cpu(invariant_cpu_capacity, cpu);
+}
+unsigned long arch_get_max_cpu_capacity(int cpu)
+{
+       return per_cpu(base_cpu_capacity, cpu);
+}
+#endif
+
+

 static void set_power_scale(unsigned int cpu, unsigned long power)
 {
@@ -82,7 +135,6 @@ struct cpu_capacity {
 struct cpu_capacity *cpu_capacity;

 unsigned long middle_capacity = 1;
-
 /*
  * Iterate all CPUs' descriptor in DT and compute the efficiency
  * (as per table_efficiency). Also calculate a middle efficiency
@@ -349,3 +401,165 @@ void __init init_cpu_topology(void)

        parse_dt_topology();
 }
+
+
+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+#include <linux/cpufreq.h>
+
+#define CPUPOWER_FREQSCALE_SHIFT 10
+#define CPUPOWER_FREQSCALE_DEFAULT (1L << CPUPOWER_FREQSCALE_SHIFT)
+struct cpufreq_extents {
+       u32 max;
+       u32 flags;
+};
+/* Flag set when the governor in use only allows one frequency.
+ * Disables scaling.
+ */
+#define CPUPOWER_FREQINVAR_SINGLEFREQ 0x01
+static struct cpufreq_extents freq_scale[CONFIG_NR_CPUS];
+
+static unsigned long get_max_cpu_power()
+{
+       unsigned long max_cpu_power = 0;
+       int cpu;
+       for_each_online_cpu(cpu){
+               if( per_cpu(cpu_scale, cpu) > max_cpu_power)
+                       max_cpu_power = per_cpu(cpu_scale, cpu);
+       }
+       return max_cpu_power;
+}
+
+
+/* Called when the CPU Frequency is changed.
+ * Once for each CPU.
+ */
+static int cpufreq_callback(struct notifier_block *nb,
+                                       unsigned long val, void *data)
+{
+       struct cpufreq_freqs *freq = data;
+       int cpu = freq->cpu;
+       struct cpufreq_extents *extents;
+       unsigned int curr_freq;
+
+       if (freq->flags & CPUFREQ_CONST_LOOPS)
+               return NOTIFY_OK;
+
+       if (val != CPUFREQ_POSTCHANGE)
+               return NOTIFY_OK;
+
+       /* if dynamic load scale is disabled, set the load scale to 1.0 */
+       if (!frequency_invariant_power_enabled) {
+               per_cpu(invariant_cpu_capacity, cpu) = per_cpu(base_cpu_capacity, cpu);
+               return NOTIFY_OK;
+       }
+
+       extents = &freq_scale[cpu];
+       /* If our governor was recognised as a single-freq governor,
+        * use curr = max to be sure multiplier is 1.0
+        */
+       if (extents->flags & CPUPOWER_FREQINVAR_SINGLEFREQ)
+               curr_freq = extents->max;
+       else
+               curr_freq = freq->new >> CPUPOWER_FREQSCALE_SHIFT;
+
+       per_cpu(invariant_cpu_capacity, cpu) = (curr_freq *
+               per_cpu(prescaled_cpu_capacity, cpu)) >> CPUPOWER_FREQSCALE_SHIFT;
+       return NOTIFY_OK;
+}
+
+/* Called when the CPUFreq governor is changed.
+ * Only called for the CPUs which are actually changed by the
+ * userspace.
+ */
+static int cpufreq_policy_callback(struct notifier_block *nb,
+                                      unsigned long event, void *data)
+{
+       struct cpufreq_policy *policy = data;
+       struct cpufreq_extents *extents;
+       int cpu, singleFreq = 0, cpu_capacity;
+       static const char performance_governor[] = "performance";
+       static const char powersave_governor[] = "powersave";
+       unsigned long max_cpu_power;
+
+       if (event == CPUFREQ_START)
+               return 0;
+
+       if (event != CPUFREQ_INCOMPATIBLE)
+               return 0;
+
+       /* CPUFreq governors do not accurately report the range of
+        * CPU Frequencies they will choose from.
+        * We recognise performance and powersave governors as
+        * single-frequency only.
+        */
+       if (!strncmp(policy->governor->name, performance_governor,
+                       strlen(performance_governor)) ||
+               !strncmp(policy->governor->name, powersave_governor,
+                               strlen(powersave_governor)))
+               singleFreq = 1;
+
+       max_cpu_power = get_max_cpu_power();
+       /* Make sure that all CPUs impacted by this policy are
+        * updated since we will only get a notification when the
+        * user explicitly changes the policy on a CPU.
+        */
+       for_each_cpu(cpu, policy->cpus) {
+               /* scale cpu_power to max(1024) */
+               cpu_capacity = (per_cpu(cpu_scale, cpu) << CPUPOWER_FREQSCALE_SHIFT)
+                               / max_cpu_power;
+               extents = &freq_scale[cpu];
+               extents->max = policy->max >> CPUPOWER_FREQSCALE_SHIFT;
+               if (!frequency_invariant_power_enabled) {
+                       /* when disabled, invariant_cpu_scale = cpu_scale */
+                       per_cpu(base_cpu_capacity, cpu) = CPUPOWER_FREQSCALE_DEFAULT;
+                       per_cpu(invariant_cpu_capacity, cpu) = CPUPOWER_FREQSCALE_DEFAULT;
+                       /* unused when disabled */
+                       per_cpu(prescaled_cpu_capacity, cpu) = CPUPOWER_FREQSCALE_DEFAULT;
+               } else {
+                       if (singleFreq)
+                               extents->flags |= CPUPOWER_FREQINVAR_SINGLEFREQ;
+                       else
+                               extents->flags &= ~CPUPOWER_FREQINVAR_SINGLEFREQ;
+                       per_cpu(base_cpu_capacity, cpu) = cpu_capacity;
+                       per_cpu(prescaled_cpu_capacity, cpu) = (cpu_capacity << CPUPOWER_FREQSCALE_SHIFT) / extents->max;
+                       per_cpu(invariant_cpu_capacity, cpu) =
+                                       ((policy->cur >> CPUPOWER_FREQSCALE_SHIFT) *
+                                       per_cpu(prescaled_cpu_capacity, cpu)) >> CPUPOWER_FREQSCALE_SHIFT;
+               }
+       }
+       return 0;
+}
+
+static struct notifier_block cpufreq_notifier = {
+       .notifier_call  = cpufreq_callback,
+};
+static struct notifier_block cpufreq_policy_notifier = {
+       .notifier_call  = cpufreq_policy_callback,
+};
+
+static int __init register_topology_cpufreq_notifier(void)
+{
+       int ret;
+
+       /* init safe defaults since there are no policies at registration */
+       for (ret = 0; ret < CONFIG_NR_CPUS; ret++) {
+               /* safe defaults */
+               freq_scale[ret].max = CPUPOWER_FREQSCALE_DEFAULT;
+               per_cpu(base_cpu_capacity, ret) = CPUPOWER_FREQSCALE_DEFAULT;
+               per_cpu(invariant_cpu_capacity, ret) = CPUPOWER_FREQSCALE_DEFAULT;
+               per_cpu(prescaled_cpu_capacity, ret) = CPUPOWER_FREQSCALE_DEFAULT;
+       }
+
+       pr_info("topology: registering cpufreq notifiers for scale-invariant CPU Power\n");
+       ret = cpufreq_register_notifier(&cpufreq_policy_notifier,
+                       CPUFREQ_POLICY_NOTIFIER);
+
+       if (ret != -EINVAL)
+               ret = cpufreq_register_notifier(&cpufreq_notifier,
+                       CPUFREQ_TRANSITION_NOTIFIER);
+
+       return ret;
+}
+
+core_initcall(register_topology_cpufreq_notifier);
+#endif /* CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY */
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index ae989c5..23159ad 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -43,6 +43,13 @@ static ssize_t show_##name(struct device *dev,                       \
        unsigned int cpu = dev->id;                             \
        return sprintf(buf, "%d\n", topology_##name(cpu));      \
 }
+#define define_id_lu_show_func(name)                   \
+static ssize_t show_##name(struct device *dev,                 \
+               struct device_attribute *attr, char *buf)       \
+{                                                              \
+       unsigned int cpu = dev->id;                             \
+       return sprintf(buf, "%lu\n", topology_##name(cpu));     \
+}

 #if defined(topology_thread_cpumask) || defined(topology_core_cpumask) || \
     defined(topology_book_cpumask)
@@ -122,6 +129,13 @@ define_one_ro_named(book_siblings, show_book_cpumask);
 define_one_ro_named(book_siblings_list, show_book_cpumask_list);
 #endif

+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+define_id_lu_show_func(max_cpu_capacity);
+define_one_ro(max_cpu_capacity);
+define_id_lu_show_func(cpu_capacity);
+define_one_ro(cpu_capacity);
+#endif
+
 static struct attribute *default_attrs[] = {
        &dev_attr_physical_package_id.attr,
        &dev_attr_core_id.attr,
@@ -134,6 +148,10 @@ static struct attribute *default_attrs[] = {
        &dev_attr_book_siblings.attr,
        &dev_attr_book_siblings_list.attr,
 #endif
+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+       &dev_attr_max_cpu_capacity.attr,
+       &dev_attr_cpu_capacity.attr,
+#endif
        NULL
 };

diff --git a/linaro/configs/big-LITTLE-MP.conf b/linaro/configs/big-LITTLE-MP.conf
index 8cc2be0..34122aa 100644
--- a/linaro/configs/big-LITTLE-MP.conf
+++ b/linaro/configs/big-LITTLE-MP.conf
@@ -8,6 +8,7 @@ CONFIG_SCHED_HMP=y
 CONFIG_HMP_FAST_CPU_MASK=""
 CONFIG_HMP_SLOW_CPU_MASK=""
 CONFIG_HMP_VARIABLE_SCALE=y
-CONFIG_HMP_FREQUENCY_INVARIANT_SCALE=y
 CONFIG_SCHED_HMP_PRIO_FILTER=y
 CONFIG_SCHED_HMP_PRIO_FILTER_VAL=5
+CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY=y
+
--
1.7.9.5


-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
