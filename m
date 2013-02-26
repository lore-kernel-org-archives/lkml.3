Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3BZFhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:37:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38390 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3BZFhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:37:46 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <512C4A07.40903@jp.fujitsu.com>
Date: Tue, 26 Feb 2013 14:37:11 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <vasilis.liaskovitis@profitbricks.com>
Subject: Re: [PATCH v2] ACPI: Add sysfs links from memory device to memblocks
References: <1361826130-31062-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1361826130-31062-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/02/26 6:02, Toshi Kani wrote:
> In order to eject a memory device object represented as "PNP0C80:%d"
> in sysfs, its associated memblocks (system/memory/memory%d) need to
> be off-lined.  However, there is no user friendly way to correlate
> between a memory device object and its memblocks in sysfs.
> 
> This patch creates sysfs links to memblocks under a memory device
> object so that a user can easily checks and manipulates its memblocks
> in sysfs.
> 
> For example, when PNP0C80:05 is associated with memory8 and memory9,
> the following two links are created under PNP0C80:05.  This allows
> a user to access memory8/9 directly from PNP0C80:05.
> 
>    # ll /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C80:05
>    lrwxrwxrwx. memory8 -> ../../../system/memory/memory8
>    lrwxrwxrwx. memory9 -> ../../../system/memory/memory9
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---

I confirmed that the patch has no problem.
Feel free to add:

Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

> 
> This patch applies on top of the Rafael's patch below.
> https://patchwork.kernel.org/patch/2153261/
> 
> v2: Added a NULL return check for find_memory_block_hinted() as
> pointed by Yasuaki Ishimatsu.
> 
> ---
>   drivers/acpi/acpi_memhotplug.c |   56 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 56 insertions(+)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 3b3abbc..98477a5 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -28,6 +28,7 @@
>    */
>   
>   #include <linux/acpi.h>
> +#include <linux/memory.h>
>   #include <linux/memory_hotplug.h>
>   
>   #include "internal.h"
> @@ -168,6 +169,55 @@ static int acpi_memory_check_device(struct acpi_memory_device *mem_device)
>   	return 0;
>   }
>   
> +static void acpi_setup_mem_blk_links(struct acpi_memory_device *mem_device,
> +		struct acpi_memory_info *info, bool add_links)
> +{
> +	struct memory_block *mem_blk = NULL;
> +	struct mem_section *mem_sect;
> +	unsigned long start_pfn, end_pfn, pfn;
> +	unsigned long section_nr;
> +	int ret;
> +
> +	start_pfn = PFN_DOWN(info->start_addr);
> +	end_pfn = PFN_UP(info->start_addr + info->length-1);
> +
> +	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> +		section_nr = pfn_to_section_nr(pfn);
> +
> +		if (!present_section_nr(section_nr))
> +			continue;
> +
> +		mem_sect = __nr_to_section(section_nr);
> +
> +		/* skip if the same memblock */
> +		if (mem_blk)
> +			if ((section_nr >= mem_blk->start_section_nr) &&
> +			    (section_nr <= mem_blk->end_section_nr))
> +				continue;
> +
> +		mem_blk = find_memory_block_hinted(mem_sect, mem_blk);
> +		if (!mem_blk)
> +			continue;
> +
> +		if (add_links) {
> +			ret = sysfs_create_link_nowarn(
> +				&mem_device->device->dev.kobj,
> +				&mem_blk->dev.kobj,
> +				kobject_name(&mem_blk->dev.kobj));
> +			if (ret && ret != -EEXIST)
> +				dev_err(&mem_device->device->dev,
> +					"Failed to create sysfs link %s\n",
> +					kobject_name(&mem_blk->dev.kobj));
> +		} else {
> +			sysfs_remove_link(&mem_device->device->dev.kobj,
> +				kobject_name(&mem_blk->dev.kobj));
> +		}
> +	}
> +
> +	if (mem_blk)
> +		kobject_put(&mem_blk->dev.kobj);
> +}
> +
>   static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>   {
>   	int result, num_enabled = 0;
> @@ -207,6 +257,9 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>   			continue;
>   		}
>   
> +		/* Create sysfs links to its mem_blk devices */
> +		acpi_setup_mem_blk_links(mem_device, info, true);
> +
>   		if (!result)
>   			info->enabled = 1;
>   		/*
> @@ -241,6 +294,9 @@ static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
>   			/* The kernel does not use this memory block */
>   			continue;
>   
> +		/* Remove sysfs links to its mem_blk devices */
> +		acpi_setup_mem_blk_links(mem_device, info, false);
> +
>   		if (!info->enabled)
>   			/*
>   			 * The kernel uses this memory block, but it may be not
> 


