Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaHKOdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:33:37 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:49606
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753567AbaHKOdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:33:35 -0400
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] PCI/MSI: Remove arch_msi_check_device()
Thread-Topic: [PATCH v2 2/2] PCI/MSI: Remove arch_msi_check_device()
Thread-Index: AQHPtVnNGMGA3zaF00ChSJBTu4cvyZvLdr8Q
Date: Mon, 11 Aug 2014 14:33:25 +0000
Message-ID: <0a23568bd6eb4dfbb5f4acc96bba3706@BLUPR03MB566.namprd03.prod.outlook.com>
References: <cover.1405160163.git.agordeev@redhat.com>
 <1005232855c3af2c0c669818ee63be445389b6ad.1405160163.git.agordeev@redhat.com>
 <20140716222024.GE14366@google.com>
 <20140811114536.GA3427@dhcp-27-160.brq.redhat.com>
In-Reply-To: <20140811114536.GA3427@dhcp-27-160.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03008837BD
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(199002)(189002)(13464003)(51704005)(64706001)(76176999)(54356999)(50986999)(20776003)(99396002)(74316001)(46102001)(77982001)(76482001)(80022001)(19580395003)(19580405001)(79102001)(83072002)(92566001)(33646002)(85852003)(81542001)(86362001)(101416001)(2656002)(15202345003)(31966008)(4396001)(74662001)(74502001)(76576001)(93886004)(105586002)(85306004)(81342001)(15975445006)(66066001)(87936001)(21056001)(107046002)(106356001)(106116001)(99286002)(83322001)(95666004)(24736002)(108616003)(422495003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB567;H:BLUPR03MB566.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:3;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-owner@vger.kernel.org]
> On Behalf Of Alexander Gordeev
> Sent: Monday, August 11, 2014 5:16 PM
> To: Bjorn Helgaas
> Cc: linux-kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> pci@vger.kernel.org
> Subject: [PATCH v2 2/2] PCI/MSI: Remove arch_msi_check_device()
> 
> There are no archs that override arch_msi_check_device() hook. Remove it as it
> is completely redundant.

Is not we are still overriding this in powerpc (not sure I missed some patch , if so please point to that).

$ grep -r  arch_msi_check_device arch/powerpc/
Binary file arch/powerpc/kernel/msi.o matches
arch/powerpc/kernel/msi.c:int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
Binary file arch/powerpc/kernel/built-in.o matches

Thanks
-Bharat

> 
> If an arch would need to check MSI/MSI-X possibility for a device it should make
> it within arch_setup_msi_irqs() hook.
> 
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/pci/msi.c   | 49 +++++++++++++------------------------------------
>  include/linux/msi.h |  3 ---
>  2 files changed, 13 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c index 5a40516..6c2cc41 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -56,16 +56,6 @@ void __weak arch_teardown_msi_irq(unsigned int irq)
>  	chip->teardown_irq(chip, irq);
>  }
> 
> -int __weak arch_msi_check_device(struct pci_dev *dev, int nvec, int type) -{
> -	struct msi_chip *chip = dev->bus->msi;
> -
> -	if (!chip || !chip->check_device)
> -		return 0;
> -
> -	return chip->check_device(chip, dev, nvec, type);
> -}
> -
>  int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)  {
>  	struct msi_desc *entry;
> @@ -806,22 +796,23 @@ out_free:
>  }
> 
>  /**
> - * pci_msi_check_device - check whether MSI may be enabled on a device
> + * pci_msi_supported - check whether MSI may be enabled on a device
>   * @dev: pointer to the pci_dev data structure of MSI device function
>   * @nvec: how many MSIs have been requested ?
> - * @type: are we checking for MSI or MSI-X ?
>   *
>   * Look at global flags, the device itself, and its parent buses
>   * to determine if MSI/-X are supported for the device. If MSI/-X is
>   * supported return 0, else return an error code.
>   **/
> -static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
> +static int pci_msi_supported(struct pci_dev *dev, int nvec)
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
> @@ -843,10 +834,6 @@ static int pci_msi_check_device(struct pci_dev *dev, int
> nvec, int type)
>  		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
>  			return -EINVAL;
> 
> -	ret = arch_msi_check_device(dev, nvec, type);
> -	if (ret)
> -		return ret;
> -
>  	return 0;
>  }
> 
> @@ -949,13 +936,13 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry
> *entries, int nvec)
>  	int status, nr_entries;
>  	int i, j;
> 
> -	if (!entries || !dev->msix_cap || dev->current_state != PCI_D0)
> -		return -EINVAL;
> -
> -	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSIX);
> +	status = pci_msi_supported(dev, nvec);
>  	if (status)
>  		return status;
> 
> +	if (!entries)
> +		return -EINVAL;
> +
>  	nr_entries = pci_msix_vec_count(dev);
>  	if (nr_entries < 0)
>  		return nr_entries;
> @@ -1062,8 +1049,9 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec,
> int maxvec)
>  	int nvec;
>  	int rc;
> 
> -	if (dev->current_state != PCI_D0)
> -		return -EINVAL;
> +	rc = pci_msi_supported(dev, minvec);
> +	if (rc)
> +		return rc;
> 
>  	WARN_ON(!!dev->msi_enabled);
> 
> @@ -1086,17 +1074,6 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec,
> int maxvec)
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
> diff --git a/include/linux/msi.h b/include/linux/msi.h index 8103f32..dbf7cc9
> 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -60,7 +60,6 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc
> *desc);  void arch_teardown_msi_irq(unsigned int irq);  int
> arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);  void
> arch_teardown_msi_irqs(struct pci_dev *dev); -int arch_msi_check_device(struct
> pci_dev* dev, int nvec, int type);  void arch_restore_msi_irqs(struct pci_dev
> *dev);
> 
>  void default_teardown_msi_irqs(struct pci_dev *dev); @@ -77,8 +76,6 @@ struct
> msi_chip {
>  	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
>  			 struct msi_desc *desc);
>  	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
> -	int (*check_device)(struct msi_chip *chip, struct pci_dev *dev,
> -			    int nvec, int type);
>  };
> 
>  #endif /* LINUX_MSI_H */
> --
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
