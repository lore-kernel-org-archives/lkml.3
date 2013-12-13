Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3LMPdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:33:44 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34270 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3LMPdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:33:43 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-24-52ab28d48914
Message-id: <52AB28D3.8080500@samsung.com>
Date: Fri, 13 Dec 2013 16:33:39 +0100
From: Lukasz Czerwinski <l.czerwinski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: "djbw@fb.com" <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC PATCH] dma: pl330: Change pl330_tx_status()
References: <1386587966-27635-1-git-send-email-l.czerwinski@samsung.com>
 <52A5B0FA.901@metafoo.de>
In-reply-to: <52A5B0FA.901@metafoo.de>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xK7pXNFYHGWzYbWOxuf8Bm8WSyfNZ
	LS7vmsNmsfbIXXaLw2/aWR1YPSY2v2P3WPLmEKtH35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVw
	ZTS0HGMtaFWpeLNhLUsD43mZLkZODgkBE4kJTfvYIGwxiQv31gPZXBxCAksZJW42nGQCSQgJ
	fGKUaH6tA2LzCmhJzNt1mh3EZhFQlVh9czJYDZuAkcSst4eZQWxRgQiJo6ufsULUC0r8mHyP
	BcQWEdCQ+P9mEjvIAmaBfYwSk5YvAdssLGAr8XbvNkaIZSkSN/ZdBBrKwcEpoCaxvE0YJMws
	YC2xchJECbOAvMTmNW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vO
	z93ECAnjrzsYlx6zOsQowMGoxMN7k3t1kBBrYllxZe4hRgkOZiUR3hBVoBBvSmJlVWpRfnxR
	aU5q8SFGJg5OqQZG89+LhO1zc2I9e3INll11Dex95XWbk8mixzylxT+w++TuuTXfl2ektGx5
	pFx3331il+xuD0vHfgZGrQoBq+1Fu0Q6Fr6I8DNpMpsn0uUiPtdla7H4M+X2L8q7ciVOXbA5
	fIvfd9LV6N37T92eFXhPa97zuWUpNz++1Khb8P38/tKT155bv7yqxFKckWioxVxUnAgA9VO7
	9EECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 01:00 PM, Lars-Peter Clausen wrote:
> On 12/09/2013 12:19 PM, Lukasz Czerwinski wrote:
>> This patch adds possibility to read status of unfinished transfers
>> before termination.
>>
>> Signed-off-by: Lukasz Czerwinski <l.czerwinski@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>
>> I tested patch with Exynos4 board. This is only proof of concept.
>> Any comments are welcome.
>
> The patch does not look as if it is going to work correctly. And I think
> that this can't be implemented correctly with the current structure of the
> driver (at least not without jumping through a couple of hoops). I do have a
> couple of WIP patches that restructure the driver and then implement residue
> reporting on top of it.
>
>>

Thanks for your comments.

I will be waiting for your patch series then I will implement residue 
reporting in proper way.

br
Lukasz

>> Thanks
>> Lukasz
>>
>>   drivers/dma/pl330.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 60 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
>> index 24f8ae3..c88c36e 100644
>> --- a/drivers/dma/pl330.c
>> +++ b/drivers/dma/pl330.c
>> @@ -566,6 +566,7 @@ struct dma_pl330_chan {
>>   	/* For D-to-M and M-to-D channels */
>>   	int burst_sz; /* the peripheral fifo width */
>>   	int burst_len; /* the number of burst */
>> +	int transfered;
>
> This is always set to 0.
>
>>   	dma_addr_t fifo_addr;
>>
>>   	/* for cyclic capability */
>> @@ -602,6 +603,9 @@ struct dma_pl330_desc {
>>
>>   	enum desc_status status;
>>
>> +	int bytes_requested;
>> +	int direction;
>> +
>>   	/* The channel which currently holds this desc */
>>   	struct dma_pl330_chan *pchan;
>>   };
>> @@ -2366,6 +2370,29 @@ static int pl330_alloc_chan_resources(struct dma_chan *chan)
>>   	return 1;
>>   }
>>
>> +int pl330_get_current_xferred_count(struct dma_pl330_chan *pch,
>> +		struct dma_pl330_desc *desc)
>> +{
>> +	u32 val, addr;
>> +	struct pl330_thread *thrd = pch->pl330_chid;
>> +	void __iomem *regs = thrd->dmac->pinfo->base;
>> +
>> +	val = addr = 0;
>> +	switch (desc->direction) {
>> +	case DMA_MEM_TO_DEV:
>> +		val = readl(regs + SA(thrd->id));
>> +		addr = desc->px.src_addr;
>> +		break;
>> +	case DMA_DEV_TO_MEM:
>> +		val = readl(regs + DA(thrd->id));
>> +		addr = desc->px.dst_addr;
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +	return val - addr;
>> +}
>> +
>>   static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned long arg)
>>   {
>>   	struct dma_pl330_chan *pch = to_pchan(chan);
>> @@ -2446,7 +2473,33 @@ static enum dma_status
>>   pl330_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
>>   		 struct dma_tx_state *txstate)
>>   {
>> -	return dma_cookie_status(chan, cookie, txstate);
>> +	enum dma_status ret;
>> +	unsigned long flags;
>> +	struct dma_pl330_desc *desc;
>> +	struct dma_pl330_chan *pch = to_pchan(chan);
>> +	unsigned int bytes_transferred;
>> +	unsigned int residual;
>> +
>> +	/* Check in pending list */
>> +	spin_lock_irqsave(&pch->lock, flags);
>> +	list_for_each_entry(desc, &pch->work_list, node) {
>> +		if (desc->txd.cookie == cookie) {
>> +			bytes_transferred =
>> +				pl330_get_current_xferred_count(pch, desc);
>
> pl330_get_current_xferred_count() will only return the correct result if it
> is called for the currently active transfer.
>
> And then there is also the issue that the driver creates multiple internal
> descriptors for each segment in the transfer. Each of these descriptors gets
> different cookie. pl330_tx_submit() returns the cookie to the descriptor to
> the first segment in the transfer. This means if you pass that cookie to
> pl330_tx_status() you'll only get the residue for the first segment and not
> for the whole transfer, as it is supposed to be.
>
>> +			residual =  desc->bytes_requested -
>> +				bytes_transferred % desc->bytes_requested;
>
> If bytes_transferred % desc->bytes_requested != bytes_transferred there is a
> bug somewhere.
>
>> +			dma_set_residue(txstate, residual);
>> +			ret = desc->status;
>> +			spin_unlock_irqrestore(&pch->lock, flags);
>> +			return ret;
>> +		}
>> +	}
>> +	spin_unlock_irqrestore(&pch->lock, flags);
>> +
>> +	ret = dma_cookie_status(chan, cookie, txstate);
>> +	dma_set_residue(txstate,  pch->transfered);
>> +
>> +	return ret;
>>   }
>>
> [...]
> .
>

  * English - detected
  * Polish

  * Polish

  <javascript:void(0);>
