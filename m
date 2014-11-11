Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaKKNsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:48:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:24088 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaKKNsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:48:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="635054409"
Message-ID: <546213BC.1050204@linux.intel.com>
Date: Tue, 11 Nov 2014 21:48:44 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Feng Wu <feng.wu@intel.com>, gleb@kernel.org, pbonzini@redhat.com,
        dwmw2@infradead.org, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] iommu/vt-d: No need to migrating irq for VT-d Posted-Interrtups
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com> <1415600812-27773-13-git-send-email-feng.wu@intel.com>
In-Reply-To: <1415600812-27773-13-git-send-email-feng.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/11/10 14:26, Feng Wu wrote:
> We don't need to migrate the irqs for VT-d Posted-Interrtups here.
> When 'pst' is set in IRTE, the associated irq will be posted to
> guests instead of interrupt remapping. The destination of the
> interrupt is set in Posted-Interrupts Descriptor, and the migration
> happens during VCPU scheduling.
> 
> Signed-off-by: Feng Wu <feng.wu@intel.com>
> ---
>  drivers/iommu/intel_irq_remapping.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> index 87c02fe..249e2b1 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -1038,6 +1038,13 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
>  	if (get_irte(irq, &irte))
>  		return -EBUSY;
>  
> +	/*
> +	 * If the interrupt is for posting, it is used by guests,
> +	 * we cannot change IRTE here.
> +	 */
> +	if (irte.irq_post_low.pst == 1)
> +		return 0;
Hi Feng,
	You should return some error code instead of 0, otherwise the
irq core will get confused.

> +
>  	err = assign_irq_vector(irq, cfg, mask);
>  	if (err)
>  		return err;
> 
