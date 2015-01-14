Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbbANUFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:05:25 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:22859 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbANUFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:05:22 -0500
X-IronPort-AV: E=Sophos;i="5.07,757,1413270000"; 
   d="scan'208";a="54818385"
Message-ID: <54B6CC00.3050609@broadcom.com>
Date: Wed, 14 Jan 2015 12:05:20 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Scott Branden" <sbranden@broadcom.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
References: <rjui@broadcom.com> <1418183832-24793-1-git-send-email-rjui@broadcom.com> <1418183832-24793-3-git-send-email-rjui@broadcom.com> <20150113225012.GK22880@pengutronix.de> <54B5D0F9.8030902@broadcom.com> <20150114075137.GL22880@pengutronix.de>
In-Reply-To: <20150114075137.GL22880@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/13/2015 11:51 PM, Uwe Kleine-König wrote:
> Hello,
> 
> On Tue, Jan 13, 2015 at 06:14:17PM -0800, Ray Jui wrote:
>>>> +	irq = platform_get_irq(pdev, 0);
>>>> +	if (irq < 0) {
>>> irq == 0 should be handled as error, too.
>>>
>> Ah. I thought zero is a valid global interrupt number, and I see other
>> drivers checking against < 0 as well. Is my understanding incorrect?
> These are wrong, too. 0 should never be a valid interrupt number. There
> are some exceptions but mostly for historic reasons. The right handling
> is used for example in drivers/i2c/busses/i2c-efm32.c.
> 
Okay. Will check against <= 0. Thanks.

>>>> +		dev_err(dev->device, "no irq resource\n");
>>>> +		return irq;
>>>> +	}
>> [...]
>>>> +static int bcm_iproc_i2c_remove(struct platform_device *pdev)
>>>> +{
>>>> +	struct bcm_iproc_i2c_dev *dev = platform_get_drvdata(pdev);
>>>> +
>>>> +	i2c_del_adapter(&dev->adapter);
>>>> +	bcm_iproc_i2c_disable(dev);
>>> I think you have a problem here if bcm_iproc_i2c_remove is called while
>>> an irq is still being serviced. I'm not sure how to prevent this
>>> properly for a shared interrupt.
>>>
>> Can I grab i2c_lock_adapter to ensure the bus is locked (so there's no
>> outstanding transactions or IRQs by the time we remove the adapter)? But
>> I see no I2C bus driver does this in their remove function...
> The problem I pointed out is the reason for some driver authors not to
> use devm_request_irq. If you use plain request_irq and the matching
> free_irq in the .remove callback you can be sure that the irq isn't
> running any more as soon as free_irq returns.
> 
Okay. Will change to use request_irq and make sure that it's freed in
the remove function. Also, the interrupt is dedicated to the I2C
controller, so I'll remove the IRQF_SHARED flag.

> BTW, if you use vim, you can add
> 
> 	set cinoptions=(,:
> 	if has("autocmd")
> 		filetype plugin indent on
> 	endif
> 
> to your .vimrc. Then while typing vim does the indention right and
> consistent, and with the = command you can reindent.
> 
Wow this is excellent! Just tried and it works perfectly. Thanks a lot!!!

> Best regards
> Uwe
> 
