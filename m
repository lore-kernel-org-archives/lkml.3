Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab3KMVDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:03:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36554 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3KMVDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:03:41 -0500
Date: Wed, 13 Nov 2013 15:03:38 -0600
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] dmaengine: add msm bam dma driver
Message-ID: <20131113210338.GA7571@agross>
References: <1382732643-8184-1-git-send-email-agross@codeaurora.org>
 <1382732643-8184-2-git-send-email-agross@codeaurora.org>
 <20131031165948.GM18788@intel.com>
 <20131031214621.GC24406@agross>
 <20131107230317.GA5494@agross>
 <20131113131812.GX8834@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113131812.GX8834@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 06:48:12PM +0530, Vinod Koul wrote:
> On Thu, Nov 07, 2013 at 05:03:17PM -0600, Andy Gross wrote:
> > On Thu, Oct 31, 2013 at 04:46:21PM -0500, Andy Gross wrote:
> > > On Thu, Oct 31, 2013 at 10:29:48PM +0530, Vinod Koul wrote:
> > > > On Fri, Oct 25, 2013 at 03:24:02PM -0500, Andy Gross wrote:
> > > > 
> > > > This should be sent to dmaengine@vger.kernel.org
> > >  
> > > I'll add the list when I send the second iteration or should I send it over mid
> > > stream?
> either ways is okay, but pls make sure the next rev is sent on list.
> 
> > > 
> > > > > +	/* reset channel */
> > > > > +	iowrite32(1, bdev->regs + BAM_P_RST(bchan->id));
> > > > > +	iowrite32(0, bdev->regs + BAM_P_RST(bchan->id));
> > > > > +
> > > > > +	dma_free_coherent(bdev->dev, BAM_DESC_FIFO_SIZE, bchan->fifo_virt,
> > > > > +				bchan->fifo_phys);
> > > > > +
> > > > > +	/* mask irq for pipe/channel */
> > > > > +	val = ioread32(bdev->regs + BAM_IRQ_SRCS_MSK_EE(bchan->ee));
> > > > > +	val &= ~(1 << bchan->id);
> > > > > +	iowrite32(val, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bchan->ee));
> > > > > +
> > > > > +	/* disable irq */
> > > > > +	iowrite32(0, bdev->regs + BAM_P_IRQ_EN(bchan->id));
> > > > > +
> > > > > +	clear_bit(bchan->ee, &bdev->enabled_ees);
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * bam_slave_config - set slave configuration for channel
> > > > > + * @chan: dma channel
> > > > > + * @cfg: slave configuration
> > > > > + *
> > > > > + * Sets slave configuration for channel
> > > > > + * Only allow setting direction once.  BAM channels are unidirectional
> > > > > + * and the direction is set in hardware.
> > > > > + *
> > > > > + */
> > > > > +static void bam_slave_config(struct bam_chan *bchan,
> > > > > +		struct bam_dma_slave_config *bcfg)
> > > > 
> > > > > +{
> > > > > +	struct bam_device *bdev = bchan->device;
> > > > > +
> > > > > +	bchan->bam_slave.desc_threshold = bcfg->desc_threshold;
> > > > what does the desc_threshold mean?
> > >  
> > > The desc threshhold determines the minimum number of bytes of descriptor that
> > > causes a write event to be communicated to the peripheral.  I default to 4 bytes
> > > (1 descriptor), but this is configurable through the DMA_SLAVE_CONFIG interface
> > > using the extended slave_config structure.
> sounds like src/dst_maxburst?
 
Ok, i wasn't sure if that really matched.  That simplifies this and gets me out
of dealing with a extended slave_config structure.  At least until I need to add
support for some of the other versions of our BAM DMA controller.

> > > > > + * bam_tx_submit - Adds transaction to channel pending queue
> > > > > + * @tx: transaction to queue
> > > > > + *
> > > > > + * Adds dma transaction to pending queue for channel
> > > > > + *
> > > > > +*/
> > > > > +static dma_cookie_t bam_tx_submit(struct dma_async_tx_descriptor *tx)
> > > > > +{
> > > > > +	struct bam_chan *bchan = to_bam_chan(tx->chan);
> > > > > +	struct bam_async_desc *desc = to_bam_async_desc(tx);
> > > > > +	dma_cookie_t cookie;
> > > > > +
> > > > > +	spin_lock_bh(&bchan->lock);
> > > > > +
> > > > > +	cookie = dma_cookie_assign(tx);
> > > > > +	list_add_tail(&desc->node, &bchan->pending);
> > > > > +
> > > > > +	spin_unlock_bh(&bchan->lock);
> > > > > +
> > > > > +	return cookie;
> > > > > +}
> > > > Okay you are *NOT* using virt-dma layer, all this can be removed if you do that,
> > > > this is similar to what vchan_tx_submit() does!
> > > >
> > > 
> > > I'll look into reworking and utilizing the virt-dma layer.
> > >  
> > 
> > Is it acceptable to pick and choose the pieces of the virt-dma layer that
> > benefit me? Or do I have to absorb all of it.  The smaller helper structs and
> > functions are fine, but in some cases they force a certain implementation.
> and that implementation is the right one and the what we expect from users!
> 
> > The bam_tx_submit and perhaps the cleanup functions are about the only pieces
> > I'd be able to leverage from the virt-dma, aside from the structures.
> > 
> > The main issue with the rest of the code is that it doesn't fit the behavior of
> > my dma controller.  Because i have a fixed sized circular buffer for my
> > descriptor FIFO, I have to copy in the new descriptors before I start up the
> > dma channel.
> the virt-dma is for managing the descriptors and the lists for managing the
> descriptors. Using this is right way and is based on dmaengine APIs and not on
> dma controllers, so I see no reason why you cant use this!
> 

Let me expand on how our hardware works:

The BAM controller requires the use of external memory for storage of the
hardware descriptors for each channel.  The location and size of the FIFO is
programmed into a set of registers.  The controller keeps track of the current
offset to be worked on within that FIFO.  Kicking off a transaction is as simple
as updating one register to indicate the offset of the next free descriptor.

So in the alloc_channel(), I allocate the FIFO.  However, I never consume any
FIFO space until the tx_submit() is called.  The prep_slave_sg() cannot consume
FIFO which means I have to keep around a copy of the sg list (or descriptors
that correspond to each entry).

> > Using the vchan_cookie_complete() forces me to start the next transaction within
> > the interrupt, or schedule another tasklet to do that work for me.  The overhead
> > for copying what could be a large number of descriptors into the FIFO might
> > introduce too much latency inside the IRQ handler  (especially since this is done
> > to non-cached memory).  Using another tasklet for just restarting the dma
> > controller seems klunky to me.
> That is the expectation from API. Once a txn is complete, you need to quickly
> start the next one in the completion.
>
> > I would rather start the next transaction within the tasklet queued from the IRQ
> > (vchan_cookie_complete), but because it uses it's own tasklet, I wouldn't be
> > able to leverage that.
> why dont you call the vchan_cookie_complete from the irq. That will trigger the
> virt-tasklet to complete the current one, then you schedule your tasklet to
> program the next one.
> 
This equates to serialization of DMA transactions on a channel.  We can't allow
the controller to immediately start on the next transaction until we've fully
processed the current one.  This introduces latency between each transaction for
no real reason.

> > The vchan_cookie_complete() usage within the IRQ handler also implys that only 1
> > dma transaction is completed per IRQ.  That might not be the case for me,
> > because I can advance the DMA FIFO offset to tell the controller to keep going
> > to the next transaction.  By the time I get to servicing the IRQ, I might have
> > completed more than 1 transaction.   I suppose you could call
> > vchan_cookie_complete() multiple times, but that seems wrong to me due to the
> > multiple calls to tasklet_schedule.
> I think you are mistaken here. If you have issued 3 descriptors to your HW, then
> assuming you got single completion (which IMO is wrong and you should get
> interrupt for every completion), then you mark all three as completed, the
> completion would move all the completed descriptors
>
Ok, lets say you have 1 large DMA transaction followed by 2 really small ones.
If I was to go ahead and advance my FIFO offset to indicate the 2 new
transactions (after an issue_pending) while the first transaction is still being worked on, I could
conceivably have all three complete by the time the ISR is serviced.

In the virt-dma model, I wouldn't advance my FIFO offset until the currently
running transaction completes.  The latency of kicking off that next transaction
means my channel utilization goes down because my controller is idle until I get
around to executing the tasklet to kick off the next one.
 
I think I'll just implement this both ways and gather some metrics on what it
costs me to use the virt-dma.

> > > > > +static int bam_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> > > > > +	unsigned long arg)
> > > > > +{
> > > > > +	struct bam_chan *bchan = to_bam_chan(chan);
> > > > > +	struct bam_device *bdev = bchan->device;
> > > > > +	struct bam_dma_slave_config *bconfig;
> > > > > +	int ret = 0;
> > > > > +
> > > > > +	switch (cmd) {
> > > > > +	case DMA_PAUSE:
> > > > > +		spin_lock_bh(&bchan->lock);
> > > > > +		iowrite32(1, bdev->regs + BAM_P_HALT(bchan->id));
> > > > > +		spin_unlock_bh(&bchan->lock);
> > > > > +		break;
> > > > > +	case DMA_RESUME:
> > > > > +		spin_lock_bh(&bchan->lock);
> > > > > +		iowrite32(0, bdev->regs + BAM_P_HALT(bchan->id));
> > > > > +		spin_unlock_bh(&bchan->lock);
> > > > > +		break;
> > > > > +	case DMA_TERMINATE_ALL:
> > > > > +		bam_dma_terminate_all(chan);
> > > > > +		break;
> > > > > +	case DMA_SLAVE_CONFIG:
> > > > > +		bconfig = (struct bam_dma_slave_config *)arg;
> > > > > +		bam_slave_config(bchan, bconfig);
> > > > DMA_SLAVE_CONFIG expects arg as struct dma_slave_config, not this. Pls dont
> > > > voilate APIs
> > > 
> > > So for extended slave_config structures, the caller needs to send in a ptr to
> > > the dma_slave_config and then I can determine the bam_dma_slave_config.  Will
> > > fix.
> What are the additional parameters you need to "extended" config?
> 
> > > 
> > > > > +		break;
> > > > > +	default:
> > > > > +		ret = -EIO;
> > > > I would expect -ENXIO here!
> > > > 
> > > 
> > > OK.
> > > 
> > > > > +		break;
> > > > > +	}
> > > > > +
> > > > > +	return ret;
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * bam_tx_status - returns status of transaction
> > > > > + * @chan: dma channel
> > > > > + * @cookie: transaction cookie
> > > > > + * @txstate: DMA transaction state
> > > > > + *
> > > > > + * Return status of dma transaction
> > > > > + */
> > > > > +static enum dma_status bam_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
> > > > > +		struct dma_tx_state *txstate)
> > > > > +{
> > > > > +	return dma_cookie_status(chan, cookie, txstate);
> > > > hmmm, this wont work in many cases for slave. For example if you try to get this
> > > > working with audio you need to provide the residue values.
> > > > The results you are providing here will not be useful, so I would recommedn
> > > > fixing it
> > > > 
> > > 
> > > Ok so in this case I'd need to read where I am in the descriptor chain and
> > > calculate the residual.  That shouldn't be a problem.
> Yup!
-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
