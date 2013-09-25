Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab3IYQpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:45:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab3IYQps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:45:48 -0400
Message-ID: <1380127533.3030.319.camel@ul30vt.home>
Subject: Re: [PATCH 2/7] iommu: add api to get iommu_domain of a device
From: Alex Williamson <alex.williamson@redhat.com>
To: Bharat Bhushan <r65777@freescale.com>
Cc: joro@8bytes.org, benh@kernel.crashing.org, galak@kernel.crashing.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, agraf@suse.de, scottwood@freescale.com,
        iommu@lists.linux-foundation.org,
        Bharat Bhushan <Bharat.Bhushan@freescale.com>
Date: Wed, 25 Sep 2013 10:45:33 -0600
In-Reply-To: <1379575763-2091-3-git-send-email-Bharat.Bhushan@freescale.com>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1379575763-2091-3-git-send-email-Bharat.Bhushan@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 12:59 +0530, Bharat Bhushan wrote:
> This api return the iommu domain to which the device is attached.
> The iommu_domain is required for making API calls related to iommu.
> Follow up patches which use this API to know iommu maping.
> 
> Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
> ---
>  drivers/iommu/iommu.c |   10 ++++++++++
>  include/linux/iommu.h |    7 +++++++
>  2 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index fbe9ca7..6ac5f50 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -696,6 +696,16 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(iommu_detach_device);
>  
> +struct iommu_domain *iommu_get_dev_domain(struct device *dev)
> +{
> +	struct iommu_ops *ops = dev->bus->iommu_ops;
> +
> +	if (unlikely(ops == NULL || ops->get_dev_iommu_domain == NULL))
> +		return NULL;
> +
> +	return ops->get_dev_iommu_domain(dev);
> +}
> +EXPORT_SYMBOL_GPL(iommu_get_dev_domain);

What prevents this from racing iommu_domain_free()?  There's no
references acquired, so there's no reason for the caller to assume the
pointer is valid.

>  /*
>   * IOMMU groups are really the natrual working unit of the IOMMU, but
>   * the IOMMU API works on domains and devices.  Bridge that gap by
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 7ea319e..fa046bd 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -127,6 +127,7 @@ struct iommu_ops {
>  	int (*domain_set_windows)(struct iommu_domain *domain, u32 w_count);
>  	/* Get the numer of window per domain */
>  	u32 (*domain_get_windows)(struct iommu_domain *domain);
> +	struct iommu_domain *(*get_dev_iommu_domain)(struct device *dev);
>  
>  	unsigned long pgsize_bitmap;
>  };
> @@ -190,6 +191,7 @@ extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
>  				      phys_addr_t offset, u64 size,
>  				      int prot);
>  extern void iommu_domain_window_disable(struct iommu_domain *domain, u32 wnd_nr);
> +extern struct iommu_domain *iommu_get_dev_domain(struct device *dev);
>  /**
>   * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
>   * @domain: the iommu domain where the fault has happened
> @@ -284,6 +286,11 @@ static inline void iommu_domain_window_disable(struct iommu_domain *domain,
>  {
>  }
>  
> +static inline struct iommu_domain *iommu_get_dev_domain(struct device *dev)
> +{
> +	return NULL;
> +}
> +
>  static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova)
>  {
>  	return 0;



