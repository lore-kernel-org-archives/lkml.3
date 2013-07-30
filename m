Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab3G3Dvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:51:38 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60121 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3G3Dvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:51:37 -0400
Message-ID: <51F73815.2040406@linux.vnet.ibm.com>
Date: Tue, 30 Jul 2013 09:20:45 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cpuidle/powernv: Enable idle powernv cpu to call
 into the cpuidle framework.
References: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com> <20130723090150.7291.89879.stgit@deepthi.in.ibm.com> <51F35AC7.8060909@linaro.org> <51F67BE5.10701@linux.vnet.ibm.com> <51F67FDE.6070902@linaro.org>
In-Reply-To: <51F67FDE.6070902@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073014-3568-0000-0000-000004013087
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 08:14 PM, Daniel Lezcano wrote:
> On 07/29/2013 04:27 PM, Deepthi Dharwar wrote:
>> On 07/27/2013 10:59 AM, Daniel Lezcano wrote:
>>> On 07/23/2013 11:01 AM, Deepthi Dharwar wrote:
>>>> This patch enables idle powernv cpu to hook on to the cpuidle
>>>> framework, if available, else call on to default idle platform
>>>> code.
>>>
>>> Why do you need to do that ?
>>>
>>
>> Hi Daniel,
>>
>> Well, this is needed in case when one does not compile with CPU_IDLE
>> config option.
>>
>> When CPUIDLE is not configured, idle cpus are needed to be running some
>> sort of default idle code or loop ( in the worst case) if cpuidle driver
>> is not registered or if one decides not to have that config enabled.
> 
> Hi Deepthi,
> 
> ok may be there is some difference with the other platform but the
> arch_cpu_idle function defined in the other archs do:
> 
> void arch_cpu_idle(void)
> {
>         if (cpuidle_idle_call())
>                 x86_idle();
>         else
>                 local_irq_enable();
> }
> 
> or
> 
> void arch_cpu_idle(void)
> {
>         if (cpuidle_idle_call())
>                 default_idle();
> }
> 
> When the cpuidle driver is not compiled or not loaded, cpuidle_idle_call
> fails, falling back to the default idle function.
> 
> The arch_cpu_idle function is called from the generic code in
> kernel/cpu/idle.c.
> 
> Is there a particular reason to do it in a different way ?

On powerpc, we have another parameter, ppc_md.powersave
knob.  In arch_cpu_idle, we check for this knob. This is kernel command
line parameter too. If this is not set then default idle is executed.
ppc_md is generic powerpc structure, which points to idle routine that
needs to be executed.

In arch_cpu_idle code for powerpc:

arch_cpu_idle()
{
   if (ppc_md.powersave())
		ppc_md.powersave()
    } else
	/* default idle */
}

Not all flavors of powerpc arch support cpuidle.
So only those that support, powersave is set to cpuidle backend call.
And this check is necessary there.

Regards,
Deepthi



> Thanks
>   -- Daniel
> 
>>>
>>>> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
>>>> ---
>>>>  arch/powerpc/platforms/powernv/setup.c |   12 +++++++++++-
>>>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
>>>> index 84438af..97d0951 100644
>>>> --- a/arch/powerpc/platforms/powernv/setup.c
>>>> +++ b/arch/powerpc/platforms/powernv/setup.c
>>>> @@ -25,6 +25,7 @@
>>>>  #include <linux/of.h>
>>>>  #include <linux/interrupt.h>
>>>>  #include <linux/bug.h>
>>>> +#include <linux/cpuidle.h>
>>>>  
>>>>  #include <asm/machdep.h>
>>>>  #include <asm/firmware.h>
>>>> @@ -196,6 +197,15 @@ static int __init pnv_probe(void)
>>>>  	return 1;
>>>>  }
>>>>  
>>>> +void powernv_idle(void)
>>>> +{
>>>> +	/* Hook to cpuidle framework if available, else
>>>> +	 * call on default platform idle code
>>>> +	 */
>>>> +	if (cpuidle_idle_call())
>>>> +		power7_idle();
>>>> +}
>>>> +
>>>>  define_machine(powernv) {
>>>>  	.name			= "PowerNV",
>>>>  	.probe			= pnv_probe,
>>>> @@ -205,7 +215,7 @@ define_machine(powernv) {
>>>>  	.show_cpuinfo		= pnv_show_cpuinfo,
>>>>  	.progress		= pnv_progress,
>>>>  	.machine_shutdown	= pnv_shutdown,
>>>> -	.power_save             = power7_idle,
>>>> +	.power_save             = powernv_idle,
>>>>  	.calibrate_decr		= generic_calibrate_decr,
>>>>  #ifdef CONFIG_KEXEC
>>>>  	.kexec_cpu_down		= pnv_kexec_cpu_down,
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>
>>>
>>>
>>
> 
> 

