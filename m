Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaKLP3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:29:24 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38048 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaKLP3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:29:23 -0500
Message-ID: <54637CCF.6020501@arm.com>
Date: Wed, 12 Nov 2014 15:29:19 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 16/16] PCI/MSI: Enhance core to support hierarchy irqdomain
References: <20141112133941.647950773@linutronix.de> <20141112134121.196562300@linutronix.de>
In-Reply-To: <20141112134121.196562300@linutronix.de>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 12 Nov 2014 15:29:19.0911 (UTC) FILETIME=[6D913370:01CFFE8D]
X-MC-Unique: 114111215292007701
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 12/11/14 13:43, Thomas Gleixner wrote:
> From: Jiang Liu <jiang.liu@linux.intel.com>
> 
> Enhance PCI MSI core to support hierarchy irqdomain, so the common
> code can be shared across architectures.
> 
> [ tglx: Extracted and combined from several patches ]
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
> Cc: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/pci/Kconfig |    5 ++++
>  drivers/pci/msi.c   |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/msi.h |    8 ++++++
>  3 files changed, 75 insertions(+)
> 
> Index: tip/drivers/pci/Kconfig
> ===================================================================
> --- tip.orig/drivers/pci/Kconfig
> +++ tip/drivers/pci/Kconfig
> @@ -17,6 +17,11 @@ config PCI_MSI
>  
>  	   If you don't know what to do here, say Y.
>  
> +config PCI_MSI_IRQ_DOMAIN
> +	bool
> +	depends on PCI_MSI
> +	select GENERIC_MSI_IRQ_DOMAIN
> +
>  config PCI_DEBUG
>  	bool "PCI Debugging"
>  	depends on PCI && DEBUG_KERNEL
> Index: tip/drivers/pci/msi.c
> ===================================================================
> --- tip.orig/drivers/pci/msi.c
> +++ tip/drivers/pci/msi.c
> @@ -19,6 +19,7 @@
>  #include <linux/errno.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> +#include <linux/irqdomain.h>
>  
>  #include "pci.h"
>  
> @@ -1072,3 +1073,64 @@ int pci_enable_msix_range(struct pci_dev
>  	return nvec;
>  }
>  EXPORT_SYMBOL(pci_enable_msix_range);
> +
> +#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
> +void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg *msg)
> +{
> +	struct msi_desc *desc = irq_data->msi_desc;
> +
> +	/*
> +	 * MSI-X message is written per-IRQ.
> +	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
> +	 */
> +	if (desc->irq == irq_data->irq)
> +		pci_write_msi_msg(desc, msg);

My compiler barks at this. Shouldn't that be either:
		pci_write_msi_msg(desc->irq, msg);
or
		__pci_write_msi_msg(desc, msg);
?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

