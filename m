Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaHBP3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 11:29:33 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33832 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754477AbaHBP3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 11:29:32 -0400
Date: Sat, 2 Aug 2014 16:29:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
	dma controller API
Message-ID: <20140802152921.GC30282@n2100.arm.linux.org.uk>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com> <20140730160607.GM8181@intel.com> <20140731074440.GY3952@lukather> <20140731132223.GK30282@n2100.arm.linux.org.uk> <20140731164152.GF3952@lukather> <20140801145325.GR30282@n2100.arm.linux.org.uk> <20140802151144.GK3952@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140802151144.GK3952@lukather>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 05:11:44PM +0200, Maxime Ripard wrote:
> On Fri, Aug 01, 2014 at 03:53:26PM +0100, Russell King - ARM Linux wrote:
> > > > >   - That might just be my experience, but judging from previous
> > > > >     commits, DMA_PRIVATE is completely obscure, and we just set it
> > > > >     because it was making it work, without knowing what it was
> > > > >     supposed to do.
> > > > 
> > > > DMA_PRIVATE means that the channel is unavailable for async-tx operations
> > > > - in other words, it's slave-only.  Setting it before registration results
> > > > in the private-use count being incremented, disabling the DMA_PRIVATE
> > > > manipulation in the channel request/release APIs (requested channels are
> > > > unavailable for async-tx operations, which is why that flag is also set
> > > > there.)
> > > > 
> > > > To put it another way, if a DMA engine driver only provides slave DMA
> > > > support, it must set DMA_PRIVATE to mark the channel unavailable for
> > > > async-tx operations.  If a DMA engine drivers channels can also be used
> > > > for async-tx operations, then it should leave the flag clear.
> > > 
> > > What about channels that can be both used for slave operations and
> > > async-tx (like memcpy) ?
> > 
> > Then you don't set DMA_PRIVATE when the DMA engine driver registers with
> > the core.  That then allows the DMA engine core to manage the flag,
> > setting it when the channel is allocated for slave usage.
> 
> Then I guess we currently have a bug related to this.
> 
> During the development of the A31 driver that recently got merged,
> during two subsequent channel allocation, the second would fail if
> DMA_PRIVATE wasn't set.
> 
> I think it was on in dmaengine_get, but I'll have to get back to you
> on that whenever I'm back from my holydays.

I think you mean dma_chan_get().  dmaengine_get() is used to obtain
references to the async_tx memcpy/crypto channels, and should not be used
by a driver making use of the slave capabilities.

There two systems are slightly competitive between each other.  Slave
stuff generally want to get hold of specific channels, whereas the
async_tx stuff can generally do with any channel which provides the
appropriate capabilities, and can switch between channels if it needs
to perform a series of operations only supported by separate channels.

> You can also add vchan scheduling or descriptor allocations. The atmel
> guys seem to have hit a performance issue with dma_pool_alloc, so they
> re-developped a descriptor allocation mechanism in their driver. I
> don't have much more details on this, but if that was to be true, that
> would definitely be something that should be in the framework.

It is entirely legal for a dmaengine driver to maintain its own list of
"free" transaction descriptors (that's actually what many async-tx
drivers do) and is partly why there's the alloc_chan_resources and
free_chan_resources callbacks.

However, they tend to be fairly large structures, and don't always
match what the hardware wants, so using them to describe the individual
scatterlist elements of a transaction is not always a good idea.

> vchan mapping to physical channels also seem to be quite common in the
> drivers. That would be a nice addition too.

It's intentionally not in the vchan interface because that mapping is
device specific.

For example, there are some DMA engine implementations where certain
physical DMA channels should not be used because they have slightly
different properties (for example, they can lock the CPU off the bus
if they're permanently transferring data, such as in a memcpy or
device-to-memory transfer where the device always has data available.)

In any case, I'm not interested in seeing vchan turning into another
"layer" - it must remain a library.  Layers are bad news. :)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
