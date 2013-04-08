Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936108Ab3DHOHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:07:54 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:5508 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935913Ab3DHOHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:07:52 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I1432I4015Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1155h)
X-WSS-ID: 0MKXWKR-02-2L7-02
X-M-MSG: 
Message-ID: <5162CF2E.9030304@amd.com>
Date: Mon, 8 Apr 2013 09:07:42 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: <suravee.suthikulpanit@amd.com>
CC: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iommu/amd: Add workaround to propery clearing IOMMU status
 register
References: <1365031144-2543-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1365031144-2543-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,

Do you have any feedback about this patch?

Thanks,

Suravee

On 4/3/2013 6:19 PM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>
> The IOMMU interrupt handling in bottom half must clear the PPR log interrupt
> and event log interrupt bits to re-enable the interrupt. This is done by
> writing 1 to the memory mapped register to clear the bit. Due to hardware bug,
> if the driver tries to clear this bit while the IOMMU hardware also setting
> this bit, the conflict will result with the bit being set. If the interrupt
> handling code does not make sure to clear this bit, subsequent changes in the
> event/PPR logs will no longer generating interrupts, and would result if
> buffer overflow. After clearing the bits, the driver must read back
> the register to verify.
>
> In the current interrupt handling scheme, there are as many threads as
> the number of IOMMUs. Each thread is created and assigned to an IOMMU at
> the time of registering interrupt handlers (request_threaded_irq).
> When an IOMMU HW generates an interrupt, the irq handler (top half) wakes up
> the corresponding thread to process event and PPR logs of all IOMMUs
> starting from the 1st IOMMU.
>
> In the system with multiple IOMMU,this handling scheme complicates the
> synchronization of the IOMMU data structures and status registers as
> there could be multiple threads competing for the same IOMMU while
> the other IOMMU could be left unhandled.
>
> In order to simplify the implementation of the workaround, this patch is
> proposing a different interrupt handling scheme by having each thread only
> managing interrupts of the corresponding IOMMU. This can be achieved by passing
> the struct amd_iommu when registering the interrupt handlers. This structure is
> unique for each IOMMU and can be used by the bottom half thread to identify
> the IOMMU to be handled instead of calling for_each_iommu.  Besides this also
> eliminate the needs to lock the IOMMU for processing event and PPR logs.
>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   drivers/iommu/amd_iommu.c      |   59 ++++++++++++++++++++--------------------
>   drivers/iommu/amd_iommu_init.c |    2 +-
>   2 files changed, 31 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index e5db3e5..3548d63 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -803,12 +803,6 @@ retry:
>   static void iommu_poll_events(struct amd_iommu *iommu)
>   {
>   	u32 head, tail;
> -	unsigned long flags;
> -
> -	/* enable event interrupts again */
> -	writel(MMIO_STATUS_EVT_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
> -
> -	spin_lock_irqsave(&iommu->lock, flags);
>   
>   	head = readl(iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
>   	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
> @@ -819,8 +813,6 @@ static void iommu_poll_events(struct amd_iommu *iommu)
>   	}
>   
>   	writel(head, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
> -
> -	spin_unlock_irqrestore(&iommu->lock, flags);
>   }
>   
>   static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u64 *raw)
> @@ -845,17 +837,11 @@ static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u64 *raw)
>   
>   static void iommu_poll_ppr_log(struct amd_iommu *iommu)
>   {
> -	unsigned long flags;
>   	u32 head, tail;
>   
>   	if (iommu->ppr_log == NULL)
>   		return;
>   
> -	/* enable ppr interrupts again */
> -	writel(MMIO_STATUS_PPR_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
> -
> -	spin_lock_irqsave(&iommu->lock, flags);
> -
>   	head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
>   	tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
>   
> @@ -891,34 +877,49 @@ static void iommu_poll_ppr_log(struct amd_iommu *iommu)
>   		head = (head + PPR_ENTRY_SIZE) % PPR_LOG_SIZE;
>   		writel(head, iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
>   
> -		/*
> -		 * Release iommu->lock because ppr-handling might need to
> -		 * re-acquire it
> -		 */
> -		spin_unlock_irqrestore(&iommu->lock, flags);
> -
>   		/* Handle PPR entry */
>   		iommu_handle_ppr_entry(iommu, entry);
>   
> -		spin_lock_irqsave(&iommu->lock, flags);
> -
>   		/* Refresh ring-buffer information */
>   		head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
>   		tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
>   	}
> -
> -	spin_unlock_irqrestore(&iommu->lock, flags);
>   }
>   
>   irqreturn_t amd_iommu_int_thread(int irq, void *data)
>   {
> -	struct amd_iommu *iommu;
> +	struct amd_iommu *iommu = (struct amd_iommu *) data;
> +	u32 status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
>   
> -	for_each_iommu(iommu) {
> -		iommu_poll_events(iommu);
> -		iommu_poll_ppr_log(iommu);
> -	}
> +	while (status & (MMIO_STATUS_EVT_INT_MASK | MMIO_STATUS_PPR_INT_MASK)) {
> +		if (status & MMIO_STATUS_EVT_INT_MASK) {
> +			pr_devel("AMD-Vi: Processing IOMMU Event Log\n");
> +			iommu_poll_events(iommu);
> +		}
>   
> +		if (status & MMIO_STATUS_PPR_INT_MASK) {
> +			pr_devel("AMD-Vi: Processing IOMMU PPR Log\n");
> +			iommu_poll_ppr_log(iommu);
> +		}
> +
> +		/* Enable EVT and PPR interrupts again */
> +		writel((MMIO_STATUS_EVT_INT_MASK | MMIO_STATUS_PPR_INT_MASK),
> +			iommu->mmio_base + MMIO_STATUS_OFFSET);
> +
> +		/*
> +		 * Hardware bug: When re-enabling interrupt (by writing 1
> +		 * to clear the bit), the hardware might also try to set
> +		 * the interrupt bit in the event status register.
> +		 * In this scenario, the bit will be set, and disable
> +		 * subsequent interrupts.
> +		 *
> +		 * Workaround: The IOMMU driver should read back the
> +		 * status register and check if the interrupt bits are cleared.
> +		 * If not, driver will need to go through the interrupt handler
> +		 * again and re-clear the bits
> +		 */
> +		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
> +	}
>   	return IRQ_HANDLED;
>   }
>   
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index e3c2d74..e4120bb 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -1275,7 +1275,7 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
>   				 amd_iommu_int_handler,
>   				 amd_iommu_int_thread,
>   				 0, "AMD-Vi",
> -				 iommu->dev);
> +				 iommu);
>   
>   	if (r) {
>   		pci_disable_msi(iommu->dev);


