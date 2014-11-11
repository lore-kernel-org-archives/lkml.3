Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaKKEH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:07:26 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34427 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaKKEHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:07:22 -0500
Date: Mon, 10 Nov 2014 21:07:17 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] PCI: Deletion of unnecessary checks before three
 function calls
Message-ID: <20141111040717.GD28161@google.com>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <545649DE.80304@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545649DE.80304@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 04:12:30PM +0100, SF Markus Elfring wrote:
> The functions pci_dev_put(), pci_pme_wakeup_bus() and put_device() test
> whether their argument is NULL and then return immediately. Thus the test
> around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Applied to pci/misc for v3.19, thanks!

> ---
>  drivers/pci/pci-acpi.c     | 3 +--
>  drivers/pci/probe.c        | 3 +--
>  drivers/pci/search.c       | 3 +--
>  drivers/pci/xen-pcifront.c | 3 +--
>  4 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> index 37263b0..a8fe5de 100644
> --- a/drivers/pci/pci-acpi.c
> +++ b/drivers/pci/pci-acpi.c
> @@ -60,8 +60,7 @@ static void pci_acpi_wake_dev(struct work_struct *work)
>  	pci_wakeup_event(pci_dev);
>  	pm_runtime_resume(&pci_dev->dev);
> 
> -	if (pci_dev->subordinate)
> -		pci_pme_wakeup_bus(pci_dev->subordinate);
> +	pci_pme_wakeup_bus(pci_dev->subordinate);
>  }
> 
>  /**
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 4170113..e93f16e 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -86,8 +86,7 @@ static void release_pcibus_dev(struct device *dev)
>  {
>  	struct pci_bus *pci_bus = to_pci_bus(dev);
> 
> -	if (pci_bus->bridge)
> -		put_device(pci_bus->bridge);
> +	put_device(pci_bus->bridge);
>  	pci_bus_remove_resources(pci_bus);
>  	pci_release_bus_of_node(pci_bus);
>  	kfree(pci_bus);
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index 827ad83..2d806bd 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -305,8 +305,7 @@ static struct pci_dev *pci_get_dev_by_id(const struct
> pci_device_id *id,
>  			      match_pci_dev_by_id);
>  	if (dev)
>  		pdev = to_pci_dev(dev);
> -	if (from)
> -		pci_dev_put(from);
> +	pci_dev_put(from);
>  	return pdev;
>  }
> 
> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
> index 53df39a..46664cc 100644
> --- a/drivers/pci/xen-pcifront.c
> +++ b/drivers/pci/xen-pcifront.c
> @@ -596,8 +596,7 @@ static pci_ers_result_t pcifront_common_process(int cmd,
>  	pcidev = pci_get_bus_and_slot(bus, devfn);
>  	if (!pcidev || !pcidev->driver) {
>  		dev_err(&pdev->xdev->dev, "device or AER driver is NULL\n");
> -		if (pcidev)
> -			pci_dev_put(pcidev);
> +		pci_dev_put(pcidev);
>  		return result;
>  	}
>  	pdrv = pcidev->driver;
> -- 
> 2.1.3
> 
> 
