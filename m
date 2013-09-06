Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3IFPqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:46:31 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:56200 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab3IFPq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:46:29 -0400
MIME-Version: 1.0
In-Reply-To: <1831138.AvDtjG8RWn@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
	<1599165.8kjc3DtEzc@vostro.rjw.lan>
	<2228690.GcUDD3xFfP@vostro.rjw.lan>
	<1831138.AvDtjG8RWn@vostro.rjw.lan>
Date: Fri, 6 Sep 2013 08:46:28 -0700
X-Google-Sender-Auth: kKgaUb7xJSA97w9VHQez1E6rojA
Message-ID: <CAE9FiQXacWEXngMCQeB1CPVxuvL-jNW_MyMcDV-e8tK6DvY3Kw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ACPI / hotplug / PCI: Avoid doing too much for
 spurious notifies
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 6:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Sometimes we may get a spurious device check or bus check notify for
> a hotplug device and in those cases we should avoid doing all of the
> configuration work needed when something actually changes.  To that
> end, check the return value of pci_scan_slot() in enable_slot() and
> bail out early if it is 0.
>
> This turns out to help reduce the amount of diagnostic output from
> the ACPIPHP subsystem and speed up boot on at least one system that
> generates multiple device check notifies for PCIe ports during
> boot.
>
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |   35 +++++++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
>
> Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> @@ -542,12 +542,12 @@ static void __ref enable_slot(struct acp
>         struct acpiphp_func *func;
>         int max, pass;
>         LIST_HEAD(add_list);
> +       int nr_found;
>
>         list_for_each_entry(func, &slot->funcs, sibling)
>                 acpiphp_bus_add(func_to_handle(func));
>
> -       pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
> -
> +       nr_found = pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
>         max = acpiphp_max_busnr(bus);
>         for (pass = 0; pass < 2; pass++) {
>                 list_for_each_entry(dev, &bus->devices, bus_list) {
> @@ -566,8 +566,11 @@ static void __ref enable_slot(struct acp
>                         }
>                 }
>         }
> -
>         __pci_bus_assign_resources(bus, &add_list, NULL);
> +       /* Nothing more to do here if there are no new devices on this bus. */
> +       if (!nr_found && (slot->flags & SLOT_ENABLED))
> +               return;
> +
>         acpiphp_sanitize_bus(bus);
>         acpiphp_set_hpp_values(bus);
>         acpiphp_set_acpi_region(slot);
>

why not just returning early before size bridges and assign unassign resources?

Yinghai
