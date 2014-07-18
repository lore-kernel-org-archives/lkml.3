Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030213AbaGRLEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:04:38 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:44227 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaGRLEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:04:35 -0400
X-Greylist: delayed 21505 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2014 07:04:34 EDT
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: thierry.reding@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <b9eb4356d754449dc2339e39e9a0462c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53C8FF38.8010506@rock-chips.com>
Date: Fri, 18 Jul 2014 19:04:24 +0800
From: caesar <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Beniamino Galvani <b.galvani@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cf@rock-chips.com,
        addy.ke@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        hj@rock-chips.com
Subject: Re: [PATCH 2/2] pwm: add this series patch to support for rk-pwm
 and vop-pwm.
References: <1405577294-19336-1-git-send-email-caesar.wang@rock-chips.com> <1405577294-19336-3-git-send-email-caesar.wang@rock-chips.com> <20140717192459.GA4617@gmail.com> <53C8AB34.3050102@rock-chips.com> <20140718100341.GA30497@ulmo>
In-Reply-To: <20140718100341.GA30497@ulmo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

于 2014年07月18日 18:03, Thierry Reding 写道:
> On Fri, Jul 18, 2014 at 01:05:56PM +0800, caesar wrote:
>> 于 2014年07月18日 03:24, Beniamino Galvani 写道:
>>> On Thu, Jul 17, 2014 at 02:08:14PM +0800, caesar wrote:
> [...]
>>>> @@ -119,9 +185,12 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
>>>>   		return -ENOMEM;
>>>>   	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> -	pc->base = devm_ioremap_resource(&pdev->dev, r);
>>>> -	if (IS_ERR(pc->base))
>>>> -		return PTR_ERR(pc->base);
>>>> +	pc->base = of_iomap(np, 0);
>>>> +	if (!pc->base) {
>>>> +		dev_err(&pdev->dev, "failed to map controller\n");
>>>> +		ret = -ENOMEM;
>>>> +		goto fail_map;
>>>> +	}
>>> I think that this change is not needed. devm_ioremap_resource()
>>> guarantees an automatic unmapping when the device is destroyed.
>>>
>>> Moreover, when of_iomap() fails you don't need to call iounmap().
>>>
>>> Beniamino
>> VOP-PWM base has be requested for lcdc.
> Why?
VOP is  a seperate controllers for rk3288 and genenation SoCs.
The VOP contains lcdc,pwm......

For example :Rk3288 SOC address mapping

lcdc0: lcdc@ff930000                     vop0pwm: pwm@ff9301a0
reg = <0xff930000 0x10000>       reg = <0xff9301a0 0x10>;
offset = 0x10000                            offset = 0x10

lcdc1: lcdc@ff940000                    vop1pwm: pwm@ff9401a0
reg = <0xff940000 0x10000>      reg = <0xff9401a0 0x10>;
offset = 0x10000                           offset = 0x10

In a word, lcdc and vop-pwm has shared the map address.
>> When I use devm_ioremap_resource(), the vop-pwm will request region fail.
>>
>> Example:.931020] rockchip-pwm ff9401a0.pwm: can't request region for
>> resource [mem 0xff9401a0-0xff9401af] /pwm@ff9401a0.
>> So ,I have to charge it.
>>
>> I will be simplyfied by having:
>> - pc->base = devm_ioremap_resource(&pdev->dev, r);
>> + if (!strcmp(of_id->compatible, "rockchip,vop-pwm"))
>> + pc->base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
>> + else
>> + pc->base = devm_ioremap_resource(&pdev->dev, r);
>>
>> Maybe, Could you give me better suggestions for it?
> The right thing to do is not have two drivers access the same device.
> Why does lcdc request the PWM register region?
>
> Thierry
Ditto,
Maybe,Could you give me a better suggestion to do it?


