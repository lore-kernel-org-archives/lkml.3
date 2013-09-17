Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab3IQUPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:15:06 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41936 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752921Ab3IQUPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:15:04 -0400
Date: Tue, 17 Sep 2013 21:14:52 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Linn Crosetto <linn@hp.com>
Cc: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] x86: EFI stub support for large memory maps
Message-ID: <20130917201452.GI3409@console-pimps.org>
References: <1377291771-21302-1-git-send-email-linn@hp.com>
 <1378487056-9857-1-git-send-email-linn@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378487056-9857-1-git-send-email-linn@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Sep, at 11:04:16AM, Linn Crosetto wrote:
> This patch fixes a problem with EFI memory maps larger than 128 entries
> when booting using the EFI stub, which results in overflowing e820_map
> in boot_params and an eventual halt when checking the map size in
> sanitize_e820_map().
> 
> If the number of map entries is greater than what can fit in e820_map,
> add the extra entries to the setup_data list using type SETUP_E820_EXT.
> These extra entries are then picked up when the setup_data list is
> parsed in parse_e820_ext().
> 
> Signed-off-by: Linn Crosetto <linn@hp.com>
> ---
> Changes in v2:
> * Free memory when error is returned from alloc_e820ext() as suggested by Matt
>   Fleming
> * Set pointer to NULL and size to 0 after freeing memory in alloc_e820ext()
> 
>  arch/x86/boot/compressed/eboot.c | 223 ++++++++++++++++++++++++++++-----------
>  1 file changed, 160 insertions(+), 63 deletions(-)

[...]

> +static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
> +				  u32 *e820ext_size)
> +{
> +	efi_status_t status;
> +	unsigned long size;
> +
> +	size = sizeof(struct setup_data) +
> +		sizeof(struct e820entry) * nr_desc;
> +
> +	if (*e820ext && size <= *e820ext_size)
> +		return EFI_SUCCESS; /* Already allocated */

Do we actually need this check? I thought the 'prev_nr_desc' below
ensures we only allocate 'e820ext' if we need more memory.

[...]

> @@ -1016,6 +1157,19 @@ get_map:
>  	if (status != EFI_SUCCESS)
>  		goto free_mem_map;
>  
> +	prev_nr_desc = nr_desc;
> +	nr_desc = size / desc_size;
> +	if (nr_desc > prev_nr_desc &&
> +	    nr_desc > ARRAY_SIZE(boot_params->e820_map)) {
> +		u32 nr_e820ext = nr_desc - ARRAY_SIZE(boot_params->e820_map);
> +
> +		status = alloc_e820ext(nr_e820ext, &e820ext, &e820ext_size);
> +		if (status != EFI_SUCCESS)
> +			goto free_mem_map;
> +
> +		goto get_map; /* Allocated memory, get map again */
> +	}
> +

-- 
Matt Fleming, Intel Open Source Technology Center
