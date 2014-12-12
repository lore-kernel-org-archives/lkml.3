Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934649AbaLLJXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:23:43 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:48019 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200AbaLLJXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:23:41 -0500
Message-ID: <548AA623.9070304@atmel.com>
Date: Fri, 12 Dec 2014 09:24:03 +0100
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: <nicolas.ferre@atmel.com>, <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <soren.brinkmann@xilinx.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] net/macb: add TX multiqueue support for gem
References: <cover.1418291637.git.cyrille.pitchen@atmel.com>	<87a3098203ee6eaa7a60607713a293d3258e2b58.1418291637.git.cyrille.pitchen@atmel.com> <20141211203103.4191887a@free-electrons.com>
In-Reply-To: <20141211203103.4191887a@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11/12/2014 20:31, Thomas Petazzoni a écrit :
> Dear Cyrille Pitchen,
> 
> On Thu, 11 Dec 2014 11:16:51 +0100, Cyrille Pitchen wrote:
> 
>> +#define GEM_ISR1				0x0400
>> +#define GEM_ISR2				0x0404
>> +#define GEM_ISR3				0x0408
>> +#define GEM_ISR4				0x040c
>> +#define GEM_ISR5				0x0410
>> +#define GEM_ISR6				0x0414
>> +#define GEM_ISR7				0x0418
> 
> What about doing instead:
> 
> #define GEM_ISR(q)				((q) == 0 ? MACB_ISR : 0x400 + (q) << 2)
> 
> And ditto for all other registers, which will save a lot of boring repeated code.
> 
> If you do that, then you can avoid the following fields in the
> macb_queue structure:
> 
> +	unsigned int		ISR;
> +	unsigned int		IER;
> +	unsigned int		IDR;
> +	unsigned int		IMR;
> +	unsigned int		TBQP;
> 
> And the not very pleasant calculation of those offsets:
> 
> +	bp->queues[0].bp = bp;
> +	bp->queues[0].ISR  = MACB_ISR;
> +	bp->queues[0].IER  = MACB_IER;
> +	bp->queues[0].IDR  = MACB_IDR;
> +	bp->queues[0].IMR  = MACB_IMR;
> +	bp->queues[0].TBQP = MACB_TBQP;
> +	for (q = 1, queue = &bp->queues[1]; q < MACB_MAX_QUEUES; ++q) {
> +		if (!(queue_mask & (1 << q)))
> +			continue;
> +
> +		queue->bp = bp;
> +		queue->ISR  = (q-1) * sizeof(u32) + GEM_ISR1;
> +		queue->IER  = (q-1) * sizeof(u32) + GEM_IER1;
> +		queue->IDR  = (q-1) * sizeof(u32) + GEM_IDR1;
> +		queue->IMR  = (q-1) * sizeof(u32) + GEM_IMR1;
> +		queue->TBQP = (q-1) * sizeof(u32) + GEM_TBQP1;
> +		queue++;
> +	}
> 
> You replace the ISR, IER, IDR, IMR and TBQP by an "id" field in
> macb_queue, which contains the queue number, and then change your:
> 
> +#define queue_readl(queue, reg)				\
> +	__raw_readl((queue)->bp->regs + queue->reg)
> +#define queue_writel(queue, reg, value)			\
> +	__raw_writel((value), (queue)->bp->regs + queue->reg)
> 
> to
> 
> +#define queue_readl(queue, reg)				\
> +	__raw_readl((queue)->bp->regs + reg((queue)->id))
> +#define queue_writel(queue, reg, value)			\
> +	__raw_writel((value), (queue)->bp->regs + reg((queue)->id)
> 
> Best regards,
> 
> Thomas
> 
Good idea, I'm working on it.

Thanks,

Cyrille
