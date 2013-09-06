Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150Ab3IFKDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:03:32 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60434 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877Ab3IFKDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:03:30 -0400
Date: Fri, 6 Sep 2013 11:03:25 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Linn Crosetto <linn@hp.com>
Cc: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: EFI stub support for large memory maps
Message-ID: <20130906100325.GB7579@console-pimps.org>
References: <1377291771-21302-1-git-send-email-linn@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377291771-21302-1-git-send-email-linn@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug, at 03:02:51PM, Linn Crosetto wrote:
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
>  arch/x86/boot/compressed/eboot.c | 220 ++++++++++++++++++++++++++++-----------
>  1 file changed, 157 insertions(+), 63 deletions(-)

[...]

> @@ -1016,6 +1154,19 @@ get_map:
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
> +			return status;

In the error path shouldn't we jump to free_mem_map to avoid leaking
memory?

-- 
Matt Fleming, Intel Open Source Technology Center
