Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbbAFLBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:01:25 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55752 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbbAFLBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:01:22 -0500
Date: Tue, 6 Jan 2015 11:01:12 +0000
From: Javi Merino <javi.merino@arm.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>, Mark Brown <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v6 6/9] thermal: cpu_cooling: implement the power
 cooling device API
Message-ID: <20150106110112.GE2885@e104805>
References: <20141208125033.GB2980@e104805>
 <CAKohpokM_8Qm5YH0Xb=n95bP94Qreqpcd1fAyCD2W5u9Pd=ndg@mail.gmail.com>
 <20141208142217.GA1831@e104805>
 <CAKohpomy7=v_qE3B_+hhwdUE8MCJkV7gzmPpUOb==t1BuZAnAA@mail.gmail.com>
 <20141209103249.GB2891@e104805>
 <CAKohpokBVH2gnqBrDffPMcsYx6BNKFvMWkNM4D3DzU8nxb=-xw@mail.gmail.com>
 <20141209110043.GD2891@e104805>
 <20150102143720.GA10683@developer>
 <20150105165339.GB3042@e104805>
 <20150105204448.GB31247@developer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150105204448.GB31247@developer>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On Mon, Jan 05, 2015 at 08:44:53PM +0000, Eduardo Valentin wrote:
> On Mon, Jan 05, 2015 at 04:53:40PM +0000, Javi Merino wrote:
> > On Fri, Jan 02, 2015 at 02:37:23PM +0000, Eduardo Valentin wrote:
> > > On Tue, Dec 09, 2014 at 11:00:43AM +0000, Javi Merino wrote:
> > > > On Tue, Dec 09, 2014 at 10:36:46AM +0000, Viresh Kumar wrote:
> > > > > On 9 December 2014 at 16:02, Javi Merino <javi.merino@arm.com> wrote:
> > > > diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/th=
> > > ermal/cpu-cooling-api.txt
> > > > index fca24c931ec8..d438a900e374 100644
> > > > --- a/Documentation/thermal/cpu-cooling-api.txt
> > > > +++ b/Documentation/thermal/cpu-cooling-api.txt
[...]
> > > > +
> > > > +In this simplified representation our model becomes:
> > > > +
> > > > +Pdyn =3D Kd * Voltage^2 * Frequency * Utilisation
> > > > +
> > > > +Where Kd (capacitance) represents an indicative running time dynamic
> > > > +power coefficient in fundamental units of mW/MHz/uVolt^2
> > > > +
> > > 
> > > Do we have Kd (capacitance) reference values for ARM processors? Is it
> > > worth adding a few of them as an example table here?=20
> > 
> > The reference numbers correspond not only to a particular processor
> > (e.g. Cortex-A15) but to specific SoCs, as the implementation
> > technology plays a key role in this.  I'll see if we can share some
> > reference values for specific SoCs.
> 
> It does not need to be a extensive / exhaustive list. A small set of
> examples should do it.
> 
> > > Where does one find Kd values?
> > > 
> > > Just looking for pointers for platform driver writers (potential users
> > > of these APIs).
> > 
> > I understand your concern.  I'm afraid the best I can say here is "ask
> > the SoC vendor".
> 
> OK. Adding the above hint + a small set of examples should do it.

I'll do that then.

> > > > +2.2 Static power
> > > > +
> > > > +Static leakage power consumption depends on a number of factors.  For a
> > > > +given circuit implementation the primary factors are:
> > > > +
> > > > +- Time the circuit spends in each 'power state'
> > > > +- Temperature
> > > > +- Operating voltage
> > > > +- Process grade
> > > > +
> > > > +The time the circuit spends in each 'power state' for a given
> > > > +evaluation period at first order means OFF or ON.  However,
> > > > +'retention' states can also be supported that reduce power during
> > > > +inactive periods without loss of context.
> > > > +
> > > > +Note: The visibility of state entries to the OS can vary, according to
> > > > +platform specifics, and this can then impact the accuracy of a model
> > > > +based on OS state information alone.  It might be possible in some
> > > > +cases to extract more accurate information from system resources.
> > > > +
> > > > +The temperature, operating voltage and process 'grade' (slow to fast)
> > > > +of the circuit are all significant factors in static leakage power
> > > > +consumption.  All of these have complex relationships to static power.
> > > > +
> > > > +Circuit implementation specific factors include the chosen silicon
> > > > +process as well as the type, number and size of transistors in both
> > > > +the logic gates and any RAM elements included.
> > > > +
> > > > +The static power consumption modelling must take into account the
> > > > +power managed regions that are implemented.  Taking the example of an
> > > > +ARM processor cluster, the modelling would take into account whether
> > > > +each CPU can be powered OFF separately or if only a single power
> > > > +region is implemented for the complete cluster.
> > > > +
> > > > +In one view, there are others, a static power consumption model can
> > > > +then start from a set of reference values for each power managed
> > > > +region (e.g. CPU, Cluster/L2) in each state (e.g. ON, OFF) at an
> > > > +arbitrary process grade, voltage and temperature point.  These values
> > > > +are then scaled for all of the following: the time in each state, the
> > > > +process grade, the current temperature and the operating voltage.
> > > > +However, since both implementation specific and complex relationships
> > > > +dominate the estimate, the appropriate interface to the model from the
> > > > +cpu cooling device is to provide a function callback that calculates
> > > > +the static power in this platform.  When registering the cpu cooling
> > > > +device pass a function pointer that follows the `get_static_t`
> > > > +prototype:
> > > > +
> > > > +    u32 plat_get_static(cpumask_t *cpumask, unsigned long voltage);
> > > > +
> > > > +with `cpumask` a cpumask of the cpus involved in the calculation and
> > > > +`voltage` the voltage at which they are operating.
> > > > +
> > > 
> > > What is the expected behavior of 'plat_get_static' if a wrong parameter
> > > is passed? Say, a cpumask that is invalid or a unsupported voltage?
> > > Shall it return 0? Does 0 means error?
> > 
> > I guess returning 0 and pr_warn() would be the best approach.  There's
> > no point in propagating an error since the upper layers can't really
> > do anything about it (other than maybe the governor ignoring this
> > cooling device?).
> > 
> 
> Yeah, governors may ignore them. IMO, that is the best expected
> behavior, instead of using wrong values silently.

Ok, I'll propagate the error then so that governors know about it and
can ignore it.

> > I'll clarify it in the documentation.
> 
> cool.
> 
> > 
> > > Besides, how is the platform code supposed to return the estimate, given
> > > it depends on time spent in state, and we are not passing any info about
> > > time here?
> > 
> > Ok, I'll look into passing the time here.
> > 
> 
> nice!
> 
> > > Same question applies to temperature.
> > 
> > The problem here is that the cpu cooling device does not know the
> > temperature of the processor.  It may or may not be the temperature of
> > the thermal zone.  The platform code is the best place to determine
> > the thermal zone whose sensor is closer to the processor and get its
> > temperature.
> > 
> > Alternatively, the thermal zone for the sensor that is closer to the
> > cpu could be passed when the cpu cooling device is registered and that
> > could be used to pass the cpu's temperature to the plat_get_static()
> > function.  Do you prefer this approach?
> 
> I believe the former is better. You may leave to platform layer to
> request temperature from appropriate thermal zone (s) and then deriving the
> correct extrapolated temperature. 
> 
> However, the way the document text is now may confuse readers. We should
> mention in the text how to get temperature, given that it is not passed
> by the API.

Ok, I'll clarify the documentation and include part of what I said up
there.

> > >                                                      For voltage, we are
> > > passing as parameter. For process grade, well, platform code is probably
> > > best point to determine it, so, no need.
> > > 
> > > > +If `plat_static_func` is NULL, static power is considered to be
> > > > +negligible for this platform and only dynamic power is considered.
> > > > +
> > > > +The platform specific callback can then use any combination of tables
> > > > +and/or equations to permute the estimated value.  Process grade
> > > > +information is not passed to the model since access to such data, from
> > > > +on-chip measurement capability or manufacture time data, is platform
> > > > +specific.
> > > > +
> > > 
> > > agreed
> > > 
> > > > +Note: the significance of static power for CPUs in comparison to
> > > > +dynamic power is highly dependent on implementation.  Given the
> > > > +potential complexity in implementation, the importance and accuracy of
> > > > +its inclusion when using cpu cooling devices should be assessed on a
> > > > +case by cases basis.
> > > > +
> > > > diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> > > > index ad09e51ffae4..959a103d18ba 100644
> > > > --- a/drivers/thermal/cpu_cooling.c
> > > > +++ b/drivers/thermal/cpu_cooling.c
> > > > @@ -24,11 +24,25 @@
> > > >  #include <linux/thermal.h>
> > > >  #include <linux/cpufreq.h>
> > > >  #include <linux/err.h>
> > > > +#include <linux/pm_opp.h>
> > > >  #include <linux/slab.h>
> > > >  #include <linux/cpu.h>
> > > >  #include <linux/cpu_cooling.h>
> > > > =20
> > > >  /**
> > > > + * struct power_table - frequency to power conversion
> > > > + * @frequency:	frequency in KHz
> > > > + * @power:	power in mW
> > > > + *
> > > > + * This structure is built when the cooling device registers and helps
> > > > + * in translating frequency to power and viceversa.
> > > > + */
> > > > +struct power_table {
> > > > +	u32 frequency;
> > > > +	u32 power;
> > > > +};
> > > > +
> > > > +/**
> > > >   * struct cpufreq_cooling_device - data for cooling device with cpufreq
> > > >   * @id: unique integer value corresponding to each cpufreq_cooling_device
> > > >   *	registered.
> > > > @@ -39,6 +53,15 @@
> > > >   * @cpufreq_val: integer value representing the absolute value of the cl=
> > > ipped
> > > >   *	frequency.
> > > >   * @allowed_cpus: all the cpus involved for this cpufreq_cooling_device.
> > > > + * @last_load: load measured by the latest call to cpufreq_get_actual_po=
> > > wer()
> > > > + * @time_in_idle: previous reading of the absolute time that this cpu wa=
> > > s idle
> > > > + * @time_in_idle_timestamp: wall time of the last invocation of
> > > > + *	get_cpu_idle_time_us()
> > > > + * @dyn_power_table: array of struct power_table for frequency to power
> > > > + *	conversion
> > > 
> > > 
> > > Is this ordered somehow? Is it worth mentioning?
> > 
> > It's in ascending ordered.  It's documented in
> > build_dyn_power_table().
> > 
> 
> I see.. but the field here needs to be documented too, don't you
> agree? I would mention here also that this field is expected to be
> ordered. Just for the sake of having a good kernel doc entry.

Fair enough, I'll include it here as well.

> > > > + * @dyn_power_table_entries: number of entries in the @dyn_power_table a=
> > > rray
> > > > + * @cpu_dev: the first cpu_device from @allowed_cpus that has OPPs regis=
> > > tered
> > > > + * @plat_get_static_power: callback to calculate the static power
> > > >   *
> > > >   * This structure is required for keeping information of each
> > > >   * cpufreq_cooling_device registered. In order to prevent corruption of =
> > > this a
> > > > @@ -51,6 +74,13 @@ struct cpufreq_cooling_device {
> > > >  	unsigned int cpufreq_val;
> > > >  	struct cpumask allowed_cpus;
> > > >  	struct list_head node;
> > > > +	u32 last_load;
> > > > +	u64 time_in_idle[NR_CPUS];
> > > > +	u64 time_in_idle_timestamp[NR_CPUS];
> > > > +	struct power_table *dyn_power_table;
> > > > +	int dyn_power_table_entries;
> > > > +	struct device *cpu_dev;
> > > > +	get_static_t plat_get_static_power;
> > > >  };
> > > >  static DEFINE_IDR(cpufreq_idr);
> > > >  static DEFINE_MUTEX(cooling_cpufreq_lock);
> > > > @@ -338,6 +368,204 @@ static int cpufreq_thermal_notifier(struct notifier=
> > > _block *nb,
> > > >  	return 0;
> > > >  }
> > > > =20
> > > > +/**
> > > > + * build_dyn_power_table() - create a dynamic power to frequency table
> > > > + * @cpufreq_device:	the cpufreq cooling device in which to store the tab=
> > > le
> > > > + * @capacitance: dynamic power coefficient for these cpus
> > > > + *
> > > > + * Build a dynamic power to frequency table for this cpu and store it
> > > > + * in @cpufreq_device.  This table will be used in cpu_power_to_freq() a=
> > > nd
> > > > + * cpu_freq_to_power() to convert between power and frequency
> > > > + * efficiently.  Power is stored in mW, frequency in KHz.  The
> > > > + * resulting table is in ascending order.
> > > 
> > > by which parameter? Do we assume a increasing convex relation between
> > > power and frequency?
> > 
> > By both parameters.  If frequency increases, power increases.  There's
> > no point in building a system that for lower frequencies you get
> > higher power consumption, right?  It's the worst of both worlds.
> 
> OK. Agreed, let's not make it overcomplicated.

Good

> > > > + *
> > > > + * Return: 0 on success, -E* on error.
> > > > + */
> > > > +static int build_dyn_power_table(struct cpufreq_cooling_device *cpufreq_=
> > > device,
> > > > +				u32 capacitance)
> > > > +{
> > > > +	struct power_table *power_table;
> > > > +	struct dev_pm_opp *opp;
> > > > +	struct device *dev =3D NULL;
> > > > +	int num_opps =3D 0, cpu, i, ret =3D 0;
> > > > +	unsigned long freq;
> > > > +
> > > > +	rcu_read_lock();
> > > > +
> > > > +	for_each_cpu(cpu, &cpufreq_device->allowed_cpus) {
> > > > +		dev =3D get_cpu_device(cpu);
> > > > +		if (!dev) {
> > > > +			dev_warn(&cpufreq_device->cool_dev->device,
> > > > +				"No cpu device for cpu %d\n", cpu);
> > > > +			continue;
> > > > +		}
> > > > +
> > > > +		num_opps =3D dev_pm_opp_get_opp_count(dev);
> > > > +		if (num_opps > 0) {
> > > > +			break;
> > > > +		} else if (num_opps < 0) {
> > > > +			ret =3D num_opps;
> > > > +			goto unlock;
> > > > +		}
> > > > +	}
> > > > +
> > > > +	if (num_opps =3D=3D 0) {
> > > > +		ret =3D -EINVAL;
> > > > +		goto unlock;
> > > > +	}
> > > > +
> > > > +	power_table =3D devm_kcalloc(&cpufreq_device->cool_dev->device, num_opp=
> > > s,
> > > > +				sizeof(*power_table), GFP_KERNEL);
> > > > +
> > > > +	for (freq =3D 0, i =3D 0;
> > > > +	     opp =3D dev_pm_opp_find_freq_ceil(dev, &freq), !IS_ERR(opp);
> > > > +	     freq++, i++) {
> > > > +		u32 freq_mhz, voltage_mv;
> > > > +		u64 power;
> > > > +
> > > > +		freq_mhz =3D freq / 1000000;
> > > > +		voltage_mv =3D dev_pm_opp_get_voltage(opp) / 1000;
> > > > +
> > > > +		/*
> > > > +		 * Do the multiplication with MHz and millivolt so as
> > > > +		 * to not overflow.
> > > > +		 */
> > > > +		power =3D (u64)capacitance * freq_mhz * voltage_mv * voltage_mv;
> > > > +		do_div(power, 1000000000);
> > > > +
> > > > +		/* frequency is stored in power_table in KHz */
> > > > +		power_table[i].frequency =3D freq / 1000;
> > > 
> > > Why do we have a comment about freq unit but no comment about power unit? :=
> > > -)
> > 
> > It's in the documentation of the function.  I can repeat it here if
> > you want.
> 
> Well, I would say, you either comment both here, or remove the above.

I'll repeat it here then.

> > > > +}
> > > > +
> > > > +/**
> > > > + * get_dynamic_power() - calculate the dynamic power
> > > > + * @cpufreq_device:	&cpufreq_cooling_device for this cdev
> > > > + * @freq:	current frequency
> > > > + *
> > > 
> > > No description?
> > 
> > Well, the short description in the first line reads "calculate the
> > dynamic power" and the return value is "the dynamic power consumed by
> > the cpus described by @cpufreq_device".  There's really nothing more
> > that can be said about this function.
> 
> 
> Yeah, but kerneldoc still complains about entries without descriptions
> (and without Return: entries too, or missing parameter descriptions).
> So, you should describe the entry properly, with all required fields.

Ok, ok, I'll add a sentence as long description.

> > > > + * Return: the dynamic power consumed by the cpus described by
> > > > + * @cpufreq_device.
> > > > + */
> > > > +static u32 get_dynamic_power(struct cpufreq_cooling_device *cpufreq_devi=
> > > ce,
> > > > +			unsigned long freq)
> > > > +{
> > > > +	u32 raw_cpu_power;
> > > > +
> > > > +	raw_cpu_power =3D cpu_freq_to_power(cpufreq_device, freq);
> > > > +	return (raw_cpu_power * cpufreq_device->last_load) / 100;
> > > > +}
> > > > +
> > > >  /* cpufreq cooling device callback functions are defined below */
> > > > =20
> > > >  /**
> > > > @@ -407,8 +635,106 @@ static int cpufreq_set_cur_state(struct thermal_coo=
> > > ling_device *cdev,
> > > >  	return cpufreq_apply_cooling(cpufreq_device, state);
> > > >  }
> > > > =20
> > > > +/**
> > > > + * cpufreq_get_actual_power() - get the current power
> > > > + * @cdev:	&thermal_cooling_device pointer
> > > > + *
> > > 
> > > ditto.
> > > 
> > > those should generate kerneldoc warns. Can you please run kerneldoc
> > > script in your patch? make sure it does not add warns / errors.
> > 
> > It doesn't because the description is "Return the current power
> > consumption of the cpus in milliwatts."  Again, I don't see what else
> > can be said about these functions.
> 
> 
> I see, then you must include a 'Return:' section for this kerneldoc
> entry.
> 
> > 
> > > > + * Return the current power consumption of the cpus in milliwatts.
> > > > + */
> > > > +static u32 cpufreq_get_actual_power(struct thermal_cooling_device *cdev)
> > > > +{
> > > > +	unsigned long freq;
> > > > +	int cpu;
> > > > +	u32 static_power, dynamic_power, total_load =3D 0;
> > > > +	struct cpufreq_cooling_device *cpufreq_device =3D cdev->devdata;
> > > > +
> > > > +	freq =3D cpufreq_quick_get(cpumask_any(&cpufreq_device->allowed_cpus));
> > > > +
> > > > +	for_each_cpu(cpu, &cpufreq_device->allowed_cpus) {
> > > > +		u32 load;
> > > > +
> > > > +		if (cpu_online(cpu))
> > > > +			load =3D get_load(cpufreq_device, cpu);
> > > > +		else
> > > > +			load =3D 0;
> > > > +
> > > > +		total_load +=3D load;
> > > > +	}
> > > > +
> > > > +	cpufreq_device->last_load =3D total_load;
> > > > +
> > > > +	static_power =3D get_static_power(cpufreq_device, freq);
> > > > +	dynamic_power =3D get_dynamic_power(cpufreq_device, freq);
> > > > +
> > > > +	return static_power + dynamic_power;
> > > > +}
> > > > +
> > > > +/**
> > > > + * cpufreq_state2power() - convert a cpu cdev state to power consumed
> > > > + * @cdev:	&thermal_cooling_device pointer
> > > > + * @state:	cooling device state to be converted
> > > > + *
> > > > + * Convert cooling device state @state into power consumption in milliwa=
> > > tts.
> > > 
> > > Considering 100% of utilization, right?
> > > 
> > > 
> > > Return: ?
> > 
> > Ok, I'll add:
> > 
> > Return: the power consumption.
> 
> 
> Is there any fail case? 

There will be now that I'm going to return 0 or error on failure and
the power will be returned in a parameter.

> > > > + */
> > > > +static u32 cpufreq_state2power(struct thermal_cooling_device *cdev,
> > > > +			unsigned long state)
> > > > +{
> > > > +	unsigned int freq, num_cpus;
> > > > +	cpumask_t cpumask;
> > > > +	u32 static_power, dynamic_power;
> > > > +	struct cpufreq_cooling_device *cpufreq_device =3D cdev->devdata;
> > > > +
> > > > +	cpumask_and(&cpumask, &cpufreq_device->allowed_cpus, cpu_online_mask);
> > > > +	num_cpus =3D cpumask_weight(&cpumask);
> > > > +
> > > > +	freq =3D get_cpu_frequency(cpumask_any(&cpumask), state);
> > > > +	if (!freq)
> > > > +		return 0;
> 
> Looks like 0 means 0 mW and error situation, this needs to go into
> kernel doc.

Similar to above.

> > > > +
> > > > +	static_power =3D get_static_power(cpufreq_device, freq);
> > > > +	dynamic_power =3D cpu_freq_to_power(cpufreq_device, freq) * num_cpus;
> > > > +
> > > > +	return static_power + dynamic_power;
> > > > +}
> > > > +
> > > > +/**
> > > > + * cpufreq_power2state() - convert power to a cooling device state
> > > > + * @cdev:	&thermal_cooling_device pointer
> > > > + * @power:	power in milliwatts to be converted
> > > > + *
> > > > + * Calculate a cooling device state for the cpus described by @cdev
> > > > + * that would allow them to consume at most @power mW.
> > > 
> > > Return: ?=20
> > 
> > I'll add:
> > 
> > Return: the cooling device state
> 
> Fail case?

Same as above.

> > > > + */
> > > > +static unsigned long cpufreq_power2state(struct thermal_cooling_device *=
> > > cdev,
> > > > +					u32 power)
> > > > +{
> > > > +	unsigned int cpu, cur_freq, target_freq;
> > > > +	s32 dyn_power;
> > > > +	u32 last_load, normalised_power;
> > > > +	unsigned long cdev_state;
> > > > +	struct cpufreq_cooling_device *cpufreq_device =3D cdev->devdata;
> > > > +
> > > > +	cpu =3D cpumask_any_and(&cpufreq_device->allowed_cpus, cpu_online_mask);
> > > > +
> > > > +	cur_freq =3D cpufreq_quick_get(cpu);
> > > > +	dyn_power =3D power - get_static_power(cpufreq_device, cur_freq);
> > > > +	dyn_power =3D dyn_power > 0 ? dyn_power : 0;
> > > > +	last_load =3D cpufreq_device->last_load ?: 1;
> > > > +	normalised_power =3D (dyn_power * 100) / last_load;
> > > > +	target_freq =3D cpu_power_to_freq(cpufreq_device, normalised_power);
> > > > +
> > > 
> > > 
> > > I got confused with the description vs. the implementation here.
> > > Description says, a calculation from cooling device state to power. But
> > > calling this function twice for the same power value, in different
> > > moments, with difference cpu loads, (may) return different states
> > > between calls.. Can you please improve description?
> > 
> > Sure, I'll update the documentation.
> > 
> > > > +	cdev_state =3D cpufreq_cooling_get_level(cpu, target_freq);
> > > > +	if (cdev_state =3D=3D THERMAL_CSTATE_INVALID) {
> > > > +		pr_err_ratelimited("Failed to convert %dKHz for cpu %d into a cdev sta=
> > > te\n",
> > > > +				target_freq, cpu);
> > > > +		return 0;
> > > 
> > > How about passing state as parameter and allowing the API to return an
> > > error code?
> > 
> > You are right, it makes the cpufreq cooling device API more
> > consistent.  I'll make cpufreq_state2power() and cpufreq_power2state()
> > return 0 or error code and pass the power/state in a parameter.
> > 
> 
> good.
> 

[...]
> > > > diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
> > > > index c303d383def1..5c4f4567acf0 100644
> > > > --- a/include/linux/cpu_cooling.h
> > > > +++ b/include/linux/cpu_cooling.h
> > > > @@ -28,6 +28,8 @@
> > > >  #include <linux/thermal.h>
> > > >  #include <linux/cpumask.h>
> > > > =20
> > > > +typedef u32 (*get_static_t)(cpumask_t *cpumask, unsigned long voltage);
> > > > +
> > > >  #ifdef CONFIG_CPU_THERMAL
> > > >  /**
> > > >   * cpufreq_cooling_register - function to create cpufreq cooling device.
> > > > @@ -37,14 +39,38 @@ struct thermal_cooling_device *
> > > >  cpufreq_cooling_register(const struct cpumask *clip_cpus);
> > > > =20
> > > >  /**
> > > > + * cpufreq_power_cooling_register() - create cpufreq cooling device with=
> > >  power extensions
> > > > + * @clip_cpus: cpumask of cpus where the frequency constraints will happ=
> > > en
> > > > + * @capacitance:	dynamic power coefficient for these cpus
> > > > + * @plat_static_func:	function to calculate the static power consumed by=
> > >  these
> > > > + *			cpus (optional)
> > > > + */
> > > > +struct thermal_cooling_device *
> > > > +cpufreq_power_cooling_register(const struct cpumask *clip_cpus,
> > > > +			u32 capacitance, get_static_t plat_static_func);
> > > > +
> > > > +#ifdef CONFIG_THERMAL_OF
> > > > +/**
> > > >   * of_cpufreq_cooling_register - create cpufreq cooling device based on =
> > > DT.
> > > >   * @np: a valid struct device_node to the cooling device device tree nod=
> > > e.
> > > >   * @clip_cpus: cpumask of cpus where the frequency constraints will happ=
> > > en
> > > >   */
> > > > -#ifdef CONFIG_THERMAL_OF
> > > >  struct thermal_cooling_device *
> > > >  of_cpufreq_cooling_register(struct device_node *np,
> > > >  			    const struct cpumask *clip_cpus);
> > > > +
> > > > +/**
> > > > + * of_cpufreq_power_cooling_register() - create cpufreq cooling device w=
> > > ith power extensions
> > > > + * @np:	a valid struct device_node to the cooling device device tree node
> > > > + * @clip_cpus:	cpumask of cpus where the frequency constraints will happ=
> > > en
> > > > + * @capacitance:	dynamic power coefficient for these cpus
> > > > + * @plat_static_func:	function to calculate the static power consumed by=
> > >  these
> > > > + *			cpus (optional)
> > > > + */
> > > 
> > > I think we should avoid duplicating kernel doc entries.=20
> > 
> > I totally agree, but I was just trying to be consistent.
> > cpufreq_cooling_register() and cpufreq_cooling_unregister() have
> > kernel doc entries here and in cpu_cooling.c.  I'm happy to send a
> > patch that removes the duplicated kernel doc for
> > cpufreq_cooling_register() and friends in include/linux/cpu_cooling.h
> > and drop the duplication from this patch as well.
> 
> I should have one removing them here:
> https://git.kernel.org/cgit/linux/kernel/git/evalenti/linux.git/commit/?h=thermal-docbook&id=5ea03ddc0ba1a4cadcfdc8954f1ccce0013eddb3
> 
> I will post the series soon.

Great, then I'll remove the redundant entries here in my patch.

Cheers,
Javi
