Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaCCGtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 01:49:19 -0500
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:39508 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751031AbaCCGtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 01:49:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2898:2901:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:6117:6119:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: twig81_339f09bc83b56
X-Filterd-Recvd-Size: 3107
Message-ID: <1393829352.13719.73.camel@joe-AO722>
Subject: Re: [Patch v8 2/2] dmaengine: add Qualcomm BAM dma driver
From: Joe Perches <joe@perches.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Date: Sun, 02 Mar 2014 22:49:12 -0800
In-Reply-To: <1393828245-18766-3-git-send-email-agross@codeaurora.org>
References: <1393828245-18766-1-git-send-email-agross@codeaurora.org>
	 <1393828245-18766-3-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-03 at 00:30 -0600, Andy Gross wrote:
> Add the DMA engine driver for the QCOM Bus Access Manager (BAM) DMA controller
> found in the MSM 8x74 platforms.
> 
> Each BAM DMA device is associated with a specific on-chip peripheral.  Each
> channel provides a uni-directional data transfer engine that is capable of
> transferring data between the peripheral and system memory (System mode), or
> between two peripherals (BAM2BAM).
[]

trivia:

> +static u32 process_channel_irqs(struct bam_device *bdev)
> +{
[]
> +	for (i = 0; i < bdev->num_channels; i++) {
> +		struct bam_chan *bchan = &bdev->channels[i];
> +		if (srcs & BIT(i)) {
> +			/* clear pipe irq */
> +			pipe_stts = readl_relaxed(bdev->regs +
> +				BAM_P_IRQ_STTS(i));
> +
> +			writel_relaxed(pipe_stts, bdev->regs +
> +					BAM_P_IRQ_CLR(i));
> +
> +			spin_lock_irqsave(&bchan->vc.lock, flags);
> +			async_desc = bchan->curr_txd;
> +
> +			if (async_desc) {
> +				async_desc->num_desc -= async_desc->xfer_len;
> +				async_desc->curr_desc += async_desc->xfer_len;
> +				bchan->curr_txd = NULL;
> +
> +				/* manage FIFO */
> +				bchan->head += async_desc->xfer_len;
> +				bchan->head %= MAX_DESCRIPTORS;
> +
> +				/*
> +				 * if complete, process cookie.  Otherwise
> +				 * push back to front of desc_issued so that
> +				 * it gets restarted by the tasklet
> +				 */
> +				if (!async_desc->num_desc)
> +					vchan_cookie_complete(&async_desc->vd);
> +				else
> +					list_add(&async_desc->vd.node,
> +						&bchan->vc.desc_issued);
> +			}
> +
> +			spin_unlock_irqrestore(&bchan->vc.lock, flags);
> +		}
> +	}

This could be written with fewer indents using continue
(and maybe faster using ffs too)

	for (i = 0; i < bdev->num_channels; i++) {
		struct bam_chan *bchan;

		if (!(srcs & BIT(i)))
			continue;

		bchan = &bdev->channels[i];

		/* clear pipe irq */
		pipe_stts = readl_relaxed(bdev->regs + BAM_P_IRQ_STTS(i));
		writel_relaxed(pipe_stts, bdev->regs + BAM_P_IRQ_CLR(i));

		etc...


