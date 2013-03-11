Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3CKRJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:09:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60734 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3CKRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:09:20 -0400
Date: Mon, 11 Mar 2013 17:09:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: A proposal to check the device in generic way
Message-ID: <20130311170902.GN4977@n2100.arm.linux.org.uk>
References: <1363001537.18714.3.camel@smile> <Pine.LNX.4.64.1303111302340.21241@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1303111302340.21241@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 01:26:01PM +0100, Guennadi Liakhovetski wrote:
> Hi Andriy
> 
> (adding Russell to CC)
> 
> On Mon, 11 Mar 2013, Shevchenko, Andriy wrote:
> 
> > Hello.
> > 
> > Currently in linux-next we have the following things:
> > 
> > $ git grep -n 'chan->device->dev->driver' drivers/dma/
> > 
> > drivers/dma/amba-pl08x.c:1594:  if (chan->device->dev->driver !=
> > &pl08x_amba_driver.drv)
> > drivers/dma/dmaengine.c:190:    return chan->device->dev->driver->owner;
> > drivers/dma/edma.c:609: if (chan->device->dev->driver ==
> > &edma_driver.driver) {
> > drivers/dma/omap-dma.c:654:     if (chan->device->dev->driver ==
> > &omap_dma_driver.driver) {
> > drivers/dma/pl330.c:2374:       if (chan->device->dev->driver !=
> > &pl330_driver.drv)
> > drivers/dma/sa11x0-dma.c:1080:  if (chan->device->dev->driver ==
> > &sa11x0_dma_driver.driver) 
> > 
> > I think it's a non-generic way to check which driver provides a channel
> > into filter function. First of all, I don't get why that comparison goes
> > as deep as driver structure. Isn't clearer to check chan->device->dev
> > against the struct dev passed in the custom parameter structure? Like:
> > 
> > struct filter_params {
> >  struct dev *dev;
> >  void *param;
> > };
> 
> I don't think you always know which DMA device you want to use with this 
> DMA client - sometimes there are several DMA engine devices, that can be 
> used with your DMA client, or even if it's only one, you don't necessarily 
> have a pointer to it in your DMA client.

Correct - take a look at what gets passed - for example, sometimes the
filter parameter is just a string.  Sometimes, even in the static
platform code, we may not have an address for the DMA device structure.

So, how would you supply the struct device for the DMA?  You can't.

But, think about it a moment.  What we're actually really interested in
is: do we know the structure of the driver's channel specific data?
What determines that?  The device?  Or the driver?  It's the driver.

So for safe and correct type checking, we need to make sure that the
dma_chan is really associated with _this_ driver before we dereference
anything in the driver-private data structures surrounding dma_chan.

Hence, the struct device_driver is the right thing to use.  I would
however agree that it would be nice if the device model provided us a
way to do that without having to delve that deeply ourselves.
