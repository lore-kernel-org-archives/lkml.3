Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3LRAdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 19:33:18 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60657 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab3LRAdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 19:33:16 -0500
Date: Tue, 17 Dec 2013 17:33:13 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v4 6/9] PCI/MSI: Factor out pci_get_msi_vec_count()
 interface
Message-ID: <20131218003313.GB15119@google.com>
References: <cover.1387140921.git.agordeev@redhat.com>
 <d0d8cd19befa8757faf7660fd3ae619945b2cde4.1387140921.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0d8cd19befa8757faf7660fd3ae619945b2cde4.1387140921.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 09:34:59AM +0100, Alexander Gordeev wrote:
> Device drivers can use this interface to obtain maximum number
> of MSI interrupts the device supports and use that number i.e.
> in a following call to pci_enable_msi_block() interface.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Reviewed-by: Tejun Heo <tj@kernel.org>
> ---
>  Documentation/PCI/MSI-HOWTO.txt |   15 ++++++++++++++
>  drivers/pci/msi.c               |   41 +++++++++++++++++++++++++++++++-------
>  include/linux/pci.h             |    6 +++++
>  3 files changed, 54 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
> index a4d174e..c03b815 100644
> --- a/Documentation/PCI/MSI-HOWTO.txt
> +++ b/Documentation/PCI/MSI-HOWTO.txt
> @@ -169,6 +169,21 @@ on any interrupt for which it previously called request_irq().
>  Failure to do so results in a BUG_ON(), leaving the device with
>  MSI enabled and thus leaking its vector.
>  
> +4.2.5 pci_get_msi_vec_count
> +
> +int pci_get_msi_vec_count(struct pci_dev *dev)

What would you think of "pci_msi_vec_count()" or "pci_msi_vector_count()"
instead?  The "get" doesn't really seem necessary, and we often use "get"
to indicate acquiring a reference (though it's obvious that doesn't apply
here).

Bjorn

> +This function could be used to retrieve the number of MSI vectors the
> +device requested (via the Multiple Message Capable register). The MSI
> +specification only allows the returned value to be a power of two,
> +up to a maximum of 2^5 (32).
> +
> +If this function returns a negative number, it indicates the device is
> +not capable of sending MSIs.
> +
> +If this function returns a positive number, it indicates the maximum
> +number of MSI interrupt vectors that could be allocated.
> +
>  4.3 Using MSI-X
>  
>  The MSI-X capability is much more flexible than the MSI capability.
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index c0e2259..8915edb 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -834,6 +834,31 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
>  }
>  
>  /**
> + * pci_get_msi_vec_count - Return the number of MSI vectors a device can send
> + * @dev: device to report about
> + *
> + * This function returns the number of MSI vectors a device requested via
> + * Multiple Message Capable register. It returns a negative errno if the
> + * device is not capable sending MSI interrupts. Otherwise, the call succeeds
> + * and returns a power of two, up to a maximum of 2^5 (32), according to the
> + * MSI specification.
> + **/
> +int pci_get_msi_vec_count(struct pci_dev *dev)
> +{
> +	int ret;
> +	u16 msgctl;
> +
> +	if (!dev->msi_cap)
> +		return -EINVAL;
> +
> +	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
> +	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(pci_get_msi_vec_count);
> +
> +/**
>   * pci_enable_msi_block - configure device's MSI capability structure
>   * @dev: device to configure
>   * @nvec: number of interrupts to configure
> @@ -849,13 +874,13 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
>  int pci_enable_msi_block(struct pci_dev *dev, int nvec)
>  {
>  	int status, maxvec;
> -	u16 msgctl;
>  
> -	if (!dev->msi_cap || dev->current_state != PCI_D0)
> +	if (dev->current_state != PCI_D0)
>  		return -EINVAL;
>  
> -	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
> -	maxvec = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
> +	maxvec = pci_get_msi_vec_count(dev);
> +	if (maxvec < 0)
> +		return maxvec;
>  	if (nvec > maxvec)
>  		return maxvec;
>  
> @@ -880,13 +905,13 @@ EXPORT_SYMBOL(pci_enable_msi_block);
>  int pci_enable_msi_block_auto(struct pci_dev *dev, int *maxvec)
>  {
>  	int ret, nvec;
> -	u16 msgctl;
>  
> -	if (!dev->msi_cap || dev->current_state != PCI_D0)
> +	if (dev->current_state != PCI_D0)
>  		return -EINVAL;
>  
> -	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
> -	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
> +	ret = pci_get_msi_vec_count(dev);
> +	if (ret < 0)
> +		return ret;
>  
>  	if (maxvec)
>  		*maxvec = ret;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 8cf7b15..997751d 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1154,6 +1154,11 @@ struct msix_entry {
>  
>  
>  #ifndef CONFIG_PCI_MSI
> +static inline int pci_get_msi_vec_count(struct pci_dev *dev)
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline int pci_enable_msi_block(struct pci_dev *dev, int nvec)
>  {
>  	return -ENOSYS;
> @@ -1195,6 +1200,7 @@ static inline int pci_msi_enabled(void)
>  	return 0;
>  }
>  #else
> +int pci_get_msi_vec_count(struct pci_dev *dev);
>  int pci_enable_msi_block(struct pci_dev *dev, int nvec);
>  int pci_enable_msi_block_auto(struct pci_dev *dev, int *maxvec);
>  void pci_msi_shutdown(struct pci_dev *dev);
> -- 
> 1.7.7.6
> 
