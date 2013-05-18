Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3ERTlE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 15:41:04 -0400
Received: from mout.gmx.net ([212.227.15.15]:53603 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab3ERTlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 15:41:01 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18QzUdqm5oQ9RDZrleGcPCyL99kHXKfqNUSEqPUlN
	Cv9zp4CF1Douei
Message-ID: <5197D947.4070200@gmx.de>
Date: Sat, 18 May 2013 21:40:55 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-parisc@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] parisc: avoid WARNING: at kernel/cpu/idle.c:96
References: <20130508204242.GA16254@p100.box> <1368047134.8623.5.camel@dabdike> <5196843B.8060807@linux.vnet.ibm.com>
In-Reply-To: <5196843B.8060807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 09:25 PM, Srivatsa S. Bhat wrote:
> On 05/09/2013 02:35 AM, James Bottomley wrote:
>> On Wed, 2013-05-08 at 22:42 +0200, Helge Deller wrote:
>>> We need to enable local irqs to avoid this runtime warning.
>>>
>>> Signed-off-by: Helge Deller <deller@gmx.de>
>>>
>>> diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
>>> index 55f92b6..2840d43 100644
>>> --- a/arch/parisc/kernel/process.c
>>> +++ b/arch/parisc/kernel/process.c
>>> @@ -286,3 +286,8 @@ void *dereference_function_descriptor(void *ptr)
>>>  	return ptr;
>>>  }
>>>  #endif
>>> +
>>> +void arch_cpu_idle(void)
>>> +{
>>> +	local_irq_enable();
>>
>> This is definitely wrong.  we'd need at least a cpu_relax() in there.
>> Without that the cpu will bounce around in the idle loop.  I'd advise
>> that we simply keep the default cpu_idle_poll().
>>
>> However, this looks like a kernel bug to me in cpu_idle_loop()?  not
>> something we should be working around in the arch code.
>>
>> Thomas, what's going on here?  It looks like you can never avoid the
>> WARN_ON_ONCE if you don't provide any arch specific idle functions.  If
>> you wish to allow this case then the correct patch (keeping the WARN_ON)
>> would appear to be this one.
>>
>> James
>>
>> ----
>> diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
>> index 8b86c0c..829e41f 100644
>> --- a/kernel/cpu/idle.c
>> +++ b/kernel/cpu/idle.c
>> @@ -56,6 +56,7 @@ void __weak arch_cpu_idle_dead(void) { }
>>  void __weak arch_cpu_idle(void)
>>  {
>>  	cpu_idle_force_poll = 1;
>> +	local_irq_enable();
>>  }
>>
>>  /*
>>
> 
> This patch looks like the correct fix to me.
> 
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks Srivatsa!

I can push it through the parisc tree if nobody objects...

Helge
