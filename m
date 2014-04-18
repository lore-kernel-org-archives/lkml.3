Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaDRB7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:59:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:61407 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbaDRB7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:59:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,882,1389772800"; 
   d="scan'208";a="495110713"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>
CC: Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: RE: [PATCH] ACPICA: Tables: Skip NULL entries in RSDT and XSDT.
Thread-Topic: [PATCH] ACPICA: Tables: Skip NULL entries in RSDT and XSDT.
Thread-Index: AQHPWqkiRbIEWi18XUqckj4NN5SyAZsWnSKw
Date: Fri, 18 Apr 2014 01:59:32 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802554B14@SHSMSX101.ccr.corp.intel.com>
References: <261e2207fab4a185b44fb27dbf9bc68588aea713.1397785844.git.lv.zheng@intel.com>
In-Reply-To: <261e2207fab4a185b44fb27dbf9bc68588aea713.1397785844.git.lv.zheng@intel.com>
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

Hi, Stable reviewers

This patch is not included in any upstream kernel, so it might not follow the stable rule.
If you think you need more information, please ignore this message.
This urgent fix is sent here for people who are monitoring stable and seeking for this fix.

Thanks and best regards
-Lv

> From: Zheng, Lv
> Sent: Friday, April 18, 2014 9:53 AM
> 
> Note that this patch is only used for stable kernels, upstream kernels
> will have this problem fixed in ACPICA 201303-04 release.  So upstream
> kernels shouldn't merge this commit.
> 
> It is reported that there are buggy BIOSes in the world: AMI uses a XSDt
> compiler for early BIOSes, this compiler will generate XSDT with a NULL
> entry.  The affected BIOS versions are "AMI BIOS F2-F4".
> 
> Original solution on Linux is to use an alternative heathy root table
> instead of the ill one.  This commit is refined by the following ACPICA
> commit that tries to reduce the source code differences between Linux and
> ACPICA upstream.
>   Commit: 671cc68dc61f029d44b43a681356078e02d8dab8
>   Subject: ACPICA: Back port and refine validation of the XSDT root table.
> But according to the bug report, the XSDT in fact is not broken, we should
> just add NULL entry sanity check before installing a table address from
> XSDT.
> 
> With the NULL entry sanity check implemented, the XSDT validation is
> useless because:
> 1. If XSDT contains NULL entries, it can be bypassed by the new sanity
>    check mechanism;
> 2. If RSDP contains a bad XSDT address, invoking XSDT validation will still
>    lead to kernel crash.
> 
> This patch deletes XSDT validation logics and adds code to skip NULL
> entries that can be found in RSDT or XSDT. Lv Zheng.
> 
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=73911
> Buglink: https://bugs.archlinux.org/task/39811
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
> Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
> Cc: Zhao Yakui <yakui.zhao@intel.com>
> Cc: <stable@vger.kernel.org> # 3.14.x: 671cc68: ACPICA: Back port and refine validation of the XSDT root table.
> ---
>  drivers/acpi/acpica/tbutils.c |  116 ++++-------------------------------------
>  1 file changed, 11 insertions(+), 105 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
> index 6412d3c..aaea4e2 100644
> --- a/drivers/acpi/acpica/tbutils.c
> +++ b/drivers/acpi/acpica/tbutils.c
> @@ -49,8 +49,6 @@
>  ACPI_MODULE_NAME("tbutils")
> 
>  /* Local prototypes */
> -static acpi_status acpi_tb_validate_xsdt(acpi_physical_address address);
> -
>  static acpi_physical_address
>  acpi_tb_get_root_table_entry(u8 *table_entry, u32 table_entry_size);
> 
> @@ -357,87 +355,6 @@ acpi_tb_get_root_table_entry(u8 *table_entry, u32 table_entry_size)
> 
>  /*******************************************************************************
>   *
> - * FUNCTION:    acpi_tb_validate_xsdt
> - *
> - * PARAMETERS:  address             - Physical address of the XSDT (from RSDP)
> - *
> - * RETURN:      Status. AE_OK if the table appears to be valid.
> - *
> - * DESCRIPTION: Validate an XSDT to ensure that it is of minimum size and does
> - *              not contain any NULL entries. A problem that is seen in the
> - *              field is that the XSDT exists, but is actually useless because
> - *              of one or more (or all) NULL entries.
> - *
> - ******************************************************************************/
> -
> -static acpi_status acpi_tb_validate_xsdt(acpi_physical_address xsdt_address)
> -{
> -	struct acpi_table_header *table;
> -	u8 *next_entry;
> -	acpi_physical_address address;
> -	u32 length;
> -	u32 entry_count;
> -	acpi_status status;
> -	u32 i;
> -
> -	/* Get the XSDT length */
> -
> -	table =
> -	    acpi_os_map_memory(xsdt_address, sizeof(struct acpi_table_header));
> -	if (!table) {
> -		return (AE_NO_MEMORY);
> -	}
> -
> -	length = table->length;
> -	acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
> -
> -	/*
> -	 * Minimum XSDT length is the size of the standard ACPI header
> -	 * plus one physical address entry
> -	 */
> -	if (length < (sizeof(struct acpi_table_header) + ACPI_XSDT_ENTRY_SIZE)) {
> -		return (AE_INVALID_TABLE_LENGTH);
> -	}
> -
> -	/* Map the entire XSDT */
> -
> -	table = acpi_os_map_memory(xsdt_address, length);
> -	if (!table) {
> -		return (AE_NO_MEMORY);
> -	}
> -
> -	/* Get the number of entries and pointer to first entry */
> -
> -	status = AE_OK;
> -	next_entry = ACPI_ADD_PTR(u8, table, sizeof(struct acpi_table_header));
> -	entry_count = (u32)((table->length - sizeof(struct acpi_table_header)) /
> -			    ACPI_XSDT_ENTRY_SIZE);
> -
> -	/* Validate each entry (physical address) within the XSDT */
> -
> -	for (i = 0; i < entry_count; i++) {
> -		address =
> -		    acpi_tb_get_root_table_entry(next_entry,
> -						 ACPI_XSDT_ENTRY_SIZE);
> -		if (!address) {
> -
> -			/* Detected a NULL entry, XSDT is invalid */
> -
> -			status = AE_NULL_ENTRY;
> -			break;
> -		}
> -
> -		next_entry += ACPI_XSDT_ENTRY_SIZE;
> -	}
> -
> -	/* Unmap table */
> -
> -	acpi_os_unmap_memory(table, length);
> -	return (status);
> -}
> -
> -/*******************************************************************************
> - *
>   * FUNCTION:    acpi_tb_parse_root_table
>   *
>   * PARAMETERS:  rsdp                    - Pointer to the RSDP
> @@ -502,25 +419,6 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
>  	 */
>  	acpi_os_unmap_memory(rsdp, sizeof(struct acpi_table_rsdp));
> 
> -	/*
> -	 * If it is present and used, validate the XSDT for access/size
> -	 * and ensure that all table entries are at least non-NULL
> -	 */
> -	if (table_entry_size == ACPI_XSDT_ENTRY_SIZE) {
> -		status = acpi_tb_validate_xsdt(address);
> -		if (ACPI_FAILURE(status)) {
> -			ACPI_BIOS_WARNING((AE_INFO,
> -					   "XSDT is invalid (%s), using RSDT",
> -					   acpi_format_exception(status)));
> -
> -			/* Fall back to the RSDT */
> -
> -			address =
> -			    (acpi_physical_address) rsdp->rsdt_physical_address;
> -			table_entry_size = ACPI_RSDT_ENTRY_SIZE;
> -		}
> -	}
> -
>  	/* Map the RSDT/XSDT table header to get the full table length */
> 
>  	table = acpi_os_map_memory(address, sizeof(struct acpi_table_header));
> @@ -592,12 +490,20 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
> 
>  		/* Get the table physical address (32-bit for RSDT, 64-bit for XSDT) */
> 
> +		address = acpi_tb_get_root_table_entry(table_entry, table_entry_size);
> +
> +		/* Skip NULL entry in RSDT/XSDT */
> +
> +		if (!address) {
> +			goto next_table;
> +		}
> +
>  		acpi_gbl_root_table_list.tables[acpi_gbl_root_table_list.
> -						current_table_count].address =
> -		    acpi_tb_get_root_table_entry(table_entry, table_entry_size);
> +						current_table_count].address = address;
> +		acpi_gbl_root_table_list.current_table_count++;
> 
> +next_table:
>  		table_entry += table_entry_size;
> -		acpi_gbl_root_table_list.current_table_count++;
>  	}
> 
>  	/*
> --
> 1.7.10

