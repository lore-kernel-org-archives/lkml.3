Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaHAOxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:53:36 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:32904 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751887AbaHAOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:53:35 -0400
Date: Fri, 1 Aug 2014 15:53:26 +0100
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
Message-ID: <20140801145325.GR30282@n2100.arm.linux.org.uk>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com> <20140730160607.GM8181@intel.com> <20140731074440.GY3952@lukather> <20140731132223.GK30282@n2100.arm.linux.org.uk> <20140731164152.GF3952@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731164152.GF3952@lukather>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 06:41:52PM +0200, Maxime Ripard wrote:
> You prove my point then. Vinod asks for GFP_NOWAIT in his
> reviews. Even though it doesn't change anything relative to the
> atomicity of the operations, the policy is still not the same.

The difference between GFP_NOWAIT and GFP_ATOMIC is whether the emergency
pool can be used.  If you want DMA prepare functions to fail when there
is memory pressure, and you can guarantee that all drivers using the DMA
engine API will properly fall back to some other method, then I suppose
using GFP_NOWAIT is reasonable.  GFP_ATOMIC just provides additional
protection.

> > >   - That might just be my experience, but judging from previous
> > >     commits, DMA_PRIVATE is completely obscure, and we just set it
> > >     because it was making it work, without knowing what it was
> > >     supposed to do.
> > 
> > DMA_PRIVATE means that the channel is unavailable for async-tx operations
> > - in other words, it's slave-only.  Setting it before registration results
> > in the private-use count being incremented, disabling the DMA_PRIVATE
> > manipulation in the channel request/release APIs (requested channels are
> > unavailable for async-tx operations, which is why that flag is also set
> > there.)
> > 
> > To put it another way, if a DMA engine driver only provides slave DMA
> > support, it must set DMA_PRIVATE to mark the channel unavailable for
> > async-tx operations.  If a DMA engine drivers channels can also be used
> > for async-tx operations, then it should leave the flag clear.
> 
> What about channels that can be both used for slave operations and
> async-tx (like memcpy) ?

Then you don't set DMA_PRIVATE when the DMA engine driver registers with
the core.  That then allows the DMA engine core to manage the flag,
setting it when the channel is allocated for slave usage.

One important point here is that async_tx does not have the idea of
channel allocation - a channel which is registered into the DMA engine
core without DMA_PRIVATE set is a candidate for use by the async_tx
API.

> Hence why we should document as much as possible then, to spread the
> knowledge and avoid it being lost when someone disappears or isn't
> available anymore.
> 
> (And hopefully reduce the number of "errors" that might be done by
> submitters, hence reducing the number of review iterations, lessening
> the maintainers load)

The bigger issue in the longer run is being able to maintain and improve
the DMA engine implementations and API.  One of the blockers to that is
properly understanding all the async_tx API stuff, something which even
I have been unable to do despite knowing a fair amount about DMA engine
itself.

Where I fall down is the exact meaning of the ACK stuff, how the chaining
is supposed to work, how the dependency between two DMA channels are
handled.

This is why I was unable to resolve DMA engine's multiple mapping of the
same DMA buffers, which has caused problems for ARM.

I've discussed this point in the past with Dan, making the point that
each DMA engine driver should not be that concerned about things like
descriptor list management, cookies, dependent transfers, but we seem
to be ultimately doomed to re-implementing much of that infrastructure
in every single DMA engine driver that comes along.

Each DMA engine driver which gets accepted into mainline makes this
problem worse - it's another driver which does something slightly
differently that if we were to ever clean this stuff up, would need
to be fixed.  This remains my biggest concern with the DMA engine
code today, and I'm one of the few people who have put effort into
trying to sort that out.

> > Drivers should have no reason what so ever to be touching the cookie
> > directly anymore.
> 
> Ok, thanks a lot for this!

I notice that drivers/dma/sirf-dma.c directly touches it and the
completed cookie as well:

drivers/dma/sirf-dma.c: dma_cookie_t last_cookie = 0;
drivers/dma/sirf-dma.c:                         last_cookie = desc->cookie;
drivers/dma/sirf-dma.c:                 schan->chan.completed_cookie = last_cookie;

That's something which should be fixed.  I haven't looked too hard
because it's not something I want to get involved with again right
now.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
