Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaKJOwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:52:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:55654 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbaKJOv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:51:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,353,1413270000"; 
   d="scan'208";a="634470374"
Message-ID: <5460D100.90403@linux.intel.com>
Date: Mon, 10 Nov 2014 22:51:44 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>, Tejun Heo <tj@kernel.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Sunil Goutham <sgoutham@cavium.com>,
        Robert Richter <rrichter@cavium.com>
Subject: Re: [PATCH] AHCI: Add generic MSI-X interrupt support to SATA PCI
 driver
References: <1415597417-10547-1-git-send-email-rric@kernel.org>
In-Reply-To: <1415597417-10547-1-git-send-email-rric@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/10 13:30, Robert Richter wrote:
> From: Sunil Goutham <sgoutham@cavium.com>
> 
> This patch adds generic support for MSI-X interrupts to the SATA PCI
> driver. Only single interrupt support is implemented. Thus, per-port
> interrupts can not yet be enabled.
> 
> The driver now checks the device for the existence of MSI-X and tries
> to enable the interrupt. Otherwise, if a device is not MSI-X capable,
> the initialization is skipped and MSI or intx interrupts are
> configured.
> 
> This patch also enables AHCI for Cavium Thunder SoCs that uses MSI-X.
> 
> Signed-off-by: Sunil Goutham <sgoutham@cavium.com>
> Signed-off-by: Robert Richter <rrichter@cavium.com>
> ---
>  arch/arm64/Kconfig |  1 +
>  drivers/ata/ahci.c | 40 +++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index ac9afde76dea..55970474d3ae 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -145,6 +145,7 @@ config ARCH_THUNDER
>  	bool "Cavium Inc. Thunder SoC Family"
>  	help
>  	  This enables support for Cavium's Thunder Family of SoCs.
> +	select SATA_AHCI
>  
>  config ARCH_VEXPRESS
>  	bool "ARMv8 software model (Versatile Express)"
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 5f039f191067..8e43ccb72c95 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -52,6 +52,7 @@
>  
>  enum {
>  	AHCI_PCI_BAR_STA2X11	= 0,
> +	AHCI_PCI_BAR_CAVIUM	= 0,
>  	AHCI_PCI_BAR_ENMOTUS	= 2,
>  	AHCI_PCI_BAR_STANDARD	= 5,
>  };
> @@ -483,6 +484,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
>  	/* Enmotus */
>  	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
>  
> +	/* Cavium */
> +	{ PCI_DEVICE(0x177d, 0xa01c), .driver_data = board_ahci },
> +
>  	/* Generic, PCI class code for AHCI */
>  	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
>  	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
> @@ -1188,11 +1192,43 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
>  {}
>  #endif
>  
> +static int ahci_init_msix(struct pci_dev *pdev, unsigned int n_ports,
> +			  struct ahci_host_priv *hpriv)
> +{
> +	int rc, nvec;
> +	struct msix_entry entry = {};
> +
> +	/* check if msix is supported */
> +	nvec = pci_msix_vec_count(pdev);
> +	if (nvec <= 0)
> +		return 0;
> +
> +	/* per-port msix interrupts are not supported */
> +	if (n_ports > 1 && nvec >= n_ports)
> +		return -ENOSYS;
> +
> +	/* only enable the first entry (entry.entry = 0) */
> +	rc = pci_enable_msix_exact(pdev, &entry, 1);
> +	if (rc < 0)
> +		return rc;
> +
> +	pdev->irq = entry.vector;
Hi Robert,
	You can't overwrite pci_dev->irq for MSI-X, it's no way to
recover original irq for INTx after unbinding ahci driver. Instead,
you may access msi_desc->irq when requesting irq.
Regards!
Gerry
> +
> +	return 1;
> +}
> +
>  static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
>  				struct ahci_host_priv *hpriv)
>  {
>  	int rc, nvec;
>  
> +	nvec = ahci_init_msix(pdev, n_ports, hpriv);
> +	if (nvec > 0)
> +		return nvec;
> +
> +	if (nvec && nvec != -ENOSYS)
> +		dev_err(&pdev->dev, "failed to enable MSI-X: %d", nvec);
> +
>  	if (hpriv->flags & AHCI_HFLAG_NO_MSI)
>  		goto intx;
>  
> @@ -1271,11 +1307,13 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		dev_info(&pdev->dev,
>  			 "PDC42819 can only drive SATA devices with this driver\n");
>  
> -	/* Both Connext and Enmotus devices use non-standard BARs */
> +	/* Some devices use non-standard BARs */
>  	if (pdev->vendor == PCI_VENDOR_ID_STMICRO && pdev->device == 0xCC06)
>  		ahci_pci_bar = AHCI_PCI_BAR_STA2X11;
>  	else if (pdev->vendor == 0x1c44 && pdev->device == 0x8000)
>  		ahci_pci_bar = AHCI_PCI_BAR_ENMOTUS;
> +	else if (pdev->vendor == 0x177d && pdev->device == 0xa01c)
> +		ahci_pci_bar = AHCI_PCI_BAR_CAVIUM;
>  
>  	/*
>  	 * The JMicron chip 361/363 contains one SATA controller and one
> 
