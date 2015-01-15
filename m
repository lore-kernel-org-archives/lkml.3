Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbbAOD3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 22:29:34 -0500
Received: from mga14.intel.com ([192.55.52.115]:39188 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbbAOD3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 22:29:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,401,1418112000"; 
   d="scan'208";a="662095636"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Moore, Robert" <robert.moore@intel.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ACPICA: rsdump: Remove some unused functions
Thread-Topic: [PATCH] ACPICA: rsdump: Remove some unused functions
Thread-Index: AQHQL2Bz4u1uK/UmOUyka1iZcQe/R5zAhG0g
Date: Thu, 15 Jan 2015 03:29:08 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026B7A16@SHSMSX101.ccr.corp.intel.com>
References: <1421174632-5146-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1421174632-5146-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
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

Hi, Rickard

I've done some corrections in the following commit for this report:
https://github.com/zetalog/acpica/commit/f86ad0858eacfe890cbeae43846da2638c389c1c
All other utilities related corrections are done in:
https://github.com/zetalog/acpica/commit/06fb69ea0e4c47edc91544a90a69b983fd161963
And the patches are now part of the 201501 release materials pending for review:
https://github.com/acpica/acpica/pull/61

I think I should also let you know my opinions against this kind of no usage functions.

IMO, what you've done is useless and make source tree maintenance more difficult than anyone expects.

Kernel compilation contains "strip" step which can automatically remove symbols without any references on them.
So we don't need to maintain this in the source level.
And there is a defect in maintaining it in the source level.

A module could have native variables and functions accessing these native variables should be bounded to the same source file.
So if there are 2 functions using one native variables in a source file like the following example:

a.c

static int a;

int get_a(void)
{
	return a;
}

void set_a(int a)
{
	a = v;
}

If get_a is only used by a module enabled with CONFIG_DEVICE_X and set_a is only used by a module enabled with CONFIG_DEVICE_Y.
Should we do such modifications?

static int a;

#ifdef CONFIG_DEVICE_X
int get_a(void)
{
	return a;
}
#endif

#ifdef CONFIG_DEVICE_Y
void set_a(int a)
{
	a = v;
}
#endif

I think no one will do this in the kernel.
We simply will prepare another config itme for a.c, for example CONFIG_MODULE_A

Then we will have dependencies in Kconfig:
config DEVICE_X
	bool
	depends MODULE_A

config DEVICE_Y
	bool
	depends MODULE_A

And let the no user function automatically be deleted by "strip".
Because if the references changes, the developers will need to check plenty of such "#ifdef" to correct compilation warnings...

If you do want to do this in the upstream kernel, you'll find millions of functions need to be wrapped by such useless "#ifdef".
A source file should only contain the self contained logics in it without considering the users.

Thanks and best regards
-Lv

> -----Original Message-----
> From: Rickard Strandqvist [mailto:rickard_strandqvist@spectrumdigital.se]
> Sent: Wednesday, January 14, 2015 2:44 AM
> To: Moore, Robert; Zheng, Lv
> Cc: Rickard Strandqvist; Wysocki, Rafael J; Len Brown; linux-acpi@vger.kernel.org; devel@acpica.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] ACPICA: rsdump: Remove some unused functions
> 
> Removes some functions that are not used anywhere:
> acpi_rs_dump_irq_list() acpi_rs_dump_resource_list()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/acpi/acpica/acresrc.h |    7 ---
>  drivers/acpi/acpica/rsdump.c  |  110 -----------------------------------------
>  2 files changed, 117 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/acresrc.h b/drivers/acpi/acpica/acresrc.h
> index 4b008e8..4a4f8af 100644
> --- a/drivers/acpi/acpica/acresrc.h
> +++ b/drivers/acpi/acpica/acresrc.h
> @@ -299,13 +299,6 @@ acpi_rs_set_resource_length(acpi_rsdesc_size total_length,
>  			    union aml_resource *aml);
> 
>  /*
> - * rsdump
> - */
> -void acpi_rs_dump_resource_list(struct acpi_resource *resource);
> -
> -void acpi_rs_dump_irq_list(u8 * route_table);
> -
> -/*
>   * Resource conversion tables
>   */
>  extern struct acpi_rsconvert_info acpi_rs_convert_dma[];
> diff --git a/drivers/acpi/acpica/rsdump.c b/drivers/acpi/acpica/rsdump.c
> index c3c56b5..8bd41ec 100644
> --- a/drivers/acpi/acpica/rsdump.c
> +++ b/drivers/acpi/acpica/rsdump.c
> @@ -357,116 +357,6 @@ static void acpi_rs_dump_address_common(union acpi_resource_data *resource)
> 
>  /*******************************************************************************
>   *
> - * FUNCTION:    acpi_rs_dump_resource_list
> - *
> - * PARAMETERS:  resource_list       - Pointer to a resource descriptor list
> - *
> - * RETURN:      None
> - *
> - * DESCRIPTION: Dispatches the structure to the correct dump routine.
> - *
> - ******************************************************************************/
> -
> -void acpi_rs_dump_resource_list(struct acpi_resource *resource_list)
> -{
> -	u32 count = 0;
> -	u32 type;
> -
> -	ACPI_FUNCTION_ENTRY();
> -
> -	/* Check if debug output enabled */
> -
> -	if (!ACPI_IS_DEBUG_ENABLED(ACPI_LV_RESOURCES, _COMPONENT)) {
> -		return;
> -	}
> -
> -	/* Walk list and dump all resource descriptors (END_TAG terminates) */
> -
> -	do {
> -		acpi_os_printf("\n[%02X] ", count);
> -		count++;
> -
> -		/* Validate Type before dispatch */
> -
> -		type = resource_list->type;
> -		if (type > ACPI_RESOURCE_TYPE_MAX) {
> -			acpi_os_printf
> -			    ("Invalid descriptor type (%X) in resource list\n",
> -			     resource_list->type);
> -			return;
> -		}
> -
> -		/* Sanity check the length. It must not be zero, or we loop forever */
> -
> -		if (!resource_list->length) {
> -			acpi_os_printf
> -			    ("Invalid zero length descriptor in resource list\n");
> -			return;
> -		}
> -
> -		/* Dump the resource descriptor */
> -
> -		if (type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
> -			acpi_rs_dump_descriptor(&resource_list->data,
> -						acpi_gbl_dump_serial_bus_dispatch
> -						[resource_list->data.
> -						 common_serial_bus.type]);
> -		} else {
> -			acpi_rs_dump_descriptor(&resource_list->data,
> -						acpi_gbl_dump_resource_dispatch
> -						[type]);
> -		}
> -
> -		/* Point to the next resource structure */
> -
> -		resource_list = ACPI_NEXT_RESOURCE(resource_list);
> -
> -		/* Exit when END_TAG descriptor is reached */
> -
> -	} while (type != ACPI_RESOURCE_TYPE_END_TAG);
> -}
> -
> -/*******************************************************************************
> - *
> - * FUNCTION:    acpi_rs_dump_irq_list
> - *
> - * PARAMETERS:  route_table     - Pointer to the routing table to dump.
> - *
> - * RETURN:      None
> - *
> - * DESCRIPTION: Print IRQ routing table
> - *
> - ******************************************************************************/
> -
> -void acpi_rs_dump_irq_list(u8 * route_table)
> -{
> -	struct acpi_pci_routing_table *prt_element;
> -	u8 count;
> -
> -	ACPI_FUNCTION_ENTRY();
> -
> -	/* Check if debug output enabled */
> -
> -	if (!ACPI_IS_DEBUG_ENABLED(ACPI_LV_RESOURCES, _COMPONENT)) {
> -		return;
> -	}
> -
> -	prt_element = ACPI_CAST_PTR(struct acpi_pci_routing_table, route_table);
> -
> -	/* Dump all table elements, Exit on zero length element */
> -
> -	for (count = 0; prt_element->length; count++) {
> -		acpi_os_printf("\n[%02X] PCI IRQ Routing Table Package\n",
> -			       count);
> -		acpi_rs_dump_descriptor(prt_element, acpi_rs_dump_prt);
> -
> -		prt_element = ACPI_ADD_PTR(struct acpi_pci_routing_table,
> -					   prt_element, prt_element->length);
> -	}
> -}
> -
> -/*******************************************************************************
> - *
>   * FUNCTION:    acpi_rs_out*
>   *
>   * PARAMETERS:  title       - Name of the resource field
> --
> 1.7.10.4

