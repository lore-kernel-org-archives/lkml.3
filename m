Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaGNJzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:55:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbaGNJy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:54:57 -0400
Date: Mon, 14 Jul 2014 11:55:39 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI/MSI: Remove arch_msi_check_device()
Message-ID: <20140714095538.GA15981@dhcp-26-207.brq.redhat.com>
References: <cover.1405160163.git.agordeev@redhat.com>
 <1005232855c3af2c0c669818ee63be445389b6ad.1405160163.git.agordeev@redhat.com>
 <53C33C6D.8020103@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C33C6D.8020103@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:11:57AM +0800, Yijing Wang wrote:
> >  /**
> > - * pci_msi_check_device - check whether MSI may be enabled on a device
> > + * msi_check_device - check whether MSI may be enabled on a device
> >   * @dev: pointer to the pci_dev data structure of MSI device function
> >   * @nvec: how many MSIs have been requested ?
> > - * @type: are we checking for MSI or MSI-X ?
> >   *
> >   * Look at global flags, the device itself, and its parent buses
> >   * to determine if MSI/-X are supported for the device. If MSI/-X is
> >   * supported return 0, else return an error code.
> >   **/
> > -static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
> > +static int msi_check_device(struct pci_dev *dev, int nvec)
> >  {
> >  	struct pci_bus *bus;
> > -	int ret;
> >  
> >  	/* MSI must be globally enabled and supported by the device */
> > -	if (!pci_msi_enable || !dev || dev->no_msi)
> > +	if (!pci_msi_enable)
> > +		return -EINVAL;
> > +
> > +	if (!dev || dev->no_msi || dev->current_state != PCI_D0)
> >  		return -EINVAL;
> >  
> >  	/*
> > @@ -846,10 +837,6 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
> >  		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
> >  			return -EINVAL;
> >  
> > -	ret = arch_msi_check_device(dev, nvec, type);
> > -	if (ret)
> > -		return ret;
> > -
> 
> Move the arch_msi_check_device() into arch_msi_setup_irq(), make we can not detect whether the device in this platform
> supports MSI or MSI-X aeap. If we delay this, maybe we will do a lot unnecessary working for MSI/MSI-X setup.

A traditional approach for a function is first to make sanity check and
then allocate resources. I do not see a reason to keep these two steps
in separate functions: arch_msi_check_device() and arch_setup_msi_irq().

Just make checks within arch_setup_msi_irq() and bail out early would be as
cheap as it is now, but more natural and would deflate the interface.

Moreover, some platforms duplicate checks in arch_msi_check_device() and
arch_setup_msi_irq(), which does not add to readability.

> Thanks!
> Yijing.
> 
> >  	return 0;
> >  }
> >  
> > @@ -954,13 +941,13 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
> >  	int status, nr_entries;
> >  	int i, j;
> >  
> > -	if (!entries || !dev->msix_cap || dev->current_state != PCI_D0)
> > -		return -EINVAL;
> > -
> > -	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSIX);
> > +	status = msi_check_device(dev, nvec);
> >  	if (status)
> >  		return status;
> >  
> > +	if (!entries)
> > +		return -EINVAL;
> > +
> >  	nr_entries = pci_msix_vec_count(dev);
> >  	if (nr_entries < 0)
> >  		return nr_entries;
> > @@ -1085,8 +1072,9 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
> >  	int nvec;
> >  	int rc;
> >  
> > -	if (dev->current_state != PCI_D0)
> > -		return -EINVAL;
> > +	rc = msi_check_device(dev, minvec);
> > +	if (rc)
> > +		return rc;
> >  
> >  	WARN_ON(!!dev->msi_enabled);
> >  
> > @@ -1109,17 +1097,6 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
> >  		nvec = maxvec;
> >  
> >  	do {
> > -		rc = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSI);
> > -		if (rc < 0) {
> > -			return rc;
> > -		} else if (rc > 0) {
> > -			if (rc < minvec)
> > -				return -ENOSPC;
> > -			nvec = rc;
> > -		}
> > -	} while (rc);
> > -
> > -	do {
> >  		rc = msi_capability_init(dev, nvec);
> >  		if (rc < 0) {
> >  			return rc;
> > diff --git a/include/linux/msi.h b/include/linux/msi.h
> > index 92a2f99..3b873bc 100644
> > --- a/include/linux/msi.h
> > +++ b/include/linux/msi.h
> > @@ -59,7 +59,6 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
> >  void arch_teardown_msi_irq(unsigned int irq);
> >  int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
> >  void arch_teardown_msi_irqs(struct pci_dev *dev);
> > -int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
> >  void arch_restore_msi_irqs(struct pci_dev *dev);
> >  
> >  void default_teardown_msi_irqs(struct pci_dev *dev);
> > @@ -76,8 +75,6 @@ struct msi_chip {
> >  	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
> >  			 struct msi_desc *desc);
> >  	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
> > -	int (*check_device)(struct msi_chip *chip, struct pci_dev *dev,
> > -			    int nvec, int type);
> >  };
> >  
> >  #endif /* LINUX_MSI_H */
> > 
> 
> 
> -- 
> Thanks!
> Yijing
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
