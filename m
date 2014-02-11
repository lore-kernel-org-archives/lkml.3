Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaBKSRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:17:44 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59895 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaBKSRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:17:42 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Tue, 11 Feb 2014 19:17:37 +0100
Message-ID: <8701691.z6Q6jDD18v@al>
User-Agent: KMail/4.12.2 (Linux/3.13.2-custom; KDE/4.12.2; x86_64; ; )
In-Reply-To: <20140211104237.GE18029@intel.com>
References: <52F2CC7B.80406@gmail.com> <4302366.hs31VgE4VT@vostro.rjw.lan> <20140211104237.GE18029@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 February 2014 12:42:37 Mika Westerberg wrote:
> On Mon, Feb 10, 2014 at 11:39:29PM +0100, Rafael J. Wysocki wrote:
> > > _STA() returns 0x0A instead of 0x0F. Could there be something missing in
> > > the ACPI hotplug code that overlooks this and removes the device on
> > > resume?
> > 
> > That is possible.  Actually even quite likely, but let's wait for the
> > response from Peter.
> 
> Here's a hack that should take the 0xa return value into consideration. It
> turned out that this case is even mentioned in the ACPI spec.

Tested-by: Peter Wu <lekensteyn@gmail.com>

This works, the devices are not lost anymore after resume. dmesg
mentions the 04:00.* devices at resume compared to the unpatched kernel:

[   42.650721] PM: Finishing wakeup.
[   42.650768] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP03
[   42.650772] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP03
[   42.650874] iwlwifi 0000:05:00.0: no hotplug settings from platform
[   42.650722] Restarting tasks ... done.
[   42.650985] video LNXVIDEO:00: Restoring backlight state
[   42.650988] video LNXVIDEO:01: Restoring backlight state
[   43.124208] ACPI: \_SB_.AC__: ACPI_NOTIFY_BUS_CHECK event: unsupported
[   43.128401] jme 0000:04:00.5: irq 50 for MSI/MSI-X
[   43.153005] jme 0000:04:00.5 eth0: Link is down
[   43.153030] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   43.154364] iwlwifi 0000:05:00.0: L1 Enabled; Disabling L0S
[   43.162307] iwlwifi 0000:05:00.0: Radio type=0x1-0x3-0x1
[   43.276220] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP01
[   43.276223] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP01
[   43.276257] xhci_hcd 0000:02:00.0: no hotplug settings from platform
[   43.276267] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP02
[   43.276268] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP02
[   43.276355] sdhci-pci 0000:04:00.0: no hotplug settings from platform
[   43.276368] pci 0000:04:00.2: no hotplug settings from platform
[   43.276381] jmb38x_ms 0000:04:00.3: no hotplug settings from platform
[   43.276393] jme 0000:04:00.5: no hotplug settings from platform
[   43.276398] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP03
[   43.276399] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP03
[   43.276491] iwlwifi 0000:05:00.0: no hotplug settings from platform
[   43.277214] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready

Rafael, do you want me to test the other patch as well?

Peter

> diff --git a/drivers/pci/hotplug/acpiphp_glue.c
> b/drivers/pci/hotplug/acpiphp_glue.c index e2a783fdb98f..014381b42d86
> 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -730,6 +730,17 @@ static unsigned int get_slot_status(struct acpiphp_slot
> *slot) return (unsigned int)sta;
>  }
> 
> +static inline bool device_sta_valid(unsigned long long sta)
> +{
> +	/*
> +	 * ACPI spec says that _STA may return bit 0 clear with bit 8 set
> +	 * if the device is valid but does not require device driver to be
> +	 * loaded (chapter 6.3.7).
> +	 */
> +	unsigned mask = ACPI_STA_DEVICE_ENABLED | ACPI_STA_DEVICE_FUNCTIONING;
> +	return (sta & mask) == mask;
> +}
> +
>  /**
>   * trim_stale_devices - remove PCI devices that are not responding.
>   * @dev: PCI device to start walking the hierarchy from.
> @@ -745,7 +756,7 @@ static void trim_stale_devices(struct pci_dev *dev)
>  		unsigned long long sta;
> 
>  		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
> -		alive = (ACPI_SUCCESS(status) && sta == ACPI_STA_ALL)
> +		alive = (ACPI_SUCCESS(status) && device_sta_valid(sta))
> 
>  			|| acpiphp_no_hotplug(handle);
> 
>  	}
>  	if (!alive) {
> @@ -792,7 +803,7 @@ static void acpiphp_check_bridge(struct acpiphp_bridge
> *bridge) mutex_lock(&slot->crit_sect);
>  		if (slot_no_hotplug(slot)) {
>  			; /* do nothing */
> -		} else if (get_slot_status(slot) == ACPI_STA_ALL) {
> +		} else if (device_sta_valid(get_slot_status(slot))) {
>  			/* remove stale devices if any */
>  			list_for_each_entry_safe_reverse(dev, tmp,
>  							 &bus->devices, bus_list)

