Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaEGWOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:14:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44899 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaEGWOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:14:50 -0400
Message-ID: <536AB041.5070705@ti.com>
Date: Wed, 7 May 2014 17:14:25 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/26] ARM: OMAP: dmtimer: Get rid of check for mem resource
 error
References: <1398375849-6017-1-git-send-email-joelf@ti.com> <1398375849-6017-10-git-send-email-joelf@ti.com> <20140507152426.GD9502@atomide.com> <536AAB1C.6010301@ti.com> <20140507220959.GE19102@atomide.com>
In-Reply-To: <20140507220959.GE19102@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 05:10 PM, Tony Lindgren wrote:
> * Joel Fernandes <joelf@ti.com> [140507 14:53]:
>> On 05/07/2014 10:24 AM, Tony Lindgren wrote:
>>> * Joel Fernandes <joelf@ti.com> [140424 14:44]:
>>>> The subsequent devm_ioremap_resource will catch it and print an error, let it
>>>> be checked there.
>>>>
>>>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>>>> ---
>>>>  arch/arm/plat-omap/dmtimer.c |    4 ----
>>>>  1 file changed, 4 deletions(-)
>>>>
>>>> diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
>>>> index 7e806f9..1fd30fa 100644
>>>> --- a/arch/arm/plat-omap/dmtimer.c
>>>> +++ b/arch/arm/plat-omap/dmtimer.c
>>>> @@ -810,10 +810,6 @@ static int omap_dm_timer_probe(struct platform_device *pdev)
>>>>  	}
>>>>  
>>>>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> -	if (unlikely(!mem)) {
>>>> -		dev_err(dev, "%s: no memory resource.\n", __func__);
>>>> -		return -ENODEV;
>>>> -	}
>>>>  
>>>>  	timer = devm_kzalloc(dev, sizeof(struct omap_dm_timer), GFP_KERNEL);
>>>>  	if (!timer) {
>>>
>>> We still need to return an error here and not try to continue though.
>>
>> We are returning an error if mem is NULL so the redundant check is
>> unnecessary:
>>
>> ...
>>         timer->io_base = devm_ioremap_resource(dev, mem);
>>         if (IS_ERR(timer->io_base))
>>                 return PTR_ERR(timer->io_base);
> 
> Why would you want to even continue omap_dm_timer_probe()
> further and allocate memory if platform_get_resource() fails?
> 

But its freed anyway on error. I just felt that extra LOC could be
removed. Ideally we should do something like


mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
io_base = devm_ioremap_resource(dev, mem);
if (IS_ERR(io_base))
	return PTR_ERR(io_base);

timer = devm_kzalloc(dev, sizeof(struct omap_dm_timer), GFP_KERNEL);
if (!timer) {
 ...
}
timer->io_base = io_base;


That combines the platform_get_resource and devm_ioremap_resource error
paths into 1 path and avoids redundant checks.. I can do it this way, or
if you want drop the patch entirely, I'm OK with it both ways..

thanks,

-Joel

