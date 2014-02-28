Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaB1XOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:14:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:52066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaB1XO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:14:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: dmaengine@vger.kernel.org, vinod.koul@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Sandeep Nair <sandeep_n@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] dma: Add Keystone Packet DMA Engine driver
Date: Sat, 01 Mar 2014 00:14:01 +0100
Message-ID: <21183060.JRdahJE8pQ@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1393628200-12317-1-git-send-email-santosh.shilimkar@ti.com>
References: <1393628200-12317-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:HzvjTmI3VB48PX8FIEj2ttiJ85tMsXa4Exk5bC7jAap
 kjBYpIuz4uo7zg2+/hL9HHRoRO4HiO9DYcQT6tCMAn/399wsFW
 5pTsCfBahXI/KbPACkICZFwmtv/cDFSYn9SUEQCjDTuq/VXfmi
 MQGMzjrorsi/FJh+f0RgTT0zfx1guq2XROOmOBXLItqdZafYnX
 aFtOp3LyX4ZExplfAMKqr4Bl2qZc3IXrhJ1w4SNWm4xzbYH9DP
 WTP5mSJ2SWpSBCtPTHCiRjWEh5emXC8qt2823lVPK6KM/+Mryi
 U3pekkKrAJKqrGY2ezGN83eaQiopqcOVf2ikiEIgLhfO65NG29
 4HMG96/2oUIr3HWZWypc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 February 2014 17:56:40 Santosh Shilimkar wrote:
> The Packet DMA driver sets up the dma channels and flows for the
> QMSS(Queue Manager SubSystem) who triggers the actual data movements
> across clients using destination queues. Every client modules like
> NETCP(Network Coprocessor), SRIO(Serial Rapid IO) and CRYPTO
> Engines has its own instance of packet dma hardware. QMSS has also
> an internal packet DMA module which is used as an infrastructure
> DMA with zero copy.
> 
> Patch adds DMAEngine driver for Keystone Packet DMA hardware.
> The specifics on the device tree bindings for Packet DMA can be
> found in:
>         Documentation/devicetree/bindings/dma/keystone-pktdma.txt
> 
> The driver implements the configuration functions using standard DMAEngine
> apis. The data movement is managed by QMSS device driver.

The description of this sounds a bit like the x-gene queue manager/tag
manager, rather than a traditional DMA engine. For that driver, we
decided to use the mailbox subsystem instead of the DMA subsystem.

Can you explain what kind of data is actually getting transferred
in by your hardware here? You say the DMA is performed by the QMSS,
so do you use the pktdma driver to drive the data transfers of the
QMSS or do you just use it for flow control by passing short (a few
bytes) messages and also have to program the pktdma?

> +
> +bool dma_keystone_filter_fn(struct dma_chan *chan, void *param)
> +{
> +       if (chan->device->dev->driver == &keystone_dma_driver.driver) {
> +               struct keystone_dma_chan *kdma_chan = from_achan(chan);
> +               unsigned chan_id = *(u32 *)param & KEYSTONE_DMA_CHAN_ID_MASK;
> +               unsigned chan_type = *(u32 *)param >> KEYSTONE_DMA_TYPE_SHIFT;
> +
> +               if (chan_type == KEYSTONE_DMA_TX_CHAN_TYPE &&
> +                   kdma_chan->direction == DMA_MEM_TO_DEV)
> +                       return chan_id  == kdma_chan->channel;
> +
> +               if (chan_type == KEYSTONE_DMA_RX_FLOW_TYPE &&
> +                   kdma_chan->direction == DMA_DEV_TO_MEM)
> +                       return chan_id  == kdma_chan->flow;
> +       }
> +       return false;
> +}
> +EXPORT_SYMBOL_GPL(dma_keystone_filter_fn);

The filter function should be removed here and replaced with a simpler
custom xlate function calling dma_get_slave_chan() on the matching
channel.

> diff --git a/include/linux/keystone-pktdma.h b/include/linux/keystone-pktdma.h
> new file mode 100644
> index 0000000..e6a66c8
> --- /dev/null
> +++ b/include/linux/keystone-pktdma.h
> @@ -0,0 +1,168 @@

A DMA engine driver should not have a public API. Please move all the
contents of the two header files into the driver itself to ensure none
of this is visible to slave drivers. If it turns out that you use
declarations from this header in slave drivers at the moment, please
explain what they are so we can discuss alternative solutions.

	Arnd
