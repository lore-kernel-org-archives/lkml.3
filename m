Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3FCFfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 01:35:22 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:63572 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3FCFfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 01:35:17 -0400
Message-ID: <51AC2A99.30709@synopsys.com>
Date: Mon, 3 Jun 2013 11:03:13 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH V3] irqchip: Add TB10x interrupt controller driver (2)
References: <20130530211944.05F4D3E0A90@localhost> <1370014348-21121-1-git-send-email-christian.ruppert@abilis.com> <alpine.LFD.2.02.1305311835040.2905@ionos> <20130531221814.534DF3E08FE@localhost> <20130601110133.GA4051@ab42.lan>
In-Reply-To: <20130601110133.GA4051@ab42.lan>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 04:31 PM, Christian Ruppert wrote:
> On Fri, May 31, 2013 at 11:18:14PM +0100, Grant Likely wrote:
>> On Fri, 31 May 2013 19:32:34 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
>>> On Fri, 31 May 2013, Christian Ruppert wrote:
>>>
>>>> The SOC interrupt controller driver for the Abilis Systems TB10x series of
>>>> SOCs based on ARC700 CPUs.
>>>>
>>>> This patch depends on commits eb76bdd407d8a90e59a06cb0158886df390e5d1c and
>>>> 712bc93df9e7f14b8a163148d2aa7c778e151627 from branch irq/for-arm of
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git.
>>> That branch can be pulled into ARC as well. It only contains the
>>> changes, which are necessary for the irq domain support of the generic
>>> irq chip.
> Vineet, what do you think about this? For the moment I have pulled the
> patch set into our local branch and to me it doesn't matter, we just
> have to make sure to respect this dependency when merging everything
> together.

Yes what you did is right. I don't have to back-merge any of this into my tree -
given that I'm not testing the v3 intc here. In 3.11 all respective changes will
go in via the respective trees anyways.

>
>> (I don't know why someone would design an interrupt controller that way,
>> but that's another issue).
> There are several technical reasons for this front-end. The one that
> concerns us most in the kernel is that the TB10x front-end does the
> translation from all kinds of interrupt trigger modes to the level
> triggered interrupts natively understood by the ARC CPU built-in
> controller.

As I mentioned in prev email,  arc in-core intc always exists, providing
reasonable functionality so that simpler SoCs don't have to do that themselves.


>> The loop above is mapping each of the
>> interrupt inputs on the parent controller so that each child controller
>> can be chained to it as an input. I can't think of how else it could be
>> set up with the current code if the drivers were kept separate.
> This is exactly the intention. I haven't found an easier way to do this
> either but I'm open to suggestions.

But the child intc must only uplink to one parent intc IRQ line. In that case why
do we need to enumerate the rest of them in code. Is that a limitation of
framework or the parent intc (with it's legacy domain instantiation) is not doing
something correct.

>  Btw, I have noticed that the parent
> controller interrupts from this loop are not listed in /proc/interrupts.
> I'm not sure if what is done in the loop is sufficient or if I should
> add something else (the naive option of using request_irq doesn't work,
> the kernel saying something in the lines of "irq XX triggered but noone
> cares").
>
>> Christian, what is the parent interrupt controller for this SoC? It
>> really feels like the tb10x-ictl belongs as part of the parent
>> controller. I went and looked at the parent node, and I saw this:
>>
>> 		intc: interrupt-controller {
>> 				compatible = "snps,arc700-intc";
>> 				interrupt-controller;
>> 				#interrupt-cells = <1>;
>> 		};
>>
>> I noticed the conspicuous absence of a reg property. Is this something
>> architectural?
> The parent controller is part of the CPU itself, see
> arch/arc/kernel/irq.c. This controller is maintained by Vineet and IMHO
> we should keep it separate from the TB10x one since it is implicitly
> used in all ARC-based platforms whereas the TB10x controller is used in
> Abilis chips only.

Ofcourse they have to separate. The question is, what do we need to do to avoid
clunkiness in code for the cascaded intc.

>> If I were working on this system I'd drop the
>> snps,arc700-intc node entirely and have a single abilis,tb10x-intc that
>> encapsulated the properties of both (you would of course want to share
>> handler functions for the 'normal' inputs without the custom features).
>> That would eliminate the goofyness of listing 27 separate interrupts in
>> the abilis,tb10x-ictl interrupts property.
> To complicate things even further, some ARC CPU built-in peripherals
> (e.g. timers) generate interrupts directly to the ARC built-in interrupt
> controller (without going through the TB10x front-end), hence the
> "goofy" list of interrupts in the TB10x DT node.

But I presume that this is common-place for cascaded intc setups - some
peripherals hooking up directly to topmost intc would be normal. But it seems I'm
not as educated in area as I really should be.

-Vineet
