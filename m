Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751045AbaKYN4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:56:30 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32500 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKYN41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:56:27 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-9c-54748a88b1dd
Message-id: <54748A87.4040500@samsung.com>
Date: Tue, 25 Nov 2014 14:56:23 +0100
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>, vinod.koul@intel.com
Cc: dan.j.williams@intel.com, ars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        l.czerwinski@samsung.com
Subject: Re: [PATCH 1/2] dma: pl330: improve pl330_tx_status() function
References: <1416918346-2442-1-git-send-email-r.baldyga@samsung.com>
 <1416918346-2442-2-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1416918346-2442-2-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xa7odXSUhBucatS0uHOhktJg+9QKj
	xeqpf1ktXr8wtPg1bRKbxeVdc9gs1h65y27x4PBOdouXfftZHDg9Fu95yeSx5M0hVo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DKOH7jKktBs0LFraktrA2MKyS7GDk5JARMJK6+XsAIYYtJ
	XLi3nq2LkYtDSGApo0Rf60Yo5zOjxN8Py5lBqngFtCRmdC5n6WLk4GARUJXovlIBEmYT8JCY
	9r0HrERUIELiypo5jBDlghI/Jt8DKxcRcJC4cpgZZCSzwFxGiQOXV7KB1AgLuEtsvHKICcQW
	EqiXmDftHwuIzSngKvFy0XuwXmYBdYkpU3JBwswC8hKb17xlnsAoMAvJhlkIVbOQVC1gZF7F
	KJpamlxQnJSea6hXnJhbXJqXrpecn7uJERLoX3YwLj5mdYhRgINRiYfXILEkRIg1say4MvcQ
	owQHs5IIb241UIg3JbGyKrUoP76oNCe1+BAjEwenVANj6+Rd86KUWOL8ZqxdkvP2Yc5VV39p
	U9UQobJ1jF9lHvOF2KSKPdy382HxAv6zIW+lDuayroiMXFf68VGAqV0c45u6uMhJWScYVmj9
	jwpOyhJ7enN2xUuRWMaIB9s3TGrZs+Wg2Wv/K/5zpr38wz1P4rtA+PL9zxRzOM+s2c3v8Glu
	CN+EKaI3lFiKMxINtZiLihMBmagfLVICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.11.2014 13:25, Robert Baldyga wrote:
> This patch adds possibility to read residue of DMA transfer. It's useful
> when we want to know how many bytes have been transfered before we
> terminate channel. It can take place, for example, on timeout interrupt.
> 
> Signed-off-by: Lukasz Czerwinski <l.czerwinski@samsung.com>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/dma/pl330.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index d5149aa..c32806d 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -437,6 +437,7 @@ struct dma_pl330_chan {
>  	/* For D-to-M and M-to-D channels */
>  	int burst_sz; /* the peripheral fifo width */
>  	int burst_len; /* the number of burst */
> +	int transfered;
>  	dma_addr_t fifo_addr;
>  
>  	/* for cyclic capability */
> @@ -500,6 +501,9 @@ struct dma_pl330_desc {
>  
>  	enum desc_status status;
>  
> +	int bytes_requested;
> +	int direction;
> +
>  	/* The channel which currently holds this desc */
>  	struct dma_pl330_chan *pchan;
>  
> @@ -2156,11 +2160,60 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
>  	spin_unlock_irqrestore(&pch->lock, flags);
>  }
>  
> +int pl330_get_current_xferred_count(struct dma_pl330_chan *pch,
> +		struct dma_pl330_desc *desc)
> +{
> +	u32 val, addr;
> +	struct pl330_thread *thrd = pch->thread;
> +	void __iomem *regs = thrd->dmac->base;
> +
> +	val = addr = 0;
> +	switch (desc->direction) {
> +	case DMA_MEM_TO_DEV:
> +		val = readl(regs + SA(thrd->id));
> +		addr = desc->px.src_addr;
> +		break;
> +	case DMA_DEV_TO_MEM:
> +		val = readl(regs + DA(thrd->id));
> +		addr = desc->px.dst_addr;
> +		break;
> +	default:
> +		break;
> +	}
> +	return val - addr;
> +}
> +
>  static enum dma_status
>  pl330_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
>  		 struct dma_tx_state *txstate)
>  {
> -	return dma_cookie_status(chan, cookie, txstate);
> +	enum dma_status ret;
> +	unsigned long flags;
> +	struct dma_pl330_desc *desc;
> +	struct dma_pl330_chan *pch = to_pchan(chan);
> +	unsigned int bytes_transferred;
> +	unsigned int residual;
> +
> +	/* Check in pending list */
> +	spin_lock_irqsave(&pch->lock, flags);
> +	list_for_each_entry(desc, &pch->work_list, node) {
> +		if (desc->txd.cookie == cookie) {
> +			bytes_transferred =
> +				pl330_get_current_xferred_count(pch, desc);

As in 2nd patch - what if this get called after all transfers complete?
You're touching the device here so pm_runtime_get_sync()/put/autosuspend
may be needed.

Best regards,
Krzysztof

> +			residual =  desc->bytes_requested -
> +				bytes_transferred % desc->bytes_requested;
> +			dma_set_residue(txstate, residual);
> +			ret = desc->status;
> +			spin_unlock_irqrestore(&pch->lock, flags);
> +			return ret;
> +		}
> +	}
> +	spin_unlock_irqrestore(&pch->lock, flags);
> +
> +	ret = dma_cookie_status(chan, cookie, txstate);
> +	dma_set_residue(txstate,  pch->transfered);
> +
> +	return ret;
>  }
>  
>  static void pl330_issue_pending(struct dma_chan *chan)
> @@ -2421,10 +2474,13 @@ static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
>  			break;
>  		}
>  
> +		desc->direction = direction;
>  		desc->rqtype = direction;
>  		desc->rqcfg.brst_size = pch->burst_sz;
>  		desc->rqcfg.brst_len = 1;
> +		desc->bytes_requested = period_len;
>  		fill_px(&desc->px, dst, src, period_len);
> +		pch->transfered = 0;
>  
>  		if (!first)
>  			first = desc;
> @@ -2554,9 +2610,12 @@ pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  				sg_dma_address(sg), addr, sg_dma_len(sg));
>  		}
>  
> +		desc->direction = direction;
>  		desc->rqcfg.brst_size = pch->burst_sz;
>  		desc->rqcfg.brst_len = 1;
>  		desc->rqtype = direction;
> +		desc->bytes_requested = sg_dma_len(sg);
> +		pch->transfered = 0;
>  	}
>  
>  	/* Return the last desc in the chain */
> 

