Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaBMLCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:02:19 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:52710 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaBMLCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:02:17 -0500
Message-ID: <52FCA4EA.3090205@linux.vnet.ibm.com>
Date: Thu, 13 Feb 2014 16:26:42 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: ego@linux.vnet.ibm.com, "paulus@samba.org" <paulus@samba.org>,
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
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of callback
 registration functions
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com> <1392081980.5612.123.camel@misato.fc.hp.com> <52F9ED11.5010800@linux.vnet.ibm.com> <1392136436.5612.131.camel@misato.fc.hp.com> <20140211171805.GA3932@in.ibm.com> <1392140115.5612.135.camel@misato.fc.hp.com> <52FA77EA.7050105@linux.vnet.ibm.com> <1392151870.5612.159.camel@misato.fc.hp.com> <52FB1244.2060609@linux.vnet.ibm.com>
In-Reply-To: <52FB1244.2060609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021311-5816-0000-0000-00000C3FEE81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 11:48 AM, Srivatsa S. Bhat wrote:
> On 02/12/2014 02:21 AM, Toshi Kani wrote:
>> On Wed, 2014-02-12 at 00:50 +0530, Srivatsa S. Bhat wrote:
>>> On 02/11/2014 11:05 PM, Toshi Kani wrote:
>>  :
>>>> How about this?  foo_cpu_notifier returns NOP when foo_notifier_ready is
>>>> false.
>>>>
>>>>         register_cpu_notifier(&foobar_cpu_notifier);
>>>>
>>>>         get_online_cpus();
>>>>
>>>>         for_each_online_cpu(cpu)
>>>>                 init_cpu(cpu);
>>>>
>>>> 	foo_notifier_ready = true;
>>>>
>>>>         put_online_cpus();
>>>>
>>>
>>> Nah, that looks a lot like some quick-n-dirty hack ;-(
>>> It would also amount to burdening the various subsystems to add weird-looking
>>> pieces of code such as this in their callbacks:
>>>
>>> 	if (!foo_notifier_ready)
>>> 		return NOTIFY_OK;
>>>
>>> This only makes it all the more evident that the callback registration APIs
>>> exposed by the CPU hotplug core is poorly designed.
>>>
>>> What we need instead, is an elegant, well-defined and easy-to-use set of
>>> interfaces/APIs exposed by the core CPU hotplug code to the various
>>> subsystems. I don't think we should worry so much about the fact that
>>> we can't use the familiar get/put_online_cpus() in this type of callback
>>> registration scenario. We can introduce a sane set of APIs that work
>>> well in such situations and use them consistently.
>>
>>> For example, something like the code snippet shown below looks pretty
>>> neat to me:
>>>
>>> 	cpu_notifier_register_begin();
>>>
>>> 	for_each_online_cpu(cpu)
>>> 		init_cpu(cpu);
>>>
>>> 	register_cpu_notifier(&foobar_cpu_notifier);
>>>
>>> 	cpu_notifier_register_done();
>>>
>>> What do you think?
>>
>> I agree that it is cleaner for the callers as long as people understand
>> how to use them.  Can you document them properly so that they know when
>> they need to use them instead of the familiar get/put_online_cpus()?
>>
> 
> Sure.. I had updated the documentation with the semantics introduced in
> this patchset, in patch 2:
> 
> http://thread.gmane.org/gmane.linux.kernel/1641638/focus=1641695
> 
> Similarly I'll keep the docs updated with these new APIs in v2 as well.
>

For now, however, let us not add the new rw-semaphore to the CPU hotplug
core yet. Its very unlikely that we'll see any performance issue immediately,
due to serialized initialization of cpu hotplug notifiers, since early boot
is mostly sequential anyway.

Some time in the future, if we start hitting bottlenecks in the cpu hotplug
notifier registration phase (perhaps when we implement parallel CPU boot-up
infrastructure), then we can directly use the rw-semaphore solution, since
we have already worked it out. Besides, like Gautham said, we might want
to be more careful and have a very good justification before adding more
locks to the CPU hotplug core code. So we'll add the new rw-sempahore if
and when it becomes necessary.

I'll post the v2 with the earlier design itself, by adding the new symbols
cpu_notifier_register_begin/done() (to enhance the readability) and map
them to cpu_maps_update_begin/done().

Thank you!

Regards,
Srivatsa S. Bhat

