Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaLNLuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 06:50:12 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:32921 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaLNLuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 06:50:08 -0500
Message-ID: <548D7967.2060403@linux.vnet.ibm.com>
Date: Sun, 14 Dec 2014 17:19:59 +0530
From: Shreyas B Prabhu <shreyas@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
CC: linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paul Mackerras <paulus@samba.org>,
        "Preeti U. Murthy" <preeti@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [v3, 2/4] powerpc/powernv: Enable Offline CPUs to enter deep
 idle states
References: <20141214100558.B40551400B7@ozlabs.org>
In-Reply-To: <20141214100558.B40551400B7@ozlabs.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121411-0025-0000-0000-000002657AC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sunday 14 December 2014 03:35 PM, Michael Ellerman wrote:
> On Thu, 2014-04-12 at 07:28:21 UTC, "Shreyas B. Prabhu" wrote:
>> From: "Preeti U. Murthy" <preeti@linux.vnet.ibm.com>
>>
>> The secondary threads should enter deep idle states so as to gain maximum
>> powersavings when the entire core is offline. To do so the offline path
>> must be made aware of the available deepest idle state. Hence probe the
>> device tree for the possible idle states in powernv core code and
>> expose the deepest idle state through flags.
>>
>> Since the  device tree is probed by the cpuidle driver as well, move
>> the parameters required to discover the idle states into an appropriate
>> common place to both the driver and the powernv core code.
>>
>> Another point is that fastsleep idle state may require workarounds in
>> the kernel to function properly. This workaround is introduced in the
>> subsequent patches. However neither the cpuidle driver or the hotplug
>> path need be bothered about this workaround.
>>
>> They will be taken care of by the core powernv code.
> 
>  ...
> 
>> diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
>> index 4753958..3dc4cec 100644
>> --- a/arch/powerpc/platforms/powernv/smp.c
>> +++ b/arch/powerpc/platforms/powernv/smp.c
>> @@ -159,13 +160,17 @@ static void pnv_smp_cpu_kill_self(void)
>>  	generic_set_cpu_dead(cpu);
>>  	smp_wmb();
>>  
>> +	idle_states = pnv_get_supported_cpuidle_states();
>>  	/* We don't want to take decrementer interrupts while we are offline,
>>  	 * so clear LPCR:PECE1. We keep PECE2 enabled.
>>  	 */
>>  	mtspr(SPRN_LPCR, mfspr(SPRN_LPCR) & ~(u64)LPCR_PECE1);
>>  	while (!generic_check_cpu_restart(cpu)) {
>>  		ppc64_runlatch_off();
>> -		power7_nap(1);
>> +		if (idle_states & OPAL_PM_SLEEP_ENABLED)
>> +			power7_sleep();
>> +		else
>> +			power7_nap(1);
> 
> So I might be missing something subtle here, but aren't we potentially enabling
> sleep here, prior to your next patch which makes it safe to actually use sleep?
> 
> Shouldn't we only allow sleep after patch 3? Or in other words shouldn't this
> be patch 3 (or 4)?
> 

A point to note here, when sleep is exposed in device tree under ibm,cpu-idle-state-flags,
we use 2 bits, OPAL_PM_SLEEP_ENABLED and OPAL_PM_SLEEP_ENABLED_ER1. This patch only enables
sleep in OPAL_PM_SLEEP_ENABLED case. In current POWER8 chips, sleep is exposed as 
OPAL_PM_SLEEP_ENABLED_ER1, indicating the hardware bug and the need for fastsleep
workaround. And bulk of the redesign introduced in next patch helps fastsleep workaround
and winkle. 

That said, using sleep without "powernv: cpuidle: Redesign idle states management"
does expose us to a bug with performing VM migration onto subcores. But not enabling
here (i.e offline case) until next patch doesn't make much difference as the cpuidle 
framework has already enabled sleep.

In other words, OPAL_PM_SLEEP_ENABLED case will come into picture when the hardware
bug around fastsleep is fixed. And in this case running any kernel without "powernv: 
cpuidle: Redesign idle states management" does expose us to a bug with sleep + VM 
migration onto subcores, because cpuidle enables sleep based on OPAL_PM_SLEEP_ENABLED 
bit. IMO delaying enabling of sleep in OPAL_PM_SLEEP_ENABLED case until next patch, 
only for offline cpus should not gain us much. But I'll be happy to resend the patches
with the change if you think it is required.


Thanks,
Shreyas

