Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3C0AiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:38:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50417 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212Ab3C0AiL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:38:11 -0400
X-Greylist: delayed 2869 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Mar 2013 20:38:11 EDT
From: Dan Williams <djbw@fb.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] ioatdma: Adding write back descriptor error
 status support for ioatdma 3.3
Thread-Topic: [PATCH 09/10] ioatdma: Adding write back descriptor error
 status support for ioatdma 3.3
Thread-Index: AQHOKnNWaHXr79TyLESflR1Epun8OJi4o8CA
Date: Tue, 26 Mar 2013 23:47:54 +0000
Message-ID: <84A937D219C2B44EB8EA44831ACA1E49171F50DF@PRN-MBX01-3.TheFacebook.com>
In-Reply-To: <20130326224327.15072.96599.stgit@djiang5-linux2.ch.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <518137AA1973AC4EB9A34A58B5B642E6@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-03-26_04:2013-03-26,2013-03-26,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 3/26/13 3:43 PM, "Dave Jiang" <dave.jiang@intel.com> wrote:

>v3.3 provides support for write back descriptor error status. This allows
>reporting of errors in a descriptor field. In supporting this, certain
>errors such as P/Q validation errors no longer halts the channel. The DMA
>engine can continue to execute until the end of the chain and allow
>software
>to report the "errors" up the stack. We are also going to mask those error
>interrupts and handle them when the "chain" has completed at the end.
>
>Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>---
> drivers/dma/ioat/dma_v3.c    |   87
>++++++++++++++++++++++++++++++++++++------
> drivers/dma/ioat/hw.h        |   17 +++++++-
> drivers/dma/ioat/registers.h |    1
> 3 files changed, 90 insertions(+), 15 deletions(-)
>
>diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
>index 230a8bc..83d44f3 100644
>--- a/drivers/dma/ioat/dma_v3.c
>+++ b/drivers/dma/ioat/dma_v3.c
>@@ -498,6 +498,32 @@ static bool ioat3_cleanup_preamble(struct
>ioat_chan_common *chan,
> 	return true;
> }
> 
>+static void desc_get_errstat(struct ioat_ring_ent *desc)
>+{
>+	struct ioat_dma_descriptor *hw = desc->hw;
>+
>+	switch (hw->ctl_f.op) {
>+	case IOAT_OP_PQ_VAL:
>+	case IOAT_OP_PQ_VAL_16S:
>+	{
>+		struct ioat_pq_descriptor *pq = desc->pq;
>+
>+		/* check if there's error written */
>+		if (!pq->dwbes_f.wbes)
>+			return;
>+
>+		if (pq->dwbes_f.p_val_err)
>+			*desc->result |= SUM_CHECK_P_RESULT;
>+
>+		if (pq->dwbes_f.q_val_err)
>+			*desc->result |= SUM_CHECK_Q_RESULT;
>+		return;
>+	}
>+	default:
>+		return;
>+	}
>+}
>+
> /**
>  * __cleanup - reclaim used descriptors
>  * @ioat: channel (ring) to clean
>@@ -535,6 +561,10 @@ static void __cleanup(struct ioat2_dma_chan *ioat,
>dma_addr_t phys_complete)
> 		prefetch(ioat2_get_ring_ent(ioat, idx + i + 1));
> 		desc = ioat2_get_ring_ent(ioat, idx + i);
> 		dump_desc_dbg(ioat, desc);
>+
>+		/* set err stat if we are using dwbes */
>+		desc_get_errstat(desc);
>+
> 		tx = &desc->txd;
> 		if (tx->cookie) {
> 			dma_cookie_complete(tx);
>@@ -580,14 +610,15 @@ static void ioat3_cleanup(struct ioat2_dma_chan
>*ioat)
> {
> 	struct ioat_chan_common *chan = &ioat->base;
> 	u64 phys_complete;
>+	u32 chanerr;
> 
> 	spin_lock_bh(&chan->cleanup_lock);
> 
> 	if (ioat3_cleanup_preamble(chan, &phys_complete))
> 		__cleanup(ioat, phys_complete);
> 
>+	chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
> 	if (is_ioat_halted(*chan->completion)) {
>-		u32 chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
> 
> 		if (chanerr & IOAT_CHANERR_HANDLE_MASK) {
> 			mod_timer(&chan->timer, jiffies + IDLE_TIMEOUT);

This is now incurring a mmio read for every cleanup which somewhat defeats
the point of posting the completion status to memory.  Should be able to
get away with just writel(IOAT_CHANERR_HANDLE_MASK) iff cleanup found came
across an error-writeback.


>@@ -595,6 +626,15 @@ static void ioat3_cleanup(struct ioat2_dma_chan
>*ioat)
> 		}
> 	}
> 
>+	/*
>+	 * with DWBES we must clear the chanerr register at the end of the
>+	 * chain in order to be able to issue the next command.
>+	 */
>+	if (chanerr) {
>+		writel(chanerr & IOAT_CHANERR_HANDLE_MASK,
>+		       chan->reg_base + IOAT_CHANERR_OFFSET);
>+	}
>+

 Does this also mean we need to re-write dmacount?  I.e. are writes to
dmacount ignored while chanerr is non-zero?

