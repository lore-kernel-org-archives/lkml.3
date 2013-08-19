Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab3HSTfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:35:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57896 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3HSTf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:35:28 -0400
Message-ID: <5212737A.1030904@wwwdotorg.org>
Date: Mon, 19 Aug 2013 13:35:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Lars Poeschel <poeschel@lemonage.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>,
        mark.rutland@arm.com, ian.campbell@citrix.com, galak@codeaurora.org,
        pawel.moll@arm.com
Subject: Re: [PATCH v2] RFC: interrupt consistency check for OF GPIO IRQs
References: <1376387195-27469-1-git-send-email-larsi@wh2.tu-dresden.de> <1955836.AOXICuVgjP@flatron> <CACRpkdZqtn80rkpGokpjwoeEWTx+f_ug1zqOHBA1SeSz9Oj7mA@mail.gmail.com> <9241298.URG9CVQFmF@flatron>
In-Reply-To: <9241298.URG9CVQFmF@flatron>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2013 03:59 AM, Tomasz Figa wrote:
> [Ccing DT maintainers, as they may have some ideas as well]
> 
> On Saturday 17 of August 2013 02:16:11 Linus Walleij wrote:
>> On Thu, Aug 15, 2013 at 11:53 AM, Tomasz Figa <tomasz.figa@gmail.com>  wrote:
...

>>> This is the biggest problem of this patch. It assumes that there is
>>> only a single and shared GPIO/interrupt specification scheme, which
>>> might not be true.
>>>
>>> First of all, almost all interrupt bindings have an extra,
>>> semi-generic
>>> flags field as last cell in the specifier. Now there can be more than
>>> one> 
>>> cell used to index GPIOs and interrupts, for example:
>>>         interrupts = <1 3 8>
>>>
>>> which could mean: bank 1, pin 3, low level triggered.
>>
>> You are right, but:
>> Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
>> Specifies how to handle the one-celled and two-celled versions.
>>
>> And nothing else is specified. So it's not overly complex.
> 
> The documentation states that:
> 
> 	It is the responsibility of the interrupt controller's binding to 
> 	define the length and format of the interrupt specifier.
> 
> Then two _example_ formats follow, preceded by following statement:
> 
> 	The following two variants are commonly used:
> 
> I already know a variant which uses three (Exynos combiner) and four 
> (S3C24xx interrupt controller) cells. They are not pin controllers, but 
> you can't stop anyone from adopting similar or even more complex 
> specifiers formats for their hardware, especially when it matches more 
> closely the interrupt/pin layout used in their hardware.

Yes, the binding doc interrupts.txt mentioned above does not specify
*the* one-/two-cell format, but *a* common/possible one- and two-cell
format. There's no strict reason that all interrupt controllers have to
use those exact formats. The only way to parse interrupt specifiers is
to ask the driver for the the interrupt controller code to parse the
property.

The same goes for GPIOs.

>> But we have to read out the #interrupt-cells specifier from the
>> controller I guess, but since we the gcn pointer we can do this
>> easily. (I'll fix...)
>>
>>> I think you may need to reuse a lot of the code that normally parses
>>> the interrupts property, i.e. the irq_of_parse_and_map() path, which
>>> will then give you the hwirq index inside your irq chip, which may
>>> (or may not) be the same as the GPIO offset inside your GPIO chip.
>>
>> We don't need to map it, and that's the hard part of that code.
>> We just need to add some code to check the number of
>> cells.
> 
> Not really. Only the interrupt controller's driver (or rather its .xlate() 
> callback) knows how to map all the cells into hwirq index. So we must at 
> least get the irq domain associated with the node and call its .xlate() 
> callback with requested count of cells.

Yes.
