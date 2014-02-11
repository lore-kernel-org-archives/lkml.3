Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaBKQka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:40:30 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:10206 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaBKQk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:40:27 -0500
Message-ID: <1392136436.5612.131.camel@misato.fc.hp.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of
 callback registration functions
From: Toshi Kani <toshi.kani@hp.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "paulus@samba.org" <paulus@samba.org>, "oleg@redhat.com" <oleg@redhat.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "walken@google.com" <walken@google.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Tue, 11 Feb 2014 09:33:56 -0700
In-Reply-To: <52F9ED11.5010800@linux.vnet.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
	 <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com>
	 <1392081980.5612.123.camel@misato.fc.hp.com>
	 <52F9ED11.5010800@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 09:27 +0000, Srivatsa S. Bhat wrote:
> On 02/11/2014 06:56 AM, Toshi Kani wrote:
> > On Thu, 2014-02-06 at 03:34 +0530, Srivatsa S. Bhat wrote:
> >  :
> [...]
> >>
> >> Also, since cpu_maps_update_begin/done() is like a super-set of
> >> get/put_online_cpus(), the former naturally protects the critical sections
> >> from concurrent hotplug operations.
> > 
> > get/put_online_cpus() is a reader-lock and concurrent executions are
> > allowed among the readers.  They won't be serialized until a cpu
> > online/offline operation begins.  By replacing this lock with
> > cpu_maps_update_begin/done(), we now serialize all readers.  Isn't that
> > too restrictive?
> 
> That's an excellent line of thought! It doesn't really hurt at the moment
> because the for_each_online_cpu() kind of loop that the initcalls of various
> subsystems run (before registering the notifier) are really tiny (typically
> the loop runs for just 1 cpu, the boot-cpu). In other words, this change
> represents a tiny increase in the critical section size; so its effect
> shouldn't be noticeable. (Note that in the old model, register_cpu_notifier()
> already takes the cpu_add_remove_lock, so they will be serialized at that
> point, and this is necessary).
> 
> However, going forward, when we start using more aggressive CPU onlining
> techniques during boot (such as parallel CPU hotplug), the issue you pointed
> out can become a real bottleneck, since for_each_online_cpu() can become
> quite a large loop, and hence explicit (and unnecessary) mutual exclusion
> will start hurting.
>  
> >  Can we fix the issue with CPU_POST_DEAD and continue
> > to use get_online_cpus()?
> > 
> 
> We don't want to get rid of CPU_POST_DEAD, so unfortunately we can't continue
> to use get_online_cpus(). However, I am thinking of introducing a Reader-Writer
> semaphore for this purpose, so that the registration routines can run in
> parallel most of the time. (Basically, the rw-semaphore is like
> get/put_online_cpus(), except that it protects the full hotplug critical section,
> including the CPU_POST_DEAD stage.)

I agree that introducing a reader-writer semaphore allows concurrent
executions.  Adding yet another hotplug lock is a bit unfortunate,
though.

This may be a dumb question, but can't we simply do this way?

        get_online_cpus();

        for_each_online_cpu(cpu)
                init_cpu(cpu);

        put_online_cpus();

        register_cpu_notifier(&foobar_cpu_notifier);

Thanks,
-Toshi
 


