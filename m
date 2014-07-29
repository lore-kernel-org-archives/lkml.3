Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaG2PaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:30:19 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42134 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbaG2PaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:30:12 -0400
MIME-Version: 1.0
In-Reply-To: <53D7AA72.6010309@mm-sol.com>
References: <53D788A7.4020303@mm-sol.com> <3794875.CZFbAag5Sv@wuerfel> <53D7AA72.6010309@mm-sol.com>
From: Rob Herring <rob.herring@linaro.org>
Date: Tue, 29 Jul 2014 10:29:50 -0500
Message-ID: <CABGGisy6_TOkT7fHp049rwH_FhQxCRGQqGBCsODUFTTchhsLvg@mail.gmail.com>
Subject: Re: use IORESOURCE_REG resource type for non-translatable addresses
 in DT
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 9:06 AM, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
> Arnd, thanks for the comments.
>
> On 07/29/2014 03:00 PM, Arnd Bergmann wrote:
>> On Tuesday 29 July 2014 14:42:31 Stanimir Varbanov wrote:
>>>         taddr = of_translate_address(dev, addrp);
>>> -       if (taddr == OF_BAD_ADDR)
>>> -               return -EINVAL;
>>> +       /*
>>> +        * if the address is non-translatable to cpu physical address
>>> +        * fallback to a IORESOURCE_REG resource.
>>> +        */
>>> +       if (taddr == OF_BAD_ADDR) {
>>> +               memset(r, 0, sizeof(*r));
>>> +               taddr = of_read_number(addrp, 1);
>>> +               if (taddr == OF_BAD_ADDR)
>>> +                       return -EINVAL;
>>> +               r->start = taddr;
>>> +               r->end = taddr + size - 1;
>>> +               r->flags = IORESOURCE_REG;
>>> +               r->name = name ? name : dev->full_name;
>>> +               return 0;
>>> +       }
>>> +
>>
>> I don't think that everything returning OF_BAD_ADDR makes sense
>> to turn into IORESOURCE_REG. It could be an e.g. invalid DT
>> representation, a node with #size-cells=<0>, or it could be
>> something that gets translated one or more nodes up in the
>> tree before it reaches a bus without a ranges property.
>>
>> Also, you should not rely on #address-cells being hardcoded
>> to <1> above.
>>
>
> This was just an example. Of course it has many issues and probaly it is
> wrong:) The main goal was to understand does IORESOURCE_REG resource
> type and parsing the *reg* properties for non-translatable addresses are
> feasible. And also does it acceptable by community and OF platform
> maintainers.

I guess the question I have is what is the advantage of making this a
resource? You can't really pass it to other functions.

We're moving in the opposite direction for IRQs as now
platform_get_irq translates the IRQ directly rather than using the
resource (but the resource is still there just to avoid potentially
breaking things for now).

>> How about modifying of_get_address() rather than
>> __of_address_to_resource() instead? You could introduce
>> a new of_bus entry for each bus you expect to return
>> an IORESOURCE_REG, or you could change of_bus_default_get_flags
>> to return IORESOURCE_REG if the parent node has no ranges property
>> and is not the root node.
>
> IMO the clearer solution is to introduce a new of_bus bus. In that case
> one possible problem will be how to distinguish the non-translatable and
> the other buses. Also the *device_type* property is deprecated for non
> PCI devices.

You would have to look for the presence or absence of ranges property.

Rob
