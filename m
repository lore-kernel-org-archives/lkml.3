Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3CHFdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:33:25 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49294 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3CHFdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:33:22 -0500
Date: Thu, 7 Mar 2013 21:33:17 -0800
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 02/14] x86, ACPI: Split find/copy from
 acpi_initrd_override
Message-ID: <20130308053317.GD14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
 <1362718720-27048-3-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362718720-27048-3-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:58:28PM -0800, Yinghai Lu wrote:
> To parse srat early, we will need to move acpi table probing early.
> and to keep acpi_initrd_table_override working, we need to move it
> ahead.
> 
> But current that is called after init_mem_mapping and relocate_initrd().
> 
> Copying need to be after memblock is ready, because it need to allocate
> some buffer for acpi tables.
> 
> Finding will be moved into head_32.S and head64.c, just like microcode
> early scanning.
> 
> So split them at first.
> 
> Also move down functions declaration to avoid #ifdef in setup.c
> 
> Signed-off-by: Yinghai <yinghai@kernel.org>
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Jacob Shin <jacob.shin@amd.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
...
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index c9e36d7..b9d2ff0 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -539,6 +539,7 @@ acpi_os_predefined_override(const struct acpi_predefined_names *init_val,
>  
>  static u64 acpi_tables_addr;
>  static int all_tables_size;
> +static int table_nr;

Not particularly good choice of name for static variable visible to
multiple functions.  all_tables_size isn't a stellar choice either but
no need to continue the tradition.  Maybe acpi_nr_initrd_files?  Also,
why is this one defined here away from the actual table?

> -/* Must not increase 10 or needs code modification below */
> -#define ACPI_OVERRIDE_TABLES 10
> +#define ACPI_OVERRIDE_TABLES 64

What's up with the silent bumping of table size?

> +static struct cpio_data __initdata early_initrd_files[ACPI_OVERRIDE_TABLES];

acpi_initrd_files[]?  Do we really need the "early" designation
together with initrd?

> @@ -647,14 +653,14 @@ void __init acpi_initrd_override(void *data, size_t size)
>  	memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
>  	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
>  
> -	p = early_ioremap(acpi_tables_addr, all_tables_size);
> -
>  	for (no = 0; no < table_nr; no++) {
> -		memcpy(p + total_offset, early_initrd_files[no].data,
> -		       early_initrd_files[no].size);
> -		total_offset += early_initrd_files[no].size;
> +		size_t size = early_initrd_files[no].size;
> +
> +		p = early_ioremap(acpi_tables_addr + total_offset, size);
> +		memcpy(p, early_initrd_files[no].data, size);
> +		early_iounmap(p, size);
> +		total_offset += size;
>  	}
> -	early_iounmap(p, all_tables_size);

Why is this necessary?  Why no explanation in the description?

> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -79,14 +79,6 @@ typedef int (*acpi_tbl_table_handler)(struct acpi_table_header *table);
>  typedef int (*acpi_tbl_entry_handler)(struct acpi_subtable_header *header,
>  				      const unsigned long end);
>  
> -#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
> -void acpi_initrd_override(void *data, size_t size);
> -#else
> -static inline void acpi_initrd_override(void *data, size_t size)
> -{
> -}
> -#endif
> -
>  char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
>  void __acpi_unmap_table(char *map, unsigned long size);
>  int early_acpi_boot_init(void);
> @@ -485,6 +477,14 @@ static inline bool acpi_driver_match_device(struct device *dev,
>  
>  #endif	/* !CONFIG_ACPI */
>  
> +#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
> +void acpi_initrd_override_find(void *data, size_t size);
> +void acpi_initrd_override_copy(void);
> +#else
> +static inline void acpi_initrd_override_find(void *data, size_t size) { }
> +static inline void acpi_initrd_override_copy(void) { }
> +#endif

I don't get this part either.  Why is it necessary to move the
prototypes to avoid #ifdefs in setup.c?  Ah, okay, you're brining it
outside CONFIG_ACPI so that they're defined regardless of that config
option.  Can you please add why you're moving the prototype in the
descriptoin?  Having "what" is nice but "why" is much nicer. :)

Thanks.

-- 
tejun
