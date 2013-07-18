Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328Ab3GRBkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 21:40:14 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45097 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632Ab3GRBkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 21:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <10121200.vQGTlJqFtd@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
	<3718119.FLASu5DBx8@vostro.rjw.lan>
	<2366394.4EoP1MXmG2@vostro.rjw.lan>
	<10121200.vQGTlJqFtd@vostro.rjw.lan>
Date: Wed, 17 Jul 2013 18:40:10 -0700
X-Google-Sender-Auth: Yb-NoF_k9dTvG0d2GpGHUySEwoY
Message-ID: <CAE9FiQXcLeNxjmh-6+jtpOmgC-NB3=Pwh1vZnb+DNLnoKzZQaQ@mail.gmail.com>
Subject: Re: [PATCH 2/30] ACPI / hotplug / PCI: Consolidate acpiphp_enumerate_slots()
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 4:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The acpiphp_enumerate_slots() function is now split into two parts,
> acpiphp_enumerate_slots() proper and init_bridge_misc() which is
> only called by the former.  If these functions are combined,
> it is possible to make the code easier to follow and to clean up
> the error handling (to prevent memory leaks on error from
> happening in particular), so do that.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |   92 ++++++++++++++++++-------------------
>  1 file changed, 45 insertions(+), 47 deletions(-)
>
> Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> @@ -353,46 +353,6 @@ static int detect_ejectable_slots(acpi_h
>         return found;
>  }
>
> -/* initialize miscellaneous stuff for both root and PCI-to-PCI bridge */
> -static void init_bridge_misc(struct acpiphp_bridge *bridge)
> -{
> -       acpi_status status;
> -
> -       /* must be added to the list prior to calling register_slot */
> -       mutex_lock(&bridge_mutex);
> -       list_add(&bridge->list, &bridge_list);
> -       mutex_unlock(&bridge_mutex);
> -
> -       /* register all slot objects under this bridge */
> -       status = acpi_walk_namespace(ACPI_TYPE_DEVICE, bridge->handle, (u32)1,
> -                                    register_slot, NULL, bridge, NULL);
> -       if (ACPI_FAILURE(status)) {
> -               mutex_lock(&bridge_mutex);
> -               list_del(&bridge->list);
> -               mutex_unlock(&bridge_mutex);
> -               return;
> -       }
> -
> -       /* install notify handler for P2P bridges */
> -       if (!pci_is_root_bus(bridge->pci_bus)) {
> -               if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
> -                       status = acpi_remove_notify_handler(bridge->func->handle,
> -                                               ACPI_SYSTEM_NOTIFY,
> -                                               handle_hotplug_event_func);
> -                       if (ACPI_FAILURE(status))
> -                               err("failed to remove notify handler\n");
> -               }
> -               status = acpi_install_notify_handler(bridge->handle,
> -                                            ACPI_SYSTEM_NOTIFY,
> -                                            handle_hotplug_event_bridge,
> -                                            bridge);
> -
> -               if (ACPI_FAILURE(status)) {
> -                       err("failed to register interrupt notify handler\n");
> -               }
> -       }
> -}
> -
>
>  /* find acpiphp_func from acpiphp_bridge */
>  static struct acpiphp_func *acpiphp_bridge_handle_to_function(acpi_handle handle)
> @@ -1149,8 +1109,9 @@ static void handle_hotplug_event_func(ac
>   */
>  void acpiphp_enumerate_slots(struct pci_bus *bus)
>  {
> -       acpi_handle handle;
>         struct acpiphp_bridge *bridge;
> +       acpi_handle handle;
> +       acpi_status status;
>
>         if (acpiphp_disabled)
>                 return;
> @@ -1178,14 +1139,51 @@ void acpiphp_enumerate_slots(struct pci_
>          */
>         get_device(&bus->dev);
>
> -       if (!pci_is_root_bus(bridge->pci_bus) &&
> -           acpi_has_method(bridge->handle, "_EJ0")) {
> -               dbg("found ejectable p2p bridge\n");
> -               bridge->flags |= BRIDGE_HAS_EJ0;
> -               bridge->func = acpiphp_bridge_handle_to_function(handle);
> +       /* must be added to the list prior to calling register_slot */
> +       mutex_lock(&bridge_mutex);
> +       list_add(&bridge->list, &bridge_list);
> +       mutex_unlock(&bridge_mutex);
> +
> +       /* register all slot objects under this bridge */
> +       status = acpi_walk_namespace(ACPI_TYPE_DEVICE, bridge->handle, 1,
> +                                    register_slot, NULL, bridge, NULL);
> +       if (ACPI_FAILURE(status)) {
> +               acpi_handle_err(bridge->handle, "failed to register slots\n");
> +               goto err;
> +       }
> +
> +       if (pci_is_root_bus(bridge->pci_bus))
> +               return;
> +
> +       /* install notify handler for P2P bridges */
> +       status = acpi_install_notify_handler(bridge->handle, ACPI_SYSTEM_NOTIFY,
> +                                            handle_hotplug_event_bridge,
> +                                            bridge);
> +       if (ACPI_FAILURE(status)) {
> +               acpi_handle_err(bridge->handle,
> +                               "failed to register notify handler\n");
> +               goto err;
>         }
>
> -       init_bridge_misc(bridge);
> +       if (!acpi_has_method(bridge->handle, "_EJ0"))
> +               return;
> +
> +       dbg("found ejectable p2p bridge\n");
> +       bridge->flags |= BRIDGE_HAS_EJ0;
> +       bridge->func = acpiphp_bridge_handle_to_function(bridge->handle);
> +       if (bridge->func) {
> +               status = acpi_remove_notify_handler(bridge->func->handle,
> +                                                   ACPI_SYSTEM_NOTIFY,
> +                                                   handle_hotplug_event_func);
> +               if (ACPI_FAILURE(status))
> +                       acpi_handle_err(bridge->func->handle,
> +                                       "failed to remove notify handler\n");
> +       }

looks little weird that you change to install bridge notifier handler and remove
bridge func notifier handler.
actually these two handles is the same one.

I would prefer to keeping the old sequence.

Yinghai
