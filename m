Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162347AbaDCG3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 02:29:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56329 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933511AbaDCG3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 02:29:12 -0400
Message-ID: <533CFFB3.9070201@ti.com>
Date: Thu, 3 Apr 2014 09:29:07 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tero Kristo <t-kristo@ti.com>, Mike Turquette <mturquette@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: ti: clk-7xx: Correct ABE DPLL configuration
References: <1396446525-20302-1-git-send-email-peter.ujfalusi@ti.com> <533C1AC2.1000307@ti.com>
In-Reply-To: <533C1AC2.1000307@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 05:12 PM, Tero Kristo wrote:
> On 04/02/2014 04:48 PM, Peter Ujfalusi wrote:
>> ABE DPLL frequency need to be lowered from 361267200
>> to 180633600 to facilitate the ATL requironments.
>> The dpll_abe_m2x2_ck clock need to be set to double
>> of ABE DPLL rate in order to have correct clocks
>> for audio.
> 
> Do you have some sort of TRM reference for this?

The ATL's max divider is 32.
For audio purpose the clock coming out from the ATL instance should be
128 * fs. It is only possible to have 44.1KHz sampling rate with ABE DPLL set
to 361267200 or 180633600. Which means:
The atl generated clock should be 128 * 44100 = 5644800
>From ABE_DPLL 361267200 we would need to have 64 as divider (ATL can't do this).
>From the suggested ABE_DPLL of 180633600 we can use ATL divider of 32, which
is the maximum it can do.

So the reason for the change is to have ATLPCLK clock which can be used for
audio in the future, the 361267200 is just too high.

> 
> -Tero
> 
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>   drivers/clk/ti/clk-7xx.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
>> index f7e40734c819..19a55bf407dd 100644
>> --- a/drivers/clk/ti/clk-7xx.c
>> +++ b/drivers/clk/ti/clk-7xx.c
>> @@ -16,7 +16,7 @@
>>   #include <linux/clkdev.h>
>>   #include <linux/clk/ti.h>
>>
>> -#define DRA7_DPLL_ABE_DEFFREQ                361267200
>> +#define DRA7_DPLL_ABE_DEFFREQ                180633600
>>   #define DRA7_DPLL_GMAC_DEFFREQ                1000000000
>>
>>
>> @@ -322,6 +322,11 @@ int __init dra7xx_dt_clk_init(void)
>>       if (rc)
>>           pr_err("%s: failed to configure ABE DPLL!\n", __func__);
>>
>> +    dpll_ck = clk_get_sys(NULL, "dpll_abe_m2x2_ck");
>> +    rc = clk_set_rate(dpll_ck, DRA7_DPLL_ABE_DEFFREQ * 2);
>> +    if (rc)
>> +        pr_err("%s: failed to configure ABE DPLL m2x2!\n", __func__);
>> +
>>       dpll_ck = clk_get_sys(NULL, "dpll_gmac_ck");
>>       rc = clk_set_rate(dpll_ck, DRA7_DPLL_GMAC_DEFFREQ);
>>       if (rc)
>>
> 


-- 
Péter
