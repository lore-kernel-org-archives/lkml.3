Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab3K0BC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:02:29 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62306 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754898Ab3K0BCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:02:24 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/10] PCI: Move resources and bus_list releasing to pci_release_dev
Date: Wed, 27 Nov 2013 02:15:11 +0100
Message-ID: <5956447.Fj3sMXmCsu@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385429290-25397-4-git-send-email-yinghai@kernel.org>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <1385429290-25397-4-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 25, 2013 05:28:03 PM Yinghai Lu wrote:
> We should not release resource in pci_destroy that is too early
> as there could be still other use hold reference.
> 
> release them or remove it from bus devices list at last
> in pci_release_dev instead.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/probe.c  | 21 +++++++++++++++++++--
>  drivers/pci/remove.c | 19 -------------------
>  2 files changed, 19 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 173a9cf..12ec56c 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1154,6 +1154,18 @@ static void pci_release_capabilities(struct pci_dev *dev)
>  	pci_free_cap_save_buffers(dev);
>  }
>  
> +static void pci_free_resources(struct pci_dev *dev)
> +{
> +	int i;
> +
> +	pci_cleanup_rom(dev);
> +	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
> +		struct resource *res = dev->resource + i;
> +		if (res->parent)
> +			release_resource(res);
> +	}
> +}
> +
>  /**
>   * pci_release_dev - free a pci device structure when all users of it are finished.
>   * @dev: device that's been disconnected
> @@ -1163,9 +1175,14 @@ static void pci_release_capabilities(struct pci_dev *dev)
>   */
>  static void pci_release_dev(struct device *dev)
>  {
> -	struct pci_dev *pci_dev;
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +
> +	down_write(&pci_bus_sem);
> +	list_del(&pci_dev->bus_list);
> +	up_write(&pci_bus_sem);
> +
> +	pci_free_resources(pci_dev);

What are the possible side effects of this change?

> -	pci_dev = to_pci_dev(dev);
>  	pci_release_capabilities(pci_dev);
>  	pci_release_of_node(pci_dev);
>  	pcibios_release_device(pci_dev);
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 692f4c3..f452148 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -3,20 +3,6 @@
>  #include <linux/pci-aspm.h>
>  #include "pci.h"
>  
> -static void pci_free_resources(struct pci_dev *dev)
> -{
> -	int i;
> -
> -	msi_remove_pci_irq_vectors(dev);
> -
> -	pci_cleanup_rom(dev);
> -	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
> -		struct resource *res = dev->resource + i;
> -		if (res->parent)
> -			release_resource(res);
> -	}
> -}
> -
>  static void pci_stop_dev(struct pci_dev *dev)
>  {
>  	pci_pme_active(dev, false);
> @@ -36,11 +22,6 @@ static void pci_destroy_dev(struct pci_dev *dev)
>  {
>  	device_del(&dev->dev);
>  
> -	down_write(&pci_bus_sem);
> -	list_del(&dev->bus_list);
> -	up_write(&pci_bus_sem);
> -
> -	pci_free_resources(dev);
>  	put_device(&dev->dev);

And if the side effects are benign enough, why don't we do a device_unregister()
here?

>  }
>  

Rafael

