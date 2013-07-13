Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127Ab3GMVhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 17:37:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41525 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab3GMVhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 17:37:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] PCI / hotplug / ACPI: Get rid of check_sub_bridges()
Date: Sat, 13 Jul 2013 23:47:26 +0200
Message-ID: <3395919.UaDiFX78Zn@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1373735399-28055-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1373735399-28055-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 13, 2013 08:09:59 PM Mika Westerberg wrote:
> Now that acpiphp_check_bridge() always enumerates devices behind the
> bridge, there is no need to do that for each sub-bridge anymore like it is
> done in the current ACPI-based PCI hotplug code. Given this we don't need
> check_sub_bridges() anymore and can drop the function completely.
> 
> This also simplifies the ACPIPHP code a bit.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> This applies on top of v3.10 with Rafael's ACPIPHP + Thunderbolt series
> applied:
>

OK, I added it to my bleeding-edge branch along with this series:

> 	http://www.spinics.net/lists/linux-acpi/msg44480.html

rebased on top of some previous ACPI cleanup commits.  I needed to make some
changes in the process (and fixed up some breakage reported by the auto build
testing), hopefully I didn't break anything.  If you're in an adventurous mood,
testing would be welcome. ;-)  [That already includes the majority of 3.11
material from Linus, though, so unexpected breakage elsewhere may happen.]

Thanks,
Rafael


>  drivers/pci/hotplug/acpiphp_glue.c | 25 -------------------------
>  1 file changed, 25 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 62e09af..741504a 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -760,25 +760,6 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
>   * ACPI event handlers
>   */
>  
> -static acpi_status
> -check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
> -{
> -	struct acpiphp_bridge *bridge;
> -	char objname[64];
> -	struct acpi_buffer buffer = { .length = sizeof(objname),
> -				      .pointer = objname };
> -
> -	bridge = acpiphp_handle_to_bridge(handle);
> -	if (bridge) {
> -		acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> -		dbg("%s: re-enumerating slots under %s\n",
> -			__func__, objname);
> -		acpiphp_check_bridge(bridge);
> -		put_bridge(bridge);
> -	}
> -	return AE_OK ;
> -}
> -
>  void acpiphp_check_host_bridge(acpi_handle handle)
>  {
>  	struct acpiphp_bridge *bridge;
> @@ -788,9 +769,6 @@ void acpiphp_check_host_bridge(acpi_handle handle)
>  		acpiphp_check_bridge(bridge);
>  		put_bridge(bridge);
>  	}
> -
> -	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
> -		ACPI_UINT32_MAX, check_sub_bridges, NULL, NULL, NULL);
>  }
>  
>  static void hotplug_event(acpi_handle handle, u32 type, void *data)
> @@ -818,9 +796,6 @@ static void hotplug_event(acpi_handle handle, u32 type, void *data)
>  		dbg("%s: re-enumerating slots under %s\n", __func__, objname);
>  		if (bridge) {
>  			acpiphp_check_bridge(bridge);
> -			acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
> -					    ACPI_UINT32_MAX, check_sub_bridges,
> -					    NULL, NULL, NULL);
>  		} else {
>  			struct acpiphp_slot *slot = func->slot;
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
