Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaEGWAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:00:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44352 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaEGWAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:00:48 -0400
Message-ID: <536AACF6.9070204@ti.com>
Date: Wed, 7 May 2014 17:00:22 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/26] ARM: OMAP: dmtimer: Add function to check if timer
 is running
References: <1398375849-6017-1-git-send-email-joelf@ti.com> <1398375849-6017-5-git-send-email-joelf@ti.com> <20140507152521.GE9502@atomide.com>
In-Reply-To: <20140507152521.GE9502@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 10:25 AM, Tony Lindgren wrote:
> * Joel Fernandes <joelf@ti.com> [140424 14:44]:
>> Inorder to move non-DM timer specific code that modifies the "idlect"
>> mask on OMAP1, from dmtimer code, to OMAP1 specific timer initialization code,
>> we introduce a new function that can possibly be reused for other purposes in
>> the future. The function just checks if a timer is running based on the timer ID
>> which should be same as pdev->id. This allows us to cleanly separate the timer vs
>> non-timer bits and keep the timer bits in the dmtimer code.
>>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>>  arch/arm/plat-omap/dmtimer.c              |   29 +++++++++++++++++++++++++++++
>>  arch/arm/plat-omap/include/plat/dmtimer.h |    2 ++
>>  2 files changed, 31 insertions(+)
>>
>> diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
>> index 4debb3d..86b2641 100644
>> --- a/arch/arm/plat-omap/dmtimer.c
>> +++ b/arch/arm/plat-omap/dmtimer.c
>> @@ -187,6 +187,35 @@ int omap_dm_timer_reserve_systimer(int id)
>>  	return 0;
>>  }
>>  
>> +/*
>> + * Check if a timer is running based on timer_id, used for OMAP1 currently.
>> + */
>> +int omap_dm_timer_is_running(int timer_id)
>> +{
>> +	int i = 1, ret = 0;
>> +	struct omap_dm_timer *timer = NULL;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&dm_timer_lock, flags);
>> +	list_for_each_entry(timer, &omap_timer_list, node) {
>> +		if (i == timer_id) {
>> +			u32 l;
>> +			l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
>> +			if (l & OMAP_TIMER_CTRL_ST) {
>> +				ret = 1;
>> +				goto done;
>> +			} else {
>> +				goto done;
>> +			}
>> +		}
>> +		i++;
>> +	}
>> +done:
>> +	spin_unlock_irqrestore(&dm_timer_lock, flags);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(omap_dm_timer_is_running);
> 
> Let's not add new exported custom functions, let's instead try to get
> rid of them. What needs to use this one?

This piece of code was entangled with OMAP1 specific logic.

The OMAP1 specific logic is moved into a new function in the OMAP1 timer
layer called: omap_dm_timer_modify_idlect_mask

What's left is code that needs to iterate over all the timers by
checking the OMAP_TIMER_CTRL_ST bit in the control register. This is
left back into the dmtimer code but needs to be exported since we
ultimately will move dmtimer into clock source.

If you notice, I removed export of omap_dm_timer_modify_idlect_mask
since it is moved to omap1 layer and is local there, so it should be OK
to export this symbol instead. We are not adding more exports, and its
still an improvement over the old code as the OMAP1 specific logic is
decoupled from the generic dmtimer code.

thanks,

-Joel

