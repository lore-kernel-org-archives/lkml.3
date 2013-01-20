Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3ATQcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 11:32:31 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:58422 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3ATQcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 11:32:25 -0500
Date: Sun, 20 Jan 2013 11:37:35 -0500
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] dmaengine: add per channel capabilities api
Message-ID: <20130120163735.GC21407@beef>
References: <1357844826-30746-1-git-send-email-mporter@ti.com>
 <abcd725c6216491da2b1054e5e11ad82@DFLE72.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abcd725c6216491da2b1054e5e11ad82@DFLE72.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 12:37:34PM +0000, Vinod Koul wrote:
> On Thu, Jan 10, 2013 at 02:07:03PM -0500, Matt Porter wrote:
> > The call is implemented as follows:
> > 
> > 	struct dmaengine_chan_caps
> > 	*dma_get_channel_caps(struct dma_chan *chan,
> > 			      enum dma_transfer_direction dir);
> > 
> > The dma transfer direction parameter may appear a bit out of place
> > but it is necessary since the direction field in struct
> > dma_slave_config was deprecated. In some cases, EDMA for one, it
> > is necessary for the dmaengine driver to have the burst and address
> > width slave configuration parameters available in order to compute
> > the maximum segment size that can be handle. Due to this requirement,
> > the calling order of this api is as follows:
> Well you are passing direction as argument so even in EDMA it doesn't seem to
> help you as you seem to need burst and width!. So why do you even need the
> direction to compute the capablities

Yes, I need burst and width, but they are dependent on direction (dst vs
src, as stored in the slave channel config). Ok, so I think I know where
this is leading...the problem is probably that I made an implicit
dependency on burst and width here. The expectation in this
implementation is that dmaengine_slave_config() has already been called
and as a result, the dmaengine driver has either src_* or dst_*
attributes populated depending on the direction of the channel. Given
that, the call to dma_get_channel_caps() needs to provide the direction
in order for the driver to know which of src_*/dst_* attributes are
valid in order to do the max segment size calculation.

An alternative, since the slave driver is the one that provided the
info in the first place is:

	struct dmaengine_chan_caps
	*dma_get_channel_caps(struct dma_chan *chan,
			      enum dma_slave_buswidth addr_width,
			      u32 maxburst);

where the attributes required by the edma driver to find the max
segment size are now explicitly provided. This approach also removes
the ordering requirement of calling dmaengine_slave_config() first. Is
this what you had in mind?

-Matt
