Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab3LJXIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:08:54 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:52810 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3LJXIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:08:51 -0500
Date: Tue, 10 Dec 2013 16:08:47 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 10/11] PCI/MSI: Convert pci_msix_table_size() to a
 public interface
Message-ID: <20131210230847.GG4699@google.com>
References: <cover.1385399393.git.agordeev@redhat.com>
 <4c879b0928ded8b4c9d2fab3fc413b98d34d8c7c.1385399393.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c879b0928ded8b4c9d2fab3fc413b98d34d8c7c.1385399393.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:09:59AM +0100, Alexander Gordeev wrote:
> Make pci_msix_table_size() function to return a negative errno
> if device does not support MSI-X interrupts. After this update
> pci_msix_table_size() can fail and callers must always check
> the returned value.
> 
> This update is needed to create a consistent MSI-X counterpart
> for pci_get_msi_cap() MSI interface. Device drivers can use this
> function to obtain maximum number of MSI-X interrupts the device
> supports and i.e. use that number in a following call to
> pci_enable_msix() interface.

If pci_msix_table_size() is a counterpart to pci_get_msi_cap(), can we make
the names similar?

> The only user of pci_msix_table_size() function is PCI-Express
> port driver, which is also updated by this change.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Reviewed-by: Tejun Heo <tj@kernel.org>
> ---
>  Documentation/PCI/MSI-HOWTO.txt |   13 +++++++++++++
>  drivers/pci/msi.c               |   12 ++++++++++--
>  drivers/pci/pcie/portdrv_core.c |    5 +++--
>  include/linux/pci.h             |    2 +-
>  4 files changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
> index 1fe4900..5955389 100644
> --- a/Documentation/PCI/MSI-HOWTO.txt
> +++ b/Documentation/PCI/MSI-HOWTO.txt
> @@ -243,6 +243,19 @@ MSI-X Table.  This address is mapped by the PCI subsystem, and should not
>  be accessed directly by the device driver.  If the driver wishes to
>  mask or unmask an interrupt, it should call disable_irq() / enable_irq().
>  
> +4.3.4 pci_msix_table_size
> +
> +int pci_msix_table_size(struct pci_dev *dev)
> +
> +This function could be used to retrieve number of entries in the device
> +MSI-X table.
> +
> +If this function returns a negative number, it indicates the device is
> +not capable of sending MSI-Xs.
> +
> +If this function returns a positive number, it indicates the maximum
> +number of MSI-X interrupt vectors that could be allocated.
> +
>  4.4 Handling devices implementing both MSI and MSI-X capabilities
>  
>  If a device implements both MSI and MSI-X capabilities, it can
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index e4b02ac..6fe0add 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -932,17 +932,23 @@ EXPORT_SYMBOL(pci_disable_msi);
>  /**
>   * pci_msix_table_size - return the number of device's MSI-X table entries
>   * @dev: pointer to the pci_dev data structure of MSI-X device function
> - */
> +
> + * This function returns the number of device's MSI-X table entries and
> + * therefore the number of MSI-X vectors device is capable to send.
> + * It returns a negative errno if the device is not capable sending MSI-X
> + * interrupts.
> + **/
>  int pci_msix_table_size(struct pci_dev *dev)
>  {
>  	u16 control;
>  
>  	if (!dev->msix_cap)
> -		return 0;
> +		return -EINVAL;
>  
>  	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
>  	return msix_table_size(control);
>  }
> +EXPORT_SYMBOL(pci_msix_table_size);
>  
>  /**
>   * pci_enable_msix - configure device's MSI-X capability structure
> @@ -972,6 +978,8 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
>  		return status;
>  
>  	nr_entries = pci_msix_table_size(dev);
> +	if (nr_entries < 0)
> +		return nr_entries;
>  	if (nvec > nr_entries)
>  		return nr_entries;
>  
> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
> index 08d131f..5bebeec 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -80,8 +80,9 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
>  	u32 reg32;
>  
>  	nr_entries = pci_msix_table_size(dev);
> -	if (!nr_entries)
> -		return -EINVAL;
> +	if (nr_entries < 0)
> +		return nr_entries;
> +	BUG_ON(!nr_entries);
>  	if (nr_entries > PCIE_PORT_MAX_MSIX_ENTRIES)
>  		nr_entries = PCIE_PORT_MAX_MSIX_ENTRIES;
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 9ab1692..8af1217 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1172,7 +1172,7 @@ static inline void pci_disable_msi(struct pci_dev *dev)
>  
>  static inline int pci_msix_table_size(struct pci_dev *dev)
>  {
> -	return 0;
> +	return -ENOSYS;
>  }
>  static inline int pci_enable_msix(struct pci_dev *dev,
>  				  struct msix_entry *entries, int nvec)
> -- 
> 1.7.7.6
> 
