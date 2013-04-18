Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936140Ab3DRLbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:31:45 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:37472 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936028Ab3DRLbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:31:44 -0400
Date: Thu, 18 Apr 2013 12:31:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 24/32] dmaengine: ste_dma40: Supply full Device Tree
 parsing support
Message-ID: <20130418113138.GD27903@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-25-git-send-email-lee.jones@linaro.org>
 <201304181306.34835.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304181306.34835.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013, Arnd Bergmann wrote:

> On Thursday 18 April 2013, Lee Jones wrote:
> > Using the new DMA DT bindings and API, we can register the DMA40 driver
> > as Device Tree capable. Now, when a client attempts to allocate a
> > channel using the DMA DT bindings via its own node, we are able to parse
> > the request and allocate a channel in the correct manor.
> 
> s/manor/manner/ ?
> 
> > +Optional properties:
> > +- interrupt-parent: Should be the phandle for the interrupt controller
> > +  that services interrupts for this device
> 
> I would not bother listing the interrupt-parent.
> 
> > +Clients
> > +Required properties:
> > +- dmas: Comma seperated list of dma channel requests
> > +- dma-names: Names of the aforementioned requested channels
> > +
> > +Each dmas request consists of 4 cells:
> > +  1. A phandle pointing to the DMA controller
> > +  2. The DMA request line number (only when 'use fixed channel' is set)
> > +  3. Device Type
> > +  4. A 32bit mask specifying; mode, direction and endianess [NB: This list will grow]
> > +        bits 1-2: Mode:
> > +          00: Logical
> > +          01: Physical
> > +          10: Operation
> > +          11: Undefined - will most likely return an error
> 
> The statement "will most likely return an error" is not very
> specification-like. ;-) Maybe better call it "reserved".

Actually, I wrote this before I wrote the code.

It definitely does return an error. :)

I'll fixup as you requested anyway.

> What is actually an "Operation" channel? Do we need it for slaves?

No idea. It was in the header file, so I thought I'd better reserve a
bit for it early in case it comes in handy later. 

> > +        bits 3-4: Direction:
> > +          00: Mem to Mem
> > +          01: Mem to Dev
> > +          10: Dev to Mem
> > +          11: Dev to Dev
> 
> For slave channels, we only need mem-to-dev and dev-to-mem, so I would
> use only one bit here.

Okay.

> > +        bit 5: Endianess:
> > +           0: Little endian
> > +           1: Big endian
> > +        bit 6: Use fixed channel:
> > +           0: Use automatic channel selection
> > +           1: Use DMA request line number
> 
> I think you have mixed up the "device type" and "request line number".
> 
> The request line is what identifies the slave device (which you call
> the device type)

You're right, I am a little confused by them.

I call them 'device type' because that's what they're called already.
Grep for 'dma_dev_type'. This is the number which gets split into
event group and line, like this:

	event_group = D40_TYPE_TO_GROUP(dev_type);
	event_line = D40_TYPE_TO_EVENT(dev_type);

> and I would put that number first.

So you want me to switch that round so it looks like:

	dmas = <<phandle> <dev_type> <fixed_chan> <flags>;

Instead of what I have at the moment:

	dmas = <<phandle> <fixed_chan> <dev_type> <flags>;

Correct?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
