Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaKCKkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:40:07 -0500
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:43923 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaKCKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:40:04 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2014 05:40:04 EST
Message-ID: <54575A31.3090202@laposte.net>
Date: Mon, 03 Nov 2014 11:34:25 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>, "tj"@kernel.org,
        rjw@rjwysocki.net
Subject: Re: FW: [PATCH V2] ata: Disabling the async PM for JMicron chips
References: <1411543338-2257-1-git-send-email-chuansheng.liu@intel.com> <27240C0AC20F114CBF8149A2696CBE4A01EB378D@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01EB378D@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrgedvgddtlecutefuodetggdotefrucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtgfesthekrgdttdefheenucfhrhhomhepuegrrhhtohcuoehmihhsthgvrhdrfhhrvggvmhgrnheslhgrphhoshhtvgdrnhgvtheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrgh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

yes I confirm that this patch solves the problem with JMicron JMB363-368
sata/ide controlers,

I have tested this patch with kernel 3.17.2 and kernel 3.18rc3, my
JMicron JMB363/368 can now work after a standby mode,

so I hope that this patch will be merged


Le 03/11/2014 10:13, Liu, Chuansheng a écrit :
> Hello Mister,
> You should have received this email, please reply to all with your test result, which will help the patch merged, thanks.
> 
> Best Regards
> Chuansheng
> 
> -----Original Message-----
> From: Liu, Chuansheng 
> Sent: Wednesday, September 24, 2014 3:22 PM
> To: tj@kernel.org; rjw@rjwysocki.net
> Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org; mister.freeman@laposte.net; Zhang, Rui; Liu, Chuansheng
> Subject: [PATCH V2] ata: Disabling the async PM for JMicron chips
> 
> Like the commit e6b7e41cdd8c ("ata: Disabling the async PM for JMicron chip 363/361"),
> Barto found the similar issue for JMicron chip 368, that 363/368 has no
> parent-children relationship, but they have the power dependency.
> 
> So here we can exclude the JMicron chips out of pm_async method directly,
> to avoid further similar issues.
> 
> Details in:
> https://bugzilla.kernel.org/show_bug.cgi?id=84861
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
