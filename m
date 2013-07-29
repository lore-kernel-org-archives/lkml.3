Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3G2O2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:28:43 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47098 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3G2O2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:28:40 -0400
Message-ID: <51F67BE5.10701@linux.vnet.ibm.com>
Date: Mon, 29 Jul 2013 19:57:49 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cpuidle/powernv: Enable idle powernv cpu to call
 into the cpuidle framework.
References: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com> <20130723090150.7291.89879.stgit@deepthi.in.ibm.com> <51F35AC7.8060909@linaro.org>
In-Reply-To: <51F35AC7.8060909@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072914-7014-0000-0000-000003648B3E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 10:59 AM, Daniel Lezcano wrote:
> On 07/23/2013 11:01 AM, Deepthi Dharwar wrote:
>> This patch enables idle powernv cpu to hook on to the cpuidle
>> framework, if available, else call on to default idle platform
>> code.
> 
> Why do you need to do that ?
> 

Hi Daniel,

Well, this is needed in case when one does not compile with CPU_IDLE
config option.

When CPUIDLE is not configured, idle cpus are needed to be running some
sort of default idle code or loop ( in the worst case) if cpuidle driver
is not registered or if one decides not to have that config enabled.

Regards,
Deepthi

> 
>> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
>> ---
>>  arch/powerpc/platforms/powernv/setup.c |   12 +++++++++++-
>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
>> index 84438af..97d0951 100644
>> --- a/arch/powerpc/platforms/powernv/setup.c
>> +++ b/arch/powerpc/platforms/powernv/setup.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/of.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/bug.h>
>> +#include <linux/cpuidle.h>
>>  
>>  #include <asm/machdep.h>
>>  #include <asm/firmware.h>
>> @@ -196,6 +197,15 @@ static int __init pnv_probe(void)
>>  	return 1;
>>  }
>>  
>> +void powernv_idle(void)
>> +{
>> +	/* Hook to cpuidle framework if available, else
>> +	 * call on default platform idle code
>> +	 */
>> +	if (cpuidle_idle_call())
>> +		power7_idle();
>> +}
>> +
>>  define_machine(powernv) {
>>  	.name			= "PowerNV",
>>  	.probe			= pnv_probe,
>> @@ -205,7 +215,7 @@ define_machine(powernv) {
>>  	.show_cpuinfo		= pnv_show_cpuinfo,
>>  	.progress		= pnv_progress,
>>  	.machine_shutdown	= pnv_shutdown,
>> -	.power_save             = power7_idle,
>> +	.power_save             = powernv_idle,
>>  	.calibrate_decr		= generic_calibrate_decr,
>>  #ifdef CONFIG_KEXEC
>>  	.kexec_cpu_down		= pnv_kexec_cpu_down,
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 

