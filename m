Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbaKYMn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:43:26 -0500
Received: from smtp-out-206.synserver.de ([212.40.185.206]:1113 "EHLO
	smtp-out-201.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752414AbaKYMnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:43:25 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23885
Message-ID: <5474796C.50603@metafoo.de>
Date: Tue, 25 Nov 2014 13:43:24 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>, vinod.koul@intel.com
CC: dan.j.williams@intel.com, ars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        l.czerwinski@samsung.com
Subject: Re: [PATCH 1/2] dma: pl330: improve pl330_tx_status() function
References: <1416918346-2442-1-git-send-email-r.baldyga@samsung.com> <1416918346-2442-2-git-send-email-r.baldyga@samsung.com>
In-Reply-To: <1416918346-2442-2-git-send-email-r.baldyga@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 01:25 PM, Robert Baldyga wrote:
[...]
>   static enum dma_status
>   pl330_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
>   		 struct dma_tx_state *txstate)
>   {
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
> +			residual =  desc->bytes_requested -
> +				bytes_transferred % desc->bytes_requested;
> +			dma_set_residue(txstate, residual);
> +			ret = desc->status;
> +			spin_unlock_irqrestore(&pch->lock, flags);
> +			return ret;

I don't think this has the correct semantics. The expected behavior is that 
you pass a cookie of a descriptor and tx_status tells you how many bytes for 
the whole descriptor are still left to be transferred. What you implemented 
tells you how many bytes are still left for the current segment of the 
active descriptor. This will only work fine for descriptors that only have 
one segment. But this will definitely break audio playback using the PL330 
where you have more than one segment per descriptor.


> +		}
> +	}
> +	spin_unlock_irqrestore(&pch->lock, flags);
> +
> +	ret = dma_cookie_status(chan, cookie, txstate);
> +	dma_set_residue(txstate,  pch->transfered);
> +

pch->transfered is always 0?
