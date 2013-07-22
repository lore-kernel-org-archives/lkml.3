Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3GVXeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:34:22 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:42211 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3GVXeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:34:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 09/15] DMA: shdma: support referencing specific DMACs within a multiplexer in DT
Date: Tue, 23 Jul 2013 01:35:10 +0200
Message-ID: <1458504.WlA0Z5lFQc@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1307220823570.7852@axis700.grange>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de> <1722625.6c1mAhWBWU@avalon> <Pine.LNX.4.64.1307220823570.7852@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Monday 22 July 2013 08:34:19 Guennadi Liakhovetski wrote:
> On Mon, 22 Jul 2013, Laurent Pinchart wrote:
> > On Friday 19 July 2013 18:29:34 Guennadi Liakhovetski wrote:
> > > Currently shdma DT nodes have to be placed under a multiplexer node. DMA
> > > slave DT nodes then use that multiplexer's phandle in their "dmas"
> > > properties. However, sometimes it can be necessary to let DMA slaves
> > > only use a specific DMAC instance. In this case it would be logical to
> > > just use the respective phandle in that slave's "dmas" property. For
> > > this to work the referenced DMAC has to register a struct of_dma
> > > instance, which isn't presently done. Instead the driver currently only
> > > registers one struct of_dma for the multiplexer. This patch adds support
> > > for such configurations. To enable this option a "#dma-cells" property
> > > also must be added to the respective DMAC DT node.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > > ---
> > > 
> > >  Documentation/devicetree/bindings/dma/shdma.txt |   16 ++++++
> > 
> > Patches that touch DT bindings must be CC'ed to devicetree@vger.kernel.org
> > (http://www.gossamer-threads.com/lists/linux/kernel/1750512).
> 
> Yes, I saw that announcements, but if my calculations are correct, these
> patches went out before the MAINTAINERS patch above hit the mailing list,
> and as of this writing it's still not in next.

My point was merely to inform you of the change in case you had missed it :-)

> > >  drivers/dma/sh/shdma.h                          |    7 +++
> > >  drivers/dma/sh/shdmac.c                         |   66 ++++++++++++++++
> > >  3 files changed, 89 insertions(+), 0 deletions(-)
> 
> [snip]
> 
> > > diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
> > > index ae89261..0ddcddf 100644
> > > --- a/drivers/dma/sh/shdmac.c
> > > +++ b/drivers/dma/sh/shdmac.c
> > > @@ -22,6 +22,7 @@
> > >  #include <linux/module.h>
> > >  #include <linux/of.h>
> > >  #include <linux/of_device.h>
> > > +#include <linux/of_dma.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/interrupt.h>
> > >  #include <linux/dmaengine.h>
> > > @@ -665,6 +666,63 @@ static const struct shdma_ops sh_dmae_shdma_ops = {
> > >  	.get_partial = sh_dmae_get_partial,
> > >  };
> > > 
> > > +static bool sh_dmae_chan_filter(struct dma_chan *chan, void *arg)
> > > +{
> > > +	struct sh_dmae_filter_info *info = arg;
> > > +	struct shdma_chan *schan = to_shdma_chan(chan);
> > > +	int match = info->hw_req;
> > > +
> > > +	if (match < 0)
> > > +		/* No slave requested - arbitrary channel */
> > > +		return true;
> > > +
> > > +	dev_dbg(schan->dev, "%s(): trying %s for 0x%x\n", __func__,
> > > +		info->of_node->full_name, match);
> > > +
> > > +	if (schan->dev->of_node != info->of_node)
> > > +		return false;
> > > +
> > > +	return !sh_dmae_set_slave(schan, match, true);
> > > +}
> > > +
> > > +static struct dma_chan *sh_dmae_of_xlate(struct of_phandle_args
> > > *dma_spec,
> > > +					 struct of_dma *ofdma)
> > > +{
> > > +	struct sh_dmae_filter_info *info = ofdma->of_dma_data;
> > > +	u32 id = dma_spec->args[0];
> > > +	dma_cap_mask_t mask;
> > > +	struct dma_chan *chan;
> > > +
> > > +	if (dma_spec->args_count != 1)
> > > +		return NULL;
> > > +
> > > +	dma_cap_zero(mask);
> > > +	/* Only slave DMA channels can be allocated via DT */
> > > +	dma_cap_set(DMA_SLAVE, mask);
> > > +
> > > +	info->hw_req = id;
> > > +	info->of_node = dma_spec->np;
> > > +
> > > +	chan = dma_request_channel(mask, sh_dmae_chan_filter, info);
> > > +	if (chan)
> > > +		to_shdma_chan(chan)->hw_req = id;
> > > +
> > > +	return chan;
> > > +}
> > 
> > Would https://lkml.org/lkml/2013/3/25/250 help ?
> 
> Don't think so. In my .xlate() method I also assign the .hw_req field,

If I'm not mistaken your hw_req field is equivalent to the chan_id field in 
the above patch.

> and the filter is pretty different.

There's indeed an additional sh_dmae_set_slave() call in your filter, which 
feels a bit out of place. I was just wondering whether it wouldn't be possible 
to consolidate the code with the above patch.

> And in any case that patch is from March... And I don't see it in the
> mainline or in next, are there plans to re-push it?

I don't know, but I will need something similar soon, so I'll revive the 
discussion.

-- 
Regards,

Laurent Pinchart

