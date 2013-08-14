Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684Ab3HNN1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:27:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52678 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab3HNN1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:27:38 -0400
Message-ID: <520B85C8.5030908@arm.com>
Date: Wed, 14 Aug 2013 14:27:36 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [GIT PULL] DT/core: cpu_ofnode updates for v3.12
References: <5208E2D3.7060005@arm.com> <3356439.a21MloFP7n@vostro.rjw.lan>  <520A536C.3030600@arm.com> <520A7B00.8060405@arm.com> <1376428024.4255.14.camel@pasglop> <520B5584.7030608@arm.com> <520B7DAE.3060501@gmail.com>
In-Reply-To: <520B7DAE.3060501@gmail.com>
X-OriginalArrivalTime: 14 Aug 2013 13:27:33.0969 (UTC) FILETIME=[08EEAC10:01CE98F2]
X-MC-Unique: 113081414273602701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/08/13 13:53, Rob Herring wrote:
> On 08/14/2013 05:01 AM, Sudeep KarkadaNagesha wrote:
>> On 13/08/13 22:07, Benjamin Herrenschmidt wrote:
>>> On Tue, 2013-08-13 at 19:29 +0100, Sudeep KarkadaNagesha wrote:
>>>> I don't understand completely the use of ibm,ppc-interrupt-server#s and
>>>> its implications on generic of_get_cpu_node implementation.
>>>> I see the PPC specific definition of of_get_cpu_node uses thread id only
>>>> in 2 instances. Based on that, I have tried to move all the other
>>>> instances to use generic definition.
>>>>
>>>> Let me know if the idea is correct.
>>>
>>> No. The device-tree historically only represents cores, not HW threads, so
>>> it makes sense to retrieve also the thread number corresponding to the CPU.
>>>
>> Ok
>>
>>> However, the mechanism to represent HW threads in the device-tree is currently
>>> somewhat platform specific (the ibm,ppc-interrupt-server#s).
>> I see most of the callers pass NULL to thread id argument except 2
>> instances in entire tree. If that's the case why can't we move to use
>> generic of_get_cpu_node in most of those cases and have PPC specific
>> implementation for the ones using thread id.
>>
>>>
>>> So what you could do for now is:
>>>
>>>  - Have a generic version that always returns 0 as the thread, which is weak
>> I would prefer to move to generic of_get_cpu_node where ever possible
>> and rename the function that takes thread id rather than making generic
>> one weak.
>>
>>>
>>>  - powerpc keeps its own implementation
>> How about only in cases where it needs thread_id.
>>
>>>
>>>  - Start a discussion on the bindings (if not already there) to define threads
>>> in a better way at which point the generic function can be updated.
>>>
>> I am not sure if we need to define any new bindings. Excerpts from ePAPR
>> (v1.1):
>> "3.7.1 General Properties of CPU nodes
>> The value of "reg" is a <prop-encoded-array> that defines a unique
>> CPU/thread id for the CPU/threads represented by the CPU node.
>> If a CPU supports more than one thread (i.e. multiple streams of
>> execution) the reg property is an array with 1 element per thread. The
>> #address-cells on the /cpus node specifies how many cells each element
>> of the array takes. Software can determine the number of threads by
>> dividing the size of reg by the parent node's #address-cells."
>>
>> And this is exactly in agreement to what's implemented in the generic
>> of_get_cpu_node:
>>
>> for_each_child_of_node(cpus, cpun) {
>>         if (of_node_cmp(cpun->type, "cpu"))
>>                 continue;
>>         cell = of_get_property(cpun, "reg", &prop_len);
>>         if (!cell) {
>>                 pr_warn("%s: missing reg property\n", cpun->full_name);
>>                 continue;
>>         }
>>         prop_len /= sizeof(*cell);
>>         while (prop_len) {
>>                 hwid = of_read_number(cell, ac);
>>                 prop_len -= ac;
>>                 if (arch_match_cpu_phys_id(cpu, hwid))
>>                         return cpun;
>>         }
>> }
> 
> How about something like this:
> 
> for_each_child_of_node(cpus, cpun) {
>         if (of_node_cmp(cpun->type, "cpu"))
>                 continue;
> 
> 	if (arch_of_get_cpu_node(cpun, thread))
> 		return cpun;
> 
>         cell = of_get_property(cpun, "reg", &prop_len);
>         if (!cell) {
>                 pr_warn("%s: missing reg property\n", cpun->full_name);
>                 continue;
>         }
>         prop_len /= sizeof(*cell);
>         while (prop_len) {
>                 hwid = of_read_number(cell, ac);
>                 prop_len -= ac;
>                 if (arch_match_cpu_phys_id(cpu, hwid))
>        	                return cpun;
>         }
> }
> 
> For PPC:
> 
> arch_of_get_cpu_node()
> {
>         const u32 *intserv;
>         unsigned int plen, t;
> 
>         /* Check for ibm,ppc-interrupt-server#s. */
>         intserv = of_get_property(np, "ibm,ppc-interrupt-server#s",
>                                 &plen);
>         if (!intserv)
> 		return false;
> 
> 	hardid = get_hard_smp_processor_id(cpu);
> 
>         plen /= sizeof(u32);
>         for (t = 0; t < plen; t++) {
>                  if (hardid == intserv[t]) {
>                          if (thread)
>                                   *thread = t;
>                          return true;
>                  }
>         }
> 	return false;
> }
> 

Sorry responded to earlier mail before seeing this. This approach looks
good, but we still need to have thread id as argument which should be fine.

But as per my understanding on how logical cpu<->hard proccessor id is
setup, the thread_id is implicit in the logical cpu id making it
unnecessary to depend on DT each time.

Regards,
Sudeep

>>
>> Yes this doesn't cover the historical "ibm,ppc-interrupt-server#s", for
>> which we can have PPC specific wrapper above the generic one i.e. get
>> the cpu node and then parse for thread id under custom property.
>>
>> Let me know your thoughts.
>>
>> Regards,
>> Sudeep
>>
>>
>>
> 
> 


