Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3ILLir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:38:47 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49634 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3ILLip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:38:45 -0400
Message-ID: <5231A791.9080600@ahsoftware.de>
Date: Thu, 12 Sep 2013 13:37:53 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <344239800.bDEkDg48ZQ@avalon> <CACRpkdavR=fv+y1RCNfdgQypPuRbO6isOSwGsABDrYiGeMdyZw@mail.gmail.com> <52308C91.2000105@ahsoftware.de> <523096FE.8080901@collabora.co.uk> <5230AB6E.1070807@ahsoftware.de> <5231817F.8000901@ahsoftware.de> <5231934D.4060706@collabora.co.uk> <52319741.5050407@ahsoftware.de> <5231A0F8.1070505@ahsoftware.de> <5231A4FE.1070704@ahsoftware.de>
In-Reply-To: <5231A4FE.1070704@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.09.2013 13:26, schrieb Alexander Holler:
> Am 12.09.2013 13:09, schrieb Alexander Holler:
>> Am 12.09.2013 12:28, schrieb Alexander Holler:
>>> Am 12.09.2013 12:11, schrieb Javier Martinez Canillas:
>>>> On 09/12/2013 10:55 AM, Alexander Holler wrote:
>>>
...
>>>
>>>> So, if I understood the code correctly the DT IRQ core doesn't expect
>>>> a device
>>>> node to have more than one "interrupt-parent" property.
>>>>
>>>> It *should* work though if you have multiple "interrupts" properties
>>>> defined and
>>>> all of them have the same "interrupt-parent":
>>>>
>>>>         interrupt-parent = <&gpio6>;
>>>>         interrupts = <1 IRQF_TRIGGER_HIGH>; /* GPIO6_1 */
>>>>         interrupts = <2 IRQF_TRIGGER_LOW>; /* GPIO6_2 */
>>>>
>>>> since of_irq_map_one() will be called for each "interrupts" and the
>>>> correct
>>>> "interrupt-parent" will get obtained by of_irq_find_parent().
>>>
>>> I assumed that answer. So to make such a scenario possible, something
>>> like this might be neccessary:
>>>
>>>           interrupts = <&gpio6 1 IRQF_TRIGGER_HIGH>; /* GPIO6_1 */
>>>           interrupts = <&gpio7 2 IRQF_TRIGGER_LOW>; /* GPIO7_2 */
>>>
>>> or, to be compatible
>>>
>>>           interrupts = <1 IRQF_TRIGGER_HIGH &gpio6>; /* GPIO6_1 */
>>>           interrupts = <1 IRQF_TRIGGER_LOW &gpio7>; /* GPIO7_1 */
>>>
>>> Another problem is the naming. In all the above cases, the driver would
>>> not know which IRQ he should use for what. Maybe the order defines it,
>>> but that wouldn't be very verbose. And I think just changing the name
>>> would make travelling the tree impossible, as only the driver itself
>>> would know the name and it's meaning.
>>
>> On a second look, travelling the tree is still possible if the solution
>> would be like above (without that interrupt-parent). So if a driver
>> requires two interrupts he could use
>>
>>        interrupt-foo = <1 IRQF_TRIGGER_HIGH &gpio6>; /* GPIO6_1 */
>>        interrupt-bar = <1 IRQF_TRIGGER_LOW &gpio7>; /* GPIO7_1 */
>>
>> And travelling the tree will still be possible because walking from the
>> interrupt-controllers (those gpio) downwards would end up at the
>> interrupt definitions, so the name of them isn't needed to find them in
>> the tree.
>
> I've just seen how they solved it for dma:
>
>              dmas = <&edma0 16
>                  &edma0 17>;
>              dma-names = "rx", "tx";
>
> so it would be like
>
>        interrupts = <1 IRQF_TRIGGER_HIGH &gpio6>; /* GPIO6_1 */
>        interrupts = <1 IRQF_TRIGGER_LOW &gpio7>; /* GPIO7_1 */
>        interrupt-names = "foo", "bar";
>
> Or this would be possible:
>
>        interrupt-parent = <&gpio6 &gpio7>;
>        interrupts = <1 IRQF_TRIGGER_HIGH>; /* GPIO6_1 */
>        interrupts = <1 IRQF_TRIGGER_LOW>; /* GPIO7_1 */
>        interrupt-names = "foo", "bar";
>

And looking at how gpios are defined, I think it should be like that:


           interrupts = <&gpio6 1 IRQF_TRIGGER_HIGH
                         &gpio7 2 IRQF_TRIGGER_LOW
           >;
           interrupt-names = "foo", "bar";

So without that interrupt-parent.

Regards,

Alexander

