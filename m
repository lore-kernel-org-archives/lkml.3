Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbaEOSkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:40:47 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:50488 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaEOSkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:40:31 -0400
Date: Thu, 15 May 2014 14:45:34 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com,
        rjw@rjwysocki.net
Subject: Re: [RFC PATCH 2/5] thermal: cpu_cooling: Add notifications support
 for the clients
Message-ID: <20140515184534.GB3138@developer>
References: <1399559880-20562-1-git-send-email-amit.daniel@samsung.com>
 <1399559880-20562-3-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399559880-20562-3-git-send-email-amit.daniel@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Amit,


On Thu, May 08, 2014 at 08:07:57PM +0530, Amit Daniel Kachhap wrote:
> This patch adds notification support for those clients of cpu_cooling
> APIs which may want to do something interesting after receiving these
> cpu_cooling events. The notifier structure passed is of both Set/Get type.
> The notfications events can be of type,
> 1. CPU_COOLING_SET_STATE_PRE
> 2. CPU_COOLING_SET_STATE_POST
> 3. CPU_COOLING_GET_CUR_STATE
> 4. CPU_COOLING_GET_MAX_STATE

What do you think about expanding this feature to all cooling devices?

I mean, why should we restrict to cpu(freq) cooling?

The clock cooling device I posted (and that I plan to merge soon) should
also benefit of this infrastructure. The clock cooling is for the
context of other processing units, that do not benefit of cpufreq.


> 
> The advantages of these notfications is to differentiate between different
> P states in the cpufreq table and the cooling states. The clients of these
> events may group few P states into 1 cooling states. Also some more cooling
> states can be enabled when the maximum of P state is reached. Post notifications
> can be used for those cases.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/cpu_cooling.c |   99 +++++++++++++++++++++++++++++++++++++++-
>  include/linux/cpu_cooling.h   |   55 +++++++++++++++++++++++
>  2 files changed, 151 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 21f44d4..e2aeb36 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -50,6 +50,7 @@ struct cpufreq_cooling_device {
>  	unsigned int cpufreq_state;
>  	unsigned int cpufreq_val;
>  	struct cpumask allowed_cpus;
> +	struct cpufreq_cooling_status request_status;
>  	struct list_head node;
>  };
>  static DEFINE_IDR(cpufreq_idr);
> @@ -59,6 +60,8 @@ static DEFINE_MUTEX(cooling_cpufreq_lock);
>  #define NOTIFY_INVALID NULL
>  static struct cpufreq_cooling_device *notify_device;
>  
> +/* Notfier list to validates/updates the cpufreq cooling states */
> +static BLOCKING_NOTIFIER_HEAD(cpufreq_cooling_state_notifier_list);
>  /* A list to hold all the cpufreq cooling devices registered */
>  static LIST_HEAD(cpufreq_cooling_list);
>  
> @@ -266,6 +269,21 @@ static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
>  	return freq;
>  }
>  
> +static int
> +cpufreq_cooling_notify_states(struct cpufreq_cooling_status *request,
> +			enum cpu_cooling_state_ops op)
> +{
> +	/* Invoke the notifiers which have registered for this state change */
> +	if (op == CPU_COOLING_SET_STATE_PRE ||
> +		op == CPU_COOLING_SET_STATE_POST ||
> +		op == CPU_COOLING_GET_MAX_STATE ||
> +		op == CPU_COOLING_GET_CUR_STATE) {
> +		blocking_notifier_call_chain(
> +			&cpufreq_cooling_state_notifier_list, op, request);
> +	}
> +	return 0;
> +}
> +
>  /**
>   * cpufreq_apply_cooling - function to apply frequency clipping.
>   * @cpufreq_device: cpufreq_cooling_device pointer containing frequency
> @@ -285,9 +303,18 @@ static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
>  	struct cpumask *mask = &cpufreq_device->allowed_cpus;
>  	unsigned int cpu = cpumask_any(mask);
>  
> +	cpufreq_device->request_status.cur_state =
> +						cpufreq_device->cpufreq_state;
> +	cpufreq_device->request_status.new_state = cooling_state;
> +
> +	cpufreq_cooling_notify_states(&cpufreq_device->request_status,
> +					CPU_COOLING_SET_STATE_PRE);
> +

Can a listener block/abort/postpone a state transition?

> +	cooling_state = cpufreq_device->request_status.new_state;
>  

So you are proposing listeners can have control on target cpufreq state,
right? Or did I get it wrong?

I think we should have this better documented. Besides, if that is the
case, what happens if we have several listeners?

>  	/* Check if the old cooling action is same as new cooling action */
> -	if (cpufreq_device->cpufreq_state == cooling_state)
> +	if (cpufreq_device->cpufreq_state ==
> +				cpufreq_device->request_status.new_state)
>  		return 0;
>  
>  	clip_freq = get_cpu_frequency(cpu, cooling_state);
> @@ -304,7 +331,8 @@ static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
>  	}
>  
>  	notify_device = NOTIFY_INVALID;
> -
> +	cpufreq_cooling_notify_states(&cpufreq_device->request_status,
> +					CPU_COOLING_SET_STATE_POST);
>  	return 0;
>  }
>  
> @@ -383,6 +411,11 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
>  	if (count > 0)
>  		*state = count;
>  
> +	cpufreq_device->request_status.max_state = count;
> +	cpufreq_cooling_notify_states(&cpufreq_device->request_status,
> +					CPU_COOLING_GET_MAX_STATE);
> +	*state = cpufreq_device->request_status.max_state;
> +

same question here, who determines the priorities when several listeners
are present in the system?

>  	return ret;
>  }
>  
> @@ -410,8 +443,12 @@ static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
>  		/* Cooling device pointer not found */
>  		return -EINVAL;
>  	}
> +	cpufreq_device->request_status.cur_state =
> +						cpufreq_device->cpufreq_state;
> +	cpufreq_cooling_notify_states(&cpufreq_device->request_status,
> +					CPU_COOLING_GET_CUR_STATE);
>  

ditto.

> -	*state = cpufreq_device->cpufreq_state;
> +	*state = cpufreq_device->request_status.cur_state;
>  
>  	return 0;
>  }
> @@ -520,6 +557,7 @@ __cpufreq_cooling_register(struct device_node *np,
>  	}
>  	cpufreq_dev->cool_dev = cool_dev;
>  	cpufreq_dev->cpufreq_state = 0;
> +	cpufreq_dev->request_status.devdata = devdata;
>  	mutex_lock(&cooling_cpufreq_lock);
>  
>  	/* Register the notifier for first cpufreq cooling device */
> @@ -614,3 +652,58 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
>  	kfree(cpufreq_dev);
>  }
>  EXPORT_SYMBOL_GPL(cpufreq_cooling_unregister);
> +
> +/**
> + * cpufreq_cooling_register_notifier - register a driver with cpufreq cooling.
> + * @nb:	notifier function to register.
> + * @list: CPU_COOLING_STATE_NOTIFIER type.
> + *
> + * Add a driver to receive cpufreq cooling notifications like current state,
> + * max state and set state. The drivers after reading the events can perform
> + * some mapping between the P states and cooling states like grouping some P
> + * states into 1 cooling state.
> + *
> + * Return: 0 (success)
> + */
> +int cpufreq_cooling_register_notifier(struct notifier_block *nb,
> +					unsigned int list)
> +{
> +	int ret = 0;
> +	switch (list) {
> +	case CPU_COOLING_STATE_NOTIFIER:
> +		ret = blocking_notifier_chain_register(
> +				&cpufreq_cooling_state_notifier_list, nb);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(cpufreq_cooling_register_notifier);
> +
> +/**
> + * cpufreq_cooling_unregister_notifier - unregisters a driver with cpufreq
> + * cooling.
> + * @nb:	notifier function to unregister.
> + * @list: CPU_COOLING_STATE_NOTIFIER type.
> + *
> + * Removes a driver to receive further cpufreq cooling notifications.
> + *
> + * Return: 0 (success)
> + */
> +int cpufreq_cooling_unregister_notifier(struct notifier_block *nb,
> +					unsigned int list)
> +{
> +	int ret = 0;
> +	switch (list) {
> +	case CPU_COOLING_STATE_NOTIFIER:
> +		ret = blocking_notifier_chain_unregister(
> +				&cpufreq_cooling_state_notifier_list, nb);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(cpufreq_cooling_unregister_notifier);

The exported symbols must be documented under Documentation/ too.

> diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
> index aaef7d8..f786935 100644
> --- a/include/linux/cpu_cooling.h
> +++ b/include/linux/cpu_cooling.h
> @@ -28,6 +28,22 @@
>  #include <linux/thermal.h>
>  #include <linux/cpumask.h>
>  
> +#define CPU_COOLING_STATE_NOTIFIER	(0)
> +
> +enum cpu_cooling_state_ops {
> +	CPU_COOLING_SET_STATE_PRE,
> +	CPU_COOLING_SET_STATE_POST,
> +	CPU_COOLING_GET_CUR_STATE,
> +	CPU_COOLING_GET_MAX_STATE,
> +};
> +
> +struct cpufreq_cooling_status {
> +	unsigned long cur_state;
> +	unsigned long new_state;
> +	unsigned long max_state;
> +	void *devdata;
> +};
> +
>  #ifdef CONFIG_CPU_THERMAL
>  /**
>   * cpufreq_cooling_register - function to create cpufreq cooling device.
> @@ -62,6 +78,34 @@ of_cpufreq_cooling_register(struct device_node *np,
>  void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
>  
>  unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq);
> +
> +/**
> + * cpufreq_cooling_register_notifier - register a driver with cpufreq cooling.
> + * @nb:	notifier function to register.
> + * @list: CPU_COOLING_STATE_NOTIFIER type.
> + *
> + * Add a driver to receive cpufreq cooling notifications like current state,
> + * max state and set state. The drivers after reading the events can perform
> + * some mapping between the P states and cooling states like grouping some P
> + * states into 1 cooling state.
> + *
> + * Return: 0 (success)
> + */
> +int cpufreq_cooling_register_notifier(struct notifier_block *nb,
> +					unsigned int list);
> +
> +/**
> + * cpufreq_cooling_unregister_notifier - unregisters a driver with cpufreq
> + * cooling.
> + * @nb:	notifier function to unregister.
> + * @list: CPU_COOLING_STATE_NOTIFIER type.
> + *
> + * Removes a driver to receive further cpufreq cooling notifications.
> + *
> + * Return: 0 (success)
> + */
> +int cpufreq_cooling_unregister_notifier(struct notifier_block *nb,
> +					unsigned int list);
>  #else /* !CONFIG_CPU_THERMAL */
>  static inline struct thermal_cooling_device *
>  cpufreq_cooling_register(const struct cpumask *clip_cpus, void *devdata)
> @@ -84,6 +128,17 @@ unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq)
>  {
>  	return THERMAL_CSTATE_INVALID;
>  }
> +static inline int
> +cpufreq_cooling_register_notifier(struct notifier_block *nb, unsigned int list)
> +{
> +	return 0;
> +}
> +static inline int
> +cpufreq_cooling_unregister_notifier(struct notifier_block *nb,
> +					unsigned int list)
> +{
> +	return 0;
> +}
>  #endif	/* CONFIG_CPU_THERMAL */
>  
>  #endif /* __CPU_COOLING_H__ */
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
