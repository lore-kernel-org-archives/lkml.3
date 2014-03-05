Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbaCEDtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:49:50 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:36244 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222AbaCEDts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:49:48 -0500
Message-ID: <53169E86.1090609@huawei.com>
Date: Wed, 5 Mar 2014 11:48:22 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 3/7] pci: Create pci_host_bridge before its associated
 bus in pci_create_root_bus.
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com> <1393948204-11555-4-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1393948204-11555-4-git-send-email-Liviu.Dudau@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/4 23:50, Liviu Dudau wrote:
> Before commit 7b5436635800 the pci_host_bridge was created before the root bus.
> As that commit has added a needless dependency on the bus for pci_alloc_host_bridge()
> the creation order has been changed for no good reason. Revert the order of
> creation as we are going to depend on the pci_host_bridge structure to retrieve the
> domain number of the root bus.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 6e34498..78ccba0 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -505,7 +505,7 @@ static void pci_release_host_bridge_dev(struct device *dev)
>  	kfree(bridge);
>  }
>  
> -static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
> +static struct pci_host_bridge *pci_alloc_host_bridge(void)
>  {
>  	struct pci_host_bridge *bridge;
>  
> @@ -514,7 +514,6 @@ static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
>  		return NULL;
>  
>  	INIT_LIST_HEAD(&bridge->windows);
> -	bridge->bus = b;
>  	return bridge;
>  }
>  
> @@ -1727,9 +1726,21 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  	char bus_addr[64];
>  	char *fmt;
>  
> +	bridge = pci_alloc_host_bridge();
> +	if (!bridge)
> +		return NULL;
> +
> +	bridge->dev.parent = parent;
> +	bridge->dev.release = pci_release_host_bridge_dev;
> +	error = pcibios_root_bridge_prepare(bridge);
> +	if (error) {
> +		kfree(bridge);
> +		return NULL;

What about use goto err_out?

> +	}
> +
>  	b = pci_alloc_bus();
>  	if (!b)
> -		return NULL;
> +		goto err_out;
>  
>  	b->sysdata = sysdata;
>  	b->ops = ops;
> @@ -1738,26 +1749,15 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  	if (b2) {
>  		/* If we already got to this bus through a different bridge, ignore it */
>  		dev_dbg(&b2->dev, "bus already known\n");
> -		goto err_out;
> +		goto err_bus_out;
>  	}
>  
> -	bridge = pci_alloc_host_bridge(b);
> -	if (!bridge)
> -		goto err_out;
> -
> -	bridge->dev.parent = parent;
> -	bridge->dev.release = pci_release_host_bridge_dev;
> +	bridge->bus = b;
>  	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
> -	error = pcibios_root_bridge_prepare(bridge);
> -	if (error) {
> -		kfree(bridge);
> -		goto err_out;
> -	}
> -
>  	error = device_register(&bridge->dev);
>  	if (error) {
>  		put_device(&bridge->dev);
> -		goto err_out;
> +		goto err_bus_out;
>  	}
>  	b->bridge = get_device(&bridge->dev);
>  	device_enable_async_suspend(b->bridge);
> @@ -1814,8 +1814,10 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  class_dev_reg_err:
>  	put_device(&bridge->dev);
>  	device_unregister(&bridge->dev);
> -err_out:
> +err_bus_out:
>  	kfree(b);
> +err_out:
> +	kfree(bridge);
>  	return NULL;
>  }
>  
> 


-- 
Thanks!
Yijing

