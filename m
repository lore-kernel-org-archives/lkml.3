Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763007Ab3DCH0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:26:14 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:43988 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762992Ab3DCH0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:26:12 -0400
Message-ID: <515BD992.50009@atmel.com>
Date: Wed, 3 Apr 2013 09:26:10 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Boris BREZILLON <linux-arm@overkiz.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Andrew Victor <linux@maxim.org.za>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: at91/tc: fix clock source id for tc block > 1
References: <1364921211-15756-1-git-send-email-linux-arm@overkiz.com> <20130403044555.GN20693@game.jcrosoft.org>
In-Reply-To: <20130403044555.GN20693@game.jcrosoft.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 06:45 AM, Jean-Christophe PLAGNIOL-VILLARD :
> On 18:46 Tue 02 Apr     , Boris BREZILLON wrote:
>> This patch fixes wrong clock request for TC block 2.
>> The second block was using t0_clk, t1_clk and t2_clk clks instead of
>> t3_clk, t4_clk and t5_clk clks.
>>
> this is intended as we have 3 clock per device

True.
Boris, did you hit an issue with former code that your patch is solving?
What is the reason for this patch?

Thanks, best regards,


>> Signed-off-by: Boris BREZILLON <linux-arm@overkiz.com>
>> ---
>>  drivers/misc/atmel_tclib.c |   24 ++++++++++++++++--------
>>  1 file changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/misc/atmel_tclib.c b/drivers/misc/atmel_tclib.c
>> index c8d8e38..768a988 100644
>> --- a/drivers/misc/atmel_tclib.c
>> +++ b/drivers/misc/atmel_tclib.c
>> @@ -142,6 +142,8 @@ static int __init tc_probe(struct platform_device *pdev)
>>  	struct atmel_tc *tc;
>>  	struct clk	*clk;
>>  	int		irq;
>> +	char		clk_id[7];
>> +	int		clk_offset;
>>  
>>  	if (!platform_get_resource(pdev, IORESOURCE_MEM, 0))
>>  		return -EINVAL;
>> @@ -156,25 +158,31 @@ static int __init tc_probe(struct platform_device *pdev)
>>  
>>  	tc->pdev = pdev;
>>  
>> -	clk = clk_get(&pdev->dev, "t0_clk");
>> -	if (IS_ERR(clk)) {
>> -		kfree(tc);
>> -		return -EINVAL;
>> -	}
>> -
>>  	/* Now take SoC information if available */
>>  	if (pdev->dev.of_node) {
>>  		const struct of_device_id *match;
>>  		match = of_match_node(atmel_tcb_dt_ids, pdev->dev.of_node);
>>  		if (match)
>>  			tc->tcb_config = match->data;
>> +		clk_offset = of_alias_get_id(tc->pdev->dev.of_node, "tcb");
>> +	} else
>> +		clk_offset = pdev->id;
>> +	clk_offset *= 3;
>> +
>> +	snprintf(clk_id, sizeof(clk_id), "t%d_clk", clk_offset++);
>> +	clk = clk_get(&pdev->dev, clk_id);
>> +	if (IS_ERR(clk)) {
>> +		kfree(tc);
>> +		return -EINVAL;
>>  	}
>>  
>>  	tc->clk[0] = clk;
>> -	tc->clk[1] = clk_get(&pdev->dev, "t1_clk");
>> +	snprintf(clk_id, sizeof(clk_id), "t%d_clk", clk_offset++);
>> +	tc->clk[1] = clk_get(&pdev->dev, clk_id);
>>  	if (IS_ERR(tc->clk[1]))
>>  		tc->clk[1] = clk;
>> -	tc->clk[2] = clk_get(&pdev->dev, "t2_clk");
>> +	snprintf(clk_id, sizeof(clk_id), "t%d_clk", clk_offset++);
>> +	tc->clk[2] = clk_get(&pdev->dev, clk_id);
>>  	if (IS_ERR(tc->clk[2]))
>>  		tc->clk[2] = clk;
>>  
>> -- 
>> 1.7.9.5
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


-- 
Nicolas Ferre
