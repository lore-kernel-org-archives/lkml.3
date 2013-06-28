Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3F1QPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:15:34 -0400
Received: from mout3.freenet.de ([195.4.92.93]:54338 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab3F1QPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:15:33 -0400
Date: Fri, 28 Jun 2013 18:11:36 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ 102/127] iommu/amd: Workaround for ERBT1312
Message-ID: <20130628181136.52d00e9c@dualc.maya.org>
In-Reply-To: <lhtB1-q1-53@gated-at.bofh.it>
References: <lhtAZ-q1-5@gated-at.bofh.it> <lhtB1-q1-53@gated-at.bofh.it>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joerg, hello Alex,

the subsequent patch and the patch "iommu/amd: Re-enable IOMMU event log
interrupt after handling." 925fe08bce38d1ff052fe2209b9e2b8d5fbb7f98
spread /var/log/messages with the following line (> 700 lines/second)
right after loading vfio:

AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.0 domain=0x0000 address=0x000000fdf9103300 flags=0x0600]

lspci -vvvs 0:14.0
00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus Controller (rev 42)
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-


Besides the enormous pollution I couldn't see any malfunction at all.
At first, I didn't realised it at all (-> the SSD was fast enough to
cover it silently). I saw it the first time I rebooted because X didn't start any more because
the /var partition was completely full. 

I removed the two mentioned patches and all is working
fine again as before.

Any idea?


Thanks,
kind regards,
Andreas


Greg Kroah-Hartman wrote:
> 3.9-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Joerg Roedel <joro@8bytes.org>
> 
> commit d3263bc29706e42f74d8800807c2dedf320d77f1 upstream.
> 
> Work around an IOMMU  hardware bug where clearing the
> EVT_INT or PPR_INT bit in the status register may race with
> the hardware trying to set it again. When not handled the
> bit might not be cleared and we lose all future event or ppr
> interrupts.
> 
> Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/iommu/amd_iommu.c |   34 ++++++++++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 8 deletions(-)
> 
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -700,14 +700,23 @@ retry:
>  
>  static void iommu_poll_events(struct amd_iommu *iommu)
>  {
> -	u32 head, tail;
> +	u32 head, tail, status;
>  	unsigned long flags;
>  
> -	/* enable event interrupts again */
> -	writel(MMIO_STATUS_EVT_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
> -
>  	spin_lock_irqsave(&iommu->lock, flags);
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
>  	head = readl(iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
>  	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
>  
> @@ -744,16 +753,25 @@ static void iommu_handle_ppr_entry(struc
>  static void iommu_poll_ppr_log(struct amd_iommu *iommu)
>  {
>  	unsigned long flags;
> -	u32 head, tail;
> +	u32 head, tail, status;
>  
>  	if (iommu->ppr_log == NULL)
>  		return;
>  
> -	/* enable ppr interrupts again */
> -	writel(MMIO_STATUS_PPR_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
> -
>  	spin_lock_irqsave(&iommu->lock, flags);
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
>  	head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
>  	tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
>  
