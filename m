Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaCKAQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:16:14 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62210 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753456AbaCKAQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:16:11 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3 00/52] CPU hotplug: Fix issues with callback registration
Date: Tue, 11 Mar 2014 01:31:28 +0100
Message-ID: <2714771.szsVpCAzkq@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 11, 2014 02:03:52 AM Srivatsa S. Bhat wrote:
> Hi,

Hi,

> Many subsystems and drivers have the need to register CPU hotplug callbacks
> from their init routines and also perform initialization for the CPUs that are
> already online. But unfortunately there is no race-free way to achieve this
> today.
> 
> For example, consider this piece of code:
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
> This is not safe because there is a possibility of an ABBA deadlock involving
> the cpu_add_remove_lock and the cpu_hotplug.lock.
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
>    Try to acquire
>    cpu_add_remove_lock
>    [via register_cpu_notifier()]
> 
>                                               CPU online/offline operation
>                                               tries to acquire cpu_hotplug.lock
>                                               [via cpu_hotplug_begin()]
> 
>                             *** DEADLOCK! ***
> 
> 
> Other combinations of callback registration also don't work correctly.
> Examples:
> 
> 	register_cpu_notifier(&foobar_cpu_notifier);
> 
> 	get_online_cpus();
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	put_online_cpus();
> 
> This can lead to double initialization if a hotplug operation occurs after
> registering the notifier and before invoking get_online_cpus().
> 
> On the other hand, the following piece of code can miss hotplug events
> altogether:
> 
> 	get_online_cpus();
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	put_online_cpus();
>               ^
>               |   Race window; Can miss hotplug events here
>               v
> 	register_cpu_notifier(&foobar_cpu_notifier);
> 
> 
> To solve these issues and provide a race-free method to register CPU hotplug
> callbacks, this patchset introduces new variants of the callback registration
> APIs that don't hold the cpu_add_remove_lock, and exports the
> cpu_add_remove_lock via 2 new APIs cpu_notifier_register_begin/done() for use
> by various subsystems. With this in place, the following code snippet will
> register a hotplug callback as well as initialize already online CPUs without
> any race conditions.
> 
> 	cpu_notifier_register_begin();
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	/* This doesn't take the cpu_add_remove_lock */
> 	__register_cpu_notifier(&foobar_cpu_notifier);
> 
> 	cpu_notifier_register_done();
> 
> 
> In this patchset, patch 1 adds lockdep annotations to catch the above mentioned
> deadlock scenario. Patch 2 introduces the new APIs and infrastructure necessary
> for race-free callback registration. The remaining patches perform tree-wide
> conversions (to use this model).
> 
> This patchset has been hosted in the below git tree. It applies cleanly on
> v3.14-rc6.
> 
> git://github.com/srivatsabhat/linux.git cpuhp-registration-fixes-v3

So to me, this is a useful patchset and it addresses a real problem.  It has
gone through several rounds of review and recently I haven't really seen any
objections against is from anyone.  On the contrary, I've seen ACKs from a
number of people whom I trust.

Thus, if nobody objects, I'm going to take this series into the PM tree for 3.15.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
