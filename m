Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaCCBUk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 20:20:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:49516 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbaCCBUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 20:20:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,574,1389772800"; 
   d="scan'208";a="492569450"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Thomas Renninger <trenn@suse.de>, "Moore, Robert" <robert.moore@intel.com>,
        "Box, David E" <david.e.box@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "ck@conrad-kostecki.de" <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [PATCH 2/4] ACPICA: Introduce new acpi_os_physical_table_add OS
 callback
Thread-Topic: [PATCH 2/4] ACPICA: Introduce new acpi_os_physical_table_add
 OS callback
Thread-Index: AQHPNn7ETOONm9s0vUeg3rV5HSj6rg==
Date: Mon, 3 Mar 2014 01:20:31 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024BB021@SHSMSX101.ccr.corp.intel.com>
References: <1393608241-31037-1-git-send-email-trenn@suse.de>
 <1393608241-31037-3-git-send-email-trenn@suse.de>
In-Reply-To: <1393608241-31037-3-git-send-email-trenn@suse.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas

I have a patch series that can cleanup the ACPICA table manager, and change the acpi_load_table into the following style:

acpi_status acpi_install_table(acpi_physical_address address, char *signature, u8 flags, bool override);

For the flags parameter, it will be:
ACPI_TABLE_ORIGIN_EXTERNAL_PHYSICAL (renamed from ACPI_TABLE_ORIGIN_UNKNOWN)
ACPI_TABLE_ORIGIN_EXTERNAL_VIRTUAL (renamed from ACPI_TABLE_ORIGIN_OVERRIDE)
ACPI_TABLE_ORIGIN_INTERNAL_PHYSICAL (renamed from ACPI_TABLE_ORIGIN_MAPPED)
ACPI_TABLE_ORIGIN_INTERNAL_LOGICAL (renamed from ACPI_TABLE_ORIGIN_ALLOCATED)

So that we can have the following advantages:

1. the table signature can be validate in one single function.
2. the table checksum can always be validated before installing it to acpi_gbl_root_table_list.
3. acpi_os_table_override() and acpi_os_phsycal_table_override() can be merged
4. for acpi_load_table (renamed to acpi_install_table()) invocations, if it is invoked by OSPM, override can be avoided.
5. part of the acpi_tb_parse_root_table() code can be merged with the acpi_load_table() by invoking same installing API with flags specified.

And with this API, you don't have to introduce code into ACPICA to achieve acpi_os_physical_table_add().
You only need to invoke an OSPM only initialization step after acpi_initialize_tables(), inside of which, you can invoke acpi_install_table() to install new arbitrary tables serving for the purposes of OSPM.
For your cases, I think you can implement the code in this way:

Int __init acpi_table_init(void)
{
	Status = acpi_initialize_tables()....
	/* add all tables, if they haven't been overridden, they will be newly installed */
	for (no = 0; no < no_of_overridden_tables; no++) {
		acpi_install_table(the_phsycail_address, NULL, ACPI_TABLE_ORIGIN_EXTERNAL_PHYSICAL, false);
	}
}

This function also has been carefully redesigned to ensure:
1. override can avoided for the newly added table.
2. checksum can be verified before adding it to the acpi_gbl_root_table_list, and it will only be verified once per table.
3. No need to save the table no that has already been physically overridden, it will be taken care by the new interfaces.

I can send out the cleanup series for you to confirm.

Thanks and best regards
-Lv


> -----Original Message-----
> From: Thomas Renninger [mailto:trenn@suse.de]
> Sent: Saturday, March 01, 2014 1:24 AM
> To: Moore, Robert; Zheng, Lv; Box, David E; Wysocki, Rafael J
> Cc: Thomas Renninger; hpa@zytor.com; tglx@linutronix.de; ck@conrad-kostecki.de; linux-kernel@vger.kernel.org; x86@kernel.org;
> mingo@redhat.com; rjw@rjwysocki.net; devel@acpica.org
> Subject: [PATCH 2/4] ACPICA: Introduce new acpi_os_physical_table_add OS callback
> 
> This one allows OS to add arbitrary ACPI tables.
> 
> ToDo: It should get checked whether a table with the same signature already
> exists and if this is the case, adding should not happen.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: hpa@zytor.com
> CC: tglx@linutronix.de
> CC: ck@conrad-kostecki.de
> CC: linux-kernel@vger.kernel.org
> CC: x86@kernel.org
> CC: mingo@redhat.com
> CC: rjw@rjwysocki.net
> CC: devel@acpica.org
> ---
>  drivers/acpi/acpica/tbutils.c |   36 ++++++++++++++++++++++++++++++++++++
>  include/acpi/acpiosxf.h       |    6 ++++++
>  2 files changed, 42 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
> index 6412d3c..a819d198 100644
> --- a/drivers/acpi/acpica/tbutils.c
> +++ b/drivers/acpi/acpica/tbutils.c
> @@ -453,6 +453,8 @@ static acpi_status acpi_tb_validate_xsdt(acpi_physical_address xsdt_address)
>   *
>   ******************************************************************************/
> 
> +#define ACPI_MAX_TABLE_ADD 64
> +
>  acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
>  {
>  	struct acpi_table_rsdp *rsdp;
> @@ -623,5 +625,39 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
>  		}
>  	}
> 
> +	/*
> +	 * ACPI Table Add:
> +	 * Allow the OS to add additional tables to the global root table list
> +	 */
> +	for (i = 0; i < ACPI_MAX_TABLE_ADD; i++) {
> +		int tmp, k;
> +		table_entry_size = 0;
> +		address = 0;
> +		status = acpi_os_physical_table_add(&address,
> +						    &table_entry_size);
> +		if (status == AE_OK && table_entry_size && address) {
> +			table = acpi_os_map_memory(address, table_entry_size);
> +			for (k = 2; k < acpi_gbl_root_table_list.current_table_count; k++) {
> +				/*
> +				  Always add SSDTs. Only allow adding of other
> +				  tables if none of such a signature already
> +				  exists. Use the override interface instead
> +				  in such a case.
> +				*/
> +				if (ACPI_COMPARE_NAME("SSDT", table->signature) &&
> +				    !ACPI_COMPARE_NAME(&acpi_gbl_root_table_list.tables[i].signature, table->signature)) {
> +	ACPI_INFO((AE_INFO, "OS table not added, signature already exists:"));
> +	acpi_tb_print_table_header(address, table);
> +	acpi_os_unmap_memory(table, table_entry_size);
> +				} else {
> +	ACPI_INFO((AE_INFO, "Add OS provided table:"));
> +	acpi_tb_print_table_header(address, table);
> +	status = acpi_tb_store_table(address, table, table_entry_size,
> +				     ACPI_TABLE_ORIGIN_MAPPED, &tmp);
> +				}
> +			}
> +		} else
> +			break;
> +	}
>  	return_ACPI_STATUS(AE_OK);
>  }
> diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
> index 01e6c6d..70c00ed 100644
> --- a/include/acpi/acpiosxf.h
> +++ b/include/acpi/acpiosxf.h
> @@ -111,6 +111,12 @@ acpi_os_physical_table_override(struct acpi_table_header *existing_table,
>  				u32 *new_table_length);
>  #endif
> 
> +#ifndef ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_physical_table_add
> +acpi_status
> +acpi_os_physical_table_add(acpi_physical_address * new_address,
> +			   u32 *new_table_length);
> +#endif
> +
>  /*
>   * Spinlock primitives
>   */
> --
> 1.7.6.1

