Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3FXX0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:26:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17330 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3FXX0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:26:08 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=6_m7Rbag898A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=8uwyFV8zIU4A:10 a=YXXixupxd1DkEvLSfEYA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372116363.18733.189.camel@gandalf.local.home>
Subject: Re: [PATCH 04/45] CPU hotplug: Add infrastructure to check lacking
 hotplug synchronization
From: Steven Rostedt <rostedt@goodmis.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Mon, 24 Jun 2013 19:26:03 -0400
In-Reply-To: <20130623133841.19094.69631.stgit@srivatsabhat.in.ibm.com>
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com>
	 <20130623133841.19094.69631.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-23 at 19:08 +0530, Srivatsa S. Bhat wrote:


Just to make the code a little cleaner, can you add:

> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 860f51a..e90d9d7 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -63,6 +63,72 @@ static struct {
>  	.refcount = 0,
>  };
>  
> +#ifdef CONFIG_DEBUG_HOTPLUG_CPU
> +
> +static DEFINE_PER_CPU(unsigned long, atomic_reader_refcnt);
> +
> +static int current_is_hotplug_safe(const struct cpumask *mask)
> +{
> +
> +	/* If we are not dealing with cpu_online_mask, don't complain. */
> +	if (mask != cpu_online_mask)
> +		return 1;
> +
> +	/* If this is the task doing hotplug, don't complain. */
> +	if (unlikely(current == cpu_hotplug.active_writer))
> +		return 1;
> +
> +	/* If we are in early boot, don't complain. */
> +	if (system_state != SYSTEM_RUNNING)
> +		return 1;
> +
> +	/*
> +	 * Check if the current task is in atomic context and it has
> +	 * invoked get_online_cpus_atomic() to synchronize with
> +	 * CPU Hotplug.
> +	 */
> +	if (preempt_count() || irqs_disabled())
> +		return this_cpu_read(atomic_reader_refcnt);
> +	else
> +		return 1; /* No checks for non-atomic contexts for now */
> +}
> +
> +static inline void warn_hotplug_unsafe(void)
> +{
> +	WARN_ONCE(1, "Must use get/put_online_cpus_atomic() to synchronize"
> +		     " with CPU hotplug\n");
> +}
> +
> +/*
> + * Check if the task (executing in atomic context) has the required protection
> + * against CPU hotplug, while accessing the specified cpumask.
> + */
> +void check_hotplug_safe_cpumask(const struct cpumask *mask)
> +{
> +	if (!current_is_hotplug_safe(mask))
> +		warn_hotplug_unsafe();
> +}
> +EXPORT_SYMBOL_GPL(check_hotplug_safe_cpumask);
> +
> +/*
> + * Similar to check_hotplug_safe_cpumask(), except that we don't complain
> + * if the task (executing in atomic context) is testing whether the CPU it
> + * is executing on is online or not.
> + *
> + * (A task executing with preemption disabled on a CPU, automatically prevents
> + *  offlining that CPU, irrespective of the actual implementation of CPU
> + *  offline. So we don't enforce holding of get_online_cpus_atomic() for that
> + *  case).
> + */
> +void check_hotplug_safe_cpu(unsigned int cpu, const struct cpumask *mask)
> +{
> +	if(!current_is_hotplug_safe(mask) && cpu != smp_processor_id())
> +		warn_hotplug_unsafe();
> +}
> +EXPORT_SYMBOL_GPL(check_hotplug_safe_cpu);
> +

static inline void atomic_reader_refcnt_inc(void)
{
	this_cpu_inc(atomic_reader_refcnt);
}
static inline void atomic_reader_refcnt_dec(void)
{
	this_cpu_dec(atomic_reader_refcnt);
}

#else
static inline void atomic_reader_refcnt_inc(void)
{
}
static inline void atomic_reader_refcnt_dec(void)
{
}
#endif

> +#endif
> +
>  void get_online_cpus(void)
>  {
>  	might_sleep();
> @@ -189,13 +255,22 @@ unsigned int get_online_cpus_atomic(void)
>  	 * from going offline.
>  	 */
>  	preempt_disable();
> +
> +#ifdef CONFIG_DEBUG_HOTPLUG_CPU
> +	this_cpu_inc(atomic_reader_refcnt);
> +#endif

Replace the #ifdef with just:

	atomic_reader_refcnt_inc();

>  	return smp_processor_id();
>  }
>  EXPORT_SYMBOL_GPL(get_online_cpus_atomic);
>  
>  void put_online_cpus_atomic(void)
>  {
> +
> +#ifdef CONFIG_DEBUG_HOTPLUG_CPU
> +	this_cpu_dec(atomic_reader_refcnt);
> +#endif

And

	atomic_reader_refcnt_dec();

-- Steve

>  	preempt_enable();
> +
>  }
>  EXPORT_SYMBOL_GPL(put_online_cpus_atomic);
>  


