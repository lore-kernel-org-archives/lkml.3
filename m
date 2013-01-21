Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3AUST1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:19:27 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:39236 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3AUSTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:19:25 -0500
Date: Mon, 21 Jan 2013 13:19:23 -0500
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] dmaengine: add per channel capabilities api
Message-ID: <20130121181922.GD10020@beef>
References: <1357844826-30746-1-git-send-email-mporter@ti.com>
 <abcd725c6216491da2b1054e5e11ad82@DFLE72.ent.ti.com>
 <20130120163735.GC21407@beef>
 <c4113bae604945b586e9613814be737a@DLEE74.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4113bae604945b586e9613814be737a@DLEE74.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 03:15:23AM +0000, Vinod Koul wrote:
> On Sun, Jan 20, 2013 at 11:37:35AM -0500, Matt Porter wrote:
> > On Sun, Jan 20, 2013 at 12:37:34PM +0000, Vinod Koul wrote:
> > > On Thu, Jan 10, 2013 at 02:07:03PM -0500, Matt Porter wrote:
> > > > The call is implemented as follows:
> > > > 
> > > > 	struct dmaengine_chan_caps
> > > > 	*dma_get_channel_caps(struct dma_chan *chan,
> > > > 			      enum dma_transfer_direction dir);
> > > > 
> > > > The dma transfer direction parameter may appear a bit out of place
> > > > but it is necessary since the direction field in struct
> > > > dma_slave_config was deprecated. In some cases, EDMA for one, it
> > > > is necessary for the dmaengine driver to have the burst and address
> > > > width slave configuration parameters available in order to compute
> > > > the maximum segment size that can be handle. Due to this requirement,
> > > > the calling order of this api is as follows:
> > > Well you are passing direction as argument so even in EDMA it doesn't seem to
> > > help you as you seem to need burst and width!. So why do you even need the
> > > direction to compute the capablities
> > 
> > Yes, I need burst and width, but they are dependent on direction (dst vs
> > src, as stored in the slave channel config). Ok, so I think I know where
> > this is leading...the problem is probably that I made an implicit
> > dependency on burst and width here. The expectation in this
> And also due to wrong documentation. This is what you have put up the flow as:
> Due to this requirement,
> the calling order of this api is as follows:
> 
> 1. Allocate a DMA slave channel
> 1a. [Optionally] Get channel capabilities
> 2. Set slave and controller specific parameters
> 3. Get a descriptor for transaction
> 4. Submit the transaction
> 5. Issue pending requests and wait for callback notification
>
> Now when we query capablities, slave parameters _are_not_set_.
> So seems like you have thought something and written something else!

Agreed. My documentation is incorrect. My bad, it should have been
ordered 1, 2, 1a, ... as you've noted.

> Which brings me to the point on what are we trying to query:
> a) API capability, dont need slave parameters for that

agreed

> b) Sg segment length and numbers: Well these are capabilities, so it tells
> you what is the maximum I can do. IMO it doesn't make sense to tie it down to
> burst, width etc. For that configuration you are checking maximum. What this
> needs to return is what is the maximum length it supports and maximum number of
> sg list the h/w can use. Also if you return your burst and width capablity, then
> any client can easily find out what is the length byte value it can hold.
 
Ok, so I could report the max burst size to the client, but on EDMA it's
going to be SZ_64K-1, as that's the hw limit. Max addr width would also
be the same or capped at the maximum enum the current API support of 8
bytes.

This information is not useful to the client in my case. Only the client
knows its FIFO size, and thus the actual burst size it needs to request
as that is a value specific to the IP the client driver controls. So it
knows actual burst size and the width of that fifo transfer, because we
already support telling the dmaengine driver this info in the current
API.

But, the client driver has no idea what DMAC it's using under the API.
So, whereas if the omap_hsmmc driver is running on omap-dma, it can
handle any SG segment size, if the driver happens to be running on edma,
it needs to know the actual allowed max segment size for the slave
channel parameters that it has set. The theoretical max segment size
on EDMA is far larger than the actual maximum for a configured
slave channel. This is why (yes, I screwed up and the documentation had
the ordering wrong) I had the intention of dma_get_channel_caps() only
being valid *after* dma_slave_config() was called. This is, in fact,
the only point at which the edma driver has enough information to be
able to report a valid max number of segments back to a client driver.
Consider that on another channel, with burst size configured by a client
driver to a high value (e.g. twice as big of a FIFO), now the edma
driver has to report a small max segment size that can be used. The
client driver has no idea it's on an edma controller so it needs some
help from the dmaengine API to choose the optimal constraints when it
builds SG lists. Too large and the EDMA driver has to reject it, too
small and we lose performance and also run into the constraint edma has
on the total number of segments we can handle in one sg list.

> If you feel this computaion if client specific, though looking at doesnt make me
> think so, you can add a callback for this computaion given the parameters.

It's client-specific in the sense that the client peripheral is what
provides the address width and burst size constraint (based on the FIFO
integrated with that peripheral instantiation), but the abstracted
dmaengine peripheral is what provides the segment size limit (no limit
in the omap-dma case but a variable limit in the edma case).

Sounds like you prefer a separate API from dma_get_channel_caps() to
handle the case I'm describing here. Possibly a separate
dma_get_max_sg_seg_size() and dma_get_max_sg_seg_nr()?

-Matt
