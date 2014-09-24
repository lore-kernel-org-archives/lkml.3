Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaIXFGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 01:06:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:24383 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaIXFGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 01:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,586,1406617200"; 
   d="scan'208";a="604445439"
Date: Wed, 24 Sep 2014 10:07:55 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/2] dmaengine: Add QCOM ADM DMA driver
Message-ID: <20140924043755.GQ24663@intel.com>
References: <1410401933-20621-1-git-send-email-agross@codeaurora.org>
 <1410401933-20621-2-git-send-email-agross@codeaurora.org>
 <20140923102850.GI24663@intel.com>
 <20140923221002.GC5975@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923221002.GC5975@qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 05:10:02PM -0500, Andy Gross wrote:
> <snip>
> 
> > > +			break;
> > > +		default:
> > > +			achan->slave.src_maxburst = 0;
> > > +			achan->slave.dst_maxburst = 0;
> > Why clear these for error cases
> 
> With the return I shouldn't need to.  I'll fix this.
> 
> > > +			ret = -EINVAL;
> > > +			break;
> > > +		}
> > > +
> > > +		if (!ret)
> > > +			writel(achan->blk_size,
> > > +				adev->regs + HI_CRCI_CTL(achan->id, adev->ee));
> > and why do we write to HW on this. Shouldn't this be done when you program
> > the descriptor?
> 
> It could be deferred to later.  The main point is that I don't see the
> slave_config happening every transaction.  I was only modifying it now instead
> of making a register write for every transaction.
Well wouldn't it cause a problem if you write to hardware and a transaction
is already in progress.
So it makese sense to write every time at transaction start with latest
value programmed.

> > 
> > > +static enum dma_status adm_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
> > > +	struct dma_tx_state *txstate)
> > > +{
> > > +	struct adm_chan *achan = to_adm_chan(chan);
> > > +	struct virt_dma_desc *vd;
> > > +	enum dma_status ret;
> > > +	unsigned long flags;
> > > +	size_t residue = 0;
> > > +
> > > +	ret = dma_cookie_status(chan, cookie, txstate);
> > > +
> > Last arg can be null to this, so before you do residue calcluation and block
> > interrupts would make sense to return from here if arg is NULL
> 
> Good catch.  Will fix.
> 
> > 
> > > +	spin_lock_irqsave(&achan->vc.lock, flags);
> > > +
> > > +	vd = vchan_find_desc(&achan->vc, cookie);
> > > +	if (vd)
> > > +		residue = container_of(vd, struct adm_async_desc, vd)->length;
> > > +	else if (achan->curr_txd && achan->curr_txd->vd.tx.cookie == cookie)
> > > +		residue = achan->curr_txd->length;
> > so this is current cookie, so you need to read from HW on current position
> 
> There is no way to get current position unfortunately without relying on
> unreliable debug registers.
In that case would it make sense to return complete txn length?

-- 
~Vinod
