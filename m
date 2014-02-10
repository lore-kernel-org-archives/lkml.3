Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaBJJVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:21:35 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:38848 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaBJJV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:21:29 -0500
Message-ID: <52F898CB.6030900@linux.vnet.ibm.com>
Date: Mon, 10 Feb 2014 14:45:55 +0530
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
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com> <20140206184103.GA31410@redhat.com> <20140207191125.GA8098@in.ibm.com>
In-Reply-To: <20140207191125.GA8098@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021009-5140-0000-0000-000004889C0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gautham,

On 02/08/2014 12:41 AM, Gautham R Shenoy wrote:
> On Thu, Feb 06, 2014 at 07:41:03PM +0100, Oleg Nesterov wrote:
>> On 02/06, Srivatsa S. Bhat wrote:
>>>
>>> The following method of CPU hotplug callback registration is not safe
>>> due to the possibility of an ABBA deadlock involving the cpu_add_remove_lock
>>> and the cpu_hotplug.lock.
>>
>> Off-topic, but perhaps it also makes sense to add the lockdep annotations
>> later, to catch other similar problems. Currently get_online_cpus() acquires
>> nothing from lockdep pov.
> 
> Well, both get/put_online_cpus() as well as cpu_hotplug_begin/end()
> take the cpu_hotplug.lock mutex. So ideally the lockdep annotations of
> mutex_lock/unlock() should have worked.

The reason lockdep doesn't catch the lock-inversion (ABBA) deadlock between
cpu_hotplug.lock (from get_online_cpus) and cpu_add_remove_lock (from
cpu_maps_update_begin) is because, in the following path, the
cpu_add_remove_lock is acquired after *releasing* the cpu_hotplug.lock mutex.

get_online_cpus();  // acquire mutex; update counter; release mutex

register_cpu_notifier(); // acquire cpu_add_remove_lock ...

put_online_cpus();

> If it hasn't, then the
> following lockdep annotations to cpu-hotplug locking should do the
> trick.
> 

This patch looks good to me. I have a couple of suggestions though..

> Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
> ---
>  kernel/cpu.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index deff2e6..3d2dd1c 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -19,6 +19,7 @@
>  #include <linux/mutex.h>
>  #include <linux/gfp.h>
>  #include <linux/suspend.h>
> +#include <linux/lockdep.h>
> 
>  #include "smpboot.h"
> 
> @@ -57,21 +58,34 @@ static struct {
>  	 * an ongoing cpu hotplug operation.
>  	 */
>  	int refcount;
> +
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +	struct lockdep_map dep_map;
> +#endif
>  } cpu_hotplug = {
>  	.active_writer = NULL,
>  	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
>  	.refcount = 0,
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +	.dep_map = {.name = "cpu_hotplug.lock" },
> +#endif
>  };
> 
> +#define cphp_lock_acquire_read(l, s, t, i) lock_acquire_shared_recursive(l, s, t, NULL, i)
> +#define cphp_lock_acquire(l, s, t, i)      lock_acquire_exclusive(l, s, t, NULL, i)
> +#define cphp_lock_release(l, n, i)      lock_release(l, n, i)
> +

Can you make them cpuhp_* instead of cphp_*? That way it would suit better as
a short-form of "cpu hotplug".

Also, perhaps we could use the lock_map_acquire(), lock_map_acquire_read()
and lock_map_release() macros to make the call-sites look neater.

Regards,
Srivatsa S. Bhat


>  void get_online_cpus(void)
>  {
>  	might_sleep();
>  	if (cpu_hotplug.active_writer == current)
>  		return;
> +	cphp_lock_acquire_read(&cpu_hotplug.dep_map, 0, 0, _RET_IP_);
>  	mutex_lock(&cpu_hotplug.lock);
>  	cpu_hotplug.refcount++;
>  	mutex_unlock(&cpu_hotplug.lock);
> 
> +
>  }
>  EXPORT_SYMBOL_GPL(get_online_cpus);
> 
> @@ -79,6 +93,7 @@ void put_online_cpus(void)
>  {
>  	if (cpu_hotplug.active_writer == current)
>  		return;
> +
>  	mutex_lock(&cpu_hotplug.lock);
> 
>  	if (WARN_ON(!cpu_hotplug.refcount))
> @@ -87,6 +102,7 @@ void put_online_cpus(void)
>  	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
>  		wake_up_process(cpu_hotplug.active_writer);
>  	mutex_unlock(&cpu_hotplug.lock);
> +	cphp_lock_release(&cpu_hotplug.dep_map, 1, _RET_IP_);
> 
>  }
>  EXPORT_SYMBOL_GPL(put_online_cpus);
> @@ -117,6 +133,7 @@ void cpu_hotplug_begin(void)
>  {
>  	cpu_hotplug.active_writer = current;
> 
> +	cphp_lock_acquire(&cpu_hotplug.dep_map, 0, 0, _RET_IP_);
>  	for (;;) {
>  		mutex_lock(&cpu_hotplug.lock);
>  		if (likely(!cpu_hotplug.refcount))
> @@ -131,6 +148,7 @@ void cpu_hotplug_done(void)
>  {
>  	cpu_hotplug.active_writer = NULL;
>  	mutex_unlock(&cpu_hotplug.lock);
> +	cphp_lock_release(&cpu_hotplug.dep_map, 1, _RET_IP_);
>  }
> 
>  /*
> 

