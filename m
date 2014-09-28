Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaI1Fyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 01:54:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:52247 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaI1Fyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 01:54:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,613,1406617200"; 
   d="scan'208";a="597846094"
Message-ID: <5427A297.7050605@intel.com>
Date: Sun, 28 Sep 2014 13:54:31 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        mister.freeman@laposte.net, rui.zhang@intel.com,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH V2] ata: Disabling the async PM for JMicron chips
References: <1411543338-2257-1-git-send-email-chuansheng.liu@intel.com>
In-Reply-To: <1411543338-2257-1-git-send-email-chuansheng.liu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 03:22 PM, Chuansheng Liu wrote:
> Like the commit e6b7e41cdd8c ("ata: Disabling the async PM for JMicron chip 363/361"),
> Barto found the similar issue for JMicron chip 368, that 363/368 has no
> parent-children relationship, but they have the power dependency.
> 
> So here we can exclude the JMicron chips out of pm_async method directly,
> to avoid further similar issues.
> 
> Details in:
> https://bugzilla.kernel.org/show_bug.cgi?id=84861

I think we can disable the async PM for JMicron chips in PCI subsystem:
pci_pm_init, check if it is JMicron chip and then enable_async
accordingly. The problem doesn't have much to do with ATA, so move them
to PCI may be more appropriate.

Thanks,
Aaron

> 
> Reported-and-tested-by: Barto <mister.freeman@laposte.net>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> ---
>  drivers/ata/ahci.c         |   11 +++++------
>  drivers/ata/pata_jmicron.c |   11 +++++------
>  2 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index a0cc0ed..85aa6ec 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1340,15 +1340,14 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		ahci_pci_bar = AHCI_PCI_BAR_ENMOTUS;
>  
>  	/*
> -	 * The JMicron chip 361/363 contains one SATA controller and one
> +	 * The JMicron chip 361/363/368 contains one SATA controller and one
>  	 * PATA controller,for powering on these both controllers, we must
>  	 * follow the sequence one by one, otherwise one of them can not be
> -	 * powered on successfully, so here we disable the async suspend
> -	 * method for these chips.
> +	 * powered on successfully.
> +	 * Here we can exclude the Jmicron family directly out of pm_async
> +	 * method to follow the power-on sequence.
>  	 */
> -	if (pdev->vendor == PCI_VENDOR_ID_JMICRON &&
> -		(pdev->device == PCI_DEVICE_ID_JMICRON_JMB363 ||
> -		pdev->device == PCI_DEVICE_ID_JMICRON_JMB361))
> +	if (pdev->vendor == PCI_VENDOR_ID_JMICRON)
>  		device_disable_async_suspend(&pdev->dev);
>  
>  	/* acquire resources */
> diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
> index 47e418b..1d685b6 100644
> --- a/drivers/ata/pata_jmicron.c
> +++ b/drivers/ata/pata_jmicron.c
> @@ -144,15 +144,14 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
>  	const struct ata_port_info *ppi[] = { &info, NULL };
>  
>  	/*
> -	 * The JMicron chip 361/363 contains one SATA controller and one
> +	 * The JMicron chip 361/363/368 contains one SATA controller and one
>  	 * PATA controller,for powering on these both controllers, we must
>  	 * follow the sequence one by one, otherwise one of them can not be
> -	 * powered on successfully, so here we disable the async suspend
> -	 * method for these chips.
> +	 * powered on successfully.
> +	 * Here we can exclude the Jmicron family directly out of pm_async
> +	 * method to follow the power-on sequence.
>  	 */
> -	if (pdev->vendor == PCI_VENDOR_ID_JMICRON &&
> -		(pdev->device == PCI_DEVICE_ID_JMICRON_JMB363 ||
> -		pdev->device == PCI_DEVICE_ID_JMICRON_JMB361))
> +	if (pdev->vendor == PCI_VENDOR_ID_JMICRON)
>  		device_disable_async_suspend(&pdev->dev);
>  
>  	return ata_pci_bmdma_init_one(pdev, ppi, &jmicron_sht, NULL, 0);
> 

