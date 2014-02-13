Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaBMVAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:00:22 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:9477 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaBMVAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:00:20 -0500
Message-ID: <1392324808.17215.13.camel@misato.fc.hp.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of
 callback registration functions
From: Toshi Kani <toshi.kani@hp.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "walken@google.com" <walken@google.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Thu, 13 Feb 2014 13:53:28 -0700
In-Reply-To: <52FCA4EA.3090205@linux.vnet.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
	 <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com>
	 <1392081980.5612.123.camel@misato.fc.hp.com>
	 <52F9ED11.5010800@linux.vnet.ibm.com>
	 <1392136436.5612.131.camel@misato.fc.hp.com>
	 <20140211171805.GA3932@in.ibm.com>
	 <1392140115.5612.135.camel@misato.fc.hp.com>
	 <52FA77EA.7050105@linux.vnet.ibm.com>
	 <1392151870.5612.159.camel@misato.fc.hp.com>
	 <52FB1244.2060609@linux.vnet.ibm.com> <52FCA4EA.3090205@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-13 at 10:56 +0000, Srivatsa S. Bhat wrote:
> On 02/12/2014 11:48 AM, Srivatsa S. Bhat wrote:
: 
> >>> For example, something like the code snippet shown below looks pretty
> >>> neat to me:
> >>>
> >>> 	cpu_notifier_register_begin();
> >>>
> >>> 	for_each_online_cpu(cpu)
> >>> 		init_cpu(cpu);
> >>>
> >>> 	register_cpu_notifier(&foobar_cpu_notifier);
> >>>
> >>> 	cpu_notifier_register_done();
> >>>
> >>> What do you think?
> >>
> >> I agree that it is cleaner for the callers as long as people understand
> >> how to use them.  Can you document them properly so that they know when
> >> they need to use them instead of the familiar get/put_online_cpus()?
> >>
> > 
> > Sure.. I had updated the documentation with the semantics introduced in
> > this patchset, in patch 2:
> > 
> > http://thread.gmane.org/gmane.linux.kernel/1641638/focus=1641695
> > 
> > Similarly I'll keep the docs updated with these new APIs in v2 as well.
> >
> 
> For now, however, let us not add the new rw-semaphore to the CPU hotplug
> core yet. Its very unlikely that we'll see any performance issue immediately,
> due to serialized initialization of cpu hotplug notifiers, since early boot
> is mostly sequential anyway.
> 
> Some time in the future, if we start hitting bottlenecks in the cpu hotplug
> notifier registration phase (perhaps when we implement parallel CPU boot-up
> infrastructure), then we can directly use the rw-semaphore solution, since
> we have already worked it out. Besides, like Gautham said, we might want
> to be more careful and have a very good justification before adding more
> locks to the CPU hotplug core code. So we'll add the new rw-sempahore if
> and when it becomes necessary.
> 
> I'll post the v2 with the earlier design itself, by adding the new symbols
> cpu_notifier_register_begin/done() (to enhance the readability) and map
> them to cpu_maps_update_begin/done().

Sounds reasonable to me.  I was also concerned about exporting and
overloading cpu_maps_update_begin/done() for a different purpose (their
purpose is to update cpu_maps).  So, I think adding the new interfaces
is good when we cannot use get/set_online_cpus() for this.

Thanks,
-Toshi



