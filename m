Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBJWZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:25:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65262 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750890AbaBJWY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:24:59 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Peter Wu <lekensteyn@gmail.com>,
        Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Mon, 10 Feb 2014 23:39:29 +0100
Message-ID: <4302366.hs31VgE4VT@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140210122035.GY18029@intel.com>
References: <52F2CC7B.80406@gmail.com> <1747020.MhBDqPO9oJ@vostro.rjw.lan> <20140210122035.GY18029@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 10, 2014 02:20:35 PM Mika Westerberg wrote:
> On Mon, Feb 10, 2014 at 01:10:19PM +0100, Rafael J. Wysocki wrote:
> > On Monday, February 10, 2014 02:15:22 AM Peter Wu wrote:
> > > On Monday 10 February 2014 01:52:14 Rafael J. Wysocki wrote:
> > > > > Could the following commit have something to do with it?
> > > > >
> > > > > 
> > > > >
> > > > > commit 4ebe34503baa0644c9352bcd76d4cf573bffe206
> > > > > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > Date:   Tue Jul 16 22:10:35 2013 +0200
> > > > >
> > > > > 
> > > > >     ACPI / hotplug / PCI: Check for new devices on enabled slots
> > > > 
> > > > This one, or another one in that series.  I rather suspect
> > > > 
> > > > ab1225901da2 Revert "ACPI / hotplug / PCI: Avoid doing too much for spurious
> > > > notifies"
> > > > 
> > > > from Mika, but it really doesn't matter.
> > > > 
> > > > Can you please check the patch below (it is on top of 3.14-rc1, but I think
> > > > it'll still apply to 3.13) and report back?
> > > 
> > > I applied the following patch:
> > > 
> > > --- drivers/pci/hotplug/acpiphp_glue.c.orig	2014-02-10 01:46:59.678124018 +0100
> > > +++ drivers/pci/hotplug/acpiphp_glue.c	2014-02-10 01:48:59.634124004 +0100
> > > @@ -552,10 +552,10 @@
> > >  	struct pci_dev *dev;
> > >  	struct pci_bus *bus = slot->bus;
> > >  	struct acpiphp_func *func;
> > > -	int max, pass;
> > > +	int nr_found, max, pass, bridges_scanned = 0;
> > >  	LIST_HEAD(add_list);
> > >  
> > > -	acpiphp_rescan_slot(slot);
> > > +	nr_found = acpiphp_rescan_slot(slot);
> > >  	max = acpiphp_max_busnr(bus);
> > >  	for (pass = 0; pass < 2; pass++) {
> > >  		list_for_each_entry(dev, &bus->devices, bus_list) {
> > > @@ -571,9 +571,16 @@
> > >  					__pci_bus_size_bridges(dev->subordinate,
> > >  							       &add_list);
> > >  				}
> > > +				bridges_scanned++;
> > >  			}
> > >  		}
> > >  	}
> > > +	/* Nothing more to do here if there are no new devices on this bus. */
> > > +	if (!nr_found && !bridges_scanned && (slot->flags & SLOT_ENABLED)) {
> > > +		pr_debug("No more new devices on this bus.\n");
> > > +		return;
> > > +	}
> > > +
> > >  	__pci_bus_assign_resources(bus, &add_list, NULL);
> > >  
> > >  	acpiphp_sanitize_bus(bus);
> > > 
> > > Unfortunately, the adapter still vanishes. dmesg is below this message.
> > > 
> > > Peter
> > > 
> > > [   44.558995] CPU3 is up
> > > [   44.561438] ACPI: Waking up from system sleep state S3
> > > [   45.254084] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
> > > [   45.280727] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
> > > [   45.307403] xhci_hcd 0000:02:00.0: System wakeup disabled by ACPI
> > > [   45.361012] PM: noirq resume of devices complete after 133.354 msecs
> > > [   45.361292] PM: early resume of devices complete after 0.233 msecs
> > > [   45.361680] iwlwifi 0000:05:00.0: RF_KILL bit toggled to enable radio.
> > > [   45.361731] pcieport 0000:00:1c.1: System wakeup disabled by ACPI
> > > [   45.470912] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
> > > [   45.700502] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > > [   45.700533] ata5: SATA link down (SStatus 0 SControl 300)
> > > [   45.701385] ata1.00: configured for UDMA/133
> > > [   45.701503] sd 0:0:0:0: [sda] Starting disk
> > > [   45.707139] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > > [   45.872011] ata2.00: configured for UDMA/100
> > > [   46.791141] PM: resume of devices complete after 1430.658 msecs
> > > [   46.791560] PM: Finishing wakeup.
> > > [   46.791565] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP03
> > > [   46.791568] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP03
> > > [   46.791642] acpiphp_glue: No more new devices on this bus.
> > > [   46.791571] Restarting tasks ... done.
> > > [   46.793204] video LNXVIDEO:00: Restoring backlight state
> > > [   46.793211] video LNXVIDEO:01: Restoring backlight state
> > > [   47.246425] ACPI: \_SB_.AC__: ACPI_NOTIFY_BUS_CHECK event: unsupported
> > > [   47.251540] jme 0000:04:00.5: irq 50 for MSI/MSI-X
> > > [   47.276949] jme 0000:04:00.5 eth0: Link is down
> > 
> > I'm wondering why these two messages are printed here.
> > 
> > > [   47.276974] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> > > [   47.278423] iwlwifi 0000:05:00.0: L1 Enabled; Disabling L0S
> > > [   47.285758] iwlwifi 0000:05:00.0: Radio type=0x1-0x3-0x1
> > > [   47.393492] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP01
> > > [   47.393495] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP01
> > > [   47.393517] acpiphp_glue: No more new devices on this bus.
> > > [   47.393525] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP02
> > > [   47.393527] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP02
> > 
> > Anyway, the message you've added to the patch is not printed for this bridge,
> > so the condition is not satified for its bus.  We need to find out why it isn't
> > satisfied and what exactly happens to the devices that appear to go away.
> 
> One thing, I noticed when checking the DSDT:
> 
> 	Device (J380)
> 	{
> 		Method (_STA, 0, NotSerialized)  // _STA: Status
> 		{
> 			If (LNotEqual (DVID, 0xFFFFFFFF))
> 			{
> 				Return (0x0A)
> 			}
> 			Else
> 			{
> 				Return (Zero)
> 			}
> 		}
> 
> _STA() returns 0x0A instead of 0x0F. Could there be something missing in
> the ACPI hotplug code that overlooks this and removes the device on resume?

That is possible.  Actually even quite likely, but let's wait for the response
from Peter.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
