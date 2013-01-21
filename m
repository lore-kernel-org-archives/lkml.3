Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3AUDkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 22:40:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:22522 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab3AUDkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 22:40:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,502,1355126400"; 
   d="scan'208";a="274495557"
Date: Sun, 20 Jan 2013 19:15:23 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Matt Porter <mporter@ti.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] dmaengine: add per channel capabilities api
Message-ID: <20130121031523.GA21551@intel.com>
References: <1357844826-30746-1-git-send-email-mporter@ti.com>
 <abcd725c6216491da2b1054e5e11ad82@DFLE72.ent.ti.com>
 <20130120163735.GC21407@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130120163735.GC21407@beef>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 11:37:35AM -0500, Matt Porter wrote:
> On Sun, Jan 20, 2013 at 12:37:34PM +0000, Vinod Koul wrote:
> > On Thu, Jan 10, 2013 at 02:07:03PM -0500, Matt Porter wrote:
> > > The call is implemented as follows:
> > > 
> > > 	struct dmaengine_chan_caps
> > > 	*dma_get_channel_caps(struct dma_chan *chan,
> > > 			      enum dma_transfer_direction dir);
> > > 
> > > The dma transfer direction parameter may appear a bit out of place
> > > but it is necessary since the direction field in struct
> > > dma_slave_config was deprecated. In some cases, EDMA for one, it
> > > is necessary for the dmaengine driver to have the burst and address
> > > width slave configuration parameters available in order to compute
> > > the maximum segment size that can be handle. Due to this requirement,
> > > the calling order of this api is as follows:
> > Well you are passing direction as argument so even in EDMA it doesn't seem to
> > help you as you seem to need burst and width!. So why do you even need the
> > direction to compute the capablities
> 
> Yes, I need burst and width, but they are dependent on direction (dst vs
> src, as stored in the slave channel config). Ok, so I think I know where
> this is leading...the problem is probably that I made an implicit
> dependency on burst and width here. The expectation in this
And also due to wrong documentation. This is what you have put up the flow as:
Due to this requirement,
the calling order of this api is as follows:

1. Allocate a DMA slave channel
1a. [Optionally] Get channel capabilities
2. Set slave and controller specific parameters
3. Get a descriptor for transaction
4. Submit the transaction
5. Issue pending requests and wait for callback notification

Now when we query capablities, slave parameters _are_not_set_.
So seems like you have thought something and written something else!

Which brings me to the point on what are we trying to query:
a) API capability, dont need slave parameters for that
b) Sg segment length and numbers: Well these are capabilities, so it tells
you what is the maximum I can do. IMO it doesn't make sense to tie it down to
burst, width etc. For that configuration you are checking maximum. What this
needs to return is what is the maximum length it supports and maximum number of
sg list the h/w can use. Also if you return your burst and width capablity, then
any client can easily find out what is the length byte value it can hold.

If you feel this computaion if client specific, though looking at doesnt make me
think so, you can add a callback for this computaion given the parameters.

--
~Vinod
