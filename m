Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbaBFQPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:15:23 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37463 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbaBFQPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:15:22 -0500
Message-ID: <52F3B3D6.10402@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 21:39:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: ego@linux.vnet.ibm.com
CC: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/51] CPU hotplug: Fix issues with callback registration
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140206093833.GA8105@in.ibm.com> <52F36C41.2070700@linux.vnet.ibm.com> <20140206121410.GA30676@in.ibm.com>
In-Reply-To: <20140206121410.GA30676@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020616-7014-0000-0000-0000044A208F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 05:44 PM, Gautham R Shenoy wrote:
> On Thu, Feb 06, 2014 at 04:34:33PM +0530, Srivatsa S. Bhat wrote:
>>>
>>> CPU_POST_DEAD notification, is invoked with the cpu_hotplug.lock
>>> dropped. This was necessary for subsystems which would be waiting for
>>> some other thread to finish some work, and that other thread could
>>> invoke get_online_cpus(). If CPU_POST_DEAD notification were issued
>>> without dropping the cpu_hotplug.lock, this would lead to a deadlock
>>> as the notifier would be left stuck waiting for the thread which is
>>> blocked in get_online_cpus().
>>>
>>> It was introduced to ensure that multithreaded workqueues can safely
>>> use get_online_cpus() [https://lkml.org/lkml/2008/6/29/121].
>>>
>>> As of now, only two subsystems use this notification and workqueues is
>>> _not_ one of them!
>>>   * arch/x86/kernel/cpu/mcheck/mce.c:mce_cpu_callback()
>>>   * drivers/cpufreq/cpufreq.c:cpufreq_cpu_callback()
>>> I haven't yet audited these two cases to see if they really need this
>>> to be handled in CPU_POST_DEAD or if they can be handled in CPU_DEAD.
>>>
>>
>> Well, cpufreq had a legitimate need to use POST_DEAD to avoid the
>> deadlock described in commit 1aee40ac9c. However, there had been some
>> discussion some time ago about reorganizing the cpufreq's hotplug callback
>> so as to move most (but not all) of its work outside of POST_DEAD [1].
>> But as it stands, I don't think it would be easy to totally get rid of
>> cpufreq's dependence on the POST_DEAD notifier.
>>
> 
> Right, I see the reason why cpufreq needs POST_DEAD.
> 
>> Besides, I think its good to retain the POST_DEAD notifier option in
>> the CPU hotplug core code. It has come handy several times to fix hard
>> deadlock issues.
>>
> 
> I know. I am not denying the usefulness of POST_DEAD. But the fact
> that some of the CPU_* notifiers are invoked with the cpu_hotplug.lock
> held while CPU_POST_DEAD is invoked with the lock dropped looks a bit
> asymmetrical. At the moment I cannot think of a simpler alternative.
> 

Hmmm...

> 
>>> Also can we have an alternate API, something like
>>> cpu_hotplug_register_begin/end() instead of reusing
>>> cpu_maps_update_begin/end() for this usage, since in most of the
>>> patches that follow, we're not touching the any of the cpu_*_maps!
>>>
>>
>> Yes, the function names cpu_maps_update_begin/end() don't really suit
>> the kind of usage I'm proposing in this patchset, and hence is kind of
>> a misnomer. For better readability, I'm thinking of defining a macro
>> such as say, cpu_hotplug_notifier_lock()/unlock() that redirects to
>> cpu_maps_update_begin/end() respectively. That way, we can export just
>> those former symbols for use by modules, and thereby the code would look
>> more intuitive, like this:
>>
>> 	cpu_hotplug_notifier_lock();
>>
>> 	for_each_online_cpu(cpu)
>> 		init_cpu(cpu);
>>
>> 	/* This doesn't take the cpu_add_remove_lock */
>> 	__register_cpu_notifier(&foobar_cpu_notifier);
>>
>> 	cpu_hotplug_notifier_unlock();
>>
>> What do you think?
> 
> Sounds good.

Cool! If there are no objections, I'll use this naming for the APIs
and spin a v2 of the patchset soon.

Thank you!
 
Regards,
Srivatsa S. Bhat

