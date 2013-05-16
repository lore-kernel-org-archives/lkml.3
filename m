Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3EPNEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:04:16 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49657 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3EPNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:04:15 -0400
MIME-Version: 1.0
In-Reply-To: <1364746680-6564-2-git-send-email-agust@denx.de>
References: <1364746680-6564-2-git-send-email-agust@denx.de>
Date: Thu, 16 May 2013 17:04:05 +0400
Message-ID: <CAF0T0X4Er_39EYr21sNUrvi1cuBu0dFfTfWnutYP2Bfcoia2Xw@mail.gmail.com>
Subject: Re: [2/2] dmaengine: mpc512x: add slave sg and device control operations
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Anatolij,

I've made SCLPC device driver use .device_prep_slave_sg() from your patch
and before I send the second version of it I would like to propose
some improvements:


diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 1c822b1..80d8633 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -28,11 +28,6 @@
  * file called COPYING.
  */

-/*
- * This is initial version of MPC5121 DMA driver. Only memory to memory
- * transfers are supported (tested using dmatest module).
- */
-
 #include <linux/module.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
@@ -191,6 +186,7 @@ struct mpc_dma_chan {
     struct list_head        completed;
     struct mpc_dma_tcd        *tcd;
     dma_addr_t            tcd_paddr;
+    u32                tcd_nunits;

     /* Lock for this structure */
     spinlock_t            lock;
@@ -276,6 +272,7 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
         mdma->tcd[cid].e_sg = 1;

     switch (cid) {
+    case 26:
     case 30:
         out_8(&mdma->regs->dmaserq, cid);
         break;
@@ -664,9 +661,8 @@ static struct dma_async_tx_descriptor
*mpc_dma_prep_slave_sg(
     struct mpc_dma_chan *mchan = dma_chan_to_mpc_dma_chan(chan);
     struct mpc_dma_desc *mdesc = NULL;
     struct mpc_dma_tcd *tcd;
-    unsigned long flags;
+    unsigned long iflags;
     struct scatterlist *sg;
-    dma_addr_t dst, src;
     size_t len;
     int iter, i;

@@ -674,12 +670,12 @@ static struct dma_async_tx_descriptor
*mpc_dma_prep_slave_sg(
         return NULL;

     for_each_sg(sgl, sg, sg_len, i) {
-        spin_lock_irqsave(&mchan->lock, flags);
+        spin_lock_irqsave(&mchan->lock, iflags);

         mdesc = list_first_entry(&mchan->free, struct mpc_dma_desc,
                      node);
         if (!mdesc) {
-            spin_unlock_irqrestore(&mchan->lock, flags);
+            spin_unlock_irqrestore(&mchan->lock, iflags);
             /* try to free completed descriptors */
             mpc_dma_process_completed(mdma);
             return NULL;
@@ -687,7 +683,7 @@ static struct dma_async_tx_descriptor
*mpc_dma_prep_slave_sg(

         list_del(&mdesc->node);

-        spin_unlock_irqrestore(&mchan->lock, flags);
+        spin_unlock_irqrestore(&mchan->lock, iflags);

         mdesc->error = 0;
         tcd = mdesc->tcd;
@@ -696,40 +692,43 @@ static struct dma_async_tx_descriptor
*mpc_dma_prep_slave_sg(
         memset(tcd, 0, sizeof(struct mpc_dma_tcd));

         if (direction == DMA_DEV_TO_MEM) {
-            dst = sg_dma_address(sg);
-            src = mchan->per_paddr;
+            tcd->saddr = mchan->per_paddr;
+            tcd->daddr = sg_dma_address(sg);
+            tcd->soff = 0;
+            tcd->doff = 4;
         } else if (direction == DMA_MEM_TO_DEV) {
-            dst = mchan->per_paddr;
-            src = sg_dma_address(sg);
-        } else {
-            return NULL;
-        }
-
-        len = sg_dma_len(sg);
-
-        if (direction == DMA_MEM_TO_DEV) {
             tcd->saddr = sg_dma_address(sg);
             tcd->daddr = mchan->per_paddr;
             tcd->soff = 4;
             tcd->doff = 0;
         } else {
-            tcd->saddr = mchan->per_paddr;
-            tcd->daddr = sg_dma_address(sg);
-            tcd->soff = 0;
-            tcd->doff = 4;
+            return NULL;
         }
-
         tcd->ssize = MPC_DMA_TSIZE_4;
         tcd->dsize = MPC_DMA_TSIZE_4;
-        tcd->nbytes = 64;

-        iter = sg_dma_len(sg) / 64;
+        if (!IS_ALIGNED(sg_dma_address(sg), 4))
+            return NULL;
+
+        len = sg_dma_len(sg);
+        if (mchan->tcd_nunits)
+            tcd->nbytes = mchan->tcd_nunits * 4;
+        else
+            tcd->nbytes = 64;

-        /* citer_linkch contains the high bits of iter */
-        tcd->citer_linkch = iter >> 9;
-        tcd->biter_linkch = iter >> 9;
-        tcd->citer = iter & 0x1ff;
-        tcd->biter = iter & 0x1ff;
+        if (!IS_ALIGNED(len, tcd->nbytes))
+            return NULL;
+
+        iter = len / tcd->nbytes;
+        if (iter > ((1 << 15) - 1)) {   /* maximum biter */
+            return NULL; /* len is too big */
+        } else {
+            /* citer_linkch contains the high bits of iter */
+            tcd->biter = iter & 0x1ff;
+            tcd->biter_linkch = iter >> 9;
+            tcd->citer = tcd->biter;
+            tcd->citer_linkch = tcd->biter_linkch;
+        }

         tcd->e_sg = 0;

@@ -745,9 +744,9 @@ static struct dma_async_tx_descriptor
*mpc_dma_prep_slave_sg(
     }

     /* Place descriptor in prepared list */
-    spin_lock_irqsave(&mchan->lock, flags);
+    spin_lock_irqsave(&mchan->lock, iflags);
     list_add_tail(&mdesc->node, &mchan->prepared);
-    spin_unlock_irqrestore(&mchan->lock, flags);
+    spin_unlock_irqrestore(&mchan->lock, iflags);

     return &mdesc->desc;
 }
@@ -772,10 +771,13 @@ static int mpc_dma_device_control(struct
dma_chan *chan, enum dma_ctrl_cmd cmd,
             cfg->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES)
             return -EINVAL;

-        if (cfg->direction == DMA_DEV_TO_MEM)
+        if (cfg->direction == DMA_DEV_TO_MEM) {
             mchan->per_paddr = cfg->src_addr;
-        else
+            mchan->tcd_nunits = cfg->src_maxburst;
+        } else {
             mchan->per_paddr = cfg->dst_addr;
+            mchan->tcd_nunits = cfg->dst_maxburst;
+        }

         return 0;
     default:

2013/3/31 Anatolij Gustschin <agust@denx.de>:
> Prepare the driver to support slave sg operation.
>

Thanks.

Best regards,
Alexander
