Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbaBFM2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:28:38 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51372 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754027AbaBFM2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:28:36 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Len Brown <lenb@kernel.org>
Cc: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 38/51] intel-idle: Fix CPU hotplug callback registration
Date: Thu, 06 Feb 2014 13:43:08 +0100
Message-ID: <87012016.ZnbTpcb5sN@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20140205221122.19080.64763.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205221122.19080.64763.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 06, 2014 03:41:23 AM Srivatsa S. Bhat wrote:
> Subsystems that want to register CPU hotplug callbacks, as well as perform
> initialization for the CPUs that are already online, often do it as shown
> below:
> 
> 	get_online_cpus();
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	register_cpu_notifier(&foobar_cpu_notifier);
> 
> 	put_online_cpus();
> 
> This is wrong, since it is prone to ABBA deadlocks involving the
> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
> with CPU hotplug operations).
> 
> Instead, the correct and race-free way of performing the callback
> registration is:
> 
> 	cpu_maps_update_begin();
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	/* Note the use of the double underscored version of the API */
> 	__register_cpu_notifier(&foobar_cpu_notifier);
> 
> 	cpu_maps_update_done();
> 
> 
> Fix the intel-idle code by using this latter form of callback registration.
> 
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

This looks good to me.  Len, what do you think?

Srivatsa, how does it depend on the rest of your series?

> ---
> 
>  drivers/idle/intel_idle.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 8e1939f..716ee5a 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -681,14 +681,19 @@ static int __init intel_idle_init(void)
>  	if (intel_idle_cpuidle_devices == NULL)
>  		return -ENOMEM;
>  
> +	cpu_maps_update_begin();
> +
>  	for_each_online_cpu(i) {
>  		retval = intel_idle_cpu_init(i);
>  		if (retval) {
> +			cpu_maps_update_done();
>  			cpuidle_unregister_driver(&intel_idle_driver);
>  			return retval;
>  		}
>  	}
> -	register_cpu_notifier(&cpu_hotplug_notifier);
> +	__register_cpu_notifier(&cpu_hotplug_notifier);
> +
> +	cpu_maps_update_done();
>  
>  	return 0;
>  }
> @@ -698,10 +703,13 @@ static void __exit intel_idle_exit(void)
>  	intel_idle_cpuidle_devices_uninit();
>  	cpuidle_unregister_driver(&intel_idle_driver);
>  
> +	cpu_maps_update_begin();
>  
>  	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE)
>  		on_each_cpu(__setup_broadcast_timer, (void *)false, 1);
> -	unregister_cpu_notifier(&cpu_hotplug_notifier);
> +	__unregister_cpu_notifier(&cpu_hotplug_notifier);
> +
> +	cpu_maps_update_done();
>  
>  	return;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
