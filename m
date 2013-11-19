Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab3KSUeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:34:15 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:54004 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab3KSUeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:34:12 -0500
MIME-Version: 1.0
In-Reply-To: <528B905E.6000206@ti.com>
References: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>
	<1383905510-31760-4-git-send-email-prabhakar.csengg@gmail.com>
	<CACRpkdaJg4wqtD5xhPVrHJHxFoVwau6jidbOuQ9xFSK_6drxPQ@mail.gmail.com>
	<528A2565.4000802@ti.com>
	<CACRpkda7h4hsMYv_2gdrY+JB80kHu3BkS5OOGyGhEZFc_UkCig@mail.gmail.com>
	<528B905E.6000206@ti.com>
Date: Tue, 19 Nov 2013 21:34:09 +0100
Message-ID: <CACRpkdYaWuepKCie82uRx4PMfb7xTLtU43WzsLzW7Bpor7wVgw@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] gpio: davinci: use irqdomain
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>, Sekhar Nori <nsekhar@ti.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 5:22 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> On 11/19/2013 01:06 AM, Linus Walleij wrote:

>> The problem that appear is if someone is using platform data-provided
>> IRQs off the irq_chip without calling gpio_to_irq() on the GPIO line
>> first. This has been determined to be legal to do, so preferably
>> create the map when registering the lines.
>
> Ok, I understand. It may fail in case if someone will define/calculate
>  IRQ number for device manually in board code, like:
>  dev_irq = (DA850_N_CP_INTC_IRQ + gpioN)

Usually people just hardcode the IRQ value or use some
#define, like they have often also done with GPIO numbers ...

> Also, looks like It is possible to fail if Main/arch IRQ controller
> code doesn't make call of irq_alloc_descs() during init, so
> allocated_irqs will be empty.

If you use irq_domain_add_simple() the irqdomain core
will actually attempt to do this.

But if you use a linear domain, you have to create these
irqdescs as you go. The simplest way to do this is to call
irq_create_mapping() on all IRQs, because that call will
also allocate some descriptor.

> Before recommending that, I've checked Davinci platform code and didn't
> find any risk places - BUT, Seems my findings need to be confirmed by
> Sekhar.

It's no big deal, but I just want you to be aware that this
may cause a problem at some point.

>> I think you should try to keep the 5 irqdomains, but whatever
>> gives the simplest code is usually the right answer, and
>> divide-and-conquer (split down the problem) is usually a good
>> idea.
>>
>> How the GPIO block(s) are represented in the device tree is
>> another totally separate issue about hardware description,
>> do not let the device tree model your driver structure.
>
>
> Thanks for you comments, but looks like I have to be more specific :)
>
> How irq_find_host() will look for proper IRQ domain in our case?
> And will it work at all, taking into account that all (5) IRQ domains
> will have the same value of "of_node" property?
> of_irq_to_resource()
> |-irq_of_parse_and_map()
>   |-irq_create_of_mapping()
>     |-irq_find_host(irq_data->np)
>  where np will point on GPIO node.
>
> As result my question is about what do DT core frameworks allow or not
> allow to do? And according to that implementation of driver can be
> changed.

Hm, I'm not like a super-expert on the interrupt core, but maybe
you need to create subnodes inside the top node to represent this,
then use of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
to populate them from the main node.

Yours,
Linus Walleij
