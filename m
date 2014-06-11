Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbaFKC3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:29:37 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:43067 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaFKC3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <1986515.ZPZrccsmiq@vostro.rjw.lan>
References: <1986515.ZPZrccsmiq@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 10 Jun 2014 20:29:15 -0600
Message-ID: <CAErSpo5rpdb985tS91BOEGJePwU3OSzKp_KgrrZfRqaxKBgPMw@mail.gmail.com>
Subject: Re: [PATCH] ACPI / hotplug / PCI: Add hotplug contexts to PCI host bridges
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 2:51 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> After relatively recent changes in the ACPI-based PCI hotplug
> (ACPIPHP) code, the acpiphp_check_host_bridge() executed for PCI
> host bridges via acpi_pci_root_scan_dependent() doesn't do anything
> useful, because those bridges do not have hotplug contexts.  That
> happens by mistake, so fix it by making acpiphp_enumerate_slots()
> add hotplug contexts to PCI host bridges too and modify
> acpiphp_remove_slots() to drop those contexts for host bridges
> as appropriate.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=76901
> Fixes: 2d8b1d566a5f (ACPI / hotplug / PCI: Get rid of check_sub_bridges())
> Reported-and-tested-by: Gavin Guo <gavin.guo@canonical.com>
> Cc: 3.15+ <stable@vger.kernel.org> # 3.15+
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Rafael, do you want to merge this via your tree, since you merged the
original acpiphp rework?

I do have a small cleanup of acpiphp_glue.c in my queue, but it won't
conflict with this.

Thanks a lot for fixing this!

Bjorn

> ---
>  drivers/pci/hotplug/acpiphp.h      |   10 ++++++
>  drivers/pci/hotplug/acpiphp_glue.c |   60 +++++++++++++++++++++++++------------
>  2 files changed, 52 insertions(+), 18 deletions(-)
>
> Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> @@ -373,17 +373,13 @@ static acpi_status acpiphp_add_context(a
>
>  static struct acpiphp_bridge *acpiphp_dev_to_bridge(struct acpi_device *adev)
>  {
> -       struct acpiphp_context *context;
>         struct acpiphp_bridge *bridge = NULL;
>
>         acpi_lock_hp_context();
> -       context = acpiphp_get_context(adev);
> -       if (context) {
> -               bridge = context->bridge;
> +       if (adev->hp) {
> +               bridge = to_acpiphp_root_context(adev->hp)->root_bridge;
>                 if (bridge)
>                         get_bridge(bridge);
> -
> -               acpiphp_put_context(context);
>         }
>         acpi_unlock_hp_context();
>         return bridge;
> @@ -881,7 +877,17 @@ void acpiphp_enumerate_slots(struct pci_
>          */
>         get_device(&bus->dev);
>
> -       if (!pci_is_root_bus(bridge->pci_bus)) {
> +       acpi_lock_hp_context();
> +       if (pci_is_root_bus(bridge->pci_bus)) {
> +               struct acpiphp_root_context *root_context;
> +
> +               root_context = kzalloc(sizeof(*root_context), GFP_KERNEL);
> +               if (!root_context)
> +                       goto err;
> +
> +               root_context->root_bridge = bridge;
> +               acpi_set_hp_context(adev, &root_context->hp, NULL, NULL, NULL);
> +       } else {
>                 struct acpiphp_context *context;
>
>                 /*
> @@ -890,21 +896,16 @@ void acpiphp_enumerate_slots(struct pci_
>                  * parent is going to be handled by pciehp, in which case this
>                  * bridge is not interesting to us either.
>                  */
> -               acpi_lock_hp_context();
>                 context = acpiphp_get_context(adev);
> -               if (!context) {
> -                       acpi_unlock_hp_context();
> -                       put_device(&bus->dev);
> -                       pci_dev_put(bridge->pci_dev);
> -                       kfree(bridge);
> -                       return;
> -               }
> +               if (!context)
> +                       goto err;
> +
>                 bridge->context = context;
>                 context->bridge = bridge;
>                 /* Get a reference to the parent bridge. */
>                 get_bridge(context->func.parent);
> -               acpi_unlock_hp_context();
>         }
> +       acpi_unlock_hp_context();
>
>         /* Must be added to the list prior to calling acpiphp_add_context(). */
>         mutex_lock(&bridge_mutex);
> @@ -919,6 +920,30 @@ void acpiphp_enumerate_slots(struct pci_
>                 cleanup_bridge(bridge);
>                 put_bridge(bridge);
>         }
> +       return;
> +
> + err:
> +       acpi_unlock_hp_context();
> +       put_device(&bus->dev);
> +       pci_dev_put(bridge->pci_dev);
> +       kfree(bridge);
> +}
> +
> +void acpiphp_drop_bridge(struct acpiphp_bridge *bridge)
> +{
> +       if (pci_is_root_bus(bridge->pci_bus)) {
> +               struct acpiphp_root_context *root_context;
> +               struct acpi_device *adev;
> +
> +               acpi_lock_hp_context();
> +               adev = ACPI_COMPANION(bridge->pci_bus->bridge);
> +               root_context = to_acpiphp_root_context(adev->hp);
> +               adev->hp = NULL;
> +               acpi_unlock_hp_context();
> +               kfree(root_context);
> +       }
> +       cleanup_bridge(bridge);
> +       put_bridge(bridge);
>  }
>
>  /**
> @@ -936,8 +961,7 @@ void acpiphp_remove_slots(struct pci_bus
>         list_for_each_entry(bridge, &bridge_list, list)
>                 if (bridge->pci_bus == bus) {
>                         mutex_unlock(&bridge_mutex);
> -                       cleanup_bridge(bridge);
> -                       put_bridge(bridge);
> +                       acpiphp_drop_bridge(bridge);
>                         return;
>                 }
>
> Index: linux-pm/drivers/pci/hotplug/acpiphp.h
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
> +++ linux-pm/drivers/pci/hotplug/acpiphp.h
> @@ -142,6 +142,16 @@ static inline acpi_handle func_to_handle
>         return func_to_acpi_device(func)->handle;
>  }
>
> +struct acpiphp_root_context {
> +       struct acpi_hotplug_context hp;
> +       struct acpiphp_bridge *root_bridge;
> +};
> +
> +static inline struct acpiphp_root_context *to_acpiphp_root_context(struct acpi_hotplug_context *hp)
> +{
> +       return container_of(hp, struct acpiphp_root_context, hp);
> +}
> +
>  /*
>   * struct acpiphp_attention_info - device specific attention registration
>   *
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
