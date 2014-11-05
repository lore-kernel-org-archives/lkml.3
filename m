Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbaKEOFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:05:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:62365 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbaKEOFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:05:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,320,1413270000"; 
   d="scan'208";a="602747162"
Date: Wed, 5 Nov 2014 19:34:01 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Jonathan Corbet <corbet@lwn.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ
 safe option
Message-ID: <20141105140401.GO1870@intel.com>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
 <20141031142241.GA17547@amd>
 <1414766416.6537.6.camel@AMDC1943>
 <3452823.YQ5FR2FtKz@avalon>
 <20141103162728.GB1870@intel.com>
 <20141103170408.GD4042@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103170408.GD4042@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 05:04:08PM +0000, Russell King - ARM Linux wrote:
> On Mon, Nov 03, 2014 at 09:57:28PM +0530, Vinod Koul wrote:
> > On Sat, Nov 01, 2014 at 02:29:42AM +0200, Laurent Pinchart wrote:
> > > Many other drivers suffer from the same problem. While I won't reject your 
> > > proposed fix, I would prefer a more generic approach.
> > > 
> > > One option that has been discussed previously was to use a work queue to delay 
> > > starting the DMA transfer to an interruptible context where 
> > > pm_runtime_get_sync() could be called. However, as Russell pointed out [1], 
> > > even that won't work in all cases as the DMA slave might need the transfer to 
> > > be started before enabling part of its hardware (OMAP audio seem to be such a 
> > > case).
> > > 
> > > I've heard a rumor of a possible DMA engine rework to forbid calling the 
> > > descriptor preparation API from atomic context. This could be used as a base 
> > > to implement runtime PM, as DMA slave drivers should not prepare descriptors 
> > > if they don't need to use them. However that's a long term plan, and we need a 
> > > solution sooner than that.
> > 
> > Well it is not a rumour :)
> > 
> > I have been contemplating that now that async_tx will be killed so we dont
> > have to worry about that usage. For the slave dma usage, we can change the
> > prepare API to be non atomic. I think the users will be okay with approach.
> > This way drivers can use runtime pm calls in prepare.
> 
> Except we /do/ have a fair number of places where the prep calls are made
> from atomic contexts, particularly in serial drivers.  You'd need to
> introduce a tasklet into almost every serial driver which doesn't
> already have one to restart RX DMA after an error or pause.  Eg,
> 
> drivers/tty/serial/amba-pl011.c
> drivers/tty/serial/pch_uart.c
> drivers/tty/serial/imx.c
> 
> Probably also:
> 
> drivers/net/ethernet/micrel/ks8842.c
> 
> There could well be other places as well, I've not gone through and
> checked exhaustively.
Yes that would be required to be done first. Or is there any better
alternative proposal, am all ears

-- 
~Vinod
