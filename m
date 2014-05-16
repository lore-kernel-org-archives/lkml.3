Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbaEPRcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:32:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46657 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbaEPRcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:32:31 -0400
Date: Fri, 16 May 2014 18:32:26 +0100
From: Javi Merino <javi.merino@arm.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>, edubezval@gmail.com,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>
Subject: Re: [RFC PATCH 2/5] thermal: cpu_cooling: Add notifications support
 for the clients
Message-ID: <20140516173226.GE2856@e102654-lin.cambridge.arm.com>
References: <1399559880-20562-1-git-send-email-amit.daniel@samsung.com>
 <1399559880-20562-3-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
In-Reply-To: <1399559880-20562-3-git-send-email-amit.daniel@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 16 May 2014 17:32:37.0702 (UTC) FILETIME=[D4A38660:01CF712C]
X-MC-Unique: 114051618322900201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Thu, May 08, 2014 at 03:37:57PM +0100, Amit Daniel Kachhap wrote:
> This patch adds notification support for those clients of cpu_cooling
> APIs which may want to do something interesting after receiving these
> cpu_cooling events. The notifier structure passed is of both Set/Get type.
> The notfications events can be of type,
> 1. CPU_COOLING_SET_STATE_PRE
> 2. CPU_COOLING_SET_STATE_POST
> 3. CPU_COOLING_GET_CUR_STATE
> 4. CPU_COOLING_GET_MAX_STATE
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
> +	cooling_state = cpufreq_device->request_status.new_state;
>  
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

I think this should all be inside the "if (count > 0)".  If not, then
remove it, as it is dead code now.

Cheers,
Javi

