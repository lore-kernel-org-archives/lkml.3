Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab3FSQ2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:28:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:16980 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871Ab3FSQ2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:28:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,898,1363158000"; 
   d="scan'208";a="356251401"
Date: Wed, 19 Jun 2013 09:28:20 -0700
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dmadevices: dma_sync_wait undefined
Message-ID: <20130619162812.GA20657@jonmason-lab>
References: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
 <1371602813-19828-2-git-send-email-jon.mason@intel.com>
 <CAA9_cmc1Gu=BnM_OpMuqL7Hcjz-kfqxJtZzGHP8Nh-hc+tCWeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmc1Gu=BnM_OpMuqL7Hcjz-kfqxJtZzGHP8Nh-hc+tCWeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 06:13:28PM -0700, Dan Williams wrote:
> On Tue, Jun 18, 2013 at 5:46 PM, Jon Mason <jon.mason@intel.com> wrote:
> > dma_sync_wait is declared regardless of whether CONFIG_DMA_ENGINE is
> > enabled, but calling the function without CONFIG_DMA_ENGINE enabled
> > results in the following gcc error.
> > ERROR: "dma_sync_wait" [drivers/ntb/ntb.ko] undefined!
> >
> > To get around this, declare dma_sync_wait as an inline function if
> > CONFIG_DMA_ENGINE is undefined.
> >
> > Signed-off-by: Jon Mason <jon.mason@intel.com>
> > Acked-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> >  include/linux/dmaengine.h |    6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> > index 96d3e4a..e3652ac 100644
> > --- a/include/linux/dmaengine.h
> > +++ b/include/linux/dmaengine.h
> > @@ -963,8 +963,8 @@ dma_set_tx_state(struct dma_tx_state *st, dma_cookie_t last, dma_cookie_t used,
> >         }
> >  }
> >
> > -enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
> >  #ifdef CONFIG_DMA_ENGINE
> > +enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
> >  enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
> >  void dma_issue_pending_all(void);
> >  struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
> > @@ -972,6 +972,10 @@ struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
> >  struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name);
> >  void dma_release_channel(struct dma_chan *chan);
> >  #else
> > +static inline enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie)
> > +{
> > +       return DMA_SUCCESS;
> > +}
> 
> Seems like something we should fix, but why is this not an indication
> that the code calling this is missing a "depends on DMA_ENGINE".

The driver could use CPU or DMA to move data.  If there are no free
DMA channels or none present, use CPU.  In this way, there is no real
dependency on DMA_ENGINE being enabled.

> On second look dma_sync_wait is a use as last resort hack that
> probably should not escape its internal use in dmaengine.c.  The other
> escape in drivers/media/platform/timblogiw.c already looks problematic
> by having a live cpu spin immediately following a sleeping wait,
> obviously something event based was wanted.  What's the use case in
> NTB?

NTB is currently using it to flush any pending DMAs.  This is needed
to allow the DMA engine and the CPU to perform operations on the same
"Memory Window".  Without this, it is possible for the operations to
complete out of order, which is not a desired outcome for any network
traffic over NTB.  CPU is preferred over DMA engine for small
transfers.  Also, it provides an alternative for errors in the DMA
engine copy process (e.g., DMA mapping, device_prep_dma_memcpy, and
dmaengine_submit).

Thanks,
Jon

> 
> --
> Dan
