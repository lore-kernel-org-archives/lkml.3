Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963Ab3FSBNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:13:33 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:61223 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSBNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:13:30 -0400
MIME-Version: 1.0
In-Reply-To: <1371602813-19828-2-git-send-email-jon.mason@intel.com>
References: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
	<1371602813-19828-2-git-send-email-jon.mason@intel.com>
Date: Tue, 18 Jun 2013 18:13:28 -0700
X-Google-Sender-Auth: UHIka6k-0tWgfGlwnzEev_NlIFo
Message-ID: <CAA9_cmc1Gu=BnM_OpMuqL7Hcjz-kfqxJtZzGHP8Nh-hc+tCWeA@mail.gmail.com>
Subject: Re: [PATCH 1/2] dmadevices: dma_sync_wait undefined
From: Dan Williams <djbw@fb.com>
To: Jon Mason <jon.mason@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 5:46 PM, Jon Mason <jon.mason@intel.com> wrote:
> dma_sync_wait is declared regardless of whether CONFIG_DMA_ENGINE is
> enabled, but calling the function without CONFIG_DMA_ENGINE enabled
> results in the following gcc error.
> ERROR: "dma_sync_wait" [drivers/ntb/ntb.ko] undefined!
>
> To get around this, declare dma_sync_wait as an inline function if
> CONFIG_DMA_ENGINE is undefined.
>
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> Acked-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  include/linux/dmaengine.h |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 96d3e4a..e3652ac 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -963,8 +963,8 @@ dma_set_tx_state(struct dma_tx_state *st, dma_cookie_t last, dma_cookie_t used,
>         }
>  }
>
> -enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
>  #ifdef CONFIG_DMA_ENGINE
> +enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
>  enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
>  void dma_issue_pending_all(void);
>  struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
> @@ -972,6 +972,10 @@ struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
>  struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name);
>  void dma_release_channel(struct dma_chan *chan);
>  #else
> +static inline enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie)
> +{
> +       return DMA_SUCCESS;
> +}

Seems like something we should fix, but why is this not an indication
that the code calling this is missing a "depends on DMA_ENGINE".

On second look dma_sync_wait is a use as last resort hack that
probably should not escape its internal use in dmaengine.c.  The other
escape in drivers/media/platform/timblogiw.c already looks problematic
by having a live cpu spin immediately following a sleeping wait,
obviously something event based was wanted.  What's the use case in
NTB?

--
Dan
