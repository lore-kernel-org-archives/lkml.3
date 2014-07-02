Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbaGBUWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:22:11 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35011 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbaGBUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:22:06 -0400
Date: Wed, 2 Jul 2014 14:22:01 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, iommu@lists.linux-foundation.org,
        linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/3] PCI/MSI: Add pci_enable_msi_partial()
Message-ID: <20140702202201.GA28852@google.com>
References: <cover.1402405331.git.agordeev@redhat.com>
 <4fef62a2e647a7c38e9f2a1ea4244b3506a85e2b.1402405331.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fef62a2e647a7c38e9f2a1ea4244b3506a85e2b.1402405331.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 03:10:30PM +0200, Alexander Gordeev wrote:
> There are PCI devices that require a particular value written
> to the Multiple Message Enable (MME) register while aligned on
> power of 2 boundary value of actually used MSI vectors 'nvec'
> is a lesser of that MME value:
> 
> 	roundup_pow_of_two(nvec) < 'Multiple Message Enable'
> 
> However the existing pci_enable_msi_block() interface is not
> able to configure such devices, since the value written to the
> MME register is calculated from the number of requested MSIs
> 'nvec':
> 
> 	'Multiple Message Enable' = roundup_pow_of_two(nvec)

For MSI, software learns how many vectors a device requests by reading
the Multiple Message Capable (MMC) field.  This field is encoded, so a
device can only request 1, 2, 4, 8, etc., vectors.  It's impossible
for a device to request 3 vectors; it would have to round up that up
to a power of two and request 4 vectors.

Software writes similarly encoded values to MME to tell the device how
many vectors have been allocated for its use.  For example, it's
impossible to tell the device that it can use 3 vectors; the OS has to
round that up and tell the device it can use 4 vectors.

So if I understand correctly, the point of this series is to take
advantage of device-specific knowledge, e.g., the device requests 4
vectors via MMC, but we "know" the device is only capable of using 3.
Moreover, we tell the device via MME that 4 vectors are available, but
we've only actually set up 3 of them.

This makes me uneasy because we're lying to the device, and the device
is perfectly within spec to use all 4 of those vectors.  If anything
changes the number of vectors the device uses (new device revision,
firmware upgrade, etc.), this is liable to break.

Can you quantify the benefit of this?  Can't a device already use
MSI-X to request exactly the number of vectors it can use?  (I know
not all devices support MSI-X, but maybe we should just accept MSI for
what it is and encourage the HW guys to use MSI-X if MSI isn't good
enough.)

> In this case the result written to the MME register may not
> satisfy the aforementioned PCI devices requirement and therefore
> the PCI functions will not operate in a desired mode.

I'm not sure what you mean by "will not operate in a desired mode."
I thought this was an optimization to save vectors and that these
changes would be completely invisible to the hardware.

Bjorn

> This update introduces pci_enable_msi_partial() extension to
> pci_enable_msi_block() interface that accepts extra 'nvec_mme'
> argument which is then written to MME register while the value
> of 'nvec' is still used to setup as many interrupts as requested.
> 
> As result of this change, architecture-specific callbacks
> arch_msi_check_device() and arch_setup_msi_irqs() get an extra
> 'nvec_mme' parameter as well, but it is ignored for now.
> Therefore, this update is a placeholder for architectures that
> wish to support pci_enable_msi_partial() function in the future.
> 
> Cc: linux-doc@vger.kernel.org
> Cc: linux-mips@linux-mips.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-s390@vger.kernel.org
> Cc: x86@kernel.org
> Cc: xen-devel@lists.xenproject.org
> Cc: iommu@lists.linux-foundation.org
> Cc: linux-ide@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  Documentation/PCI/MSI-HOWTO.txt |   36 ++++++++++++++--
>  arch/mips/pci/msi-octeon.c      |    2 +-
>  arch/powerpc/kernel/msi.c       |    4 +-
>  arch/s390/pci/pci.c             |    2 +-
>  arch/x86/kernel/x86_init.c      |    2 +-
>  drivers/pci/msi.c               |   83 ++++++++++++++++++++++++++++++++++-----
>  include/linux/msi.h             |    5 +-
>  include/linux/pci.h             |    3 +
>  8 files changed, 115 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
> index 10a9369..c8a8503 100644
> --- a/Documentation/PCI/MSI-HOWTO.txt
> +++ b/Documentation/PCI/MSI-HOWTO.txt
> @@ -195,14 +195,40 @@ By contrast with pci_enable_msi_range() function, pci_enable_msi_exact()
>  returns zero in case of success, which indicates MSI interrupts have been
>  successfully allocated.
>  
> -4.2.4 pci_disable_msi
> +4.2.4 pci_enable_msi_partial
> +
> +int pci_enable_msi_partial(struct pci_dev *dev, int nvec, int nvec_mme)
> +
> +This variation on pci_enable_msi_exact() call allows a device driver to
> +setup 'nvec_mme' number of multiple MSIs with the PCI function, while
> +setup only 'nvec' (which could be a lesser of 'nvec_mme') number of MSIs
> +in operating system. The MSI specification only allows 'nvec_mme' to be
> +allocated in powers of two, up to a maximum of 2^5 (32).
> +
> +This function could be used when a PCI function is known to send 'nvec'
> +MSIs, but still requires a particular number of MSIs 'nvec_mme' to be
> +initialized with. As result, 'nvec_mme' - 'nvec' number of unused MSIs
> +do not waste system resources.
> +
> +If this function returns 0, it has succeeded in allocating 'nvec_mme'
> +interrupts and setting up 'nvec' interrupts. In this case, the function
> +enables MSI on this device and updates dev->irq to be the lowest of the
> +new interrupts assigned to it.  The other interrupts assigned to the
> +device are in the range dev->irq to dev->irq + nvec - 1.
> +
> +If this function returns a negative number, it indicates an error and
> +the driver should not attempt to request any more MSI interrupts for
> +this device.
> +
> +4.2.5 pci_disable_msi
>  
>  void pci_disable_msi(struct pci_dev *dev)
>  
> -This function should be used to undo the effect of pci_enable_msi_range().
> -Calling it restores dev->irq to the pin-based interrupt number and frees
> -the previously allocated MSIs.  The interrupts may subsequently be assigned
> -to another device, so drivers should not cache the value of dev->irq.
> +This function should be used to undo the effect of pci_enable_msi_range()
> +or pci_enable_msi_partial(). Calling it restores dev->irq to the pin-based
> +interrupt number and frees the previously allocated MSIs.  The interrupts
> +may subsequently be assigned to another device, so drivers should not cache
> +the value of dev->irq.
>  
>  Before calling this function, a device driver must always call free_irq()
>  on any interrupt for which it previously called request_irq().
> diff --git a/arch/mips/pci/msi-octeon.c b/arch/mips/pci/msi-octeon.c
> index 2b91b0e..2be7979 100644
> --- a/arch/mips/pci/msi-octeon.c
> +++ b/arch/mips/pci/msi-octeon.c
> @@ -178,7 +178,7 @@ msi_irq_allocated:
>  	return 0;
>  }
>  
> -int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> +int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int nvec_mme, int type)
>  {
>  	struct msi_desc *entry;
>  	int ret;
> diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
> index 8bbc12d..c60aee3 100644
> --- a/arch/powerpc/kernel/msi.c
> +++ b/arch/powerpc/kernel/msi.c
> @@ -13,7 +13,7 @@
>  
>  #include <asm/machdep.h>
>  
> -int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
> +int arch_msi_check_device(struct pci_dev *dev, int nvec, int nvec_mme, int type)
>  {
>  	if (!ppc_md.setup_msi_irqs || !ppc_md.teardown_msi_irqs) {
>  		pr_debug("msi: Platform doesn't provide MSI callbacks.\n");
> @@ -32,7 +32,7 @@ int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
>          return 0;
>  }
>  
> -int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> +int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int nvec_mme, int type)
>  {
>  	return ppc_md.setup_msi_irqs(dev, nvec, type);
>  }
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index 9ddc51e..3cf38a8 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -398,7 +398,7 @@ static void zpci_irq_handler(struct airq_struct *airq)
>  	}
>  }
>  
> -int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
> +int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int nvec_mme, int type)
>  {
>  	struct zpci_dev *zdev = get_zdev(pdev);
>  	unsigned int hwirq, msi_vecs;
> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> index e48b674..b65bf95 100644
> --- a/arch/x86/kernel/x86_init.c
> +++ b/arch/x86/kernel/x86_init.c
> @@ -121,7 +121,7 @@ struct x86_msi_ops x86_msi = {
>  };
>  
>  /* MSI arch specific hooks */
> -int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> +int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int nvec_mme, int type)
>  {
>  	return x86_msi.setup_msi_irqs(dev, nvec, type);
>  }
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 27a7e67..0410d9b 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -56,7 +56,8 @@ void __weak arch_teardown_msi_irq(unsigned int irq)
>  	chip->teardown_irq(chip, irq);
>  }
>  
> -int __weak arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
> +int __weak arch_msi_check_device(struct pci_dev *dev,
> +				 int nvec, int nvec_mme, int type)
>  {
>  	struct msi_chip *chip = dev->bus->msi;
>  
> @@ -66,7 +67,8 @@ int __weak arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
>  	return chip->check_device(chip, dev, nvec, type);
>  }
>  
> -int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> +int __weak arch_setup_msi_irqs(struct pci_dev *dev,
> +			       int nvec, int nvec_mme, int type)
>  {
>  	struct msi_desc *entry;
>  	int ret;
> @@ -598,6 +600,7 @@ error_attrs:
>   * msi_capability_init - configure device's MSI capability structure
>   * @dev: pointer to the pci_dev data structure of MSI device function
>   * @nvec: number of interrupts to allocate
> + * @nvec_mme: number of interrupts to write to Multiple Message Enable register
>   *
>   * Setup the MSI capability structure of the device with the requested
>   * number of interrupts.  A return value of zero indicates the successful
> @@ -605,7 +608,7 @@ error_attrs:
>   * an error, and a positive return value indicates the number of interrupts
>   * which could have been allocated.
>   */
> -static int msi_capability_init(struct pci_dev *dev, int nvec)
> +static int msi_capability_init(struct pci_dev *dev, int nvec, int nvec_mme)
>  {
>  	struct msi_desc *entry;
>  	int ret;
> @@ -640,7 +643,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
>  	list_add_tail(&entry->list, &dev->msi_list);
>  
>  	/* Configure MSI capability structure */
> -	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
> +	ret = arch_setup_msi_irqs(dev, nvec, nvec_mme, PCI_CAP_ID_MSI);
>  	if (ret) {
>  		msi_mask_irq(entry, mask, ~mask);
>  		free_msi_irqs(dev);
> @@ -758,7 +761,8 @@ static int msix_capability_init(struct pci_dev *dev,
>  	if (ret)
>  		return ret;
>  
> -	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
> +	/* Parameter 'nvec_mme' does not make sense in case of MSI-X */
> +	ret = arch_setup_msi_irqs(dev, nvec, 0, PCI_CAP_ID_MSIX);
>  	if (ret)
>  		goto out_avail;
>  
> @@ -812,13 +816,15 @@ out_free:
>   * pci_msi_check_device - check whether MSI may be enabled on a device
>   * @dev: pointer to the pci_dev data structure of MSI device function
>   * @nvec: how many MSIs have been requested ?
> + * @nvec_mme: how many MSIs write to Multiple Message Enable register ?
>   * @type: are we checking for MSI or MSI-X ?
>   *
>   * Look at global flags, the device itself, and its parent buses
>   * to determine if MSI/-X are supported for the device. If MSI/-X is
>   * supported return 0, else return an error code.
>   **/
> -static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
> +static int pci_msi_check_device(struct pci_dev *dev,
> +				int nvec, int nvec_mme, int type)
>  {
>  	struct pci_bus *bus;
>  	int ret;
> @@ -846,7 +852,7 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
>  		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
>  			return -EINVAL;
>  
> -	ret = arch_msi_check_device(dev, nvec, type);
> +	ret = arch_msi_check_device(dev, nvec, nvec_mme, type);
>  	if (ret)
>  		return ret;
>  
> @@ -878,6 +884,62 @@ int pci_msi_vec_count(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL(pci_msi_vec_count);
>  
> +/**
> + * pci_enable_msi_partial - configure device's MSI capability structure
> + * @dev: device to configure
> + * @nvec: number of interrupts to configure
> + * @nvec_mme: number of interrupts to write to Multiple Message Enable register
> + *
> + * This function tries to allocate @nvec number of interrupts while setup
> + * device's Multiple Message Enable register with @nvec_mme interrupts.
> + * It returns a negative errno if an error occurs. If it succeeds, it returns
> + * zero and updates the @dev's irq member to the lowest new interrupt number;
> + * the other interrupt numbers allocated to this device are consecutive.
> + */
> +int pci_enable_msi_partial(struct pci_dev *dev, int nvec, int nvec_mme)
> +{
> +	int maxvec;
> +	int rc;
> +
> +	if (dev->current_state != PCI_D0)
> +		return -EINVAL;
> +
> +	WARN_ON(!!dev->msi_enabled);
> +
> +	/* Check whether driver already requested MSI-X irqs */
> +	if (dev->msix_enabled) {
> +		dev_info(&dev->dev, "can't enable MSI "
> +			 "(MSI-X already enabled)\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!is_power_of_2(nvec_mme))
> +		return -EINVAL;
> +	if (nvec > nvec_mme)
> +		return -EINVAL;
> +
> +	maxvec = pci_msi_vec_count(dev);
> +	if (maxvec < 0)
> +		return maxvec;
> +	else if (nvec_mme > maxvec)
> +		return -EINVAL;
> +
> +	rc = pci_msi_check_device(dev, nvec, nvec_mme, PCI_CAP_ID_MSI);
> +	if (rc < 0)
> +		return rc;
> +	else if (rc > 0)
> +		return -ENOSPC;
> +
> +	rc = msi_capability_init(dev, nvec, nvec_mme);
> +	if (rc < 0)
> +		return rc;
> +	else if (rc > 0)
> +		return -ENOSPC;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pci_enable_msi_partial);
> +
>  void pci_msi_shutdown(struct pci_dev *dev)
>  {
>  	struct msi_desc *desc;
> @@ -957,7 +1019,7 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
>  	if (!entries || !dev->msix_cap || dev->current_state != PCI_D0)
>  		return -EINVAL;
>  
> -	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSIX);
> +	status = pci_msi_check_device(dev, nvec, 0, PCI_CAP_ID_MSIX);
>  	if (status)
>  		return status;
>  
> @@ -1110,7 +1172,8 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
>  		nvec = maxvec;
>  
>  	do {
> -		rc = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSI);
> +		rc = pci_msi_check_device(dev, nvec, roundup_pow_of_two(nvec),
> +					  PCI_CAP_ID_MSI);
>  		if (rc < 0) {
>  			return rc;
>  		} else if (rc > 0) {
> @@ -1121,7 +1184,7 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
>  	} while (rc);
>  
>  	do {
> -		rc = msi_capability_init(dev, nvec);
> +		rc = msi_capability_init(dev, nvec, roundup_pow_of_two(nvec));
>  		if (rc < 0) {
>  			return rc;
>  		} else if (rc > 0) {
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index 92a2f99..b9f89ee 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -57,9 +57,10 @@ struct msi_desc {
>   */
>  int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
>  void arch_teardown_msi_irq(unsigned int irq);
> -int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
> +int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int nvec_mme, int type);
>  void arch_teardown_msi_irqs(struct pci_dev *dev);
> -int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
> +int arch_msi_check_device(struct pci_dev *dev,
> +			  int nvec, int nvec_mme, int type);
>  void arch_restore_msi_irqs(struct pci_dev *dev);
>  
>  void default_teardown_msi_irqs(struct pci_dev *dev);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 71d9673..7360bd2 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1184,6 +1184,7 @@ void pci_disable_msix(struct pci_dev *dev);
>  void msi_remove_pci_irq_vectors(struct pci_dev *dev);
>  void pci_restore_msi_state(struct pci_dev *dev);
>  int pci_msi_enabled(void);
> +int pci_enable_msi_partial(struct pci_dev *dev, int nvec, int nvec_mme);
>  int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec);
>  static inline int pci_enable_msi_exact(struct pci_dev *dev, int nvec)
>  {
> @@ -1215,6 +1216,8 @@ static inline void pci_disable_msix(struct pci_dev *dev) { }
>  static inline void msi_remove_pci_irq_vectors(struct pci_dev *dev) { }
>  static inline void pci_restore_msi_state(struct pci_dev *dev) { }
>  static inline int pci_msi_enabled(void) { return 0; }
> +static int pci_enable_msi_partial(struct pci_dev *dev, int nvec, int nvec_mme)
> +{ return -ENOSYS; }
>  static inline int pci_enable_msi_range(struct pci_dev *dev, int minvec,
>  				       int maxvec)
>  { return -ENOSYS; }
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
