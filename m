Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaBJLQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:16:31 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42890 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaBJLQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:16:30 -0500
Message-ID: <52F8B3C8.4080802@linux.vnet.ibm.com>
Date: Mon, 10 Feb 2014 16:41:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: ego@linux.vnet.ibm.com
CC: Oleg Nesterov <oleg@redhat.com>, paulus@samba.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of	callback
 registration functions
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com> <20140206184103.GA31410@redhat.com> <20140207191125.GA8098@in.ibm.com> <52F898CB.6030900@linux.vnet.ibm.com> <20140210105130.GA14693@in.ibm.com>
In-Reply-To: <20140210105130.GA14693@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021011-5564-0000-0000-00000BEF5AF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 04:21 PM, Gautham R Shenoy wrote:
> On Mon, Feb 10, 2014 at 02:45:55PM +0530, Srivatsa S. Bhat wrote:
>> Hi Gautham,
>>
>> On 02/08/2014 12:41 AM, Gautham R Shenoy wrote:
>>> On Thu, Feb 06, 2014 at 07:41:03PM +0100, Oleg Nesterov wrote:
>>>> On 02/06, Srivatsa S. Bhat wrote:
>>>>>
>>>>> The following method of CPU hotplug callback registration is not safe
>>>>> due to the possibility of an ABBA deadlock involving the cpu_add_remove_lock
>>>>> and the cpu_hotplug.lock.
>>>>
[...]
>> get_online_cpus();  // acquire mutex; update counter; release mutex
>>
>> register_cpu_notifier(); // acquire cpu_add_remove_lock ...
>>
>> put_online_cpus();
>>
>>> If it hasn't, then the
>>> following lockdep annotations to cpu-hotplug locking should do the
>>> trick.
>>>
>>
>> This patch looks good to me. I have a couple of suggestions though..
>>
> 
> Thanks. I have incorporated the suggestions. Could you check if the
> following looks good ?
> 
> ---
>  Add lockdep annotations for get/put_online_cpus() and
>  cpu_hotplug_begin()/cpu_hotplug_end().
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Srivatsa Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
> ---
[...]
> +/* Lockdep annotations for get/put_online_cpus() and cpu_hotplug_begin/end() */
> +#define cpuhp_lock_acquire_read() lock_map_acquire_read(&cpu_hotplug.dep_map)
> +#define cpuhp_lock_acquire()      lock_map_acquire(&cpu_hotplug.dep_map)
> +#define cpuhp_lock_release()      lock_map_release(&cpu_hotplug.dep_map)
> +
>  void get_online_cpus(void)
>  {
>  	might_sleep();
>  	if (cpu_hotplug.active_writer == current)
>  		return;
> +	cpuhp_lock_acquire_read();
>  	mutex_lock(&cpu_hotplug.lock);
>  	cpu_hotplug.refcount++;
>  	mutex_unlock(&cpu_hotplug.lock);
> @@ -87,6 +101,7 @@ void put_online_cpus(void)
>  	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
>  		wake_up_process(cpu_hotplug.active_writer);
>  	mutex_unlock(&cpu_hotplug.lock);
> +	cpuhp_lock_release();
> 
>  }
>  EXPORT_SYMBOL_GPL(put_online_cpus);
> @@ -117,6 +132,7 @@ void cpu_hotplug_begin(void)
>  {
>  	cpu_hotplug.active_writer = current;
> 
> +	cpuhp_lock_acquire();

Shouldn't we move this to _after_ the for-loop? Because, that's when the
hotplug writer is really in a state equivalent to exclusive access to the
hotplug lock... Else, we might fool lockdep into believing that the hotplug
writer has the lock for write, and at the same time several readers have
the lock for read as well.. no?

Sorry I didn't notice this earlier.

>  	for (;;) {
>  		mutex_lock(&cpu_hotplug.lock);
>  		if (likely(!cpu_hotplug.refcount))
> @@ -131,6 +147,7 @@ void cpu_hotplug_done(void)
>  {
>  	cpu_hotplug.active_writer = NULL;
>  	mutex_unlock(&cpu_hotplug.lock);
> +	cpuhp_lock_release();
>  }
> 
>  /*
> 

Regards,
Srivatsa S. Bhat

