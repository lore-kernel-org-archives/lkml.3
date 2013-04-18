Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967566Ab3DRQNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:13:31 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:45252
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967280Ab3DRQNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:13:30 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1155h)
X-WSS-ID: 0MLGL28-01-57C-02
X-M-MSG: 
Message-ID: <51701B9F.10003@amd.com>
Date: Thu, 18 Apr 2013 11:13:19 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 V2] iommu/amd: Add workaround for ERBT1312
References: <1366009666-44792-1-git-send-email-suravee.suthikulpanit@amd.com> <20130418160220.GA4153@8bytes.org>
In-Reply-To: <20130418160220.GA4153@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,

This workaround is required for both event log and ppr log.  Your patch 
is only taking care of the event log.

Suravee

On 4/18/2013 11:02 AM, Joerg Roedel wrote:
> On Mon, Apr 15, 2013 at 02:07:46AM -0500, suravee.suthikulpanit@amd.com wrote:
>>   drivers/iommu/amd_iommu.c |  145 +++++++++++++++++++++++++++++----------------
> That is way too much for a simple erratum workaround, and too much for a
> stable backport. I queued the patch below instead, which has a much
> smaller diff and does the same. Please rebase your second patch on-top
> of this one and send it again.
>
>  From 4ba052102863da02db79c03d2483b6ad905737ad Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joro@8bytes.org>
> Date: Thu, 18 Apr 2013 17:55:04 +0200
> Subject: [PATCH] iommu/amd: Workaround for ERBT1312
>
> Work around an IOMMU  hardware bug where clearing the
> EVT_INT bit in the status register may race with the
> hardware trying to set it again. When not handled the bit
> might not be cleared and we lose all future event
> interrupts.
>
> Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> ---
>   drivers/iommu/amd_iommu.c |   17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index f42793d..de5ae4b 100644
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


