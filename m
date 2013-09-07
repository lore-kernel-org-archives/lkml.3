Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024Ab3IGAPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 20:15:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37412 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab3IGAPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 20:15:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, yinghai@kernel.org, bhelgaas@google.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] ACPI: Add new acpi_dev_resource_address_space_with_addr() function
Date: Sat, 07 Sep 2013 02:26:05 +0200
Message-ID: <30641425.ncNBBIQlZc@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1378477486-8758-4-git-send-email-tianyu.lan@intel.com>
References: <1378477486-8758-1-git-send-email-tianyu.lan@intel.com> <1378477486-8758-4-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 06, 2013 10:24:45 AM Lan Tianyu wrote:
> Make acpi_dev_resource_address_space() to accept struct
> acpi_resource_address64 as param and rename it to *_with_addr.

I'd prefer acpi_dev_resource_address_space_full() or something like this.

Apart from this it is fine by me.

Thanks,
Rafael


> This is for some cases that acpi address info is also needed
> after convert from acpi resouce to generic resource.
> 
> Add acpi_devi_resource_addres_space() again as a wrapper of new
> function for original users.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/acpi/resource.c | 53 ++++++++++++++++++++++++++++++++++---------------
>  include/linux/acpi.h    |  3 +++
>  2 files changed, 40 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index 84bc3db..76da28b 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -162,19 +162,21 @@ bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res)
>  EXPORT_SYMBOL_GPL(acpi_dev_resource_io);
>  
>  /**
> - * acpi_dev_resource_address_space - Extract ACPI address space information.
> + * acpi_dev_resource_address_space_with_addr - Extract ACPI address space information.
>   * @ares: Input ACPI resource object.
> + * @addr: Output ACPI resource address64 space object.
>   * @res: Output generic resource object.
>   *
>   * Check if the given ACPI resource object represents an address space resource
> - * and if that's the case, use the information in it to populate the generic
> - * resource object pointed to by @res.
> + * and if that's the case, convert it to ACPI resource address64 space object
> + * pointed to by @addr and use the information to populate the generic resource
> + * object pointed to by @re.
>   */
> -bool acpi_dev_resource_address_space(struct acpi_resource *ares,
> +bool acpi_dev_resource_address_space_with_addr(struct acpi_resource *ares,
> +				     struct acpi_resource_address64 *addr,
>  				     struct resource *res)
>  {
>  	acpi_status status;
> -	struct acpi_resource_address64 addr;
>  	bool window;
>  	u64 len;
>  	u8 io_decode;
> @@ -188,29 +190,29 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
>  		return false;
>  	}
>  
> -	status = acpi_resource_to_address64(ares, &addr);
> +	status = acpi_resource_to_address64(ares, addr);
>  	if (ACPI_FAILURE(status))
>  		return true;
>  
> -	res->start = addr.minimum + addr.translation_offset;
> -	res->end = addr.maximum + addr.translation_offset;
> -	window = addr.producer_consumer == ACPI_PRODUCER;
> +	res->start = addr->minimum + addr->translation_offset;
> +	res->end = addr->maximum + addr->translation_offset;
> +	window = addr->producer_consumer == ACPI_PRODUCER;
>  
> -	switch(addr.resource_type) {
> +	switch (addr->resource_type) {
>  	case ACPI_MEMORY_RANGE:
> -		len = addr.maximum - addr.minimum + 1;
> +		len = addr->maximum - addr->minimum + 1;
>  		res->flags = acpi_dev_memresource_flags(len,
> -						addr.info.mem.write_protect,
> +						addr->info.mem.write_protect,
>  						window);
>  
> -		if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
> +		if (addr->info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
>  			res->flags |= IORESOURCE_PREFETCH;
>  		break;
>  	case ACPI_IO_RANGE:
> -		io_decode = addr.granularity == 0xfff ?
> +		io_decode = addr->granularity == 0xfff ?
>  				ACPI_DECODE_10 : ACPI_DECODE_16;
> -		res->flags = acpi_dev_ioresource_flags(addr.minimum,
> -						       addr.maximum,
> +		res->flags = acpi_dev_ioresource_flags(addr->minimum,
> +						       addr->maximum,
>  						       io_decode, window);
>  		break;
>  	case ACPI_BUS_NUMBER_RANGE:
> @@ -222,6 +224,25 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
>  
>  	return true;
>  }
> +EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space_with_addr);
> +
> +/**
> + * acpi_dev_resource_address_space - Extract ACPI address space information.
> + * @ares: Input ACPI resource object.
> + * @res: Output generic resource object.
> + *
> + * Check if the given ACPI resource object represents an address space resource
> + * and if that's the case, use the information in it to populate the generic
> + * resource object pointed to by @res.
> + */
> +bool acpi_dev_resource_address_space(struct acpi_resource *ares,
> +				     struct resource *res)
> +{
> +	struct acpi_resource_address64 addr;
> +
> +	return acpi_dev_resource_address_space_with_addr(ares, &addr,
> +							 res);
> +}
>  EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space);
>  
>  /**
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index a5db4ae..9f5c0d5 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -260,6 +260,9 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res);
>  bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res);
>  bool acpi_dev_resource_address_space(struct acpi_resource *ares,
>  				     struct resource *res);
> +bool acpi_dev_resource_address_space_with_addr(struct acpi_resource *ares,
> +				struct acpi_resource_address64 *addr,
> +				struct resource *res);
>  bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
>  					 struct resource *res);
>  unsigned long acpi_dev_irq_flags(u8 triggering, u8 polarity, u8 shareable);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
