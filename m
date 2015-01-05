Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbbAEQxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:53:51 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55492 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbbAEQxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:53:49 -0500
Date: Mon, 5 Jan 2015 16:53:40 +0000
From: Javi Merino <javi.merino@arm.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>, Mark Brown <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v6 6/9] thermal: cpu_cooling: implement the power
 cooling device API
Message-ID: <20150105165339.GB3042@e104805>
References: <1417806260-9264-7-git-send-email-javi.merino@arm.com>
 <CAOh2x==BKyS08th2d4r0Q2UGqhzAwj6sqOgFsH6J0pWup+OU_A@mail.gmail.com>
 <20141208125033.GB2980@e104805>
 <CAKohpokM_8Qm5YH0Xb=n95bP94Qreqpcd1fAyCD2W5u9Pd=ndg@mail.gmail.com>
 <20141208142217.GA1831@e104805>
 <CAKohpomy7=v_qE3B_+hhwdUE8MCJkV7gzmPpUOb==t1BuZAnAA@mail.gmail.com>
 <20141209103249.GB2891@e104805>
 <CAKohpokBVH2gnqBrDffPMcsYx6BNKFvMWkNM4D3DzU8nxb=-xw@mail.gmail.com>
 <20141209110043.GD2891@e104805>
 <20150102143720.GA10683@developer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150102143720.GA10683@developer>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 02:37:23PM +0000, Eduardo Valentin wrote:
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> Content-Transfer-Encoding: quoted-printable
> 
> Hello Javi,
> 
> Looks like the charset seams to be scrambled. Anyways, I will attempt to
> send a couple of feedback here..

Yes, some SMTP servers here are known to do that and I was using the
wrong one.  Sorry for that, it should not happen again.

> On Tue, Dec 09, 2014 at 11:00:43AM +0000, Javi Merino wrote:
> > On Tue, Dec 09, 2014 at 10:36:46AM +0000, Viresh Kumar wrote:
> > > On 9 December 2014 at 16:02, Javi Merino <javi.merino@arm.com> wrote:
> > > > Sorry but I don't follow.  __cpufreq_cooling_register() is passed a
> > > > clip_cpus mask, not a single cpu.  How do I get "the cpu for which
> > > > __cpufreq_cooling_register() is called" if not by looping through all
> > > > the cpus in the mask?
> > >=20
> > > Yeah, its np that is passed instead of cpu number. So, that wouldn't
> > > be usable. Also because of the limitations I explained earlier, it makes
> > > sense to iterate over all clip_cpus and finding which one owns OPPs.
> >=20
> > Ok, how about this then?  I've pasted the whole commit so as to avoid
> > confusion.
> 
> I should consider this one as V7 of this patch, probably..
> 
> >=20
> > diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/th=
> ermal/cpu-cooling-api.txt
> > index fca24c931ec8..d438a900e374 100644
> > --- a/Documentation/thermal/cpu-cooling-api.txt
> > +++ b/Documentation/thermal/cpu-cooling-api.txt
> > @@ -25,8 +25,150 @@ the user. The registration APIs returns the cooling d=
> evice pointer.
> > =20
> >     clip_cpus: cpumask of cpus where the frequency constraints will happe=
> n.
> > =20
> > -1.1.2 void cpufreq_cooling_unregister(struct thermal_cooling_device *cde=
> v)
> > +1.1.2 struct thermal_cooling_device *cpufreq_power_cooling_register(
> > +    const struct cpumask *clip_cpus, u32 capacitance,
> > +    get_static_t plat_static_func)
> > +
> > +Similar to cpufreq_cooling_register, this function registers a cpufreq
> > +cooling device.  Using this function, the cooling device will
> > +implement the power extensions by using a simple cpu power model.  The
> > +cpus must have registered their OPPs using the OPP library.
> > +
> > +The additional parameters are needed for the power model (See 2. Power
> > +models).  "capacitance" is the dynamic power coefficient (See 2.1
> > +Dynamic power).  "plat_static_func" is a function to calculate the
> > +static power consumed by these cpus (See 2.2 Static power).
> > +
> > +1.1.3 struct thermal_cooling_device *of_cpufreq_power_cooling_register(
> > +    struct device_node *np, const struct cpumask *clip_cpus, u32 capacit=
> ance,
> > +    get_static_t plat_static_func)
> > +
> > +Similar to cpufreq_power_cooling_register, this function register a
> > +cpufreq cooling device with power extensions using the device tree
> > +information supplied by the np parameter.
> > +
> > +1.1.4 void cpufreq_cooling_unregister(struct thermal_cooling_device *cde=
> v)
> > =20
> >      This interface function unregisters the "thermal-cpufreq-%x" cooling=
>  device.
> > =20
> >      cdev: Cooling device pointer which has to be unregistered.
> > +
> > +2. Power models
> > +
> > +The power API registration functions provide a simple power model for
> > +CPUs.  The current power is calculated as dynamic + (optionally)
> > +static power.  This power model requires that the operating-points of
> > +the CPUs are registered using the kernel's opp library and the
> > +`cpufreq_frequency_table` is assigned to the `struct device` of the
> > +cpu.  If you are using the `cpufreq-cpu0.c` driver then the
> 
> cpufreq-cpu0.c is the old version of cpufreq-dt.c, right? I would
> suggest using CONFIG_* names instead of file names though.

Ok.

> > +`cpufreq_frequency_table` should already be assigned to the cpu
> > +device.
> > +
> > +The `plat_static_func` parameter of `cpufreq_power_cooling_register()`
> > +and `of_cpufreq_power_cooling_register()` is optional.  If you don't
> > +provide it, only dynamic power will be considered.
> > +
> > +2.1 Dynamic power
> > +
> > +The dynamic power consumption of a processor depends on many factors.
> > +For a given processor implementation the primary factors are:
> > +
> > +- The time the processor spends running, consuming dynamic power, as
> > +  compared to the time in idle states where dynamic consumption is
> > +  negligible.  Herein we refer to this as 'utilisation'.
> > +- The voltage and frequency levels as a result of DVFS.  The DVFS
> > +  level is a dominant factor governing power consumption.
> > +- In running time the 'execution' behaviour (instruction types, memory
> > +  access patterns and so forth) causes, in most cases, a second order
> > +  variation.  In pathological cases this variation can be significant,
> > +  but typically it is of a much lesser impact than the factors above.
> > +
> > +A high level dynamic power consumption model may then be represented as:
> > +
> > +Pdyn =3D f(run) * Voltage^2 * Frequency * Utilisation
> > +
> > +f(run) here represents the described execution behaviour and its
> > +result has a units of Watts/Hz/Volt^2 (this often expressed in
> > +mW/MHz/uVolt^2)
> > +
> > +The detailed behaviour for f(run) could be modelled on-line.  However,
> > +in practice, such an on-line model has dependencies on a number of
> > +implementation specific processor support and characterisation
> > +factors.  Therefore, in initial implementation that contribution is
> > +represented as a constant coefficient.  This is a simplification
> > +consistent with the relative contribution to overall power variation.
> > +
> > +In this simplified representation our model becomes:
> > +
> > +Pdyn =3D Kd * Voltage^2 * Frequency * Utilisation
> > +
> > +Where Kd (capacitance) represents an indicative running time dynamic
> > +power coefficient in fundamental units of mW/MHz/uVolt^2
> > +
> 
> Do we have Kd (capacitance) reference values for ARM processors? Is it
> worth adding a few of them as an example table here?=20

The reference numbers correspond not only to a particular processor
(e.g. Cortex-A15) but to specific SoCs, as the implementation
technology plays a key role in this.  I'll see if we can share some
reference values for specific SoCs.

> Where does one find Kd values?
> 
> Just looking for pointers for platform driver writers (potential users
> of these APIs).

I understand your concern.  I'm afraid the best I can say here is "ask
the SoC vendor".

> > +2.2 Static power
> > +
> > +Static leakage power consumption depends on a number of factors.  For a
> > +given circuit implementation the primary factors are:
> > +
> > +- Time the circuit spends in each 'power state'
> > +- Temperature
> > +- Operating voltage
> > +- Process grade
> > +
> > +The time the circuit spends in each 'power state' for a given
> > +evaluation period at first order means OFF or ON.  However,
> > +'retention' states can also be supported that reduce power during
> > +inactive periods without loss of context.
> > +
> > +Note: The visibility of state entries to the OS can vary, according to
> > +platform specifics, and this can then impact the accuracy of a model
> > +based on OS state information alone.  It might be possible in some
> > +cases to extract more accurate information from system resources.
> > +
> > +The temperature, operating voltage and process 'grade' (slow to fast)
> > +of the circuit are all significant factors in static leakage power
> > +consumption.  All of these have complex relationships to static power.
> > +
> > +Circuit implementation specific factors include the chosen silicon
> > +process as well as the type, number and size of transistors in both
> > +the logic gates and any RAM elements included.
> > +
> > +The static power consumption modelling must take into account the
> > +power managed regions that are implemented.  Taking the example of an
> > +ARM processor cluster, the modelling would take into account whether
> > +each CPU can be powered OFF separately or if only a single power
> > +region is implemented for the complete cluster.
> > +
> > +In one view, there are others, a static power consumption model can
> > +then start from a set of reference values for each power managed
> > +region (e.g. CPU, Cluster/L2) in each state (e.g. ON, OFF) at an
> > +arbitrary process grade, voltage and temperature point.  These values
> > +are then scaled for all of the following: the time in each state, the
> > +process grade, the current temperature and the operating voltage.
> > +However, since both implementation specific and complex relationships
> > +dominate the estimate, the appropriate interface to the model from the
> > +cpu cooling device is to provide a function callback that calculates
> > +the static power in this platform.  When registering the cpu cooling
> > +device pass a function pointer that follows the `get_static_t`
> > +prototype:
> > +
> > +    u32 plat_get_static(cpumask_t *cpumask, unsigned long voltage);
> > +
> > +with `cpumask` a cpumask of the cpus involved in the calculation and
> > +`voltage` the voltage at which they are operating.
> > +
> 
> What is the expected behavior of 'plat_get_static' if a wrong parameter
> is passed? Say, a cpumask that is invalid or a unsupported voltage?
> Shall it return 0? Does 0 means error?

I guess returning 0 and pr_warn() would be the best approach.  There's
no point in propagating an error since the upper layers can't really
do anything about it (other than maybe the governor ignoring this
cooling device?).

I'll clarify it in the documentation.

> Besides, how is the platform code supposed to return the estimate, given
> it depends on time spent in state, and we are not passing any info about
> time here?

Ok, I'll look into passing the time here.

> Same question applies to temperature.

The problem here is that the cpu cooling device does not know the
temperature of the processor.  It may or may not be the temperature of
the thermal zone.  The platform code is the best place to determine
the thermal zone whose sensor is closer to the processor and get its
temperature.

Alternatively, the thermal zone for the sensor that is closer to the
cpu could be passed when the cpu cooling device is registered and that
could be used to pass the cpu's temperature to the plat_get_static()
function.  Do you prefer this approach?

>                                                      For voltage, we are
> passing as parameter. For process grade, well, platform code is probably
> best point to determine it, so, no need.
> 
> > +If `plat_static_func` is NULL, static power is considered to be
> > +negligible for this platform and only dynamic power is considered.
> > +
> > +The platform specific callback can then use any combination of tables
> > +and/or equations to permute the estimated value.  Process grade
> > +information is not passed to the model since access to such data, from
> > +on-chip measurement capability or manufacture time data, is platform
> > +specific.
> > +
> 
> agreed
> 
> > +Note: the significance of static power for CPUs in comparison to
> > +dynamic power is highly dependent on implementation.  Given the
> > +potential complexity in implementation, the importance and accuracy of
> > +its inclusion when using cpu cooling devices should be assessed on a
> > +case by cases basis.
> > +
> > diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> > index ad09e51ffae4..959a103d18ba 100644
> > --- a/drivers/thermal/cpu_cooling.c
> > +++ b/drivers/thermal/cpu_cooling.c
> > @@ -24,11 +24,25 @@
> >  #include <linux/thermal.h>
> >  #include <linux/cpufreq.h>
> >  #include <linux/err.h>
> > +#include <linux/pm_opp.h>
> >  #include <linux/slab.h>
> >  #include <linux/cpu.h>
> >  #include <linux/cpu_cooling.h>
> > =20
> >  /**
> > + * struct power_table - frequency to power conversion
> > + * @frequency:	frequency in KHz
> > + * @power:	power in mW
> > + *
> > + * This structure is built when the cooling device registers and helps
> > + * in translating frequency to power and viceversa.
> > + */
> > +struct power_table {
> > +	u32 frequency;
> > +	u32 power;
> > +};
> > +
> > +/**
> >   * struct cpufreq_cooling_device - data for cooling device with cpufreq
> >   * @id: unique integer value corresponding to each cpufreq_cooling_device
> >   *	registered.
> > @@ -39,6 +53,15 @@
> >   * @cpufreq_val: integer value representing the absolute value of the cl=
> ipped
> >   *	frequency.
> >   * @allowed_cpus: all the cpus involved for this cpufreq_cooling_device.
> > + * @last_load: load measured by the latest call to cpufreq_get_actual_po=
> wer()
> > + * @time_in_idle: previous reading of the absolute time that this cpu wa=
> s idle
> > + * @time_in_idle_timestamp: wall time of the last invocation of
> > + *	get_cpu_idle_time_us()
> > + * @dyn_power_table: array of struct power_table for frequency to power
> > + *	conversion
> 
> 
> Is this ordered somehow? Is it worth mentioning?

It's in ascending ordered.  It's documented in
build_dyn_power_table().

> > + * @dyn_power_table_entries: number of entries in the @dyn_power_table a=
> rray
> > + * @cpu_dev: the first cpu_device from @allowed_cpus that has OPPs regis=
> tered
> > + * @plat_get_static_power: callback to calculate the static power
> >   *
> >   * This structure is required for keeping information of each
> >   * cpufreq_cooling_device registered. In order to prevent corruption of =
> this a
> > @@ -51,6 +74,13 @@ struct cpufreq_cooling_device {
> >  	unsigned int cpufreq_val;
> >  	struct cpumask allowed_cpus;
> >  	struct list_head node;
> > +	u32 last_load;
> > +	u64 time_in_idle[NR_CPUS];
> > +	u64 time_in_idle_timestamp[NR_CPUS];
> > +	struct power_table *dyn_power_table;
> > +	int dyn_power_table_entries;
> > +	struct device *cpu_dev;
> > +	get_static_t plat_get_static_power;
> >  };
> >  static DEFINE_IDR(cpufreq_idr);
> >  static DEFINE_MUTEX(cooling_cpufreq_lock);
> > @@ -338,6 +368,204 @@ static int cpufreq_thermal_notifier(struct notifier=
> _block *nb,
> >  	return 0;
> >  }
> > =20
> > +/**
> > + * build_dyn_power_table() - create a dynamic power to frequency table
> > + * @cpufreq_device:	the cpufreq cooling device in which to store the tab=
> le
> > + * @capacitance: dynamic power coefficient for these cpus
> > + *
> > + * Build a dynamic power to frequency table for this cpu and store it
> > + * in @cpufreq_device.  This table will be used in cpu_power_to_freq() a=
> nd
> > + * cpu_freq_to_power() to convert between power and frequency
> > + * efficiently.  Power is stored in mW, frequency in KHz.  The
> > + * resulting table is in ascending order.
> 
> by which parameter? Do we assume a increasing convex relation between
> power and frequency?

By both parameters.  If frequency increases, power increases.  There's
no point in building a system that for lower frequencies you get
higher power consumption, right?  It's the worst of both worlds.

> > + *
> > + * Return: 0 on success, -E* on error.
> > + */
> > +static int build_dyn_power_table(struct cpufreq_cooling_device *cpufreq_=
> device,
> > +				u32 capacitance)
> > +{
> > +	struct power_table *power_table;
> > +	struct dev_pm_opp *opp;
> > +	struct device *dev =3D NULL;
> > +	int num_opps =3D 0, cpu, i, ret =3D 0;
> > +	unsigned long freq;
> > +
> > +	rcu_read_lock();
> > +
> > +	for_each_cpu(cpu, &cpufreq_device->allowed_cpus) {
> > +		dev =3D get_cpu_device(cpu);
> > +		if (!dev) {
> > +			dev_warn(&cpufreq_device->cool_dev->device,
> > +				"No cpu device for cpu %d\n", cpu);
> > +			continue;
> > +		}
> > +
> > +		num_opps =3D dev_pm_opp_get_opp_count(dev);
> > +		if (num_opps > 0) {
> > +			break;
> > +		} else if (num_opps < 0) {
> > +			ret =3D num_opps;
> > +			goto unlock;
> > +		}
> > +	}
> > +
> > +	if (num_opps =3D=3D 0) {
> > +		ret =3D -EINVAL;
> > +		goto unlock;
> > +	}
> > +
> > +	power_table =3D devm_kcalloc(&cpufreq_device->cool_dev->device, num_opp=
> s,
> > +				sizeof(*power_table), GFP_KERNEL);
> > +
> > +	for (freq =3D 0, i =3D 0;
> > +	     opp =3D dev_pm_opp_find_freq_ceil(dev, &freq), !IS_ERR(opp);
> > +	     freq++, i++) {
> > +		u32 freq_mhz, voltage_mv;
> > +		u64 power;
> > +
> > +		freq_mhz =3D freq / 1000000;
> > +		voltage_mv =3D dev_pm_opp_get_voltage(opp) / 1000;
> > +
> > +		/*
> > +		 * Do the multiplication with MHz and millivolt so as
> > +		 * to not overflow.
> > +		 */
> > +		power =3D (u64)capacitance * freq_mhz * voltage_mv * voltage_mv;
> > +		do_div(power, 1000000000);
> > +
> > +		/* frequency is stored in power_table in KHz */
> > +		power_table[i].frequency =3D freq / 1000;
> 
> Why do we have a comment about freq unit but no comment about power unit? :=
> -)

It's in the documentation of the function.  I can repeat it here if
you want.

> > +		power_table[i].power =3D power;
> > +	}
> > +
> > +	if (i =3D=3D 0) {
> > +		ret =3D PTR_ERR(opp);
> > +		goto unlock;
> > +	}
> > +
> > +	cpufreq_device->cpu_dev =3D dev;
> > +	cpufreq_device->dyn_power_table =3D power_table;
> > +	cpufreq_device->dyn_power_table_entries =3D i;
> > +
> > +unlock:
> > +	rcu_read_unlock();
> > +	return ret;
> > +}
> > +
> > +static u32 cpu_freq_to_power(struct cpufreq_cooling_device *cpufreq_devi=
> ce,
> > +			     u32 freq)
> > +{
> > +	int i;
> > +	struct power_table *pt =3D cpufreq_device->dyn_power_table;
> > +
> > +	for (i =3D 1; i < cpufreq_device->dyn_power_table_entries; i++)
> > +		if (freq < pt[i].frequency)
> > +			break;
> > +
> > +	return pt[i - 1].power;
> > +}
> > +
> > +static u32 cpu_power_to_freq(struct cpufreq_cooling_device *cpufreq_devi=
> ce,
> > +			u32 power)
> > +{
> > +	int i;
> > +	struct power_table *pt =3D cpufreq_device->dyn_power_table;
> > +
> > +	for (i =3D 1; i < cpufreq_device->dyn_power_table_entries; i++)
> > +		if (power < pt[i].power)
> > +			break;
> > +
> > +	return pt[i - 1].frequency;
> > +}
> > +
> > +/**
> > + * get_load() - get load for a cpu since last updated
> > + * @cpufreq_device:	&struct cpufreq_cooling_device for this cpu
> > + * @cpu:	cpu number
> > + *
> > + * Return: The average load of cpu @cpu in percentage since this
> > + * function was last called.
> > + */
> > +static u32 get_load(struct cpufreq_cooling_device *cpufreq_device, int c=
> pu)
> > +{
> > +	u32 load;
> > +	u64 now, now_idle, delta_time, delta_idle;
> > +
> > +	now_idle =3D get_cpu_idle_time(cpu, &now, 0);
> > +	delta_idle =3D now_idle - cpufreq_device->time_in_idle[cpu];
> > +	delta_time =3D now - cpufreq_device->time_in_idle_timestamp[cpu];
> > +
> > +	if (delta_time <=3D delta_idle)
> > +		load =3D 0;
> > +	else
> > +		load =3D div64_u64(100 * (delta_time - delta_idle), delta_time);
> > +
> > +	cpufreq_device->time_in_idle[cpu] =3D now_idle;
> > +	cpufreq_device->time_in_idle_timestamp[cpu] =3D now;
> > +
> > +	return load;
> > +}
> > +
> > +/**
> > + * get_static_power() - calculate the static power consumed by the cpus
> > + * @cpufreq_device:	struct &cpufreq_cooling_device for this cpu cdev
> > + * @freq:	frequency in KHz
> > + *
> > + * Calculate the static power consumed by the cpus described by
> > + * @cpu_actor running at frequency @freq.  This function relies on a
> > + * platform specific function that should have been provided when the
> > + * actor was registered.  If it wasn't, the static power is assumed to
> > + * be negligible.
> > + *
> > + * Return: The static power consumed by the cpus.  It returns 0 on
> > + * error or if there is no plat_get_static_power().
> > + */
> > +static u32 get_static_power(struct cpufreq_cooling_device *cpufreq_devic=
> e,
> > +			unsigned long freq)
> > +{
> > +	struct dev_pm_opp *opp;
> > +	unsigned long voltage;
> > +	struct cpumask *cpumask =3D &cpufreq_device->allowed_cpus;
> > +	unsigned long freq_hz =3D freq * 1000;
> > +
> > +	if (!cpufreq_device->plat_get_static_power)
> > +		return 0;
> > +
> > +	rcu_read_lock();
> > +
> > +	opp =3D dev_pm_opp_find_freq_exact(cpufreq_device->cpu_dev, freq_hz,
> > +					true);
> > +	voltage =3D dev_pm_opp_get_voltage(opp);
> > +
> > +	rcu_read_unlock();
> > +
> > +	if (voltage =3D=3D 0) {
> > +		dev_warn_ratelimited(cpufreq_device->cpu_dev,
> > +				"Failed to get voltage for frequency %lu: %ld\n",
> > +				freq_hz, IS_ERR(opp) ? PTR_ERR(opp) : 0);
> > +		return 0;
> > +	}
> > +
> > +	return cpufreq_device->plat_get_static_power(cpumask, voltage);
> 
> temperature ? time in idle state ?

Replied above.

> > +}
> > +
> > +/**
> > + * get_dynamic_power() - calculate the dynamic power
> > + * @cpufreq_device:	&cpufreq_cooling_device for this cdev
> > + * @freq:	current frequency
> > + *
> 
> No description?

Well, the short description in the first line reads "calculate the
dynamic power" and the return value is "the dynamic power consumed by
the cpus described by @cpufreq_device".  There's really nothing more
that can be said about this function.

> > + * Return: the dynamic power consumed by the cpus described by
> > + * @cpufreq_device.
> > + */
> > +static u32 get_dynamic_power(struct cpufreq_cooling_device *cpufreq_devi=
> ce,
> > +			unsigned long freq)
> > +{
> > +	u32 raw_cpu_power;
> > +
> > +	raw_cpu_power =3D cpu_freq_to_power(cpufreq_device, freq);
> > +	return (raw_cpu_power * cpufreq_device->last_load) / 100;
> > +}
> > +
> >  /* cpufreq cooling device callback functions are defined below */
> > =20
> >  /**
> > @@ -407,8 +635,106 @@ static int cpufreq_set_cur_state(struct thermal_coo=
> ling_device *cdev,
> >  	return cpufreq_apply_cooling(cpufreq_device, state);
> >  }
> > =20
> > +/**
> > + * cpufreq_get_actual_power() - get the current power
> > + * @cdev:	&thermal_cooling_device pointer
> > + *
> 
> ditto.
> 
> those should generate kerneldoc warns. Can you please run kerneldoc
> script in your patch? make sure it does not add warns / errors.

It doesn't because the description is "Return the current power
consumption of the cpus in milliwatts."  Again, I don't see what else
can be said about these functions.

> > + * Return the current power consumption of the cpus in milliwatts.
> > + */
> > +static u32 cpufreq_get_actual_power(struct thermal_cooling_device *cdev)
> > +{
> > +	unsigned long freq;
> > +	int cpu;
> > +	u32 static_power, dynamic_power, total_load =3D 0;
> > +	struct cpufreq_cooling_device *cpufreq_device =3D cdev->devdata;
> > +
> > +	freq =3D cpufreq_quick_get(cpumask_any(&cpufreq_device->allowed_cpus));
> > +
> > +	for_each_cpu(cpu, &cpufreq_device->allowed_cpus) {
> > +		u32 load;
> > +
> > +		if (cpu_online(cpu))
> > +			load =3D get_load(cpufreq_device, cpu);
> > +		else
> > +			load =3D 0;
> > +
> > +		total_load +=3D load;
> > +	}
> > +
> > +	cpufreq_device->last_load =3D total_load;
> > +
> > +	static_power =3D get_static_power(cpufreq_device, freq);
> > +	dynamic_power =3D get_dynamic_power(cpufreq_device, freq);
> > +
> > +	return static_power + dynamic_power;
> > +}
> > +
> > +/**
> > + * cpufreq_state2power() - convert a cpu cdev state to power consumed
> > + * @cdev:	&thermal_cooling_device pointer
> > + * @state:	cooling device state to be converted
> > + *
> > + * Convert cooling device state @state into power consumption in milliwa=
> tts.
> 
> Considering 100% of utilization, right?
> 
> 
> Return: ?

Ok, I'll add:

Return: the power consumption.

> > + */
> > +static u32 cpufreq_state2power(struct thermal_cooling_device *cdev,
> > +			unsigned long state)
> > +{
> > +	unsigned int freq, num_cpus;
> > +	cpumask_t cpumask;
> > +	u32 static_power, dynamic_power;
> > +	struct cpufreq_cooling_device *cpufreq_device =3D cdev->devdata;
> > +
> > +	cpumask_and(&cpumask, &cpufreq_device->allowed_cpus, cpu_online_mask);
> > +	num_cpus =3D cpumask_weight(&cpumask);
> > +
> > +	freq =3D get_cpu_frequency(cpumask_any(&cpumask), state);
> > +	if (!freq)
> > +		return 0;
> > +
> > +	static_power =3D get_static_power(cpufreq_device, freq);
> > +	dynamic_power =3D cpu_freq_to_power(cpufreq_device, freq) * num_cpus;
> > +
> > +	return static_power + dynamic_power;
> > +}
> > +
> > +/**
> > + * cpufreq_power2state() - convert power to a cooling device state
> > + * @cdev:	&thermal_cooling_device pointer
> > + * @power:	power in milliwatts to be converted
> > + *
> > + * Calculate a cooling device state for the cpus described by @cdev
> > + * that would allow them to consume at most @power mW.
> 
> Return: ?=20

I'll add:

Return: the cooling device state

> > + */
> > +static unsigned long cpufreq_power2state(struct thermal_cooling_device *=
> cdev,
> > +					u32 power)
> > +{
> > +	unsigned int cpu, cur_freq, target_freq;
> > +	s32 dyn_power;
> > +	u32 last_load, normalised_power;
> > +	unsigned long cdev_state;
> > +	struct cpufreq_cooling_device *cpufreq_device =3D cdev->devdata;
> > +
> > +	cpu =3D cpumask_any_and(&cpufreq_device->allowed_cpus, cpu_online_mask);
> > +
> > +	cur_freq =3D cpufreq_quick_get(cpu);
> > +	dyn_power =3D power - get_static_power(cpufreq_device, cur_freq);
> > +	dyn_power =3D dyn_power > 0 ? dyn_power : 0;
> > +	last_load =3D cpufreq_device->last_load ?: 1;
> > +	normalised_power =3D (dyn_power * 100) / last_load;
> > +	target_freq =3D cpu_power_to_freq(cpufreq_device, normalised_power);
> > +
> 
> 
> I got confused with the description vs. the implementation here.
> Description says, a calculation from cooling device state to power. But
> calling this function twice for the same power value, in different
> moments, with difference cpu loads, (may) return different states
> between calls.. Can you please improve description?

Sure, I'll update the documentation.

> > +	cdev_state =3D cpufreq_cooling_get_level(cpu, target_freq);
> > +	if (cdev_state =3D=3D THERMAL_CSTATE_INVALID) {
> > +		pr_err_ratelimited("Failed to convert %dKHz for cpu %d into a cdev sta=
> te\n",
> > +				target_freq, cpu);
> > +		return 0;
> 
> How about passing state as parameter and allowing the API to return an
> error code?

You are right, it makes the cpufreq cooling device API more
consistent.  I'll make cpufreq_state2power() and cpufreq_power2state()
return 0 or error code and pass the power/state in a parameter.

> > +	}
> > +
> > +	return cdev_state;
> > +}
> > +
> >  /* Bind cpufreq callbacks to thermal cooling device ops */
> > -static struct thermal_cooling_device_ops const cpufreq_cooling_ops =3D {
> > +static struct thermal_cooling_device_ops cpufreq_cooling_ops =3D {
> 
> Why do we change the const?

Because below we do:

	if (capacitance) {
		cpufreq_cooling_ops.get_actual_power = cpufreq_get_actual_power;
		cpufreq_cooling_ops.state2power = cpufreq_state2power;
		cpufreq_cooling_ops.power2state = cpufreq_power2state;
...

> >  	.get_max_state =3D cpufreq_get_max_state,
> >  	.get_cur_state =3D cpufreq_get_cur_state,
> >  	.set_cur_state =3D cpufreq_set_cur_state,
> > @@ -434,7 +760,8 @@ static struct notifier_block thermal_cpufreq_notifier=
> _block =3D {
> >   */
> >  static struct thermal_cooling_device *
> >  __cpufreq_cooling_register(struct device_node *np,
> > -			   const struct cpumask *clip_cpus)
> > +			const struct cpumask *clip_cpus, u32 capacitance,
> > +			get_static_t plat_static_func)
> >  {
> >  	struct thermal_cooling_device *cool_dev;
> >  	struct cpufreq_cooling_device *cpufreq_dev =3D NULL;
> > @@ -464,10 +791,23 @@ __cpufreq_cooling_register(struct device_node *np,
> > =20
> >  	cpumask_copy(&cpufreq_dev->allowed_cpus, clip_cpus);
> > =20
> > +	if (capacitance) {
> > +		cpufreq_cooling_ops.get_actual_power =3D cpufreq_get_actual_power;
> > +		cpufreq_cooling_ops.state2power =3D cpufreq_state2power;
> > +		cpufreq_cooling_ops.power2state =3D cpufreq_power2state;
> > +		cpufreq_dev->plat_get_static_power =3D plat_static_func;
> > +
> > +		ret =3D build_dyn_power_table(cpufreq_dev, capacitance);
> > +		if (ret) {
> > +			cool_dev =3D ERR_PTR(ret);
> > +			goto free;
> > +		}
> > +	}
> > +
> >  	ret =3D get_idr(&cpufreq_idr, &cpufreq_dev->id);
> >  	if (ret) {
> > -		kfree(cpufreq_dev);
> > -		return ERR_PTR(-EINVAL);
> > +		cool_dev =3D ERR_PTR(-EINVAL);
> > +		goto free;
> >  	}
> > =20
> >  	snprintf(dev_name, sizeof(dev_name), "thermal-cpufreq-%d",
> > @@ -475,11 +815,8 @@ __cpufreq_cooling_register(struct device_node *np,
> > =20
> >  	cool_dev =3D thermal_of_cooling_device_register(np, dev_name, cpufreq_d=
> ev,
> >  						      &cpufreq_cooling_ops);
> > -	if (IS_ERR(cool_dev)) {
> > -		release_idr(&cpufreq_idr, cpufreq_dev->id);
> > -		kfree(cpufreq_dev);
> > -		return cool_dev;
> > -	}
> > +	if (IS_ERR(cool_dev))
> > +		goto release_idr;
> >  	cpufreq_dev->cool_dev =3D cool_dev;
> >  	cpufreq_dev->cpufreq_state =3D 0;
> >  	mutex_lock(&cooling_cpufreq_lock);
> > @@ -494,6 +831,12 @@ __cpufreq_cooling_register(struct device_node *np,
> >  	mutex_unlock(&cooling_cpufreq_lock);
> > =20
> >  	return cool_dev;
> > +
> > +release_idr:
> > +	release_idr(&cpufreq_idr, cpufreq_dev->id);
> > +free:
> > +	kfree(cpufreq_dev);
> > +	return cool_dev;
> >  }
> > =20
> >  /**
> > @@ -510,7 +853,7 @@ __cpufreq_cooling_register(struct device_node *np,
> >  struct thermal_cooling_device *
> >  cpufreq_cooling_register(const struct cpumask *clip_cpus)
> >  {
> > -	return __cpufreq_cooling_register(NULL, clip_cpus);
> > +	return __cpufreq_cooling_register(NULL, clip_cpus, 0, NULL);
> >  }
> >  EXPORT_SYMBOL_GPL(cpufreq_cooling_register);
> > =20
> > @@ -534,11 +877,77 @@ of_cpufreq_cooling_register(struct device_node *np,
> >  	if (!np)
> >  		return ERR_PTR(-EINVAL);
> > =20
> > -	return __cpufreq_cooling_register(np, clip_cpus);
> > +	return __cpufreq_cooling_register(np, clip_cpus, 0, NULL);
> >  }
> >  EXPORT_SYMBOL_GPL(of_cpufreq_cooling_register);
> > =20
> >  /**
> > + * cpufreq_power_cooling_register() - create cpufreq cooling device with=
>  power extensions
> > + * @clip_cpus:	cpumask of cpus where the frequency constraints will happ=
> en
> > + * @capacitance:	dynamic power coefficient for these cpus
> > + * @plat_static_func:	function to calculate the static power consumed by=
>  these
> > + *			cpus (optional)
> > + *
> > + * This interface function registers the cpufreq cooling device with
> > + * the name "thermal-cpufreq-%x".  This api can support multiple
> > + * instances of cpufreq cooling devices.  Using this function, the
> > + * cooling device will implement the power extensions by using a
> > + * simple cpu power model.  The cpus must have registered their OPPs
> > + * using the OPP library.
> > + *
> > + * An optional @plat_static_func may be provided to calculate the
> > + * static power consumed by these cpus.  If the platform's static
> > + * power consumption is unknown or negligible, make it NULL.
> > + *
> > + * Return: a valid struct thermal_cooling_device pointer on success,
> > + * on failure, it returns a corresponding ERR_PTR().
> > + */
> > +struct thermal_cooling_device *
> > +cpufreq_power_cooling_register(const struct cpumask *clip_cpus, u32 capa=
> citance,
> > +			get_static_t plat_static_func)
> > +{
> > +	return __cpufreq_cooling_register(NULL, clip_cpus, capacitance,
> > +				plat_static_func);
> > +}
> > +EXPORT_SYMBOL(cpufreq_power_cooling_register);
> > +
> > +/**
> > + * of_cpufreq_power_cooling_register() - create cpufreq cooling device w=
> ith power extensions
> > + * @np:	a valid struct device_node to the cooling device device tree node
> > + * @clip_cpus:	cpumask of cpus where the frequency constraints will happ=
> en
> > + * @capacitance:	dynamic power coefficient for these cpus
> > + * @plat_static_func:	function to calculate the static power consumed by=
>  these
> > + *			cpus (optional)
> > + *
> > + * This interface function registers the cpufreq cooling device with
> > + * the name "thermal-cpufreq-%x".  This api can support multiple
> > + * instances of cpufreq cooling devices.  Using this API, the cpufreq
> > + * cooling device will be linked to the device tree node provided.
> > + * Using this function, the cooling device will implement the power
> > + * extensions by using a simple cpu power model.  The cpus must have
> > + * registered their OPPs using the OPP library.
> > + *
> > + * An optional @plat_static_func may be provided to calculate the
> > + * static power consumed by these cpus.  If the platform's static
> > + * power consumption is unknown or negligible, make it NULL.
> > + *
> > + * Return: a valid struct thermal_cooling_device pointer on success,
> > + * on failure, it returns a corresponding ERR_PTR().
> > + */
> > +struct thermal_cooling_device *
> > +of_cpufreq_power_cooling_register(struct device_node *np,
> > +			const struct cpumask *clip_cpus, u32 capacitance,
> > +			get_static_t plat_static_func)
> > +{
> > +	if (!np)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	return __cpufreq_cooling_register(np, clip_cpus, capacitance,
> > +				plat_static_func);
> > +}
> > +EXPORT_SYMBOL(of_cpufreq_power_cooling_register);
> > +
> > +/**
> >   * cpufreq_cooling_unregister - function to remove cpufreq cooling devic=
> e.
> >   * @cdev: thermal cooling device pointer.
> >   *
> > diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
> > index c303d383def1..5c4f4567acf0 100644
> > --- a/include/linux/cpu_cooling.h
> > +++ b/include/linux/cpu_cooling.h
> > @@ -28,6 +28,8 @@
> >  #include <linux/thermal.h>
> >  #include <linux/cpumask.h>
> > =20
> > +typedef u32 (*get_static_t)(cpumask_t *cpumask, unsigned long voltage);
> > +
> >  #ifdef CONFIG_CPU_THERMAL
> >  /**
> >   * cpufreq_cooling_register - function to create cpufreq cooling device.
> > @@ -37,14 +39,38 @@ struct thermal_cooling_device *
> >  cpufreq_cooling_register(const struct cpumask *clip_cpus);
> > =20
> >  /**
> > + * cpufreq_power_cooling_register() - create cpufreq cooling device with=
>  power extensions
> > + * @clip_cpus: cpumask of cpus where the frequency constraints will happ=
> en
> > + * @capacitance:	dynamic power coefficient for these cpus
> > + * @plat_static_func:	function to calculate the static power consumed by=
>  these
> > + *			cpus (optional)
> > + */
> > +struct thermal_cooling_device *
> > +cpufreq_power_cooling_register(const struct cpumask *clip_cpus,
> > +			u32 capacitance, get_static_t plat_static_func);
> > +
> > +#ifdef CONFIG_THERMAL_OF
> > +/**
> >   * of_cpufreq_cooling_register - create cpufreq cooling device based on =
> DT.
> >   * @np: a valid struct device_node to the cooling device device tree nod=
> e.
> >   * @clip_cpus: cpumask of cpus where the frequency constraints will happ=
> en
> >   */
> > -#ifdef CONFIG_THERMAL_OF
> >  struct thermal_cooling_device *
> >  of_cpufreq_cooling_register(struct device_node *np,
> >  			    const struct cpumask *clip_cpus);
> > +
> > +/**
> > + * of_cpufreq_power_cooling_register() - create cpufreq cooling device w=
> ith power extensions
> > + * @np:	a valid struct device_node to the cooling device device tree node
> > + * @clip_cpus:	cpumask of cpus where the frequency constraints will happ=
> en
> > + * @capacitance:	dynamic power coefficient for these cpus
> > + * @plat_static_func:	function to calculate the static power consumed by=
>  these
> > + *			cpus (optional)
> > + */
> 
> I think we should avoid duplicating kernel doc entries.=20

I totally agree, but I was just trying to be consistent.
cpufreq_cooling_register() and cpufreq_cooling_unregister() have
kernel doc entries here and in cpu_cooling.c.  I'm happy to send a
patch that removes the duplicated kernel doc for
cpufreq_cooling_register() and friends in include/linux/cpu_cooling.h
and drop the duplication from this patch as well.

> > +struct thermal_cooling_device *
> > +of_cpufreq_power_cooling_register(struct device_node *np,
> > +				const struct cpumask *clip_cpus,
> > +				u32 capacitance, get_static_t plat_static_func);
> >  #else
> >  static inline struct thermal_cooling_device *
> >  of_cpufreq_cooling_register(struct device_node *np,
> > @@ -52,6 +78,14 @@ of_cpufreq_cooling_register(struct device_node *np,
> >  {
> >  	return NULL;
> >  }
> > +
> > +struct thermal_cooling_device *
> > +of_cpufreq_power_cooling_register(struct device_node *np,
> > +				const struct cpumask *clip_cpus,
> > +				u32 capacitance, get_static_t plat_static_func)
> 
> This is expected to be static inline.

Yes, I'll change it.

Thanks for reviewing a patch with such a horrible encoding,
Javi
