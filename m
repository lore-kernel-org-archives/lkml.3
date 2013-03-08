Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658Ab3CHGr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:47:58 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:58221 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3CHGr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:47:56 -0500
MIME-Version: 1.0
In-Reply-To: <20130308053317.GD14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-3-git-send-email-yinghai@kernel.org>
	<20130308053317.GD14556@mtj.dyndns.org>
Date: Thu, 7 Mar 2013 22:47:55 -0800
X-Google-Sender-Auth: lk8EErC_9jSpteKLim4mnPk157E
Message-ID: <CAE9FiQXre0H5Uw2GddRXhA6zB7ZfGmvXiEjCMpQ7b0mLynxQdA@mail.gmail.com>
Subject: Re: [PATCH 02/14] x86, ACPI: Split find/copy from acpi_initrd_override
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 9:33 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Mar 07, 2013 at 08:58:28PM -0800, Yinghai Lu wrote:
>> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
>> index c9e36d7..b9d2ff0 100644
>> --- a/drivers/acpi/osl.c
>> +++ b/drivers/acpi/osl.c
>> @@ -539,6 +539,7 @@ acpi_os_predefined_override(const struct acpi_predefined_names *init_val,
>>
>>  static u64 acpi_tables_addr;
>>  static int all_tables_size;
>> +static int table_nr;
>
> Not particularly good choice of name for static variable visible to
> multiple functions.  all_tables_size isn't a stellar choice either but
> no need to continue the tradition.  Maybe acpi_nr_initrd_files?  Also,
> why is this one defined here away from the actual table?

ok, acpi_nr_initrd_files.

will check if it could be killed.

>> -/* Must not increase 10 or needs code modification below */
>> -#define ACPI_OVERRIDE_TABLES 10
>> +#define ACPI_OVERRIDE_TABLES 64
>
> What's up with the silent bumping of table size?

will mention that in change log.

>
>> +static struct cpio_data __initdata early_initrd_files[ACPI_OVERRIDE_TABLES];
>
> acpi_initrd_files[]?  Do we really need the "early" designation
> together with initrd?

just move it out from acpi_initrd_override.

>
>> @@ -647,14 +653,14 @@ void __init acpi_initrd_override(void *data, size_t size)
>>       memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
>>       arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
>>
>> -     p = early_ioremap(acpi_tables_addr, all_tables_size);
>> -
>>       for (no = 0; no < table_nr; no++) {
>> -             memcpy(p + total_offset, early_initrd_files[no].data,
>> -                    early_initrd_files[no].size);
>> -             total_offset += early_initrd_files[no].size;
>> +             size_t size = early_initrd_files[no].size;
>> +
>> +             p = early_ioremap(acpi_tables_addr + total_offset, size);
>> +             memcpy(p, early_initrd_files[no].data, size);
>> +             early_iounmap(p, size);
>> +             total_offset += size;
>>       }
>> -     early_iounmap(p, all_tables_size);
>
> Why is this necessary?  Why no explanation in the description?

actually it is the reason for bump table_nr to 64.

early_ioremap only can map 256k one time, so there will have limit for
overall size.

If map one by one, then we could increase the number of limit.

>
>> --- a/include/linux/acpi.h
>> +++ b/include/linux/acpi.h
>> @@ -79,14 +79,6 @@ typedef int (*acpi_tbl_table_handler)(struct acpi_table_header *table);
>>  typedef int (*acpi_tbl_entry_handler)(struct acpi_subtable_header *header,
>>                                     const unsigned long end);
>>
>> -#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
>> -void acpi_initrd_override(void *data, size_t size);
>> -#else
>> -static inline void acpi_initrd_override(void *data, size_t size)
>> -{
>> -}
>> -#endif
>> -
>>  char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
>>  void __acpi_unmap_table(char *map, unsigned long size);
>>  int early_acpi_boot_init(void);
>> @@ -485,6 +477,14 @@ static inline bool acpi_driver_match_device(struct device *dev,
>>
>>  #endif       /* !CONFIG_ACPI */
>>
>> +#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
>> +void acpi_initrd_override_find(void *data, size_t size);
>> +void acpi_initrd_override_copy(void);
>> +#else
>> +static inline void acpi_initrd_override_find(void *data, size_t size) { }
>> +static inline void acpi_initrd_override_copy(void) { }
>> +#endif
>
> I don't get this part either.  Why is it necessary to move the
> prototypes to avoid #ifdefs in setup.c?  Ah, okay, you're brining it
> outside CONFIG_ACPI so that they're defined regardless of that config
> option.  Can you please add why you're moving the prototype in the
> descriptoin?  Having "what" is nice but "why" is much nicer. :)

I think i have that in the log.

more detail is : ACPI_INITRD_TABLE_OVERRIDE depends
one ACPI and BLK_DEV_INITRD.

So could move it out safely.

Thanks

Yinghai
