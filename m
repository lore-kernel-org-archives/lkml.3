Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaETOMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:12:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38814 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaETOMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:12:02 -0400
From: Javi Merino <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Punit.Agrawal@arm.com, Javi Merino <javi.merino@arm.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Punit Agrawal <punit.agrawal@arm.com>
Subject: [RFC PATCH v2 5/7] thermal: add a basic cpu power actor
Date: Tue, 20 May 2014 15:10:55 +0100
Message-Id: <1400595057-8585-6-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400595057-8585-1-git-send-email-javi.merino@arm.com>
References: <1400595057-8585-1-git-send-email-javi.merino@arm.com>
X-OriginalArrivalTime: 20 May 2014 14:12:00.0255 (UTC) FILETIME=[7769E0F0:01CF7435]
X-MC-Unique: 114052015120009101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4KECL3q012790

Introduce a power actor for cpus.  It has a basic power model to get
the current power utilization and uses cpufreq cooling devices to set
the desired power.  It uses the current frequency (as reported by
cpufreq) as well as load and OPPs for the power calculations.  The
cpus must have registered their OPPs in the OPP library.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 Documentation/thermal/power_actor.txt     |   46 ++++
 drivers/thermal/Kconfig                   |    5 +
 drivers/thermal/power_actor/Kconfig       |    9 +
 drivers/thermal/power_actor/Makefile      |    2 +
 drivers/thermal/power_actor/cpu_actor.c   |  419 +++++++++++++++++++++++++++++
 drivers/thermal/power_actor/power_actor.h |   23 ++
 6 files changed, 504 insertions(+)
 create mode 100644 drivers/thermal/power_actor/Kconfig
 create mode 100644 drivers/thermal/power_actor/cpu_actor.c

diff --git a/Documentation/thermal/power_actor.txt b/Documentation/thermal/power_actor.txt
index a0f06e091907..d74909376610 100644
--- a/Documentation/thermal/power_actor.txt
+++ b/Documentation/thermal/power_actor.txt
@@ -27,3 +27,49 @@ Callbacks
 milliwatts.
 
 Returns 0 on success, -E* on error.
+
+CPU Power Actor API
+===================
+A simple power model for CPUs.  The current power is calculated as
+dynamic power.  The dynamic power consumption of a processor depends
+on many factors.  For a given processor implementation the primary
+factors are:
+
+- The time the processor spends running, consuming dynamic power, as
+  compared to the time in idle states where dynamic consumption is
+  negligible.  Herein we refer to this as 'utilisation'.
+- The voltage and frequency levels as a result of DVFS.  The DVFS
+  level is a dominant factor governing power consumption.
+- In running time the 'execution' behaviour (instruction types, memory
+  access patterns and so forth) causes, in most cases, a second order
+  variation.  In pathological cases this variation can be significant,
+  but typically it is of a much lesser impact than the factors above.
+
+A high level dynamic power consumption model may then be represented as:
+
+Pdyn = f(run) * Voltage^2 * Frequency * Utilisation
+
+f(run) here represents the described execution behaviour and its
+result has a units of Watts/Hz/Volt^2 (this often expressed in
+mW/MHz/uVolt^2)
+
+The detailed behaviour for f(run) could be modelled on-line.  However,
+in practice, such an on-line model has dependencies on a number of
+implementation specific processor support and characterisation
+factors.  Therefore, in initial implementation that contribution is
+represented as a constant coefficient.  This is a simplification
+consistent with the relative contribution to overall power variation.
+
+In this simplified representation our model becomes:
+
+Pdyn = Kd * Voltage^2 * Frequency * Utilisation
+
+Where Kd (capacitance) represents an indicative running time dynamic
+power coefficient in fundamental units of mW/MHz/uVolt^2
+
+This power model requires that the operating-points of the CPUs are
+registered using the kernel's opp library and the
+`cpufreq_frequency_table` is assigned to the `struct device` of the
+cpu.  If you are using the `cpufreq-cpu0.c` driver then the
+`cpufreq_frequency_table` should already be assigned to the cpu
+device.
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 47e2f15537ca..1818c4fa60b8 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -92,6 +92,11 @@ config THERMAL_GOV_USER_SPACE
 config THERMAL_POWER_ACTOR
 	bool
 
+menu "Power actors"
+depends on THERMAL_POWER_ACTOR
+source "drivers/thermal/power_actor/Kconfig"
+endmenu
+
 config CPU_THERMAL
 	bool "generic cpu cooling support"
 	depends on CPU_FREQ
diff --git a/drivers/thermal/power_actor/Kconfig b/drivers/thermal/power_actor/Kconfig
new file mode 100644
index 000000000000..fa542ca99cdb
--- /dev/null
+++ b/drivers/thermal/power_actor/Kconfig
@@ -0,0 +1,9 @@
+#
+# Thermal power actor configuration
+#
+
+config THERMAL_POWER_ACTOR_CPU
+	bool
+	prompt "Simple power model for a CPU"
+	help
+	  A simple CPU power model
diff --git a/drivers/thermal/power_actor/Makefile b/drivers/thermal/power_actor/Makefile
index 46478f4928be..6f04b92997e6 100644
--- a/drivers/thermal/power_actor/Makefile
+++ b/drivers/thermal/power_actor/Makefile
@@ -3,3 +3,5 @@
 #
 
 obj-y += power_actor.o
+
+obj-$(CONFIG_THERMAL_POWER_ACTOR_CPU) += cpu_actor.o
diff --git a/drivers/thermal/power_actor/cpu_actor.c b/drivers/thermal/power_actor/cpu_actor.c
new file mode 100644
index 000000000000..0d76d52609fa
--- /dev/null
+++ b/drivers/thermal/power_actor/cpu_actor.c
@@ -0,0 +1,419 @@
+/*
+ * A basic cpu actor
+ *
+ * Copyright (C) 2014 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) "CPU actor: " fmt
+
+#include <linux/cpu.h>
+#include <linux/cpufreq.h>
+#include <linux/cpumask.h>
+#include <linux/cpu_cooling.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/pm_opp.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+
+#include "power_actor.h"
+
+/**
+ * struct power_table - frequency to power conversion
+ * @frequency:	frequency in KHz
+ * @power:	power in mW
+ *
+ * This structure is built when the cooling device registers and helps
+ * in translating frequency to power and viceversa.
+ */
+struct power_table {
+	u32 frequency;
+	u32 power;
+};
+
+/**
+ * struct cpu_actor - information for each cpu actor
+ * @cpumask:	cpus covered by this actor
+ * @freq:	frequency in KHz of the cpus represented by the cooling device
+ * @last_load: load measured by the latest call to cpu_get_req_power()
+ * @capacitance: the dynamic power coefficient of these cpus
+ * @time_in_idle: previous reading of the absolute time that this cpu was idle
+ * @time_in_idle_timestamp: wall time of the last invocation of
+ *	get_cpu_idle_time_us()
+ * @power_table: array of struct power_table for frequency to power conversion
+ * @power_table_entries: number of entries in the @power_table array
+ * @cdev:	cpufreq cooling device associated with this actor
+ */
+struct cpu_actor {
+	cpumask_t cpumask;
+	u32 freq;
+	u32 last_load;
+	u32 capacitance;
+	u64 time_in_idle[NR_CPUS];
+	u64 time_in_idle_timestamp[NR_CPUS];
+	struct power_table *power_table;
+	int power_table_entries;
+	struct thermal_cooling_device *cdev;
+};
+
+static DEFINE_MUTEX(cpu_power_actor_lock);
+
+static unsigned int cpu_power_actors_registered;
+
+static u32 cpu_freq_to_power(struct cpu_actor *cpu_actor, u32 freq)
+{
+	int i;
+	struct power_table *pt = cpu_actor->power_table;
+
+	for (i = 0; i < cpu_actor->power_table_entries - 1; i++)
+		if (freq <= pt[i].frequency)
+			break;
+
+	return pt[i].power;
+}
+
+static u32 cpu_power_to_freq(struct cpu_actor *cpu_actor, u32 power)
+{
+	int i;
+	struct power_table *pt = cpu_actor->power_table;
+
+	for (i = 0; i < cpu_actor->power_table_entries - 1; i++)
+		if (power <= pt[i].power)
+			break;
+
+	return pt[i].frequency;
+}
+
+/**
+ * get_load - get load for a cpu since last updated
+ * @cpu_actor: struct cpu_actor for this actor
+ * @cpu: cpu number
+ *
+ * Return the average load of cpu @cpu in percentage since this
+ * function was last called.
+ */
+static u32 get_load(struct cpu_actor *cpu_actor, int cpu)
+{
+	u32 load;
+	u64 now, now_idle, delta_time, delta_idle;
+
+	now_idle = get_cpu_idle_time(cpu, &now, 0);
+	delta_idle = now_idle - cpu_actor->time_in_idle[cpu];
+	delta_time = now - cpu_actor->time_in_idle_timestamp[cpu];
+
+	if (delta_time <= delta_idle)
+		load = 0;
+	else
+		load = div64_u64(100 * (delta_time - delta_idle), delta_time);
+
+	cpu_actor->time_in_idle[cpu] = now_idle;
+	cpu_actor->time_in_idle_timestamp[cpu] = now;
+
+	return load;
+}
+
+/**
+ * cpu_get_req_power - get the current power
+ * @actor: power actor pointer
+ *
+ * Callback for the power actor to return the current power
+ * consumption in milliwatts.
+ */
+static u32 cpu_get_req_power(struct power_actor *actor)
+{
+	int cpu;
+	u32 power = 0, raw_cpu_power, total_load = 0;
+	struct cpu_actor *cpu_actor = actor->data;
+
+	raw_cpu_power = cpu_freq_to_power(cpu_actor, cpu_actor->freq);
+
+	for_each_cpu(cpu, &cpu_actor->cpumask) {
+		u32 load;
+
+		if (!cpu_online(cpu))
+			continue;
+
+		load = get_load(cpu_actor, cpu);
+		power += (raw_cpu_power * load) / 100;
+		total_load += load;
+	}
+
+	cpu_actor->last_load = total_load;
+
+	return power;
+}
+
+/**
+ * cpu_set_power - set cpufreq cooling device to consume a certain power
+ * @actor: power actor pointer
+ * @power: the power in milliwatts that should be set
+ *
+ * Callback for the power actor to configure the power consumption of
+ * the CPU to be @power milliwatts at most.  This function assumes
+ * that the load will remain constant.  The power is translated into a
+ * cooling state that the cpu cooling device then sets.
+ *
+ * Returns 0 on success, -EINVAL if it couldn't convert the frequency
+ * to a cpufreq cooling device state.
+ */
+static int cpu_set_power(struct power_actor *actor, u32 power)
+{
+	unsigned int cpu, freq;
+	unsigned long cdev_state;
+	u32 normalised_power, last_load;
+	struct thermal_cooling_device *cdev;
+	struct cpu_actor *cpu_actor = actor->data;
+
+	cdev = cpu_actor->cdev;
+	cpu = cpumask_any(&cpu_actor->cpumask);
+	last_load = cpu_actor->last_load ? cpu_actor->last_load : 1;
+	normalised_power = (power * 100) / last_load;
+	freq = cpu_power_to_freq(cpu_actor, normalised_power);
+
+	cdev_state = cpufreq_cooling_get_level(cpu, freq);
+	if (cdev_state == THERMAL_CSTATE_INVALID) {
+		pr_err("Failed to convert %dKHz for cpu %d into a cdev state\n",
+			freq, cpu);
+		return -EINVAL;
+	}
+
+	return cdev->ops->set_cur_state(cdev, cdev_state);
+}
+
+static struct power_actor_ops cpu_actor_ops = {
+	.get_req_power = cpu_get_req_power,
+	.set_power = cpu_set_power,
+};
+
+/**
+ * cpufreq_frequency_change - notifier callback for cpufreq frequency changes
+ * @nb:		struct notifier_block * with callback info
+ * @event:	value showing cpufreq event for which this function invoked
+ * @data:	callback-specific data
+ *
+ * Callback to get notifications of frequency changes.  In the
+ * CPUFREQ_POSTCHANGE @event we store the new frequency so that
+ * cpufreq_get_cur() knows the current frequency and can convert it
+ * into power.
+ */
+static int cpufreq_frequency_change(struct notifier_block *nb,
+				unsigned long event, void *data)
+{
+	struct power_actor *actor;
+	struct cpufreq_freqs *freqs = data;
+
+	/* Only update frequency on postchange */
+	if (event != CPUFREQ_POSTCHANGE)
+		return NOTIFY_OK;
+
+	list_for_each_entry(actor, &actor_list, actor_node) {
+		struct cpu_actor *cpu_actor;
+
+		if (actor->type != POWER_ACTOR_CPU)
+			continue;
+
+		cpu_actor = actor->data;
+
+		if (cpumask_test_cpu(freqs->cpu, &cpu_actor->cpumask))
+			cpu_actor->freq = freqs->new;
+	}
+
+	return NOTIFY_OK;
+}
+
+struct notifier_block cpufreq_transition_notifier = {
+	.notifier_call = cpufreq_frequency_change,
+};
+
+/**
+ * build_cpu_power_table - create a power to frequency table
+ * @cpu_actor:	the cpu_actor in which to store the table
+ *
+ * Build a power to frequency table for this cpu and store it in
+ * @cpu_actor.  This table will be used in cpu_power_to_freq() and
+ * cpu_freq_to_power() to convert between power and frequency
+ * efficiently.  Power is stored in mW, frequency in KHz.  The
+ * resulting table is in ascending order.
+ *
+ * Returns 0 on success, -E* on error.
+ */
+static int build_cpu_power_table(struct cpu_actor *cpu_actor)
+{
+	struct power_table *power_table;
+	struct dev_pm_opp *opp;
+	struct device *dev = NULL;
+	int num_opps, cpu, i, ret = 0;
+	unsigned long freq;
+
+	num_opps = 0;
+
+	rcu_read_lock();
+
+	for_each_cpu(cpu, &cpu_actor->cpumask) {
+		dev = get_cpu_device(cpu);
+		if (!dev)
+			continue;
+
+		num_opps = dev_pm_opp_get_opp_count(dev);
+		if (num_opps > 0) {
+			break;
+		} else if (num_opps < 0) {
+			ret = num_opps;
+			goto unlock;
+		}
+	}
+
+	if (num_opps == 0) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	power_table = kcalloc(num_opps, sizeof(*power_table), GFP_KERNEL);
+
+	i = 0;
+	for (freq = 0;
+	     opp = dev_pm_opp_find_freq_ceil(dev, &freq), !IS_ERR(opp);
+	     freq++) {
+		u32 freq_mhz, voltage_mv;
+		u64 power;
+
+		freq_mhz = freq / 1000000;
+		voltage_mv = dev_pm_opp_get_voltage(opp) / 1000;
+
+		/*
+		 * Do the multiplication with MHz and millivolt so as
+		 * to not overflow.
+		 */
+		power = (u64)cpu_actor->capacitance * freq_mhz *
+			voltage_mv * voltage_mv;
+		do_div(power, 1000000000);
+
+		/* frequency is stored in power_table in KHz */
+		power_table[i].frequency = freq / 1000;
+		power_table[i].power = power;
+
+		i++;
+	}
+
+	if (i == 0) {
+		ret = PTR_ERR(opp);
+		goto unlock;
+	}
+
+	cpu_actor->power_table = power_table;
+	cpu_actor->power_table_entries = i;
+
+unlock:
+	rcu_read_unlock();
+	return ret;
+}
+
+/**
+ * power_cpu_actor_register - register a cpu_actor within the power actor API
+ * @cpu_mask:	cpumask of cpus covered by this power_actor
+ * @cdev:	cpufreq cooling device associated with this actor
+ * @capacitance: dynamic power coefficient for these cpus
+ *
+ * Register the cpus in @cpumask with the power actor API using a
+ * simple cpu power model.  The cpus must have registered their OPPs
+ * in the OPP library.
+ *
+ * Return the power_actor created on success or the corresponding
+ * ERR_PTR() on failure.  This actor should be freed with
+ * power_cpu_actor_unregister() when it's no longer needed.
+ */
+struct power_actor *power_cpu_actor_register(cpumask_t *cpumask,
+					struct thermal_cooling_device *cdev,
+					u32 capacitance)
+{
+	int ret;
+	struct power_actor *actor, *err_ret;
+	struct cpu_actor *cpu_actor;
+	u32 cpu_max_power;
+	unsigned int last_entry;
+
+	cpu_actor = kzalloc(sizeof(*cpu_actor), GFP_KERNEL);
+	if (!cpu_actor)
+		return ERR_PTR(-ENOMEM);
+
+	cpumask_copy(&cpu_actor->cpumask, cpumask);
+	cpu_actor->cdev = cdev;
+	cpu_actor->capacitance = capacitance;
+
+	ret = build_cpu_power_table(cpu_actor);
+	if (ret) {
+		err_ret = ERR_PTR(ret);
+		goto kfree;
+	}
+
+	last_entry = cpu_actor->power_table_entries - 1;
+	cpu_max_power = cpu_actor->power_table[last_entry].power;
+	cpu_max_power *= cpumask_weight(cpumask);
+
+	actor = power_actor_register(POWER_ACTOR_CPU, &cpu_actor_ops,
+				cpu_max_power, cpu_actor);
+	if (IS_ERR(actor)) {
+		err_ret = actor;
+		goto kfree;
+	}
+
+	mutex_lock(&cpu_power_actor_lock);
+
+	/*
+	 * You can't register multiple times the same notifier_block.
+	 * The first power actor registered is the only one that
+	 * registers the notifier.
+	 */
+	if (!cpu_power_actors_registered) {
+		ret = cpufreq_register_notifier(&cpufreq_transition_notifier,
+						CPUFREQ_TRANSITION_NOTIFIER);
+		if (ret) {
+			err_ret = ERR_PTR(ret);
+			mutex_unlock(&cpu_power_actor_lock);
+			goto power_actor_unregister;
+		}
+	}
+
+	cpu_power_actors_registered++;
+	mutex_unlock(&cpu_power_actor_lock);
+
+	return actor;
+
+power_actor_unregister:
+	power_actor_unregister(actor);
+kfree:
+	kfree(cpu_actor);
+
+	return err_ret;
+}
+
+void power_cpu_actor_unregister(struct power_actor *actor)
+{
+	struct cpu_actor *cpu_actor = actor->data;
+
+	kfree(cpu_actor->power_table);
+
+	mutex_lock(&cpu_power_actor_lock);
+
+	cpu_power_actors_registered--;
+
+	if (!cpu_power_actors_registered)
+		cpufreq_unregister_notifier(&cpufreq_transition_notifier,
+					CPUFREQ_TRANSITION_NOTIFIER);
+
+	mutex_unlock(&cpu_power_actor_lock);
+
+	kfree(cpu_actor);
+	power_actor_unregister(actor);
+}
diff --git a/drivers/thermal/power_actor/power_actor.h b/drivers/thermal/power_actor/power_actor.h
index 82be19ce741d..fe5c8cc3da3c 100644
--- a/drivers/thermal/power_actor/power_actor.h
+++ b/drivers/thermal/power_actor/power_actor.h
@@ -17,11 +17,16 @@
 #ifndef __POWER_ACTOR_H__
 #define __POWER_ACTOR_H__
 
+#include <linux/cpumask.h>
+#include <linux/device.h>
+#include <linux/err.h>
 #include <linux/list.h>
+#include <linux/thermal.h>
 
 #define MAX_NUM_ACTORS 8
 
 enum power_actor_types {
+	POWER_ACTOR_CPU,
 };
 
 struct power_actor;
@@ -58,6 +63,24 @@ struct power_actor *power_actor_register(enum power_actor_types type,
 					u32 max_power, void *privdata);
 void power_actor_unregister(struct power_actor *actor);
 
+#ifdef CONFIG_THERMAL_POWER_ACTOR_CPU
+struct power_actor *power_cpu_actor_register(cpumask_t *cpumask,
+					struct thermal_cooling_device *cdev,
+					u32 capacitance);
+void power_cpu_actor_unregister(struct power_actor *actor);
+#else
+static inline
+struct power_actor *power_cpu_actor_register(cpumask_t *cpumask,
+					struct thermal_cooling_device *cdev,
+					u32 capacitance)
+{
+	return ERR_PTR(-ENOSYS);
+}
+static inline void power_cpu_actor_unregister(struct power_actor *actor)
+{
+}
+#endif
+
 extern struct list_head actor_list;
 
 #endif /* __POWER_ACTOR_H__ */
-- 
1.7.9.5


