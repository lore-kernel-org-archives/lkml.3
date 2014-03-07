Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaCGW36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:29:58 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:32978 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbaCGW34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:29:56 -0500
Message-ID: <531A485D.9010508@mm-sol.com>
Date: Sat, 08 Mar 2014 00:29:49 +0200
From: Stanimir Vabanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [Patch v8 2/2] dmaengine: add Qualcomm BAM dma driver
References: <1393828245-18766-1-git-send-email-agross@codeaurora.org> <1393828245-18766-3-git-send-email-agross@codeaurora.org>
In-Reply-To: <1393828245-18766-3-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Thanks for the patch.

<snip>

> +#define BAM_IRQ_SRCS_EE(pipe)		(0x0800 + ((pipe) * 0x80))
> +#define BAM_IRQ_SRCS_MSK_EE(pipe)	(0x0804 + ((pipe) * 0x80))

s/pipe/ee ?

<snip>

> +struct bam_chan {
> +	struct virt_dma_chan vc;
> +
> +	struct bam_device *bdev;
> +
> +	/* configuration from device tree */
> +	u32 id;
> +	u32 ee;
> +

do we need per channel ee? I'm asking because failed to find references
to it.

> +	struct bam_async_desc *curr_txd;	/* current running dma */
> +
> +	/* runtime configuration */
> +	struct dma_slave_config slave;
> +
> +	/* fifo storage */
> +	struct bam_desc_hw *fifo_virt;
> +	dma_addr_t fifo_phys;
> +
> +	/* fifo markers */
> +	unsigned short head;		/* start of active descriptor entries */
> +	unsigned short tail;		/* end of active descriptor entries */
> +
> +	unsigned int initialized;	/* is the channel hw initialized? */
> +	unsigned int paused;		/* is the channel paused? */
> +	unsigned int reconfigure;	/* new slave config? */
> +
> +	struct list_head node;
> +};
> +

<snip>

> +
> +/**
> + * bam_alloc_chan - Allocate channel resources for DMA channel.
> + * @chan: specified channel
> + *
> + * This function allocates the FIFO descriptor memory
> + */
> +static int bam_alloc_chan(struct dma_chan *chan)
> +{
> +	struct bam_chan *bchan = to_bam_chan(chan);
> +	struct bam_device *bdev = bchan->bdev;
> +

you could invert the logic and avoid extra indentation.
	if (bchan->fifo_virt)
		return 0;

> +	/* allocate FIFO descriptor space, but only if necessary */
> +	if (!bchan->fifo_virt) {
> +		bchan->fifo_virt = dma_alloc_writecombine(bdev->dev,
> +					BAM_DESC_FIFO_SIZE, &bchan->fifo_phys,
> +					GFP_KERNEL);
> +
> +		if (!bchan->fifo_virt) {
> +			dev_err(bdev->dev, "Failed to allocate desc fifo\n");
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	return 0;
> +}
> +

<snip>

regards,
Stan
