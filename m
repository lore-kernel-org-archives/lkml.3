Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaLEK6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:58:16 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45831 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaLEK6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:58:15 -0500
Message-ID: <54818FB1.9010901@linux.vnet.ibm.com>
Date: Fri, 05 Dec 2014 16:27:53 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        Jingchang Lu <jingchang.lu@freescale.com>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm: ls1021a: setup hrtimer based tick broadcast
References: <1417770449-3492-1-git-send-email-jingchang.lu@freescale.com> <20141205102714.GD11889@leverpostej>
In-Reply-To: <20141205102714.GD11889@leverpostej>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120510-0033-0000-0000-0000013B8DCF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 03:57 PM, Mark Rutland wrote:
> Hi,
> 
> On Fri, Dec 05, 2014 at 09:07:29AM +0000, Jingchang Lu wrote:
>> This adds setup of hrtimer based tick broadcast to utilize
>> the hrtimer in SMP without other broadcast tick devices.
>>
>> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> 
> This shouldn't live in board code.
> 
> Similarly to what happens with the generic dummy timer on all arches
> that select it (and the broadcast hrtimer on all arches that use it so
> far), we should just unconditionally register the broadcast hrtimer.
> 
> A real broadcast-capable clock event device will take preference if
> present, so we don't need to add board-specific code to only register
> this in certain conditions.

Hmm.. this makes sense to me. Let me send out a patch to do this.

Regards
Preeti U Murthy
> 
> Mark.
> 
>> ---
>>  arch/arm/mach-imx/mach-ls1021a.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/arm/mach-imx/mach-ls1021a.c b/arch/arm/mach-imx/mach-ls1021a.c
>> index b89c858..4d074cf 100644
>> --- a/arch/arm/mach-imx/mach-ls1021a.c
>> +++ b/arch/arm/mach-imx/mach-ls1021a.c
>> @@ -7,6 +7,10 @@
>>   * (at your option) any later version.
>>   */
>>  
>> +#include <linux/clockchips.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/clocksource.h>
>> +
>>  #include <asm/mach/arch.h>
>>  
>>  #include "common.h"
>> @@ -16,7 +20,15 @@ static const char * const ls1021a_dt_compat[] __initconst = {
>>  	NULL,
>>  };
>>  
>> +static void __init ls1021a_init_time(void)
>> +{
>> +	of_clk_init(NULL);
>> +	clocksource_of_init();
>> +	tick_setup_hrtimer_broadcast();
>> +}
>> +
>>  DT_MACHINE_START(LS1021A, "Freescale LS1021A")
>>  	.smp		= smp_ops(ls1021a_smp_ops),
>> +	.init_time	= ls1021a_init_time,
>>  	.dt_compat	= ls1021a_dt_compat,
>>  MACHINE_END
>> -- 
>> 1.8.0
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
> 

