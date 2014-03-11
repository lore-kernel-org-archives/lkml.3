Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaCKXXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:23:22 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52872 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755861AbaCKXXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:23:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, jwollrath@web.de, markus@trippelsdorf.de,
        pebolle@tiscali.nl
Subject: Re: [PATCH] PNPACPI: proper handling ACPI IO/Memory resources
Date: Wed, 12 Mar 2014 00:38:39 +0100
Message-ID: <3883740.St1mC7IYnm@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394548827-15172-1-git-send-email-rui.zhang@intel.com>
References: <1394548827-15172-1-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 11, 2014 10:40:27 PM Zhang Rui wrote:
> Before commit b355cee88e3b1a193f0e9a81db810f6f83ad728b,
> if acpi_dev_resource_memory()/acpi_dev_resource_io() returns false,
> it means the the resource is not a memeory/IO resource.
> 
> But after commit b355cee88e3b1a193f0e9a81db810f6f83ad728b,
> if the memory/IO resource is invalid (the length of the resource is zero),
> acpi_dev_resource_memory()/acpi_dev_resource_io() returns false as well.
> 
> This breaks pnpacpi_allocated_resource(), because the current code would
> recognize the invalid memory/io resource as unknown resource type.
> Thus users will get warning messages on machines with zero length
> ACPI memeory/IO resources.
> 
> This patch fixes the problem by invoking acpi_dev_resource_memory()/
> acpi_dev_resource_io() for ACPI memory/IO resources only.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

Applied, thanks Rui!

> ---
>  drivers/pnp/pnpacpi/rsparser.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
> index 167f3d0..66977eb 100644
> --- a/drivers/pnp/pnpacpi/rsparser.c
> +++ b/drivers/pnp/pnpacpi/rsparser.c
> @@ -183,9 +183,7 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
>  	struct resource r = {0};
>  	int i, flags;
>  
> -	if (acpi_dev_resource_memory(res, &r)
> -	    || acpi_dev_resource_io(res, &r)
> -	    || acpi_dev_resource_address_space(res, &r)
> +	if (acpi_dev_resource_address_space(res, &r)
>  	    || acpi_dev_resource_ext_address_space(res, &r)) {
>  		pnp_add_resource(dev, &r);
>  		return AE_OK;
> @@ -217,6 +215,17 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
>  	}
>  
>  	switch (res->type) {
> +	case ACPI_RESOURCE_TYPE_MEMORY24:
> +	case ACPI_RESOURCE_TYPE_MEMORY32:
> +	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
> +		if (acpi_dev_resource_memory(res, &r))
> +			pnp_add_resource(dev, &r);
> +		break;
> +	case ACPI_RESOURCE_TYPE_IO:
> +	case ACPI_RESOURCE_TYPE_FIXED_IO:
> +		if (acpi_dev_resource_io(res, &r))
> +			pnp_add_resource(dev, &r);
> +		break;
>  	case ACPI_RESOURCE_TYPE_DMA:
>  		dma = &res->data.dma;
>  		if (dma->channel_count > 0 && dma->channels[0] != (u8) -1)
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
