Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbaLKTbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:31:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:46189 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757031AbaLKTbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:31:07 -0500
Date: Thu, 11 Dec 2014 20:31:03 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Cc: <nicolas.ferre@atmel.com>, <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <soren.brinkmann@xilinx.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] net/macb: add TX multiqueue support for gem
Message-ID: <20141211203103.4191887a@free-electrons.com>
In-Reply-To: <87a3098203ee6eaa7a60607713a293d3258e2b58.1418291637.git.cyrille.pitchen@atmel.com>
References: <cover.1418291637.git.cyrille.pitchen@atmel.com>
	<87a3098203ee6eaa7a60607713a293d3258e2b58.1418291637.git.cyrille.pitchen@atmel.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Cyrille Pitchen,

On Thu, 11 Dec 2014 11:16:51 +0100, Cyrille Pitchen wrote:

> +#define GEM_ISR1				0x0400
> +#define GEM_ISR2				0x0404
> +#define GEM_ISR3				0x0408
> +#define GEM_ISR4				0x040c
> +#define GEM_ISR5				0x0410
> +#define GEM_ISR6				0x0414
> +#define GEM_ISR7				0x0418

What about doing instead:

#define GEM_ISR(q)				((q) == 0 ? MACB_ISR : 0x400 + (q) << 2)

And ditto for all other registers, which will save a lot of boring repeated code.

If you do that, then you can avoid the following fields in the
macb_queue structure:

+	unsigned int		ISR;
+	unsigned int		IER;
+	unsigned int		IDR;
+	unsigned int		IMR;
+	unsigned int		TBQP;

And the not very pleasant calculation of those offsets:

+	bp->queues[0].bp = bp;
+	bp->queues[0].ISR  = MACB_ISR;
+	bp->queues[0].IER  = MACB_IER;
+	bp->queues[0].IDR  = MACB_IDR;
+	bp->queues[0].IMR  = MACB_IMR;
+	bp->queues[0].TBQP = MACB_TBQP;
+	for (q = 1, queue = &bp->queues[1]; q < MACB_MAX_QUEUES; ++q) {
+		if (!(queue_mask & (1 << q)))
+			continue;
+
+		queue->bp = bp;
+		queue->ISR  = (q-1) * sizeof(u32) + GEM_ISR1;
+		queue->IER  = (q-1) * sizeof(u32) + GEM_IER1;
+		queue->IDR  = (q-1) * sizeof(u32) + GEM_IDR1;
+		queue->IMR  = (q-1) * sizeof(u32) + GEM_IMR1;
+		queue->TBQP = (q-1) * sizeof(u32) + GEM_TBQP1;
+		queue++;
+	}

You replace the ISR, IER, IDR, IMR and TBQP by an "id" field in
macb_queue, which contains the queue number, and then change your:

+#define queue_readl(queue, reg)				\
+	__raw_readl((queue)->bp->regs + queue->reg)
+#define queue_writel(queue, reg, value)			\
+	__raw_writel((value), (queue)->bp->regs + queue->reg)

to

+#define queue_readl(queue, reg)				\
+	__raw_readl((queue)->bp->regs + reg((queue)->id))
+#define queue_writel(queue, reg, value)			\
+	__raw_writel((value), (queue)->bp->regs + reg((queue)->id)

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
