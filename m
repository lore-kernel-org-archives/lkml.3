Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaEGVn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:43:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44870 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaEGVnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:43:55 -0400
Message-ID: <536AA900.4040200@ti.com>
Date: Wed, 7 May 2014 16:43:28 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/26] ARM: OMAP: dmtimer: Remove setting of clk parent
 indirectly through platform hook
References: <1398375849-6017-1-git-send-email-joelf@ti.com> <1398375849-6017-2-git-send-email-joelf@ti.com> <20140507151907.GB9502@atomide.com>
In-Reply-To: <20140507151907.GB9502@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 10:19 AM, Tony Lindgren wrote:
> * Joel Fernandes <joelf@ti.com> [140424 14:44]:
>> There is a platform specific hook just for OMAP1 to set its clk parent.  Remove
>> this hook and have OMAP1 set its parent in omap1_dm_timer_init.  If OMAP1 is
>> ever migrated to clock framework, the correct way to do this would be through
>> clk_set_parent like other platforms.
>>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>>  arch/arm/mach-omap1/timer.c                |    8 +++++++-
>>  arch/arm/plat-omap/dmtimer.c               |    8 +++-----
>>  include/linux/platform_data/dmtimer-omap.h |    2 --
>>  3 files changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap1/timer.c b/arch/arm/mach-omap1/timer.c
>> index bde7a35..4b9c604 100644
>> --- a/arch/arm/mach-omap1/timer.c
>> +++ b/arch/arm/mach-omap1/timer.c
>> @@ -140,7 +140,13 @@ static int __init omap1_dm_timer_init(void)
>>  			goto err_free_pdata;
>>  		}
>>  
>> -		pdata->set_timer_src = omap1_dm_timer_set_src;
>> +		/*
>> +		 * Since OMAP1 doesn't support clock framework, set timer clock
>> +		 * source to 32KHz here instead of expecting it to be set by
>> +		 * dmtimer code.
>> +		 */
>> +		omap1_dm_timer_set_src(pdev, 0x01);
>> +
>>  		pdata->timer_capability = OMAP_TIMER_ALWON |
>>  				OMAP_TIMER_NEEDS_RESET | OMAP_TIMER_HAS_DSP_IRQ;
>>  
> 
> This does not sound right, omap1 does support clock framework just fine.
> It is not using the common clock framework though.
> 
> This breaks omap_dm_timer_set_source() for sure. Setting the source
> during init is not a right solution here. Probably best to keep the
> pdata hook around, drivers can support pdata and DT data together
> just fine.

Actually pdata hook in this case is used only in 1 place, and is OMAP1
specific so I felt its better to clean it up.

Can you elaborate a bit more on why it breaks? I have no way of testing
OMAP1 without hardware.

What difference is it to set MOD_CONF_CTRL_1 in omap1's
arch_initcall(omap1_dm_timer_init)  versus doing so later?

-Joel

