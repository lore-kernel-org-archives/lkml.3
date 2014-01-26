Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaAZLBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 06:01:09 -0500
Received: from mail-yk0-f173.google.com ([209.85.160.173]:63659 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaAZLBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 06:01:07 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jan 2014 06:01:07 EST
Message-ID: <1390733658.3059.10.camel@laptop>
Subject: [PATCH] for_each macros correctness
From: Jose Alonso <joalonsof@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jan 2014 08:54:18 -0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I observed that there are for_each macros that do an extra memory access
beyond the defined area.
Normally this does not cause problems.
But, this can cause exceptions. For example: if the area is allocated at
the end of a page and the next page is not accessible.

For correctness, I suggest changing the arguments of the 'for loop' like
others 'for_each' do in the kernel.

files involved:
   drivers/s390/cio/qdio.h
   drivers/scsi/isci/host.h
   drivers/sh/clk/core.c
   include/linux/blk-mq.h
   include/linux/shdma-base.h
   sound/soc/sh/rcar/adg.c


Signed-off-by: Jose Alonso <joalonsof@gmail.com>
---
diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index 8acaae1..a563e4c 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -359,14 +359,12 @@ static inline int multicast_outbound(struct qdio_q *q)
 #define need_siga_sync_out_after_pci(q)	\
 	(unlikely(q->irq_ptr->siga_flag.sync_out_after_pci))
 
-#define for_each_input_queue(irq_ptr, q, i)	\
-	for (i = 0, q = irq_ptr->input_qs[0];	\
-		i < irq_ptr->nr_input_qs;	\
-		q = irq_ptr->input_qs[++i])
-#define for_each_output_queue(irq_ptr, q, i)	\
-	for (i = 0, q = irq_ptr->output_qs[0];	\
-		i < irq_ptr->nr_output_qs;	\
-		q = irq_ptr->output_qs[++i])
+#define for_each_input_queue(irq_ptr, q, i)		\
+	for (i = 0; i < irq_ptr->nr_input_qs &&		\
+		({ q = irq_ptr->input_qs[i]; 1; }); i++)
+#define for_each_output_queue(irq_ptr, q, i)		\
+	for (i = 0; i < irq_ptr->nr_output_qs &&	\
+		({ q = irq_ptr->output_qs[i]; 1; }); i++)
 
 #define prev_buf(bufnr)	\
 	((bufnr + QDIO_MAX_BUFFERS_MASK) & QDIO_MAX_BUFFERS_MASK)
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 4911310..99c5a69 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -311,9 +311,8 @@ static inline struct Scsi_Host *to_shost(struct isci_host *ihost)
 }
 
 #define for_each_isci_host(id, ihost, pdev) \
-	for (id = 0, ihost = to_pci_info(pdev)->hosts[id]; \
-	     id < ARRAY_SIZE(to_pci_info(pdev)->hosts) && ihost; \
-	     ihost = to_pci_info(pdev)->hosts[++id])
+	for (id = 0; id < ARRAY_SIZE(to_pci_info(pdev)->hosts) && \
+	     (ihost = to_pci_info(pdev)->hosts[id]); id++)
 
 static inline void wait_for_start(struct isci_host *ihost)
 {
diff --git a/drivers/sh/clk/core.c b/drivers/sh/clk/core.c
index 7472785..6dd3cbb 100644
--- a/drivers/sh/clk/core.c
+++ b/drivers/sh/clk/core.c
@@ -82,8 +82,8 @@ struct clk_rate_round_data {
 };
 
 #define for_each_frequency(pos, r, freq)			\
-	for (pos = r->min, freq = r->func(pos, r);		\
-	     pos <= r->max; pos++, freq = r->func(pos, r))	\
+	for (pos = r->min; pos <= r->max &&			\
+	     ({ freq = r->func(pos, r); 1; }); pos++)		\
 		if (unlikely(freq == 0))			\
 			;					\
 		else
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index ab0e9b2..a4b40cf 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -159,16 +159,16 @@ static inline struct request *blk_mq_tag_to_rq(struct blk_mq_hw_ctx *hctx,
 }
 
 #define queue_for_each_hw_ctx(q, hctx, i)				\
-	for ((i) = 0, hctx = (q)->queue_hw_ctx[0];			\
-	     (i) < (q)->nr_hw_queues; (i)++, hctx = (q)->queue_hw_ctx[i])
+	for ((i) = 0; (i) < (q)->nr_hw_queues &&			\
+	     ({ hctx = (q)->queue_hw_ctx[i]; 1; }); (i)++)
 
 #define queue_for_each_ctx(q, ctx, i)					\
-	for ((i) = 0, ctx = per_cpu_ptr((q)->queue_ctx, 0);		\
-	     (i) < (q)->nr_queues; (i)++, ctx = per_cpu_ptr(q->queue_ctx, (i)))
+	for ((i) = 0; (i) < (q)->nr_queues &&				\
+	     ({ ctx = per_cpu_ptr((q)->queue_ctx, (i)); 1; }); (i)++)
 
 #define hctx_for_each_ctx(hctx, ctx, i)					\
-	for ((i) = 0, ctx = (hctx)->ctxs[0];				\
-	     (i) < (hctx)->nr_ctx; (i)++, ctx = (hctx)->ctxs[(i)])
+	for ((i) = 0; (i) < (hctx)->nr_ctx &&				\
+	     ({ ctx = (hctx)->ctxs[(i)]; 1; }); (i)++)
 
 #define blk_ctx_sum(q, sum)						\
 ({									\
diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
index f92c0a4..35285f7 100644
--- a/include/linux/shdma-base.h
+++ b/include/linux/shdma-base.h
@@ -111,8 +111,8 @@ struct shdma_dev {
 	size_t desc_size;
 };
 
-#define shdma_for_each_chan(c, d, i) for (i = 0, c = (d)->schan[0]; \
-				i < (d)->dma_dev.chancnt; c = (d)->schan[++i])
+#define shdma_for_each_chan(c, d, i) for (i = 0; i < (d)->dma_dev.chancnt && \
+				({ c = (d)->schan[i]; 1; }); i++)
 
 int shdma_request_irq(struct shdma_chan *, int,
 			   unsigned long, const char *);
diff --git a/sound/soc/sh/rcar/adg.c b/sound/soc/sh/rcar/adg.c
index a53235c..ef19c15 100644
--- a/sound/soc/sh/rcar/adg.c
+++ b/sound/soc/sh/rcar/adg.c
@@ -25,9 +25,8 @@ struct rsnd_adg {
 };
 
 #define for_each_rsnd_clk(pos, adg, i)		\
-	for (i = 0, (pos) = adg->clk[i];	\
-	     i < CLKMAX;			\
-	     i++, (pos) = adg->clk[i])
+	for (i = 0; i < CLKMAX &&		\
+	     ({ (pos) = adg->clk[i]; 1; }); i++)
 #define rsnd_priv_to_adg(priv) ((struct rsnd_adg *)(priv)->adg)
 
 static int rsnd_adg_set_convert_clk_gen1(struct rsnd_priv *priv,


