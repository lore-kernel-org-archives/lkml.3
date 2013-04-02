Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761854Ab3DBTCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:02:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51007 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759150Ab3DBTCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:02:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 1/2] dmaengine: mpc512x_dma: use generic DMA DT bindings
Date: Tue, 2 Apr 2013 19:01:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Anatolij Gustschin <agust@denx.de>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
References: <1364746680-6564-1-git-send-email-agust@denx.de> <20130402182215.GO10326@intel.com>
In-Reply-To: <20130402182215.GO10326@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304021901.51705.arnd@arndb.de>
X-Provags-ID: V02:K0:w5xzA+9wde/Urw8lp2c3DwWNjVtdmdFgASkf3FeRzHn
 2v8EYbpuuB5ny/37DblxKm/4jegpAu3dltMOVTByO+8C39XW4I
 O5OfdYjs2rob7c+PwWq0P+vWkdM9GKYPCFlHyoJ0fNCX9v99FO
 O+H6TVKO/9n2nNQOqytA/16+blFXC4lTnsOezj5zeih7uUDa2W
 ba9lMcKsUPv9ZRdtDUqyEZnXrMOhMMOyswdWhM4ydWrRA8+aQ1
 c3cna+ZsnOMVq3aTG4DC/p9Y/mWy3mjuHvi5DJkJd54fGD5c03
 woN14EWR1m08o8LuEL9VLW8i7kWyIHSFAJRty7NOK10iXWvxDx
 5ogvbkb6uDvFfRufFmGI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 April 2013, Vinod Koul wrote:
> On Sun, Mar 31, 2013 at 06:17:59PM +0200, Anatolij Gustschin wrote:
> > Add generic DMA bindings and register the DMA controller
> > to DT DMA helpers.
> I need someone who understands DT better than me to comment/ack...
> Arnd...?

> >  
> > +struct mpc_dma_filter_args {
> > +	struct mpc_dma *mdma;
> > +	unsigned int chan_id;
> > +};
> > +
> > +static bool mpc_dma_filter(struct dma_chan *chan, void *param)
> > +{
> > +	struct mpc_dma_filter_args *fargs = param;
> > +
> > +	if (chan->device != &fargs->mdma->dma)
> > +		return false;
> > +
> > +	return (chan->chan_id == fargs->chan_id);
> > +}

This assumes that there is a 1:1 mapping between channels and request lines,
which is unusual, but I assume it's correct for the hardware.

> > @@ -791,11 +830,26 @@ static int mpc_dma_probe(struct platform_device *op)
> >  	/* Register DMA engine */
> >  	dev_set_drvdata(dev, mdma);
> >  	retval = dma_async_device_register(dma);
> > -	if (retval) {
> > -		devm_free_irq(dev, mdma->irq, mdma);
> > -		irq_dispose_mapping(mdma->irq);
> > +	if (retval)
> > +		goto reg_err;
> > +
> > +	if (dev->of_node) {
> > +		retval = of_dma_controller_register(dev->of_node,
> > +						    mpc_dma_xlate, mdma);
> > +		if (retval) {
> > +			dev_err(&op->dev,
> > +				"could not register of_dma_controller\n");
> > +			goto of_err;
> > +		}
> >  	}

Here we rely on the fact that all device trees including this dma engine
have a correct representation of the device, which breaks backwards
compatibility with old device trees, which don't yet follow the binding
or don't need to because they only use memory-to-memory channels.

You can easily make it backwards compatible by making the above a
non-fatal error and just continuing here even if of_dma_controller_register
failed. If compatiblity is not a concern, the above is good.

The main thing missing is a binding file in
Documentation/devicetree/bindings/dma/mpc512x-dma.txt

	Arnd
