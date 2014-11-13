Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaKMR0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:26:31 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37471 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaKMR03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:26:29 -0500
Date: Thu, 13 Nov 2014 10:26:25 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Apply _HPX link control for all supported pcie
 device
Message-ID: <20141113172625.GH5064@google.com>
References: <1415736586-16044-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415736586-16044-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 12:09:46PM -0800, Yinghai Lu wrote:
> With commit 6cd33649fa83 ("PCI: Add pci_configure_device() during enumeration")
> and following commits, we apply _HPX for pci devices.
> 
> that is called via pci_scan_slot
> 			==>pci_scan_single_device
> 				==>pci_device_add
> 					==>pci_configure_device
> 						==>program_hpp_type2
> and dev->subordinate is not allocated yet.
> 
> So that link control setup get skipped.
> 
> Acoording to ACPI spec, there is no requirement that need to be set to pcie
> root port or downstream port.
> 
> We could just change to pcie_cap_has_lnkctl to cover all pcie devices with
> link control cap.
> 
> -v2: Do not move pcie_cap_has_lnkctl() out of pci/access.c according to Bjorn.
> 
> Fixes: 6cd33649fa83 ("PCI: Add pci_configure_device() during enumeration")
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to for-linus for v3.18, thanks!

> ---
>  drivers/pci/access.c |    2 +-
>  drivers/pci/pci.h    |    2 ++
>  drivers/pci/probe.c  |    2 +-
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/pci/probe.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/probe.c
> +++ linux-2.6/drivers/pci/probe.c
> @@ -1323,7 +1323,7 @@ static void program_hpp_type2(struct pci
>  			~hpp->pci_exp_devctl_and, hpp->pci_exp_devctl_or);
>  
>  	/* Initialize Link Control Register */
> -	if (dev->subordinate)
> +	if (pcie_cap_has_lnkctl(dev))
>  		pcie_capability_clear_and_set_word(dev, PCI_EXP_LNKCTL,
>  			~hpp->pci_exp_lnkctl_and, hpp->pci_exp_lnkctl_or);
>  
> Index: linux-2.6/drivers/pci/pci.h
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.h
> +++ linux-2.6/drivers/pci/pci.h
> @@ -6,6 +6,8 @@
>  
>  extern const unsigned char pcie_link_speed[];
>  
> +bool pcie_cap_has_lnkctl(const struct pci_dev *dev);
> +
>  /* Functions internal to the PCI core code */
>  
>  int pci_create_sysfs_dev_files(struct pci_dev *pdev);
> Index: linux-2.6/drivers/pci/access.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/access.c
> +++ linux-2.6/drivers/pci/access.c
> @@ -444,7 +444,7 @@ static inline int pcie_cap_version(const
>  	return pcie_caps_reg(dev) & PCI_EXP_FLAGS_VERS;
>  }
>  
> -static inline bool pcie_cap_has_lnkctl(const struct pci_dev *dev)
> +bool pcie_cap_has_lnkctl(const struct pci_dev *dev)
>  {
>  	int type = pci_pcie_type(dev);
>  
