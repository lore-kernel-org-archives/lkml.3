Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbaCDOcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:32:06 -0500
Received: from 8bytes.org ([85.214.48.195]:58378 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757289AbaCDOcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:32:03 -0500
Date: Tue, 4 Mar 2014 15:31:58 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH v2] IOMMU: enhance dmar to support device hotplug
Message-ID: <20140304143158.GC2799@8bytes.org>
References: <1385022116-228-1-git-send-email-wangyijing@huawei.com>
 <1385022116-228-2-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385022116-228-2-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Mar  4 15:32:01 2014
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5315e3e120861151684529
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 04:21:56PM +0800, Yijing Wang wrote:
> @@ -3641,21 +3681,42 @@ static int device_notifier(struct notifier_block *nb,
>  	struct device *dev = data;
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct dmar_domain *domain;
> +	struct dmar_device *dmar_dev;
> +	struct dmar_drhd_unit *drhd;
>  
> -	if (iommu_no_mapping(dev))
> -		return 0;
> -
> -	domain = find_domain(pdev);
> -	if (!domain)
> -		return 0;
> +	switch (action) {
> +	case BUS_NOTIFY_ADD_DEVICE:
> +		for_each_drhd_unit(drhd)
> +			list_for_each_entry(dmar_dev, &drhd->devices, list)
> +				if (dmar_dev->segment == pci_domain_nr(pdev->bus)
> +					&& dmar_dev->bus == pdev->bus->number
> +					&& dmar_dev->devfn == pdev->devfn)
> +					dmar_dev->pdev = pci_dev_get(pdev);
> +		break;
> +	case BUS_NOTIFY_DEL_DEVICE:
> +		for_each_drhd_unit(drhd)
> +			list_for_each_entry(dmar_dev, &drhd->devices, list)
> +				if (dmar_dev->pdev == pdev) {
> +					pci_dev_put(pdev);
> +					dmar_dev->pdev = NULL;
> +				}

How is that synchronized with other users of this dmar_dev structure.
Could it happen that you drop the device reference while other parts of
the driver still use it?


	Joerg


