Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935099Ab3DOVfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:35:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52457 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab3DOVfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:35:00 -0400
Date: Mon, 15 Apr 2013 23:34:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Arnd Bergmann <arnd@arndb.de>
cc: Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH/RFC 3/6] DMA: shdma: add DT support
In-Reply-To: <201304152318.42913.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.1304152328320.32574@axis700.grange>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
 <1365632389-2249-4-git-send-email-g.liakhovetski@gmx.de> <20130415164238.GG12436@intel.com>
 <201304152318.42913.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:M+uEURBLIpHTCjvTRfzJLNYf0X+SRvdr33Q0yb7GxhF
 h0vL0AQbYsIy1Q9cZAu3e1K1PjHQ0g5pcPinwJQUjizRyjnRQW
 iDqKqaByE/WK/JbEVo/8nIM/iQHLq9RH4iSwCTMIdUWeeLmPj2
 VNRApemmVR+xFBaEe39rK8pC8e3UbLtX/6xcekZijJiqpqXjNr
 SAT2QnjdK45u0myHNswoBiqUQZ6hbOvBb+88sEgx2ZJl1v3WSN
 8VQO/Zflo59pkLFHn3RARW+cnx2N2GDPSNSTf70klmtJDM9/JD
 3ZUHqDTXCS3Kis+Wp0oFcUHtFOmwlbJ0TpiyD07ZsRgrEquImN
 M6dttIceBX5taq9FeRUyKnWNSawnXinRgWFE3S6OpdFnt9XUI6
 E/nlKPrHyX7/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd

Thanks for the review.

On Mon, 15 Apr 2013, Arnd Bergmann wrote:

> On Monday 15 April 2013, Vinod Koul wrote:
> > On Thu, Apr 11, 2013 at 12:19:46AM +0200, Guennadi Liakhovetski wrote:
> > > This patch adds Device Tree support to the shdma driver. No special DT
> > > properties are used, only standard DMA DT bindings are implemented. Since
> > > shdma controllers reside on SoCs, their configuration is SoC-specific and
> > > shall be passed to the driver from the SoC platform data, using the
> > > auxdata procedure.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > > ---
> > Need Arnd to review :)
> 
> This patch is missing the DT binding document, which is necessary for a proper
> review, and as a documentation for anyone trying to write device tree source
> files.

The documentation was left off consciously, because this driver isn't 
using any non-standard DMA DT bindings, only those, already described in 
Documentation/devicetree/bindings/dma/dma.txt.

> In particular, it is not clear what mid/rid refer to here and whether they should
> be represented as one or two cells. The driver here uses one cell, which is probably
> ok, but I'd like to understand that anyway.

Yes, mid/rid is a kind of a DMA request line number on these controllers, 
IIUC. It does have some internal hardware meaning, so, it's not a plane 
index, but for a high-level view it's just an 8-bit DMA request ID.

> > > + * NOTE 2: This filter function is also used in the DT case by shdma_xlate().
> > > + * In that case the MID-RID value is used for slave channel filtering and is
> > > + * passed to this function in the "arg" parameter.
> > >   */
> > >  bool shdma_chan_filter(struct dma_chan *chan, void *arg)
> > >  {
> > >  	struct shdma_chan *schan = to_shdma_chan(chan);
> > >  	struct shdma_dev *sdev = to_shdma_dev(schan->dma_chan.device);
> > >  	const struct shdma_ops *ops = sdev->ops;
> > > -	int slave_id = (int)arg;
> > > +	int match = (int)arg;
> > >  	int ret;
> > >  
> > > -	if (slave_id < 0)
> > > +	if (match < 0)
> > >  		/* No slave requested - arbitrary channel */
> > >  		return true;
> > >  
> > > -	if (slave_id >= slave_num)
> > > +	if (!schan->dev->of_node && match >= slave_num)
> > >  		return false;
> > >  
> > > -	ret = ops->set_slave(schan, slave_id, true);
> > > +	ret = ops->set_slave(schan, match, true);
> > >  	if (ret < 0)
> > >  		return false;
> 
> The filter function should really ensure that the dma_chan.device matches
> the device passed as the argument before accessing any members of
> the outer structures. This seems to be a preexisting bug.

Also this I wouldn't necessarily call a bug, but a pre-existing and known 
limitation :) So far no platform, using such DMA controllers, has DMA 
controllers, driven by different dmaengine drivers, so, no confusion is 
possible, since those request line IDs are unique across SoCs. If in the 
future need arises, this limitation can certainly be lifted.

> > > +struct dma_chan *shdma_xlate(struct of_phandle_args *dma_spec,
> > > +				 struct of_dma *ofdma)
> > > +{
> > > +	struct shdma_dev *sdev = ofdma->of_dma_data;
> > > +	u32 id = dma_spec->args[0];
> > > +	dma_cap_mask_t mask;
> > > +	struct dma_chan *chan;
> > > +
> > > +	if (dma_spec->args_count != 1 || !sdev)
> > > +		return NULL;
> > > +
> > > +	dma_cap_zero(mask);
> > > +	/* Only slave DMA channels can be allocated via DT */
> > > +	dma_cap_set(DMA_SLAVE, mask);
> > > +
> > > +	chan = dma_request_channel(mask, shdma_chan_filter, (void *)id);
> > > +	if (chan)
> > > +		to_shdma_chan(chan)->hw_req = id;
> > > +
> > > +	return chan;
> > > +}
> > > +EXPORT_SYMBOL(shdma_xlate);
> 
> And consequently, this function should pass the sdev into the filter function
> along with the id.
> 
> With a binding document added, the patch seems ok. The check for the device should
> probably be added to the filter function in any case.
> 
> 	Arnd

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
