Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab3BEQVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:21:54 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:43176 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3BEQVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:21:50 -0500
MIME-Version: 1.0
In-Reply-To: <5110369B.9060901@ti.com>
References: <20130201184915.GP2244@beef>
	<510C1D0E.6030401@mvista.com>
	<20130201185820.GE29898@arwen.pp.htv.fi>
	<510C2A47.1090607@mvista.com>
	<20130201205600.GA31762@arwen.pp.htv.fi>
	<20130201213003.GW2637@n2100.arm.linux.org.uk>
	<20130204154153.GA18237@arwen.pp.htv.fi>
	<510FF1A6.403@mvista.com>
	<20130204164712.GB4269@arwen.pp.htv.fi>
	<510FF5C9.3030600@mvista.com>
	<20130204170216.GC4269@arwen.pp.htv.fi>
	<51100A72.6030909@ti.com>
	<CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com>
	<5110369B.9060901@ti.com>
Date: Tue, 5 Feb 2013 17:21:48 +0100
Message-ID: <CACRpkda8xBB35CwuBH76xXcC341TeRs1ZuwzDD0LtuXc4ifQTw@mail.gmail.com>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
From: Linus Walleij <linus.walleij@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
Cc: balbi@ti.com, Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, "Nair, Sandeep" <sandeep_n@ti.com>,
        Chris Ball <cjb@laptop.org>, Matt Porter <mporter@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 11:30 PM, Cyril Chemparathy <cyril@ti.com> wrote:

> NAPI needs to switch between polled and interrupt driven modes of operation.
> Further, in a given poll, it needs to be able to limit the amount of traffic
> processed to a specified budget.

I don't think any of this is a problem.

Polling, just scan cookies. Disable or ignore the callbacks.

For IRQ mode, use the completion callback to push each cookie
to NAPI, and thus let the IRQ drive the traffic.

>> The thing you're looking for sounds more like an adapter on top
>> of dmaengine, which can surely be constructed, some
>> drivers/dma/dmaengine-napi.c or whatever.
>
> I'm not debating the possibility of duct-taping a network driver on top of
> the dma-engine interface.  That is very much doable, and we have done this
> already.

So it seems I have a different opinion on elegance.

I think it can be a nice little adapter, and you're talking about
duct-tape, like it's something ugly and crude.

So let's get to the bottom of that.

> Starting with a stock dma-engine driver, our first approach was to use
> dmaengine_pause() and dmaengine_resume() in the network driver to throttle
> completion callbacks per NAPI's needs.

Why? Do you really need to limit this in the middle of transfers?

I'm half-guessing that one transfer is typically something like one
packet. Pausing and starting would be something you would use
in case you had a circular buffer with an eternal ongoing transfer,
and you wanted to slow that down.

> Having learned our lessons from the first attempt, the second step was to
> add a separate notification callback from the dma-engine layer - a
> notification independent of any particular descriptor.  With this callback
> in place, we got rid of some of the state machine crap in the network
> driver.
>
> The third step was to add a dmaengine_poll() call instead of constantly
> bouncing a channel between paused and running states.  This further cleaned
> up some of the network driver code, but now the dma-engine driver looks like
> crap if it needs to support both the traditional and new (i.e. notify +
> poll) modes.  This is where we are at today.

I don't see why you have to modify dmaengine to do poll.
It should be trivial as discussed to just keep track of the cookies,
scan over them and poll out the completed work.

Then to mitigate the load I guess you just do not issue
too many dma transfers? Can you not regulate the workload
by adjusting the number of transfer cookies you issue in
parallel, and if they're not issued in parallel but adjacent,
can you not just issue them so often?

Or are you polling out half transfers or something, so
that the granularity of one transfer/cookie would be
enough?

Maybe I'm not getting the picture here?

Can you describe how the network stream is chopped into
transfers in this hardware, I think that could ease our
understanding?

Especially I guess we need to know if the hardware is providing
useful chunks like one packet or if it's just one eternal stream of
bits that you then have to demux and put into skbufs or
something.

> Even with the addition of these extensions, the interaction between the
> network driver and the dma-engine driver is clumsy and involves multiple
> back and forth calls per packet.  This is not elegant, and certainly not
> efficient.  In comparison, the virtqueue interface is a natural fit with the
> network driver, and is free of the aforementioned problems.

Yes the described approach and hacking around in dmaengine to
do the polling seems ugly. But just a queue of cookies does not
seem so ugly, rather the opposite.

> [Russell writes]
>>  So yes, the DMA engine API supports it.  Whether the _implementations_
>>  themselves do is very much hit and miss (and in reality is much more
>> miss than hit.)
>
> Don't these assume that the driver can determine the need for an interrupt
> upfront at prep/submit time?  AFAICT, this assumption doesn't hold true
> with NAPI.

Yes it does. You can however stop an ongoing transfer
(by referring to the cookie), pick out the bytes transferred so far
and trigger a new transfer using/not using an IRQ if you want.

This is an abstracted way of doing the same brutal buffer
slaying that I hear NAPI is doing to some network drivers.

For example see the RX path of this driver:
drivers/tty/serial/amba-pl011.c

There is DMA for it, but we may stop the DMA transfer on
an IRQ, take the partial buffer out and feed it to the TTY.
Could just as well be a network packet. Sometimes it is, if
there is a modem on the other end.

RX DMA is triggered in pl011_dma_rx_trigger_dma(),
then either pl011_dma_rx_callback() gets called if the DMA
transfer completes, or we get an IRQ (like a timeout) and
endup in pl011_dma_rx_irq(), where the transfer is stopped,
buffer emtied and then we can decide what to do next.

This could just as well have been some API calling in and
saying "give me your buffer NOW".

I think we need to look at an NAPI driver that does this trick
so we understand what you want from the API.

Yours,
Linus Walleij
