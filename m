Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaLIOTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:19:15 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:58351 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaLIOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:19:14 -0500
Date: Tue, 9 Dec 2014 06:19:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        peterz@infradead.org, oleg@redhat.com, bp@suse.de, jkosina@suse.cz
Subject: Re: [PATCH v3] CPU hotplug: active_writer not woken up in some cases
 - deadlock
Message-ID: <20141209141903.GB25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1418127811-22629-1-git-send-email-dahi@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418127811-22629-1-git-send-email-dahi@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120914-0033-0000-0000-000002F3F900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 01:23:31PM +0100, David Hildenbrand wrote:
> Commit b2c4623dcd07 ("rcu: More on deadlock between CPU hotplug and expedited
> grace periods") introduced another problem that can easily be reproduced by
> starting/stopping cpus in a loop.
> 
> E.g.:
>   for i in `seq 5000`; do
>       echo 1 > /sys/devices/system/cpu/cpu1/online
>       echo 0 > /sys/devices/system/cpu/cpu1/online
>   done
> 
> Will result in:
>   INFO: task /cpu_start_stop:1 blocked for more than 120 seconds.
>   Call Trace:
>   ([<00000000006a028e>] __schedule+0x406/0x91c)
>    [<0000000000130f60>] cpu_hotplug_begin+0xd0/0xd4
>    [<0000000000130ff6>] _cpu_up+0x3e/0x1c4
>    [<0000000000131232>] cpu_up+0xb6/0xd4
>    [<00000000004a5720>] device_online+0x80/0xc0
>    [<00000000004a57f0>] online_store+0x90/0xb0
>   ...
> 
> And a deadlock.
> 
> Problem is that if the last ref in put_online_cpus() can't get the
> cpu_hotplug.lock the puts_pending count is incremented, but a sleeping
> active_writer might never be woken up, therefore never exiting the loop in
> cpu_hotplug_begin().
> 
> This fix wakes up the active_writer proactively. The writer already goes back to
> sleep if the ref count isn't already down to 0, so this should be fine.
> 
> In order to avoid many potential races, we have to:
> - Protect current_writer by a spin lock. When holding this lock we can be sure
>   that the writer won't vainsh or change. (use-after-free)
> - Increment the cpu_hotplug.puts_pending count before we test for an
>   active_writer. (otherwise a wakeup might get lost)
> - Move setting of TASK_UNINTERRUPTIBLE in cpu_hotplug_begin() above the
>   condition check. (otherwise a wakeup might get lost)
> 
> Can't reproduce it with this fix.

Would wait_event()/wake_up() work for the wakeup-writer case?

							Thanx, Paul

> Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> ---
>  kernel/cpu.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 90a3d01..7489b7a 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -58,6 +58,7 @@ static int cpu_hotplug_disabled;
> 
>  static struct {
>  	struct task_struct *active_writer;
> +	spinlock_t awr_lock; /* protects active_writer from being changed */
>  	struct mutex lock; /* Synchronizes accesses to refcount, */
>  	/*
>  	 * Also blocks the new readers during
> @@ -72,6 +73,7 @@ static struct {
>  #endif
>  } cpu_hotplug = {
>  	.active_writer = NULL,
> +	.awr_lock = __SPIN_LOCK_UNLOCKED(cpu_hotplug.awr_lock),
>  	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
>  	.refcount = 0,
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> @@ -116,7 +118,13 @@ void put_online_cpus(void)
>  	if (cpu_hotplug.active_writer == current)
>  		return;
>  	if (!mutex_trylock(&cpu_hotplug.lock)) {
> +		/* inc before testing for active_writer to not lose wake ups */
>  		atomic_inc(&cpu_hotplug.puts_pending);
> +		spin_lock(&cpu_hotplug.awr_lock);
> +		/* we might be the last one */
> +		if (unlikely(cpu_hotplug.active_writer))
> +			wake_up_process(cpu_hotplug.active_writer);
> +		spin_unlock(&cpu_hotplug.awr_lock);
>  		cpuhp_lock_release();
>  		return;
>  	}
> @@ -156,20 +164,24 @@ EXPORT_SYMBOL_GPL(put_online_cpus);
>   */
>  void cpu_hotplug_begin(void)
>  {
> +	spin_lock(&cpu_hotplug.awr_lock);
>  	cpu_hotplug.active_writer = current;
> +	spin_unlock(&cpu_hotplug.awr_lock);
> 
>  	cpuhp_lock_acquire();
>  	for (;;) {
>  		mutex_lock(&cpu_hotplug.lock);
> +		__set_current_state(TASK_UNINTERRUPTIBLE);
>  		if (atomic_read(&cpu_hotplug.puts_pending)) {
>  			int delta;
> 
>  			delta = atomic_xchg(&cpu_hotplug.puts_pending, 0);
>  			cpu_hotplug.refcount -= delta;
>  		}
> -		if (likely(!cpu_hotplug.refcount))
> +		if (likely(!cpu_hotplug.refcount)) {
> +			__set_current_state(TASK_RUNNING);
>  			break;
> -		__set_current_state(TASK_UNINTERRUPTIBLE);
> +		}
>  		mutex_unlock(&cpu_hotplug.lock);
>  		schedule();
>  	}
> @@ -177,7 +189,9 @@ void cpu_hotplug_begin(void)
> 
>  void cpu_hotplug_done(void)
>  {
> +	spin_lock(&cpu_hotplug.awr_lock);
>  	cpu_hotplug.active_writer = NULL;
> +	spin_unlock(&cpu_hotplug.awr_lock);
>  	mutex_unlock(&cpu_hotplug.lock);
>  	cpuhp_lock_release();
>  }
> -- 
> 1.8.5.5
> 

