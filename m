Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3FNVEC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:04:02 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:59693 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3FNVEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:04:00 -0400
MIME-Version: 1.0
In-Reply-To: <1371238081-32260-5-git-send-email-jiang.liu@huawei.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com>
	<1371238081-32260-5-git-send-email-jiang.liu@huawei.com>
Date: Fri, 14 Jun 2013 14:03:59 -0700
X-Google-Sender-Auth: 1c4vv5_qwXvFsGssncfn85Avuww
Message-ID: <CAE9FiQWd8QCpSYp-d7SvXvu=GdSEV7SoTSnfC+VBkz=g5sxR8w@mail.gmail.com>
Subject: Re: [BUGFIX v2 4/4] ACPIPHP: fix bug 56531 Sony VAIO VPCZ23A4R: can't
 assign mem/io after docking
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 12:28 PM, Jiang Liu <jiang.liu@huawei.com> wrote:
> Please refer to https://bugzilla.kernel.org/show_bug.cgi?id=56531 for
> more information.
>
> This issue is caused by differences in PCI resource assignment between
> boot time and runtime hotplug. On x86 platforms, OS respects PCI
> resource assignment from BIOS and only reassign resources for unassigned
> BARs at boot time. But with acpiphp, it ignores BIOS resource assignment
> and reassign all resources by itself.
>
> If we have enough resources, reassigning all PCI resources should work
> too, but it may fail if we are under resource constraints. On the other
> handle, current PCI MMIO alignment algorithm may waste huge MMIO address
> space if we have some PCI devices with huge MMIO BARs.
>
> On this Sony laptop, BIOS allocates limited MMIO resources for the dock
> station and the dock station has a gfx which has a 256MB MMIO BAR.
> So current acpiphp driver fails to allocate resources for most devices
> on the dock station.
>
> So change acpiphp driver to follow boot time behavior to respect BIOS
> resource assignment.
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
> Tested-by: Alexander E. Patrakov <patrakov@gmail.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: <stable@vger.kernel.org>

Acked-by: Yinghai Lu <yinghai@kernel.org>

> ---
>  drivers/pci/hotplug/acpiphp_glue.c | 7 +++++--
>  drivers/pci/pci.h                  | 5 +++++
>  drivers/pci/setup-bus.c            | 8 ++++----
>  3 files changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index a65203b..f4a53e9 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -687,6 +687,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>         struct pci_bus *bus = slot->bridge->pci_bus;
>         struct acpiphp_func *func;
>         int num, max, pass;
> +       LIST_HEAD(add_list);
>
>         if (slot->flags & SLOT_ENABLED)
>                 goto err_exit;
> @@ -711,13 +712,15 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>                                 max = pci_scan_bridge(bus, dev, max, pass);
>                                 if (pass && dev->subordinate) {
>                                         check_hotplug_bridge(slot, dev);
> -                                       pci_bus_size_bridges(dev->subordinate);
> +                                       pcibios_resource_survey_bus(dev->subordinate);
> +                                       __pci_bus_size_bridges(dev->subordinate,
> +                                                              &add_list);
>                                 }
>                         }
>                 }
>         }
>
> -       pci_bus_assign_resources(bus);
> +       __pci_bus_assign_resources(bus, &add_list, NULL);
>         acpiphp_sanitize_bus(bus);
>         acpiphp_set_hpp_values(bus);
>         acpiphp_set_acpi_region(slot);
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 68678ed..d1182c4 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -202,6 +202,11 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>                     struct resource *res, unsigned int reg);
>  int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type);
>  void pci_configure_ari(struct pci_dev *dev);
> +void __ref __pci_bus_size_bridges(struct pci_bus *bus,
> +                       struct list_head *realloc_head);
> +void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
> +                                     struct list_head *realloc_head,
> +                                     struct list_head *fail_head);
>
>  /**
>   * pci_ari_enabled - query ARI forwarding status
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 16abaaa..d254e23 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -1044,7 +1044,7 @@ handle_done:
>         ;
>  }
>
> -static void __ref __pci_bus_size_bridges(struct pci_bus *bus,
> +void __ref __pci_bus_size_bridges(struct pci_bus *bus,
>                         struct list_head *realloc_head)
>  {
>         struct pci_dev *dev;
> @@ -1115,9 +1115,9 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
>  }
>  EXPORT_SYMBOL(pci_bus_size_bridges);
>
> -static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
> -                                        struct list_head *realloc_head,
> -                                        struct list_head *fail_head)
> +void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
> +                                     struct list_head *realloc_head,
> +                                     struct list_head *fail_head)
>  {
>         struct pci_bus *b;
>         struct pci_dev *dev;
> --
> 1.8.1.2
>
