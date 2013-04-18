Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967807Ab3DRRAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:00:14 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:25919
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967753Ab3DRRAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:00:08 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I1432I1447Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1155h)
X-WSS-ID: 0MLGN7Y-01-8DX-02
X-M-MSG: 
Message-ID: <5170268E.8080706@amd.com>
Date: Thu, 18 Apr 2013 11:59:58 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 V2] iommu/amd: Add workaround for ERBT1312
References: <1366009666-44792-1-git-send-email-suravee.suthikulpanit@amd.com> <20130418160220.GA4153@8bytes.org> <51701B9F.10003@amd.com> <20130418162856.GA13891@8bytes.org>
In-Reply-To: <20130418162856.GA13891@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,

One last concern I have for this patch is the case when we re-enable the 
interrupt, then another interrupt happens while we processing the log 
and set the bit.  If the interrupt thread doesn't check this right 
before the thread exits the handler.  We could still end up leaving the 
interrupt disabled.

Suravee

On 4/18/2013 11:28 AM, Joerg Roedel wrote:
> On Thu, Apr 18, 2013 at 11:13:19AM -0500, Suravee Suthikulanit wrote:
>> This workaround is required for both event log and ppr log.  Your
>> patch is only taking care of the event log.
> Right, thanks for the notice. Here is the updated patch.
>
>  From cebe04596989c4b9001e2c1571c4fb219ea37b99 Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joro@8bytes.org>
> Date: Thu, 18 Apr 2013 17:55:04 +0200
> Subject: [PATCH] iommu/amd: Workaround for ERBT1312
>
> Work around an IOMMU  hardware bug where clearing the
> EVT_INT or PPR_INT bit in the status register may race with
> the hardware trying to set it again. When not handled the
> bit might not be cleared and we lose all future event or ppr
> interrupts.
>
> Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> ---
>   drivers/iommu/amd_iommu.c |   34 ++++++++++++++++++++++++++--------
>   1 file changed, 26 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index f42793d..27792f8 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -700,14 +700,23 @@ retry:
>   
>   static void iommu_poll_events(struct amd_iommu *iommu)
>   {
> -	u32 head, tail;
> +	u32 head, tail, status;
>   	unsigned long flags;
>   
> -	/* enable event interrupts again */
> -	writel(MMIO_STATUS_EVT_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
> -
>   	spin_lock_irqsave(&iommu->lock, flags);
>   
> +	/* enable event interrupts again */
> +	do {
> +		/*
> +		 * Workaround for Erratum ERBT1312
> +		 * Clearing the EVT_INT bit may race in the hardware, so read
> +		 * it again and make sure it was really cleared
> +		 */
> +		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
> +		writel(MMIO_STATUS_EVT_INT_MASK,
> +		       iommu->mmio_base + MMIO_STATUS_OFFSET);
> +	} while (status & MMIO_STATUS_EVT_INT_MASK);
> +
>   	head = readl(iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
>   	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
>   
> @@ -744,16 +753,25 @@ static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u64 *raw)
>   static void iommu_poll_ppr_log(struct amd_iommu *iommu)
>   {
>   	unsigned long flags;
> -	u32 head, tail;
> +	u32 head, tail, status;
>   
>   	if (iommu->ppr_log == NULL)
>   		return;
>   
> -	/* enable ppr interrupts again */
> -	writel(MMIO_STATUS_PPR_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
> -
>   	spin_lock_irqsave(&iommu->lock, flags);
>   
> +	/* enable ppr interrupts again */
> +	do {
> +		/*
> +		 * Workaround for Erratum ERBT1312
> +		 * Clearing the PPR_INT bit may race in the hardware, so read
> +		 * it again and make sure it was really cleared
> +		 */
> +		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
> +		writel(MMIO_STATUS_PPR_INT_MASK,
> +		       iommu->mmio_base + MMIO_STATUS_OFFSET);
> +	} while (status & MMIO_STATUS_PPR_INT_MASK);
> +
>   	head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
>   	tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
>   


