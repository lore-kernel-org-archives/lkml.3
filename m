Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaLETGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:06:44 -0500
Received: from service87.mimecast.com ([91.220.42.44]:37601 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaLETFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:05:24 -0500
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [RFC PATCH v6 6/9] thermal: cpu_cooling: implement the power cooling device API
Date: Fri,  5 Dec 2014 19:04:17 +0000
Message-Id: <1417806260-9264-7-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
X-OriginalArrivalTime: 05 Dec 2014 19:05:20.0282 (UTC) FILETIME=[6A0D1FA0:01D010BE]
X-MC-Unique: 114120519052300201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB5J6tYr013865

Add a basic power model to the cpu cooling device to implement the
power cooling device API.  The power model uses the current frequency,
current load and OPPs for the power calculations.  The cpus must have
registered their OPPs using the OPP library.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 Documentation/thermal/cpu-cooling-api.txt | 144 +++++++++-
 drivers/thermal/cpu_cooling.c             | 431 +++++++++++++++++++++++++++++-
 include/linux/cpu_cooling.h               |  49 +++-
 3 files changed, 611 insertions(+), 13 deletions(-)

diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/thermal/cpu-cooling-api.txt
index fca24c931ec8..d438a900e374 100644
--- a/Documentation/thermal/cpu-cooling-api.txt
+++ b/Documentation/thermal/cpu-cooling-api.txt
@@ -25,8 +25,150 @@ the user. The registration APIs returns the cooling device pointer.
 
    clip_cpus: cpumask of cpus where the frequency constraints will happen.
 
-1.1.2 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
+1.1.2 struct thermal_cooling_device *cpufreq_power_cooling_register(
+    const struct cpumask *clip_cpus, u32 capacitance,
+    get_static_t plat_static_func)
+
+Similar to cpufreq_cooling_register, this function registers a cpufreq
+cooling device.  Using this function, the cooling device will
+implement the power extensions by using a simple cpu power model.  The
+cpus must have registered their OPPs using the OPP library.
+
+The additional parameters are needed for the power model (See 2. Power
+models).  "capacitance" is the dynamic power coefficient (See 2.1
+Dynamic power).  "plat_static_func" is a function to calculate the
+static power consumed by these cpus (See 2.2 Static power).
+
+1.1.3 struct thermal_cooling_device *of_cpufreq_power_cooling_register(
+    struct device_node *np, const struct cpumask *clip_cpus, u32 capacitance,
+    get_static_t plat_static_func)
+
+Similar to cpufreq_power_cooling_register, this function register a
+cpufreq cooling device with power extensions using the device tree
+information supplied by the np parameter.
+
+1.1.4 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 
     This interface function unregisters the "thermal-cpufreq-%x" cooling device.
 
     cdev: Cooling device pointer which has to be unregistered.
+
+2. Power models
+
+The power API registration functions provide a simple power model for
+CPUs.  The current power is calculated as dynamic + (optionally)
+static power.  This power model requires that the operating-points of
+the CPUs are registered using the kernel's opp library and the
+`cpufreq_frequency_table` is assigned to the `struct device` of the
+cpu.  If you are using the `cpufreq-cpu0.c` driver then the
+`cpufreq_frequency_table` should already be assigned to the cpu
+device.
+
+The `plat_static_func` parameter of `cpufreq_power_cooling_register()`
+and `of_cpufreq_power_cooling_register()` is optional.  If you don't
+provide it, only dynamic power will be considered.
+
+2.1 Dynamic power
+
+The dynamic power consumption of a processor depends on many factors.
+For a given processor implementation the primary factors are:
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
+2.2 Static power
+
+Static leakage power consumption depends on a number of factors.  For a
+given circuit implementation the primary factors are:
+
+- Time the circuit spends in each 'power state'
+- Temperature
+- Operating voltage
+- Process grade
+
+The time the circuit spends in each 'power state' for a given
+evaluation period at first order means OFF or ON.  However,
+'retention' states can also be supported that reduce power during
+inactive periods without loss of context.
+
+Note: The visibility of state entries to the OS can vary, according to
+platform specifics, and this can then impact the accuracy of a model
+based on OS state information alone.  It might be possible in some
+cases to extract more accurate information from system resources.
+
+The temperature, operating voltage and process 'grade' (slow to fast)
+of the circuit are all significant factors in static leakage power
+consumption.  All of these have complex relationships to static power.
+
+Circuit implementation specific factors include the chosen silicon
+process as well as the type, number and size of transistors in both
+the logic gates and any RAM elements included.
+
+The static power consumption modelling must take into account the
+power managed regions that are implemented.  Taking the example of an
+ARM processor cluster, the modelling would take into account whether
+each CPU can be powered OFF separately or if only a single power
+region is implemented for the complete cluster.
+
+In one view, there are others, a static power consumption model can
+then start from a set of reference values for each power managed
+region (e.g. CPU, Cluster/L2) in each state (e.g. ON, OFF) at an
+arbitrary process grade, voltage and temperature point.  These values
+are then scaled for all of the following: the time in each state, the
+process grade, the current temperature and the operating voltage.
+However, since both implementation specific and complex relationships
+dominate the estimate, the appropriate interface to the model from the
+cpu cooling device is to provide a function callback that calculates
+the static power in this platform.  When registering the cpu cooling
+device pass a function pointer that follows the `get_static_t`
+prototype:
+
+    u32 plat_get_static(cpumask_t *cpumask, unsigned long voltage);
+
+with `cpumask` a cpumask of the cpus involved in the calculation and
+`voltage` the voltage at which they are operating.
+
+If `plat_static_func` is NULL, static power is considered to be
+negligible for this platform and only dynamic power is considered.
+
+The platform specific callback can then use any combination of tables
+and/or equations to permute the estimated value.  Process grade
+information is not passed to the model since access to such data, from
+on-chip measurement capability or manufacture time data, is platform
+specific.
+
+Note: the significance of static power for CPUs in comparison to
+dynamic power is highly dependent on implementation.  Given the
+potential complexity in implementation, the importance and accuracy of
+its inclusion when using cpu cooling devices should be assessed on a
+case by cases basis.
+
diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index ad09e51ffae4..335d95dd7e5a 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -24,11 +24,25 @@
 #include <linux/thermal.h>
 #include <linux/cpufreq.h>
 #include <linux/err.h>
+#include <linux/pm_opp.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/cpu_cooling.h>
 
 /**
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
  * struct cpufreq_cooling_device - data for cooling device with cpufreq
  * @id: unique integer value corresponding to each cpufreq_cooling_device
  *	registered.
@@ -39,6 +53,14 @@
  * @cpufreq_val: integer value representing the absolute value of the clipped
  *	frequency.
  * @allowed_cpus: all the cpus involved for this cpufreq_cooling_device.
+ * @last_load: load measured by the latest call to cpufreq_get_actual_power()
+ * @time_in_idle: previous reading of the absolute time that this cpu was idle
+ * @time_in_idle_timestamp: wall time of the last invocation of
+ *	get_cpu_idle_time_us()
+ * @dyn_power_table: array of struct power_table for frequency to power
+ *	conversion
+ * @dyn_power_table_entries: number of entries in the @dyn_power_table array
+ * @plat_get_static_power: callback to calculate the static power
  *
  * This structure is required for keeping information of each
  * cpufreq_cooling_device registered. In order to prevent corruption of this a
@@ -51,6 +73,12 @@ struct cpufreq_cooling_device {
 	unsigned int cpufreq_val;
 	struct cpumask allowed_cpus;
 	struct list_head node;
+	u32 last_load;
+	u64 time_in_idle[NR_CPUS];
+	u64 time_in_idle_timestamp[NR_CPUS];
+	struct power_table *dyn_power_table;
+	int dyn_power_table_entries;
+	get_static_t plat_get_static_power;
 };
 static DEFINE_IDR(cpufreq_idr);
 static DEFINE_MUTEX(cooling_cpufreq_lock);
@@ -338,6 +366,206 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
 	return 0;
 }
 
+/**
+ * build_dyn_power_table() - create a dynamic power to frequency table
+ * @cpufreq_device:	the cpufreq cooling device in which to store the table
+ * @capacitance: dynamic power coefficient for these cpus
+ *
+ * Build a dynamic power to frequency table for this cpu and store it
+ * in @cpufreq_device.  This table will be used in cpu_power_to_freq() and
+ * cpu_freq_to_power() to convert between power and frequency
+ * efficiently.  Power is stored in mW, frequency in KHz.  The
+ * resulting table is in ascending order.
+ *
+ * Return: 0 on success, -E* on error.
+ */
+static int build_dyn_power_table(struct cpufreq_cooling_device *cpufreq_device,
+				u32 capacitance)
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
+	for_each_cpu(cpu, &cpufreq_device->allowed_cpus) {
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
+		power = (u64)capacitance * freq_mhz * voltage_mv * voltage_mv;
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
+	cpufreq_device->dyn_power_table = power_table;
+	cpufreq_device->dyn_power_table_entries = i;
+
+unlock:
+	rcu_read_unlock();
+	return ret;
+}
+
+static u32 cpu_freq_to_power(struct cpufreq_cooling_device *cpufreq_device,
+			u32 freq)
+{
+	int i;
+	struct power_table *pt = cpufreq_device->dyn_power_table;
+
+	for (i = 1; i < cpufreq_device->dyn_power_table_entries; i++)
+		if (freq < pt[i].frequency)
+			break;
+
+	return pt[i - 1].power;
+}
+
+static u32 cpu_power_to_freq(struct cpufreq_cooling_device *cpufreq_device,
+			u32 power)
+{
+	int i;
+	struct power_table *pt = cpufreq_device->dyn_power_table;
+
+	for (i = 1; i < cpufreq_device->dyn_power_table_entries; i++)
+		if (power < pt[i].power)
+			break;
+
+	return pt[i - 1].frequency;
+}
+
+/**
+ * get_load() - get load for a cpu since last updated
+ * @cpufreq_device:	&struct cpufreq_cooling_device for this cpu
+ * @cpu:	cpu number
+ *
+ * Return: The average load of cpu @cpu in percentage since this
+ * function was last called.
+ */
+static u32 get_load(struct cpufreq_cooling_device *cpufreq_device, int cpu)
+{
+	u32 load;
+	u64 now, now_idle, delta_time, delta_idle;
+
+	now_idle = get_cpu_idle_time(cpu, &now, 0);
+	delta_idle = now_idle - cpufreq_device->time_in_idle[cpu];
+	delta_time = now - cpufreq_device->time_in_idle_timestamp[cpu];
+
+	if (delta_time <= delta_idle)
+		load = 0;
+	else
+		load = div64_u64(100 * (delta_time - delta_idle), delta_time);
+
+	cpufreq_device->time_in_idle[cpu] = now_idle;
+	cpufreq_device->time_in_idle_timestamp[cpu] = now;
+
+	return load;
+}
+
+/**
+ * get_static_power() - calculate the static power consumed by the cpus
+ * @cpufreq_device:	struct &cpufreq_cooling_device for this cpu cdev
+ * @freq:	frequency in KHz
+ *
+ * Calculate the static power consumed by the cpus described by
+ * @cpu_actor running at frequency @freq.  This function relies on a
+ * platform specific function that should have been provided when the
+ * actor was registered.  If it wasn't, the static power is assumed to
+ * be negligible.
+ *
+ * Return: The static power consumed by the cpus.  It returns 0 on
+ * error or if there is no plat_get_static_power().
+ */
+static u32 get_static_power(struct cpufreq_cooling_device *cpufreq_device,
+			unsigned long freq)
+{
+	struct device *cpu_dev;
+	struct dev_pm_opp *opp;
+	unsigned long voltage;
+	struct cpumask *cpumask = &cpufreq_device->allowed_cpus;
+	unsigned long freq_hz = freq * 1000;
+
+	if (!cpufreq_device->plat_get_static_power)
+		return 0;
+
+	cpu_dev = get_cpu_device(cpumask_any(cpumask));
+
+	rcu_read_lock();
+
+	opp = dev_pm_opp_find_freq_exact(cpu_dev, freq_hz, true);
+	voltage = dev_pm_opp_get_voltage(opp);
+
+	rcu_read_unlock();
+
+	if (voltage == 0) {
+		dev_warn_ratelimited(cpu_dev,
+				"Failed to get voltage for frequency %lu: %ld\n",
+				freq_hz, IS_ERR(opp) ? PTR_ERR(opp) : 0);
+		return 0;
+	}
+
+	return cpufreq_device->plat_get_static_power(cpumask, voltage);
+}
+
+/**
+ * get_dynamic_power() - calculate the dynamic power
+ * @cpufreq_device:	&cpufreq_cooling_device for this cdev
+ * @freq:	current frequency
+ *
+ * Return: the dynamic power consumed by the cpus described by
+ * @cpufreq_device.
+ */
+static u32 get_dynamic_power(struct cpufreq_cooling_device *cpufreq_device,
+			unsigned long freq)
+{
+	u32 raw_cpu_power;
+
+	raw_cpu_power = cpu_freq_to_power(cpufreq_device, freq);
+	return (raw_cpu_power * cpufreq_device->last_load) / 100;
+}
+
 /* cpufreq cooling device callback functions are defined below */
 
 /**
@@ -407,8 +635,106 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 	return cpufreq_apply_cooling(cpufreq_device, state);
 }
 
+/**
+ * cpufreq_get_actual_power() - get the current power
+ * @cdev:	&thermal_cooling_device pointer
+ *
+ * Return the current power consumption of the cpus in milliwatts.
+ */
+static u32 cpufreq_get_actual_power(struct thermal_cooling_device *cdev)
+{
+	unsigned long freq;
+	int cpu;
+	u32 static_power, dynamic_power, total_load = 0;
+	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
+
+	freq = cpufreq_quick_get(cpumask_any(&cpufreq_device->allowed_cpus));
+
+	for_each_cpu(cpu, &cpufreq_device->allowed_cpus) {
+		u32 load;
+
+		if (cpu_online(cpu))
+			load = get_load(cpufreq_device, cpu);
+		else
+			load = 0;
+
+		total_load += load;
+	}
+
+	cpufreq_device->last_load = total_load;
+
+	static_power = get_static_power(cpufreq_device, freq);
+	dynamic_power = get_dynamic_power(cpufreq_device, freq);
+
+	return static_power + dynamic_power;
+}
+
+/**
+ * cpufreq_state2power() - convert a cpu cdev state to power consumed
+ * @cdev:	&thermal_cooling_device pointer
+ * @state:	cooling device state to be converted
+ *
+ * Convert cooling device state @state into power consumption in milliwatts.
+ */
+static u32 cpufreq_state2power(struct thermal_cooling_device *cdev,
+			unsigned long state)
+{
+	unsigned int freq, num_cpus;
+	cpumask_t cpumask;
+	u32 static_power, dynamic_power;
+	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
+
+	cpumask_and(&cpumask, &cpufreq_device->allowed_cpus, cpu_online_mask);
+	num_cpus = cpumask_weight(&cpumask);
+
+	freq = get_cpu_frequency(cpumask_any(&cpumask), state);
+	if (!freq)
+		return 0;
+
+	static_power = get_static_power(cpufreq_device, freq);
+	dynamic_power = cpu_freq_to_power(cpufreq_device, freq) * num_cpus;
+
+	return static_power + dynamic_power;
+}
+
+/**
+ * cpufreq_power2state() - convert power to a cooling device state
+ * @cdev:	&thermal_cooling_device pointer
+ * @power:	power in milliwatts to be converted
+ *
+ * Calculate a cooling device state for the cpus described by @cdev
+ * that would allow them to consume at most @power mW.
+ */
+static unsigned long cpufreq_power2state(struct thermal_cooling_device *cdev,
+					u32 power)
+{
+	unsigned int cpu, cur_freq, target_freq;
+	s32 dyn_power;
+	u32 last_load, normalised_power;
+	unsigned long cdev_state;
+	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
+
+	cpu = cpumask_any_and(&cpufreq_device->allowed_cpus, cpu_online_mask);
+
+	cur_freq = cpufreq_quick_get(cpu);
+	dyn_power = power - get_static_power(cpufreq_device, cur_freq);
+	dyn_power = dyn_power > 0 ? dyn_power : 0;
+	last_load = cpufreq_device->last_load ?: 1;
+	normalised_power = (dyn_power * 100) / last_load;
+	target_freq = cpu_power_to_freq(cpufreq_device, normalised_power);
+
+	cdev_state = cpufreq_cooling_get_level(cpu, target_freq);
+	if (cdev_state == THERMAL_CSTATE_INVALID) {
+		pr_err_ratelimited("Failed to convert %dKHz for cpu %d into a cdev state\n",
+				target_freq, cpu);
+		return 0;
+	}
+
+	return cdev_state;
+}
+
 /* Bind cpufreq callbacks to thermal cooling device ops */
-static struct thermal_cooling_device_ops const cpufreq_cooling_ops = {
+static struct thermal_cooling_device_ops cpufreq_cooling_ops = {
 	.get_max_state = cpufreq_get_max_state,
 	.get_cur_state = cpufreq_get_cur_state,
 	.set_cur_state = cpufreq_set_cur_state,
@@ -434,7 +760,8 @@ static struct notifier_block thermal_cpufreq_notifier_block = {
  */
 static struct thermal_cooling_device *
 __cpufreq_cooling_register(struct device_node *np,
-			   const struct cpumask *clip_cpus)
+			const struct cpumask *clip_cpus, u32 capacitance,
+			get_static_t plat_static_func)
 {
 	struct thermal_cooling_device *cool_dev;
 	struct cpufreq_cooling_device *cpufreq_dev = NULL;
@@ -464,10 +791,23 @@ __cpufreq_cooling_register(struct device_node *np,
 
 	cpumask_copy(&cpufreq_dev->allowed_cpus, clip_cpus);
 
+	if (capacitance) {
+		cpufreq_cooling_ops.get_actual_power = cpufreq_get_actual_power;
+		cpufreq_cooling_ops.state2power = cpufreq_state2power;
+		cpufreq_cooling_ops.power2state = cpufreq_power2state;
+		cpufreq_dev->plat_get_static_power = plat_static_func;
+
+		ret = build_dyn_power_table(cpufreq_dev, capacitance);
+		if (ret) {
+			cool_dev = ERR_PTR(ret);
+			goto free;
+		}
+	}
+
 	ret = get_idr(&cpufreq_idr, &cpufreq_dev->id);
 	if (ret) {
-		kfree(cpufreq_dev);
-		return ERR_PTR(-EINVAL);
+		cool_dev = ERR_PTR(-EINVAL);
+		goto free;
 	}
 
 	snprintf(dev_name, sizeof(dev_name), "thermal-cpufreq-%d",
@@ -475,11 +815,8 @@ __cpufreq_cooling_register(struct device_node *np,
 
 	cool_dev = thermal_of_cooling_device_register(np, dev_name, cpufreq_dev,
 						      &cpufreq_cooling_ops);
-	if (IS_ERR(cool_dev)) {
-		release_idr(&cpufreq_idr, cpufreq_dev->id);
-		kfree(cpufreq_dev);
-		return cool_dev;
-	}
+	if (IS_ERR(cool_dev))
+		goto release_idr;
 	cpufreq_dev->cool_dev = cool_dev;
 	cpufreq_dev->cpufreq_state = 0;
 	mutex_lock(&cooling_cpufreq_lock);
@@ -494,6 +831,12 @@ __cpufreq_cooling_register(struct device_node *np,
 	mutex_unlock(&cooling_cpufreq_lock);
 
 	return cool_dev;
+
+release_idr:
+	release_idr(&cpufreq_idr, cpufreq_dev->id);
+free:
+	kfree(cpufreq_dev);
+	return cool_dev;
 }
 
 /**
@@ -510,7 +853,7 @@ __cpufreq_cooling_register(struct device_node *np,
 struct thermal_cooling_device *
 cpufreq_cooling_register(const struct cpumask *clip_cpus)
 {
-	return __cpufreq_cooling_register(NULL, clip_cpus);
+	return __cpufreq_cooling_register(NULL, clip_cpus, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(cpufreq_cooling_register);
 
@@ -534,11 +877,77 @@ of_cpufreq_cooling_register(struct device_node *np,
 	if (!np)
 		return ERR_PTR(-EINVAL);
 
-	return __cpufreq_cooling_register(np, clip_cpus);
+	return __cpufreq_cooling_register(np, clip_cpus, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(of_cpufreq_cooling_register);
 
 /**
+ * cpufreq_power_cooling_register() - create cpufreq cooling device with power extensions
+ * @clip_cpus:	cpumask of cpus where the frequency constraints will happen
+ * @capacitance:	dynamic power coefficient for these cpus
+ * @plat_static_func:	function to calculate the static power consumed by these
+ *			cpus (optional)
+ *
+ * This interface function registers the cpufreq cooling device with
+ * the name "thermal-cpufreq-%x".  This api can support multiple
+ * instances of cpufreq cooling devices.  Using this function, the
+ * cooling device will implement the power extensions by using a
+ * simple cpu power model.  The cpus must have registered their OPPs
+ * using the OPP library.
+ *
+ * An optional @plat_static_func may be provided to calculate the
+ * static power consumed by these cpus.  If the platform's static
+ * power consumption is unknown or negligible, make it NULL.
+ *
+ * Return: a valid struct thermal_cooling_device pointer on success,
+ * on failure, it returns a corresponding ERR_PTR().
+ */
+struct thermal_cooling_device *
+cpufreq_power_cooling_register(const struct cpumask *clip_cpus, u32 capacitance,
+			get_static_t plat_static_func)
+{
+	return __cpufreq_cooling_register(NULL, clip_cpus, capacitance,
+				plat_static_func);
+}
+EXPORT_SYMBOL(cpufreq_power_cooling_register);
+
+/**
+ * of_cpufreq_power_cooling_register() - create cpufreq cooling device with power extensions
+ * @np:	a valid struct device_node to the cooling device device tree node
+ * @clip_cpus:	cpumask of cpus where the frequency constraints will happen
+ * @capacitance:	dynamic power coefficient for these cpus
+ * @plat_static_func:	function to calculate the static power consumed by these
+ *			cpus (optional)
+ *
+ * This interface function registers the cpufreq cooling device with
+ * the name "thermal-cpufreq-%x".  This api can support multiple
+ * instances of cpufreq cooling devices.  Using this API, the cpufreq
+ * cooling device will be linked to the device tree node provided.
+ * Using this function, the cooling device will implement the power
+ * extensions by using a simple cpu power model.  The cpus must have
+ * registered their OPPs using the OPP library.
+ *
+ * An optional @plat_static_func may be provided to calculate the
+ * static power consumed by these cpus.  If the platform's static
+ * power consumption is unknown or negligible, make it NULL.
+ *
+ * Return: a valid struct thermal_cooling_device pointer on success,
+ * on failure, it returns a corresponding ERR_PTR().
+ */
+struct thermal_cooling_device *
+of_cpufreq_power_cooling_register(struct device_node *np,
+			const struct cpumask *clip_cpus, u32 capacitance,
+			get_static_t plat_static_func)
+{
+	if (!np)
+		return ERR_PTR(-EINVAL);
+
+	return __cpufreq_cooling_register(np, clip_cpus, capacitance,
+				plat_static_func);
+}
+EXPORT_SYMBOL(of_cpufreq_power_cooling_register);
+
+/**
  * cpufreq_cooling_unregister - function to remove cpufreq cooling device.
  * @cdev: thermal cooling device pointer.
  *
diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
index c303d383def1..5c4f4567acf0 100644
--- a/include/linux/cpu_cooling.h
+++ b/include/linux/cpu_cooling.h
@@ -28,6 +28,8 @@
 #include <linux/thermal.h>
 #include <linux/cpumask.h>
 
+typedef u32 (*get_static_t)(cpumask_t *cpumask, unsigned long voltage);
+
 #ifdef CONFIG_CPU_THERMAL
 /**
  * cpufreq_cooling_register - function to create cpufreq cooling device.
@@ -37,14 +39,38 @@ struct thermal_cooling_device *
 cpufreq_cooling_register(const struct cpumask *clip_cpus);
 
 /**
+ * cpufreq_power_cooling_register() - create cpufreq cooling device with power extensions
+ * @clip_cpus: cpumask of cpus where the frequency constraints will happen
+ * @capacitance:	dynamic power coefficient for these cpus
+ * @plat_static_func:	function to calculate the static power consumed by these
+ *			cpus (optional)
+ */
+struct thermal_cooling_device *
+cpufreq_power_cooling_register(const struct cpumask *clip_cpus,
+			u32 capacitance, get_static_t plat_static_func);
+
+#ifdef CONFIG_THERMAL_OF
+/**
  * of_cpufreq_cooling_register - create cpufreq cooling device based on DT.
  * @np: a valid struct device_node to the cooling device device tree node.
  * @clip_cpus: cpumask of cpus where the frequency constraints will happen
  */
-#ifdef CONFIG_THERMAL_OF
 struct thermal_cooling_device *
 of_cpufreq_cooling_register(struct device_node *np,
 			    const struct cpumask *clip_cpus);
+
+/**
+ * of_cpufreq_power_cooling_register() - create cpufreq cooling device with power extensions
+ * @np:	a valid struct device_node to the cooling device device tree node
+ * @clip_cpus:	cpumask of cpus where the frequency constraints will happen
+ * @capacitance:	dynamic power coefficient for these cpus
+ * @plat_static_func:	function to calculate the static power consumed by these
+ *			cpus (optional)
+ */
+struct thermal_cooling_device *
+of_cpufreq_power_cooling_register(struct device_node *np,
+				const struct cpumask *clip_cpus,
+				u32 capacitance, get_static_t plat_static_func);
 #else
 static inline struct thermal_cooling_device *
 of_cpufreq_cooling_register(struct device_node *np,
@@ -52,6 +78,14 @@ of_cpufreq_cooling_register(struct device_node *np,
 {
 	return NULL;
 }
+
+struct thermal_cooling_device *
+of_cpufreq_power_cooling_register(struct device_node *np,
+				const struct cpumask *clip_cpus,
+				u32 capacitance, get_static_t plat_static_func)
+{
+	return NULL;
+}
 #endif
 
 /**
@@ -68,11 +102,24 @@ cpufreq_cooling_register(const struct cpumask *clip_cpus)
 	return NULL;
 }
 static inline struct thermal_cooling_device *
+cpufreq_power_cooling_register(const struct cpumask *clip_cpus,
+			u32 capacitance, get_static_t plat_static_func)
+{
+	return NULL;
+}
+static inline struct thermal_cooling_device *
 of_cpufreq_cooling_register(struct device_node *np,
 			    const struct cpumask *clip_cpus)
 {
 	return NULL;
 }
+static inline struct thermal_cooling_device *
+of_cpufreq_power_cooling_register(struct device_node *np,
+				const struct cpumask *clip_cpus,
+				u32 capacitance, get_static_t plat_static_func)
+{
+	return NULL;
+}
 static inline
 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 {
-- 
1.9.1


