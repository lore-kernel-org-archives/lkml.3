Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaB1NdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:33:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:43325 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbaB1NdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:33:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,561,1389772800"; 
   d="scan'208";a="491554173"
Message-ID: <1393594391.28803.79.camel@smile.fi.intel.com>
Subject: Re: [PATCH 4/5] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com
Date: Fri, 28 Feb 2014 15:33:11 +0200
In-Reply-To: <20140228103614.GM607@lukather>
References: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com>
	 <1393258967-4843-5-git-send-email-maxime.ripard@free-electrons.com>
	 <1393327695.28803.25.camel@smile.fi.intel.com>
	 <20140228103614.GM607@lukather>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 11:36 +0100, Maxime Ripard wrote:
> Hi Andy,
> 
> On Tue, Feb 25, 2014 at 01:28:15PM +0200, Andy Shevchenko wrote:
> > > +static irqreturn_t sun6i_dma_interrupt(int irq, void *dev_id)
> > > +{
> > > +	struct sun6i_dma_dev *sdev = (struct sun6i_dma_dev *)dev_id;
> > > +	struct sun6i_vchan *vchan;
> > > +	struct sun6i_pchan *pchan;
> > > +	int i, j, ret = 0;
> > > +	u32 status;
> > > +
> > > +	for (i = 0; i < 2; i++) {
> > > +		status = readl(sdev->base + DMA_IRQ_STAT(i));
> > > +		if (!status) {
> > > +			ret |= IRQ_NONE;
> > 
> > Maybe move this to definition block.
> > 
> > > +			continue;
> > > +		}
> > > +
> > > +		dev_dbg(sdev->slave.dev, "DMA irq status %s: 0x%x\n",
> > > +			i ? "high" : "low", status);
> > > +
> > > +		writel(status, sdev->base + DMA_IRQ_STAT(i));
> > > +
> > > +		for (j = 0; (j < 8) && status; j++) {
> > > +			if (status & DMA_IRQ_QUEUE) {
> > > +				pchan = sdev->pchans + j;
> > > +				vchan = pchan->vchan;
> > > +
> > > +				if (vchan) {
> > > +					unsigned long flags;
> > > +
> > > +					spin_lock_irqsave(&vchan->vc.lock,
> > > +							  flags);
> > > +					vchan_cookie_complete(&pchan->desc->vd);
> > > +					pchan->done = pchan->desc;
> > > +					spin_unlock_irqrestore(&vchan->vc.lock,
> > > +							       flags);
> > > +				}
> > > +			}
> > > +
> > > +			status = status >> 4;
> > > +		}
> > > +
> > > +		ret |= IRQ_HANDLED;
> > 
> > In case one is handled, another is not, what you have to do?
> 
> The interrupt status is split across two registers. In the case where
> one of the two register reports an interrupt, we still have to handle
> our interrupt, we actually did, so we have to return IRQ_HANDLED.

You removed the code below this assignment, but if I remember correctly
you check for exact value there.

In case of one is not handled and the other is handled you will have ret
= IRQ_HANDLED | IRQ_NONE. Thus, your following code will not be
executed. Is it by design?



-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

