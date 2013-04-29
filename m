Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3D2QUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:20:07 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65356 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab3D2QUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:20:05 -0400
Message-ID: <517E9DAC.7030709@gmail.com>
Date: Tue, 30 Apr 2013 00:19:56 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jiang Liu <jiang.liu@huawei.com>, Gavin Guo <tuffkidtt@gmail.com>,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3] PCI, ACPI, hotplug: Fix BUS_CHECK event handle on
 root bridge
References: <1366940798-15268-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1366940798-15268-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,
	Reviewed-by: Jiang Liu <jiang.liu@huawei.com>
	Thanks!

On 04/26/2013 09:46 AM, Yinghai Lu wrote:
> Gavin found that acpiphp does not handle hotplug anymore even after
> now we have acpiphp built-in preparing for v3.10.
> 
> Bjorn analyzed bootlog, he found that 
>     acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>     ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
>     \_SB_.PCI0:_OSC invalid UUID
>     acpiphp: Slot [1] registered
>     acpiphp: Slot [1-1] registered
>    acpi root: \_SB_.PCI0 notify handler is installed
>     _handle_hotplug_event_root: Bus check notify on \_SB_.PCI0
>     _handle_hotplug_event_root: Bus check notify on \_SB_.PCI0
> And that means:
>    So we should be using acpiphp, which you do have built in statically,
>    and it found a couple slots.  And we did get two bus check notifies on
>    \_SB_.PCI0, so we *should* be re-enumerating PCI bus 0000:00.  But it
>    looks like we're handling this as a host bridge hotplug event instead
>    of a PCI device hotplug.  My guess is that
>    handle_root_bridge_insertion() does nothing because the PCI0 ACPI
>    device already exists, though I would expect to see the "acpi device
>    exists..." in your dmesg log if this were the case.
> 
> Also according to Rafael and Bjorn, it is perfect fine that we
> should enumerate bus by sending event to root bridge after hotadd
> device to slots under that root bridge or children bridges.
> 
> It turns out that it is regression caused by
> | commit 668192b678201d2fff27c6cc76bb003c1ec4a52a
> | Author: Yinghai Lu <yinghai@kernel.org>
> | Date:   Mon Jan 21 13:20:48 2013 -0800
> |
> |    PCI: acpiphp: Move host bridge hotplug to pci_root.c
> 
> We should check slots when BUS_CHECK is sent to root bridge acpi handle.
> 
> Restore the old behavoir by calling acpi_check_bridge and check_sub_bridge
> in acpiphp.
> 
> Jiang Liu acctually have simimar patch but it forgets calling
> acpi_check_bridge() for system that have slots on root bus directly.
> That is still valid, as in QEMU we still have that slots on bus 0 at
> least. But my first version patch wrongly check if root bridge exists
> before check_sub_bridge for children bridges. 
> 
> -v2: Don't check bridge for acpi_walk_namespace with check_sub_bridges.
>      also put back bridge reference.
> -v3: More changelog and etc.
> 
> Reported-by: Gavin Guo <tuffkidtt@gmail.com>
> Tested-by: Gavin Guo <tuffkidtt@gmail.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/acpi/pci_root.c            |    2 ++
>  drivers/pci/hotplug/acpiphp_glue.c |   14 ++++++++++++++
>  include/linux/pci-acpi.h           |    2 ++
>  3 files changed, 18 insertions(+)
> 
> Index: linux-2.6/drivers/acpi/pci_root.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/pci_root.c
> +++ linux-2.6/drivers/acpi/pci_root.c
> @@ -643,6 +643,8 @@ static void _handle_hotplug_event_root(s
>  				 (char *)buffer.pointer);
>  		if (!root)
>  			handle_root_bridge_insertion(handle);
> +		else
> +			acpiphp_check_host_bridge(handle);
>  
>  		break;
>  
> Index: linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
> @@ -950,6 +950,20 @@ check_sub_bridges(acpi_handle handle, u3
>  	return AE_OK ;
>  }
>  
> +void acpiphp_check_host_bridge(acpi_handle handle)
> +{
> +	struct acpiphp_bridge *bridge;
> +
> +	bridge = acpiphp_handle_to_bridge(handle);
> +	if (bridge) {
> +		acpiphp_check_bridge(bridge);
> +		put_bridge(bridge);
> +	}
> +
> +	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
> +		ACPI_UINT32_MAX, check_sub_bridges, NULL, NULL, NULL);
> +}
> +
>  static void _handle_hotplug_event_bridge(struct work_struct *work)
>  {
>  	struct acpiphp_bridge *bridge;
> Index: linux-2.6/include/linux/pci-acpi.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pci-acpi.h
> +++ linux-2.6/include/linux/pci-acpi.h
> @@ -60,11 +60,13 @@ static inline void acpi_pci_slot_remove(
>  void acpiphp_init(void);
>  void acpiphp_enumerate_slots(struct pci_bus *bus, acpi_handle handle);
>  void acpiphp_remove_slots(struct pci_bus *bus);
> +void acpiphp_check_host_bridge(acpi_handle handle);
>  #else
>  static inline void acpiphp_init(void) { }
>  static inline void acpiphp_enumerate_slots(struct pci_bus *bus,
>  					   acpi_handle handle) { }
>  static inline void acpiphp_remove_slots(struct pci_bus *bus) { }
> +static inline void acpiphp_check_host_bridge(acpi_handle handle) { }
>  #endif
>  
>  #else	/* CONFIG_ACPI */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

