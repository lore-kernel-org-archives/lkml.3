Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3CZXzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:55:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:14685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab3CZXzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="276376344"
Message-ID: <51523564.30605@intel.com>
Date: Tue, 26 Mar 2013 16:55:16 -0700
From: Dave Jiang <dave.jiang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Dan Williams <djbw@fb.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] ioatdma: Adding write back descriptor error status
 support for ioatdma 3.3
References: <84A937D219C2B44EB8EA44831ACA1E49171F50DF@PRN-MBX01-3.TheFacebook.com>
In-Reply-To: <84A937D219C2B44EB8EA44831ACA1E49171F50DF@PRN-MBX01-3.TheFacebook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 04:47 PM, Dan Williams wrote:
>
> On 3/26/13 3:43 PM, "Dave Jiang" <dave.jiang@intel.com> wrote:
>
>> v3.3 provides support for write back descriptor error status. This allows
>> reporting of errors in a descriptor field. In supporting this, certain
>> errors such as P/Q validation errors no longer halts the channel. The DMA
>> engine can continue to execute until the end of the chain and allow
>> software
>> to report the "errors" up the stack. We are also going to mask those error
>> interrupts and handle them when the "chain" has completed at the end.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>> drivers/dma/ioat/dma_v3.c    |   87
>> ++++++++++++++++++++++++++++++++++++------
>> drivers/dma/ioat/hw.h        |   17 +++++++-
>> drivers/dma/ioat/registers.h |    1
>> 3 files changed, 90 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
>> index 230a8bc..83d44f3 100644
>> --- a/drivers/dma/ioat/dma_v3.c
>> +++ b/drivers/dma/ioat/dma_v3.c
>> @@ -498,6 +498,32 @@ static bool ioat3_cleanup_preamble(struct
>> ioat_chan_common *chan,
>> 	return true;
>> }
>>
>> +static void desc_get_errstat(struct ioat_ring_ent *desc)
>> +{
>> +	struct ioat_dma_descriptor *hw = desc->hw;
>> +
>> +	switch (hw->ctl_f.op) {
>> +	case IOAT_OP_PQ_VAL:
>> +	case IOAT_OP_PQ_VAL_16S:
>> +	{
>> +		struct ioat_pq_descriptor *pq = desc->pq;
>> +
>> +		/* check if there's error written */
>> +		if (!pq->dwbes_f.wbes)
>> +			return;
>> +
>> +		if (pq->dwbes_f.p_val_err)
>> +			*desc->result |= SUM_CHECK_P_RESULT;
>> +
>> +		if (pq->dwbes_f.q_val_err)
>> +			*desc->result |= SUM_CHECK_Q_RESULT;
>> +		return;
>> +	}
>> +	default:
>> +		return;
>> +	}
>> +}
>> +
>> /**
>>   * __cleanup - reclaim used descriptors
>>   * @ioat: channel (ring) to clean
>> @@ -535,6 +561,10 @@ static void __cleanup(struct ioat2_dma_chan *ioat,
>> dma_addr_t phys_complete)
>> 		prefetch(ioat2_get_ring_ent(ioat, idx + i + 1));
>> 		desc = ioat2_get_ring_ent(ioat, idx + i);
>> 		dump_desc_dbg(ioat, desc);
>> +
>> +		/* set err stat if we are using dwbes */
>> +		desc_get_errstat(desc);
>> +
>> 		tx = &desc->txd;
>> 		if (tx->cookie) {
>> 			dma_cookie_complete(tx);
>> @@ -580,14 +610,15 @@ static void ioat3_cleanup(struct ioat2_dma_chan
>> *ioat)
>> {
>> 	struct ioat_chan_common *chan = &ioat->base;
>> 	u64 phys_complete;
>> +	u32 chanerr;
>>
>> 	spin_lock_bh(&chan->cleanup_lock);
>>
>> 	if (ioat3_cleanup_preamble(chan, &phys_complete))
>> 		__cleanup(ioat, phys_complete);
>>
>> +	chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
>> 	if (is_ioat_halted(*chan->completion)) {
>> -		u32 chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
>>
>> 		if (chanerr & IOAT_CHANERR_HANDLE_MASK) {
>> 			mod_timer(&chan->timer, jiffies + IDLE_TIMEOUT);
> This is now incurring a mmio read for every cleanup which somewhat defeats
> the point of posting the completion status to memory.  Should be able to
> get away with just writel(IOAT_CHANERR_HANDLE_MASK) iff cleanup found came
> across an error-writeback.
Ok I'll fix that.

>
>
>> @@ -595,6 +626,15 @@ static void ioat3_cleanup(struct ioat2_dma_chan
>> *ioat)
>> 		}
>> 	}
>>
>> +	/*
>> +	 * with DWBES we must clear the chanerr register at the end of the
>> +	 * chain in order to be able to issue the next command.
>> +	 */
>> +	if (chanerr) {
>> +		writel(chanerr & IOAT_CHANERR_HANDLE_MASK,
>> +		       chan->reg_base + IOAT_CHANERR_OFFSET);
>> +	}
>> +
>   Does this also mean we need to re-write dmacount?  I.e. are writes to
> dmacount ignored while chanerr is non-zero?
>
I don't believe so. At least that hasn't been an issue with testing. I 
have asked them to remove that "feature" with future silicon.
