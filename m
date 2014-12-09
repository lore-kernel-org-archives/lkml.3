Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbaLICUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 21:20:45 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:13785 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754329AbaLICUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 21:20:44 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44705543"
Message-ID: <54865D65.8030906@cn.fujitsu.com>
Date: Tue, 9 Dec 2014 10:24:37 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Anton Blanchard <anton@samba.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <tj@kernel.org>,
        <fengguang.wu@intel.com>, <rafael.j.wysocki@intel.com>,
        <yuyang.du@intel.com>, <lkp@01.org>, <yuanhan.liu@linux.intel.com>,
        <pjt@google.com>, <bsegall@google.com>, <daniel@numascale.com>,
        <subbaram@codeaurora.org>, <computersforpeace@gmail.com>,
        <sp@datera.io>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] kthread: kthread_bind fails to enforce CPU affinity (fixes
 kernel BUG at kernel/smpboot.c:134!)
References: <1418009221-12719-1-git-send-email-anton@samba.org> <20141208085405.730577a3@gandalf.local.home>
In-Reply-To: <20141208085405.730577a3@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2014 09:54 PM, Steven Rostedt wrote:
> On Mon,  8 Dec 2014 14:27:01 +1100
> Anton Blanchard <anton@samba.org> wrote:
> 
>> I have a busy ppc64le KVM box where guests sometimes hit the infamous
>> "kernel BUG at kernel/smpboot.c:134!" issue during boot:
>>
>> BUG_ON(td->cpu != smp_processor_id());
>>
>> Basically a per CPU hotplug thread scheduled on the wrong CPU. The oops
>> output confirms it:
>>
>> CPU: 0
>> Comm: watchdog/130
>>
>> The issue is in kthread_bind where we set the cpus_allowed mask, but do
>> not touch task_thread_info(p)->cpu. The scheduler assumes the previously
>> scheduled CPU is in the cpus_allowed mask, but in this case we are
>> moving a thread to another CPU so it is not.
>>
> 
> Does this happen always on boot up, and always with the watchdog thread?
> 
> I followed the logic that starts the watchdog threads.
> 
> watchdog_enable_all_cpus()
>   smpboot_register_percpu-thread() {
> 
>     for_each_online_cpu(cpu) { ... }
> 
> Where watchdog_enable_all_cpus() can be called by
> lockup_detector_init() before SMP is started, but also by
> proc_dowatchdog() which is called by the sysctl commands (after SMP is
> up and running).
> 
> I noticed there's no "get_online_cpus()" anywhere, although the
> unregister_percpu_thread() has it. Is it possible that we created a
> thread on a CPU that wasn't fully online yet?
> 
> Perhaps the following patch is needed? Even if this isn't the solution
> to this bug, it is probably needed as watchdog_enable_all_cpus() can be
> called after boot up too.
> 
> -- Steve


Hi, Steven, tglx

See this https://lkml.org/lkml/2014/7/30/804
"[PATCH] smpboot: add missing get_online_cpus() when register"


Thanks,
Lai

> 
> diff --git a/kernel/smpboot.c b/kernel/smpboot.c
> index eb89e1807408..60d35ac5d3f1 100644
> --- a/kernel/smpboot.c
> +++ b/kernel/smpboot.c
> @@ -279,6 +279,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
>  	unsigned int cpu;
>  	int ret = 0;
>  
> +	get_online_cpus();
>  	mutex_lock(&smpboot_threads_lock);
>  	for_each_online_cpu(cpu) {
>  		ret = __smpboot_create_thread(plug_thread, cpu);
> @@ -291,6 +292,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
>  	list_add(&plug_thread->list, &hotplug_threads);
>  out:
>  	mutex_unlock(&smpboot_threads_lock);
> +	put_online_cpus();
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> .
> 

