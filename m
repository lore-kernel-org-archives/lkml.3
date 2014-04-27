Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaD0WE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 18:04:29 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49257 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751463AbaD0WE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 18:04:28 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Subject: Re: [PATCH V5 06/12] ACPI: introduce platform_id flag
Date: Mon, 28 Apr 2014 00:20:55 +0200
Message-ID: <2359355.Scs9im2VU5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1396886819-2637-7-git-send-email-rui.zhang@intel.com>
References: <1396886819-2637-1-git-send-email-rui.zhang@intel.com> <1396886819-2637-7-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 08, 2014 12:06:53 AM Zhang Rui wrote:
> Only certain kind of ACPI device objects can be enumerated to platform bus.
> These ACPI device objects include
> 1. ACPI device objects that have _HID control method.
> 2. some ACPI device objects that have Linux specified HID strings.
> 
> In order to distinguish those device objects from the others, a new flag
> platform_id and a new function acpi_add_platform_id() are introduced
> in this patch.
> 
> Currently, only devices with _HID method have this flag set.
> If you want platform devices to be created for device objects without _HID,
> use acpi_add_platform_id() when adding artificial Linux-specific ID strings
> to them.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

It looks like [12/12] should be folded into this one or bisection may be broken
for somebody.

> ---
>  drivers/acpi/scan.c     |    9 ++++++++-
>  include/acpi/acpi_bus.h |    3 ++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index c82ab73..451e7d9 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1730,6 +1730,13 @@ static void acpi_add_id(struct acpi_device_pnp *pnp, const char *dev_id)
>  	pnp->type.hardware_id = 1;
>  }
>  
> +static void acpi_add_platform_id(struct acpi_device_pnp *pnp,
> +				 const char *dev_id)
> +{
> +	acpi_add_id(pnp, dev_id);
> +	pnp->type.platform_id = 1;
> +}
> +
>  /*
>   * Old IBM workstations have a DSDT bug wherein the SMBus object
>   * lacks the SMBUS01 HID and the methods do not have the necessary "_"
> @@ -1794,7 +1801,7 @@ static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
>  		}
>  
>  		if (info->valid & ACPI_VALID_HID)
> -			acpi_add_id(pnp, info->hardware_id.string);
> +			acpi_add_platform_id(pnp, info->hardware_id.string);
>  		if (info->valid & ACPI_VALID_CID) {
>  			cid_list = &info->compatible_id_list;
>  			for (i = 0; i < cid_list->count; i++)
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index ba679af..ec92ad3 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -233,7 +233,8 @@ struct acpi_hardware_id {
>  struct acpi_pnp_type {
>  	u32 hardware_id:1;
>  	u32 bus_address:1;
> -	u32 reserved:30;
> +	u32 platform_id:1;
> +	u32 reserved:29;
>  };
>  
>  struct acpi_device_pnp {
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
