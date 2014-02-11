Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaBKTOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:14:11 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55807 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaBKTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:14:08 -0500
Message-ID: <52FA7539.4030907@linux.vnet.ibm.com>
Date: Wed, 12 Feb 2014 00:38:41 +0530
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
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com> <1392081980.5612.123.camel@misato.fc.hp.com> <52F9ED11.5010800@linux.vnet.ibm.com> <20140211171553.GA26036@redhat.com>
In-Reply-To: <20140211171553.GA26036@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021119-9574-0000-0000-00000BE6FAD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 10:45 PM, Oleg Nesterov wrote:
> On 02/11, Srivatsa S. Bhat wrote:
>>
>> +static DECLARE_RWSEM(cpu_hotplug_rwsem);
>> +
>> +void cpu_notifier_register_begin(void)
>> +{
>> +	down_read(&cpu_hotplug_rwsem);
>> +}
>> +
>> +void cpu_notifier_register_end(void)
>> +{
>> +	up_read(&cpu_hotplug_rwsem);
>> +}
>> +
>>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
>>  static DEFINE_MUTEX(cpu_add_remove_lock);
>>  
>> @@ -32,12 +45,14 @@ static DEFINE_MUTEX(cpu_add_remove_lock);
>>   */
>>  void cpu_maps_update_begin(void)
>>  {
>> +	down_write(&cpu_hotplug_rwsem);
>>  	mutex_lock(&cpu_add_remove_lock);
>>  }
>>  
>>  void cpu_maps_update_done(void)
>>  {
>>  	mutex_unlock(&cpu_add_remove_lock);
>> +	up_write(&cpu_hotplug_rwsem);
>>  }
> 
> I am a bit confused... If we do this, why we can't simply turn
> cpu_add_remove_lock into rw_semaphore?
> 

Short answer: Being a mutex, cpu_add_remove_lock ensures that the updates to
the cpu notifier chain get serialized. If we make that an rw-semaphore, then
the notifier chain mutations (during callback registration) will run in
parallel, wreaking havoc.

Long answer: There are two distinct phases in the critical section involving
the callback registration - one that should run in parallel with other
readers (other such critical sections) and the other one which should run
serially, as depicted below.

	cpu_notifier_register_begin();                |  Run in parallel
                                                      |  with similar phases
	for_each_online_cpu(cpu)                      |  from other subsystems.
		init_cpu(cpu);                        |

	/* Updates the cpu notifier chain. */
	register_cpu_notifier(&foobar_cpu_notifier); ||| -- Must run serially

	cpu_notifier_register_done();


So, for the first part, we can use an rw-semaphore, to allow the init
routines of various subsystems to run in parallel. For the second part,
we need strict mutual exclusion; so we can use the cpu_add_remove_lock
mutex as it is. But it so happens that the length of the critical section
for both these locks are exactly the same on the hotplug writer side - they
both need to cover the full hotplug code, including the CPU_POST_DEAD stage.

I do agree that this approach introduces yet another lock in the hotplug
path. However, we can nicely abstract it into APIs that the rest of the
subsystems can call (as shown above), without needing to know the internal
lock ordering etc.

Thoughts?

Regards,
Srivatsa S. Bhat

