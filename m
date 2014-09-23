Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbaIWK5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:57:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:16491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbaIWK46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:56:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,579,1406617200"; 
   d="scan'208";a="595512234"
Date: Tue, 23 Sep 2014 15:58:50 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/2] dmaengine: Add QCOM ADM DMA driver
Message-ID: <20140923102850.GI24663@intel.com>
References: <1410401933-20621-1-git-send-email-agross@codeaurora.org>
 <1410401933-20621-2-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410401933-20621-2-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:18:52PM -0500, Andy Gross wrote:

> +static int adm_slave_config(struct adm_chan *achan,
> +		struct dma_slave_config *cfg)
> +{
> +	int ret = 0;
> +	u32 burst;
> +	struct adm_device *adev = achan->adev;
> +
> +	memcpy(&achan->slave, cfg, sizeof(*cfg));
> +
> +	/* set channel CRCI burst, if applicable */
> +	if (achan->crci) {
> +		burst = max_t(u32, cfg->src_maxburst, cfg->dst_maxburst);
> +
> +		switch (burst) {
> +		case 16:
> +			achan->blk_size = 0;
> +			break;
> +		case 32:
> +			achan->blk_size = 1;
> +			break;
> +		case 64:
> +			achan->blk_size = 2;
> +			break;
> +		case 128:
> +			achan->blk_size = 3;
> +			break;
> +		case 192:
> +			achan->blk_size = 4;
> +			break;
> +		case 256:
> +			achan->blk_size = 5;
> +			break;
> +		default:
> +			achan->slave.src_maxburst = 0;
> +			achan->slave.dst_maxburst = 0;
Why clear these for error cases
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		if (!ret)
> +			writel(achan->blk_size,
> +				adev->regs + HI_CRCI_CTL(achan->id, adev->ee));
and why do we write to HW on this. Shouldn't this be done when you program
the descriptor?

> +static enum dma_status adm_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
> +	struct dma_tx_state *txstate)
> +{
> +	struct adm_chan *achan = to_adm_chan(chan);
> +	struct virt_dma_desc *vd;
> +	enum dma_status ret;
> +	unsigned long flags;
> +	size_t residue = 0;
> +
> +	ret = dma_cookie_status(chan, cookie, txstate);
> +
Last arg can be null to this, so before you do residue calcluation and block
interrupts would make sense to return from here if arg is NULL

> +	spin_lock_irqsave(&achan->vc.lock, flags);
> +
> +	vd = vchan_find_desc(&achan->vc, cookie);
> +	if (vd)
> +		residue = container_of(vd, struct adm_async_desc, vd)->length;
> +	else if (achan->curr_txd && achan->curr_txd->vd.tx.cookie == cookie)
> +		residue = achan->curr_txd->length;
so this is current cookie, so you need to read from HW on current position
> +
> +	spin_unlock_irqrestore(&achan->vc.lock, flags);
> +
> +	dma_set_residue(txstate, residue);
> +
> +	if (achan->error)
> +		return DMA_ERROR;
> +
> +	return ret;

-- 
~Vinod

