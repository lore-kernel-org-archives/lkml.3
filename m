Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaBSVmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:42:23 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:49488 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaBSVmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:42:22 -0500
Message-ID: <1392845686.6784.3.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 02/52] CPU hotplug: Provide lockless versions of
 callback registration functions
From: Toshi Kani <toshi.kani@hp.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 19 Feb 2014 14:34:46 -0700
In-Reply-To: <20140214074922.22701.17949.stgit@srivatsabhat.in.ibm.com>
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
	 <20140214074922.22701.17949.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 13:19 +0530, Srivatsa S. Bhat wrote:
> The following method of CPU hotplug callback registration is not safe
> due to the possibility of an ABBA deadlock involving the cpu_add_remove_lock
> and the cpu_hotplug.lock.
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
> The deadlock is shown below:
> 
>           CPU 0                                         CPU 1
>           -----                                         -----
> 
>    Acquire cpu_hotplug.lock
>    [via get_online_cpus()]
> 
>                                               CPU online/offline operation
>                                               takes cpu_add_remove_lock
>                                               [via cpu_maps_update_begin()]
> 
> 
>    Try to acquire
>    cpu_add_remove_lock
>    [via register_cpu_notifier()]
> 
> 
>                                               CPU online/offline operation
>                                               tries to acquire cpu_hotplug.lock
>                                               [via cpu_hotplug_begin()]
> 
> 
>                             *** DEADLOCK! ***
> 
> The problem here is that callback registration takes the locks in one order
> whereas the CPU hotplug operations take the same locks in the opposite order.
> To avoid this issue and to provide a race-free method to register CPU hotplug
> callbacks (along with initialization of already online CPUs), introduce new
> variants of the callback registration APIs that simply register the callbacks
> without holding the cpu_add_remove_lock during the registration. That way,
> we can avoid the ABBA scenario. However, we will need to hold the
> cpu_add_remove_lock throughout the entire critical section, to protect updates
> to the callback/notifier chain.
> 
> This can be achieved by writing the callback registration code as follows:
> 
> 	cpu_maps_update_begin(); [ or cpu_notifier_register_begin(); see below ]
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	/* This doesn't take the cpu_add_remove_lock */
> 	__register_cpu_notifier(&foobar_cpu_notifier);
> 
> 	cpu_maps_update_done();  [ or cpu_notifier_register_done(); see below ]
> 
> Note that we can't use get_online_cpus() here instead of cpu_maps_update_begin()
> because the cpu_hotplug.lock is dropped during the invocation of CPU_POST_DEAD
> notifiers, and hence get_online_cpus() cannot provide the necessary
> synchronization to protect the callback/notifier chains against concurrent
> reads and writes. On the other hand, since the cpu_add_remove_lock protects
> the entire hotplug operation (including CPU_POST_DEAD), we can use
> cpu_maps_update_begin/done() to guarantee proper synchronization.
> 
> Also, since cpu_maps_update_begin/done() is like a super-set of
> get/put_online_cpus(), the former naturally protects the critical sections
> from concurrent hotplug operations.
> 
> Since the names cpu_maps_update_begin/done() don't make much sense in CPU
> hotplug callback registration scenarios, we'll introduce new APIs named
> cpu_notifier_register_begin/done() and map them to cpu_maps_update_begin/done().
> 
> In summary, introduce the lockless variants of un/register_cpu_notifier() and
> also export the cpu_notifier_register_begin/done() APIs for use by modules.
> This way, we provide a race-free way to register hotplug callbacks as well as
> perform initialization for the CPUs that are already online.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Toshi Kani <toshi.kani@hp.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


