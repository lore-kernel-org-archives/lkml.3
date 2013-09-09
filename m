Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3IITv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:51:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39653 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab3IITvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:51:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] ACPI / hotplug / PCI: Avoid parent bus rescans on spurious device checks
Date: Mon, 09 Sep 2013 22:02:24 +0200
Message-ID: <2468067.2gxWP8bzg4@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1378744377.2631.82.camel@ul30vt.home>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <2762291.l6lVgcWD3r@vostro.rjw.lan> <1378744377.2631.82.camel@ul30vt.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 09, 2013 10:32:57 AM Alex Williamson wrote:
> On Sun, 2013-09-08 at 00:16 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > In the current ACPIPHP notify handler we always go directly for a
> > rescan of the parent bus if we get a device check notification for
> > a device that is not a bridge.  However, this obviously is
> > overzealous if nothing really changes, because this way we may rescan
> > the whole PCI hierarchy pretty much in vain.
> > 
> > That happens on Alex Williamson's machine whose ACPI tables contain
> > device objects that are supposed to coresspond to PCIe root ports,
> > but those ports aren't physically present (or at least they aren't
> > visible in the PCI config space to us).  The BIOS generates multiple
> > device check notifies for those objects during boot and for each of
> > them we go straight for the parent bus rescan, but the parent bus is
> > the root bus in this particular case.  In consequence, we rescan the
> > whole PCI bus from the top several times in a row, which is
> > completely unnecessary, increases boot time by 50% (after previous
> > fixes) and generates excess dmesg output from the PCI subsystem.
> > 
> > Fix the problem by checking if we can find anything new in the
> > slot corresponding to the device we've got a device check notify
> > for and doing nothig if that's not the case.
> > 
> > The spec (ACPI 5.0, Section 5.6.6) appears to mandate this behavior,
> > as it says:
> > 
> >   Device Check. Used to notify OSPM that the device either appeared
> >   or disappeared. If the device has appeared, OSPM will re-enumerate
> >   from the parent. If the device has disappeared, OSPM will
> >   invalidate the state of the device. OSPM may optimize out
> >   re-enumeration.
> > 
> > Therefore, according to the spec, we are free to do nothing if
> > nothing changes.
> > 
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=60865
> > Reported-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> 
> Works for me.  Thanks!
> 
> Tested-by: Alex Williamson <alex.williamson@redhat.com>

Great, thanks for testing.


> > ---
> >  drivers/pci/hotplug/acpiphp_glue.c |   32 +++++++++++++++++++++++++-------
> >  1 file changed, 25 insertions(+), 7 deletions(-)
> > 
> > Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> > ===================================================================
> > --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> > +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> > @@ -528,6 +528,16 @@ static void check_hotplug_bridge(struct
> >  	}
> >  }
> >  
> > +static int acpiphp_rescan_slot(struct acpiphp_slot *slot)
> > +{
> > +	struct acpiphp_func *func;
> > +
> > +	list_for_each_entry(func, &slot->funcs, sibling)
> > +		acpiphp_bus_add(func_to_handle(func));
> > +
> > +	return pci_scan_slot(slot->bus, PCI_DEVFN(slot->device, 0));
> > +}
> > +
> >  /**
> >   * enable_slot - enable, configure a slot
> >   * @slot: slot to be enabled
> > @@ -544,10 +554,7 @@ static void __ref enable_slot(struct acp
> >  	LIST_HEAD(add_list);
> >  	int nr_found;
> >  
> > -	list_for_each_entry(func, &slot->funcs, sibling)
> > -		acpiphp_bus_add(func_to_handle(func));
> > -
> > -	nr_found = pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
> > +	nr_found = acpiphp_rescan_slot(slot);
> >  	max = acpiphp_max_busnr(bus);
> >  	for (pass = 0; pass < 2; pass++) {
> >  		list_for_each_entry(dev, &bus->devices, bus_list) {
> > @@ -840,11 +847,22 @@ static void hotplug_event(acpi_handle ha
> >  	case ACPI_NOTIFY_DEVICE_CHECK:
> >  		/* device check */
> >  		dbg("%s: Device check notify on %s\n", __func__, objname);
> > -		if (bridge)
> > +		if (bridge) {
> >  			acpiphp_check_bridge(bridge);
> > -		else
> > -			acpiphp_check_bridge(func->parent);
> > +		} else {
> > +			struct acpiphp_slot *slot = func->slot;
> > +			int ret;
> >  
> > +			/*
> > +			 * Check if anything has changed in the slot and rescan
> > +			 * from the parent if that's the case.
> > +			 */
> > +			mutex_lock(&slot->crit_sect);
> > +			ret = acpiphp_rescan_slot(slot);
> > +			mutex_unlock(&slot->crit_sect);
> > +			if (ret)
> > +				acpiphp_check_bridge(func->parent);
> > +		}
> >  		break;
> >  
> >  	case ACPI_NOTIFY_EJECT_REQUEST:
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
