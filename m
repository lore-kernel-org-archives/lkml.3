Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbaGUOKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:10:17 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:50355 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383AbaGUOKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:10:13 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: thierry.reding@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <3d961cee4a5959462e5b25b170567c23>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53CD1F3C.3070000@rock-chips.com>
Date: Mon, 21 Jul 2014 22:10:04 +0800
From: caesar <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: heiko@sntech.de, b.galvani@gmail.com, cf@rock-chips.com,
        huangtao@rock-chips.com, addy.ke@rock-chips.com, xjq@rock-chips.com,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] pwm: add this patch to support the new pwm of
 Rockchip SoCs
References: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com> <1405774529-26027-3-git-send-email-caesar.wang@rock-chips.com> <20140721085001.GG8843@ulmo> <53CD0E82.6030901@rock-chips.com> <20140721132723.GH15238@ulmo>
In-Reply-To: <20140721132723.GH15238@ulmo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


于 2014年07月21日 21:27, Thierry Reding 写道:
> On Mon, Jul 21, 2014 at 08:58:42PM +0800, caesar wrote:
>> 于 2014年07月21日 16:50, Thierry Reding 写道:
>>> On Sat, Jul 19, 2014 at 08:55:29PM +0800, Caesar Wang wrote:
> [...]
>>>>   	struct rockchip_pwm_chip *pc;
>>>>   	struct resource *r;
>>>>   	int ret;
>>>> @@ -119,7 +182,10 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
>>>>   		return -ENOMEM;
>>>>   	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> -	pc->base = devm_ioremap_resource(&pdev->dev, r);
>>>> +	if (!strcmp(of_id->compatible, "rockchip,vop-pwm"))
>>>> +		pc->base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
>>>> +	else
>>>> +		pc->base = devm_ioremap_resource(&pdev->dev, r);
>>> Sorry, this still isn't an option. You really shouldn't remap I/O
>>> regions that other drivers may be using. You hinted at a shared register
>>> space during the review of the initial version. Can you provide more
>>> detail about what exactly the memory map looks like of the rk3288? Is
>>> there some kind of technical reference manual that I could look at? Or
>>> do you have a device tree extract that shows what the memory map looks
>>> like?
>>>
>>> Thierry
>> Maybe,you can look at the ARM: dts: rk3288:
>> https://github.com/rkchrome/kernel/blob/master/arch/arm/boot/dts/rk3288.dtsi
>> There is some lcdc and vop-pwm map address for rk3288.
>>
>> ,and you can look at the vop-introduce.pdf and vop-register.pdf in Annex.
>>
>> Maybe,I should put the vop-pwm in lcdc driver,but I don't hope do so it.
>>
>> Could you give a suggestion to solve it? Thanks.
> It looks like you could turn the lcdc device into an MFD device so that
> it can instantiate two devices, one for the display controller, the
> other for the PWM. Or perhaps it would even work with only a single
> child device.
>
> The device tree would become something like this:
>
> 	lcdc@ff930000 {
> 		compatible = "rockchip,rk3288-lcdc";
> 		...
>
> 		pwm@ff9301a0 {
> 			compatible = "rockchip,vop-pwm";
> 			...
> 		};
> 	};
>
> And your driver would do something like:
>
> 	static const struct resource pwm_resources[] = {
> 		{
> 			.start = 0x1a0,
> 			.end = 0x1af,
> 			.flags = IORESOURCE_MEM,
> 		},
> 	};
>
> 	static const struct mfd_cell subdevices[] = {
> 		{
> 			.name = "pwm",
> 			.id = 1,
> 			.of_compatible = "rockchip,vop-pwm",
> 			.num_resources = ARRAY_SIZE(pwm_resources),
> 			.resources = pwm_resources,
> 		},
> 	};
>
> 	static int lcdc_probe(struct platform_device *pdev)
> 	{
> 		struct resource *regs;
> 		...
>
> 		regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>
> 		...
>
> 		err = mfd_add_devices(&pdev->dev, 0, subdevices, ARRAY_SIZE(subdevices),
> 				      regs, NULL, NULL);
> 		...
> 	}
>
> Thierry

Seems resonable.

I will fix this and the other issues v3,Thanks.

Caesar


