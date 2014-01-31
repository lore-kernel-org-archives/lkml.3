Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbaAaRo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:44:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46357 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaAaRoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:44:54 -0500
Date: Fri, 31 Jan 2014 11:44:51 -0600
From: Andy Gross <agross@codeaurora.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Srikanth Thokala <sthokal@xilinx.com>, dan.j.williams@intel.com,
        vinod.koul@intel.com, michal.simek@xilinx.com,
        Grant Likely <grant.likely@linaro.org>, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
Message-ID: <20140131174451.GA20512@qualcomm.com>
References: <1390409565-4200-1-git-send-email-sthokal@xilinx.com>
 <1390409565-4200-2-git-send-email-sthokal@xilinx.com>
 <52E0FC22.8060903@metafoo.de>
 <CA+mB=1L6yvCwA3mKCwz83LQbXiVau110REV64rYrSzUhGE4ucA@mail.gmail.com>
 <52E2698B.6070001@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E2698B.6070001@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 02:24:27PM +0100, Lars-Peter Clausen wrote:
> On 01/24/2014 12:16 PM, Srikanth Thokala wrote:
> > Hi Lars,
> > 
> > On Thu, Jan 23, 2014 at 4:55 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> >> On 01/22/2014 05:52 PM, Srikanth Thokala wrote:
> >> [...]
> >>> +/**
> >>> + * xilinx_vdma_device_control - Configure DMA channel of the device
> >>> + * @dchan: DMA Channel pointer
> >>> + * @cmd: DMA control command
> >>> + * @arg: Channel configuration
> >>> + *
> >>> + * Return: '0' on success and failure value on error
> >>> + */
> >>> +static int xilinx_vdma_device_control(struct dma_chan *dchan,
> >>> +                                   enum dma_ctrl_cmd cmd, unsigned long arg)
> >>> +{
> >>> +     struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> >>> +
> >>> +     switch (cmd) {
> >>> +     case DMA_TERMINATE_ALL:
> >>> +             xilinx_vdma_terminate_all(chan);
> >>> +             return 0;
> >>> +     case DMA_SLAVE_CONFIG:
> >>> +             return xilinx_vdma_slave_config(chan,
> >>> +                                     (struct xilinx_vdma_config *)arg);
> >>
> >> You really shouldn't be overloading the generic API with your own semantics.
> >> DMA_SLAVE_CONFIG should take a dma_slave_config and nothing else.
> > 
> > Ok.  The driver needs few additional configuration from the slave
> > device like Vertical
> > Size, Horizontal Size,  Stride etc., for the DMA transfers, in that case do you
> > suggest me to define a separate dma_ctrl_cmd like the one FSLDMA_EXTERNAL_START
> > defined for Freescale drivers?
> 
> In my opinion it is not a good idea to have driver implement a generic API,
> but at the same time let the driver have custom semantics for those API
> calls. It's a bit like having a gpio driver that expects 23 and 42 as the
> values passed to gpio_set_value instead of 0 and 1. It completely defeats
> the purpose of a generic API, namely that you are able to write generic code
> that makes use of the API without having to know about which implementation
> API it is talking to. The dmaengine framework provides the
> dmaengine_prep_interleaved_dma() function to setup two dimensional
> transfers, e.g. take a look at sirf-dma.c or imx-dma.c.
> 

The comments in the include/linux/dmaengine.h state that if you have
non-generic, non-fixed configuration then you can just create your own
structure and embed the dma_slave_config.  Using the container_of you can get
back your structure.

I agree that we should always use the generic structure if possible, but
sometimes there are some non-standard things that you have to do for your
hardware.  I am currently in a bind for adding some quirky features that are
required by peripherals who want to use the QCOM DMA devices.

If the context field in prep_slave_sg and prep_dma_cyclic was exposed to
everyone, that would allow an easy way to pass in hardware specific
configuration without bastardizing the slave_config.  I noticed that rapidio is
the only consumer of that field and that they have their own prep function.

If we are not going to allow people to do their own slave_config when they need
to, then we need to remove the comments from the include file and expose the
context to the dmaengine_prep_slave_sg and dmaengine_prep_dma_cyclic.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
