Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3GAJ1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:27:15 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:42093 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3GAJ1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:27:11 -0400
Message-ID: <51D14C47.5030909@linux.vnet.ibm.com>
Date: Mon, 01 Jul 2013 15:00:47 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: habanero@linux.vnet.ibm.com
CC: Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>,
        mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        konrad.wilk@oracle.com, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
References: <20130601192125.5966.35563.sendpatchset@codeblue> <1372171802.3804.30.camel@oc2024037011.ibm.com> <51CAAA26.4090204@linux.vnet.ibm.com> <20130626113744.GA6300@hawk.usersys.redhat.com> <20130626125240.GY18508@redhat.com> <1372262213.31391.176.camel@oc6622382223.ibm.com>
In-Reply-To: <1372262213.31391.176.camel@oc6622382223.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070109-5816-0000-0000-000008B486D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 09:26 PM, Andrew Theurer wrote:
> On Wed, 2013-06-26 at 15:52 +0300, Gleb Natapov wrote:
>> On Wed, Jun 26, 2013 at 01:37:45PM +0200, Andrew Jones wrote:
>>> On Wed, Jun 26, 2013 at 02:15:26PM +0530, Raghavendra K T wrote:
>>>> On 06/25/2013 08:20 PM, Andrew Theurer wrote:
>>>>> On Sun, 2013-06-02 at 00:51 +0530, Raghavendra K T wrote:
>>>>>> This series replaces the existing paravirtualized spinlock mechanism
>>>>>> with a paravirtualized ticketlock mechanism. The series provides
>>>>>> implementation for both Xen and KVM.
>>>>>>
>>>>>> Changes in V9:
>>>>>> - Changed spin_threshold to 32k to avoid excess halt exits that are
>>>>>>     causing undercommit degradation (after PLE handler improvement).
>>>>>> - Added  kvm_irq_delivery_to_apic (suggested by Gleb)
>>>>>> - Optimized halt exit path to use PLE handler
>>>>>>
>>>>>> V8 of PVspinlock was posted last year. After Avi's suggestions to look
>>>>>> at PLE handler's improvements, various optimizations in PLE handling
>>>>>> have been tried.
>>>>>
>>>>> Sorry for not posting this sooner.  I have tested the v9 pv-ticketlock
>>>>> patches in 1x and 2x over-commit with 10-vcpu and 20-vcpu VMs.  I have
>>>>> tested these patches with and without PLE, as PLE is still not scalable
>>>>> with large VMs.
>>>>>
>>>>
>>>> Hi Andrew,
>>>>
>>>> Thanks for testing.
>>>>
>>>>> System: x3850X5, 40 cores, 80 threads
>>>>>
>>>>>
>>>>> 1x over-commit with 10-vCPU VMs (8 VMs) all running dbench:
>>>>> ----------------------------------------------------------
>>>>> 						Total
>>>>> Configuration				Throughput(MB/s)	Notes
>>>>>
>>>>> 3.10-default-ple_on			22945			5% CPU in host kernel, 2% spin_lock in guests
>>>>> 3.10-default-ple_off			23184			5% CPU in host kernel, 2% spin_lock in guests
>>>>> 3.10-pvticket-ple_on			22895			5% CPU in host kernel, 2% spin_lock in guests
>>>>> 3.10-pvticket-ple_off			23051			5% CPU in host kernel, 2% spin_lock in guests
>>>>> [all 1x results look good here]
>>>>
>>>> Yes. The 1x results look too close
>>>>
>>>>>
>>>>>
>>>>> 2x over-commit with 10-vCPU VMs (16 VMs) all running dbench:
>>>>> -----------------------------------------------------------
>>>>> 						Total
>>>>> Configuration				Throughput		Notes
>>>>>
>>>>> 3.10-default-ple_on			 6287			55% CPU  host kernel, 17% spin_lock in guests
>>>>> 3.10-default-ple_off			 1849			2% CPU in host kernel, 95% spin_lock in guests
>>>>> 3.10-pvticket-ple_on			 6691			50% CPU in host kernel, 15% spin_lock in guests
>>>>> 3.10-pvticket-ple_off			16464			8% CPU in host kernel, 33% spin_lock in guests
>>>>
>>>> I see 6.426% improvement with ple_on
>>>> and 161.87% improvement with ple_off. I think this is a very good sign
>>>>   for the patches
>>>>
>>>>> [PLE hinders pv-ticket improvements, but even with PLE off,
>>>>>   we still off from ideal throughput (somewhere >20000)]
>>>>>
>>>>
>>>> Okay, The ideal throughput you are referring is getting around atleast
>>>> 80% of 1x throughput for over-commit. Yes we are still far away from
>>>> there.
>>>>
>>>>>
>>>>> 1x over-commit with 20-vCPU VMs (4 VMs) all running dbench:
>>>>> ----------------------------------------------------------
>>>>> 						Total
>>>>> Configuration				Throughput		Notes
>>>>>
>>>>> 3.10-default-ple_on			22736			6% CPU in host kernel, 3% spin_lock in guests
>>>>> 3.10-default-ple_off			23377			5% CPU in host kernel, 3% spin_lock in guests
>>>>> 3.10-pvticket-ple_on			22471			6% CPU in host kernel, 3% spin_lock in guests
>>>>> 3.10-pvticket-ple_off			23445			5% CPU in host kernel, 3% spin_lock in guests
>>>>> [1x looking fine here]
>>>>>
>>>>
>>>> I see ple_off is little better here.
>>>>
>>>>>
>>>>> 2x over-commit with 20-vCPU VMs (8 VMs) all running dbench:
>>>>> ----------------------------------------------------------
>>>>> 						Total
>>>>> Configuration				Throughput		Notes
>>>>>
>>>>> 3.10-default-ple_on			 1965			70% CPU in host kernel, 34% spin_lock in guests		
>>>>> 3.10-default-ple_off			  226			2% CPU in host kernel, 94% spin_lock in guests
>>>>> 3.10-pvticket-ple_on			 1942			70% CPU in host kernel, 35% spin_lock in guests
>>>>> 3.10-pvticket-ple_off			 8003			11% CPU in host kernel, 70% spin_lock in guests
>>>>> [quite bad all around, but pv-tickets with PLE off the best so far.
>>>>>   Still quite a bit off from ideal throughput]
>>>>
>>>> This is again a remarkable improvement (307%).
>>>> This motivates me to add a patch to disable ple when pvspinlock is on.
>>>> probably we can add a hypercall that disables ple in kvm init patch.
>>>> but only problem I see is what if the guests are mixed.
>>>>
>>>>   (i.e one guest has pvspinlock support but other does not. Host
>>>> supports pv)
>>>
>>> How about reintroducing the idea to create per-kvm ple_gap,ple_window
>>> state. We were headed down that road when considering a dynamic window at
>>> one point. Then you can just set a single guest's ple_gap to zero, which
>>> would lead to PLE being disabled for that guest. We could also revisit
>>> the dynamic window then.
>>>
>> Can be done, but lets understand why ple on is such a big problem. Is it
>> possible that ple gap and SPIN_THRESHOLD are not tuned properly?
>
> The biggest problem currently is the double_runqueue_lock from
> yield_to():
> [2x overcommit with 20-vCPU VMs (8 VMs) all running dbench]
>
> perf from host:
>> 28.27%        396402  qemu-system-x86  [kernel.kallsyms]        [k] _raw_spin_lock
>>   4.65%         65667  qemu-system-x86  [kernel.kallsyms]        [k] __schedule
>>   3.87%         54802  qemu-system-x86  [kernel.kallsyms]        [k] finish_task_switch
>>   3.32%         47022  qemu-system-x86  [kernel.kallsyms]        [k] perf_event_task_sched_out
>>   2.84%         40093  qemu-system-x86  [kvm_intel]              [k] vmx_vcpu_run
>>   2.70%         37672  qemu-system-x86  [kernel.kallsyms]        [k] yield_to
>>   2.63%         36859  qemu-system-x86  [kvm]                    [k] kvm_vcpu_on_spin
>>   2.18%         30810  qemu-system-x86  [kvm_intel]              [k] __vmx_load_host_state
>
> A tiny patch [included below] checks if the target task is running
> before double_runqueue_lock (then bails if it is running).  This does
> reduce the lock contention somewhat:
>
> [2x overcommit with 20-vCPU VMs (8 VMs) all running dbench]
>
> perf from host:
>> 20.51%        284829  qemu-system-x86  [kernel.kallsyms]        [k] _raw_spin_lock
>>   5.21%         72949  qemu-system-x86  [kernel.kallsyms]        [k] __schedule
>>   3.70%         51962  qemu-system-x86  [kernel.kallsyms]        [k] finish_task_switch
>>   3.50%         48607  qemu-system-x86  [kvm]                    [k] kvm_vcpu_on_spin
>>   3.22%         45214  qemu-system-x86  [kernel.kallsyms]        [k] perf_event_task_sched_out
>>   3.18%         44546  qemu-system-x86  [kvm_intel]              [k] vmx_vcpu_run
>>   3.13%         43176  qemu-system-x86  [kernel.kallsyms]        [k] yield_to
>>   2.37%         33349  qemu-system-x86  [kvm_intel]              [k] __vmx_load_host_state
>>   2.06%         28503  qemu-system-x86  [kernel.kallsyms]        [k] get_pid_task
>
> So, the lock contention is reduced, and the results improve slightly
> over default PLE/yield_to (in this case 1942 -> 2161, 11%), but this is
> still far off from no PLE at all (8003) and way off from a ideal
> throughput (>20000).
>
> One of the problems, IMO, is that we are chasing our tail and burning
> too much CPU trying to fix the problem, but much of what is done is not
> actually fixing the problem (getting the one vcpu holding the lock to
> run again).  We end up spending a lot of cycles getting a lot of vcpus
> running again, and most of them are not holding that lock.  One
> indication of this is the context switches in the host:
>
> [2x overcommit with 20-vCPU VMs (8 VMs) all running dbench]
>
> pvticket with PLE on:  2579227.76/sec
> pvticket with PLE pff:  233711.30/sec
>
> That's over 10x context switches with PLE on.  All of this is for
> yield_to, but IMO most of vcpus are probably yielding to vcpus which are
> not actually holding the lock.
>
> I would like to see how this changes by tracking the lock holder in the
> pvticket lock structure, and when a vcpu spins beyond a threshold, the
> vcpu makes a hypercall to yield_to a -vCPU-it-specifies-, the one it
> knows to be holding the lock.  Note that PLE is no longer needed for
> this and the PLE detection should probably be disabled when the guest
> has this ability.
>
> Additionally, when other vcpus reach their spin threshold and also
> identify the same target vcpu (the same lock), they may opt to not make
> the yield_to hypercall, if another vcpu made the yield_to hypercall to
> the same target vcpu -very-recently-, thus avoiding a redundant exit and
> yield_to.
>
> Another optimization may be to allow vcpu preemption to be visible
> -inside- the guest.  If a vcpu reaches the spin threshold, then
> identifies the lock holding vcpu, it then checks to see if a preemption
> bit is set for that vcpu.  If it is not set, then it does nothing, and
> if it is, it makes the yield_to hypercall.  This should help for locks
> which really do have a big critical section, and the vcpus really do
> need to spin for a while.
>
> OK, one last thing.  This is a completely different approach at the
> problem:  automatically adjust active vcpus from within a guest, with
> some sort of daemon (vcpud?) to approximate the actual host cpu resource
> available.  The daemon would monitor steal time and hot unplug vcpus to
> reduce steal time to a small percentage. ending up with a slight cpu
> overcommit.  It would also have to online vcpus if more cpu resource is
> made available, again looking at steal time and adding vcpus until steal
> time increases to a small percentage.  I am not sure if the overhead of
> plugging/unplugging is worth it, but I would bet the guest would be far
> more efficient, because (a) PLE and pvticket would be handling much
> lower effective cpu overcommit (let's say ~1.1x) and (b) the guest and
> its applications would have much better scalability because the active
> vcpu count is much lower.
>
> So, let's see what one of those situations would look like, without
> actually writing something to do the unplugging/plugging for us.  Let's
> take the one of the examples above, where we have 8 VMs, each defined
> with 20 vcpus, for 2x overcommit, but let's unplug 9 vcpus in each of
> the VMs, so we end up with a 1.1x effective overcommit (the last test
> below).
>
> [2x overcommit with 20-vCPU VMs (8 VMs) all running dbench]
>
> 							Total
> Configuration						Throughput	Notes
>
> 3.10-default-ple_on					1965		70% CPU in host kernel, 34% spin_lock in guests		
> 3.10-default-ple_off			 		 226		2% CPU in host kernel, 94% spin_lock in guests
> 3.10-pvticket-ple_on			 		1942		70% CPU in host kernel, 35% spin_lock in guests
> 3.10-pvticket-ple_off			 		8003		11% CPU in host kernel, 70% spin_lock in guests
> 3.10-pvticket-ple-on_doublerq-opt	 		2161		68% CPU in host kernel, 33% spin_lock in guests		
> 3.10-pvticket-ple_on_doublerq-opt_9vcpus-unplugged	22534		6% CPU in host kernel,  9% steal in guests, 2% spin_lock in guests
>
> Finally, we get a nice result!  Note this is the lowest spin % in the guest.  The spin_lock in the host is also quite a bit better:
>
>
>> 6.77%         55421  qemu-system-x86  [kernel.kallsyms]        [k] _raw_spin_lock
>> 4.29%         57345  qemu-system-x86  [kvm_intel]              [k] vmx_vcpu_run
>> 3.87%         62049  qemu-system-x86  [kernel.kallsyms]        [k] native_apic_msr_write
>> 2.88%         45272  qemu-system-x86  [kernel.kallsyms]        [k] atomic_dec_and_mutex_lock
>> 2.71%         39276  qemu-system-x86  [kvm]                    [k] vcpu_enter_guest
>> 2.48%         38886  qemu-system-x86  [kernel.kallsyms]        [k] memset
>> 2.22%         18331  qemu-system-x86  [kvm]                    [k] kvm_vcpu_on_spin
>> 2.09%         32628  qemu-system-x86  [kernel.kallsyms]        [k] perf_event_alloc
>
> Also the host context switches dropped significantly (66%), to 38768/sec.
>
> -Andrew
>
>
>
>
>
> Patch to reduce double runqueue lock in yield_to():
>
> Signed-off-by: Andrew Theurer <habanero@linux.vnet.ibm.com>
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58453b8..795d324 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4454,6 +4454,9 @@ again:
>   		goto out_irq;
>   	}
>
> +	if (task_running(p_rq, p) || p->state)
> +		goto out_irq;
> +
>   	double_rq_lock(rq, p_rq);
>   	while (task_rq(p) != p_rq) {
>   		double_rq_unlock(rq, p_rq);
>
>

Hi Andrew,
I found that this patch, indeed helped to gain little more on top of
V10 pvspinlock patches in my test.

Here is the result on 32vcpus guest on 32 core machine (HT diabled)
test again.

patched kernel = 3.10-rc2 + v10 pvspinlock + reducing double rq patch


+---+-----------+-----------+-----------+------------+-----------+
                 ebizzy (rec/sec higher is better)
+---+-----------+-----------+-----------+------------+-----------+
       base      stdev         patched       stdev     %improvement
+---+-----------+-----------+-----------+------------+-----------+
1x   5574.9000   237.4997	  5494.6000   164.7451	  -1.44038
2x   2741.5000   561.3090	  3472.6000    98.6376	  26.66788
3x   2146.2500   216.7718	  2293.6667    56.7872	   6.86857
4x   1663.0000   141.9235	  1856.0000   120.7524	  11.60553
+---+-----------+-----------+-----------+------------+-----------+
+---+-----------+-----------+-----------+------------+-----------+
                 dbench (throughput higher is better)
+---+-----------+-----------+-----------+------------+-----------+
        base      stdev         patched       stdev     %improvement
+---+-----------+-----------+-----------+------------+-----------+
1x   14111.5600   754.4525	 14695.3600   104.6816	   4.13703
2x    2481.6270    71.2665	  2774.8420    58.4845	  11.81543
3x    1510.2483    31.8634	  1539.7300    36.1814	   1.95211
4x    1029.4875    16.9166	  1059.9800    27.4114	   2.96191
+---+-----------+-----------+-----------+------------+-----------+


