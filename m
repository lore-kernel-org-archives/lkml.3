Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbaJVW7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 18:59:18 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:39818 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812AbaJVW7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 18:59:16 -0400
Date: Wed, 22 Oct 2014 16:59:13 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI/MSI: Remove pci_enable_msix()
Message-ID: <20141022225913.GA4795@google.com>
References: <1412955343-27239-1-git-send-email-agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412955343-27239-1-git-send-email-agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 05:35:43PM +0200, Alexander Gordeev wrote:
> There are no users of pci_enable_msix() function left. Obsolete
> it in favor of pci_enable_msix_range() and pci_enable_msix_exact()
> functions.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: linux-pci@vger.kernel.org

Applied to pci/msi for v3.19, thanks!

> ---
>  Documentation/PCI/PCIEBUS-HOWTO.txt | 15 +++---
>  Documentation/PCI/pci.txt           | 14 +++---
>  drivers/pci/msi.c                   | 91 +++++++++++++++----------------------
>  include/linux/pci.h                 |  4 --
>  4 files changed, 51 insertions(+), 73 deletions(-)
> 
> diff --git a/Documentation/PCI/PCIEBUS-HOWTO.txt b/Documentation/PCI/PCIEBUS-HOWTO.txt
> index 6bd5f37..873a84a 100644
> --- a/Documentation/PCI/PCIEBUS-HOWTO.txt
> +++ b/Documentation/PCI/PCIEBUS-HOWTO.txt
> @@ -190,13 +190,14 @@ in the field interrupt_mode of struct pcie_device.
>  6.2 MSI-X Vector Resources
>  
>  Similar to the MSI a device driver for an MSI-X capable device can
> -call pci_enable_msix to request MSI-X interrupts. All service drivers
> -are not permitted to switch interrupt mode on its device. The PCI
> -Express Port Bus driver is responsible for determining the interrupt
> -mode and this should be transparent to service drivers. Any attempt
> -by service driver to call pci_enable_msix/pci_disable_msix may
> -result unpredictable behavior. Service drivers should use
> -(struct pcie_device*)dev->irq and call request_irq/free_irq.
> +call pci_enable_msix_range to request MSI-X interrupts. All service
> +drivers are not permitted to switch interrupt mode on its device.
> +The PCI Express Port Bus driver is responsible for determining the
> +interrupt mode and this should be transparent to service drivers.
> +Any attempt by service driver to call pci_enable_msix_range or
> +pci_disable_msix may result unpredictable behavior. Service drivers
> +should use (struct pcie_device*)dev->irq and call request_irq or
> +free_irq.
>  
>  6.3 PCI Memory/IO Mapped Regions
>  
> diff --git a/Documentation/PCI/pci.txt b/Documentation/PCI/pci.txt
> index 9518006..eb57f0a 100644
> --- a/Documentation/PCI/pci.txt
> +++ b/Documentation/PCI/pci.txt
> @@ -383,18 +383,18 @@ The fundamental difference between MSI and MSI-X is how multiple
>  "vectors" get allocated. MSI requires contiguous blocks of vectors
>  while MSI-X can allocate several individual ones.
>  
> -MSI capability can be enabled by calling pci_enable_msi() or
> -pci_enable_msix() before calling request_irq(). This causes
> +MSI capability can be enabled by calling pci_enable_msi_range() or
> +pci_enable_msix_range() before calling request_irq(). This causes
>  the PCI support to program CPU vector data into the PCI device
>  capability registers.
>  
>  If your PCI device supports both, try to enable MSI-X first.
>  Only one can be enabled at a time.  Many architectures, chip-sets,
> -or BIOSes do NOT support MSI or MSI-X and the call to pci_enable_msi/msix
> -will fail. This is important to note since many drivers have
> -two (or more) interrupt handlers: one for MSI/MSI-X and another for IRQs.
> -They choose which handler to register with request_irq() based on the
> -return value from pci_enable_msi/msix().
> +or BIOSes do NOT support MSI or MSI-X and the call to pci_enable_msi_range()
> +or pci_enable_msix_range() will fail. This is important to note since many
> +drivers have two (or more) interrupt handlers: one for MSI/MSI-X and another
> +for IRQs. They choose which handler to register with request_irq() based on
> +the return value from pci_enable_msi_range() or pci_enable_msix_range().
>  
>  There are (at least) two really good reasons for using MSI:
>  1) MSI is an exclusive interrupt vector by definition.
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 2f7c92c..0df0ce1 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -903,58 +903,6 @@ int pci_msix_vec_count(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL(pci_msix_vec_count);
>  
> -/**
> - * pci_enable_msix - configure device's MSI-X capability structure
> - * @dev: pointer to the pci_dev data structure of MSI-X device function
> - * @entries: pointer to an array of MSI-X entries
> - * @nvec: number of MSI-X irqs requested for allocation by device driver
> - *
> - * Setup the MSI-X capability structure of device function with the number
> - * of requested irqs upon its software driver call to request for
> - * MSI-X mode enabled on its hardware device function. A return of zero
> - * indicates the successful configuration of MSI-X capability structure
> - * with new allocated MSI-X irqs. A return of < 0 indicates a failure.
> - * Or a return of > 0 indicates that driver request is exceeding the number
> - * of irqs or MSI-X vectors available. Driver should use the returned value to
> - * re-send its request.
> - **/
> -int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
> -{
> -	int nr_entries;
> -	int i, j;
> -
> -	if (!pci_msi_supported(dev, nvec))
> -		return -EINVAL;
> -
> -	if (!entries)
> -		return -EINVAL;
> -
> -	nr_entries = pci_msix_vec_count(dev);
> -	if (nr_entries < 0)
> -		return nr_entries;
> -	if (nvec > nr_entries)
> -		return nr_entries;
> -
> -	/* Check for any invalid entries */
> -	for (i = 0; i < nvec; i++) {
> -		if (entries[i].entry >= nr_entries)
> -			return -EINVAL;		/* invalid entry */
> -		for (j = i + 1; j < nvec; j++) {
> -			if (entries[i].entry == entries[j].entry)
> -				return -EINVAL;	/* duplicate entry */
> -		}
> -	}
> -	WARN_ON(!!dev->msix_enabled);
> -
> -	/* Check whether driver already requested for MSI irq */
> -	if (dev->msi_enabled) {
> -		dev_info(&dev->dev, "can't enable MSI-X (MSI IRQ already assigned)\n");
> -		return -EINVAL;
> -	}
> -	return msix_capability_init(dev, entries, nvec);
> -}
> -EXPORT_SYMBOL(pci_enable_msix);
> -
>  void pci_msix_shutdown(struct pci_dev *dev)
>  {
>  	struct msi_desc *entry;
> @@ -1088,16 +1036,49 @@ EXPORT_SYMBOL(pci_enable_msi_range);
>   * with new allocated MSI-X interrupts.
>   **/
>  int pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
> -			       int minvec, int maxvec)
> +			  int minvec, int maxvec)
>  {
> -	int nvec = maxvec;
> +	int i, j;
> +	int nvec;
>  	int rc;
>  
> +	if (!pci_msi_supported(dev, minvec))
> +		return -EINVAL;
> +
> +	WARN_ON(!!dev->msix_enabled);
> +
> +	/* Check whether driver already requested MSI irqs */
> +	if (dev->msi_enabled) {
> +		dev_info(&dev->dev,
> +			 "can't enable MSI-X (MSI already enabled)\n");
> +		return -EINVAL;
> +	}
> +
>  	if (maxvec < minvec)
>  		return -ERANGE;
> +	else if (!entries)
> +		return -EINVAL;
> +
> +	nvec = pci_msix_vec_count(dev);
> +	if (nvec < 0)
> +		return nvec;
> +	else if (nvec < minvec)
> +		return -EINVAL;
> +	else if (nvec > maxvec)
> +		nvec = maxvec;
> +
> +	/* Check for any invalid entries */
> +	for (i = 0; i < nvec; i++) {
> +		if (entries[i].entry >= nvec)
> +			return -EINVAL;		/* invalid entry */
> +		for (j = i + 1; j < nvec; j++) {
> +			if (entries[i].entry == entries[j].entry)
> +				return -EINVAL;	/* duplicate entry */
> +		}
> +	}
>  
>  	do {
> -		rc = pci_enable_msix(dev, entries, nvec);
> +		rc = msix_capability_init(dev, entries, nvec);
>  		if (rc < 0) {
>  			return rc;
>  		} else if (rc > 0) {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 5be8db4..ad9b5d4 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1197,7 +1197,6 @@ int pci_msi_vec_count(struct pci_dev *dev);
>  void pci_msi_shutdown(struct pci_dev *dev);
>  void pci_disable_msi(struct pci_dev *dev);
>  int pci_msix_vec_count(struct pci_dev *dev);
> -int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec);
>  void pci_msix_shutdown(struct pci_dev *dev);
>  void pci_disable_msix(struct pci_dev *dev);
>  void pci_restore_msi_state(struct pci_dev *dev);
> @@ -1225,9 +1224,6 @@ static inline int pci_msi_vec_count(struct pci_dev *dev) { return -ENOSYS; }
>  static inline void pci_msi_shutdown(struct pci_dev *dev) { }
>  static inline void pci_disable_msi(struct pci_dev *dev) { }
>  static inline int pci_msix_vec_count(struct pci_dev *dev) { return -ENOSYS; }
> -static inline int pci_enable_msix(struct pci_dev *dev,
> -				  struct msix_entry *entries, int nvec)
> -{ return -ENOSYS; }
>  static inline void pci_msix_shutdown(struct pci_dev *dev) { }
>  static inline void pci_disable_msix(struct pci_dev *dev) { }
>  static inline void pci_restore_msi_state(struct pci_dev *dev) { }
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
