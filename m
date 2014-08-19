Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaHSNpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:45:51 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63289 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHSNpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:45:49 -0400
Date: Tue, 19 Aug 2014 09:45:52 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        punit.agrawal@arm.com, broonie@kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v5 08/10] thermal: introduce the Power Allocator
 governor
Message-ID: <20140819134552.GB4628@developer>
References: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
 <1405001928-12697-9-git-send-email-javi.merino@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405001928-12697-9-git-send-email-javi.merino@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javi,

On Thu, Jul 10, 2014 at 03:18:46PM +0100, Javi Merino wrote:
> The power allocator governor is a thermal governor that controls system
> and device power allocation to control temperature.  Conceptually, the
> implementation divides the sustainable power of a thermal zone among
> all the heat sources in that zone.
> 
> This governor relies on "power actors", entities that represent heat
> sources.  They can report current and maximum power consumption and
> can set a given maximum power consumption, usually via a cooling
> device.
> 
> The governor uses a Proportional Integral Derivative (PID) controller
> driven by the temperature of the thermal zone.  The output of the
> controller is a power budget that is then allocated to each power
> actor that can have bearing on the temperature we are trying to
> control.  It decides how much power to give each cooling device based
> on the performance they are requesting.  The PID controller ensures
> that the total power budget does not exceed the control temperature.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> ---
>  Documentation/thermal/power_allocator.txt |  61 ++++
>  drivers/thermal/Kconfig                   |  15 +
>  drivers/thermal/Makefile                  |   1 +
>  drivers/thermal/power_allocator.c         | 467 ++++++++++++++++++++++++++++++
>  drivers/thermal/thermal_core.c            |   7 +-
>  drivers/thermal/thermal_core.h            |   8 +
>  include/linux/thermal.h                   |   8 +
>  7 files changed, 566 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/thermal/power_allocator.txt
>  create mode 100644 drivers/thermal/power_allocator.c
> 
> diff --git a/Documentation/thermal/power_allocator.txt b/Documentation/thermal/power_allocator.txt
> new file mode 100644
> index 000000000000..1859074dadcb
> --- /dev/null
> +++ b/Documentation/thermal/power_allocator.txt
> @@ -0,0 +1,61 @@
> +Integration of the power_allocator governor in a platform
> +=========================================================
> +
> +Registering thermal_zone_device
> +-------------------------------
> +
> +An estimate of the sustainable dissipatable power (in mW) should be
> +provided while registering the thermal zone.  This is the maximum
> +sustained power for allocation at the desired maximum temperature.
> +This number can vary for different conditions, but the closed-loop of
> +the controller should take care of those variations, the
> +`sustainable_power` should be an estimation of it.  Register your
> +thermal zone with `thermal_zone_params` that have a
> +`sustainable_power`.  If you weren't passing any
> +`thermal_zone_params`, then something like this will do:
> +
> +	static const struct thermal_zone_params tz_params = {
> +		.sustainable_power = 3500,
> +	};
> +
> +and then pass `tz_params` as the 5th parameter to
> +`thermal_zone_device_register()`
> +
> +Trip points
> +-----------
> +
> +The governor requires the following two trip points:
> +
> +1.  "switch on" trip point: temperature above which the governor
> +    control loop starts operating
> +2.  "desired temperature" trip point: it should be higher than the
> +    "switch on" trip point. It is the target temperature the governor
> +    is controlling for.
> +
> +The trip points can be either active or passive.
> +

I would prefer, for the sake of keeping the right concept in use, you
state here that they are passive trip points.

> +Power actors
> +------------
> +
> +Devices controlled by this governor must be registered with the power
> +actor API.  Read `power_actor.txt` for more information about them.
> +
> +Limitations of the power allocator governor
> +===========================================
> +
> +The power allocator governor can't work with cooling devices directly.
> +A power actor can be created to interface between the governor and the
> +cooling device (see cpu_actor.c for an example).  Otherwise, if you
> +have power actors and cooling devices that are next to the same
> +thermal sensor create two thermal zones, one for each type.  Use the
> +power allocator governor for the power actor thermal zone with the
> +power actors and any other governor for the one with cooling devices.
> +
> +The power allocator governor's PID controller is highly dependent on a
> +periodic tick.  If you have a driver that calls
> +`thermal_zone_device_update()` (or anything that ends up calling the
> +governor's `throttle()` function) repetitively, the governor response
> +won't be very good.  Note that this is not particular to this
> +governor, step-wise will also misbehave if you call its throttle()
> +faster than the normal thermal framework tick (due to interrupts for
> +example) as it will overreact.

I would recommend rephrasing the paragraph above, as I mentioned in
other email, looks like a documented bug. Mentioning that the governor
is still dependent on polling_delay active_delay is still worth it.
Also, the coexistance of interrupt driven thermal zones with polling
driven framework requires the interrupt firing to be configure to
something meaneanful, such as, an event outside the temperature range
the current trip is. 

> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 249b196deffd..0e76c0dab5f3 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -71,6 +71,14 @@ config THERMAL_DEFAULT_GOV_USER_SPACE
>  	  Select this if you want to let the user space manage the
>  	  platform thermals.
>  
> +config THERMAL_DEFAULT_GOV_POWER_ALLOCATOR
> +	bool "power_allocator"
> +	select THERMAL_GOV_POWER_ALLOCATOR
> +	help
> +	  Select this if you want to control temperature based on
> +	  system and device power allocation. This governor relies on
> +	  power actors to operate.
> +
>  endchoice
>  
>  config THERMAL_GOV_FAIR_SHARE
> @@ -89,6 +97,13 @@ config THERMAL_GOV_USER_SPACE
>  	help
>  	  Enable this to let the user space manage the platform thermals.
>  
> +config THERMAL_GOV_POWER_ALLOCATOR
> +	bool "Power allocator thermal governor"
> +	select THERMAL_POWER_ACTOR
> +	help
> +	  Enable this to manage platform thermals by dynamically
> +	  allocating and limiting power to devices.
> +
>  config THERMAL_POWER_ACTOR
>  	bool
>  
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index 74f97c90a46c..e74d57d0fe61 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -13,6 +13,7 @@ thermal_sys-$(CONFIG_THERMAL_OF)		+= of-thermal.o
>  thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
>  thermal_sys-$(CONFIG_THERMAL_GOV_STEP_WISE)	+= step_wise.o
>  thermal_sys-$(CONFIG_THERMAL_GOV_USER_SPACE)	+= user_space.o
> +thermal_sys-$(CONFIG_THERMAL_GOV_POWER_ALLOCATOR)	+= power_allocator.o
>  
>  # power actors
>  obj-$(CONFIG_THERMAL_POWER_ACTOR) += power_actor.o
> diff --git a/drivers/thermal/power_allocator.c b/drivers/thermal/power_allocator.c
> new file mode 100644
> index 000000000000..eb1797cd859b
> --- /dev/null
> +++ b/drivers/thermal/power_allocator.c
> @@ -0,0 +1,467 @@
> +/*
> + * A power allocator to manage temperature
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
> +#define pr_fmt(fmt) "Power allocator: " fmt
> +
> +#include <linux/power_actor.h>
> +#include <linux/rculist.h>
> +#include <linux/slab.h>
> +#include <linux/thermal.h>
> +
> +#include "thermal_core.h"
> +
> +#define FRAC_BITS 8
> +#define int_to_frac(x) ((x) << FRAC_BITS)
> +#define frac_to_int(x) ((x) >> FRAC_BITS)
> +
> +/**
> + * mul_frac() - multiply two fixed-point numbers
> + * @x:	first multiplicand
> + * @y:	second multiplicand
> + *
> + * Return: the result of multiplying two fixed-point numbers.  The
> + * result is also a fixed-point number.
> + */
> +static inline s64 mul_frac(s64 x, s64 y)
> +{
> +	return (x * y) >> FRAC_BITS;
> +}
> +
> +enum power_allocator_trip_levels {
> +	TRIP_SWITCH_ON = 0,	/* Switch on PID controller */
> +	TRIP_MAX_DESIRED_TEMPERATURE, /* Temperature we are controlling for */
> +};
> +
> +/**
> + * struct power_allocator_params - parameters for the power allocator governor
> + * @k_po:	Proportional parameter of the PID controller when overshooting
> + *		(i.e., when temperature is below the target)
> + * @k_pi:	Proportional parameter of the PID controller when undershooting
> + * @k_i:	Integral parameter of the PID controller
> + * @k_d:	Derivative parameter of the PID controller

Po, Pi, i, and d were not documented in your document above. Did you
miss them?

Given that they are core part of the governor behavior, I'd suggest
having a section in its document about how to fine tune the constants.
Explain, for instance, if it is enough to fine tune per platform, and
if having constants defined at compilation time or at runtime are good
point to be documented.

> + * @integral_cutoff:	threshold below which the error is no longer accumulated
> +			in the PID controller
> + * @err_integral:	accumulated error in the PID controller.
> + * @prev_err:	error in the previous iteration of the PID controller.
> + *		Used to calculate the derivative term.
> + */
> +struct power_allocator_params {
> +	s32 k_po;
> +	s32 k_pu;
> +	s32 k_i;
> +	s32 k_d;
> +	s32 integral_cutoff;
> +	s32 err_integral;
> +	s32 prev_err;
> +};
> +
> +/**
> + * pid_controller() - PID controller
> + * @tz:	thermal zone we are operating in
> + * @current_temp:	the current temperature
> + * @control_temp:	the target temperature
> + * @max_allocatable_power:	maximum allocatable power for this thermal zone
> + *
> + * This PID controller increases the available power budget so that the
> + * temperature of the thermal zone gets as close as possible to
> + * @control_temp and limits the power if it exceeds it.  k_po is the
> + * proportional term when we are overshooting, k_pu is the
> + * proportional term when we are undershooting.  integral_cutoff is a
> + * threshold below which we stop accumulating the error.  The
> + * accumulated error is only valid if the requested power will make
> + * the system warmer.  If the system is mostly idle, there's no point
> + * in accumulating positive error.
> + *
> + * Return: The power budget for the next period.
> + */
> +static u32 pid_controller(struct thermal_zone_device *tz,
> +			unsigned long current_temp, unsigned long control_temp,
> +			u32 max_allocatable_power)
> +{
> +	s64 p, i, d, power_range;
> +	s32 err;
> +	struct power_allocator_params *params = tz->governor_data;
> +
> +	err = ((s32)control_temp - (s32)current_temp) / 1000;
> +	err = int_to_frac(err);
> +
> +	/* Calculate the proportional term */
> +	p = mul_frac(err < 0 ? params->k_po : params->k_pu, err);
> +
> +	/*
> +	 * Calculate the integral term
> +	 *
> +	 * if the error s less than cut off allow integration (but
> +	 * the integral is limited to max power)
> +	 *




> +	i = mul_frac(params->k_i, params->err_integral);
> +
> +	if (err < int_to_frac(params->integral_cutoff)) {
> +		s64 tmpi = mul_frac(params->k_i, err);
> +
> +		tmpi += i;
> +		if (tmpi <= int_to_frac(max_allocatable_power)) {
> +			i = tmpi;
> +			params->err_integral += err;
> +		}
> +	}
> +
> +	/*
> +	 * Calculate the derivative term
> +	 *
> +	 * We do err - prev_err, so with a positive k_d, a decreasing
> +	 * error (i.e. driving closer to the line) results in less
> +	 * power being applied, slowing down the controller)
> +	 */
> +	d = mul_frac(params->k_d, err - params->prev_err);
> +	params->prev_err = err;
> +
> +	power_range = p + i + d;
> +
> +	/* feed-forward the known sustainable dissipatable power */
> +	power_range = tz->tzp->sustainable_power + frac_to_int(power_range);
> +
> +	return clamp(power_range, (s64)0, (s64)max_allocatable_power);
> +}
> +
> +/**
> + * divvy_up_power() - divvy the allocated power between the actors
> + * @req_power:	each actor's requested power
> + * @max_power:	each actor's maximum available power
> + * @num_actors:	size of the @req_power, @max_power and @granted_power's array
> + * @total_req_power: sum of @req_power
> + * @power_range:	total allocated power
> + * @granted_power:	ouput array: each actor's granted power
> + *
> + * This function divides the total allocated power (@power_range)
> + * fairly between the actors.  It first tries to give each actor a
> + * share of the @power_range according to how much power it requested
> + * compared to the rest of the actors.  For example, if only one actor
> + * requests power, then it receives all the @power_range.  If
> + * three actors each requests 1mW, each receives a third of the
> + * @power_range.
> + *
> + * If any actor received more than their maximum power, then that
> + * surplus is re-divvied among the actors based on how far they are
> + * from their respective maximums.
> + *
> + * Granted power for each actor is written to @granted_power, which
> + * should've been allocated by the calling function.
> + */
> +static void divvy_up_power(u32 *req_power, u32 *max_power, int num_actors,
> +			u32 total_req_power, u32 power_range,
> +			u32 *granted_power)
> +{
> +	u32 extra_power, capped_extra_power, extra_actor_power[num_actors];
> +	int i;
> +
> +	if (!total_req_power) {
> +		/*
> +		 * Nobody requested anything, so just give everybody
> +		 * the maximum power
> +		 */
> +		for (i = 0; i < num_actors; i++)
> +			granted_power[i] = max_power[i];
> +
> +		return;
> +	}
> +
> +	capped_extra_power = 0;
> +	extra_power = 0;
> +	for (i = 0; i < num_actors; i++) {
> +		u64 req_range = req_power[i] * power_range;
> +
> +		granted_power[i] = div_u64(req_range, total_req_power);
> +
> +		if (granted_power[i] > max_power[i]) {
> +			extra_power += granted_power[i] - max_power[i];
> +			granted_power[i] = max_power[i];
> +		}
> +
> +		extra_actor_power[i] = max_power[i] - granted_power[i];
> +		capped_extra_power += extra_actor_power[i];
> +	}
> +
> +	if (!extra_power)
> +		return;
> +
> +	/*
> +	 * Re-divvy the reclaimed extra among actors based on
> +	 * how far they are from the max
> +	 */
> +	extra_power = min(extra_power, capped_extra_power);
> +	if (capped_extra_power > 0)
> +		for (i = 0; i < num_actors; i++)
> +			granted_power[i] += (extra_actor_power[i] *
> +					extra_power) / capped_extra_power;
> +}
> +
> +static int allocate_power(struct thermal_zone_device *tz,
> +			unsigned long current_temp, unsigned long control_temp)
> +{
> +	struct power_actor *actor;
> +	u32 *req_power, *max_power, *granted_power;
> +	u32 total_req_power, max_allocatable_power;
> +	u32 power_range;
> +	int i, num_actors, ret = 0;
> +
> +	mutex_lock(&tz->lock);
> +	rcu_read_lock();
> +
> +	num_actors = 0;
> +	list_for_each_entry_rcu(actor, &actor_list, actor_node)
> +		num_actors++;
> +
> +	req_power = devm_kcalloc(&tz->device, num_actors, sizeof(*req_power),
> +				GFP_KERNEL);
> +	if (!req_power) {
> +		ret = -ENOMEM;
> +		goto unlock;
> +	}
> +
> +	max_power = devm_kcalloc(&tz->device, num_actors, sizeof(*max_power),
> +				GFP_KERNEL);
> +	if (!max_power) {
> +		ret = -ENOMEM;
> +		goto free_req_power;
> +	}
> +
> +	granted_power = devm_kcalloc(&tz->device, num_actors,
> +				sizeof(*granted_power), GFP_KERNEL);
> +	if (!granted_power) {
> +		ret = -ENOMEM;
> +		goto free_max_power;
> +	}
> +
> +	i = 0;
> +	total_req_power = 0;
> +	max_allocatable_power = 0;
> +
> +	list_for_each_entry_rcu(actor, &actor_list, actor_node) {
> +		req_power[i] = actor->ops->get_req_power(actor, tz);
> +		total_req_power += req_power[i];
> +
> +		max_power[i] = actor->ops->get_max_power(actor, tz);
> +		max_allocatable_power += max_power[i];
> +
> +		i++;
> +	}
> +
> +	power_range = pid_controller(tz, current_temp, control_temp,
> +				max_allocatable_power);
> +
> +	divvy_up_power(req_power, max_power, num_actors, total_req_power,
> +		power_range, granted_power);
> +
> +	i = 0;
> +	list_for_each_entry_rcu(actor, &actor_list, actor_node) {
> +		actor->ops->set_power(actor, tz, granted_power[i]);
> +		i++;
> +	}
> +
> +	devm_kfree(&tz->device, granted_power);
> +free_max_power:
> +	devm_kfree(&tz->device, max_power);
> +free_req_power:
> +	devm_kfree(&tz->device, req_power);
> +unlock:
> +	rcu_read_unlock();
> +	mutex_unlock(&tz->lock);
> +
> +	return ret;
> +}
> +
> +static int check_trips(struct thermal_zone_device *tz)
> +{
> +	int ret;
> +	enum thermal_trip_type type;
> +
> +	if (tz->trips < 2)
> +		return -EINVAL;
> +
> +	ret = tz->ops->get_trip_type(tz, TRIP_SWITCH_ON, &type);
> +	if (ret)
> +		return ret;
> +
> +	if ((type != THERMAL_TRIP_PASSIVE) && (type != THERMAL_TRIP_ACTIVE))
> +		return -EINVAL;
> +
> +	ret = tz->ops->get_trip_type(tz, TRIP_MAX_DESIRED_TEMPERATURE, &type);
> +	if (ret)
> +		return ret;
> +
> +	if ((type != THERMAL_TRIP_PASSIVE) && (type != THERMAL_TRIP_ACTIVE))
> +		return -EINVAL;
> +
> +	return ret;
> +}
> +
> +static void reset_pid_controller(struct power_allocator_params *params)
> +{
> +	params->err_integral = 0;
> +	params->prev_err = 0;
> +}
> +
> +static void allow_maximum_power(struct thermal_zone_device *tz)
> +{
> +	struct power_actor *actor;
> +
> +	rcu_read_lock();
> +
> +	list_for_each_entry_rcu(actor, &actor_list, actor_node) {
> +		u32 max_power = actor->ops->get_max_power(actor, tz);
> +
> +		actor->ops->set_power(actor, tz, max_power);
> +	}
> +
> +	rcu_read_unlock();
> +}
> +
> +/**
> + * power_allocator_bind() - bind the power_allocator governor to a thermal zone
> + * @tz:	thermal zone to bind it to
> + *
> + * Check that the thermal zone is valid for this governor, that is, it
> + * has two thermal trips.  If so, initialize the PID controller
> + * parameters and bind it to the thermal zone.
> + *
> + * Return: 0 on success, -EINVAL if the trips were invalid or -ENOMEM
> + * if we ran out of memory.
> + */
> +static int power_allocator_bind(struct thermal_zone_device *tz)
> +{
> +	int ret;
> +	struct power_allocator_params *params;
> +	unsigned long switch_on_temp, control_temp;
> +	u32 temperature_threshold;
> +
> +	ret = check_trips(tz);
> +	if (ret) {
> +		dev_err(&tz->device,
> +			"thermal zone %s has the wrong number of trips for this governor\n",
> +			tz->type);
> +		return ret;
> +	}
> +
> +	if (!tz->tzp || !tz->tzp->sustainable_power) {
> +		dev_err(&tz->device,
> +			"power_allocator: missing sustainable_power\n");
> +		return -EINVAL;
> +	}
> +
> +	params = devm_kzalloc(&tz->device, sizeof(*params), GFP_KERNEL);
> +	if (!params)
> +		return -ENOMEM;
> +
> +	ret = tz->ops->get_trip_temp(tz, TRIP_SWITCH_ON, &switch_on_temp);
> +	if (ret)
> +		goto free;
> +
> +	ret = tz->ops->get_trip_temp(tz, TRIP_MAX_DESIRED_TEMPERATURE,
> +				&control_temp);
> +	if (ret)
> +		goto free;
> +
> +	temperature_threshold = (control_temp - switch_on_temp) / 1000;
> +
> +	params->k_po = int_to_frac(tz->tzp->sustainable_power) /
> +		temperature_threshold;
> +	params->k_pu = int_to_frac(2 * tz->tzp->sustainable_power) /
> +		temperature_threshold;
> +	params->k_i = int_to_frac(1);
> +	params->k_d = int_to_frac(0);
> +	params->integral_cutoff = 0;
> +
> +	reset_pid_controller(params);
> +
> +	tz->governor_data = params;
> +
> +	return 0;
> +
> +free:
> +	devm_kfree(&tz->device, params);
> +	return ret;
> +}
> +
> +static void power_allocator_unbind(struct thermal_zone_device *tz)
> +{
> +	dev_dbg(&tz->device, "Unbinding from thermal zone %d\n", tz->id);
> +	devm_kfree(&tz->device, tz->governor_data);
> +	tz->governor_data = NULL;
> +}
> +
> +static int power_allocator_throttle(struct thermal_zone_device *tz, int trip)
> +{
> +	int ret;
> +	unsigned long switch_on_temp, control_temp, current_temp;
> +	struct power_allocator_params *params = tz->governor_data;
> +
> +	/*
> +	 * We get called for every trip point but we only need to do
> +	 * our calculations once
> +	 */
> +	if (trip != TRIP_MAX_DESIRED_TEMPERATURE)
> +		return 0;
> +
> +	ret = thermal_zone_get_temp(tz, &current_temp);
> +	if (ret) {
> +		dev_warn(&tz->device, "Failed to get temperature: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = tz->ops->get_trip_temp(tz, TRIP_SWITCH_ON, &switch_on_temp);
> +	if (ret) {
> +		dev_warn(&tz->device,
> +			"Failed to get switch on temperature: %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (current_temp < switch_on_temp) {
> +		tz->passive = 0;
> +		reset_pid_controller(params);
> +		allow_maximum_power(tz);
> +		return 0;
> +	}
> +
> +	tz->passive = 1;
> +
> +	ret = tz->ops->get_trip_temp(tz, TRIP_MAX_DESIRED_TEMPERATURE,
> +				&control_temp);
> +	if (ret) {
> +		dev_warn(&tz->device,
> +			"Failed to get the maximum desired temperature: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	return allocate_power(tz, current_temp, control_temp);
> +}
> +
> +static struct thermal_governor thermal_gov_power_allocator = {
> +	.name		= "power_allocator",
> +	.bind_to_tz	= power_allocator_bind,
> +	.unbind_from_tz	= power_allocator_unbind,
> +	.throttle	= power_allocator_throttle,
> +};
> +
> +int thermal_gov_power_allocator_register(void)
> +{
> +	return thermal_register_governor(&thermal_gov_power_allocator);
> +}
> +
> +void thermal_gov_power_allocator_unregister(void)
> +{
> +	thermal_unregister_governor(&thermal_gov_power_allocator);
> +}
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 3da99dd80ad5..1415d3d8a9eb 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1857,7 +1857,11 @@ static int __init thermal_register_governors(void)
>  	if (result)
>  		return result;
>  
> -	return thermal_gov_user_space_register();
> +	result = thermal_gov_user_space_register();
> +	if (result)
> +		return result;
> +
> +	return thermal_gov_power_allocator_register();
>  }
>  
>  static void thermal_unregister_governors(void)
> @@ -1865,6 +1869,7 @@ static void thermal_unregister_governors(void)
>  	thermal_gov_step_wise_unregister();
>  	thermal_gov_fair_share_unregister();
>  	thermal_gov_user_space_unregister();
> +	thermal_gov_power_allocator_unregister();
>  }
>  
>  static int __init thermal_init(void)
> diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
> index 3db339fb636f..b24cde2c71cc 100644
> --- a/drivers/thermal/thermal_core.h
> +++ b/drivers/thermal/thermal_core.h
> @@ -77,6 +77,14 @@ static inline int thermal_gov_user_space_register(void) { return 0; }
>  static inline void thermal_gov_user_space_unregister(void) {}
>  #endif /* CONFIG_THERMAL_GOV_USER_SPACE */
>  
> +#ifdef CONFIG_THERMAL_GOV_POWER_ALLOCATOR
> +int thermal_gov_power_allocator_register(void);
> +void thermal_gov_power_allocator_unregister(void);
> +#else
> +static inline int thermal_gov_power_allocator_register(void) { return 0; }
> +static inline void thermal_gov_power_allocator_unregister(void) {}
> +#endif /* CONFIG_THERMAL_GOV_POWER_ALLOCATOR */
> +
>  /* device tree support */
>  #ifdef CONFIG_THERMAL_OF
>  int of_parse_thermal_zones(void);
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 1124b7a9358a..e01141261756 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -57,6 +57,8 @@
>  #define DEFAULT_THERMAL_GOVERNOR       "fair_share"
>  #elif defined(CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE)
>  #define DEFAULT_THERMAL_GOVERNOR       "user_space"
> +#elif defined(CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR)
> +#define DEFAULT_THERMAL_GOVERNOR       "power_allocator"
>  #endif
>  
>  struct thermal_zone_device;
> @@ -287,6 +289,12 @@ struct thermal_zone_params {
>  
>  	int num_tbps;	/* Number of tbp entries */
>  	struct thermal_bind_params *tbp;
> +
> +	/*
> +	 * Sustainable power (heat) that this thermal zone can dissipate in
> +	 * mW
> +	 */
> +	u32 sustainable_power;
>  };
>  
>  struct thermal_genl_event {
> -- 
> 1.9.1
> 
> 
