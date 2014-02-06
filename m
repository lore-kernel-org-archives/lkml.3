Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaBFLbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:31:16 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:59266 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbaBFLbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:31:15 -0500
Message-ID: <52F3713A.3040407@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 16:55:46 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "paulus@samba.org" <paulus@samba.org>, "oleg@redhat.com" <oleg@redhat.com>,
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
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 08/51] arm, hw-breakpoint: Fix CPU hotplug callback registration
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220603.19080.80971.stgit@srivatsabhat.in.ibm.com> <20140206105718.GG26035@mudshark.cambridge.arm.com>
In-Reply-To: <20140206105718.GG26035@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020611-2674-0000-0000-00000C9690FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 02/06/2014 04:27 PM, Will Deacon wrote:
> Hi Srivatsa,
> 
> On Wed, Feb 05, 2014 at 10:06:04PM +0000, Srivatsa S. Bhat wrote:
>> Subsystems that want to register CPU hotplug callbacks, as well as perform
>> initialization for the CPUs that are already online, often do it as shown
>> below:
>>
>> 	get_online_cpus();
>>
>> 	for_each_online_cpu(cpu)
>> 		init_cpu(cpu);
>>
>> 	register_cpu_notifier(&foobar_cpu_notifier);
>>
>> 	put_online_cpus();
>>
>> This is wrong, since it is prone to ABBA deadlocks involving the
>> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
>> with CPU hotplug operations).
> 
> Hmm, the code in question (for this patch) runs from an arch_initcall. How
> can you generate CPU hotplug operations at that stage?
> 

You are right - in today's design of the init sequence, CPU hotplug
operations can't be triggered at that time during boot.

However, there have been proposals to boot CPUs in parallel along with the
rest of the kernel initialization [1] (and that would need full synchronization
with CPU hotplug even at the initcall stage). Of course this needs a lot of
auditing and modifications to the CPU hotplug notifiers of various subsystems
to make them robust enough to handle the parallel boot; so its not going to
happen very soon. But I felt that it would be a good idea to ensure that we
get the locking/synchronization right, even if the registrations happen very
early during boot today.. you know, just to be on the safer side and also to
make the job easier for whoever that is, who tries to implement parallel
CPU booting again in the future ;-)

[1]. http://thread.gmane.org/gmane.linux.kernel/1246209


>> Instead, the correct and race-free way of performing the callback
>> registration is:
>>
>> 	cpu_maps_update_begin();
>>
>> 	for_each_online_cpu(cpu)
>> 		init_cpu(cpu);
>>
>> 	/* Note the use of the double underscored version of the API */
>> 	__register_cpu_notifier(&foobar_cpu_notifier);
>>
>> 	cpu_maps_update_done();
>>
>>
>> Fix the hw-breakpoint code in arm by using this latter form of callback
>> registration.
> 
> I guess you introduce __register_cpu_notifier somewhere earlier in the
> series,

Yes, patch 1 adds that API..

> so it's best if you take this all via your tree.
>

Hmm.. I'm not a maintainer myself, so I'm hoping that either Oleg or Rusty
or any of the other CPU hotplug maintainers (Thomas/Peter/Ingo) would be
willing to take these patches through their tree.

Regards,
Srivatsa S. Bhat

