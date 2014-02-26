Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaBZBIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:08:38 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62182 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750933AbaBZBIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:08:36 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: tj@kernel.org, jolsa@redhat.com, oleg@redhat.com, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/Processor: Rework processor throttling with work_on_cpu()
Date: Wed, 26 Feb 2014 02:23:35 +0100
Message-ID: <3890679.FyyHKXfXOb@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392960945-30741-1-git-send-email-tianyu.lan@intel.com>
References: <20140220151721.GB32719@redhat.com> <1392960945-30741-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 21, 2014 01:35:45 PM Lan Tianyu wrote:
> acpi_processor_set_throttling() uses set_cpus_allowed_ptr() to make
> sure struct acpi_processor->acpi_processor_set_throttling() callback
> run on associated cpu. But the function maybe called in a worker which
> has been bound to a cpu. The patch is to replace set_cpus_allowed_ptr()
> with work_on_cpu().
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/acpi/processor_throttling.c | 70 +++++++++++++++++--------------------
>  1 file changed, 33 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
> index 28baa05..2db105a 100644
> --- a/drivers/acpi/processor_throttling.c
> +++ b/drivers/acpi/processor_throttling.c
> @@ -56,6 +56,12 @@ struct throttling_tstate {
>  	int target_state;		/* target T-state */
>  };
>  
> +struct acpi_processor_throttling_arg {
> +	struct acpi_processor *pr;
> +	int target_state;
> +	bool force;
> +};
> +
>  #define THROTTLING_PRECHANGE       (1)
>  #define THROTTLING_POSTCHANGE      (2)
>  
> @@ -1060,16 +1066,25 @@ static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
>  	return 0;
>  }
>  
> +static long acpi_processor_throttling_fn(void *data)
> +{
> +	struct acpi_processor_throttling_arg *arg = data;
> +	struct acpi_processor *pr = arg->pr;
> +	struct acpi_processor_throttling *p_throttling = &pr->throttling;
> +
> +	return p_throttling->acpi_processor_set_throttling(pr,
> +			arg->target_state, arg->force);

What about doing

	return pr->throttling.acpi_processor_set_throttling(...);

directly without using the extra p_throttling pointer?

> +}
> +
>  int acpi_processor_set_throttling(struct acpi_processor *pr,
>  						int state, bool force)
>  {
> -	cpumask_var_t saved_mask;
>  	int ret = 0;
>  	unsigned int i;
>  	struct acpi_processor *match_pr;
>  	struct acpi_processor_throttling *p_throttling;
> +	struct acpi_processor_throttling_arg arg;
>  	struct throttling_tstate t_state;
> -	cpumask_var_t online_throttling_cpus;
>  
>  	if (!pr)
>  		return -EINVAL;
> @@ -1080,14 +1095,6 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
>  	if ((state < 0) || (state > (pr->throttling.state_count - 1)))
>  		return -EINVAL;
>  
> -	if (!alloc_cpumask_var(&saved_mask, GFP_KERNEL))
> -		return -ENOMEM;
> -
> -	if (!alloc_cpumask_var(&online_throttling_cpus, GFP_KERNEL)) {
> -		free_cpumask_var(saved_mask);
> -		return -ENOMEM;
> -	}
> -
>  	if (cpu_is_offline(pr->id)) {
>  		/*
>  		 * the cpu pointed by pr->id is offline. Unnecessary to change
> @@ -1096,17 +1103,15 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
>  		return -ENODEV;
>  	}
>  
> -	cpumask_copy(saved_mask, &current->cpus_allowed);
>  	t_state.target_state = state;
>  	p_throttling = &(pr->throttling);
> -	cpumask_and(online_throttling_cpus, cpu_online_mask,
> -		    p_throttling->shared_cpu_map);
> +
>  	/*
>  	 * The throttling notifier will be called for every
>  	 * affected cpu in order to get one proper T-state.
>  	 * The notifier event is THROTTLING_PRECHANGE.
>  	 */
> -	for_each_cpu(i, online_throttling_cpus) {
> +	for_each_cpu_and(i, cpu_online_mask, p_throttling->shared_cpu_map) {
>  		t_state.cpu = i;
>  		acpi_processor_throttling_notifier(THROTTLING_PRECHANGE,
>  							&t_state);
> @@ -1118,21 +1123,18 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
>  	 * it can be called only for the cpu pointed by pr.
>  	 */
>  	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
> -		/* FIXME: use work_on_cpu() */
> -		if (set_cpus_allowed_ptr(current, cpumask_of(pr->id))) {
> -			/* Can't migrate to the pr->id CPU. Exit */
> -			ret = -ENODEV;
> -			goto exit;
> -		}
> -		ret = p_throttling->acpi_processor_set_throttling(pr,
> -						t_state.target_state, force);
> +		arg.pr = pr;
> +		arg.target_state = state;
> +		arg.force = force;
> +		ret = work_on_cpu(pr->id, acpi_processor_throttling_fn, &arg);
>  	} else {
>  		/*
>  		 * When the T-state coordination is SW_ALL or HW_ALL,
>  		 * it is necessary to set T-state for every affected
>  		 * cpus.
>  		 */
> -		for_each_cpu(i, online_throttling_cpus) {
> +		for_each_cpu_and(i, cpu_online_mask,
> +		    p_throttling->shared_cpu_map) {
>  			match_pr = per_cpu(processors, i);
>  			/*
>  			 * If the pointer is invalid, we will report the
> @@ -1153,13 +1155,12 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
>  					"on CPU %d\n", i));
>  				continue;
>  			}
> -			t_state.cpu = i;
> -			/* FIXME: use work_on_cpu() */
> -			if (set_cpus_allowed_ptr(current, cpumask_of(i)))
> -				continue;
> -			ret = match_pr->throttling.
> -				acpi_processor_set_throttling(
> -				match_pr, t_state.target_state, force);
> +
> +			arg.pr = match_pr;
> +			arg.target_state = state;
> +			arg.force = force;
> +			ret = work_on_cpu(pr->id, acpi_processor_throttling_fn,
> +				&arg);
>  		}
>  	}
>  	/*
> @@ -1168,17 +1169,12 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
>  	 * affected cpu to update the T-states.
>  	 * The notifier event is THROTTLING_POSTCHANGE
>  	 */
> -	for_each_cpu(i, online_throttling_cpus) {
> +	for_each_cpu_and(i, cpu_online_mask, p_throttling->shared_cpu_map) {
>  		t_state.cpu = i;
>  		acpi_processor_throttling_notifier(THROTTLING_POSTCHANGE,
>  							&t_state);
>  	}
> -	/* restore the previous state */
> -	/* FIXME: use work_on_cpu() */
> -	set_cpus_allowed_ptr(current, saved_mask);
> -exit:
> -	free_cpumask_var(online_throttling_cpus);
> -	free_cpumask_var(saved_mask);
> +
>  	return ret;
>  }
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
