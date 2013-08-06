Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3HFRXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:23:54 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40259 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab3HFRXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:23:50 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 02/11] cpufreq: Re-arrange declarations in cpufreq.h
Date: Tue,  6 Aug 2013 22:53:04 +0530
Message-Id: <20d1588e837b3e8483ea129265e13213f1678817.1375809311.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are pretty much mixed up. Although generic headers are present but
definitions/declarations are present outside them too..

This patch just moves stuff up and down to make it look better and consistent.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/cpufreq.h | 373 +++++++++++++++++++++++-------------------------
 1 file changed, 177 insertions(+), 196 deletions(-)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 97627bb..0d3b026 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -17,60 +17,30 @@
 #include <linux/notifier.h>
 #include <linux/sysfs.h>
 
-#define CPUFREQ_NAME_LEN 16
-/* Print length for names. Extra 1 space for accomodating '\n' in prints */
-#define CPUFREQ_NAME_PLEN (CPUFREQ_NAME_LEN + 1)
-
 /*********************************************************************
- *                     CPUFREQ NOTIFIER INTERFACE                    *
+ *                        CPUFREQ INTERFACE                          *
  *********************************************************************/
-
-#define CPUFREQ_TRANSITION_NOTIFIER	(0)
-#define CPUFREQ_POLICY_NOTIFIER		(1)
-
-#ifdef CONFIG_CPU_FREQ
-int cpufreq_register_notifier(struct notifier_block *nb, unsigned int list);
-int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
-extern void disable_cpufreq(void);
-#else		/* CONFIG_CPU_FREQ */
-static inline int cpufreq_register_notifier(struct notifier_block *nb,
-						unsigned int list)
-{
-	return 0;
-}
-static inline int cpufreq_unregister_notifier(struct notifier_block *nb,
-						unsigned int list)
-{
-	return 0;
-}
-static inline void disable_cpufreq(void) { }
-#endif		/* CONFIG_CPU_FREQ */
-
-/* if (cpufreq_driver->target) exists, the ->governor decides what frequency
- * within the limits is used. If (cpufreq_driver->setpolicy> exists, these
- * two generic policies are available:
- */
-
-#define CPUFREQ_POLICY_POWERSAVE	(1)
-#define CPUFREQ_POLICY_PERFORMANCE	(2)
-
-/* Frequency values here are CPU kHz so that hardware which doesn't run
- * with some frequencies can complain without having to guess what per
- * cent / per mille means.
+/*
+ * Frequency values here are CPU kHz
+ *
  * Maximum transition latency is in nanoseconds - if it's unknown,
  * CPUFREQ_ETERNAL shall be used.
  */
 
+#define CPUFREQ_ETERNAL			(-1)
+#define CPUFREQ_NAME_LEN		16
+/* Print length for names. Extra 1 space for accomodating '\n' in prints */
+#define CPUFREQ_NAME_PLEN		(CPUFREQ_NAME_LEN + 1)
+
 struct cpufreq_governor;
 
-/* /sys/devices/system/cpu/cpufreq: entry point for global variables */
-extern struct kobject *cpufreq_global_kobject;
-int cpufreq_get_global_kobject(void);
-void cpufreq_put_global_kobject(void);
-int cpufreq_sysfs_create_file(const struct attribute *attr);
-void cpufreq_sysfs_remove_file(const struct attribute *attr);
+struct cpufreq_freqs {
+	unsigned int cpu;	/* cpu nr */
+	unsigned int old;
+	unsigned int new;
+	u8 flags;		/* flags of cpufreq_driver, see below. */
+};
 
-#define CPUFREQ_ETERNAL			(-1)
 struct cpufreq_cpuinfo {
 	unsigned int		max_freq;
 	unsigned int		min_freq;
@@ -117,111 +87,95 @@ struct cpufreq_policy {
 	int			transition_ongoing; /* Tracks transition status */
 };
 
-#define CPUFREQ_ADJUST			(0)
-#define CPUFREQ_INCOMPATIBLE		(1)
-#define CPUFREQ_NOTIFY			(2)
-#define CPUFREQ_START			(3)
-#define CPUFREQ_UPDATE_POLICY_CPU	(4)
-
 /* Only for ACPI */
 #define CPUFREQ_SHARED_TYPE_NONE (0) /* None */
 #define CPUFREQ_SHARED_TYPE_HW	 (1) /* HW does needed coordination */
 #define CPUFREQ_SHARED_TYPE_ALL	 (2) /* All dependent CPUs should set freq */
 #define CPUFREQ_SHARED_TYPE_ANY	 (3) /* Freq can be set from any dependent CPU*/
 
+struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu);
+void cpufreq_cpu_put(struct cpufreq_policy *data);
+
 static inline bool policy_is_shared(struct cpufreq_policy *policy)
 {
 	return cpumask_weight(policy->cpus) > 1;
 }
 
-/******************** cpufreq transition notifiers *******************/
-
-#define CPUFREQ_PRECHANGE	(0)
-#define CPUFREQ_POSTCHANGE	(1)
-#define CPUFREQ_RESUMECHANGE	(8)
-#define CPUFREQ_SUSPENDCHANGE	(9)
+/* /sys/devices/system/cpu/cpufreq: entry point for global variables */
+extern struct kobject *cpufreq_global_kobject;
+int cpufreq_get_global_kobject(void);
+void cpufreq_put_global_kobject(void);
+int cpufreq_sysfs_create_file(const struct attribute *attr);
+void cpufreq_sysfs_remove_file(const struct attribute *attr);
 
-struct cpufreq_freqs {
-	unsigned int cpu;	/* cpu nr */
-	unsigned int old;
-	unsigned int new;
-	u8 flags;		/* flags of cpufreq_driver, see below. */
-};
+#ifdef CONFIG_CPU_FREQ
+unsigned int cpufreq_get(unsigned int cpu);
+unsigned int cpufreq_quick_get(unsigned int cpu);
+unsigned int cpufreq_quick_get_max(unsigned int cpu);
+void disable_cpufreq(void);
 
-/**
- * cpufreq_scale - "old * mult / div" calculation for large values (32-bit-arch
- * safe)
- * @old:   old value
- * @div:   divisor
- * @mult:  multiplier
- *
- *
- * new = old * mult / div
- */
-static inline unsigned long cpufreq_scale(unsigned long old, u_int div,
-		u_int mult)
+u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy);
+int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
+int cpufreq_update_policy(unsigned int cpu);
+bool have_governor_per_policy(void);
+struct kobject *get_governor_parent_kobj(struct cpufreq_policy *policy);
+#else
+static inline unsigned int cpufreq_get(unsigned int cpu)
 {
-#if BITS_PER_LONG == 32
-
-	u64 result = ((u64) old) * ((u64) mult);
-	do_div(result, div);
-	return (unsigned long) result;
-
-#elif BITS_PER_LONG == 64
-
-	unsigned long result = old * ((u64) mult);
-	result /= div;
-	return result;
-
+	return 0;
+}
+static inline unsigned int cpufreq_quick_get(unsigned int cpu)
+{
+	return 0;
+}
+static inline unsigned int cpufreq_quick_get_max(unsigned int cpu)
+{
+	return 0;
+}
+static inline void disable_cpufreq(void) { }
 #endif
-};
 
 /*********************************************************************
- *                          CPUFREQ GOVERNORS                        *
+ *                      CPUFREQ DRIVER INTERFACE                     *
  *********************************************************************/
 
-#define CPUFREQ_GOV_START	1
-#define CPUFREQ_GOV_STOP	2
-#define CPUFREQ_GOV_LIMITS	3
-#define CPUFREQ_GOV_POLICY_INIT	4
-#define CPUFREQ_GOV_POLICY_EXIT	5
+#define CPUFREQ_RELATION_L 0  /* lowest frequency at or above target */
+#define CPUFREQ_RELATION_H 1  /* highest frequency below or at target */
 
-struct cpufreq_governor {
-	char	name[CPUFREQ_NAME_LEN];
-	int	initialized;
-	int	(*governor)	(struct cpufreq_policy *policy,
-				 unsigned int event);
-	ssize_t	(*show_setspeed)	(struct cpufreq_policy *policy,
-					 char *buf);
-	int	(*store_setspeed)	(struct cpufreq_policy *policy,
-					 unsigned int freq);
-	unsigned int max_transition_latency; /* HW must be able to switch to
-			next freq faster than this value in nano secs or we
-			will fallback to performance governor */
-	struct list_head	governor_list;
-	struct module		*owner;
+struct freq_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct cpufreq_policy *, char *);
+	ssize_t (*store)(struct cpufreq_policy *, const char *, size_t count);
 };
 
-/*
- * Pass a target to the cpufreq driver.
- */
-extern int cpufreq_driver_target(struct cpufreq_policy *policy,
-				 unsigned int target_freq,
-				 unsigned int relation);
-extern int __cpufreq_driver_target(struct cpufreq_policy *policy,
-				   unsigned int target_freq,
-				   unsigned int relation);
-int cpufreq_register_governor(struct cpufreq_governor *governor);
-void cpufreq_unregister_governor(struct cpufreq_governor *governor);
+#define cpufreq_freq_attr_ro(_name)		\
+static struct freq_attr _name =			\
+__ATTR(_name, 0444, show_##_name, NULL)
 
-/*********************************************************************
- *                      CPUFREQ DRIVER INTERFACE                     *
- *********************************************************************/
+#define cpufreq_freq_attr_ro_perm(_name, _perm)	\
+static struct freq_attr _name =			\
+__ATTR(_name, _perm, show_##_name, NULL)
 
-#define CPUFREQ_RELATION_L 0  /* lowest frequency at or above target */
-#define CPUFREQ_RELATION_H 1  /* highest frequency below or at target */
+#define cpufreq_freq_attr_rw(_name)		\
+static struct freq_attr _name =			\
+__ATTR(_name, 0644, show_##_name, store_##_name)
+
+struct global_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct kobject *kobj,
+			struct attribute *attr, char *buf);
+	ssize_t (*store)(struct kobject *a, struct attribute *b,
+			 const char *c, size_t count);
+};
+
+#define define_one_global_ro(_name)		\
+static struct global_attr _name =		\
+__ATTR(_name, 0444, show_##_name, NULL)
+
+#define define_one_global_rw(_name)		\
+static struct global_attr _name =		\
+__ATTR(_name, 0644, show_##_name, store_##_name)
 
-struct freq_attr;
 
 struct cpufreq_driver {
 	struct module		*owner;
@@ -258,7 +212,6 @@ struct cpufreq_driver {
 };
 
 /* flags */
-
 #define CPUFREQ_STICKY		0x01	/* the driver isn't removed even if
 					 * all ->init() calls failed */
 #define CPUFREQ_CONST_LOOPS	0x02	/* loops_per_jiffy or other kernel
@@ -270,8 +223,7 @@ struct cpufreq_driver {
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
 
-void cpufreq_notify_transition(struct cpufreq_policy *policy,
-		struct cpufreq_freqs *freqs, unsigned int state);
+const char *cpufreq_get_current_driver(void);
 
 static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy,
 		unsigned int min, unsigned int max)
@@ -289,87 +241,118 @@ static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy,
 	return;
 }
 
-struct freq_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct cpufreq_policy *, char *);
-	ssize_t (*store)(struct cpufreq_policy *, const char *, size_t count);
-};
-
-#define cpufreq_freq_attr_ro(_name)		\
-static struct freq_attr _name =			\
-__ATTR(_name, 0444, show_##_name, NULL)
-
-#define cpufreq_freq_attr_ro_perm(_name, _perm)	\
-static struct freq_attr _name =			\
-__ATTR(_name, _perm, show_##_name, NULL)
-
-#define cpufreq_freq_attr_rw(_name)		\
-static struct freq_attr _name =			\
-__ATTR(_name, 0644, show_##_name, store_##_name)
+/*********************************************************************
+ *                     CPUFREQ NOTIFIER INTERFACE                    *
+ *********************************************************************/
 
-struct global_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct kobject *kobj,
-			struct attribute *attr, char *buf);
-	ssize_t (*store)(struct kobject *a, struct attribute *b,
-			 const char *c, size_t count);
-};
+#define CPUFREQ_TRANSITION_NOTIFIER	(0)
+#define CPUFREQ_POLICY_NOTIFIER		(1)
 
-#define define_one_global_ro(_name)		\
-static struct global_attr _name =		\
-__ATTR(_name, 0444, show_##_name, NULL)
+/* Transition notifiers */
+#define CPUFREQ_PRECHANGE		(0)
+#define CPUFREQ_POSTCHANGE		(1)
+#define CPUFREQ_RESUMECHANGE		(8)
+#define CPUFREQ_SUSPENDCHANGE		(9)
 
-#define define_one_global_rw(_name)		\
-static struct global_attr _name =		\
-__ATTR(_name, 0644, show_##_name, store_##_name)
+/* Policy Notifiers  */
+#define CPUFREQ_ADJUST			(0)
+#define CPUFREQ_INCOMPATIBLE		(1)
+#define CPUFREQ_NOTIFY			(2)
+#define CPUFREQ_START			(3)
+#define CPUFREQ_UPDATE_POLICY_CPU	(4)
 
-struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu);
-void cpufreq_cpu_put(struct cpufreq_policy *data);
-const char *cpufreq_get_current_driver(void);
+#ifdef CONFIG_CPU_FREQ
+int cpufreq_register_notifier(struct notifier_block *nb, unsigned int list);
+int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
 
-/*********************************************************************
- *                        CPUFREQ 2.6. INTERFACE                     *
- *********************************************************************/
-u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy);
-int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
-int cpufreq_update_policy(unsigned int cpu);
-bool have_governor_per_policy(void);
-struct kobject *get_governor_parent_kobj(struct cpufreq_policy *policy);
+void cpufreq_notify_transition(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs, unsigned int state);
 
-#ifdef CONFIG_CPU_FREQ
-/*
- * query the current CPU frequency (in kHz). If zero, cpufreq couldn't detect it
- */
-unsigned int cpufreq_get(unsigned int cpu);
-#else
-static inline unsigned int cpufreq_get(unsigned int cpu)
+#else /* CONFIG_CPU_FREQ */
+static inline int cpufreq_register_notifier(struct notifier_block *nb,
+						unsigned int list)
 {
 	return 0;
 }
-#endif
-
-/*
- * query the last known CPU freq (in kHz). If zero, cpufreq couldn't detect it
- */
-#ifdef CONFIG_CPU_FREQ
-unsigned int cpufreq_quick_get(unsigned int cpu);
-unsigned int cpufreq_quick_get_max(unsigned int cpu);
-#else
-static inline unsigned int cpufreq_quick_get(unsigned int cpu)
+static inline int cpufreq_unregister_notifier(struct notifier_block *nb,
+						unsigned int list)
 {
 	return 0;
 }
-static inline unsigned int cpufreq_quick_get_max(unsigned int cpu)
+#endif /* !CONFIG_CPU_FREQ */
+
+/**
+ * cpufreq_scale - "old * mult / div" calculation for large values (32-bit-arch
+ * safe)
+ * @old:   old value
+ * @div:   divisor
+ * @mult:  multiplier
+ *
+ *
+ * new = old * mult / div
+ */
+static inline unsigned long cpufreq_scale(unsigned long old, u_int div,
+		u_int mult)
 {
-	return 0;
-}
+#if BITS_PER_LONG == 32
+	u64 result = ((u64) old) * ((u64) mult);
+	do_div(result, div);
+	return (unsigned long) result;
+
+#elif BITS_PER_LONG == 64
+	unsigned long result = old * ((u64) mult);
+	result /= div;
+	return result;
 #endif
+}
 
 /*********************************************************************
- *                       CPUFREQ DEFAULT GOVERNOR                    *
+ *                          CPUFREQ GOVERNORS                        *
  *********************************************************************/
 
 /*
+ * If (cpufreq_driver->target) exists, the ->governor decides what frequency
+ * within the limits is used. If (cpufreq_driver->setpolicy> exists, these
+ * two generic policies are available:
+ */
+#define CPUFREQ_POLICY_POWERSAVE	(1)
+#define CPUFREQ_POLICY_PERFORMANCE	(2)
+
+/* Governor Events */
+#define CPUFREQ_GOV_START	1
+#define CPUFREQ_GOV_STOP	2
+#define CPUFREQ_GOV_LIMITS	3
+#define CPUFREQ_GOV_POLICY_INIT	4
+#define CPUFREQ_GOV_POLICY_EXIT	5
+
+struct cpufreq_governor {
+	char	name[CPUFREQ_NAME_LEN];
+	int	initialized;
+	int	(*governor)	(struct cpufreq_policy *policy,
+				 unsigned int event);
+	ssize_t	(*show_setspeed)	(struct cpufreq_policy *policy,
+					 char *buf);
+	int	(*store_setspeed)	(struct cpufreq_policy *policy,
+					 unsigned int freq);
+	unsigned int max_transition_latency; /* HW must be able to switch to
+			next freq faster than this value in nano secs or we
+			will fallback to performance governor */
+	struct list_head	governor_list;
+	struct module		*owner;
+};
+
+/* Pass a target to the cpufreq driver */
+int cpufreq_driver_target(struct cpufreq_policy *policy,
+				 unsigned int target_freq,
+				 unsigned int relation);
+int __cpufreq_driver_target(struct cpufreq_policy *policy,
+				   unsigned int target_freq,
+				   unsigned int relation);
+int cpufreq_register_governor(struct cpufreq_governor *governor);
+void cpufreq_unregister_governor(struct cpufreq_governor *governor);
+
+/* CPUFREQ DEFAULT GOVERNOR */
+/*
  * Performance governor is fallback governor if any other gov failed to auto
  * load due latency restrictions
  */
@@ -417,18 +400,16 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				   unsigned int relation,
 				   unsigned int *index);
 
-/* the following 3 funtions are for cpufreq core use only */
+void cpufreq_frequency_table_update_policy_cpu(struct cpufreq_policy *policy);
+ssize_t cpufreq_show_cpus(const struct cpumask *mask, char *buf);
+
+/* the following funtion is for cpufreq core use only */
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
 
 /* the following are really really optional */
 extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
-
 void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu);
-void cpufreq_frequency_table_update_policy_cpu(struct cpufreq_policy *policy);
-
 void cpufreq_frequency_table_put_attr(unsigned int cpu);
 
-ssize_t cpufreq_show_cpus(const struct cpumask *mask, char *buf);
-
 #endif /* _LINUX_CPUFREQ_H */
-- 
1.7.12.rc2.18.g61b472e

