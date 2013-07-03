Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3GCMOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:14:12 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:64846 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab3GCMOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:14:11 -0400
MIME-Version: 1.0
In-Reply-To: <1371544880-26782-1-git-send-email-wangxfdu@gmail.com>
References: <1371544880-26782-1-git-send-email-wangxfdu@gmail.com>
Date: Wed, 3 Jul 2013 20:14:10 +0800
Message-ID: <CACDNBm3P3XQON9Bpd_aie51Q4g27zRsWcaC_AoXJS0LK6Em8eA@mail.gmail.com>
Subject: Re: [PATCH V2] dma: mmp_pdma: support for getting residual bytes
From: Xiang Wang <wangxfdu@gmail.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Xiang Wang <wangxfdu@gmail.com>, cxie4@marvell.com,
        Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all
Do you have any comments about this patch? Thanks!

2013/6/18 Xiang Wang <wangxfdu@gmail.com>:
> From: Xiang Wang <wangx@marvell.com>
>
> In some of our drivers (e.g. UART) we may stop a running DMA
> before it finishes. So we need APIs to know how many bytes
> have been transferred.
>
> Signed-off-by: Xiang Wang <wangx@marvell.com>
> ---
>  drivers/dma/mmp_pdma.c |   88 +++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 80 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
> index c26699f..57cd047 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -104,7 +104,8 @@ struct mmp_pdma_chan {
>         spinlock_t desc_lock;           /* Descriptor list lock */
>         struct list_head chain_pending; /* Link descriptors queue for pending */
>         struct list_head chain_running; /* Link descriptors queue for running */
> -       bool idle;                      /* channel statue machine */
> +       enum dma_status status; /* channel status machine */
> +       u32 bytes_residue;
>
>         struct dma_pool *desc_pool;     /* Descriptors pool */
>  };
> @@ -270,7 +271,7 @@ static void start_pending_queue(struct mmp_pdma_chan *chan)
>         struct mmp_pdma_desc_sw *desc;
>
>         /* still in running, irq will start the pending list */
> -       if (!chan->idle) {
> +       if (chan->status == DMA_IN_PROGRESS) {
>                 dev_dbg(chan->dev, "DMA controller still busy\n");
>                 return;
>         }
> @@ -307,7 +308,64 @@ static void start_pending_queue(struct mmp_pdma_chan *chan)
>          */
>         set_desc(chan->phy, desc->async_tx.phys);
>         enable_chan(chan->phy);
> -       chan->idle = false;
> +       chan->status = DMA_IN_PROGRESS;
> +       chan->bytes_residue = 0;
> +}
> +
> +/*
> + * Get the number of pending bytes. Should be called with desc_lock held
> + * because we are accessing desc list.
> + */
> +static u32 mmp_pdma_get_bytes_residue(struct mmp_pdma_chan *chan)
> +{
> +       u32 reg, orig_pos, cur_pos, ddadr, residue = 0;
> +       bool running_desc_found = false;
> +       struct mmp_pdma_desc_sw *desc_sw;
> +
> +       /*
> +        * When a phy channel is unavailable, maybe it has been freed, return
> +        * last stored value for safe.
> +        */
> +       if (!chan->phy)
> +               return chan->bytes_residue;
> +
> +       reg = (chan->phy->idx << 4) + DDADR;
> +       ddadr = readl_relaxed(chan->phy->base + reg);
> +
> +       /* iterate over all descriptors to sum up the number of pending bytes */
> +       list_for_each_entry(desc_sw, &chan->chain_running, node) {
> +               /* for the case of a running descriptor */
> +               if (desc_sw->desc.ddadr == ddadr && !running_desc_found) {
> +                       switch (chan->dir) {
> +                       case DMA_DEV_TO_MEM:
> +                       case DMA_MEM_TO_MEM:
> +                               reg = (chan->phy->idx << 4) + DTADR;
> +                               cur_pos = readl_relaxed(chan->phy->base + reg);
> +                               orig_pos = desc_sw->desc.dtadr;
> +                               break;
> +
> +                       case DMA_MEM_TO_DEV:
> +                               reg = (chan->phy->idx << 4) + DSADR;
> +                               cur_pos = readl_relaxed(chan->phy->base + reg);
> +                               orig_pos = desc_sw->desc.dsadr;
> +                               break;
> +
> +                       default:
> +                               cur_pos = 0;
> +                               orig_pos = 0;
> +                       }
> +                       residue = (u32)(desc_sw->desc.dcmd & DCMD_LENGTH)
> +                                       + orig_pos - cur_pos;
> +                       running_desc_found = true;
> +                       continue;
> +               }
> +
> +               /* for the case of following un-started descriptors*/
> +               if (running_desc_found)
> +                       residue += (u32)(desc_sw->desc.dcmd & DCMD_LENGTH);
> +       }
> +
> +       return residue;
>  }
>
>
> @@ -381,7 +439,7 @@ static int mmp_pdma_alloc_chan_resources(struct dma_chan *dchan)
>                 chan->phy->vchan = NULL;
>                 chan->phy = NULL;
>         }
> -       chan->idle = true;
> +       chan->status = DMA_SUCCESS;
>         chan->dev_addr = 0;
>         return 1;
>  }
> @@ -409,7 +467,7 @@ static void mmp_pdma_free_chan_resources(struct dma_chan *dchan)
>
>         dma_pool_destroy(chan->desc_pool);
>         chan->desc_pool = NULL;
> -       chan->idle = true;
> +       chan->status = DMA_SUCCESS;
>         chan->dev_addr = 0;
>         if (chan->phy) {
>                 chan->phy->vchan = NULL;
> @@ -588,9 +646,16 @@ static int mmp_pdma_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
>                 spin_lock_irqsave(&chan->desc_lock, flags);
>                 mmp_pdma_free_desc_list(chan, &chan->chain_pending);
>                 mmp_pdma_free_desc_list(chan, &chan->chain_running);
> +               chan->bytes_residue = 0;
>                 spin_unlock_irqrestore(&chan->desc_lock, flags);
> -               chan->idle = true;
> +               chan->status = DMA_SUCCESS;
>                 break;
> +
> +       case DMA_PAUSE:
> +               disable_chan(chan->phy);
> +               chan->status = DMA_PAUSED;
> +               break;
> +
>         case DMA_SLAVE_CONFIG:
>                 if (cfg->direction == DMA_DEV_TO_MEM) {
>                         chan->dcmd = DCMD_INCTRGADDR | DCMD_FLOWSRC;
> @@ -637,7 +702,9 @@ static enum dma_status mmp_pdma_tx_status(struct dma_chan *dchan,
>         unsigned long flags;
>
>         spin_lock_irqsave(&chan->desc_lock, flags);
> -       ret = dma_cookie_status(dchan, cookie, txstate);
> +       chan->bytes_residue = mmp_pdma_get_bytes_residue(chan);
> +       dma_set_residue(txstate, chan->bytes_residue);
> +       ret = chan->status;
>         spin_unlock_irqrestore(&chan->desc_lock, flags);
>
>         return ret;
> @@ -684,6 +751,8 @@ static void dma_do_tasklet(unsigned long data)
>                 dev_dbg(chan->dev, "completed_cookie=%d\n", cookie);
>         }
>
> +       /* update bytes_residue so that the user can query later on */
> +       chan->bytes_residue = mmp_pdma_get_bytes_residue(chan);
>         /*
>          * move the descriptors to a temporary list so we can drop the lock
>          * during the entire cleanup operation
> @@ -691,7 +760,7 @@ static void dma_do_tasklet(unsigned long data)
>         list_splice_tail_init(&chan->chain_running, &chain_cleanup);
>
>         /* the hardware is now idle and ready for more */
> -       chan->idle = true;
> +       chan->status = DMA_SUCCESS;
>
>         /* Start any pending transactions automatically */
>         start_pending_queue(chan);
> @@ -750,6 +819,9 @@ static int mmp_pdma_chan_init(struct mmp_pdma_device *pdev,
>         INIT_LIST_HEAD(&chan->chain_pending);
>         INIT_LIST_HEAD(&chan->chain_running);
>
> +       chan->status = DMA_SUCCESS;
> +       chan->bytes_residue = 0;
> +
>         /* register virt channel to dma engine */
>         list_add_tail(&chan->chan.device_node,
>                         &pdev->device.channels);
> --
> 1.7.5.4
>



-- 
Regards,
Xiang
