Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3A3R16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:27:58 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44923 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3A3R1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:27:54 -0500
MIME-Version: 1.0
In-Reply-To: <1359562210-26536-2-git-send-email-jiang.liu@huawei.com>
References: <1359562210-26536-1-git-send-email-jiang.liu@huawei.com>
	<1359562210-26536-2-git-send-email-jiang.liu@huawei.com>
Date: Wed, 30 Jan 2013 09:27:39 -0800
X-Google-Sender-Auth: C2o0wgR8etS_i0C18FuKeVKZHNY
Message-ID: <CAE9FiQU2LvEjTpbjs+LUb=vU7XDC_76OEo5irR_Bn_DjvfgQ0w@mail.gmail.com>
Subject: Re: [PATCH 2/2] acpiphp: remove dead code for PCI host bridge hotplug
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 8:10 AM, Jiang Liu <liuj97@gmail.com> wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
>
> Commit 668192b678201d2fff27c "PCI: acpiphp: Move host bridge hotplug
> to pci_root.c" has moved PCI host bridge hotplug logic from acpiphp
> to pci_root, but there is still PCI host bridge hotplug related
> dead code left in acpiphp. So remove those dead code.
>
> Now companion ACPI devices are always created before corresponding
> PCI devices. And the ACPI event handle_hotplug_event_bridge() will be
> installed only if it has associated PCI device. So remove dead code to
> handle bridge hot-adding in function handle_hotplug_event_bridge().
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  drivers/pci/hotplug/acpiphp.h      |   13 +---
>  drivers/pci/hotplug/acpiphp_glue.c |  124 ++++--------------------------------
>  2 files changed, 14 insertions(+), 123 deletions(-)
>
> diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
> index b3ead7a..b70ac00 100644
> --- a/drivers/pci/hotplug/acpiphp.h
> +++ b/drivers/pci/hotplug/acpiphp.h
> @@ -79,7 +79,6 @@ struct acpiphp_bridge {
>         /* Ejectable PCI-to-PCI bridge (PCI bridge and PCI function) */
>         struct acpiphp_func *func;
>
> -       int type;
>         int nr_slots;
>
>         u32 flags;
> @@ -146,10 +145,6 @@ struct acpiphp_attention_info
>  /* PCI bus bridge HID */
>  #define ACPI_PCI_HOST_HID              "PNP0A03"
>
> -/* PCI BRIDGE type */
> -#define BRIDGE_TYPE_HOST               0
> -#define BRIDGE_TYPE_P2P                        1
> -
>  /* ACPI _STA method value (ignore bit 4; battery present) */
>  #define ACPI_STA_PRESENT               (0x00000001)
>  #define ACPI_STA_ENABLED               (0x00000002)
> @@ -158,13 +153,7 @@ struct acpiphp_attention_info
>  #define ACPI_STA_ALL                   (0x0000000f)
>
>  /* bridge flags */
> -#define BRIDGE_HAS_STA         (0x00000001)
> -#define BRIDGE_HAS_EJ0         (0x00000002)
> -#define BRIDGE_HAS_HPP         (0x00000004)
> -#define BRIDGE_HAS_PS0         (0x00000010)
> -#define BRIDGE_HAS_PS1         (0x00000020)
> -#define BRIDGE_HAS_PS2         (0x00000040)
> -#define BRIDGE_HAS_PS3         (0x00000080)
> +#define BRIDGE_HAS_EJ0         (0x00000001)
>
>  /* slot flags */
>
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index acb7af2..4681d2c 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -325,8 +325,8 @@ static void init_bridge_misc(struct acpiphp_bridge *bridge)
>                 return;
>         }
>
> -       /* install notify handler */
> -       if (bridge->type != BRIDGE_TYPE_HOST) {
> +       /* install notify handler for P2P bridges */
> +       if (!pci_is_root_bus(bridge->pci_bus)) {
>                 if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
>                         status = acpi_remove_notify_handler(bridge->func->handle,
>                                                 ACPI_SYSTEM_NOTIFY,
> @@ -369,27 +369,12 @@ static struct acpiphp_func *acpiphp_bridge_handle_to_function(acpi_handle handle
>  static inline void config_p2p_bridge_flags(struct acpiphp_bridge *bridge)
>  {
>         acpi_handle dummy_handle;
> +       struct acpiphp_func *func;
>
>         if (ACPI_SUCCESS(acpi_get_handle(bridge->handle,
> -                                       "_STA", &dummy_handle)))
> -               bridge->flags |= BRIDGE_HAS_STA;
> -
> -       if (ACPI_SUCCESS(acpi_get_handle(bridge->handle,
> -                                       "_EJ0", &dummy_handle)))
> +                                       "_EJ0", &dummy_handle))) {
>                 bridge->flags |= BRIDGE_HAS_EJ0;
>
> -       if (ACPI_SUCCESS(acpi_get_handle(bridge->handle,
> -                                       "_PS0", &dummy_handle)))
> -               bridge->flags |= BRIDGE_HAS_PS0;
> -
> -       if (ACPI_SUCCESS(acpi_get_handle(bridge->handle,
> -                                       "_PS3", &dummy_handle)))
> -               bridge->flags |= BRIDGE_HAS_PS3;
> -
> -       /* is this ejectable p2p bridge? */
> -       if (bridge->flags & BRIDGE_HAS_EJ0) {
> -               struct acpiphp_func *func;
> -
>                 dbg("found ejectable p2p bridge\n");
>
>                 /* make link between PCI bridge and PCI function */
> @@ -412,7 +397,6 @@ static void add_host_bridge(struct acpi_pci_root *root)
>         if (bridge == NULL)
>                 return;
>
> -       bridge->type = BRIDGE_TYPE_HOST;
>         bridge->handle = handle;
>
>         bridge->pci_bus = root->bus;
> @@ -432,7 +416,6 @@ static void add_p2p_bridge(acpi_handle *handle)
>                 return;
>         }
>
> -       bridge->type = BRIDGE_TYPE_P2P;
>         bridge->handle = handle;
>         config_p2p_bridge_flags(bridge);
>
> @@ -543,7 +526,7 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
>         acpi_status status;
>         acpi_handle handle = bridge->handle;
>
> -       if (bridge->type != BRIDGE_TYPE_HOST) {
> +       if (!pci_is_root_bus(bridge->pci_bus)) {
>                 status = acpi_remove_notify_handler(handle,
>                                             ACPI_SYSTEM_NOTIFY,
>                                             handle_hotplug_event_bridge);
> @@ -551,8 +534,7 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
>                         err("failed to remove notify handler\n");
>         }
>
> -       if ((bridge->type != BRIDGE_TYPE_HOST) &&
> -           ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func)) {
> +       if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
>                 status = acpi_install_notify_handler(bridge->func->handle,
>                                                 ACPI_SYSTEM_NOTIFY,
>                                                 handle_hotplug_event_func,
> @@ -1122,64 +1104,11 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
>         }
>  }
>
> -/* Program resources in newly inserted bridge */
> -static int acpiphp_configure_p2p_bridge(acpi_handle handle)
> -{
> -       struct pci_dev *pdev = acpi_get_pci_dev(handle);
> -       struct pci_bus *bus = pdev->subordinate;
> -
> -       pci_dev_put(pdev);
> -
> -       pci_bus_size_bridges(bus);
> -       pci_bus_assign_resources(bus);
> -       acpiphp_sanitize_bus(bus);
> -       acpiphp_set_hpp_values(bus);
> -       pci_enable_bridges(bus);
> -       return 0;
> -}
> -
> -static void handle_p2p_bridge_insertion(acpi_handle handle, u32 type)
> -{
> -       struct acpi_device *device;
> -
> -       if ((type != ACPI_NOTIFY_BUS_CHECK) &&
> -                       (type != ACPI_NOTIFY_DEVICE_CHECK)) {
> -               err("unexpected notification type %d\n", type);
> -               return;
> -       }
> -
> -       if (acpi_bus_scan(handle)) {
> -               err("cannot add bridge to acpi list\n");
> -               return;
> -       }
> -       if (acpi_bus_get_device(handle, &device)) {
> -               err("ACPI device object missing\n");
> -               return;
> -       }
> -       if (!acpiphp_configure_p2p_bridge(handle))
> -               add_p2p_bridge(handle);
> -       else
> -               err("cannot configure and start bridge\n");
> -
> -}
> -
>  /*
>   * ACPI event handlers
>   */
>
>  static acpi_status
> -count_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
> -{
> -       int *count = (int *)context;
> -       struct acpiphp_bridge *bridge;
> -
> -       bridge = acpiphp_handle_to_bridge(handle);
> -       if (bridge)
> -               (*count)++;
> -       return AE_OK ;
> -}
> -
> -static acpi_status
>  check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
>  {
>         struct acpiphp_bridge *bridge;
> @@ -1203,8 +1132,6 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
>         char objname[64];
>         struct acpi_buffer buffer = { .length = sizeof(objname),
>                                       .pointer = objname };
> -       struct acpi_device *device;
> -       int num_sub_bridges = 0;
>         struct acpi_hp_work *hp_work;
>         acpi_handle handle;
>         u32 type;
> @@ -1212,23 +1139,7 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
>         hp_work = container_of(work, struct acpi_hp_work, work);
>         handle = hp_work->handle;
>         type = hp_work->type;
> -
> -       if (acpi_bus_get_device(handle, &device)) {
> -               /* This bridge must have just been physically inserted */
> -               handle_p2p_bridge_insertion(handle, type);
> -               goto out;
> -       }

According to my understanding, for acpiphp we still need to support:

one slot is on root bus 0, and will take p2p bridge directly.

I thought that I pointed this out when Yijing Wang or someone else
pose similar patch.

Thanks

Yinghai
