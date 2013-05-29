Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965520Ab3E2J6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:58:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45807 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965205Ab3E2J6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:58:35 -0400
Message-ID: <51A5D148.8050203@ti.com>
Date: Wed, 29 May 2013 12:58:32 +0300
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: J Keerthy <j-keerthy@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] PM / AVS: SmartReflex: disable errgen before vpbound
 disable
References: <1369652846-14412-1-git-send-email-andrii.tseglytskyi@ti.com> <1369652846-14412-2-git-send-email-andrii.tseglytskyi@ti.com> <87sj17aqq2.fsf@linaro.org>
In-Reply-To: <87sj17aqq2.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

Thanks a lot for your comments.

On 05/28/2013 09:45 PM, Kevin Hilman wrote:
> Andrii Tseglytskyi <andrii.tseglytskyi@ti.com> writes:
>
>> From: Nishanth Menon <nm@ti.com>
>>
>> vpboundsintr_en is available inside the IP block as an re-sycned
>> version and one which is not. Due to this, there is an 1 sysclk
>> cycle window where interruptz could be asserted low for 1 cycle.
>                               ^^^
>
> Is that the way the cool kidz are spelling interrupts these days?  ;)

Oh! Shame on me. Thank you for catching this :)

>> IF, intr_en is cleared on the exact same cycle as the irqclr, an
>> additional pulse is generated which indicates for VP that
>> an additional adjustment of voltage is required.
>>
>> This results in VP doing two voltage adjustments for the SRERR
>> (based on configuration, upto 4 steps), instead of the needed
>> 1 step.
>> Due to the unexpected pulse from AVS which breaks the AVS-VP
>> communication protocol, VP also ends up in a stuck condition by
>> entering a state where VP module remains non-responsive
>> to any futher AVS adjustment events. This creates the symptom
>> called "TRANXDONE Timeout" scenario.
>>
>> By disabling errgen prior to disable of intr_en, this situation
>> can be avoided.
>>
>> Signed-off-by: Vincent Bour <v-bour@ti.com>
>> Signed-off-by: Leonardo Affortunati <l-affortunati@ti.com>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> Signed-off-by: Andrii.Tseglytskyi <andrii.tseglytskyi@ti.com>
>  From Documentation/SubbmittingPatches:
>
>     "If a person was not directly involved in the preparation or handling
>     of a patch but wishes to signify and record their approval of it then
>     they can arrange to have an Acked-by: line added to the patch's
>     changelog."
>
> Are all of the tags above co-authors or on the delivery path?  I suspect
> an Acked-by or Reviewed-by is more appropriate here.
>
> Otherwise, patch itself looks fine.
>
> Kevin

This patch was developed by Nishanth, he is the author of the code.
Patch is the result of 2-week debug session. Vincent, Leonardo and 
Nishanth were involved to that debug session.
My contribution to this patch - is sending it to upstream, no more than 
this.
Could you please suggest - who should remain in Signed-offs ?

>> ---
>>   drivers/power/avs/smartreflex.c |   11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
>> index 6b2238b..f34d34d 100644
>> --- a/drivers/power/avs/smartreflex.c
>> +++ b/drivers/power/avs/smartreflex.c
>> @@ -449,12 +449,17 @@ int sr_disable_errgen(struct voltagedomain *voltdm)
>>   		return -EINVAL;
>>   	}
>>   
>> -	/* Disable the interrupts of ERROR module */
>> -	sr_modify_reg(sr, errconfig_offs, vpboundint_en | vpboundint_st, 0);
>> -
>>   	/* Disable the Sensor and errorgen */
>>   	sr_modify_reg(sr, SRCONFIG, SRCONFIG_SENENABLE | SRCONFIG_ERRGEN_EN, 0);
>>   
>> +	/*
>> +	 * Disable the interrupts of ERROR module
>> +	 * NOTE: modify is a read, modify,write - an implicit OCP barrier
>> +	 * which is required is present here - sequencing is critical
>> +	 * at this point (after errgen is disabled, vpboundint disable)
>> +	 */
>> +	sr_modify_reg(sr, errconfig_offs, vpboundint_en | vpboundint_st, 0);
>> +
>>   	return 0;
>>   }

