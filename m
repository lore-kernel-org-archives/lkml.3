Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaBFJj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 04:39:28 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:51448 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbaBFJjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 04:39:25 -0500
Date: Thu, 6 Feb 2014 15:08:33 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/51] CPU hotplug: Fix issues with callback registration
Message-ID: <20140206093833.GA8105@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020609-3532-0000-0000-000005503A8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 06, 2014 at 03:34:36AM +0530, Srivatsa S. Bhat wrote:
> Hi,
> 
> 
> To solve these issues and provide a race-free method to register CPU hotplug
> callbacks, this patchset introduces new variants of the callback registration
> APIs that don't hold the cpu_add_remove_lock, and exports the
> cpu_add_remove_lock via cpu_maps_update_begin/done() for use by various
> subsystems. With this in place, the following code snippet will register a
> hotplug callback as well as initialize already online CPUs without any race
> conditions.
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

Couple of comments:

Right now, cpu_add_remove_lock is being used to 
1) Serialize the cpu-hotplug writers.

2) Serialize accesses to cpu_present/possible_map.

3) Serialize updates to the cpu_chain (the cpu hotplug notifier chain).  

   - This is necessary to ensure that registration of notifiers and
     invocation of CPU_POST_DEAD notifications don't race with each
     other.  Else we could have used get/put_online_cpus() in
     register_cpu_notifier() and this patch series wouldn't have been
     necessary.

4) Bulk cpu-hotplug (disable/enable_non_boot_cpus), but this is a
special case of 1).

CPU_POST_DEAD notification, is invoked with the cpu_hotplug.lock
dropped. This was necessary for subsystems which would be waiting for
some other thread to finish some work, and that other thread could
invoke get_online_cpus(). If CPU_POST_DEAD notification were issued
without dropping the cpu_hotplug.lock, this would lead to a deadlock
as the notifier would be left stuck waiting for the thread which is
blocked in get_online_cpus().

It was introduced to ensure that multithreaded workqueues can safely
use get_online_cpus() [https://lkml.org/lkml/2008/6/29/121].

As of now, only two subsystems use this notification and workqueues is
_not_ one of them!
  * arch/x86/kernel/cpu/mcheck/mce.c:mce_cpu_callback()
  * drivers/cpufreq/cpufreq.c:cpufreq_cpu_callback()
I haven't yet audited these two cases to see if they really need this
to be handled in CPU_POST_DEAD or if they can be handled in CPU_DEAD.

Also can we have an alternate API, something like
cpu_hotplug_register_begin/end() instead of reusing
cpu_maps_update_begin/end() for this usage, since in most of the
patches that follow, we're not touching the any of the cpu_*_maps!

> 
> 
> Regards,
> Srivatsa S. Bhat
> IBM Linux Technology Center

--
Thanks and Regards
gautham.

