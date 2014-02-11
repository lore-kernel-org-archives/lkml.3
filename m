Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaBKRlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:41:52 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:36006 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaBKRlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:41:50 -0500
Message-ID: <1392140115.5612.135.camel@misato.fc.hp.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of
 callback registration functions
From: Toshi Kani <toshi.kani@hp.com>
To: ego@linux.vnet.ibm.com
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
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
Date: Tue, 11 Feb 2014 10:35:15 -0700
In-Reply-To: <20140211171805.GA3932@in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
	 <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com>
	 <1392081980.5612.123.camel@misato.fc.hp.com>
	 <52F9ED11.5010800@linux.vnet.ibm.com>
	 <1392136436.5612.131.camel@misato.fc.hp.com>
	 <20140211171805.GA3932@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 22:48 +0530, Gautham R Shenoy wrote:
> On Tue, Feb 11, 2014 at 09:33:56AM -0700, Toshi Kani wrote:
> > 
> > I agree that introducing a reader-writer semaphore allows concurrent
> > executions.  Adding yet another hotplug lock is a bit unfortunate,
> > though.
> > 
> 
> I agree with this last part. We already have enough locks for
> cpu-hotplug. Another one sounds one too many!!
> 
> 
> > This may be a dumb question, but can't we simply do this way?
> > 
> >         get_online_cpus();
> > 
> >         for_each_online_cpu(cpu)
> >                 init_cpu(cpu);
> > 
> >         put_online_cpus();
> >
>       -------- Someone chooses to hotplug a cpu here ------
>       -------- But this subsystem might miss out on knowing
>                about it since it hasn't registered its
>                notifier yet! 
> 
> >         register_cpu_notifier(&foobar_cpu_notifier);


How about this?  foo_cpu_notifier returns NOP when foo_notifier_ready is
false.

        register_cpu_notifier(&foobar_cpu_notifier);

        get_online_cpus();

        for_each_online_cpu(cpu)
                init_cpu(cpu);

	foo_notifier_ready = true;

        put_online_cpus();

Thanks,
-Toshi

