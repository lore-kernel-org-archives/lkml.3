Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab3AaR2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:28:34 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39544 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab3AaR23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:28:29 -0500
Message-ID: <510AA9BA.8080704@wwwdotorg.org>
Date: Thu, 31 Jan 2013 10:28:26 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/4] pinctrl/abx500: destroy mutex if returning early
 due to error
References: <1359574822-15729-1-git-send-email-linus.walleij@stericsson.com> <51097E35.6080100@wwwdotorg.org> <20130131080151.GA5301@gmail.com>
In-Reply-To: <20130131080151.GA5301@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 01:01 AM, Lee Jones wrote:
> On Wed, 30 Jan 2013, Stephen Warren wrote:
> 
>> On 01/30/2013 12:40 PM, Linus Walleij wrote:
>>> From: Lee Jones <lee.jones@linaro.org>
>>>
>>> Current failure path neglects to mutex_destroy() before returning
>>> an error due to an invalid parameter or an error received from
>>> gpiochip_add(). This patch aims to remedy that behaviour.
>>
>>> diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
>>
>>> @@ -1155,11 +1155,13 @@ static int abx500_gpio_probe(struct platform_device *pdev)
>>>  	default:
>>>  		dev_err(&pdev->dev, "Unsupported pinctrl sub driver (%d)\n",
>>>  				(int) platid->driver_data);
>>> +		mutex_destroy(&pct->lock);
>>>  		return -EINVAL;
>>
>> Especially given there's already a label out_free which performs this
>> mutex_destroy(), those last two lines would be better as:
>>
>> ret = -EINVAL;
>> goto out_free;
> 
> Yes, that's one way of doing it. I figured it was 6 of one and half a
> dozen of the other to be honest.
> 
> Either I:
> 
>  +           mutex_destroy(&pct->lock);
> 
> Or:
> 
>  +           ret = -EINVAL; 
>  +           goto out_free;
>  -           return -EINVAL;
> 
> I figured the smallest diff would be best. To be honest, I'm not
> bothered either way. If it offends you, I can do it the other way, no
> problem. Just let me know quick, so I can get the fixed up patch to
> Linus.
> 
> NB: There is no 'out_free:' at this point, it has already been
> removed.

Where has it been removed? Both the latest linux-next and LinusW's
pinctrl tree on git.kernel.org still contain it...

The style in that code is clearly "goto foo" for error-handling, and
makes for smaller simpler code, so I don't see why the label would be
removed.

Still, this review is just a suggestion; this driver isn't anything I
have any ownership of, so I guess feel free to go either way.
