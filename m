Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbbA1Uwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:52:53 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63916 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbbA1Uwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:52:49 -0500
Date: Wed, 28 Jan 2015 13:56:08 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        punit.agrawal@arm.com, broonie@kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH v1 3/7] thermal: cpu_cooling: implement the power cooling
 device API
Message-ID: <20150128175606.GB27003@developer.hsd1.ca.comcast.net>
References: <1422464438-16761-1-git-send-email-javi.merino@arm.com>
 <1422464438-16761-4-git-send-email-javi.merino@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <1422464438-16761-4-git-send-email-javi.merino@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2015 at 05:00:34PM +0000, Javi Merino wrote:
> Add a basic power model to the cpu cooling device to implement the
> power cooling device API.  The power model uses the current frequency,
> current load and OPPs for the power calculations.  The cpus must have
> registered their OPPs using the OPP library.
>=20
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> ---
>  Documentation/thermal/cpu-cooling-api.txt | 156 +++++++++-
>  drivers/thermal/cpu_cooling.c             | 480 ++++++++++++++++++++++++=
+++++-
>  include/linux/cpu_cooling.h               |  39 +++
>  3 files changed, 670 insertions(+), 5 deletions(-)
>=20
> diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/th=
ermal/cpu-cooling-api.txt
> index 753e47cc2e20..71653584cd03 100644
> --- a/Documentation/thermal/cpu-cooling-api.txt
> +++ b/Documentation/thermal/cpu-cooling-api.txt
> @@ -36,8 +36,162 @@ the user. The registration APIs returns the cooling d=
evice pointer.
>      np: pointer to the cooling device device tree node
>      clip_cpus: cpumask of cpus where the frequency constraints will happ=
en.
> =20
> -1.1.3 void cpufreq_cooling_unregister(struct thermal_cooling_device *cde=
v)
> +1.1.3 struct thermal_cooling_device *cpufreq_power_cooling_register(
> +    const struct cpumask *clip_cpus, u32 capacitance,
> +    get_static_t plat_static_func)
> +
> +Similar to cpufreq_cooling_register, this function registers a cpufreq
> +cooling device.  Using this function, the cooling device will
> +implement the power extensions by using a simple cpu power model.  The
> +cpus must have registered their OPPs using the OPP library.
> +
> +The additional parameters are needed for the power model (See 2. Power
> +models).  "capacitance" is the dynamic power coefficient (See 2.1
> +Dynamic power).  "plat_static_func" is a function to calculate the
> +static power consumed by these cpus (See 2.2 Static power).
> +
> +1.1.4 struct thermal_cooling_device *of_cpufreq_power_cooling_register(
> +    struct device_node *np, const struct cpumask *clip_cpus, u32 capacit=
ance,
> +    get_static_t plat_static_func)
> +
> +Similar to cpufreq_power_cooling_register, this function register a
> +cpufreq cooling device with power extensions using the device tree
> +information supplied by the np parameter.
> +
> +1.1.5 void cpufreq_cooling_unregister(struct thermal_cooling_device *cde=
v)
> =20
>      This interface function unregisters the "thermal-cpufreq-%x" cooling=
 device.
> =20
>      cdev: Cooling device pointer which has to be unregistered.
> +
> +2. Power models
> +
> +The power API registration functions provide a simple power model for
> +CPUs.  The current power is calculated as dynamic + (optionally)
> +static power.  This power model requires that the operating-points of
> +the CPUs are registered using the kernel's opp library and the
> +`cpufreq_frequency_table` is assigned to the `struct device` of the
> +cpu.  If you are using CONFIG_CPUFREQ_DT then the
> +`cpufreq_frequency_table` should already be assigned to the cpu
> +device.
> +
> +The `plat_static_func` parameter of `cpufreq_power_cooling_register()`
> +and `of_cpufreq_power_cooling_register()` is optional.  If you don't
> +provide it, only dynamic power will be considered.
> +
> +2.1 Dynamic power
> +
> +The dynamic power consumption of a processor depends on many factors.
> +For a given processor implementation the primary factors are:
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
> +Pdyn =3D f(run) * Voltage^2 * Frequency * Utilisation
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
> +Pdyn =3D Capacitance * Voltage^2 * Frequency * Utilisation
> +
> +Where `capacitance` is a constant that represents an indicative
> +running time dynamic power coefficient in fundamental units of
> +mW/MHz/uVolt^2.  Typical values for mobile CPUs might lie in range
> +from 100 to 500.  For reference, the approximate values for the SoC in
> +ARM's Juno Development Platform are 530 for the Cortex-A57 cluster and
> +140 for the Cortex-A53 cluster.
> +
> +
> +2.2 Static power
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
> +process grade, the current temperature and the operating voltage.
> +However, since both implementation specific and complex relationships
> +dominate the estimate, the appropriate interface to the model from the
> +cpu cooling device is to provide a function callback that calculates
> +the static power in this platform.  When registering the cpu cooling
> +device pass a function pointer that follows the `get_static_t`
> +prototype:
> +
> +    int plat_get_static(cpumask_t *cpumask, int interval,
> +                        unsigned long voltage, u32 &power);
> +
> +`cpumask` is the cpumask of the cpus involved in the calculation.
> +`voltage` is the voltage at which they are operating.  The function
> +should calculate the average static power for the last `interval`
> +milliseconds.  It returns 0 on success, -E* on error.  If it
> +succeeds, it should store the static power in `power`.  Reading the
> +temperature of the cpus described by `cpumask` is left for
> +plat_get_static() to do as the platform knows best which thermal
> +sensor is closest to the cpu.
> +
> +If `plat_static_func` is NULL, static power is considered to be
> +negligible for this platform and only dynamic power is considered.
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
> +its inclusion when using cpu cooling devices should be assessed on a
> +case by case basis.
> +
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index f65f0d109fc8..a639aaf228f5 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -26,6 +26,7 @@
>  #include <linux/thermal.h>
>  #include <linux/cpufreq.h>
>  #include <linux/err.h>
> +#include <linux/pm_opp.h>
>  #include <linux/slab.h>
>  #include <linux/cpu.h>
>  #include <linux/cpu_cooling.h>
> @@ -45,6 +46,19 @@
>   */
> =20
>  /**
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
>   * struct cpufreq_cooling_device - data for cooling device with cpufreq
>   * @id: unique integer value corresponding to each cpufreq_cooling_device
>   *	registered.
> @@ -58,6 +72,15 @@
>   *	cpufreq frequencies.
>   * @allowed_cpus: all the cpus involved for this cpufreq_cooling_device.
>   * @node: list_head to link all cpufreq_cooling_device together.
> + * @last_load: load measured by the latest call to cpufreq_get_actual_po=
wer()
> + * @time_in_idle: previous reading of the absolute time that this cpu wa=
s idle
> + * @time_in_idle_timestamp: wall time of the last invocation of
> + *	get_cpu_idle_time_us()
> + * @dyn_power_table: array of struct power_table for frequency to power
> + *	conversion, sorted in ascending order.
> + * @dyn_power_table_entries: number of entries in the @dyn_power_table a=
rray
> + * @cpu_dev: the first cpu_device from @allowed_cpus that has OPPs regis=
tered
> + * @plat_get_static_power: callback to calculate the static power
>   *
>   * This structure is required for keeping information of each registered
>   * cpufreq_cooling_device.
> @@ -71,6 +94,13 @@ struct cpufreq_cooling_device {
>  	unsigned int *freq_table;	/* In descending order */
>  	struct cpumask allowed_cpus;
>  	struct list_head node;
> +	u32 last_load;
> +	u64 time_in_idle[NR_CPUS];
> +	u64 time_in_idle_timestamp[NR_CPUS];
> +	struct power_table *dyn_power_table;
> +	int dyn_power_table_entries;
> +	struct device *cpu_dev;
> +	get_static_t plat_get_static_power;
>  };
>  static DEFINE_IDR(cpufreq_idr);
>  static DEFINE_MUTEX(cooling_cpufreq_lock);
> @@ -205,6 +235,210 @@ static int cpufreq_thermal_notifier(struct notifier=
_block *nb,
>  	return 0;
>  }
> =20
> +/**
> + * build_dyn_power_table() - create a dynamic power to frequency table
> + * @cpufreq_device:	the cpufreq cooling device in which to store the tab=
le
> + * @capacitance: dynamic power coefficient for these cpus
> + *
> + * Build a dynamic power to frequency table for this cpu and store it
> + * in @cpufreq_device.  This table will be used in cpu_power_to_freq() a=
nd
> + * cpu_freq_to_power() to convert between power and frequency
> + * efficiently.  Power is stored in mW, frequency in KHz.  The
> + * resulting table is in ascending order.
> + *
> + * Return: 0 on success, -E* on error.
> + */
> +static int build_dyn_power_table(struct cpufreq_cooling_device *cpufreq_=
device,
> +				 u32 capacitance)
> +{
> +	struct power_table *power_table;
> +	struct dev_pm_opp *opp;
> +	struct device *dev =3D NULL;
> +	int num_opps =3D 0, cpu, i, ret =3D 0;
> +	unsigned long freq;
> +
> +	rcu_read_lock();
> +
> +	for_each_cpu(cpu, &cpufreq_device->allowed_cpus) {
> +		dev =3D get_cpu_device(cpu);
> +		if (!dev) {
> +			dev_warn(&cpufreq_device->cool_dev->device,
> +				 "No cpu device for cpu %d\n", cpu);
> +			continue;
> +		}
> +
> +		num_opps =3D dev_pm_opp_get_opp_count(dev);
> +		if (num_opps > 0) {
> +			break;
> +		} else if (num_opps < 0) {
> +			ret =3D num_opps;
> +			goto unlock;
> +		}
> +	}
> +
> +	if (num_opps =3D=3D 0) {
> +		ret =3D -EINVAL;
> +		goto unlock;
> +	}
> +
> +	power_table =3D kcalloc(num_opps, sizeof(*power_table), GFP_KERNEL);
> +
> +	for (freq =3D 0, i =3D 0;
> +	     opp =3D dev_pm_opp_find_freq_ceil(dev, &freq), !IS_ERR(opp);
> +	     freq++, i++) {
> +		u32 freq_mhz, voltage_mv;
> +		u64 power;
> +
> +		freq_mhz =3D freq / 1000000;
> +		voltage_mv =3D dev_pm_opp_get_voltage(opp) / 1000;
> +
> +		/*
> +		 * Do the multiplication with MHz and millivolt so as
> +		 * to not overflow.
> +		 */
> +		power =3D (u64)capacitance * freq_mhz * voltage_mv * voltage_mv;
> +		do_div(power, 1000000000);
> +
> +		/* frequency is stored in power_table in KHz */
> +		power_table[i].frequency =3D freq / 1000;
> +
> +		/* power is stored in mW */
> +		power_table[i].power =3D power;
> +	}
> +
> +	if (i =3D=3D 0) {
> +		ret =3D PTR_ERR(opp);
> +		goto unlock;
> +	}
> +
> +	cpufreq_device->cpu_dev =3D dev;
> +	cpufreq_device->dyn_power_table =3D power_table;
> +	cpufreq_device->dyn_power_table_entries =3D i;
> +
> +unlock:
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +static u32 cpu_freq_to_power(struct cpufreq_cooling_device *cpufreq_devi=
ce,
> +			     u32 freq)
> +{
> +	int i;
> +	struct power_table *pt =3D cpufreq_device->dyn_power_table;
> +
> +	for (i =3D 1; i < cpufreq_device->dyn_power_table_entries; i++)
> +		if (freq < pt[i].frequency)
> +			break;
> +
> +	return pt[i - 1].power;
> +}
> +
> +static u32 cpu_power_to_freq(struct cpufreq_cooling_device *cpufreq_devi=
ce,
> +			     u32 power)
> +{
> +	int i;
> +	struct power_table *pt =3D cpufreq_device->dyn_power_table;
> +
> +	for (i =3D 1; i < cpufreq_device->dyn_power_table_entries; i++)
> +		if (power < pt[i].power)
> +			break;
> +
> +	return pt[i - 1].frequency;
> +}
> +
> +/**
> + * get_load() - get load for a cpu since last updated
> + * @cpufreq_device:	&struct cpufreq_cooling_device for this cpu
> + * @cpu:	cpu number
> + *
> + * Return: The average load of cpu @cpu in percentage since this
> + * function was last called.
> + */
> +static u32 get_load(struct cpufreq_cooling_device *cpufreq_device, int c=
pu)
> +{
> +	u32 load;
> +	u64 now, now_idle, delta_time, delta_idle;
> +
> +	now_idle =3D get_cpu_idle_time(cpu, &now, 0);
> +	delta_idle =3D now_idle - cpufreq_device->time_in_idle[cpu];
> +	delta_time =3D now - cpufreq_device->time_in_idle_timestamp[cpu];
> +
> +	if (delta_time <=3D delta_idle)
> +		load =3D 0;
> +	else
> +		load =3D div64_u64(100 * (delta_time - delta_idle), delta_time);
> +
> +	cpufreq_device->time_in_idle[cpu] =3D now_idle;
> +	cpufreq_device->time_in_idle_timestamp[cpu] =3D now;
> +
> +	return load;
> +}
> +
> +/**
> + * get_static_power() - calculate the static power consumed by the cpus
> + * @cpufreq_device:	struct &cpufreq_cooling_device for this cpu cdev
> + * @tz:		thermal zone device in which we're operating
> + * @freq:	frequency in KHz
> + * @power:	pointer in which to store the calculated static power
> + *
> + * Calculate the static power consumed by the cpus described by
> + * @cpu_actor running at frequency @freq.  This function relies on a
> + * platform specific function that should have been provided when the
> + * actor was registered.  If it wasn't, the static power is assumed to
> + * be negligible.  The calculated static power is stored in @power.
> + *
> + * Return: 0 on success, -E* on failure.
> + */
> +static int get_static_power(struct cpufreq_cooling_device *cpufreq_devic=
e,
> +			    struct thermal_zone_device *tz, unsigned long freq,
> +			    u32 *power)
> +{
> +	struct dev_pm_opp *opp;
> +	unsigned long voltage;
> +	struct cpumask *cpumask =3D &cpufreq_device->allowed_cpus;
> +	unsigned long freq_hz =3D freq * 1000;
> +
> +	if (!cpufreq_device->plat_get_static_power) {
> +		*power =3D 0;
> +		return 0;
> +	}
> +
> +	rcu_read_lock();
> +
> +	opp =3D dev_pm_opp_find_freq_exact(cpufreq_device->cpu_dev, freq_hz,
> +					 true);
> +	voltage =3D dev_pm_opp_get_voltage(opp);
> +
> +	rcu_read_unlock();
> +
> +	if (voltage =3D=3D 0) {
> +		dev_warn_ratelimited(cpufreq_device->cpu_dev,
> +				     "Failed to get voltage for frequency %lu: %ld\n",
> +				     freq_hz, IS_ERR(opp) ? PTR_ERR(opp) : 0);
> +		return -EINVAL;
> +	}
> +
> +	return cpufreq_device->plat_get_static_power(cpumask, tz->passive_delay,
> +						     voltage, power);
> +}
> +
> +/**
> + * get_dynamic_power() - calculate the dynamic power
> + * @cpufreq_device:	&cpufreq_cooling_device for this cdev
> + * @freq:	current frequency
> + *
> + * Return: the dynamic power consumed by the cpus described by
> + * @cpufreq_device.
> + */
> +static u32 get_dynamic_power(struct cpufreq_cooling_device *cpufreq_devi=
ce,
> +			     unsigned long freq)
> +{
> +	u32 raw_cpu_power;
> +
> +	raw_cpu_power =3D cpu_freq_to_power(cpufreq_device, freq);
> +	return (raw_cpu_power * cpufreq_device->last_load) / 100;
> +}
> +
>  /* cpufreq cooling device callback functions are defined below */
> =20
>  /**
> @@ -280,8 +514,161 @@ static int cpufreq_set_cur_state(struct thermal_coo=
ling_device *cdev,
>  	return 0;
>  }
> =20
> +/**
> + * cpufreq_get_requested_power() - get the current power
> + * @cdev:	&thermal_cooling_device pointer
> + * @tz:		a valid thermal zone device pointer
> + * @power:	pointer in which to store the resulting power
> + *
> + * Calculate the current power consumption of the cpus in milliwatts
> + * and store it in @power.  This function should actually calculate
> + * the requested power, but it's hard to get the frequency that
> + * cpufreq would have assigned if there were no thermal limits.
> + * Instead, we calculate the current power on the assumption that the
> + * immediate future will look like the immediate past.
> + *
> + * Return: 0 on success, -E* if getting the static power failed.
> + */
> +static int cpufreq_get_requested_power(struct thermal_cooling_device *cd=
ev,
> +				       struct thermal_zone_device *tz,
> +				       u32 *power)
> +{
> +	unsigned long freq;
> +	int cpu, ret;
> +	u32 static_power, dynamic_power, total_load =3D 0;
> +	struct cpufreq_cooling_device *cpufreq_device =3D cdev->devdata;
> +
> +	freq =3D cpufreq_quick_get(cpumask_any(&cpufreq_device->allowed_cpus));
> +
> +	for_each_cpu(cpu, &cpufreq_device->allowed_cpus) {
> +		u32 load;
> +
> +		if (cpu_online(cpu))
> +			load =3D get_load(cpufreq_device, cpu);
> +		else
> +			load =3D 0;
> +
> +		total_load +=3D load;
> +	}
> +
> +	cpufreq_device->last_load =3D total_load;
> +
> +	dynamic_power =3D get_dynamic_power(cpufreq_device, freq);
> +	ret =3D get_static_power(cpufreq_device, tz, freq, &static_power);
> +	if (ret)
> +		return ret;
> +
> +	*power =3D static_power + dynamic_power;
> +	return 0;
> +}

Repeating the query I've just made on v5, do we care if the system uses
different opps during the load sampling interval?=20

Meaning, 1 - idle might not reflect the correct load.


> +
> +/**
> + * cpufreq_state2power() - convert a cpu cdev state to power consumed
> + * @cdev:	&thermal_cooling_device pointer
> + * @tz:		a valid thermal zone device pointer
> + * @state:	cooling device state to be converted
> + * @power:	pointer in which to store the resulting power
> + *
> + * Convert cooling device state @state into power consumption in
> + * milliwatts assuming 100% load.  Store the calculated power in
> + * @power.
> + *
> + * Return: 0 on success, -EINVAL if the cooling device state could not
> + * be converted into a frequency or other -E* if there was an error
> + * when calculating the static power.
> + */
> +static int cpufreq_state2power(struct thermal_cooling_device *cdev,
> +			       struct thermal_zone_device *tz,
> +			       unsigned long state, u32 *power)
> +{
> +	unsigned int freq, num_cpus;
> +	cpumask_t cpumask;
> +	u32 static_power, dynamic_power;
> +	int ret;
> +	struct cpufreq_cooling_device *cpufreq_device =3D cdev->devdata;
> +
> +	cpumask_and(&cpumask, &cpufreq_device->allowed_cpus, cpu_online_mask);
> +	num_cpus =3D cpumask_weight(&cpumask);
> +
> +	/* None of our cpus are online, so no power */
> +	if (num_cpus =3D=3D 0) {
> +		*power =3D 0;
> +		return 0;
> +	}
> +
> +	freq =3D cpufreq_device->freq_table[state];
> +	if (!freq)
> +		return -EINVAL;
> +
> +	dynamic_power =3D cpu_freq_to_power(cpufreq_device, freq) * num_cpus;
> +	ret =3D get_static_power(cpufreq_device, tz, freq, &static_power);
> +	if (ret)
> +		return ret;
> +
> +	*power =3D static_power + dynamic_power;
> +	return 0;
> +}
> +
> +/**
> + * cpufreq_power2state() - convert power to a cooling device state
> + * @cdev:	&thermal_cooling_device pointer
> + * @tz:		a valid thermal zone device pointer
> + * @power:	power in milliwatts to be converted
> + * @state:	pointer in which to store the resulting state
> + *
> + * Calculate a cooling device state for the cpus described by @cdev
> + * that would allow them to consume at most @power mW and store it in
> + * @state.  Note that this calculation depends on external factors
> + * such as the cpu load or the current static power.  Calling this
> + * function with the same power as input can yield different cooling
> + * device states depending on those external factors.
> + *
> + * Return: 0 on success, -ENODEV if no cpus are online or -EINVAL if
> + * the calculated frequency could not be converted to a valid state.
> + * The latter should not happen unless the frequencies available to
> + * cpufreq have changed since the initialization of the cpu cooling
> + * device.
> + */
> +static int cpufreq_power2state(struct thermal_cooling_device *cdev,
> +			       struct thermal_zone_device *tz, u32 power,
> +			       unsigned long *state)
> +{
> +	unsigned int cpu, cur_freq, target_freq;
> +	int ret;
> +	s32 dyn_power;
> +	u32 last_load, normalised_power, static_power;
> +	struct cpufreq_cooling_device *cpufreq_device =3D cdev->devdata;
> +
> +	cpu =3D cpumask_any_and(&cpufreq_device->allowed_cpus, cpu_online_mask);
> +
> +	/* None of our cpus are online */
> +	if (cpu >=3D nr_cpu_ids)
> +		return -ENODEV;
> +
> +	cur_freq =3D cpufreq_quick_get(cpu);
> +	ret =3D get_static_power(cpufreq_device, tz, cur_freq, &static_power);
> +	if (ret)
> +		return ret;
> +
> +	dyn_power =3D power - static_power;
> +	dyn_power =3D dyn_power > 0 ? dyn_power : 0;
> +	last_load =3D cpufreq_device->last_load ?: 1;
> +	normalised_power =3D (dyn_power * 100) / last_load;
> +	target_freq =3D cpu_power_to_freq(cpufreq_device, normalised_power);
> +
> +	*state =3D cpufreq_cooling_get_level(cpu, target_freq);
> +	if (*state =3D=3D THERMAL_CSTATE_INVALID) {
> +		dev_warn_ratelimited(&cdev->device,
> +				     "Failed to convert %dKHz for cpu %d into a cdev state\n",
> +				     target_freq, cpu);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  /* Bind cpufreq callbacks to thermal cooling device ops */
> -static struct thermal_cooling_device_ops const cpufreq_cooling_ops =3D {
> +static struct thermal_cooling_device_ops cpufreq_cooling_ops =3D {
>  	.get_max_state =3D cpufreq_get_max_state,
>  	.get_cur_state =3D cpufreq_get_cur_state,
>  	.set_cur_state =3D cpufreq_set_cur_state,
> @@ -311,6 +698,9 @@ static unsigned int find_next_max(struct cpufreq_freq=
uency_table *table,
>   * @np: a valid struct device_node to the cooling device device tree node
>   * @clip_cpus: cpumask of cpus where the frequency constraints will happ=
en.
>   * Normally this should be same as cpufreq policy->related_cpus.
> + * @capacitance: dynamic power coefficient for these cpus
> + * @plat_static_func: function to calculate the static power consumed by=
 these
> + *                    cpus (optional)
>   *
>   * This interface function registers the cpufreq cooling device with the=
 name
>   * "thermal-cpufreq-%x". This api can support multiple instances of cpuf=
req
> @@ -322,7 +712,8 @@ static unsigned int find_next_max(struct cpufreq_freq=
uency_table *table,
>   */
>  static struct thermal_cooling_device *
>  __cpufreq_cooling_register(struct device_node *np,
> -			   const struct cpumask *clip_cpus)
> +			const struct cpumask *clip_cpus, u32 capacitance,
> +			get_static_t plat_static_func)
>  {
>  	struct thermal_cooling_device *cool_dev;
>  	struct cpufreq_cooling_device *cpufreq_dev;
> @@ -357,6 +748,20 @@ __cpufreq_cooling_register(struct device_node *np,
> =20
>  	cpumask_copy(&cpufreq_dev->allowed_cpus, clip_cpus);
> =20
> +	if (capacitance) {
> +		cpufreq_cooling_ops.get_requested_power =3D
> +			cpufreq_get_requested_power;
> +		cpufreq_cooling_ops.state2power =3D cpufreq_state2power;
> +		cpufreq_cooling_ops.power2state =3D cpufreq_power2state;
> +		cpufreq_dev->plat_get_static_power =3D plat_static_func;
> +
> +		ret =3D build_dyn_power_table(cpufreq_dev, capacitance);
> +		if (ret) {
> +			cool_dev =3D ERR_PTR(ret);
> +			goto free_table;
> +		}
> +	}
> +
>  	ret =3D get_idr(&cpufreq_idr, &cpufreq_dev->id);
>  	if (ret) {
>  		cool_dev =3D ERR_PTR(ret);
> @@ -422,7 +827,7 @@ free_cdev:
>  struct thermal_cooling_device *
>  cpufreq_cooling_register(const struct cpumask *clip_cpus)
>  {
> -	return __cpufreq_cooling_register(NULL, clip_cpus);
> +	return __cpufreq_cooling_register(NULL, clip_cpus, 0, NULL);
>  }
>  EXPORT_SYMBOL_GPL(cpufreq_cooling_register);
> =20
> @@ -446,11 +851,78 @@ of_cpufreq_cooling_register(struct device_node *np,
>  	if (!np)
>  		return ERR_PTR(-EINVAL);
> =20
> -	return __cpufreq_cooling_register(np, clip_cpus);
> +	return __cpufreq_cooling_register(np, clip_cpus, 0, NULL);
>  }
>  EXPORT_SYMBOL_GPL(of_cpufreq_cooling_register);
> =20
>  /**
> + * cpufreq_power_cooling_register() - create cpufreq cooling device with=
 power extensions
> + * @clip_cpus:	cpumask of cpus where the frequency constraints will happ=
en
> + * @capacitance:	dynamic power coefficient for these cpus
> + * @plat_static_func:	function to calculate the static power consumed by=
 these
> + *			cpus (optional)
> + *
> + * This interface function registers the cpufreq cooling device with
> + * the name "thermal-cpufreq-%x".  This api can support multiple
> + * instances of cpufreq cooling devices.  Using this function, the
> + * cooling device will implement the power extensions by using a
> + * simple cpu power model.  The cpus must have registered their OPPs
> + * using the OPP library.
> + *
> + * An optional @plat_static_func may be provided to calculate the
> + * static power consumed by these cpus.  If the platform's static
> + * power consumption is unknown or negligible, make it NULL.
> + *
> + * Return: a valid struct thermal_cooling_device pointer on success,
> + * on failure, it returns a corresponding ERR_PTR().
> + */
> +struct thermal_cooling_device *
> +cpufreq_power_cooling_register(const struct cpumask *clip_cpus, u32 capa=
citance,
> +			       get_static_t plat_static_func)
> +{
> +	return __cpufreq_cooling_register(NULL, clip_cpus, capacitance,
> +				plat_static_func);
> +}
> +EXPORT_SYMBOL(cpufreq_power_cooling_register);
> +
> +/**
> + * of_cpufreq_power_cooling_register() - create cpufreq cooling device w=
ith power extensions
> + * @np:	a valid struct device_node to the cooling device device tree node
> + * @clip_cpus:	cpumask of cpus where the frequency constraints will happ=
en
> + * @capacitance:	dynamic power coefficient for these cpus
> + * @plat_static_func:	function to calculate the static power consumed by=
 these
> + *			cpus (optional)
> + *
> + * This interface function registers the cpufreq cooling device with
> + * the name "thermal-cpufreq-%x".  This api can support multiple
> + * instances of cpufreq cooling devices.  Using this API, the cpufreq
> + * cooling device will be linked to the device tree node provided.
> + * Using this function, the cooling device will implement the power
> + * extensions by using a simple cpu power model.  The cpus must have
> + * registered their OPPs using the OPP library.
> + *
> + * An optional @plat_static_func may be provided to calculate the
> + * static power consumed by these cpus.  If the platform's static
> + * power consumption is unknown or negligible, make it NULL.
> + *
> + * Return: a valid struct thermal_cooling_device pointer on success,
> + * on failure, it returns a corresponding ERR_PTR().
> + */
> +struct thermal_cooling_device *
> +of_cpufreq_power_cooling_register(struct device_node *np,
> +				  const struct cpumask *clip_cpus,
> +				  u32 capacitance,
> +				  get_static_t plat_static_func)
> +{
> +	if (!np)
> +		return ERR_PTR(-EINVAL);
> +
> +	return __cpufreq_cooling_register(np, clip_cpus, capacitance,
> +				plat_static_func);
> +}
> +EXPORT_SYMBOL(of_cpufreq_power_cooling_register);
> +
> +/**
>   * cpufreq_cooling_unregister - function to remove cpufreq cooling devic=
e.
>   * @cdev: thermal cooling device pointer.
>   *
> diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
> index bd955270d5aa..c156f5082758 100644
> --- a/include/linux/cpu_cooling.h
> +++ b/include/linux/cpu_cooling.h
> @@ -28,6 +28,9 @@
>  #include <linux/thermal.h>
>  #include <linux/cpumask.h>
> =20
> +typedef int (*get_static_t)(cpumask_t *cpumask, int interval,
> +			    unsigned long voltage, u32 *power);
> +
>  #ifdef CONFIG_CPU_THERMAL
>  /**
>   * cpufreq_cooling_register - function to create cpufreq cooling device.
> @@ -36,6 +39,10 @@
>  struct thermal_cooling_device *
>  cpufreq_cooling_register(const struct cpumask *clip_cpus);
> =20
> +struct thermal_cooling_device *
> +cpufreq_power_cooling_register(const struct cpumask *clip_cpus,
> +			       u32 capacitance, get_static_t plat_static_func);
> +
>  /**
>   * of_cpufreq_cooling_register - create cpufreq cooling device based on =
DT.
>   * @np: a valid struct device_node to the cooling device device tree nod=
e.
> @@ -45,6 +52,12 @@ cpufreq_cooling_register(const struct cpumask *clip_cp=
us);
>  struct thermal_cooling_device *
>  of_cpufreq_cooling_register(struct device_node *np,
>  			    const struct cpumask *clip_cpus);
> +
> +struct thermal_cooling_device *
> +of_cpufreq_power_cooling_register(struct device_node *np,
> +				  const struct cpumask *clip_cpus,
> +				  u32 capacitance,
> +				  get_static_t plat_static_func);
>  #else
>  static inline struct thermal_cooling_device *
>  of_cpufreq_cooling_register(struct device_node *np,
> @@ -52,6 +65,15 @@ of_cpufreq_cooling_register(struct device_node *np,
>  {
>  	return ERR_PTR(-ENOSYS);
>  }
> +
> +static inline struct thermal_cooling_device *
> +of_cpufreq_power_cooling_register(struct device_node *np,
> +				  const struct cpumask *clip_cpus,
> +				  u32 capacitance,
> +				  get_static_t plat_static_func)
> +{
> +	return NULL;
> +}
>  #endif
> =20
>  /**
> @@ -68,11 +90,28 @@ cpufreq_cooling_register(const struct cpumask *clip_c=
pus)
>  	return ERR_PTR(-ENOSYS);
>  }
>  static inline struct thermal_cooling_device *
> +cpufreq_power_cooling_register(const struct cpumask *clip_cpus,
> +			       u32 capacitance, get_static_t plat_static_func)
> +{
> +	return NULL;
> +}
> +
> +static inline struct thermal_cooling_device *
>  of_cpufreq_cooling_register(struct device_node *np,
>  			    const struct cpumask *clip_cpus)
>  {
>  	return ERR_PTR(-ENOSYS);
>  }
> +
> +static inline struct thermal_cooling_device *
> +of_cpufreq_power_cooling_register(struct device_node *np,
> +				  const struct cpumask *clip_cpus,
> +				  u32 capacitance,
> +				  get_static_t plat_static_func)
> +{
> +	return NULL;
> +}
> +
>  static inline
>  void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
>  {
> --=20
> 1.9.1
>=20

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUySKuAAoJEMLUO4d9pOJWWGUH/jJyzIpwycjb4UgCQ4sEYgo6
J3RWTlOXYFu8PsPBLMKYpZxwzWq2L75oHlTuZe4KUMzYNcwH/UeNQ/KkBwPBY3Tr
aLjWG5fjinI0sbMnSxsP5lUadPGLWDZx0VLNB8ysdvRWGz6bH8jou3wuMVCrkWbX
SQpQe4oSBimWZeYamDRZxr5D+qGroYuqVN7VA3QYR6nqCwDgnrswPJmwFigFem0/
K7e6VnU26T+3RSO6sGv4duLHzGZWKitKzO3UQDnHtVYTae/0E5nD3H9epiHg1Qqt
GS1k73mvQJ0Q+KADX4DOTsA5hY9fEOVxYfGAecSFXME92l42RhITq9GtszgDNzM=
=awcU
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
