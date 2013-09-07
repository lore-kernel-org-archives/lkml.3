Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3IGV52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 17:57:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38175 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab3IGV5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 17:57:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, Thomas Renninger <trenn@suse.de>,
        Tang Chen <tangchen@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, ACPI: Increase override tables number limit
Date: Sun, 08 Sep 2013 00:08:21 +0200
Message-ID: <5524976.WyDjA8K7XS@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1378519680-10490-1-git-send-email-yinghai@kernel.org>
References: <1378519680-10490-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 06, 2013 07:08:00 PM Yinghai Lu wrote:
> Current acpi tables in initrd is limited to 10, that is too small.
> 64 should be good enough as we have 35 sigs and could have several
> SSDT.
> 
> Two problems in current code prevent us from increasing limit:
> 1. that cpio file info array is put in stack, as every element is 32
>    bytes, could run out of stack if we have that array size to 64.
>    We can move it out from stack, and make it as global and put it in
>    __initdata section.
> 2. early_ioremap only can remap 256k one time. Current code is mapping
>    10 tables one time. If we increase that limit, whole size could be
>    more than 256k, early_ioremap will fail with that.
>    We can map chunks one by one during copying, instead of mapping
>    all them one time.
> 
> -v2: According to tj, split it out to separated patch, also
>      rename array name to acpi_initrd_files.
> -v3: Add some comments about mapping table one by one during copying
>      per tj.
> -v4: copy one by one chunk instead as one single DSDT/SSDT could be
>      more than 256k.
> -v5: fix compiling err when !CONFIG_SMP, found by Fengguang's robot
> 
> Signed-off-by: Yinghai <yinghai@kernel.org>

Full name would be nice.

> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Acked-by: Tejun Heo <tj@kernel.org>
> Tested-by: Thomas Renninger <trenn@suse.de>
> Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
> Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Peter, any objections to the changes below from the x86 perspective?

> ---
>  arch/x86/include/asm/acpi.h |    1 +
>  drivers/acpi/osl.c          |   44 ++++++++++++++++++++++++++++++++------------
>  2 files changed, 33 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/osl.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/osl.c
> +++ linux-2.6/drivers/acpi/osl.c
> @@ -569,8 +569,10 @@ static const char * const table_sigs[] =
>  
>  #define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
>  
> -/* Must not increase 10 or needs code modification below */
> -#define ACPI_OVERRIDE_TABLES 10
> +#define ACPI_OVERRIDE_TABLES 64
> +static struct cpio_data __initdata acpi_initrd_files[ACPI_OVERRIDE_TABLES];
> +
> +#define MAP_CHUNK_SIZE   (NR_FIX_BTMAPS << PAGE_SHIFT)
>  
>  void __init acpi_initrd_override(void *data, size_t size)
>  {
> @@ -579,8 +581,6 @@ void __init acpi_initrd_override(void *d
>  	struct acpi_table_header *table;
>  	char cpio_path[32] = "kernel/firmware/acpi/";
>  	struct cpio_data file;
> -	struct cpio_data early_initrd_files[ACPI_OVERRIDE_TABLES];
> -	char *p;
>  
>  	if (data == NULL || size == 0)
>  		return;
> @@ -625,8 +625,8 @@ void __init acpi_initrd_override(void *d
>  			table->signature, cpio_path, file.name, table->length);
>  
>  		all_tables_size += table->length;
> -		early_initrd_files[table_nr].data = file.data;
> -		early_initrd_files[table_nr].size = file.size;
> +		acpi_initrd_files[table_nr].data = file.data;
> +		acpi_initrd_files[table_nr].size = file.size;
>  		table_nr++;
>  	}
>  	if (table_nr == 0)
> @@ -652,14 +652,34 @@ void __init acpi_initrd_override(void *d
>  	memblock_reserve(acpi_tables_addr, all_tables_size);
>  	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
>  
> -	p = early_ioremap(acpi_tables_addr, all_tables_size);
> -
> +	/*
> +	 * early_ioremap only can remap 256k one time. If we map all
> +	 * tables one time, we will hit the limit. Need to map chunks
> +	 * one by one during copying the same as that in relocate_initrd().
> +	 */
>  	for (no = 0; no < table_nr; no++) {
> -		memcpy(p + total_offset, early_initrd_files[no].data,
> -		       early_initrd_files[no].size);
> -		total_offset += early_initrd_files[no].size;
> +		unsigned char *src_p = acpi_initrd_files[no].data;
> +		phys_addr_t size = acpi_initrd_files[no].size;
> +		phys_addr_t dest_addr = acpi_tables_addr + total_offset;
> +		phys_addr_t slop, clen;
> +		char *dest_p;
> +
> +		total_offset += size;
> +
> +		while (size) {
> +			slop = dest_addr & ~PAGE_MASK;
> +			clen = size;
> +			if (clen > MAP_CHUNK_SIZE - slop)
> +				clen = MAP_CHUNK_SIZE - slop;
> +			dest_p = early_ioremap(dest_addr & PAGE_MASK,
> +						 clen + slop);
> +			memcpy(dest_p + slop, src_p, clen);
> +			early_iounmap(dest_p, clen + slop);
> +			src_p += clen;
> +			dest_addr += clen;
> +			size -= clen;
> +		}
>  	}
> -	early_iounmap(p, all_tables_size);
>  }
>  #endif /* CONFIG_ACPI_INITRD_TABLE_OVERRIDE */
>  
> Index: linux-2.6/arch/x86/include/asm/acpi.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/acpi.h
> +++ linux-2.6/arch/x86/include/asm/acpi.h
> @@ -26,6 +26,7 @@
>  #include <acpi/pdc_intel.h>
>  
>  #include <asm/numa.h>
> +#include <asm/fixmap.h>
>  #include <asm/processor.h>
>  #include <asm/mmu.h>
>  #include <asm/mpspec.h>
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
