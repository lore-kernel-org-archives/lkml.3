Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab3ENDVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 23:21:03 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:13038 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3ENDVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 23:21:00 -0400
Message-ID: <5191AD65.7090105@huawei.com>
Date: Tue, 14 May 2013 11:20:05 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] PCI: move resources and bus_list releasing to pci_release_dev
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org> <1368498506-25857-3-git-send-email-yinghai@kernel.org>
In-Reply-To: <1368498506-25857-3-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/14 10:28, Yinghai Lu wrote:
> We should not release resource in pci_destroy that is too early

Hi Yinghai,
   "too early" means that after pci_stop_dev(), if someone else
hold the device reference, it still care the device resource ? e.g.?

Thanks!
Yijing.

> as there could be still other use hold reference.
> 
> release them or remove it from bus devices list at last
> in pci_release_dev instead.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/probe.c  |   20 ++++++++++++++++++++
>  drivers/pci/remove.c |   19 -------------------
>  2 files changed, 20 insertions(+), 19 deletions(-)
> 
> Index: linux-2.6/drivers/pci/probe.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/probe.c
> +++ linux-2.6/drivers/pci/probe.c
> @@ -1118,6 +1118,20 @@ static void pci_release_capabilities(str
>  	pci_free_cap_save_buffers(dev);
>  }
>  
> +static void pci_free_resources(struct pci_dev *dev)
> +{
> +	int i;
> +
> +	msi_remove_pci_irq_vectors(dev);
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
> @@ -1130,6 +1144,12 @@ static void pci_release_dev(struct devic
>  	struct pci_dev *pci_dev;
>  
>  	pci_dev = to_pci_dev(dev);
> +
> +	down_write(&pci_bus_sem);
> +	list_del(&pci_dev->bus_list);
> +	up_write(&pci_bus_sem);
> +	pci_free_resources(pci_dev);
> +
>  	pci_release_capabilities(pci_dev);
>  	pci_release_of_node(pci_dev);
>  	kfree(pci_dev);
> Index: linux-2.6/drivers/pci/remove.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/remove.c
> +++ linux-2.6/drivers/pci/remove.c
> @@ -3,20 +3,6 @@
>  #include <linux/pci-aspm.h>
>  #include "pci.h"
>  
> -static void pci_free_resources(struct pci_dev *dev)
> -{
> -	int i;
> -
> - 	msi_remove_pci_irq_vectors(dev);
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
> @@ -34,11 +20,6 @@ static void pci_stop_dev(struct pci_dev
>  
>  static void pci_destroy_dev(struct pci_dev *dev)
>  {
> -	down_write(&pci_bus_sem);
> -	list_del(&dev->bus_list);
> -	up_write(&pci_bus_sem);
> -
> -	pci_free_resources(dev);
>  	put_device(&dev->dev);
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


-- 
Thanks!
Yijing

