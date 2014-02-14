Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaBNLZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:25:39 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:53545 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaBNLZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:25:35 -0500
Message-ID: <52FDFD3D.2010207@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 16:55:49 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] PPC: powernv: remove redundant cpuidle_idle_call()
References: <1391696188-14540-1-git-send-email-nicolas.pitre@linaro.org> <52FDFB4C.7010607@linux.vnet.ibm.com>
In-Reply-To: <52FDFB4C.7010607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021411-2674-0000-0000-00000CB7C7D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 04:47 PM, Preeti U Murthy wrote:
> Hi Nicolas,
> 
> You will have to include the below patch with yours. You
> could squash the two I guess, I have added the changelog
> just for clarity. And you also might want to change the subject to
> cpuidle/powernv. It gives a better picture.
> 
> Thanks
> 
> Regards
> Preeti U Murthy
> 
> 
> cpuidle/powernv: Add ppc64_runlatch_off/on() to idle routines
> 
> Following moving of cpuidle_idle_call() to the generic idle loop, we need to
> add the runlatch functions to the idle routines on powernv which was earlier
> taken care of by the arch specific idle routine.
> 
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Reviewed-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

> ---
>  drivers/cpuidle/cpuidle-powernv.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
> index 78fd174..f48607c 100644
> --- a/drivers/cpuidle/cpuidle-powernv.c
> +++ b/drivers/cpuidle/cpuidle-powernv.c
> @@ -14,6 +14,7 @@
> 
>  #include <asm/machdep.h>
>  #include <asm/firmware.h>
> +#include <asm/runlatch.h>
> 
>  struct cpuidle_driver powernv_idle_driver = {
>  	.name             = "powernv_idle",
> @@ -30,12 +31,14 @@ static int snooze_loop(struct cpuidle_device *dev,
>  	local_irq_enable();
>  	set_thread_flag(TIF_POLLING_NRFLAG);
> 
> +	ppc64_runlatch_off();
>  	while (!need_resched()) {
>  		HMT_low();
>  		HMT_very_low();
>  	}
> 
>  	HMT_medium();
> +	ppc64_runlatch_on();
>  	clear_thread_flag(TIF_POLLING_NRFLAG);
>  	smp_mb();
>  	return index;
> @@ -45,7 +48,9 @@ static int nap_loop(struct cpuidle_device *dev,
>  			struct cpuidle_driver *drv,
>  			int index)
>  {
> +	ppc64_runlatch_off();
>  	power7_idle();
> +	ppc64_runlatch_on();
>  	return index;
>  }
> 
> 
> On 02/06/2014 07:46 PM, Nicolas Pitre wrote:
>> The core idle loop now takes care of it.
>>
>> Signed-off-by: Nicolas Pitre <nico@linaro.org>
>> ---
>>  arch/powerpc/platforms/powernv/setup.c | 13 +------------
>>  1 file changed, 1 insertion(+), 12 deletions(-)
>>
>> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
>> index 21166f65c9..a932feb290 100644
>> --- a/arch/powerpc/platforms/powernv/setup.c
>> +++ b/arch/powerpc/platforms/powernv/setup.c
>> @@ -26,7 +26,6 @@
>>  #include <linux/of_fdt.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/bug.h>
>> -#include <linux/cpuidle.h>
>>
>>  #include <asm/machdep.h>
>>  #include <asm/firmware.h>
>> @@ -217,16 +216,6 @@ static int __init pnv_probe(void)
>>  	return 1;
>>  }
>>
>> -void powernv_idle(void)
>> -{
>> -	/* Hook to cpuidle framework if available, else
>> -	 * call on default platform idle code
>> -	 */
>> -	if (cpuidle_idle_call()) {
>> -		power7_idle();
>> -	}
>> -}
>> -
>>  define_machine(powernv) {
>>  	.name			= "PowerNV",
>>  	.probe			= pnv_probe,
>> @@ -236,7 +225,7 @@ define_machine(powernv) {
>>  	.show_cpuinfo		= pnv_show_cpuinfo,
>>  	.progress		= pnv_progress,
>>  	.machine_shutdown	= pnv_shutdown,
>> -	.power_save             = powernv_idle,
>> +	.power_save             = power7_idle,
>>  	.calibrate_decr		= generic_calibrate_decr,
>>  #ifdef CONFIG_KEXEC
>>  	.kexec_cpu_down		= pnv_kexec_cpu_down,
>>
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

