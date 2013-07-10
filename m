Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3GJLUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:20:43 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:45061 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3GJLUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:20:41 -0400
Message-ID: <51DD445C.5070801@linux.vnet.ibm.com>
Date: Wed, 10 Jul 2013 16:54:12 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Andrew Jones <drjones@redhat.com>, mingo@redhat.com, ouyang@cs.pitt.edu,
        habanero@linux.vnet.ibm.com, jeremy@goop.org, x86@kernel.org,
        konrad.wilk@oracle.com, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, gregkh@suse.de, agraf@suse.de,
        chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
References: <20130601192125.5966.35563.sendpatchset@codeblue> <1372171802.3804.30.camel@oc2024037011.ibm.com> <51CAAA26.4090204@linux.vnet.ibm.com> <20130626113744.GA6300@hawk.usersys.redhat.com> <20130626125240.GY18508@redhat.com> <51CAEF45.3010203@linux.vnet.ibm.com> <20130626161130.GB18152@redhat.com> <51CB2AD9.5060508@linux.vnet.ibm.com> <51DBD3C2.2040807@linux.vnet.ibm.com> <20130710103325.GP24941@redhat.com>
In-Reply-To: <20130710103325.GP24941@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071011-2674-0000-0000-000009BF04F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 04:03 PM, Gleb Natapov wrote:
> On Tue, Jul 09, 2013 at 02:41:30PM +0530, Raghavendra K T wrote:
>> On 06/26/2013 11:24 PM, Raghavendra K T wrote:
>>> On 06/26/2013 09:41 PM, Gleb Natapov wrote:
>>>> On Wed, Jun 26, 2013 at 07:10:21PM +0530, Raghavendra K T wrote:
>>>>> On 06/26/2013 06:22 PM, Gleb Natapov wrote:
>>>>>> On Wed, Jun 26, 2013 at 01:37:45PM +0200, Andrew Jones wrote:
>>>>>>> On Wed, Jun 26, 2013 at 02:15:26PM +0530, Raghavendra K T wrote:
>>>>>>>> On 06/25/2013 08:20 PM, Andrew Theurer wrote:
>>>>>>>>> On Sun, 2013-06-02 at 00:51 +0530, Raghavendra K T wrote:
>>>>>>>>>> This series replaces the existing paravirtualized spinlock
>>>>>>>>>> mechanism
>>>>>>>>>> with a paravirtualized ticketlock mechanism. The series provides
>>>>>>>>>> implementation for both Xen and KVM.
>>>>>>>>>>
>>>>>>>>>> Changes in V9:
>>>>>>>>>> - Changed spin_threshold to 32k to avoid excess halt exits that are
>>>>>>>>>>     causing undercommit degradation (after PLE handler
>>>>>>>>>> improvement).
>>>>>>>>>> - Added  kvm_irq_delivery_to_apic (suggested by Gleb)
>>>>>>>>>> - Optimized halt exit path to use PLE handler
>>>>>>>>>>
>>>>>>>>>> V8 of PVspinlock was posted last year. After Avi's suggestions
>>>>>>>>>> to look
>>>>>>>>>> at PLE handler's improvements, various optimizations in PLE
>>>>>>>>>> handling
>>>>>>>>>> have been tried.
>>>>>>>>>
>>>>>>>>> Sorry for not posting this sooner.  I have tested the v9
>>>>>>>>> pv-ticketlock
>>>>>>>>> patches in 1x and 2x over-commit with 10-vcpu and 20-vcpu VMs.  I
>>>>>>>>> have
>>>>>>>>> tested these patches with and without PLE, as PLE is still not
>>>>>>>>> scalable
>>>>>>>>> with large VMs.
>>>>>>>>>
>>>>>>>>
>>>>>>>> Hi Andrew,
>>>>>>>>
>>>>>>>> Thanks for testing.
>>>>>>>>
>>>>>>>>> System: x3850X5, 40 cores, 80 threads
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> 1x over-commit with 10-vCPU VMs (8 VMs) all running dbench:
>>>>>>>>> ----------------------------------------------------------
>>>>>>>>>                         Total
>>>>>>>>> Configuration                Throughput(MB/s)    Notes
>>>>>>>>>
>>>>>>>>> 3.10-default-ple_on            22945            5% CPU in host
>>>>>>>>> kernel, 2% spin_lock in guests
>>>>>>>>> 3.10-default-ple_off            23184            5% CPU in host
>>>>>>>>> kernel, 2% spin_lock in guests
>>>>>>>>> 3.10-pvticket-ple_on            22895            5% CPU in host
>>>>>>>>> kernel, 2% spin_lock in guests
>>>>>>>>> 3.10-pvticket-ple_off            23051            5% CPU in host
>>>>>>>>> kernel, 2% spin_lock in guests
>>>>>>>>> [all 1x results look good here]
>>>>>>>>
>>>>>>>> Yes. The 1x results look too close
>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> 2x over-commit with 10-vCPU VMs (16 VMs) all running dbench:
>>>>>>>>> -----------------------------------------------------------
>>>>>>>>>                         Total
>>>>>>>>> Configuration                Throughput        Notes
>>>>>>>>>
>>>>>>>>> 3.10-default-ple_on             6287            55% CPU  host
>>>>>>>>> kernel, 17% spin_lock in guests
>>>>>>>>> 3.10-default-ple_off             1849            2% CPU in host
>>>>>>>>> kernel, 95% spin_lock in guests
>>>>>>>>> 3.10-pvticket-ple_on             6691            50% CPU in host
>>>>>>>>> kernel, 15% spin_lock in guests
>>>>>>>>> 3.10-pvticket-ple_off            16464            8% CPU in host
>>>>>>>>> kernel, 33% spin_lock in guests
>>>>>>>>
>>>>>>>> I see 6.426% improvement with ple_on
>>>>>>>> and 161.87% improvement with ple_off. I think this is a very good
>>>>>>>> sign
>>>>>>>>   for the patches
>>>>>>>>
>>>>>>>>> [PLE hinders pv-ticket improvements, but even with PLE off,
>>>>>>>>>   we still off from ideal throughput (somewhere >20000)]
>>>>>>>>>
>>>>>>>>
>>>>>>>> Okay, The ideal throughput you are referring is getting around
>>>>>>>> atleast
>>>>>>>> 80% of 1x throughput for over-commit. Yes we are still far away from
>>>>>>>> there.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> 1x over-commit with 20-vCPU VMs (4 VMs) all running dbench:
>>>>>>>>> ----------------------------------------------------------
>>>>>>>>>                         Total
>>>>>>>>> Configuration                Throughput        Notes
>>>>>>>>>
>>>>>>>>> 3.10-default-ple_on            22736            6% CPU in host
>>>>>>>>> kernel, 3% spin_lock in guests
>>>>>>>>> 3.10-default-ple_off            23377            5% CPU in host
>>>>>>>>> kernel, 3% spin_lock in guests
>>>>>>>>> 3.10-pvticket-ple_on            22471            6% CPU in host
>>>>>>>>> kernel, 3% spin_lock in guests
>>>>>>>>> 3.10-pvticket-ple_off            23445            5% CPU in host
>>>>>>>>> kernel, 3% spin_lock in guests
>>>>>>>>> [1x looking fine here]
>>>>>>>>>
>>>>>>>>
>>>>>>>> I see ple_off is little better here.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> 2x over-commit with 20-vCPU VMs (8 VMs) all running dbench:
>>>>>>>>> ----------------------------------------------------------
>>>>>>>>>                         Total
>>>>>>>>> Configuration                Throughput        Notes
>>>>>>>>>
>>>>>>>>> 3.10-default-ple_on             1965            70% CPU in host
>>>>>>>>> kernel, 34% spin_lock in guests
>>>>>>>>> 3.10-default-ple_off              226            2% CPU in host
>>>>>>>>> kernel, 94% spin_lock in guests
>>>>>>>>> 3.10-pvticket-ple_on             1942            70% CPU in host
>>>>>>>>> kernel, 35% spin_lock in guests
>>>>>>>>> 3.10-pvticket-ple_off             8003            11% CPU in host
>>>>>>>>> kernel, 70% spin_lock in guests
>>>>>>>>> [quite bad all around, but pv-tickets with PLE off the best so far.
>>>>>>>>>   Still quite a bit off from ideal throughput]
>>>>>>>>
>>>>>>>> This is again a remarkable improvement (307%).
>>>>>>>> This motivates me to add a patch to disable ple when pvspinlock is
>>>>>>>> on.
>>>>>>>> probably we can add a hypercall that disables ple in kvm init patch.
>>>>>>>> but only problem I see is what if the guests are mixed.
>>>>>>>>
>>>>>>>>   (i.e one guest has pvspinlock support but other does not. Host
>>>>>>>> supports pv)
>>>>>>>
>>>>>>> How about reintroducing the idea to create per-kvm ple_gap,ple_window
>>>>>>> state. We were headed down that road when considering a dynamic
>>>>>>> window at
>>>>>>> one point. Then you can just set a single guest's ple_gap to zero,
>>>>>>> which
>>>>>>> would lead to PLE being disabled for that guest. We could also revisit
>>>>>>> the dynamic window then.
>>>>>>>
>>>>>> Can be done, but lets understand why ple on is such a big problem.
>>>>>> Is it
>>>>>> possible that ple gap and SPIN_THRESHOLD are not tuned properly?
>>>>>>
>>>>>
>>>>> The one obvious reason I see is commit awareness inside the guest. for
>>>>> under-commit there is no necessity to do PLE, but unfortunately we do.
>>>>>
>>>>> atleast we return back immediately in case of potential undercommits,
>>>>> but we still incur vmexit delay.
>>>> But why do we? If SPIN_THRESHOLD will be short enough (or ple windows
>>>> long enough) to not generate PLE exit we will not go into PLE handler
>>>> at all, no?
>>>>
>>>
>>> Yes. you are right. dynamic ple window was an attempt to solve it.
>>>
>>> Probelm is, reducing the SPIN_THRESHOLD is resulting in excess halt
>>> exits in under-commits and increasing ple_window may be sometimes
>>> counter productive as it affects other busy-wait constructs such as
>>> flush_tlb AFAIK.
>>> So if we could have had a dynamically changing SPIN_THRESHOLD too, that
>>> would be nice.
>>>
>>
>> Gleb, Andrew,
>> I tested with the global ple window change (similar to what I posted
>> here https://lkml.org/lkml/2012/11/11/14 ),
> This does not look global. It changes PLE per vcpu.
>
>> But did not see good result. May be it is good to go with per VM
>> ple_window.
>>
>> Gleb,
>> Can you elaborate little more on what you have in mind regarding per
>> VM ple_window. (maintaining part of it as a per vm variable is clear
>> to
>>   me), but is it that we have to load that every time of guest entry?
>>
> Only when it changes, shouldn't be to often no?
>
>> I 'll try that idea next.
>>
>> Ingo, Gleb,
>>
>>  From the results perspective, Andrew Theurer, Vinod's test results are
>> pro-pvspinlock.
>> Could you please help me to know what will make it a mergeable
>> candidate?.
>>
> I need to spend more time reviewing it :) The problem with PV interfaces
> is that they are easy to add but hard to get rid of if better solution
> (HW or otherwise) appears.

Infact Avi had acked the whole V8 series, but delayed for seeing how
PLE improvement would affect it.

The only addition from that series has been
1. tuning the SPIN_THRESHOLD to 32k (from 2k)
and
2. the halt handler now calls vcpu_on_spin to take the advantage of PLE 
improvements. (this can also go as an independent patch into kvm)

The rationale for making SPIN_THERSHOLD 32k needs big explanation.
Before PLE improvements, as you know,
kvm undercommit scenario was very worse in ple enabled cases. (compared 
to ple disabled cases).
pvspinlock patches behaved equally bad in undercommit. Both had similar 
reason so at the end there was no degradation w.r.t base.

The reason for bad performance in PLE case was unneeded vcpu iteration 
in ple handler resulting in high yield_to calls and double run queue locks.
With pvspinlock applied, same villain role was played by excessive halt 
exits.

But after ple handler improved, we needed to throttle unnecessary halts
in undercommit for pvspinlock to be on par with 1x result.

>
>> I agree that Jiannan's Preemptable Lock idea is promising and we could
>> evaluate that  approach, and make the best one get into kernel and also
>> will carry on discussion with Jiannan to improve that patch.
> That would be great. The work is stalled from what I can tell.

Jiannan is trying to improve that. and also 'am helping with testing
etc internally too.
Despite of being a great idea some how, hardcoded TIMEOUT to delay
the checking the lock availability is somehow not working great, and
still seeing some softlockups. AFAIK, Linus also hated TIMEOUT idea
in Rik's spinlock backoff patches because it is difficult to tune on 
baremetal and can have some adverse effect on virtualization too.

