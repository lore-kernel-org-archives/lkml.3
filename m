Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3H0Jpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:45:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab3H0Jpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:45:33 -0400
Date: Tue, 27 Aug 2013 11:45:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Bjorn Helgaas <bhelgaas@google.com>, Adam Radford <linuxraid@lsi.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PCI: add quirk for 3ware 9650SE controller
In-Reply-To: <alpine.LNX.2.00.1308271141080.2077@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1308271144420.2077@pobox.suse.cz>
References: <alpine.LNX.2.00.1308271141080.2077@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding Bjorn and Eric to CC, sorry for omitting you originally ]

On Tue, 27 Aug 2013, Jiri Kosina wrote:

> Commit d5dea7d95 ("PCI: msi: Disable msi interrupts when we initialize a 
> pci device") makes MSIs be forcibly disabled at boot time.
> 
> It turns out that this breaks 3ware controller -- if MSIs are disabled 
> during PCI discovery of this controller, the device doesn't work properly 
> (it doesn't respond to any commands that are being sent to it after 
> initialization).
> 
> Reverting d5dea7d95 or not force-disabling MSIs in pci_msi_init_pci_dev()
> makes the device work properly again.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
> 
> I am adding Adam Radford as a recepient as well, to see whether he is able 
> to provide some more explanation why this device would expose this 
> behavior.
> Thanks.
> 
>  drivers/pci/msi.c    |    3 +++
>  drivers/pci/quirks.c |   10 ++++++++++
>  include/linux/pci.h  |    1 +
>  3 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index aca7578..4f36b8b 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -1040,6 +1040,9 @@ void pci_msi_init_pci_dev(struct pci_dev *dev)
>  {
>  	INIT_LIST_HEAD(&dev->msi_list);
>  
> +	if (dev->broken_msi_disable)
> +		return;
> +
>  	/* Disable the msi hardware to avoid screaming interrupts
>  	 * during boot.  This is the power on reset default so
>  	 * usually this should be a noop.
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index e85d230..4ba3400 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2890,6 +2890,16 @@ static void quirk_intel_ntb(struct pci_dev *dev)
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0e08, quirk_intel_ntb);
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0e0d, quirk_intel_ntb);
>  
> +/*
> + * 3ware 9650SE controller doesn't properly initialize if MSI are
> + * disabled on it during PCI device discovery
> + */
> +static void quirk_broken_msi_disable(struct pci_dev *dev)
> +{
> +	dev->broken_msi_disable = 1;
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_3WARE, 0x1004, quirk_broken_msi_disable);
> +
>  static ktime_t fixup_debug_start(struct pci_dev *dev,
>  				 void (*fn)(struct pci_dev *dev))
>  {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 0fd1f15..c327d74 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -341,6 +341,7 @@ struct pci_dev {
>  #ifdef CONFIG_PCI_MSI
>  	struct list_head msi_list;
>  	struct kset *msi_kset;
> +	unsigned int	broken_msi_disable:1;
>  #endif
>  	struct pci_vpd *vpd;
>  #ifdef CONFIG_PCI_ATS
> 
> -- 
> Jiri Kosina
> SUSE Labs
> 

-- 
Jiri Kosina
SUSE Labs
