Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaBKBcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 20:32:51 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:26757 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaBKBcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 20:32:50 -0500
Message-ID: <1392081980.5612.123.camel@misato.fc.hp.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of
 callback registration functions
From: Toshi Kani <toshi.kani@hp.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Mon, 10 Feb 2014 18:26:20 -0700
In-Reply-To: <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
	 <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 03:34 +0530, Srivatsa S. Bhat wrote:
 :
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
> 	cpu_maps_update_begin();
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	/* This doesn't take the cpu_add_remove_lock */
> 	__register_cpu_notifier(&foobar_cpu_notifier);
> 
> 	cpu_maps_update_done();
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

get/put_online_cpus() is a reader-lock and concurrent executions are
allowed among the readers.  They won't be serialized until a cpu
online/offline operation begins.  By replacing this lock with
cpu_maps_update_begin/done(), we now serialize all readers.  Isn't that
too restrictive?  Can we fix the issue with CPU_POST_DEAD and continue
to use get_online_cpus()?

Thanks,
-Toshi



