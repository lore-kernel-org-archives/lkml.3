Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaCOBD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 21:03:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:63161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbaCOBDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 21:03:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,658,1389772800"; 
   d="scan'208";a="500322873"
Message-ID: <5323A6D9.5070005@intel.com>
Date: Sat, 15 Mar 2014 02:03:21 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH V2 06/13] ACPI: introduce enumerable_id flag
References: <1394727413-3587-1-git-send-email-rui.zhang@intel.com> <1394727413-3587-7-git-send-email-rui.zhang@intel.com>
In-Reply-To: <1394727413-3587-7-git-send-email-rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/2014 5:16 PM, Zhang Rui wrote:
> Only certain kind of ACPI device objects can be enumerated via ACPI.
> These ACPI device objects include
> 1. ACPI device objects that have _HID control method.
> 2. some ACPI device objects that have Linux specified HID strings.
>
> In order to distinguish those device objects from the others, a new flag
> enumerable_id and a new function acpi_add_eid() are introduced in this patch.

I don't really like the name of the new flag.  What about calling it 
platform_id (it is supposed to indicate that the core should create a 
platform device for it)?

> Currently, only devices with _HID method have this flag set.
> And in the future, if a device that has Linux specified HID strings
> wants to be enumerated to platform bus, acpi_add_eid() should be used

And what about calling the new function acpi_add_platform_id() accordingly?

> instead of acpi_add_id() when adding its Linux specified HID string.

And I don't quite understand the last paragraph as a whole.  Is it 
supposed to mean "if you want platform devices to be created for device 
objects without _HID, use acpi_add_platform_id() when adding artificial 
Linux-specific ID strings to them"?

> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>   drivers/acpi/scan.c     |    8 +++++++-
>   include/acpi/acpi_bus.h |    3 ++-
>   2 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 399257e..768f81d 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1679,6 +1679,12 @@ static void acpi_add_id(struct acpi_device_pnp *pnp, const char *dev_id)
>   	pnp->type.hardware_id = 1;
>   }
>   
> +static void acpi_add_eid(struct acpi_device_pnp *pnp, const char *dev_id)
> +{
> +	acpi_add_id(pnp, dev_id);
> +	pnp->type.enumerable_id = 1;
> +}
> +
>   /*
>    * Old IBM workstations have a DSDT bug wherein the SMBus object
>    * lacks the SMBUS01 HID and the methods do not have the necessary "_"
> @@ -1729,7 +1735,7 @@ static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
>   		}
>   
>   		if (info->valid & ACPI_VALID_HID)
> -			acpi_add_id(pnp, info->hardware_id.string);
> +			acpi_add_eid(pnp, info->hardware_id.string);
>   		if (info->valid & ACPI_VALID_CID) {
>   			cid_list = &info->compatible_id_list;
>   			for (i = 0; i < cid_list->count; i++)
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index 8c5e235..688ca44 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -217,7 +217,8 @@ struct acpi_hardware_id {
>   struct acpi_pnp_type {
>   	u32 hardware_id:1;
>   	u32 bus_address:1;
> -	u32 reserved:30;
> +	u32 enumerable_id:1;
> +	u32 reserved:29;
>   };
>   
>   struct acpi_device_pnp {

