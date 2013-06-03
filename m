Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110Ab3FCEFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 00:05:42 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:35209 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3FCEFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 00:05:34 -0400
Message-ID: <51AC15FA.4060800@synopsys.com>
Date: Mon, 3 Jun 2013 09:35:14 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Rob Herring <rob.herring@calxeda.com>, "Rob Landley" <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH V3] irqchip: Add TB10x interrupt controller driver
References: <20130530211944.05F4D3E0A90@localhost> <1370014348-21121-1-git-send-email-christian.ruppert@abilis.com> <alpine.LFD.2.02.1305311835040.2905@ionos> <20130531221814.534DF3E08FE@localhost>
In-Reply-To: <20130531221814.534DF3E08FE@localhost>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 03:48 AM, Grant Likely wrote:
> On Fri, 31 May 2013 19:32:34 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
>> irq chip.
>>> +static void tb10x_irq_cascade(unsigned int irq, struct irq_desc *desc)
>>> +{
>>> +	struct irq_domain *domain = irq_desc_get_handler_data(desc);
>>> +
>>> +	generic_handle_irq(irq_find_mapping(domain, irq));
>>> +}
>> ...
>>
>>> +	for (i = 0; i < nrirqs; i++) {
>>> +		unsigned int irq = irq_of_parse_and_map(ictl, i);
>>> +
>>> +		irq_set_handler_data(irq, domain);
>>> +		irq_set_chained_handler(irq, tb10x_irq_cascade);
>>> +	}
>> I might be completely confused, but this does not make any sense at
>> all.
>>
>> You allocate a linear domain and then map the interrupts in the
>> domain. The mapping function retrieves the hardware interrupt number
>> and creates a virtual interrupt number, installs the chip and the
>> handler for the interrupt and finally returns the virtual interrupt
>> number.
>>
>> Now you take that virtual interrupt number and install
>> tb10x_irq_cascade as the handler. irq_set_chained_handler() will
>> startup (unmask) the interrupt right away.
>>
>> In the cascade handler you take the virtual interrupt number, which
>> you get as argument, and find the mapping, i.e. the matching VIRTUAL
>> interrupt number for the VIRTUAL interrupt number and then call the
>> handler.
>>
>> How is this supposed to work?
> I think what is going on here is that the tb10x interrupt controller
> appears to be more of a front-end to another interrupt controller with
> each input wired up 1:1 to the interrupt inputs of the other controller.
> (I don't know why someone would design an interrupt controller that way,
> but that's another issue). 

Actually ARC700 core has an integrated intc with 32 lines and ability to
mask/unmask each of the lines, priority/level per line etc. Simpler SoCs don't
need to have anymore.

> The loop above is mapping each of the
> interrupt inputs on the parent controller so that each child controller
> can be chained to it as an input. I can't think of how else it could be
> set up with the current code if the drivers were kept separate.
>
> Christian, what is the parent interrupt controller for this SoC? It
> really feels like the tb10x-ictl belongs as part of the parent
> controller. I went and looked at the parent node, and I saw this:
>
> 		intc: interrupt-controller {
> 				compatible = "snps,arc700-intc";
> 				interrupt-controller;
> 				#interrupt-cells = <1>;
> 		};
>
> I noticed the conspicuous absence of a reg property. Is this something
> architectural? 

Indeed, the intc is not memory mapped. It is accessed via the separate AUX address
space (and separate r/w instructions) similar to x86 I/O address space.

> If I were working on this system I'd drop the
> snps,arc700-intc node entirely and have a single abilis,tb10x-intc that
> encapsulated the properties of both (you would of course want to share
> handler functions for the 'normal' inputs without the custom features).
> That would eliminate the goofyness of listing 27 separate interrupts in
> the abilis,tb10x-ictl interrupts property.

But how is this different from other systems with a primary in-core intc and a
cascaded external intc. How do they do it. I guess I need to read up more on this.

-Vineet
