Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaGNCMN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 22:12:13 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:2252 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaGNCMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 22:12:05 -0400
Message-ID: <53C33C6D.8020103@huawei.com>
Date: Mon, 14 Jul 2014 10:11:57 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, <linux-kernel@vger.kernel.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/2] PCI/MSI: Remove arch_msi_check_device()
References: <cover.1405160163.git.agordeev@redhat.com> <1005232855c3af2c0c669818ee63be445389b6ad.1405160163.git.agordeev@redhat.com>
In-Reply-To: <1005232855c3af2c0c669818ee63be445389b6ad.1405160163.git.agordeev@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /**
> - * pci_msi_check_device - check whether MSI may be enabled on a device
> + * msi_check_device - check whether MSI may be enabled on a device
>   * @dev: pointer to the pci_dev data structure of MSI device function
>   * @nvec: how many MSIs have been requested ?
> - * @type: are we checking for MSI or MSI-X ?
>   *
>   * Look at global flags, the device itself, and its parent buses
>   * to determine if MSI/-X are supported for the device. If MSI/-X is
>   * supported return 0, else return an error code.
>   **/
> -static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
> +static int msi_check_device(struct pci_dev *dev, int nvec)
>  {
>  	struct pci_bus *bus;
> -	int ret;
>  
>  	/* MSI must be globally enabled and supported by the device */
> -	if (!pci_msi_enable || !dev || dev->no_msi)
> +	if (!pci_msi_enable)
> +		return -EINVAL;
> +
> +	if (!dev || dev->no_msi || dev->current_state != PCI_D0)
>  		return -EINVAL;
>  
>  	/*
> @@ -846,10 +837,6 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
>  		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
>  			return -EINVAL;
>  
> -	ret = arch_msi_check_device(dev, nvec, type);
> -	if (ret)
> -		return ret;
> -

Move the arch_msi_check_device() into arch_msi_setup_irq(), make we can not detect whether the device in this platform
supports MSI or MSI-X aeap. If we delay this, maybe we will do a lot unnecessary working for MSI/MSI-X setup.

Thanks!
Yijing.

>  	return 0;
>  }
>  
> @@ -954,13 +941,13 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
>  	int status, nr_entries;
>  	int i, j;
>  
> -	if (!entries || !dev->msix_cap || dev->current_state != PCI_D0)
> -		return -EINVAL;
> -
> -	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSIX);
> +	status = msi_check_device(dev, nvec);
>  	if (status)
>  		return status;
>  
> +	if (!entries)
> +		return -EINVAL;
> +
>  	nr_entries = pci_msix_vec_count(dev);
>  	if (nr_entries < 0)
>  		return nr_entries;
> @@ -1085,8 +1072,9 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
>  	int nvec;
>  	int rc;
>  
> -	if (dev->current_state != PCI_D0)
> -		return -EINVAL;
> +	rc = msi_check_device(dev, minvec);
> +	if (rc)
> +		return rc;
>  
>  	WARN_ON(!!dev->msi_enabled);
>  
> @@ -1109,17 +1097,6 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
>  		nvec = maxvec;
>  
>  	do {
> -		rc = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSI);
> -		if (rc < 0) {
> -			return rc;
> -		} else if (rc > 0) {
> -			if (rc < minvec)
> -				return -ENOSPC;
> -			nvec = rc;
> -		}
> -	} while (rc);
> -
> -	do {
>  		rc = msi_capability_init(dev, nvec);
>  		if (rc < 0) {
>  			return rc;
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index 92a2f99..3b873bc 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -59,7 +59,6 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
>  void arch_teardown_msi_irq(unsigned int irq);
>  int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
>  void arch_teardown_msi_irqs(struct pci_dev *dev);
> -int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
>  void arch_restore_msi_irqs(struct pci_dev *dev);
>  
>  void default_teardown_msi_irqs(struct pci_dev *dev);
> @@ -76,8 +75,6 @@ struct msi_chip {
>  	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
>  			 struct msi_desc *desc);
>  	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
> -	int (*check_device)(struct msi_chip *chip, struct pci_dev *dev,
> -			    int nvec, int type);
>  };
>  
>  #endif /* LINUX_MSI_H */
> 


-- 
Thanks!
Yijing

