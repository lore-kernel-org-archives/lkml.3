Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3LBPbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:31:25 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40528 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab3LBPbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:31:21 -0500
Message-ID: <529CA6DD.2050108@linux.vnet.ibm.com>
Date: Mon, 02 Dec 2013 20:57:25 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, galak@kernel.crashing.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V4 6/9] cpuidle/ppc: Add basic infrastructure to enable
 the broadcast framework on ppc
References: <20131129104010.651.23117.stgit@preeti.in.ibm.com> <20131129104303.651.40279.stgit@preeti.in.ibm.com> <alpine.DEB.2.02.1311291256180.30673@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1311291256180.30673@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120215-5806-0000-0000-00002390F53F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 11/29/2013 05:28 PM, Thomas Gleixner wrote:
> On Fri, 29 Nov 2013, Preeti U Murthy wrote:
>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index b44b52c..cafa788 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -129,6 +129,8 @@ config PPC
>>  	select GENERIC_CMOS_UPDATE
>>  	select GENERIC_TIME_VSYSCALL_OLD
>>  	select GENERIC_CLOCKEVENTS
>> +	select GENERIC_CLOCKEVENTS_BROADCAST
>> +	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
> 
> What's the point of this config switch? It's nowhere used.

When broadcast IPIs are to be sent, either the "broadcast" method
associated with the local timers is used or an arch-specific method
tick_broadcast() is invoked. For the latter be invoked,
ARCH_HAS_TICK_BROADCAST config needs to be set. On PowerPC, the
broadcast method is not associated with the local timer. Hence we invoke
tick_broadcast(). This function has been added in [PATCH 2/9].
> 
>> +static int broadcast_set_next_event(unsigned long evt,
>> +					struct clock_event_device *dev)
>> +{
>> +	return 0;
>> +}
>> +
>> +static void broadcast_set_mode(enum clock_event_mode mode,
>> +				 struct clock_event_device *dev)
>> +{
>> +	if (mode != CLOCK_EVT_MODE_ONESHOT)
>> +		broadcast_set_next_event(DECREMENTER_MAX, dev);
> 
> What's the point of calling an empty function?  

You are right, this should have remained a dummy function like
broadcast_set_next_event() as per the design of this patchset.
> 
>> +}
>> +
>>  static void decrementer_set_mode(enum clock_event_mode mode,
>>  				 struct clock_event_device *dev)
>>  {
>> @@ -840,6 +869,19 @@ static void register_decrementer_clockevent(int cpu)
>>  	clockevents_register_device(dec);
>>  }
>>  
>> +static void register_broadcast_clockevent(int cpu)
>> +{
>> +	struct clock_event_device *bc_evt = &bc_timer;
>> +
>> +	*bc_evt = broadcast_clockevent;
>> +	bc_evt->cpumask = cpu_possible_mask;
>> +
>> +	printk_once(KERN_DEBUG "clockevent: %s mult[%x] shift[%d] cpu[%d]\n",
>> +		    bc_evt->name, bc_evt->mult, bc_evt->shift, cpu);
>> +
>> +	clockevents_register_device(bc_evt);
>> +}
>> +
>>  static void __init init_decrementer_clockevent(void)
>>  {
>>  	int cpu = smp_processor_id();
>> @@ -854,6 +896,19 @@ static void __init init_decrementer_clockevent(void)
>>  	register_decrementer_clockevent(cpu);
>>  }
>>  
>> +static void __init init_broadcast_clockevent(void)
>> +{
>> +	int cpu = smp_processor_id();
>> +
>> +	clockevents_calc_mult_shift(&broadcast_clockevent, ppc_tb_freq, 4);
>> +
>> +	broadcast_clockevent.max_delta_ns =
>> +		clockevent_delta2ns(DECREMENTER_MAX, &broadcast_clockevent);
>> +	broadcast_clockevent.min_delta_ns =
>> +		clockevent_delta2ns(2, &broadcast_clockevent);
> 
> clockevents_config()

Right, I will change this to call clockevents_config(). I see that this
needs to be done during the initialization of the decrementer as well.
Will do the same.

Thank you

Regards
Preeti U Murthy
> 
> Thanks,
> 
> 	tglx
> 

