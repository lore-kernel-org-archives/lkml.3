Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaLHSbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:31:47 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50863 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbaLHSbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:31:45 -0500
Date: Mon, 8 Dec 2014 10:31:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        oleg@redhat.com, bp@suse.de, jkosina@suse.cz
Subject: Re: [PATCH v1] CPU hotplug: active_reader not woken up in some cases
 - deadlock
Message-ID: <20141208183134.GQ25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1418062383-39657-1-git-send-email-dahi@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418062383-39657-1-git-send-email-dahi@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120818-0009-0000-0000-000006F61C15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 07:13:03PM +0100, David Hildenbrand wrote:
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
> cpu_hotplug.lock the puts_pending count is incremented, but a sleeping active_writer
> might never be woken up, therefore never exiting the loop in cpu_hotplug_begin().
> 
> This quick fix wakes up the active_writer proactively. The writer already
> goes back to sleep if the ref count isn't already down to 0, so this should be
> fine.
> 
> Can't reproduce the error with this fix.

Good catch!

But don't we need to use exactly the same value for the NULL check
and for the wakeup?  Otherwise, wouldn't it be possible for
cpu_hotplug.active_writer to be non-NULL for the check but NULL
for the wake_up_process()?

							Thanx, Paul

> Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> ---
>  kernel/cpu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 90a3d01..e77740583 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -117,6 +117,9 @@ void put_online_cpus(void)
>  		return;
>  	if (!mutex_trylock(&cpu_hotplug.lock)) {
>  		atomic_inc(&cpu_hotplug.puts_pending);
> +		/* we might be the last one */
> +		if (unlikely(cpu_hotplug.active_writer))
> +			wake_up_process(cpu_hotplug.active_writer);
>  		cpuhp_lock_release();
>  		return;
>  	}
> -- 
> 1.8.5.5
> 

