Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab3HLNhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:37:35 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:41873 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab3HLNhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:37:32 -0400
MIME-Version: 1.0
In-Reply-To: <1373803321-11628-3-git-send-email-gsi@denx.de>
References: <1373642781-32631-1-git-send-email-gsi@denx.de>
	<1373803321-11628-1-git-send-email-gsi@denx.de>
	<1373803321-11628-3-git-send-email-gsi@denx.de>
Date: Mon, 12 Aug 2013 17:37:30 +0400
Message-ID: <CAF0T0X6+r_1Gbp6BX2L3YF6-=qf2OP-ct5w=4ODpTj69EhQNzA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/5] dma: mpc512x: add support for peripheral transfers
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Gerhard Sittig <gsi@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        Anatolij Gustschin <agust@denx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone!

Changes offered in this letter:

- Adding a flag "will_access_peripheral" to DMA transfer descriptor
according recommendations of Gerhard Sittig.
This flag is set in mpc_dma_prep_memcpy() and mpc_dma_prep_slave_sg()
and is evaluated in mpc_dma_execute().

- Adding locking and removing default nbytes value according
recommendations of Lars-Peter Clausen.

I tested these changes on MPC5125
with SCLPC driver (transfers between dev and mem work fine)
and dmatest module (all 64 DMA channels can perform mem-to-mem transfers
which can be chained in one DMA transaction).


2013/7/14 Gerhard Sittig <gsi@denx.de>:
> From: Alexander Popov <a13xp0p0v88@gmail.com>
>
> introduce support for slave s/g transfer preparation and the associated
> device control callback in the MPC512x DMA controller driver, which adds
> support for data transfers between memory and peripheral I/O to the
> previously supported mem-to-mem transfers
>
> refuse to prepare chunked transfers (transfers with more than one part)
> as long as proper support for scatter/gather is lacking
>
> keep MPC8308 operational by always starting transfers from software,
> this SoC appears to not have request lines for flow control when
> peripherals are involved in transfers
>
> [ introduction of slave s/g preparation and device control ]
> Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
> [ execute() start condition, mpc8308 compat, terminate all, s/g length check, reworded commit msg ]
> Signed-off-by: Gerhard Sittig <gsi@denx.de>
> ---
>  drivers/dma/mpc512x_dma.c |  168 +++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 161 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
> index 4e03f1e..55e6a87 100644
> --- a/drivers/dma/mpc512x_dma.c
> +++ b/drivers/dma/mpc512x_dma.c
> @@ -2,6 +2,7 @@
>   * Copyright (C) Freescale Semicondutor, Inc. 2007, 2008.
>   * Copyright (C) Semihalf 2009
>   * Copyright (C) Ilya Yanok, Emcraft Systems 2010
> + * Copyright (C) Alexander Popov, Promcontroller 2013
>   *
>   * Written by Piotr Ziecik <kosmo@semihalf.com>. Hardware description
>   * (defines, structures and comments) was taken from MPC5121 DMA driver
> @@ -28,11 +29,6 @@
>   * file called COPYING.
>   */
>
> -/*
> - * This is initial version of MPC5121 DMA driver. Only memory to memory
> - * transfers are supported (tested using dmatest module).
> - */
> -
>  #include <linux/module.h>
>  #include <linux/dmaengine.h>
>  #include <linux/dma-mapping.h>
> @@ -63,6 +59,7 @@ enum mpc8308_dmachan_id_t {
>         MPC8308_DMACHAN_MAX = 16,
>  };
>  enum mpc512x_dmachan_id_t {
> +       MPC512x_DMACHAN_MDDRC = 32,
>         MPC512x_DMACHAN_MAX = 64,
>  };
>  #define MPC_DMA_CHANNELS       64

Adding the flag:

@@ -193,6 +183,7 @@ struct mpc_dma_desc {
     dma_addr_t            tcd_paddr;
     int                error;
     struct list_head        node;
+    int                will_access_peripheral;
 };

 struct mpc_dma_chan {


> @@ -204,9 +201,13 @@ struct mpc_dma_chan {
>         struct list_head                completed;
>         struct mpc_dma_tcd              *tcd;
>         dma_addr_t                      tcd_paddr;
> +       u32                             tcd_nunits;
>
>         /* Lock for this structure */
>         spinlock_t                      lock;
> +
> +       /* Channel's peripheral fifo address */
> +       dma_addr_t                      per_paddr;
>  };
>
>  struct mpc_dma {

We can't chain together descriptors of transfers which involve peripherals
because each of such transfers needs hardware initiated start.

@@ -253,10 +248,27 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
     struct mpc_dma_desc *first = NULL;
     struct mpc_dma_desc *prev = NULL;
     struct mpc_dma_desc *mdesc;
+    int staffed = 0;
     int cid = mchan->chan.chan_id;

-    /* Move all queued descriptors to active list */
-    list_splice_tail_init(&mchan->queued, &mchan->active);
+    /*
+     * Mem-to-mem transfers can be chained
+     * together into one transaction.
+     * But each transfer which involves peripherals
+     * must be executed separately.
+     */
+    while (!staffed) {
+        mdesc = list_first_entry(&mchan->queued,
+                        struct mpc_dma_desc, node);
+
+        if (!mdesc->will_access_peripheral)
+            list_move_tail(&mdesc->node, &mchan->active);
+        else {
+            staffed = 1;
+            if (list_empty(&mchan->active))
+                list_move_tail(&mdesc->node, &mchan->active);
+        }
+    }

     /* Chain descriptors into one transaction */
     list_for_each_entry(mdesc, &mchan->active, node) {


> @@ -270,7 +271,12 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
>
>                 prev->tcd->dlast_sga = mdesc->tcd_paddr;
>                 prev->tcd->e_sg = 1;
> -               mdesc->tcd->start = 1;
> +
> +               /* software start for mem-to-mem transfers */
> +               if (mdma->is_mpc8308)
> +                       mdesc->tcd->start = 1;
> +               else if (cid == MPC512x_DMACHAN_MDDRC)
> +                       mdesc->tcd->start = 1;
>
>                 prev = mdesc;
>         }

We don't need this change. Now only mem-to-mem transfers are chained:

@@ -270,6 +282,8 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)

         prev->tcd->dlast_sga = mdesc->tcd_paddr;
         prev->tcd->e_sg = 1;
+
+        /* software start for mem-to-mem transfers */
         mdesc->tcd->start = 1;

         prev = mdesc;


> @@ -282,7 +288,17 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
>
>         if (first != prev)
>                 mdma->tcd[cid].e_sg = 1;
> -       out_8(&mdma->regs->dmassrt, cid);
> +
> +       if (mdma->is_mpc8308) {
> +               /* MPC8308, no request lines, software initiated start */
> +               out_8(&mdma->regs->dmassrt, cid);
> +       } else if (cid == MPC512x_DMACHAN_MDDRC) {

This condition should be changed to:
+    } else if (!first->will_access_peripheral) {

> +               /* memory to memory transfer, software initiated start */
> +               out_8(&mdma->regs->dmassrt, cid);
> +       } else {
> +               /* peripherals involved, use external request line */
> +               out_8(&mdma->regs->dmaserq, cid);
> +       }
>  }
>
>  /* Handle interrupt on one half of DMA controller (32 channels) */

Setting the flag:

@@ -608,6 +632,7 @@ mpc_dma_prep_memcpy(struct dma_chan *chan,
dma_addr_t dst, dma_addr_t src,
     }

     mdesc->error = 0;
+    mdesc->will_access_peripheral = 0;
     tcd = mdesc->tcd;

     /* Prepare Transfer Control Descriptor for this transaction */


> @@ -655,6 +671,141 @@ mpc_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
>         return &mdesc->desc;
>  }
>
> +static struct dma_async_tx_descriptor *mpc_dma_prep_slave_sg(
> +               struct dma_chan *chan, struct scatterlist *sgl,
> +               unsigned int sg_len, enum dma_transfer_direction direction,
> +               unsigned long flags, void *context)
> +{
> +       struct mpc_dma *mdma = dma_chan_to_mpc_dma(chan);
> +       struct mpc_dma_chan *mchan = dma_chan_to_mpc_dma_chan(chan);
> +       struct mpc_dma_desc *mdesc = NULL;

Will be used when the spinlock is grabbed:
+    dma_addr_t per_paddr;
+    u32 tcd_nunits = 0;

> +       struct mpc_dma_tcd *tcd;
> +       unsigned long iflags;
> +       struct scatterlist *sg;
> +       size_t len;
> +       int iter, i;
> +
> +       if (!list_empty(&mchan->active))
> +               return NULL;
> +
> +       /* currently there is no proper support for scatter/gather */
> +       if (sg_len > 1)
> +               return NULL;
> +
> +       for_each_sg(sgl, sg, sg_len, i) {
> +               spin_lock_irqsave(&mchan->lock, iflags);
> +
> +               mdesc = list_first_entry(&mchan->free, struct mpc_dma_desc,
> +                                                                       node);
> +               if (!mdesc) {
> +                       spin_unlock_irqrestore(&mchan->lock, iflags);
> +                       /* try to free completed descriptors */
> +                       mpc_dma_process_completed(mdma);
> +                       return NULL;
> +               }
> +
> +               list_del(&mdesc->node);

While spinlock is grabbed:
+        per_paddr = mchan->per_paddr;
+        tcd_nunits = mchan->tcd_nunits;

> +
> +               spin_unlock_irqrestore(&mchan->lock, iflags);
> +
> +               mdesc->error = 0;

Setting the flag here:
+        mdesc->will_access_peripheral = 1;

> +               tcd = mdesc->tcd;
> +
> +               /* Prepare Transfer Control Descriptor for this transaction */
> +               memset(tcd, 0, sizeof(struct mpc_dma_tcd));
> +
> +               if (!IS_ALIGNED(sg_dma_address(sg), 4))
> +                       return NULL;
> +
> +               if (direction == DMA_DEV_TO_MEM) {
> +                       tcd->saddr = mchan->per_paddr;

This line should be changed to:
+                       tcd->saddr = per_paddr;

> +                       tcd->daddr = sg_dma_address(sg);
> +                       tcd->soff = 0;
> +                       tcd->doff = 4;
> +               } else if (direction == DMA_MEM_TO_DEV) {
> +                       tcd->saddr = sg_dma_address(sg);
> +                       tcd->daddr = mchan->per_paddr;

Ditto:
+                       tcd->daddr = per_paddr;

> +                       tcd->soff = 4;
> +                       tcd->doff = 0;
> +               } else {
> +                       return NULL;
> +               }
> +               tcd->ssize = MPC_DMA_TSIZE_4;
> +               tcd->dsize = MPC_DMA_TSIZE_4;
> +
> +               len = sg_dma_len(sg);
> +
> +               if (mchan->tcd_nunits)
> +                       tcd->nbytes = mchan->tcd_nunits * 4;
> +               else
> +                       tcd->nbytes = 64;

These 4 lines should be changed to:

+               if (tcd_nunits)
+                       tcd->nbytes = tcd_nunits * 4;
+               else
+                       return NULL;

The last line means that client kernel modules must set
src_maxburst and dst_maxburst fields of dma_slave_config (dmaengine.h).

> +
> +               if (!IS_ALIGNED(len, tcd->nbytes))
> +                       return NULL;
> +
> +               iter = len / tcd->nbytes;
> +               if (iter > ((1 << 15) - 1)) {   /* maximum biter */
> +                       return NULL; /* len is too big */
> +               } else {
> +                       /* citer_linkch contains the high bits of iter */
> +                       tcd->biter = iter & 0x1ff;
> +                       tcd->biter_linkch = iter >> 9;
> +                       tcd->citer = tcd->biter;
> +                       tcd->citer_linkch = tcd->biter_linkch;
> +               }
> +
> +               tcd->e_sg = 0;
> +               tcd->d_req = 1;
> +
> +               /* Place descriptor in prepared list */
> +               spin_lock_irqsave(&mchan->lock, iflags);
> +               list_add_tail(&mdesc->node, &mchan->prepared);
> +               spin_unlock_irqrestore(&mchan->lock, iflags);
> +       }
> +
> +       /* Return the last descriptor */

Offer to remove this comment.

> +       return &mdesc->desc;
> +}
> +
> +static int mpc_dma_device_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +                                 unsigned long arg)
> +{
> +       struct mpc_dma_chan *mchan;
> +       struct mpc_dma *mdma;
> +       struct dma_slave_config *cfg;

Locking:
+    unsigned long flags;

> +
> +       mchan = dma_chan_to_mpc_dma_chan(chan);
> +       switch (cmd) {
> +       case DMA_TERMINATE_ALL:
> +               /* disable channel requests */
> +               mdma = dma_chan_to_mpc_dma(chan);

+        spin_lock_irqsave(&mchan->lock, flags);

> +               out_8(&mdma->regs->dmacerq, chan->chan_id);
> +               list_splice_tail_init(&mchan->prepared, &mchan->free);
> +               list_splice_tail_init(&mchan->queued, &mchan->free);
> +               list_splice_tail_init(&mchan->active, &mchan->free);

+        spin_unlock_irqrestore(&mchan->lock, flags);

> +               return 0;
> +       case DMA_SLAVE_CONFIG:
> +               cfg = (void *)arg;
> +               if (cfg->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES &&
> +                   cfg->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES)
> +                       return -EINVAL;

+        spin_lock_irqsave(&mchan->lock, flags);

> +
> +               if (cfg->direction == DMA_DEV_TO_MEM) {
> +                       mchan->per_paddr = cfg->src_addr;
> +                       mchan->tcd_nunits = cfg->src_maxburst;
> +               } else {
> +                       mchan->per_paddr = cfg->dst_addr;
> +                       mchan->tcd_nunits = cfg->dst_maxburst;
> +               }

+        spin_unlock_irqrestore(&mchan->lock, flags);

> +
> +               return 0;
> +       default:
> +               return -ENOSYS;
> +       }
> +
> +       return -EINVAL;
> +}
> +
>  static int mpc_dma_probe(struct platform_device *op)
>  {
>         struct device_node *dn = op->dev.of_node;
> @@ -739,9 +890,12 @@ static int mpc_dma_probe(struct platform_device *op)
>         dma->device_issue_pending = mpc_dma_issue_pending;
>         dma->device_tx_status = mpc_dma_tx_status;
>         dma->device_prep_dma_memcpy = mpc_dma_prep_memcpy;
> +       dma->device_prep_slave_sg = mpc_dma_prep_slave_sg;
> +       dma->device_control = mpc_dma_device_control;
>
>         INIT_LIST_HEAD(&dma->channels);
>         dma_cap_set(DMA_MEMCPY, dma->cap_mask);
> +       dma_cap_set(DMA_SLAVE, dma->cap_mask);
>
>         for (i = 0; i < dma->chancnt; i++) {
>                 mchan = &mdma->channels[i];
> --
> 1.7.10.4
>

Best regards,
Alexander.
