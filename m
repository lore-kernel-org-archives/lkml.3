Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaATLVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:21:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:30024 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaATLVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:21:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="469448429"
Date: Mon, 20 Jan 2014 15:50:07 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingchang Lu <jingchang.lu@freescale.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Huan Wang <Huan.Wang@freescale.com>
Subject: Re: [PATCHv10 2/2] dma: Add Freescale eDMA engine driver support
Message-ID: <20140120102007.GC26823@intel.com>
References: <1389938684-29467-1-git-send-email-b35083@freescale.com>
 <1389938684-29467-3-git-send-email-b35083@freescale.com>
 <20140120074019.GF26823@intel.com>
 <43d79ce905e24e9bb58ef49ac19db7d7@BL2PR03MB467.namprd03.prod.outlook.com>
 <20140120093541.GX26823@intel.com>
 <f173c2531461478899818365e06df437@BL2PR03MB467.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f173c2531461478899818365e06df437@BL2PR03MB467.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 11:05:03AM +0000, Jingchang Lu wrote:
> > > > > +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> > > > > +	struct dma_slave_config *cfg = (void *)arg;
> > > > > +	unsigned long flags;
> > > > > +	LIST_HEAD(head);
> > > > > +
> > > > > +	switch (cmd) {
> > > > > +	case DMA_TERMINATE_ALL:
> > > > > +		spin_lock_irqsave(&fsl_chan->vchan.lock, flags);
> > > > > +		fsl_edma_disable_request(fsl_chan);
> > > > > +		fsl_chan->edesc = NULL;
> > > > > +		vchan_get_all_descriptors(&fsl_chan->vchan, &head);
> > > > > +		spin_unlock_irqrestore(&fsl_chan->vchan.lock, flags);
> > > > > +		vchan_dma_desc_free_list(&fsl_chan->vchan, &head);
> > > > > +		return 0;
> > > > well what happens to the current ongoing transactions, i don't see
> > those
> > > > getting
> > > > terminated?
> > > The fsl_edma_disable_request(fsl_chan) would end the channel's ongoing
> > transaction, then
> > > the eDMA would not response to device dma request, and the
> > vchan_dma_desc_free_list()
> > > will release all associate memory. Thanks.
> > Can you explain a bit more how terminate will happen, given taht you are
> > using
> > same thing for pause?
> It works just like an interrupt controller on irq enable and disable. It has a register called
> set/clear enable request register(SERQ/CERQ) to enable or disable the DMA request for a given
> channel. It won't transfer data any more with the enable request register cleared. So for the
> pause and terminate the pause is the same. And there is no other way to stop the channels.
well then it is not pause! If you jave no way to stop the channel, you cant
claim to support pause and resume!

Also, for terminate this will be problematic. Assuming you are doing transfers
and terminate is invoked. Then you will disable irq. The transfers may get stuck
and periphral clock may go away after transfer so current transaction never gets
completed, how do we recovery from this?


Alstly, have you looked at edma driver already existing, any similarties in teh
controller with that?


> > > > > +static struct dma_async_tx_descriptor *fsl_edma_prep_dma_cyclic(
> > > > > +		struct dma_chan *chan, dma_addr_t dma_addr, size_t
> > buf_len,
> > > > > +		size_t period_len, enum dma_transfer_direction
> > direction,
> > > > > +		unsigned long flags, void *context)
> > > > > +{
> > > > you may want to implement the capablities api subsequently for audio
> > > > usage.
> > > Do you mean the device_slave_caps function? If it is, I will add it.
> > Yes, that can be incrementally added..
> I have send the v11 patch out with a basic device_slave_caps definition. I notice
> that there is some new update of the dma capabilities, so if possible and others ok,
> could you please merge this patch first and leave me improving the driver in subsequent
> patches. Thanks.
Sure, as I said this can be incremental but atm am worried about pause and
terminate behaviour.

--
~Vinod
