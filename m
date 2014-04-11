Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbaDKKOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:14:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40132 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbaDKKO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:14:27 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-35-5347c08181ad
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Alan Cox <alan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
        Kefeng Wang <kefeng.wang@linaro.org>
Subject: Re: [PATCH] ahci: disable DEVSLP for Intel Valleyview
Date: Fri, 11 Apr 2014 12:14:14 +0200
Message-id: <5800248.4YbvBlxjQc@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1397123934-27114-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1397123934-27114-1-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jAd3GA+7BBlN36FpceH6BxWL61AuM
	FksPrmexaL3+jNnizgc/i2M7HjFZXN41h83i1/KjjA4cHov3vGTy2LSqk83jzrU9bB7zTgZ6
	fN4kF8AaxWWTkpqTWZZapG+XwJXRPGsna8E/6Ypd846zNDCuFuti5OSQEDCRuLt2LiuELSZx
	4d56ti5GLg4hgUWMErNOX2UDSQgJtDBJnL2XDmKzCVhJTGxfxQhiiwjoShx5sowdpIFZoIdJ
	4v2Ji8wgCWEBO4l5p/6BFbEIqEq87T0INIiDg1dAU+LNFUmQsKiAp8SO7SvB5nMK+EncaV3B
	AlIiJOArsWF+LkiYV0BQ4sfkeywgNrOAvMS+/VNZIWwdif2t09gmMArMQlI2C0nZLCRlCxiZ
	VzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB/oz6R2MqxosDjEKcDAq8fAeuOQWLMSaWFZc
	mXuIUYKDWUmE13yve7AQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUw
	WSYOTqkGxsYjnj1Cn0rXVh2paOuqCC5T8iku/Z634BVX4m3Hz2ymQo/W+pjtYovZoOQ1P++Q
	0mS3bXG7isTEut5fmnn+lDzH/wXt+3kTF3LXH7/8MmXOhrse0ksTgniaRMPWS3KH+UYur66J
	WcG+UEyRYbU37z6pwswC+ytBqo/e9h96OVVxQf2rkAkXlFiKMxINtZiLihMBv0N+vnACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, April 10, 2014 02:58:54 AM Jacob Pan wrote:
> On Intel Valleyview SoC, SATA device sleep is not reliable. When
> DEVSLP is attempted on certain SSDs, port_devslp write would fail
> and result in malfunction of AHCI controller. AHCI controller may
> be not shown in PCI enumeration after reset. Complete power source
> removal may be required to recver from this failure. So we blacklist

s/recver/recover/

> this device and override host device reported capabilities such that
> device LPM will only attempt slumber but not devslp.

s/devslp/DEVSLP/

> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Acked-by: Dan Wiilliams <dan.j.williams@intel.com>

s/Wiilliams/Williams/

> ---
>  drivers/ata/ahci.c    | 17 +++++++++++++++++
>  drivers/ata/ahci.h    |  1 +
>  drivers/ata/libahci.c |  7 +++++++
>  3 files changed, 25 insertions(+)
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 5a0bf8e..24684a1 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1115,6 +1115,19 @@ static bool ahci_broken_online(struct pci_dev *pdev)
>  	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
>  }
>  
> +#define PCI_DEVICE_ID_INTEL_VLV_SATA   0x0f23
> +static bool ahci_broken_devslp(struct pci_dev *pdev)
> +{
> +	/* device with broken DEVSLP but still showing SDS capability */
> +	static const struct pci_device_id ids[] = {
> +		{ PCI_DEVICE(PCI_VENDOR_ID_INTEL,
> +				PCI_DEVICE_ID_INTEL_VLV_SATA) },

I think that you can use PCI_VDEVICE() macro instead.

> +		{}
> +	};
> +
> +	return pci_match_id(ids, pdev);
> +}
> +
>  #ifdef CONFIG_ATA_ACPI
>  static void ahci_gtf_filter_workaround(struct ata_host *host)
>  {
> @@ -1357,6 +1370,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
>  
> +	/* must set flag prior to save config in order to take effect */
> +	if (ahci_broken_devslp(pdev))
> +		hpriv->flags |= AHCI_HFLAG_NO_DEVSLP;
> +
>  	/* save initial config */
>  	ahci_pci_save_initial_config(pdev, hpriv);
>  
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 0b670c0..630089a 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -235,6 +235,7 @@ enum {
>  						        port start (wait until
>  						        error-handling stage) */
>  	AHCI_HFLAG_MULTI_MSI		= (1 << 16), /* multiple PCI MSIs */
> +	AHCI_HFLAG_NO_DEVSLP		= (1 << 17), /* no device sleep */

This change conflicts with "[PATCH V2 1/2] ata: ahci: append new hflag
AHCI_HFLAG_NO_FBS" patch (https://lkml.org/lkml/2014/4/10/36).

>  	/* ap->flags bits */
>  
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index 8cd0184..32fd860 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -653,6 +653,13 @@ void ahci_save_initial_config(struct device *dev,
>  		cap &= ~HOST_CAP_SNTF;
>  	}
>  
> +	if ((cap2 & HOST_CAP2_SDS) && (hpriv->flags & AHCI_HFLAG_NO_DEVSLP)) {
> +		dev_info(dev,
> +			 "controller can't do DEVSLP, turning off\n");
> +		cap2 &= ~HOST_CAP2_SDS;
> +		cap2 &= ~HOST_CAP2_SADM;
> +	}
> +
>  	if (!(cap & HOST_CAP_FBS) && (hpriv->flags & AHCI_HFLAG_YES_FBS)) {
>  		dev_info(dev, "controller can do FBS, turning on CAP_FBS\n");
>  		cap |= HOST_CAP_FBS;

ditto

You most likely need to rebase your changes on top of the aforementioned
patch (Tejun?).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

