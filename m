Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab3J3Mtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:49:33 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54632 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752494Ab3J3Mtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:49:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Len Brown <lenb@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / hotplug / PCI: Always rescan the slot for new devices
Date: Wed, 30 Oct 2013 14:01:40 +0100
Message-ID: <1406112.LRdFoqkugQ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1383136836-15306-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1383136836-15306-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 30, 2013 02:40:36 PM Mika Westerberg wrote:
> Commit 2dc4128 (ACPI / hotplug / PCI: Avoid doing too much for spurious
> notifies) changed the enable_slot() to check return value of pci_scan_slot()
> and if it is zero return early from the function. It means that there were
> no new devices in this particular slot.
> 
> However, if a device appeared deeper in the hierarchy the code now ignores
> it causing things like Thunderbolt chaining fail to recognize new devices.
> 
> The problem with Alex Williamson's machine was solved with commit
> a47d8c8 (ACPI / hotplug / PCI: Avoid parent bus rescans on spurious device
> checks) and hence we should be able to restore the original functionality
> that we always rescan on bus check notification.
> 
> On a device check notification we still check what acpiphp_rescan_slot()
> returns and on zero bail out early.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

So, this is a revert of commit a47d8c8, correct?

Rafael


> ---
> Alex,
> 
> Are you able to check if your machine still works and doesn't slow down
> during boot after this patch is applied?
> 
> Thanks.
> 
>  drivers/pci/hotplug/acpiphp_glue.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index be12fbf..1ea7523 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -552,9 +552,8 @@ static void __ref enable_slot(struct acpiphp_slot *slot)
>  	struct acpiphp_func *func;
>  	int max, pass;
>  	LIST_HEAD(add_list);
> -	int nr_found;
>  
> -	nr_found = acpiphp_rescan_slot(slot);
> +	acpiphp_rescan_slot(slot);
>  	max = acpiphp_max_busnr(bus);
>  	for (pass = 0; pass < 2; pass++) {
>  		list_for_each_entry(dev, &bus->devices, bus_list) {
> @@ -574,9 +573,6 @@ static void __ref enable_slot(struct acpiphp_slot *slot)
>  		}
>  	}
>  	__pci_bus_assign_resources(bus, &add_list, NULL);
> -	/* Nothing more to do here if there are no new devices on this bus. */
> -	if (!nr_found && (slot->flags & SLOT_ENABLED))
> -		return;
>  
>  	acpiphp_sanitize_bus(bus);
>  	acpiphp_set_hpp_values(bus);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
