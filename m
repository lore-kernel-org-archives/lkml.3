Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3G2GDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:03:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:56529 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab3G2GC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:02:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,767,1367996400"; 
   d="scan'208";a="338279351"
Date: Mon, 29 Jul 2013 10:53:13 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Subject: Re: [PATCH V2] dma: mmp_pdma: support for getting residual bytes
Message-ID: <20130729052313.GB29095@intel.com>
References: <1371544880-26782-1-git-send-email-wangxfdu@gmail.com>
 <20130705064449.GC10947@intel.com>
 <CACDNBm0HA_Ptgq_he-07-PpocZ6Qf7E+rP_W1yAFpSnmoZVaeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACDNBm0HA_Ptgq_he-07-PpocZ6Qf7E+rP_W1yAFpSnmoZVaeQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 10:54:29AM +0800, Xiang Wang wrote:
> >> +static u32 mmp_pdma_get_bytes_residue(struct mmp_pdma_chan *chan)
> >> +{
> >> +     u32 reg, orig_pos, cur_pos, ddadr, residue = 0;
> >> +     bool running_desc_found = false;
> >> +     struct mmp_pdma_desc_sw *desc_sw;
> >> +
> >> +     /*
> >> +      * When a phy channel is unavailable, maybe it has been freed, return
> >> +      * last stored value for safe.
> >> +      */
> >> +     if (!chan->phy)
> >> +             return chan->bytes_residue;
> >> +
> >> +     reg = (chan->phy->idx << 4) + DDADR;
> >> +     ddadr = readl_relaxed(chan->phy->base + reg);
> >> +
> >> +     /* iterate over all descriptors to sum up the number of pending bytes */
> > and why?
> >
> > Residue does not mean sum of all pending bytes across all descriptors submitted
> > You need to find the residue of current descriptor only and return
> >
> Here are my thoughts:
> We tell dma engine to transmit x bytes for us and it creates n
> descriptors to transmit which is transparent to us.
> So when we want to find out how many bytes are left, dma engine should
> sum up all pending bytes across all descriptors.
> What's your opinion?
but you may have multiple transactions submmited. Iterating over _all_
descriptors doesnt make sense then. You need to iterate over descriptors for
current transaction only.

> >> +     list_for_each_entry(desc_sw, &chan->chain_running, node) {
> >> +             /* for the case of a running descriptor */
> >> +             if (desc_sw->desc.ddadr == ddadr && !running_desc_found) {
> >> +                     switch (chan->dir) {
> >> +                     case DMA_DEV_TO_MEM:
> >> +                     case DMA_MEM_TO_MEM:
> >> +                             reg = (chan->phy->idx << 4) + DTADR;
> >> +                             cur_pos = readl_relaxed(chan->phy->base + reg);
> >> +                             orig_pos = desc_sw->desc.dtadr;
> >> +                             break;
> >> +
> >> +                     case DMA_MEM_TO_DEV:
> >> +                             reg = (chan->phy->idx << 4) + DSADR;
> >> +                             cur_pos = readl_relaxed(chan->phy->base + reg);
> >> +                             orig_pos = desc_sw->desc.dsadr;
> >> +                             break;
> >> +
> >> +                     default:
> >> +                             cur_pos = 0;
> >> +                             orig_pos = 0;
> > This makes no sense...
> What do you recommend for the default case? Just return 0?
why should direction be anything other than these? This is error!

~Vinod
-- 
