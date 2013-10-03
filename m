Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3JCP7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:59:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:13242 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218Ab3JCP6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:58:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1026,1371106800"; 
   d="scan'208";a="302734738"
Date: Thu, 3 Oct 2013 20:36:42 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michael Grzeschik <mgr@pengutronix.de>
Cc: Christoph Fritz <chf.fritz@googlemail.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [[PATCH] 0/3] imx-dma: fixes
Message-ID: <20131003150642.GD16684@intel.com>
References: <1379426168-31989-1-git-send-email-m.grzeschik@pengutronix.de>
 <20130923041953.GA17188@intel.com>
 <1380004503.6145.16.camel@mars>
 <20130928235603.GB25376@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928235603.GB25376@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 01:56:03AM +0200, Michael Grzeschik wrote:
> Hi Christoph,
> 
> On Tue, Sep 24, 2013 at 08:35:03AM +0200, Christoph Fritz wrote:
> > On Mon, 2013-09-23 at 09:49 +0530, Vinod Koul wrote:
> > > On Tue, Sep 17, 2013 at 03:56:05PM +0200, Michael Grzeschik wrote:
> > > > Hello,
> > > > 
> > > > this series is solving some lockdep issues in the imx-dma code.
> > > > There are some list_head and deadlock issues in the code,
> > > > that is running the implementation into unsafe situations.
> > > Thanks for this, I have trying to fix this with testing done by Christoph. I had
> > > similar set of fixes
> > > 
> > > Christoph can you pls try runnning this on your setup and check and we can apply
> > > these
> > 
> > Thanks for the update, I added Michaels imx-dma patchset to Kernel
> > 3.4.62 and gave it a shot:
> > 
> > In contrast to DMA-disabled, a 'dd' copy still results in a hung:
> > 
> >    dd if=/dev/zero of=/mnt/dd-test.bin count=102400 bs=1K
> > 
> > Please see the full log from boot to hung with DEBUG enabled below.
> > With 2.6.31, copying to an SD-Card with DMA enabled works flawlessly,
> > this log is also below.
> > 
> > Michael, any ideas? I suppose you have the same board?
> 
> The hardware we tested these patches for/with was custom hardware. But
> yes, we have this board you refer. We will need to setup the same
> situation first for debugging.
> 
> Did you realize that the stalling mem2dev transfer in 3.4.62
> is generating this footprint:
> 
> > [   60.579646] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=8 total length=32768 dev_addr=0x10014038 (mem2dev)
> > [   60.591192] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0x10014038, src 0xa5527000, size 0x00001000
> > [   60.600624] imx-dma imx-dma: imxdma_enable_hw channel 0
> > [   60.605887] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0x10014038, src 0xa5525000, size 0x00001000
> > [   60.795424] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
> > [   60.801857] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0x10014038, src 0xa5523000, size 0x00001000
> > [   61.290221] imx-dma imx-dma: channel 0: watchdog timeout!
> 
> Beside on 2.6.31 the same transfer results in no failure.
> 
> > [   55.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
> > [   55.280000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a1c00, size 0x00001000
> > [   55.290000] imxdma0: imx_dma_enable
> > [   55.290000] imxdma: dma_irq_handler called, disr=0x00000001
> > [   55.290000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a2c00, size 0x00000400
> > [   55.300000] imxdma: dma_irq_handler called, disr=0x00000001
> > [   55.300000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a5000, size 0x00001000
> > [   55.320000] imxdma: dma_irq_handler called, disr=0x00000001
> > [   55.320000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a7000, size 0x00001000
> > [   55.330000] imxdma: dma_irq_handler called, disr=0x00000001
> > [   55.330000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a9000, size 0x00001000
> > [   55.340000] imxdma: dma_irq_handler called, disr=0x00000001
> > [   55.340000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ab000, size 0x00001000
> > [   55.360000] imxdma: dma_irq_handler called, disr=0x00000001
> > [   55.360000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ad000, size 0x00001000
> > [   55.380000] imxdma: dma_irq_handler called, disr=0x00000001
> > [   55.380000] imxdma0: next sg chunk dst 0x10014038, src 0xa73af000, size 0x00001000
> > [   55.390000] imxdma: dma_irq_handler called, disr=0x00000001
> > [   55.390000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b1000, size 0x00000c00
> > [   55.400000] imxdma: dma_irq_handler called, disr=0x00000001
> > [   55.410000] imxdma0: imx_dma_disable
> 
> It looks suspicious that the same same transfer in the newer kernel should take
> less amount of sg (sgcount=8 vs. sgcount=9) with the same amount of payload data.
> 
> I don't think this issue is related to the patch series I posted. But
> anyway needs to be investigated.
Yes Looks like we had same result with my patches too. So I will try applying
these and we can fix these along. I would like some working driver rather than
broken one :)

~Vinod
-- 
