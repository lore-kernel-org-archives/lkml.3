Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaDVEKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 00:10:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39524 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaDVEKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 00:10:12 -0400
Message-ID: <5355EB77.7000306@ti.com>
Date: Mon, 21 Apr 2014 23:09:27 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-kernel@vger.kernel.org>
CC: <devicetree@vger.kernel.org>, Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/7] of: introduce of_dma_get_range() helper
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com> <1397917972-6293-3-git-send-email-santosh.shilimkar@ti.com>
In-Reply-To: <1397917972-6293-3-git-send-email-santosh.shilimkar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2014 09:32 AM, Santosh Shilimkar wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
[..]
> + * Look in bottom up direction for the first "dma-range" property
> + * and parse it.
> + *  dma-ranges format:
> + *	DMA addr (dma_addr)	: naddr cells
> + *	CPU addr (phys_addr_t)	: pna cells
> + *	size			: nsize cells
> + *
> + * It returns -ENODEV if "dma-ranges" property was not found
> + * for this device in DT.
> + */
> +extern int of_dma_get_range(struct device_node *np, dma_addr_t *dma_addr,
> +		phys_addr_t *paddr, phys_addr_t *size)
> +{
> +	struct device_node *node = np;
> +	const u32 *ranges = NULL;
> +	int len, naddr, nsize, pna;
> +	int ret = 0;
> +
> +	if (!node)
> +		return -EINVAL;
> +
> +	while (1) {
> +		naddr = of_n_addr_cells(node);
> +		nsize = of_n_size_cells(node);
> +		node = of_get_next_parent(node);
> +		if (!node)
> +			break;
> +
> +		ranges = of_get_property(node, "dma-ranges", &len);
> +
> +		/* Ignore empty ranges, they imply no translation required */
> +		if (ranges && len > 0)
> +			break;
> +
> +		/*
> +		 * At least empty ranges has to be defined for parent node if
> +		 * DMA is supported
> +		 */
> +		if (!ranges)
> +			break;
> +	}
> +
> +	if (!ranges) {
> +		pr_debug("%s: no dma-ranges found for node(%s)\n",
> +			 __func__, np->full_name);
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +
> +	len /= sizeof(u32);
> +
> +	pna = of_n_addr_cells(node);
> +
> +	/* dma-ranges format:
> +	 * DMA addr	: naddr cells
> +	 * CPU addr	: pna cells
> +	 * size		: nsize cells
> +	 */
> +	*dma_addr = of_read_number(ranges, naddr);
> +	*paddr = of_translate_dma_address(np, ranges);

I am probably missing something but I'm wondering the need for a
translate step here instead of doing something like:

*paddr = of_read_number(ranges + naddr, pna);

Perhaps there is a need to do a translate step of the DMA Address in
dma-ranges all the way to the parent, which can be different from the
CPU Address (second address in dma-ranges).

in which case the format of dma-ranges after parsing looks like
<DMA-Addr Translate(DMA-Addr) Size>
to the caller, and not, <DMA-Addr CPU-Addr Size>

But for keystone if something like the following is used,		
 dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;

Then, the above fragment I proposed would return 0x8 0x00000000 which is
sufficient?

thanks,
 -Joel



> +	if (*paddr == OF_BAD_ADDR) {
> +		pr_err("%s: translation of DMA address(%pad) to CPU address failed node(%s)\n",
> +		       __func__, dma_addr, np->full_name);
> +		ret = -EINVAL;
> +	}
> +
> +	*size = of_read_number(ranges + naddr + pna, nsize);
> +
> +	pr_debug("dma_addr(%pad) cpu_addr(%pa) size(%pa)\n",
> +		 dma_addr, paddr, size);
> +
> +out:
> +	of_node_put(node);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(of_dma_get_range);
>  #endif /* CONFIG_OF_ADDRESS */
> diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
> index 05cb4a9..ba7d3dc 100644
> --- a/include/linux/of_platform.h
> +++ b/include/linux/of_platform.h
> @@ -72,6 +72,8 @@ extern int of_platform_populate(struct device_node *root,
>  				const struct of_device_id *matches,
>  				const struct of_dev_auxdata *lookup,
>  				struct device *parent);
> +extern int of_dma_get_range(struct device_node *np, dma_addr_t *dma_addr,
> +				phys_addr_t *paddr, phys_addr_t *size);
>  #else
>  static inline int of_platform_populate(struct device_node *root,
>  					const struct of_device_id *matches,
> @@ -80,6 +82,12 @@ static inline int of_platform_populate(struct device_node *root,
>  {
>  	return -ENODEV;
>  }
> +
> +static inline int of_dma_get_range(struct device_node *np, dma_addr_t *dma_addr,
> +					phys_addr_t *paddr, phys_addr_t *size)
> +{
> +	return -ENODEV;
> +}
>  #endif
>  
>  #endif	/* _LINUX_OF_PLATFORM_H */
> 

