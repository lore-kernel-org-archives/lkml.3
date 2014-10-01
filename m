Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaJAIyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:54:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34569 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaJAIyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:54:40 -0400
Date: Wed, 1 Oct 2014 09:54:36 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Rob Herring <robh@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of/pci: add pci_pio_to_address dummy for !CONFIG_OF
Message-ID: <20141001085436.GA841@e106497-lin.cambridge.arm.com>
References: <706416181.hbVGLDA3o6@wuerfel>
MIME-Version: 1.0
In-Reply-To: <706416181.hbVGLDA3o6@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 01 Oct 2014 08:54:36.0874 (UTC) FILETIME=[54070AA0:01CFDD55]
X-MC-Unique: 114100109543802501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 02:19:05PM +0100, Arnd Bergmann wrote:
> The pci_register_io_range() and pci_pio_to_address() were recently
> introduced to generalize the handling of memory mapped PCI I/O space,
> but they are only valid when CONFIG_OF is set, leading to a possible
> build error:
> 
> drivers/pci/host/pcie-rcar.c: In function 'rcar_pcie_setup_window':
> drivers/pci/host/pcie-rcar.c:340:3: error: implicit declaration of function 'pci_pio_to_address' [-Werror=implicit-function-declaration]
>    res_start = pci_pio_to_address(res->start);
>    ^
> drivers/pci/host/pcie-rcar.c: In function 'rcar_pcie_probe':
> drivers/pci/host/pcie-rcar.c:945:3: error: implicit declaration of function 'of_pci_range_to_resource' [-Werror=implicit-function-declaration]
>    err = of_pci_range_to_resource(&range, pdev->dev.of_node,
>    ^
> cc1: some warnings being treated as errors
> 
> This provides inline dummy implementations for the case that
> CONFIG_OF is disabled, to allow better build testing.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 279c5dd046 ("of/pci: Add pci_register_io_range() and pci_pio_to_address()")
> 
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 7ebb877b07c2..851097aab115 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -71,6 +71,11 @@ static inline const __be32 *of_get_address(struct device_node *dev, int index,
>  	return NULL;
>  }
>  
> +static inline phys_addr_t pci_pio_to_address(unsigned long pio)
> +{
> +	return 0;
> +}
> +
>  static inline int of_pci_range_parser_init(struct of_pci_range_parser *parser,
>  			struct device_node *node)
>  {
> @@ -144,6 +149,12 @@ static inline const __be32 *of_get_pci_address(struct device_node *dev,
>  {
>  	return NULL;
>  }
> +static inline int of_pci_range_to_resource(struct of_pci_range *range,
> +					   struct device_node *np,
> +					   struct resource *res)
> +{
> +	return -ENOSYS;
> +}
>  #endif /* CONFIG_OF_ADDRESS && CONFIG_PCI */
>  
>  #endif /* __OF_ADDRESS_H */
> 

Arnd,

I have a more general question that is related only vaguely to this patch but it was prompted by it:
given that this pcie-rcar.c driver is so dependent on the OF functionality, why the fix(es) (in
general) tend to prefer creating these dummy functions for !CONFIG_OF rather than making
CONFIG_PCI_RCAR_GEN2_PCIE dependent on CONFIG_OF? We are basically compiling a driver that we can
guarantee it will fail when used without OF support and contribute to the overall size of the kernel.
Given the presentation you have done at Linaro Connect last month on this topic, I started to wonder
if there is a deeper API style agreement that is not apparent to me?

Thanks for your time,
Liviu

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

