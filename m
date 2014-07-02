Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaGBJU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:20:28 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60002 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaGBJU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:20:27 -0400
Message-ID: <53B3CEAC.9080609@windriver.com>
Date: Wed, 2 Jul 2014 17:19:40 +0800
From: "Yang,Wei" <Wei.Yang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: <Wei.Yang@windriver.com>, <mroberto@cpti.cetuc.puc-rio.br>,
        <rmk+kernel@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v1] ARM:sa1100: Remove a redundant spin lock
References: <1404200488-7809-1-git-send-email-Wei.Yang@windriver.com>
In-Reply-To: <1404200488-7809-1-git-send-email-Wei.Yang@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

What about this patch?

Thanks
Wei
On 07/01/2014 03:41 PM, Wei.Yang@windriver.com wrote:
> From: Yang Wei <Wei.Yang@windriver.com>
>
> The pair read/write of accessing pci confiuration space function
> has already protected by pci_lock. so remove nano_lock.
>
> Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
> ---
>   arch/arm/mach-sa1100/pci-nanoengine.c |    9 ---------
>   1 file changed, 9 deletions(-)
>
> diff --git a/arch/arm/mach-sa1100/pci-nanoengine.c b/arch/arm/mach-sa1100/pci-nanoengine.c
> index ff02e2d..b944c99 100644
> --- a/arch/arm/mach-sa1100/pci-nanoengine.c
> +++ b/arch/arm/mach-sa1100/pci-nanoengine.c
> @@ -30,7 +30,6 @@
>   #include <mach/nanoengine.h>
>   #include <mach/hardware.h>
>   
> -static DEFINE_SPINLOCK(nano_lock);
>   
>   static int nanoengine_get_pci_address(struct pci_bus *bus,
>   	unsigned int devfn, int where, unsigned long *address)
> @@ -52,7 +51,6 @@ static int nanoengine_read_config(struct pci_bus *bus, unsigned int devfn, int w
>   {
>   	int ret;
>   	unsigned long address;
> -	unsigned long flags;
>   	u32 v;
>   
>   	/* nanoEngine PCI bridge does not return -1 for a non-existing
> @@ -64,15 +62,12 @@ static int nanoengine_read_config(struct pci_bus *bus, unsigned int devfn, int w
>   		goto exit_function;
>   	}
>   
> -	spin_lock_irqsave(&nano_lock, flags);
>   
>   	ret = nanoengine_get_pci_address(bus, devfn, where, &address);
>   	if (ret != PCIBIOS_SUCCESSFUL)
>   		return ret;
>   	v = __raw_readl(address);
>   
> -	spin_unlock_irqrestore(&nano_lock, flags);
> -
>   	v >>= ((where & 3) * 8);
>   	v &= (unsigned long)(-1) >> ((4 - size) * 8);
>   
> @@ -86,13 +81,11 @@ static int nanoengine_write_config(struct pci_bus *bus, unsigned int devfn, int
>   {
>   	int ret;
>   	unsigned long address;
> -	unsigned long flags;
>   	unsigned shift;
>   	u32 v;
>   
>   	shift = (where & 3) * 8;
>   
> -	spin_lock_irqsave(&nano_lock, flags);
>   
>   	ret = nanoengine_get_pci_address(bus, devfn, where, &address);
>   	if (ret != PCIBIOS_SUCCESSFUL)
> @@ -113,8 +106,6 @@ static int nanoengine_write_config(struct pci_bus *bus, unsigned int devfn, int
>   	}
>   	__raw_writel(v, address);
>   
> -	spin_unlock_irqrestore(&nano_lock, flags);
> -
>   	return PCIBIOS_SUCCESSFUL;
>   }
>   

