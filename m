Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbaIOQsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:48:30 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:41825 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbaIOQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:48:29 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 02/18] ACPI / table: Add new function to get table
 entries
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Will Deacon <will.deacon@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
In-Reply-To: <1410530416-30200-3-git-send-email-hanjun.guo@linaro.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
	<1410530416-30200-3-git-send-email-hanjun.guo@linaro.org>
Date: Mon, 15 Sep 2014 09:48:21 -0700
Message-Id: <20140915164821.8740BC40A26@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 22:00:00 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
> 
> The acpi_table_parse() function has a callback that
> passes a pointer to a table_header. Add a new function
> which takes this pointer and parses its entries. This
> eliminates the need to re-traverse all the tables for
> each call. e.g. as in acpi_table_parse_madt() which is
> normally called after acpi_table_parse().
> 
> Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>

Makes sense.

Acked-by: Grant Likely <grant.likely@linaro.org>

g.

> ---
>  drivers/acpi/tables.c |   67 ++++++++++++++++++++++++++++++++++---------------
>  include/linux/acpi.h  |    4 +++
>  2 files changed, 51 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> index 6d5a6cd..21ae521 100644
> --- a/drivers/acpi/tables.c
> +++ b/drivers/acpi/tables.c
> @@ -192,17 +192,14 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
>  
>  
>  int __init
> -acpi_table_parse_entries(char *id,
> -			     unsigned long table_size,
> -			     int entry_id,
> -			     acpi_tbl_entry_handler handler,
> -			     unsigned int max_entries)
> +acpi_parse_entries(unsigned long table_size,
> +		acpi_tbl_entry_handler handler,
> +		struct acpi_table_header *table_header,
> +		int entry_id, unsigned int max_entries)
>  {
> -	struct acpi_table_header *table_header = NULL;
>  	struct acpi_subtable_header *entry;
> -	unsigned int count = 0;
> +	int count = 0;
>  	unsigned long table_end;
> -	acpi_size tbl_size;
>  
>  	if (acpi_disabled)
>  		return -ENODEV;
> @@ -210,13 +207,11 @@ acpi_table_parse_entries(char *id,
>  	if (!handler)
>  		return -EINVAL;
>  
> -	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
> -		acpi_get_table_with_size(id, acpi_apic_instance, &table_header, &tbl_size);
> -	else
> -		acpi_get_table_with_size(id, 0, &table_header, &tbl_size);
> +	if (!table_size)
> +		return -EINVAL;
>  
>  	if (!table_header) {
> -		pr_warn("%4.4s not present\n", id);
> +		pr_warn("Table header not present\n");
>  		return -ENODEV;
>  	}
>  
> @@ -232,30 +227,62 @@ acpi_table_parse_entries(char *id,
>  		if (entry->type == entry_id
>  		    && (!max_entries || count++ < max_entries))
>  			if (handler(entry, table_end))
> -				goto err;
> +				return -EINVAL;
>  
>  		/*
>  		 * If entry->length is 0, break from this loop to avoid
>  		 * infinite loop.
>  		 */
>  		if (entry->length == 0) {
> -			pr_err("[%4.4s:0x%02x] Invalid zero length\n", id, entry_id);
> -			goto err;
> +			pr_err("[0x%02x] Invalid zero length\n", entry_id);
> +			return -EINVAL;
>  		}
>  
>  		entry = (struct acpi_subtable_header *)
>  		    ((unsigned long)entry + entry->length);
>  	}
> +
>  	if (max_entries && count > max_entries) {
>  		pr_warn("[%4.4s:0x%02x] ignored %i entries of %i found\n",
> -			id, entry_id, count - max_entries, count);
> +			table_header->signature, entry_id, count - max_entries,
> +			count);
>  	}
>  
> -	early_acpi_os_unmap_memory((char *)table_header, tbl_size);
>  	return count;
> -err:
> +}
> +
> +int __init
> +acpi_table_parse_entries(char *id,
> +			 unsigned long table_size,
> +			 int entry_id,
> +			 acpi_tbl_entry_handler handler,
> +			 unsigned int max_entries)
> +{
> +	struct acpi_table_header *table_header = NULL;
> +	acpi_size tbl_size;
> +	int count;
> +
> +	if (acpi_disabled)
> +		return -ENODEV;
> +
> +	if (!handler)
> +		return -EINVAL;
> +
> +	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
> +		acpi_get_table_with_size(id, acpi_apic_instance, &table_header, &tbl_size);
> +	else
> +		acpi_get_table_with_size(id, 0, &table_header, &tbl_size);
> +
> +	if (!table_header) {
> +		pr_warn("%4.4s not present\n", id);
> +		return -ENODEV;
> +	}
> +
> +	count = acpi_parse_entries(table_size, handler, table_header,
> +			entry_id, max_entries);
> +
>  	early_acpi_os_unmap_memory((char *)table_header, tbl_size);
> -	return -EINVAL;
> +	return count;
>  }
>  
>  int __init
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 807cbc4..36d5012 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -123,6 +123,10 @@ int acpi_numa_init (void);
>  
>  int acpi_table_init (void);
>  int acpi_table_parse(char *id, acpi_tbl_table_handler handler);
> +int __init acpi_parse_entries(unsigned long table_size,
> +			      acpi_tbl_entry_handler handler,
> +			      struct acpi_table_header *table_header,
> +			      int entry_id, unsigned int max_entries);
>  int __init acpi_table_parse_entries(char *id, unsigned long table_size,
>  				    int entry_id,
>  				    acpi_tbl_entry_handler handler,
> -- 
> 1.7.9.5
> 

