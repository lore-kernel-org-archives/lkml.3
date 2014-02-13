Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaBMSAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:00:22 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:38147 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaBMSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:00:20 -0500
Message-ID: <52FD06E8.9000209@linux.vnet.ibm.com>
Date: Thu, 13 Feb 2014 23:24:48 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Toshi Kani <toshi.kani@hp.com>, paulus@samba.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of	callback
 registration functions
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com> <1392081980.5612.123.camel@misato.fc.hp.com> <52F9ED11.5010800@linux.vnet.ibm.com> <20140211171553.GA26036@redhat.com> <52FA7539.4030907@linux.vnet.ibm.com> <20140213174452.GB14455@redhat.com>
In-Reply-To: <20140213174452.GB14455@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021318-5564-0000-0000-00000C01A86D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 11:14 PM, Oleg Nesterov wrote:
> On 02/12, Srivatsa S. Bhat wrote:
>>
>> On 02/11/2014 10:45 PM, Oleg Nesterov wrote:
>>>
>>> I am a bit confused... If we do this, why we can't simply turn
>>> cpu_add_remove_lock into rw_semaphore?
> 
> [...snip...]
> 
>> 	cpu_notifier_register_begin();                |  Run in parallel
>>                                                       |  with similar phases
>> 	for_each_online_cpu(cpu)                      |  from other subsystems.
>> 		init_cpu(cpu);                        |
>>
>> 	/* Updates the cpu notifier chain. */
>> 	register_cpu_notifier(&foobar_cpu_notifier); ||| -- Must run serially
> 
> Ah indeed, we can't use a single lock, thanks. Perhaps we can simply
> add a spinlock_t which only protects cpu_chain though, but I am not
> sure and currently this is off-topic anyway.
>

The problem with that would be that the chain invocations (during CPU hotplug)
would have to take the spinlock (to prevent running concurrently with chain
updaters). But unfortunately CPU hotplug notifier callbacks can sleep, so we
can't hold spinlocks while invoking them.

Regards,
Srivatsa S. Bhat

