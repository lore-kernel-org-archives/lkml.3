Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab3IBL6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:58:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:4437 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab3IBL6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:58:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1006,1367996400"; 
   d="scan'208";a="354819090"
Date: Mon, 2 Sep 2013 16:42:00 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lu Jingchang-B35083 <B35083@freescale.com>
Cc: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver support
Message-ID: <20130902111200.GP7376@intel.com>
References: <1376633274-17850-1-git-send-email-b35083@freescale.com>
 <20130828081742.GC11414@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520A8C7@039-SN1MPN1-003.039d.mgd.msft.net>
 <20130902045050.GE7376@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520D0D4@039-SN1MPN1-004.039d.mgd.msft.net>
 <20130902063721.GK7376@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520F101@039-SN1MPN1-004.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B56CDBE15CE27145A4B77D2D24263E8520F101@039-SN1MPN1-004.039d.mgd.msft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 07:32:53AM +0000, Lu Jingchang-B35083 wrote:
> > > > > > > +	chan->private = fn_param;
> > > > > > why do you need to use chan->private?
> > > > > [Lu Jingchang]
> > > > > The private used here is to store the slot_id information, which
> > must
> > > > be used
> > > > > by the DMAMUX in alloc_chan_resources function. Thanks.
> > > > Why dont you pass this in struct dma_slave_config memeber slave_id
> > for
> > > > this.
> > > [Lu Jingchang-b35083]
> > > I will drop this private and setup the slave_id directly in the filter
> > function.
> > why in filter? before calling prepare function you can set the slave
> > config
> How about change the filter_fn to follow:
> static bool fsl_edma_filter_fn(struct dma_chan *chan, void *fn_param)
> {
>         struct fsl_edma_filter_param *fparam = fn_param;
>         struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
>         unsigned char val;
> 
>         if (fsl_chan->edmamux->mux_id != fparam->mux_id)
>                 return false;
> 
>         val = EDMAMUX_CHCFG_ENBL | EDMAMUX_CHCFG_SOURCE(fparam->slot_id);
>         fsl_edmamux_config_chan(fsl_chan, val);
>         return true;
> }
> In fact the slot_id isn't need elsewhere, and if the filter return true, 
> This channel should be to this request. So no need to save the slave id, Right?
something like

static bool fsl_edma_filter_fn(struct dma_chan *chan, void *fn_param)
{
	struct fsl_edma_filter_param *fparam = fn_param;
	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);

	if (fsl_chan->edmamux->mux_id != fparam->mux_id)
		return false;
	return true;
}

in thedriver which calls this:

before prep:

	config->slave_id = val;

	dma_set_slave_config(chan, slave);

~Vinod
