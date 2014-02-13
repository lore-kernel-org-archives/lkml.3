Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaBMRqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:46:51 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:54642 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaBMRqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:46:49 -0500
Date: Thu, 13 Feb 2014 10:46:45 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI/MSI: Add pci_enable_msi_exact() and
 pci_enable_msix_exact()
Message-ID: <20140213174645.GA6720@google.com>
References: <1392301502-22949-1-git-send-email-agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392301502-22949-1-git-send-email-agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 03:25:02PM +0100, Alexander Gordeev wrote:
> The new functions are special cases for pci_enable_msi_range() and
> pci_enable_msix_range() when a particular number of MSI or MSI-X
> is needed.
> 
> By contrast with pci_enable_msi_range() and pci_enable_msix_range()
> functions, pci_enable_msi_exact() and pci_enable_msix_exact()
> return zero in case of success, which indicates MSI or MSI-X
> interrupts have been successfully allocated.
> 
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Thanks, I applied this to pci/misc.  I think in order to make progress on
your driver cleanups, we should put this in v3.14 so the cleanups can be
merged in the v3.15 merge window.  So I'll cherry pick this into my
for-linus branch as well.

Bjorn

> ---
>  Documentation/PCI/MSI-HOWTO.txt |   86 ++++++++++++++++++++++++++++++++++++++-
>  include/linux/pci.h             |   20 +++++++++
>  2 files changed, 104 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
> index 96ee5eb..ae7307c 100644
> --- a/Documentation/PCI/MSI-HOWTO.txt
> +++ b/Documentation/PCI/MSI-HOWTO.txt
> @@ -159,6 +159,11 @@ static int foo_driver_enable_msi(struct pci_dev *pdev, int nvec)
>  	return pci_enable_msi_range(pdev, nvec, nvec);
>  }
>  
> +Note, unlike pci_enable_msi_exact() function, which could be also used to
> +enable a particular number of MSI-X interrupts, pci_enable_msi_range()
> +returns either a negative errno or 'nvec' (not negative errno or 0 - as
> +pci_enable_msi_exact() does).
> +
>  4.2.1.3 Single MSI mode
>  
>  The most notorious example of the request type described above is
> @@ -175,7 +180,22 @@ enable the single MSI mode, pci_enable_msi_range() returns either a
>  negative errno or 1 (not negative errno or 0 - as pci_enable_msi()
>  does).
>  
> -4.2.3 pci_disable_msi
> +4.2.3 pci_enable_msi_exact
> +
> +int pci_enable_msi_exact(struct pci_dev *dev, int nvec)
> +
> +This variation on pci_enable_msi_range() call allows a device driver to
> +request exactly 'nvec' MSIs.
> +
> +If this function returns a negative number, it indicates an error and
> +the driver should not attempt to request any more MSI interrupts for
> +this device.
> +
> +By contrast with pci_enable_msi_range() function, pci_enable_msi_exact()
> +returns zero in case of success, which indicates MSI interrupts have been
> +successfully allocated.
> +
> +4.2.4 pci_disable_msi
>  
>  void pci_disable_msi(struct pci_dev *dev)
>  
> @@ -303,6 +323,11 @@ static int foo_driver_enable_msix(struct foo_adapter *adapter, int nvec)
>  				     nvec, nvec);
>  }
>  
> +Note, unlike pci_enable_msix_exact() function, which could be also used to
> +enable a particular number of MSI-X interrupts, pci_enable_msix_range()
> +returns either a negative errno or 'nvec' (not negative errno or 0 - as
> +pci_enable_msix_exact() does).
> +
>  4.3.1.3 Specific requirements to the number of MSI-X interrupts
>  
>  As noted above, there could be devices that can not operate with just any
> @@ -349,7 +374,64 @@ Note how pci_enable_msix_range() return value is analized for a fallback -
>  any error code other than -ENOSPC indicates a fatal error and should not
>  be retried.
>  
> -4.3.2 pci_disable_msix
> +4.3.2 pci_enable_msix_exact
> +
> +int pci_enable_msix_exact(struct pci_dev *dev,
> +			  struct msix_entry *entries, int nvec)
> +
> +This variation on pci_enable_msix_range() call allows a device driver to
> +request exactly 'nvec' MSI-Xs.
> +
> +If this function returns a negative number, it indicates an error and
> +the driver should not attempt to allocate any more MSI-X interrupts for
> +this device.
> +
> +By contrast with pci_enable_msix_range() function, pci_enable_msix_exact()
> +returns zero in case of success, which indicates MSI-X interrupts have been
> +successfully allocated.
> +
> +Another version of a routine that enables MSI-X mode for a device with
> +specific requirements described in chapter 4.3.1.3 might look like this:
> +
> +/*
> + * Assume 'minvec' and 'maxvec' are non-zero
> + */
> +static int foo_driver_enable_msix(struct foo_adapter *adapter,
> +				  int minvec, int maxvec)
> +{
> +	int rc;
> +
> +	minvec = roundup_pow_of_two(minvec);
> +	maxvec = rounddown_pow_of_two(maxvec);
> +
> +	if (minvec > maxvec)
> +		return -ERANGE;
> +
> +retry:
> +	rc = pci_enable_msix_exact(adapter->pdev,
> +				   adapter->msix_entries, maxvec);
> +
> +	/*
> +	 * -ENOSPC is the only error code allowed to be analized
> +	 */
> +	if (rc == -ENOSPC) {
> +		if (maxvec == 1)
> +			return -ENOSPC;
> +
> +		maxvec /= 2;
> +
> +		if (minvec > maxvec)
> +			return -ENOSPC;
> +
> +		goto retry;
> +	} else if (rc < 0) {
> +		return rc;
> +	}
> +
> +	return maxvec;
> +}
> +
> +4.3.3 pci_disable_msix
>  
>  void pci_disable_msix(struct pci_dev *dev)
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index fb57c89..33aa2ca 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1169,8 +1169,23 @@ void msi_remove_pci_irq_vectors(struct pci_dev *dev);
>  void pci_restore_msi_state(struct pci_dev *dev);
>  int pci_msi_enabled(void);
>  int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec);
> +static inline int pci_enable_msi_exact(struct pci_dev *dev, int nvec)
> +{
> +	int rc = pci_enable_msi_range(dev, nvec, nvec);
> +	if (rc < 0)
> +		return rc;
> +	return 0;
> +}
>  int pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
>  			  int minvec, int maxvec);
> +static inline int pci_enable_msix_exact(struct pci_dev *dev,
> +					struct msix_entry *entries, int nvec)
> +{
> +	int rc = pci_enable_msix_range(dev, entries, nvec, nvec);
> +	if (rc < 0)
> +		return rc;
> +	return 0;
> +}
>  #else
>  static inline int pci_msi_vec_count(struct pci_dev *dev) { return -ENOSYS; }
>  static inline int pci_enable_msi_block(struct pci_dev *dev, int nvec)
> @@ -1189,9 +1204,14 @@ static inline int pci_msi_enabled(void) { return 0; }
>  static inline int pci_enable_msi_range(struct pci_dev *dev, int minvec,
>  				       int maxvec)
>  { return -ENOSYS; }
> +static inline int pci_enable_msi_exact(struct pci_dev *dev, int nvec)
> +{ return -ENOSYS; }
>  static inline int pci_enable_msix_range(struct pci_dev *dev,
>  		      struct msix_entry *entries, int minvec, int maxvec)
>  { return -ENOSYS; }
> +static inline int pci_enable_msix_exact(struct pci_dev *dev,
> +		      struct msix_entry *entries, int nvec)
> +{ return -ENOSYS; }
>  #endif
>  
>  #ifdef CONFIG_PCIEPORTBUS
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
