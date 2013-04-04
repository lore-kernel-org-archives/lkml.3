Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764531Ab3DDS1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:27:55 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:44860 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764464Ab3DDS1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:27:53 -0400
Date: Thu, 4 Apr 2013 11:27:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 06/20] x86, ACPI: Store override acpi tables phys addr
 in cpio files info array
Message-ID: <20130404182742.GU9425@htj.dyndns.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
 <1362897887-30808-7-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362897887-30808-7-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 10:44:33PM -0800, Yinghai Lu wrote:
> In 32bit we will find table with phys address during 32bit flat mode
> in head_32.S, because at that time we don't need set page table to
> access initrd.
> 
> For copying we could use early_ioremap() with phys directly before mem mapping
> is set.
> 
> To keep 32bit and 64bit consistent, use phys_addr for all.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/acpi/osl.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index d66ae0e..54bcc37 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -615,7 +615,7 @@ void __init acpi_initrd_override_find(void *data, size_t size)
>  			table->signature, cpio_path, file.name, table->length);
>  
>  		all_tables_size += table->length;
> -		acpi_initrd_files[table_nr].data = file.data;
> +		acpi_initrd_files[table_nr].data = (void *)__pa(file.data);
>  		acpi_initrd_files[table_nr].size = file.size;
>  		table_nr++;
>  	}
> @@ -624,7 +624,7 @@ void __init acpi_initrd_override_find(void *data, size_t size)
>  void __init acpi_initrd_override_copy(void)
>  {
>  	int no, total_offset = 0;
> -	char *p;
> +	char *p, *q;
>  
>  	if (!all_tables_size)
>  		return;
> @@ -654,12 +654,20 @@ void __init acpi_initrd_override_copy(void)
>  	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
>  
>  	for (no = 0; no < ACPI_OVERRIDE_TABLES; no++) {
> +		/*
> +		 * have to use unsigned long, otherwise 32bit spit warning
> +		 * and it is ok to unsigned long, as bootloader would not
> +		 * load initrd above 4G for 32bit kernel.
> +		 */
> +		unsigned long addr = (unsigned long)acpi_initrd_files[no].data;

I can't say I like this.  It's stuffing phys_addr_t into void *.  It
might work okay but the code is a bit misleading / confusing.  "void
*" shouldn't contain a physical address.  Maybe the alternatives are
uglier, I don't know.  If you can think of a reasonable way to not do
this, it would be great.

Thanks.

-- 
tejun
