Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3KSQ0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:26:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57719 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab3KSQ0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:26:46 -0500
Message-ID: <528B905E.6000206@ti.com>
Date: Tue, 19 Nov 2013 18:22:54 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>, Sekhar Nori <nsekhar@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v5 3/7] gpio: davinci: use irqdomain
References: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>	<1383905510-31760-4-git-send-email-prabhakar.csengg@gmail.com>	<CACRpkdaJg4wqtD5xhPVrHJHxFoVwau6jidbOuQ9xFSK_6drxPQ@mail.gmail.com>	<528A2565.4000802@ti.com> <CACRpkda7h4hsMYv_2gdrY+JB80kHu3BkS5OOGyGhEZFc_UkCig@mail.gmail.com>
In-Reply-To: <CACRpkda7h4hsMYv_2gdrY+JB80kHu3BkS5OOGyGhEZFc_UkCig@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 01:06 AM, Linus Walleij wrote:
> On Mon, Nov 18, 2013 at 3:34 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
>> On 11/18/2013 03:11 PM, Linus Walleij wrote:
>
>>> I think we recently established that map creating cannot be done
>>> in gpio_to_irq* functions as that will not work properly if you request
>>> an IRQ from device tree without first obtaining the IRQ from the GPIO
>>> number with this function.
>>
>> Why? Could you point on corresponding thread, pls?
>
> All that contain this:
> "gpio: interrupt consistency check for OF GPIO IRQs"
> http://marc.info/?l=linux-kernel&w=2&r=1&s=interrupt+consistency&q=b

Thanks.

>
>> Current call tree is:
>> irq_create_of_mapping()
>> |-hwirq = omain->ops->xlate()
>> |-irq_create_mapping(domain, hwirq)
>
> OK that works for the pure device-tree scenario so mostly
> this is OK.
>
> The problem that appear is if someone is using platform data-provided
> IRQs off the irq_chip without calling gpio_to_irq() on the GPIO line
> first. This has been determined to be legal to do, so preferably
> create the map when registering the lines.

Ok, I understand. It may fail in case if someone will define/calculate
  IRQ number for device manually in board code, like:
  dev_irq = (DA850_N_CP_INTC_IRQ + gpioN)

Also, looks like It is possible to fail if Main/arch IRQ controller
code doesn't make call of irq_alloc_descs() during init, so
allocated_irqs will be empty.

Actually, the irq_find_mapping() was called before from 
gpio_to_irq_banked() in v4 of this series - than It was changed
according to my comment, to get maximum benefits of using linear IRQ
domain.

Before recommending that, I've checked Davinci platform code and didn't
find any risk places - BUT, Seems my findings need to be confirmed by
Sekhar.

I purpose to move forward as is if above will be confirmed. Otherwise,
we can switch to use irq_domain_add_legacy().

>
>>> Also: please write a patch that marks the IRQ lines.
>>> Call gpio_lock_as_irq(*gpio_chip, offset); in the
>>> irqchip startup/shutdown functions. (Can be a separate
>>> patch.)
>>
>> It seems, some misunderstanding is here. So I'd like to clarify few points
>> and would be very appreciate for your comments:
>> 1) This patch itself will work unless we switch to DT (as in the following
>> patch)
>
> Sure.... but this does not seem to have much to do
> with my request to use gpio_lock_as_irq().

Oh no. Your request about gpio_lock_as_irq() is absolutely valid :)
And it has to be added

>
>> 2) After this patch the following object structure will be created during
>> Davinci GPIO driver initialization (DA850 has 144 IRQ lines):
>> - gpio_chip0(0..31)
>>    |- irq_domain1
>> - gpio_chip1(32..63)
>>    |- irq_domain2
>> - gpio_chip2(64..95)
>>    |- irq_domain3
>> - gpio_chip3(96..127)
>>    |- irq_domain4
>> - gpio_chip4(128..143)
>>    |- irq_domain5
>
> OK that's nice.
>
>> 3) But in case of DT only one GPIO controller node will be created
>> Example:
>> gpio: gpio@1e26000 {
>>          compatible = "ti,dm6441-gpio";
>>          gpio-controller;
>>          reg = <0x226000 0x1000>;
>>          interrupt-parent = <&intc>;
>>          interrupts = <42 IRQ_TYPE_EDGE_BOTH 43 IRQ_TYPE_EDGE_BOTH
>>                  44 IRQ_TYPE_EDGE_BOTH 45 IRQ_TYPE_EDGE_BOTH
>>                  46 IRQ_TYPE_EDGE_BOTH 47 IRQ_TYPE_EDGE_BOTH
>>                  48 IRQ_TYPE_EDGE_BOTH 49 IRQ_TYPE_EDGE_BOTH
>>                  50 IRQ_TYPE_EDGE_BOTH>;
>>          interrupt-controller;
>>          #interrupt-cells = <2>;
>>          ti,ngpio = <144>;
>>          ti,davinci-gpio-unbanked = <0>;
>> }
>
> Yep...
>
>> 4) As result, to make GPIO bindings/mappings work - we'll need to implement
>> .of_xlate() callback per GPIO chip, which will provide us with valid valid
>> gpio_chip and offset of gpio inside chip
>> (It was discussed before and supposed to be done as next step).
>
> Yeah.. this is usually a bit tricky.
>
>> For example, gpio_chip3 and offset=15 should be selected:
>> devA {
>>     gpios = <&gpio 111 GPIO_ACTIVE_HIGH>;
>> }
>>
>> 5) What should be done to make GPIO IRQ bindings/mappings work?
>>
>> Example:
>> devB {
>>     interrupt-parent = <&gpio>;
>>     interrupts = <111 IRQ_TYPE_EDGE_BOTH>;
>> }
>>
>> Should we implement one IRQ domain per all GPIO chips (per GPIO controller)?
>
> I don't know, I cannot really see where the problem is.
>
> The IRQ domain is for translationg hardware numbers such as bit offsets
> into Linux IRQ numbers and nothing else, so I'd suggest that as long as
> the thing you are translating/mapping is something simple like a bit
> index you're doing the right thing.
>
> If it becomes something complex where that index is not just a bit
> but an index into an array of registers at various locations it is
> abusing the irqdomain.
>
> So I think you should create one irqdomain per GPIO instance
> or bank or whatever you want to call it: like if there is this one
> register with 32 bits, then it gets its own IRQdomain.
>
> I think you should try to keep the 5 irqdomains, but whatever
> gives the simplest code is usually the right answer, and
> divide-and-conquer (split down the problem) is usually a good
> idea.
>
> How the GPIO block(s) are represented in the device tree is
> another totally separate issue about hardware description,
> do not let the device tree model your driver structure.

Thanks for you comments, but looks like I have to be more specific :)

How irq_find_host() will look for proper IRQ domain in our case?
And will it work at all, taking into account that all (5) IRQ domains
will have the same value of "of_node" property?
of_irq_to_resource()
|-irq_of_parse_and_map()
   |-irq_create_of_mapping()
     |-irq_find_host(irq_data->np)
  where np will point on GPIO node.

As result my question is about what do DT core frameworks allow or not
allow to do? And according to that implementation of driver can be
changed.

Regards,
-grygorii

