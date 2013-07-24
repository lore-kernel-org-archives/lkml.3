Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab3GXCU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 22:20:56 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:50812 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3GXCUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 22:20:54 -0400
MIME-Version: 1.0
In-Reply-To: <3215120.cRBBS5jciE@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
	<2366394.4EoP1MXmG2@vostro.rjw.lan>
	<CAE9FiQVq3O45SOr9h6c5dBiAZs2Ry6z6L_irW8AE-fZ_1NmMXQ@mail.gmail.com>
	<3215120.cRBBS5jciE@vostro.rjw.lan>
Date: Tue, 23 Jul 2013 19:20:53 -0700
X-Google-Sender-Auth: cYaIfTd9BTgyi6Dj_2kBbWe_Fxc
Message-ID: <CAE9FiQURY5WFFJekPHV_s0HPi8uhKzSDOLSXHAkyLPf1=i8oAw@mail.gmail.com>
Subject: Re: [PATCH 0/30] ACPI / hotplug / PCI: Major rework + Thunderbolt workarounds
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

On Tue, Jul 23, 2013 at 2:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Ugh, stupid bug, sorry about it.  We try to unregister something that may have
> not been registered.
>
> Can you please check if the appended patch helps (on top of
> linux-pm.git/linux-next)?
>
> Rafael
>
>
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> @@ -340,6 +340,7 @@ static acpi_status register_slot(acpi_ha
>
>                 retval = acpiphp_register_hotplug_slot(slot, sun);
>                 if (retval) {
> +                       slot->slot = NULL;
>                         bridge->nr_slots--;
>                         if (retval == -EBUSY)
>                                 warn("Slot %llu already registered by another "
> @@ -429,7 +430,8 @@ static void cleanup_bridge(struct acpiph
>                                         err("failed to remove notify handler\n");
>                         }
>                 }
> -               acpiphp_unregister_hotplug_slot(slot);
> +               if (slot->slot)
> +                       acpiphp_unregister_hotplug_slot(slot);
>         }
>
>         mutex_lock(&bridge_mutex);
>

yes, that fixes the problem. Thanks

10:~ # echo "PCI0 3" > /sys/kernel/debug/acpi/sci_notify
[  102.231645] ACPI: ACPI device name is <PCI0>, event code is <3>
[  102.233189] ACPI: Notify event is queued
[  102.234326] ACPI: \_SB_.PCI0: Device eject notify on
_handle_hotplug_event_root
10:~ # [  102.357749] ACPI: Device 0000:00:03.0 -x-> \_SB_.PCI0.S03_
[  102.359902] ACPI: Device 0000:00:02.0 -x-> \_SB_.PCI0.VGA_
[  102.362188] ACPI: Device 0000:00:01.3 -x-> \_SB_.PCI0.PX13
[  102.364752] ata1.00: disabled
[  102.372154] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  102.374523] sd 0:0:0:0: [sda]
[  102.375759] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[  102.378173] sd 0:0:0:0: [sda] Stopping disk
[  102.380248] sd 0:0:0:0: [sda] START_STOP FAILED
[  102.381983] sd 0:0:0:0: [sda]
[  102.383167] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[  102.387588] ata2.00: disabled
[  102.395254] ACPI: Device 0000:00:01.0 -x-> \_SB_.PCI0.ISA_
[  102.396943] ACPI: Device pci0000:00 -x-> \_SB_.PCI0
[  102.398162]   acpi_pci_iommu_remove is called for \_SB_.PCI0 ffff88007ab3f1e0
[  102.400253]   acpi_pci_ioapic_remove is called for \_SB_.PCI0
ffff88007ab3f1e0
[  102.402176] pci 0000:00:00.0: freeing pci_dev info
[  102.404247] pci 0000:00:01.0: freeing pci_dev info
[  102.406611] pci 0000:00:01.1: freeing pci_dev info
[  102.408401] pci 0000:00:01.3: freeing pci_dev info
[  102.410276] pci 0000:00:02.0: freeing pci_dev info
[  102.411378] pci 0000:00:03.0: freeing pci_dev info
[  102.412485] pci_bus 0000:00: busn_res: [bus 00-ff] is released
[  102.413945] acpiphp: Slot [3] unregistered
[  102.415189] pci_hotplug: pci_hp_deregister: Removed slot 3 from the list
[  102.418224] acpiphp: release_slot - physical_slot = 3
[  102.420439] pci_bus 0000:00: dev 03, dec refcount to 1
[  102.422689] acpiphp: Slot [4] unregistered
[  102.424592] pci_hotplug: pci_hp_deregister: Removed slot 4 from the list
[  102.427484] acpiphp: release_slot - physical_slot = 4
[  102.429679] pci_bus 0000:00: dev 04, dec refcount to 1
[  102.431492] acpiphp: Slot [5] unregistered
[  102.433169] pci_hotplug: pci_hp_deregister: Removed slot 5 from the list
[  102.435486] acpiphp: release_slot - physical_slot = 5
[  102.436963] pci_bus 0000:00: dev 05, dec refcount to 1
[  102.438140] acpiphp: Slot [6] unregistered
[  102.439116] pci_hotplug: pci_hp_deregister: Removed slot 6 from the list
[  102.440922] acpiphp: release_slot - physical_slot = 6
[  102.442079] pci_bus 0000:00: dev 06, dec refcount to 1
[  102.443280] acpiphp: Slot [7] unregistered
[  102.444286] pci_hotplug: pci_hp_deregister: Removed slot 7 from the list
[  102.445840] acpiphp: release_slot - physical_slot = 7
[  102.447024] pci_bus 0000:00: dev 07, dec refcount to 1
[  102.448272] acpiphp: Slot [8] unregistered
[  102.449236] pci_hotplug: pci_hp_deregister: Removed slot 8 from the list
[  102.450770] acpiphp: release_slot - physical_slot = 8
[  102.451632] pci_bus 0000:00: dev 08, dec refcount to 1
[  102.452870] acpiphp: Slot [9] unregistered
[  102.453848] pci_hotplug: pci_hp_deregister: Removed slot 9 from the list
[  102.455400] acpiphp: release_slot - physical_slot = 9
[  102.456594] pci_bus 0000:00: dev 09, dec refcount to 1
[  102.457557] acpiphp: Slot [10] unregistered
[  102.458542] pci_hotplug: pci_hp_deregister: Removed slot 10 from the list
[  102.460124] acpiphp: release_slot - physical_slot = 10
[  102.461295] pci_bus 0000:00: dev 0a, dec refcount to 1
[  102.462482] acpiphp: Slot [11] unregistered
[  102.463464] pci_hotplug: pci_hp_deregister: Removed slot 11 from the list
[  102.465046] acpiphp: release_slot - physical_slot = 11
[  102.467024] pci_bus 0000:00: dev 0b, dec refcount to 1
[  102.468199] acpiphp: Slot [12] unregistered
[  102.469210] pci_hotplug: pci_hp_deregister: Removed slot 12 from the list
[  102.470798] acpiphp: release_slot - physical_slot = 12
[  102.471992] pci_bus 0000:00: dev 0c, dec refcount to 1
[  102.473239] acpiphp: Slot [13] unregistered
[  102.473959] pci_hotplug: pci_hp_deregister: Removed slot 13 from the list
[  102.475545] acpiphp: release_slot - physical_slot = 13
[  102.476516] pci_bus 0000:00: dev 0d, dec refcount to 1
[  102.477740] acpiphp: Slot [14] unregistered
[  102.478733] pci_hotplug: pci_hp_deregister: Removed slot 14 from the list
[  102.480319] acpiphp: release_slot - physical_slot = 14
[  102.481296] pci_bus 0000:00: dev 0e, dec refcount to 1
[  102.481947] acpiphp: Slot [15] unregistered
[  102.482888] pci_hotplug: pci_hp_deregister: Removed slot 15 from the list
[  102.484555] acpiphp: release_slot - physical_slot = 15
[  102.485806] pci_bus 0000:00: dev 0f, dec refcount to 1
[  102.486808] acpiphp: Slot [16] unregistered
[  102.487652] pci_hotplug: pci_hp_deregister: Removed slot 16 from the list
[  102.488986] acpiphp: release_slot - physical_slot = 16
[  102.489996] pci_bus 0000:00: dev 10, dec refcount to 1
[  102.491100] acpiphp: Slot [17] unregistered
[  102.492054] pci_hotplug: pci_hp_deregister: Removed slot 17 from the list
[  102.493572] acpiphp: release_slot - physical_slot = 17
[  102.494444] pci_bus 0000:00: dev 11, dec refcount to 1
[  102.495266] acpiphp: Slot [18] unregistered
[  102.495966] pci_hotplug: pci_hp_deregister: Removed slot 18 from the list
[  102.497083] acpiphp: release_slot - physical_slot = 18
[  102.497921] pci_bus 0000:00: dev 12, dec refcount to 1
[  102.498770] acpiphp: Slot [19] unregistered
[  102.499474] pci_hotplug: pci_hp_deregister: Removed slot 19 from the list
[  102.500764] acpiphp: release_slot - physical_slot = 19
[  102.501873] pci_bus 0000:00: dev 13, dec refcount to 1
[  102.502966] acpiphp: Slot [20] unregistered
[  102.503824] pci_hotplug: pci_hp_deregister: Removed slot 20 from the list
[  102.504770] acpiphp: release_slot - physical_slot = 20
[  102.505608] pci_bus 0000:00: dev 14, dec refcount to 1
[  102.506456] acpiphp: Slot [21] unregistered
[  102.507146] pci_hotplug: pci_hp_deregister: Removed slot 21 from the list
[  102.508269] acpiphp: release_slot - physical_slot = 21
[  102.508981] pci_bus 0000:00: dev 15, dec refcount to 1
[  102.509815] acpiphp: Slot [22] unregistered
[  102.510668] pci_hotplug: pci_hp_deregister: Removed slot 22 from the list
[  102.511955] acpiphp: release_slot - physical_slot = 22
[  102.512980] pci_bus 0000:00: dev 16, dec refcount to 1
[  102.514040] acpiphp: Slot [23] unregistered
[  102.514621] pci_hotplug: pci_hp_deregister: Removed slot 23 from the list
[  102.515446] acpiphp: release_slot - physical_slot = 23
[  102.516101] pci_bus 0000:00: dev 17, dec refcount to 1
[  102.516752] acpiphp: Slot [24] unregistered
[  102.517370] pci_hotplug: pci_hp_deregister: Removed slot 24 from the list
[  102.518210] acpiphp: release_slot - physical_slot = 24
[  102.518841] pci_bus 0000:00: dev 18, dec refcount to 1
[  102.519500] acpiphp: Slot [25] unregistered
[  102.520146] pci_hotplug: pci_hp_deregister: Removed slot 25 from the list
[  102.520995] acpiphp: release_slot - physical_slot = 25
[  102.522445] pci_bus 0000:00: dev 19, dec refcount to 1
[  102.523463] acpiphp: Slot [26] unregistered
[  102.524335] pci_hotplug: pci_hp_deregister: Removed slot 26 from the list
[  102.525597] acpiphp: release_slot - physical_slot = 26
[  102.526599] pci_bus 0000:00: dev 1a, dec refcount to 1
[  102.527636] acpiphp: Slot [27] unregistered
[  102.528483] pci_hotplug: pci_hp_deregister: Removed slot 27 from the list
[  102.529812] acpiphp: release_slot - physical_slot = 27
[  102.530872] pci_bus 0000:00: dev 1b, dec refcount to 1
[  102.531988] acpiphp: Slot [28] unregistered
[  102.532775] pci_hotplug: pci_hp_deregister: Removed slot 28 from the list
[  102.534200] acpiphp: release_slot - physical_slot = 28
[  102.535038] pci_bus 0000:00: dev 1c, dec refcount to 1
[  102.535727] acpiphp: Slot [29] unregistered
[  102.536328] pci_hotplug: pci_hp_deregister: Removed slot 29 from the list
[  102.537213] acpiphp: release_slot - physical_slot = 29
[  102.537886] pci_bus 0000:00: dev 1d, dec refcount to 1
[  102.539560] acpiphp: Slot [30] unregistered
[  102.541427] pci_hotplug: pci_hp_deregister: Removed slot 30 from the list
[  102.544245] acpiphp: release_slot - physical_slot = 30
[  102.545431] pci_bus 0000:00: dev 1e, dec refcount to 1
[  102.546647] acpiphp: Slot [31] unregistered
[  102.547643] pci_hotplug: pci_hp_deregister: Removed slot 31 from the list
[  102.549290] acpiphp: release_slot - physical_slot = 31
[  102.550510] pci_bus 0000:00: dev 1f, dec refcount to 1
[  102.551810] pci_bus 0000:00: dev 1f, dec refcount to 0
[  102.552861] pci_bus 0000:00: dev 1f, released physical slot 31
[  102.554226] pci_bus 0000:00: dev 1e, dec refcount to 0
[  102.555448] pci_bus 0000:00: dev 1e, released physical slot 30
[  102.556836] pci_bus 0000:00: dev 1d, dec refcount to 0
[  102.558061] pci_bus 0000:00: dev 1d, released physical slot 29
[  102.559420] pci_bus 0000:00: dev 1c, dec refcount to 0
[  102.560662] pci_bus 0000:00: dev 1c, released physical slot 28
[  102.562016] pci_bus 0000:00: dev 1b, dec refcount to 0
[  102.563218] pci_bus 0000:00: dev 1b, released physical slot 27
[  102.564556] pci_bus 0000:00: dev 1a, dec refcount to 0
[  102.565767] pci_bus 0000:00: dev 1a, released physical slot 26
[  102.567132] pci_bus 0000:00: dev 19, dec refcount to 0
[  102.568366] pci_bus 0000:00: dev 19, released physical slot 25
[  102.569631] pci_bus 0000:00: dev 18, dec refcount to 0
[  102.570826] pci_bus 0000:00: dev 18, released physical slot 24
[  102.572194] pci_bus 0000:00: dev 17, dec refcount to 0
[  102.573407] pci_bus 0000:00: dev 17, released physical slot 23
[  102.574741] pci_bus 0000:00: dev 16, dec refcount to 0
[  102.575960] pci_bus 0000:00: dev 16, released physical slot 22
[  102.577334] pci_bus 0000:00: dev 15, dec refcount to 0
[  102.578548] pci_bus 0000:00: dev 15, released physical slot 21
[  102.579894] pci_bus 0000:00: dev 14, dec refcount to 0
[  102.581141] pci_bus 0000:00: dev 14, released physical slot 20
[  102.582506] pci_bus 0000:00: dev 13, dec refcount to 0
[  102.583722] pci_bus 0000:00: dev 13, released physical slot 19
[  102.585111] pci_bus 0000:00: dev 12, dec refcount to 0
[  102.586328] pci_bus 0000:00: dev 12, released physical slot 18
[  102.587688] pci_bus 0000:00: dev 11, dec refcount to 0
[  102.588915] pci_bus 0000:00: dev 11, released physical slot 17
[  102.590281] pci_bus 0000:00: dev 10, dec refcount to 0
[  102.591485] pci_bus 0000:00: dev 10, released physical slot 16
[  102.592854] pci_bus 0000:00: dev 0f, dec refcount to 0
[  102.594066] pci_bus 0000:00: dev 0f, released physical slot 15
[  102.595417] pci_bus 0000:00: dev 0e, dec refcount to 0
[  102.596635] pci_bus 0000:00: dev 0e, released physical slot 14
[  102.598010] pci_bus 0000:00: dev 0d, dec refcount to 0
[  102.599210] pci_bus 0000:00: dev 0d, released physical slot 13
[  102.600595] pci_bus 0000:00: dev 0c, dec refcount to 0
[  102.601794] pci_bus 0000:00: dev 0c, released physical slot 12
[  102.603143] pci_bus 0000:00: dev 0b, dec refcount to 0
[  102.604362] pci_bus 0000:00: dev 0b, released physical slot 11
[  102.605700] pci_bus 0000:00: dev 0a, dec refcount to 0
[  102.606904] pci_bus 0000:00: dev 0a, released physical slot 10
[  102.608313] pci_bus 0000:00: dev 09, dec refcount to 0
[  102.609539] pci_bus 0000:00: dev 09, released physical slot 9
[  102.610879] pci_bus 0000:00: dev 08, dec refcount to 0
[  102.612117] pci_bus 0000:00: dev 08, released physical slot 8
[  102.613452] pci_bus 0000:00: dev 07, dec refcount to 0
[  102.614664] pci_bus 0000:00: dev 07, released physical slot 7
[  102.615992] pci_bus 0000:00: dev 06, dec refcount to 0
[  102.617221] pci_bus 0000:00: dev 06, released physical slot 6
[  102.618554] pci_bus 0000:00: dev 05, dec refcount to 0
[  102.619758] pci_bus 0000:00: dev 05, released physical slot 5
[  102.621116] pci_bus 0000:00: dev 04, dec refcount to 0
[  102.622320] pci_bus 0000:00: dev 04, released physical slot 4
[  102.623656] pci_bus 0000:00: dev 03, dec refcount to 0
[  102.624887] pci_bus 0000:00: dev 03, released physical slot 3
[  102.626239] pci_bus 0000:00: dev 02, dec refcount to 0
[  102.627445] pci_bus 0000:00: dev 02, released physical slot 2
[  102.628805] pci_bus 0000:00: dev 01, dec refcount to 0
[  102.629589] pci_bus 0000:00: dev 01, released physical slot 1
[  102.630631] pci_bus 0000:00: freeing pci_bus info
[  102.631369] pci_host_bridge pci0000:00: freeing pci_host_bridge info
[  102.633091] ACPI: Device does not support D3cold
[  102.633915] ACPI: Device does not support D3cold
[  102.635221] ACPI: Device does not support D3cold
[  102.636103] ACPI: Device does not support D3cold
[  102.636902] ACPI: Device does not support D3cold
[  102.637685] ACPI: Device does not support D3cold
[  102.638467] ACPI: Device does not support D3cold
[  102.639631] ACPI: Device does not support D3cold
[  102.640472] ACPI: Device does not support D3cold
[  102.641310] ACPI: Device does not support D3cold
[  102.642105] ACPI: Device does not support D3cold
[  102.642928] ACPI: Device does not support D3cold
[  102.643725] ACPI: Device does not support D3cold
[  102.644544] ACPI: Device does not support D3cold
[  102.645344] ACPI: Device does not support D3cold
[  102.646126] ACPI: Device does not support D3cold
[  102.646902] ACPI: Device does not support D3cold
[  102.647677] ACPI: Device does not support D3cold
[  102.648485] ACPI: Device does not support D3cold
[  102.649269] ACPI: Device does not support D3cold
[  102.650065] ACPI: Device does not support D3cold
[  102.650822] ACPI: Device does not support D3cold
[  102.652483] ACPI: Device does not support D3cold
[  102.654157] ACPI: Device does not support D3cold
[  102.655803] ACPI: Device does not support D3cold
[  102.657419] ACPI: Device does not support D3cold
[  102.658528] ACPI: Device does not support D3cold
[  102.659255] ACPI: Device does not support D3cold
[  102.659973] ACPI: Device does not support D3cold
[  102.661807] ACPI: Device does not support D3cold
[  102.661925] ACPI: Device does not support D3cold
[  102.662047] ACPI: Device does not support D3cold
[  102.662148] ACPI: Device does not support D3cold
[  102.662258] ACPI: Device does not support D3cold
[  102.662374] ACPI: Device does not support D3cold
[  102.662486] ACPI: Device does not support D3cold
[  102.662597] ACPI: Device does not support D3cold
[  102.662711] ACPI: Device does not support D3cold
[  102.662814] ACPI: Device does not support D3cold
[  102.662918] ACPI: Device does not support D3cold
[  102.663019] ACPI: Device does not support D3cold
[  102.663039] ACPI: \_SB_.PCI0: No _EJ0 support for device
