Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbaFKMY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:24:58 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:40576 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaFKMY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:24:56 -0400
Date: Wed, 11 Jun 2014 08:05:37 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        punit.agrawal@arm.com, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v3 5/7] thermal: add a basic cpu power actor
Message-ID: <20140611120537.GA7230@developer>
References: <1401790715-5630-1-git-send-email-javi.merino@arm.com>
 <1401790715-5630-6-git-send-email-javi.merino@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401790715-5630-6-git-send-email-javi.merino@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Javi,


On Tue, Jun 03, 2014 at 11:18:33AM +0100, Javi Merino wrote:
> Introduce a power actor for cpus.  It has a basic power model to get
> the current power utilization and uses cpufreq cooling devices to set
> the desired power.  It uses the current frequency (as reported by
> cpufreq) as well as load and OPPs for the power calculations.  The
> cpus must have registered their OPPs in the OPP library.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> ---
>  Documentation/thermal/power_actor.txt     | 126 +++++++
>  drivers/thermal/Kconfig                   |   5 +
>  drivers/thermal/power_actor/Kconfig       |   9 +
>  drivers/thermal/power_actor/Makefile      |   2 +
>  drivers/thermal/power_actor/cpu_actor.c   | 601 ++++++++++++++++++++++++++++++
>  drivers/thermal/power_actor/power_actor.h |  41 ++
>  6 files changed, 784 insertions(+)
>  create mode 100644 drivers/thermal/power_actor/Kconfig
>  create mode 100644 drivers/thermal/power_actor/cpu_actor.c
> 
> diff --git a/Documentation/thermal/power_actor.txt b/Documentation/thermal/power_actor.txt
> index 5a61f32ec143..fd51760615bf 100644
> --- a/Documentation/thermal/power_actor.txt
> +++ b/Documentation/thermal/power_actor.txt
> @@ -36,3 +36,129 @@ temperature.
>  milliwatts.
>  
>  Returns 0 on success, -E* on error.
> +
> +CPU Power Actor API
> +===================
> +
> +A simple power model for CPUs.  The current power is calculated as
> +dynamic + (optionally) static power.  This power model requires that
> +the operating-points of the CPUs are registered using the kernel's opp
> +library and the `cpufreq_frequency_table` is assigned to the `struct
> +device` of the cpu.  If you are using the `cpufreq-cpu0.c` driver then
> +the `cpufreq_frequency_table` should already be assigned to the cpu
> +device.
> +
> +The `tz` and `plat_static_func` parameters of
> +`power_cpu_actor_register()` are optional.  If you don't provide them,
> +only dynamic power will be considered.
> +
> +Dynamic power
> +-------------
> +
> +The dynamic power consumption of a processor depends
> +on many factors.  For a given processor implementation the primary
> +factors are:
> +
> +- The time the processor spends running, consuming dynamic power, as
> +  compared to the time in idle states where dynamic consumption is
> +  negligible.  Herein we refer to this as 'utilisation'.
> +- The voltage and frequency levels as a result of DVFS.  The DVFS
> +  level is a dominant factor governing power consumption.
> +- In running time the 'execution' behaviour (instruction types, memory
> +  access patterns and so forth) causes, in most cases, a second order
> +  variation.  In pathological cases this variation can be significant,
> +  but typically it is of a much lesser impact than the factors above.
> +
> +A high level dynamic power consumption model may then be represented as:
> +
> +Pdyn = f(run) * Voltage^2 * Frequency * Utilisation
> +
> +f(run) here represents the described execution behaviour and its
> +result has a units of Watts/Hz/Volt^2 (this often expressed in
> +mW/MHz/uVolt^2)
> +
> +The detailed behaviour for f(run) could be modelled on-line.  However,
> +in practice, such an on-line model has dependencies on a number of
> +implementation specific processor support and characterisation
> +factors.  Therefore, in initial implementation that contribution is
> +represented as a constant coefficient.  This is a simplification
> +consistent with the relative contribution to overall power variation.
> +
> +In this simplified representation our model becomes:
> +
> +Pdyn = Kd * Voltage^2 * Frequency * Utilisation
> +
> +Where Kd (capacitance) represents an indicative running time dynamic
> +power coefficient in fundamental units of mW/MHz/uVolt^2
> +
> +Static Power
> +------------
> +
> +Static leakage power consumption depends on a number of factors.  For a
> +given circuit implementation the primary factors are:
> +
> +- Time the circuit spends in each 'power state'
> +- Temperature
> +- Operating voltage
> +- Process grade
> +
> +The time the circuit spends in each 'power state' for a given
> +evaluation period at first order means OFF or ON.  However,
> +'retention' states can also be supported that reduce power during
> +inactive periods without loss of context.
> +
> +Note: The visibility of state entries to the OS can vary, according to
> +platform specifics, and this can then impact the accuracy of a model
> +based on OS state information alone.  It might be possible in some
> +cases to extract more accurate information from system resources.
> +
> +The temperature, operating voltage and process 'grade' (slow to fast)
> +of the circuit are all significant factors in static leakage power
> +consumption.  All of these have complex relationships to static power.
> +
> +Circuit implementation specific factors include the chosen silicon
> +process as well as the type, number and size of transistors in both
> +the logic gates and any RAM elements included.
> +
> +The static power consumption modelling must take into account the
> +power managed regions that are implemented.  Taking the example of an
> +ARM processor cluster, the modelling would take into account whether
> +each CPU can be powered OFF separately or if only a single power
> +region is implemented for the complete cluster.
> +
> +In one view, there are others, a static power consumption model can
> +then start from a set of reference values for each power managed
> +region (e.g. CPU, Cluster/L2) in each state (e.g. ON, OFF) at an
> +arbitrary process grade, voltage and temperature point.  These values
> +are then scaled for all of the following: the time in each state, the
> +process grade, the current temperature and the operating
> +voltage.  However, since both implementation specific and complex
> +relationships dominate the estimate, the appropriate interface to the
> +model from the cpu power actor is to provide a function callback that
> +calculates the static power in this platform.  When registering the
> +power cpu actor, pass the thermal zone closest to the cpu (to get the
> +temperature) and a function pointer that follows the `get_static_t`
> +prototype:
> +
> +    u32 plat_get_static(cpumask_t *cpumask, unsigned long voltage,
> +				unsigned long temperature);
> +
> +with `cpumask` a cpumask of the cpus involved in the calculation,
> +`voltage` the voltage at which they are opperating and `temperature`
> +their current temperature.
> +
> +If both `tz` and `plat_static_func` are NULL when registering the
> +power cpu actor, static power is considered to be negligible for this
> +platform and only dynamic power is considered.
> +
> +The platform specific callback can then use any combination of tables
> +and/or equations to permute the estimated value.  Process grade
> +information is not passed to the model since access to such data, from
> +on-chip measurement capability or manufacture time data, is platform
> +specific.
> +
> +Note: the significance of static power for CPUs in comparison to
> +dynamic power is highly dependent on implementation.  Given the
> +potential complexity in implementation, the importance and accuracy of
> +its inclusion when using cpu power actors should be assessed on a case by
> +cases basis.

In one way or another, we are dealing with models here. Even the above
dynamic power model is still a model and has errors from reality. The
point is providing a good default model that works across platforms.

> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 47e2f15537ca..1818c4fa60b8 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -92,6 +92,11 @@ config THERMAL_GOV_USER_SPACE
>  config THERMAL_POWER_ACTOR
>  	bool
>  
> +menu "Power actors"
> +depends on THERMAL_POWER_ACTOR
> +source "drivers/thermal/power_actor/Kconfig"
> +endmenu
> +
>  config CPU_THERMAL
>  	bool "generic cpu cooling support"
>  	depends on CPU_FREQ
> diff --git a/drivers/thermal/power_actor/Kconfig b/drivers/thermal/power_actor/Kconfig
> new file mode 100644
> index 000000000000..fa542ca99cdb
> --- /dev/null
> +++ b/drivers/thermal/power_actor/Kconfig
> @@ -0,0 +1,9 @@
> +#
> +# Thermal power actor configuration
> +#
> +
> +config THERMAL_POWER_ACTOR_CPU
> +	bool
> +	prompt "Simple power model for a CPU"
> +	help
> +	  A simple CPU power model

A better help is always welcome.

> diff --git a/drivers/thermal/power_actor/Makefile b/drivers/thermal/power_actor/Makefile
> index 46478f4928be..6f04b92997e6 100644
> --- a/drivers/thermal/power_actor/Makefile
> +++ b/drivers/thermal/power_actor/Makefile
> @@ -3,3 +3,5 @@
>  #
>  
>  obj-y += power_actor.o
> +
> +obj-$(CONFIG_THERMAL_POWER_ACTOR_CPU) += cpu_actor.o
> diff --git a/drivers/thermal/power_actor/cpu_actor.c b/drivers/thermal/power_actor/cpu_actor.c
> new file mode 100644
> index 000000000000..6eac80d119a5
> --- /dev/null
> +++ b/drivers/thermal/power_actor/cpu_actor.c
> @@ -0,0 +1,601 @@
> +/*
> + * A basic cpu actor
> + *
> + * Copyright (C) 2014 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#define pr_fmt(fmt) "CPU actor: " fmt
> +
> +#include <linux/cpu.h>
> +#include <linux/cpufreq.h>
> +#include <linux/cpumask.h>
> +#include <linux/cpu_cooling.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/pm_opp.h>
> +#include <linux/printk.h>
> +#include <linux/slab.h>
> +
> +#include "power_actor.h"
> +
> +/**
> + * struct power_table - frequency to power conversion
> + * @frequency:	frequency in KHz
> + * @power:	power in mW
> + *
> + * This structure is built when the cooling device registers and helps
> + * in translating frequency to power and viceversa.
> + */
> +struct power_table {
> +	u32 frequency;
> +	u32 power;
> +};
> +
> +/**
> + * struct cpu_actor - information for each cpu actor
> + * @cpumask:	cpus covered by this actor
> + * @freq:	frequency in KHz of the cpus represented by the cooling device
> + * @last_load:	load measured by the latest call to cpu_get_req_power()
> + * @time_in_idle:	previous reading of the absolute time that this cpu was
> + *			idle
> + * @time_in_idle_timestamp: wall time of the last invocation of
> + *			    get_cpu_idle_time_us()
> + * @dyn_power_table:	array of struct power_table for frequency to power
> + *			conversion
> + * @dyn_power_table_entries: number of entries in the @dyn_power_table array
> + * @cdev:	cpufreq cooling device associated with this actor
> + * @tz:		thermal zone for the sensor closest to the cpus
> + * @plat_get_static_power:	callback to calculate the static power
> + */
> +struct cpu_actor {
> +	cpumask_t cpumask;
> +	u32 freq;
> +	u32 last_load;
> +	u64 time_in_idle[NR_CPUS];
> +	u64 time_in_idle_timestamp[NR_CPUS];
> +	struct power_table *dyn_power_table;
> +	int dyn_power_table_entries;
> +	struct thermal_cooling_device *cdev;
> +	struct thermal_zone_device *tz;
> +	get_static_t plat_get_static_power;
> +};
> +
> +static DEFINE_MUTEX(cpu_power_actor_lock);
> +
> +static unsigned int cpu_power_actors_registered;
> +
> +static u32 cpu_freq_to_power(struct cpu_actor *cpu_actor, u32 freq)
> +{
> +	int i;
> +	struct power_table *pt = cpu_actor->dyn_power_table;
> +
> +	for (i = 0; i < cpu_actor->dyn_power_table_entries - 1; i++)
> +		if (freq <= pt[i].frequency)
> +			break;
> +
> +	return pt[i].power;
> +}
> +
> +static u32 cpu_power_to_freq(struct cpu_actor *cpu_actor, u32 power)
> +{
> +	int i;
> +	struct power_table *pt = cpu_actor->dyn_power_table;
> +
> +	for (i = 0; i < cpu_actor->dyn_power_table_entries - 1; i++)
> +		if (power <= pt[i].power)
> +			break;
> +
> +	return pt[i].frequency;
> +}
> +
> +/**
> + * get_load - get load for a cpu since last updated
> + * @cpu_actor: struct cpu_actor for this actor
> + * @cpu: cpu number
> + *
> + * Return the average load of cpu @cpu in percentage since this
> + * function was last called.
> + */
> +static u32 get_load(struct cpu_actor *cpu_actor, int cpu)
> +{
> +	u32 load;
> +	u64 now, now_idle, delta_time, delta_idle;
> +
> +	now_idle = get_cpu_idle_time(cpu, &now, 0);
> +	delta_idle = now_idle - cpu_actor->time_in_idle[cpu];
> +	delta_time = now - cpu_actor->time_in_idle_timestamp[cpu];
> +
> +	if (delta_time <= delta_idle)
> +		load = 0;
> +	else
> +		load = div64_u64(100 * (delta_time - delta_idle), delta_time);
> +
> +	cpu_actor->time_in_idle[cpu] = now_idle;
> +	cpu_actor->time_in_idle_timestamp[cpu] = now;
> +
> +	return load;
> +}
> +
> +/**
> + * __get_static_power() - calculate the static power consumed by the cpus
> + * @cpu_actor:	&struct cpu_actor for this cpu
> + * @freq:	frequency in KHz
> + *
> + * Calculate the static power consumed by the cpus described by
> + * @cpu_actor running at frequency @freq.  This function relies on a
> + * platform specific function that should have been provided when the
> + * actor was registered.  If it wasn't, the static power is assumed to
> + * be negligible.
> + *
> + * Return: The static power consumed by the cpus.  It returns 0 on
> + * error or if there is no plat_get_static_power().
> + */
> +static u32 __get_static_power(struct cpu_actor *cpu_actor, unsigned long freq)
> +{
> +	int err;
> +	struct device *cpu_dev;
> +	struct dev_pm_opp *opp;
> +	unsigned long voltage, temperature;
> +	cpumask_t *cpumask = &cpu_actor->cpumask;
> +	unsigned long freq_hz = freq * 1000;
> +
> +	if (!cpu_actor->plat_get_static_power)
> +		return 0;
> +
> +	if (freq == 0)
> +		return 0;
> +
> +	cpu_dev = get_cpu_device(cpumask_any(cpumask));
> +
> +	rcu_read_lock();
> +
> +	opp = dev_pm_opp_find_freq_exact(cpu_dev, freq_hz, true);
> +	voltage = dev_pm_opp_get_voltage(opp);
> +
> +	rcu_read_unlock();
> +
> +	if (voltage == 0) {
> +		dev_warn_ratelimited(cpu_dev,
> +				"Failed to get voltage for frequency %lu: %ld\n",
> +				freq_hz, IS_ERR(opp) ? PTR_ERR(opp) : 0);
> +		return 0;
> +	}
> +
> +	err = thermal_zone_get_temp(cpu_actor->tz, &temperature);
> +	if (err) {
> +		dev_warn(&cpu_actor->tz->device, "Unable to read temperature: %d\n",
> +			err);
> +		return 0;
> +	}
> +
> +	return cpu_actor->plat_get_static_power(cpumask, voltage, temperature);

How about if this could be optional? That is, something like:


+	if (cpu_actor->plat_get_static_power)
+		return cpu_actor->plat_get_static_power(cpumask, voltage, temperature);
+	else
+		return default_static_power(cpumask, voltage, temperature);

> +}
> +
> +static u32 get_static_power(struct cpu_actor *cpu_actor)
> +{
> +	return __get_static_power(cpu_actor, cpu_actor->freq);
> +}
> +
> +/**
> + * get_dynamic_power - calculate the dynamic power
> + * @cpu_actor: cpu_actor pointer
> + *
> + * Return the dynamic power consumed by the cpus described by
> + * cpu_actor.
> + */
> +static u32 get_dynamic_power(struct cpu_actor *cpu_actor)
> +{
> +	int cpu;
> +	u32 power = 0, raw_cpu_power, total_load = 0;
> +	raw_cpu_power = cpu_freq_to_power(cpu_actor, cpu_actor->freq);
> +
> +	for_each_cpu(cpu, &cpu_actor->cpumask) {
> +		u32 load;
> +
> +		if (!cpu_online(cpu))
> +			continue;
> +
> +		load = get_load(cpu_actor, cpu);
> +		power += (raw_cpu_power * load) / 100;
> +		total_load += load;
> +	}
> +
> +	cpu_actor->last_load = total_load;
> +
> +	return power;
> +}
> +
> +/**
> + * cpu_get_req_power - get the current power
> + * @actor:	power actor pointer
> + *
> + * Callback for the power actor to return the current power
> + * consumption in milliwatts.
> + */
> +static u32 cpu_get_req_power(struct power_actor *actor)
> +{
> +	u32 static_power, dynamic_power;
> +	struct cpu_actor *cpu_actor = actor->data;
> +
> +	static_power = get_static_power(cpu_actor);
> +	dynamic_power = get_dynamic_power(cpu_actor);
> +
> +	return static_power + dynamic_power;
> +}
> +
> +/**
> + * cpu_get_max_power() - get the maximum power that the cpu could currently consume
> + * @actor:	power actor pointer
> + *
> + * Callback for the power actor to return the maximum power
> + * consumption in milliwatts that the cpu could currently consume.
> + * The static power depends on temperature so the maximum power will
> + * vary over time.
> + */
> +static u32 cpu_get_max_power(struct power_actor *actor)
> +{
> +	u32 max_static_power, max_dyn_power;
> +	cpumask_t *cpumask;
> +	unsigned int max_freq, last_entry, num_cpus;
> +	struct cpu_actor *cpu_actor = actor->data;
> +
> +	cpumask = &cpu_actor->cpumask;
> +	max_freq = cpufreq_quick_get_max(cpumask_any(cpumask));
> +	max_static_power = __get_static_power(cpu_actor, max_freq);
> +
> +	last_entry = cpu_actor->dyn_power_table_entries - 1;
> +	num_cpus = cpumask_weight(cpumask);
> +	max_dyn_power = cpu_actor->dyn_power_table[last_entry].power * num_cpus;
> +
> +	return max_static_power + max_dyn_power;
> +}
> +
> +/**
> + * cpu_set_power - set cpufreq cooling device to consume a certain power
> + * @actor: power actor pointer
> + * @power: the power in milliwatts that should be set
> + *
> + * Callback for the power actor to configure the power consumption of
> + * the CPU to be @power milliwatts at most.  This function assumes
> + * that the load will remain constant.  The power is translated into a
> + * cooling state that the cpu cooling device then sets.
> + *
> + * Returns 0 on success, -EINVAL if it couldn't convert the frequency
> + * to a cpufreq cooling device state.
> + */
> +static int cpu_set_power(struct power_actor *actor, u32 power)
> +{
> +	unsigned int cpu, freq;
> +	unsigned long cdev_state;
> +	u32 dyn_power, normalised_power, last_load;
> +	struct thermal_cooling_device *cdev;
> +	struct cpu_actor *cpu_actor = actor->data;
> +
> +	cdev = cpu_actor->cdev;
> +
> +	dyn_power = power - get_static_power(cpu_actor);
> +	cpu = cpumask_any(&cpu_actor->cpumask);
> +	last_load = cpu_actor->last_load ? cpu_actor->last_load : 1;
> +	normalised_power = (dyn_power * 100) / last_load;
> +	freq = cpu_power_to_freq(cpu_actor, normalised_power);
> +
> +	cdev_state = cpufreq_cooling_get_level(cpu, freq);
> +	if (cdev_state == THERMAL_CSTATE_INVALID) {
> +		pr_err("Failed to convert %dKHz for cpu %d into a cdev state\n",
> +			freq, cpu);
> +		return -EINVAL;
> +	}
> +
> +	return cdev->ops->set_cur_state(cdev, cdev_state);
> +}
> +
> +static struct power_actor_ops cpu_actor_ops = {
> +	.get_req_power = cpu_get_req_power,
> +	.get_max_power = cpu_get_max_power,
> +	.set_power = cpu_set_power,
> +};

Why the above cannot be done with current thermal API?

> +
> +/**
> + * power_cpu_actor_add_static() - add static information to an existing cpu actor
> + * @cpu:	a cpu represented by the cpu power actor
> + * @tz:		pointer to the closest thermal zone to the cpu
> + * @plat_static_func:	function to calculate the static power consumed by these
> + *			cpus
> + *
> + * A function to add static information to an actor after it has
> + * registered.  In order to calculate the static power, we need the to
> + * know the temperature of the cpu, which we get from its closest
> + * thermal zone.  It is possible that when registering the
> + * power_cpu_actor, the thermal zone hasn't been registered yet.  This
> + * function allows you to add that information when the thermal zone
> + * is registered.  @cpu should be one of the cpus represented by the
> + * cpu actor you want to modify
> + *
> + * Return: 0 on success.  -EINVAL if @tz or @plat_static_func are
> + * NULL.  -ENOENT if there's no cpu power actor for @cpu.
> + */
> +int power_cpu_actor_add_static(unsigned int cpu, struct thermal_zone_device *tz,
> +			get_static_t plat_static_func)
> +{
> +	struct power_actor *actor;
> +
> +	if (!plat_static_func || !tz)
> +		return -EINVAL;
> +
> +	list_for_each_entry(actor, &actor_list, actor_node) {
> +		struct cpu_actor *cpu_actor;
> +
> +		if (actor->type != POWER_ACTOR_CPU)
> +			continue;
> +
> +		cpu_actor = actor->data;
> +
> +		if (cpumask_test_cpu(cpu, &cpu_actor->cpumask)) {
> +			cpu_actor->tz = tz;
> +			cpu_actor->plat_get_static_power = plat_static_func;
> +			return 0;
> +		}
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +/**
> + * cpufreq_frequency_change - notifier callback for cpufreq frequency changes
> + * @nb:		struct notifier_block * with callback info
> + * @event:	value showing cpufreq event for which this function invoked
> + * @data:	callback-specific data
> + *
> + * Callback to get notifications of frequency changes.  In the
> + * CPUFREQ_POSTCHANGE @event we store the new frequency so that
> + * cpufreq_get_cur() knows the current frequency and can convert it
> + * into power.
> + */
> +static int cpufreq_frequency_change(struct notifier_block *nb,
> +				unsigned long event, void *data)
> +{
> +	struct power_actor *actor;
> +	struct cpufreq_freqs *freqs = data;
> +
> +	/* Only update frequency on postchange */
> +	if (event != CPUFREQ_POSTCHANGE)
> +		return NOTIFY_DONE;
> +
> +	list_for_each_entry(actor, &actor_list, actor_node) {
> +		struct cpu_actor *cpu_actor;
> +
> +		if (actor->type != POWER_ACTOR_CPU)
> +			continue;
> +
> +		cpu_actor = actor->data;
> +
> +		if (cpumask_test_cpu(freqs->cpu, &cpu_actor->cpumask))
> +			cpu_actor->freq = freqs->new;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +struct notifier_block cpufreq_transition_notifier = {
> +	.notifier_call = cpufreq_frequency_change,
> +};
> +
> +/**
> + * build_dyn_power_table - create a dynamic power to frequency table
> + * @cpu_actor:	the cpu_actor in which to store the table
> + * @capacitance: dynamic power coefficient for these cpus
> + *
> + * Build a dynamic power to frequency table for this cpu and store it
> + * in @cpu_actor.  This table will be used in cpu_power_to_freq() and
> + * cpu_freq_to_power() to convert between power and frequency
> + * efficiently.  Power is stored in mW, frequency in KHz.  The
> + * resulting table is in ascending order.
> + *
> + * Returns 0 on success, -E* on error.
> + */
> +static int build_dyn_power_table(struct cpu_actor *cpu_actor, u32 capacitance)
> +{
> +	struct power_table *power_table;
> +	struct dev_pm_opp *opp;
> +	struct device *dev = NULL;
> +	int num_opps, cpu, i, ret = 0;
> +	unsigned long freq;
> +
> +	num_opps = 0;
> +
> +	rcu_read_lock();
> +
> +	for_each_cpu(cpu, &cpu_actor->cpumask) {
> +		dev = get_cpu_device(cpu);
> +		if (!dev)
> +			continue;
> +
> +		num_opps = dev_pm_opp_get_opp_count(dev);
> +		if (num_opps > 0) {
> +			break;
> +		} else if (num_opps < 0) {
> +			ret = num_opps;
> +			goto unlock;
> +		}
> +	}
> +
> +	if (num_opps == 0) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	power_table = kcalloc(num_opps, sizeof(*power_table), GFP_KERNEL);
> +
> +	i = 0;
> +	for (freq = 0;
> +	     opp = dev_pm_opp_find_freq_ceil(dev, &freq), !IS_ERR(opp);
> +	     freq++) {
> +		u32 freq_mhz, voltage_mv;
> +		u64 power;
> +
> +		freq_mhz = freq / 1000000;
> +		voltage_mv = dev_pm_opp_get_voltage(opp) / 1000;
> +
> +		/*
> +		 * Do the multiplication with MHz and millivolt so as
> +		 * to not overflow.
> +		 */
> +		power = (u64)capacitance * freq_mhz * voltage_mv * voltage_mv;
> +		do_div(power, 1000000000);
> +
> +		/* frequency is stored in power_table in KHz */
> +		power_table[i].frequency = freq / 1000;
> +		power_table[i].power = power;
> +
> +		i++;
> +	}
> +
> +	if (i == 0) {
> +		ret = PTR_ERR(opp);
> +		goto unlock;
> +	}
> +
> +	cpu_actor->dyn_power_table = power_table;
> +	cpu_actor->dyn_power_table_entries = i;
> +
> +unlock:
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +/**
> + * power_cpu_actor_register - register a cpu_actor within the power actor API
> + * @cpumask:	cpumask of cpus covered by this power_actor
> + * @tz:		thermal zone closest to the cpus (optional)
> + * @capacitance: dynamic power coefficient for these cpus
> + * @plat_static_func:	function to calculate the static power consumed by these
> + *			cpus (optional)
> + *
> + * Create a cpufreq cooling device for the cpus in @cpumask and
> + * register it with the power actor API using a simple cpu power
> + * model.  The cpus must have registered their OPPs in the OPP
> + * library.
> + *
> + * An optional @plat_static_func may be provided to calculate the
> + * static power consumed by these cpus.  If the platform's static
> + * power consumption is unknown or negligible, make it NULL.  If
> + * @plat_static_fun is specified, @tz needs to be specified as well.
> + * @tz should be a pointer to the thermal_zone_device whose sensor is
> + * closer to the cpus in @cpumask.
> + *
> + * Return the power_actor created on success or the corresponding
> + * ERR_PTR() on failure.  This actor should be freed with
> + * power_cpu_actor_unregister() when it's no longer needed.
> + */
> +struct power_actor *
> +power_cpu_actor_register(cpumask_t *cpumask,
> +			struct thermal_zone_device *tz,
> +			u32 capacitance,
> +			get_static_t plat_static_func)
> +{
> +	int ret;
> +	struct thermal_cooling_device *cdev;
> +	struct device *cpu_dev;
> +	struct power_actor *actor, *err_ret;
> +	struct cpu_actor *cpu_actor;
> +
> +	if (plat_static_func && !tz) {
> +		pr_warn("plat_static_func provided without a thermal zone, ignoring it\n");
> +		plat_static_func = NULL;


You either make this one hard requirement (and do not fail gracefuly
like above) or you make it really optional and provide a good default
formula (which is preferrable).

> +	}
> +
> +	cpu_dev = get_cpu_device(cpumask_any(cpumask));
> +	if (!cpu_dev || !cpu_dev->of_node)
> +		cdev = cpufreq_cooling_register(cpumask);
> +	else
> +		cdev = of_cpufreq_cooling_register(cpu_dev->of_node, cpumask);
> +
> +	if (!cdev)
> +		return ERR_PTR(PTR_ERR(cdev));
> +
> +	cpu_actor = kzalloc(sizeof(*cpu_actor), GFP_KERNEL);
> +	if (!cpu_actor) {
> +		err_ret = ERR_PTR(-ENOMEM);
> +		goto cdev_unregister;
> +	}
> +
> +	cpumask_copy(&cpu_actor->cpumask, cpumask);
> +	cpu_actor->cdev = cdev;
> +	cpu_actor->tz = tz;
> +	cpu_actor->plat_get_static_power = plat_static_func;
> +
> +	ret = build_dyn_power_table(cpu_actor, capacitance);
> +	if (ret) {
> +		err_ret = ERR_PTR(ret);
> +		goto kfree;
> +	}
> +
> +	actor = power_actor_register(POWER_ACTOR_CPU, &cpu_actor_ops,
> +				cpu_actor);
> +	if (IS_ERR(actor)) {
> +		err_ret = actor;
> +		goto kfree;
> +	}
> +
> +	mutex_lock(&cpu_power_actor_lock);
> +
> +	/*
> +	 * You can't register multiple times the same notifier_block.
> +	 * The first power actor registered is the only one that
> +	 * registers the notifier.
> +	 */
> +	if (!cpu_power_actors_registered) {
> +		ret = cpufreq_register_notifier(&cpufreq_transition_notifier,
> +						CPUFREQ_TRANSITION_NOTIFIER);
> +		if (ret) {
> +			err_ret = ERR_PTR(ret);
> +			mutex_unlock(&cpu_power_actor_lock);
> +			goto power_actor_unregister;
> +		}
> +	}
> +
> +	cpu_power_actors_registered++;
> +	mutex_unlock(&cpu_power_actor_lock);
> +
> +	return actor;
> +
> +power_actor_unregister:
> +	power_actor_unregister(actor);
> +kfree:
> +	kfree(cpu_actor);
> +cdev_unregister:
> +	cpufreq_cooling_unregister(cdev);
> +
> +	return err_ret;
> +}
> +
> +void power_cpu_actor_unregister(struct power_actor *actor)
> +{
> +	struct cpu_actor *cpu_actor = actor->data;
> +
> +	kfree(cpu_actor->dyn_power_table);
> +
> +	mutex_lock(&cpu_power_actor_lock);
> +
> +	cpu_power_actors_registered--;
> +
> +	if (!cpu_power_actors_registered)
> +		cpufreq_unregister_notifier(&cpufreq_transition_notifier,
> +					CPUFREQ_TRANSITION_NOTIFIER);
> +
> +	mutex_unlock(&cpu_power_actor_lock);
> +
> +	kfree(cpu_actor);
> +	power_actor_unregister(actor);
> +}
> diff --git a/drivers/thermal/power_actor/power_actor.h b/drivers/thermal/power_actor/power_actor.h
> index 28098f43630b..230317c284b2 100644
> --- a/drivers/thermal/power_actor/power_actor.h
> +++ b/drivers/thermal/power_actor/power_actor.h
> @@ -17,11 +17,16 @@
>  #ifndef __POWER_ACTOR_H__
>  #define __POWER_ACTOR_H__
>  
> +#include <linux/cpumask.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
>  #include <linux/list.h>
> +#include <linux/thermal.h>
>  
>  #define MAX_NUM_ACTORS 8
>  
>  enum power_actor_types {
> +	POWER_ACTOR_CPU,

Using struct device is more scalable no? What if we want to provide a
power actor for a specific bus, or device, or coprocessor? Are we going
to maintain this enum for every single new user?

Another point to think is if we are having more than one user of power
actor per device (type). 

>  };
>  
>  struct power_actor;
> @@ -59,6 +64,42 @@ struct power_actor *power_actor_register(enum power_actor_types type,
>  					void *privdata);
>  void power_actor_unregister(struct power_actor *actor);
>  
> +typedef u32 (*get_static_t)(cpumask_t *cpumask,
> +				unsigned long voltage,
> +				unsigned long temperature);
> +
> +#ifdef CONFIG_THERMAL_POWER_ACTOR_CPU
> +int power_cpu_actor_add_static(unsigned int cpu,
> +			struct thermal_zone_device *tz,
> +			get_static_t plat_static_func);
> +struct power_actor *
> +power_cpu_actor_register(cpumask_t *cpumask,
> +			struct thermal_zone_device *tz,
> +			u32 capacitance,
> +			get_static_t plat_static_func);
> +void power_cpu_actor_unregister(struct power_actor *actor);
> +#else
> +static inline
> +int power_cpu_actor_add_static(unsigned int cpu,
> +					struct thermal_zone_device *tz,
> +					get_static_t plat_static_func)
> +{
> +	return -ENOSYS;
> +}
> +static inline
> +struct power_actor *
> +power_cpu_actor_register(cpumask_t *cpumask,
> +			struct thermal_zone_device *tz,
> +			u32 capacitance,
> +			get_static_t plat_static_func)
> +{
> +	return ERR_PTR(-ENOSYS);
> +}
> +static inline void power_cpu_actor_unregister(struct power_actor *actor)
> +{
> +}
> +#endif
> +
>  extern struct list_head actor_list;
>  
>  #endif /* __POWER_ACTOR_H__ */
> -- 
> 1.9.1
> 
> 

