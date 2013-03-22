Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3CVAku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:40:50 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:16093 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3CVAkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:40:49 -0400
Message-ID: <1363912171.11659.12.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/2] ACPI,acpi_memhotplug: Remove
 acpi_memory_info->failed bit
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: rjw@sisk.pl, linux-acpi@vger.kernel.org, tangchen@cn.fujitsu.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 18:29:31 -0600
In-Reply-To: <514A8EF3.90203@jp.fujitsu.com>
References: <514022BF.3080303@jp.fujitsu.com>
	  <1363186213.12845.174.camel@misato.fc.hp.com>
	  <514679BC.5020700@jp.fujitsu.com>
	 <1363705437.11659.5.camel@misato.fc.hp.com>
	 <514A4CCD.6000608@jp.fujitsu.com> <514A8E3C.1050902@jp.fujitsu.com>
	 <514A8EF3.90203@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 13:39 +0900, Yasuaki Ishimatsu wrote:
> acpi_memory_info has enabled bit and failed bit for controlling memory
> hotplug. But we don't need to keep both bits.
> 
> The patch removes acpi_memory_info->failed bit.
> 
> Signed-off-by: yasuaki ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
> 
> v2 : Changed a based kernel from linux-3.9-rc2 to linux-pm.git/bleeding-edge.
> 
> ---
>   drivers/acpi/acpi_memhotplug.c |   13 +------------
>   1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index ea78988..597cd65 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -73,7 +73,6 @@ struct acpi_memory_info {
>   	unsigned short caching;	/* memory cache attribute */
>   	unsigned short write_protect;	/* memory read/write attribute */
>   	unsigned int enabled:1;
> -	unsigned int failed:1;
>   };
>   
>   struct acpi_memory_device {
> @@ -201,10 +200,8 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>   		 * returns -EEXIST. If add_memory() returns the other error, it
>   		 * means that this memory block is not used by the kernel.
>   		 */
> -		if (result && result != -EEXIST) {
> -			info->failed = 1;
> +		if (result && result != -EEXIST)
>   			continue;
> -		}
>   
>   		info->enabled = 1;
>   
> @@ -238,15 +235,7 @@ static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
>   	nid = acpi_get_node(mem_device->device->handle);
>   
>   	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
> -		if (info->failed)
> -			/* The kernel does not use this memory block */
> -			continue;
> -
>   		if (!info->enabled)
> -			/*
> -			 * The kernel uses this memory block, but it may be not
> -			 * managed by us.
> -			 */
>   			return -EBUSY;

Shouldn't this case (!info->enabled) continue since it is the same as
info->failed before?  -EBUSY was previously used for the -EEXIST case,
which is no longer a failure case with this patchset.

Thanks,
-Toshi


