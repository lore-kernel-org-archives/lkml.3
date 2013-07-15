Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3GOJuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 05:50:10 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:55015 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754666Ab3GOJuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 05:50:09 -0400
Message-ID: <1373881807.2591.16.camel@x61.thuisdomein>
Subject: Re: [PATCH] ioatdma: silence GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 15 Jul 2013 11:50:07 +0200
In-Reply-To: <1371465315.26299.17.camel@x61.thuisdomein>
References: <1371465315.26299.17.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Jul 2013 09:50:07.0794 (UTC) FILETIME=[B069D920:01CE8140]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 12:35 +0200, Paul Bolle wrote:
> Building dma_v3.o triggers two GCC warnings:
>     drivers/dma/ioat/dma_v3.c: In function ‘__ioat3_prep_pq16_lock’:
>     drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]
>     drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]
> 
> These warnings are caused by pq16_set_src(). It uses "int idx" as an
> index to an eight element array. Changing "idx" to unsigned int silences
> these warnings. Apparently GCC can then determine that "idx" will never
> be negative.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Identical warnings can still be seen in v3.11-rc1. Did anyone had a
chance to look at this patch?


Paul Bolle
> ---
> 0) Compile tested only.
> 
> 1) These warning were introduced in v3.10-rc1. That must have been
> through commit 7727eaa449 ("ioatdma: Adding support for 16 src PQ ops
> and super extended descriptors").
> 
>  drivers/dma/ioat/dma_v3.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index ca6ea9b..b5102da 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -251,7 +251,7 @@ static bool is_bwd_noraid(struct pci_dev *pdev)
>  }
>  
>  static void pq16_set_src(struct ioat_raw_descriptor *desc[3],
> -			dma_addr_t addr, u32 offset, u8 coef, int idx)
> +			dma_addr_t addr, u32 offset, u8 coef, unsigned int idx)
>  {
>  	struct ioat_pq_descriptor *pq = (struct ioat_pq_descriptor *)desc[0];
>  	struct ioat_pq16a_descriptor *pq16 =
> @@ -1180,7 +1180,7 @@ __ioat3_prep_pq16_lock(struct dma_chan *c, enum sum_check_flags *result,
>  	struct ioat_pq_descriptor *pq;
>  	u32 offset = 0;
>  	u8 op;
> -	int i, s, idx, num_descs;
> +	int i, idx, num_descs;
>  
>  	/* this function only handles src_cnt 9 - 16 */
>  	BUG_ON(src_cnt < 9);
> @@ -1206,6 +1206,7 @@ __ioat3_prep_pq16_lock(struct dma_chan *c, enum sum_check_flags *result,
>  	do {
>  		struct ioat_raw_descriptor *descs[4];
>  		size_t xfer_size = min_t(size_t, len, 1 << ioat->xfercap_log);
> +		unsigned int s;
>  
>  		desc = ioat2_get_ring_ent(ioat, idx + i);
>  		pq = desc->pq;

