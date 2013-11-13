Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab3KMPu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:50:26 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:32821 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756789Ab3KMPuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:50:21 -0500
Date: Wed, 13 Nov 2013 15:50:17 +0000
From: Matt Fleming <matt@console-pimps.org>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 3/7 v2] Cleanup efi_enter_virtual_mode function
Message-ID: <20131113155017.GB17248@console-pimps.org>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082716.825753041@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105082716.825753041@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Nov, at 04:20:10PM, dyoung@redhat.com wrote:
> Add two small functions:
> efi_merge_regions and efi_map_regions, efi_enter_virtual_mode
> calls them instead of embedding two long for loop.
> 
> v1->v2:
> refresh; coding style fixes.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c |  107 +++++++++++++++++++++++++-------------------
>  1 file changed, 63 insertions(+), 44 deletions(-)

[...]

> @@ -860,17 +840,59 @@ void __init efi_enter_virtual_mode(void)
>  			efi.systab = (efi_system_table_t *) (unsigned long) systab;
>  		}
>  
> -		new_memmap = krealloc(new_memmap,
> -				      (count + 1) * memmap.desc_size,
> -				      GFP_KERNEL);
> -		if (!new_memmap)
> +		*new_memmap = krealloc(*new_memmap,
> +					(*count + 1) * memmap.desc_size,
> +					GFP_KERNEL);
> +		if (!*new_memmap)
>  			goto err_out;
>  
> -		memcpy(new_memmap + (count * memmap.desc_size), md,
> +		memcpy(*new_memmap + (*count * memmap.desc_size), md,
>  		       memmap.desc_size);
> -		count++;
> +		(*count)++;
>  	}
>  
> +err_out:
> +	pr_err("Error reallocating memory, EFI runtime non-functional!\n");
> +}

You should really return an error value here so that we don't
dereference 'new_memmap' below if it's NULL. In fact, just return the
memmap...

> +
> +	efi_merge_regions();
> +
> +	efi_map_regions(&new_memmap, &count);
> +

and make sure to check the return value here.

-- 
Matt Fleming, Intel Open Source Technology Center
