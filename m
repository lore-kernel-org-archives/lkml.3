Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab3BDU3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:29:50 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:38820 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab3BDU3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:29:47 -0500
MIME-Version: 1.0
In-Reply-To: <51100A72.6030909@ti.com>
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
Date: Mon, 4 Feb 2013 21:29:46 +0100
Message-ID: <CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com>
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

On Mon, Feb 4, 2013 at 8:22 PM, Cyril Chemparathy <cyril@ti.com> wrote:

> Based on our experience with fitting multiple subsystems on top of this
> DMA-Engine driver, I must say that the DMA-Engine interface has proven
> to be a less than ideal fit for the network driver use case.
>
> The first problem is that the DMA-Engine interface expects to "push"
> completed traffic up into the upper layer as a part of its callback.
> This doesn't fit cleanly with NAPI, which expects to "pull" completed
> traffic from below in the NAPI poll.  We've somehow kludged together a
> solution around this, but it isn't very elegant.

I cannot understand the actual technical problem from the above
paragraphs though. dmaengine doesn't have a concept of pushing
nor polling, it basically copies streams of words from A to B, where
A/B can be a device or a buffer, nothing else.

The thing you're looking for sounds more like an adapter on top
of dmaengine, which can surely be constructed, some
drivers/dma/dmaengine-napi.c or whatever.

> The second problem is one of binding fixed DMA resources to fixed users.
>   AFAICT, the stock DMA-Engine mechanism works best when one DMA
> resource is as good as any other.

The filter function picks a channel for whatever reason. That reason
can be, well whatever. Some engines have a clever mechanism to
select resources on the other end.

Then for tying devices to channels we have the dmaengine
DT branch:
http://git.infradead.org/users/vkoul/slave-dma.git/shortlog/refs/heads/topic/dmaengine_dt

This stuff didn't go into v3.8 but you can *sure* expect it
to be in v3.9.

Or are you referring to a multi-engine scenario? Say if there is engine
A and B and depending on circumstances A or B may be preferred
in some order (and permutations of this problem). That is currently
identified as a shortcoming that we need help to address.

> To get over this problem, we've added
> support for named channels, and drivers specifically request for a DMA
> resource by name.  Again, this is less than ideal.

Jon Hunter has been working on a mechanism to look up DMA channels
from struct device *, dev_name() or a device tree node for example.
Just like we do with clocks or regulators.

Look at this patch from the dmaengine_dt branch:
http://git.infradead.org/users/vkoul/slave-dma.git/commitdiff/528499a7037ebec0636d928f88cd783c618df3c5

Looks up an optionally named channel for a certain
device.

It currently only supports device tree, but you are free to
patch in whatever mechanism you need there. Static tables
in platform data works too. Just nobody did it.

So go ahead and hack on dma_request_slave_channel().
(I would just branch of the DT branch.)

> We found that virtio devices offer a more elegant solution to this
> problem.  First, the virtqueue interface is a much better fit into NAPI
> (callback --> napi schedule, napi poll --> get_buf), and this eliminates
> the need for aforementioned kludges in the code.  Second, the virtio
> device infrastructure nicely uses the device model to solve the problem
> of binding DMA users to specific DMA resources.

Not that I understand the polling issue, but it sounds to me like
what Jon is doing is similar.

Surely the way to look up resources cannot be paramount in this
discussion, I think the real problem must be your specific networking
usecase, so we need to drill into that.

Yours,
Linus Walleij
