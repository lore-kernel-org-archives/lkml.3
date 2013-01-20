Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab3ATQqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 11:46:00 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:61169 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3ATQp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 11:45:58 -0500
Date: Sun, 20 Jan 2013 11:51:08 -0500
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] dma: edma: add device_channel_caps() support
Message-ID: <20130120165108.GE21407@beef>
References: <1357844826-30746-1-git-send-email-mporter@ti.com>
 <1357844826-30746-3-git-send-email-mporter@ti.com>
 <7bca07cce8884261b9828946dff5a076@DFLE72.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bca07cce8884261b9828946dff5a076@DFLE72.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 01:03:21PM +0000, Vinod Koul wrote:
> On Thu, Jan 10, 2013 at 02:07:05PM -0500, Matt Porter wrote:
> > Implement device_channel_caps().
> > 
> > EDMA has a finite set of PaRAM slots available for linking
> > a multi-segment SG transfer. In order to prevent any one
> > channel from consuming all PaRAM slots to fulfill a large SG
> > transfer, the driver reports a static per-channel max number
> > of SG segments it will handle.
> > 
> > The maximum size of SG segment is limited by the slave config
> > maxburst and addr_width for the channel in question. These values
> > are used from the current channel config to calculate and return
> > the max segment length cap.
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  drivers/dma/edma.c |   27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> > 
> > diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> > index 82c8672..fc4b9db 100644
> > --- a/drivers/dma/edma.c
> > +++ b/drivers/dma/edma.c
> > @@ -70,6 +70,7 @@ struct edma_chan {
> >  	bool				alloced;
> >  	int				slot[EDMA_MAX_SLOTS];
> >  	struct dma_slave_config		cfg;
> > +	struct dmaengine_chan_caps	caps;
> >  };
> >  
> >  struct edma_cc {
> > @@ -462,6 +463,28 @@ static void edma_issue_pending(struct dma_chan *chan)
> >  	spin_unlock_irqrestore(&echan->vchan.lock, flags);
> >  }
> >  
> > +static struct dmaengine_chan_caps
> > +*edma_get_channel_caps(struct dma_chan *chan, enum dma_transfer_direction dir)
> > +{
> > +	struct edma_chan *echan;
> > +	enum dma_slave_buswidth width = 0;
> > +	u32 burst = 0;
> > +
> > +	if (chan) {
> I think this check is redundant.

Yes, will remove.

> > +		echan = to_edma_chan(chan);
> > +		if (dir == DMA_MEM_TO_DEV) {
> > +			width = echan->cfg.dst_addr_width;
> > +			burst = echan->cfg.dst_maxburst;
> Per you API example burst and width is not set yet, so this doesn't make sense

The explanation in the cover letter mentions that dmaengine_slave_config() is
required to be called prior to dmaengine_get_channel_caps(). If we
switch to the alternative API, then that would go away including the
dependency on direction.

> > +		} else if (dir == DMA_DEV_TO_MEM) {
> > +			width = echan->cfg.src_addr_width;
> > +			burst = echan->cfg.src_maxburst;
> > +		}
> > +		echan->caps.seg_len = (SZ_64K - 1) * width * burst;
> Also the defination of API is max, above computation doesn't make sense to me!

Ok, so in this case, the slave driver has informed the dmaengine driver
that the max burst for the channel is foo. That's in units of
addr_width. On the EDMA DMAC, we program burst transfers by setting ACNT
to our per-transfer width (FIFO width in the slave SG case we are
covering here) then BCNT gets the maxburst setting. We then have a CCNT
field for EDMA that has a limit of SZ_64K-1 transfers. Thus, if a slave
driver tells us the maxburst for the channel is foo and our width is
bar, the maximum size of an SG segment in that configuration is:
(SZ_64K - 1) * bar * foo. 

-Matt
