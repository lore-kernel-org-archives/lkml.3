Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab3IETdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:33:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33564 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756895Ab3IETdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:33:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Excess dmesg output from ACPIPHP on boot (was: Re: [PATCH 25/30] ACPI / hotplug / PCI: Check for new devices on enabled slots)
Date: Thu, 05 Sep 2013 21:44:26 +0200
Message-ID: <1535359.s5bUZnSMNz@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1378390901.3246.233.camel@ul30vt.home>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <1378387184.3246.227.camel@ul30vt.home> <1378390901.3246.233.camel@ul30vt.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 05, 2013 08:21:41 AM Alex Williamson wrote:
> On Thu, 2013-09-05 at 07:19 -0600, Alex Williamson wrote:
> > On Thu, 2013-09-05 at 13:54 +0200, Rafael J. Wysocki wrote:
> > > On Wednesday, September 04, 2013 10:06:02 PM Alex Williamson wrote:
> > > > On Wed, 2013-09-04 at 21:37 -0600, Alex Williamson wrote:
> > > > > On Thu, 2013-09-05 at 01:35 +0200, Rafael J. Wysocki wrote:
> > > > > > On Wednesday, September 04, 2013 05:12:14 PM Alex Williamson wrote:
> > > > > > > On Thu, 2013-09-05 at 00:54 +0200, Rafael J. Wysocki wrote:
> > > > > > > > On Wednesday, September 04, 2013 02:36:34 PM Alex Williamson wrote:
> > > > > > > > > On Thu, 2013-07-18 at 01:32 +0200, Rafael J. Wysocki wrote:
> > > > > > > > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > > > > > 
> > > > > > > > > > The current implementation of acpiphp_check_bridge() is pretty dumb:
> > > > > > > > > >  - It enables a slot if it's not enabled and the slot status is
> > > > > > > > > >    ACPI_STA_ALL.
> > > > > > > > > >  - It disables a slot if it's enabled and the slot status is not
> > > > > > > > > >    ACPI_STA_ALL.
> > > > > > > > > > 
> > > > > > > > > > This behavior is not sufficient to handle the Thunderbolt daisy
> > > > > > > > > > chaining case properly, however, because in that case the bus
> > > > > > > > > > behind the already enabled slot needs to be rescanned for new
> > > > > > > > > > devices.
> > > > > > > > > > 
> > > > > > > > > > For this reason, modify acpiphp_check_bridge() so that slots are
> > > > > > > > > > disabled and stopped if they are not in the ACPI_STA_ALL state.
> > > > > > > > > > 
> > > > > > > > > > For slots in the ACPI_STA_ALL state, devices behind them that don't
> > > > > > > > > > respond are trimmed using a new function, trim_stale_devices(),
> > > > > > > > > > introduced specifically for this purpose.  That function walks
> > > > > > > > > > the given bus and checks each device on it.  If the device doesn't
> > > > > > > > > > respond, it is assumed to be gone and is removed.
> > > > > > > > > > 
> > > > > > > > > > Once all of the stale devices directy behind the slot have been
> > > > > > > > > > removed, acpiphp_check_bridge() will start looking for new devices
> > > > > > > > > > that might have appeared on the given bus.  It will do that even if
> > > > > > > > > > the slot is already enabled (SLOT_ENABLED is set for it).
> > > > > > > > > > 
> > > > > > > > > > In addition to that, make the bus check notification ignore
> > > > > > > > > > SLOT_ENABLED and go for enable_device() directly if bridge is NULL,
> > > > > > > > > > so that devices behind the slot are re-enumerated in that case too.
> > > > > > > > > > 
> > > > > > > > > > This change is based on earlier patches from Kirill A Shutemov
> > > > > > > > > > and Mika Westerberg.
> > > > > > > > > > 
> > > > > > > > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > > > > > Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > > > > > > > > ---
> > > > > > > > > 
> > > > > > > > > FYI, git bisect landed on this patch as the cause of my serial console
> > > > > > > > > dying on current upstream.  Further debugging to come...  Thanks,
> > > > > > > > 
> > > > > > > > Well, sorry about that.
> > > > > > > > 
> > > > > > > > What exactly do you mean by "dying"?
> > > > > > > 
> > > > > > > Sorry, I was hoping to have more details quickly, but it's been a pain
> > > > > > > to debug.  By dying I mean serial console output suddenly stops during
> > > > > > > kernel boot and nothing more comes out of it until after the system is
> > > > > > > rebooted.  The problem happens when acpiphp_check_bridge() calls
> > > > > > > enable_slot().  The serial console dies somewhere down in
> > > > > > > acpiphp_bus_trim().  I think this is happening on the 00:1f ISA bridge,
> > > > > > > so there's a good chance the serial ports are described as somewhere
> > > > > > > under there.
> > > > > > 
> > > > > > Can you please check if that is the acpiphp_bus_trim() called by
> > > > > > acpiphp_bus_add() or the other one called from trim_stale_devices()?
> > > > > > 
> > > > > > Just add a dump_stack() or WARN_ON(1) to trim_stale_devices() next to
> > > > > > the acpiphp_bus_trim() call and see if that triggers.  I *think* it's the one
> > > > > > in acpiphp_bus_add(), but it won't hurt to verify that.
> > > > > 
> > > > > Here's the call path:
> > > > > 
> > > > > [   16.120824]  [<ffffffff81627e6c>] dump_stack+0x55/0x76
> > > > > [   16.125979]  [<ffffffff8162132e>] enable_slot+0x4ee/0x5e0
> > > > > [   16.131396]  [<ffffffff813418fb>] ? trim_stale_devices+0x5b/0xf0
> > > > > [   16.137420]  [<ffffffff81341b35>] acpiphp_check_bridge+0xd5/0x110
> > > > > [   16.143531]  [<ffffffff81342acb>] hotplug_event+0x16b/0x260
> > > > > [   16.149115]  [<ffffffff81072cd9>] ? process_one_work+0x189/0x540
> > > > > [   16.155136]  [<ffffffff81342bf0>] hotplug_event_work+0x30/0x70
> > > > > [   16.160978]  [<ffffffff81072d3b>] process_one_work+0x1eb/0x540
> > > > > [   16.166819]  [<ffffffff81072cd9>] ? process_one_work+0x189/0x540
> > > > > [   16.172836]  [<ffffffff8107353c>] worker_thread+0x11c/0x370
> > > > > [   16.178426]  [<ffffffff81073420>] ? rescuer_thread+0x350/0x350
> > > > > [   16.184276]  [<ffffffff8107b0ea>] kthread+0xea/0xf0
> > > > > [   16.189165]  [<ffffffff8107b000>] ? kthread_create_on_node+0x160/0x160
> > > > > [   16.195700]  [<ffffffff816395dc>] ret_from_fork+0x7c/0xb0
> > > > > [   16.201109]  [<ffffffff8107b000>] ? kthread_create_on_node+0x160/0x160
> > > > > 
> > > > > The actual death of the serial console occurs in acpi_device_set_power()
> > > > > called from:
> > > > > 
> > > > > enable_slot()
> > > > >  acpiphp_bus_add()
> > > > >   acpiphp_bus_trim()
> > > > >    acpi_bus_trim()
> > > > >     acpi_walk_namespace()
> > > > >      acpi_bus_remove()
> > > > >       acpi_device_unregister()
> > > > >        acpi_device_set_power()
> > > > > 
> > > > > I can't seem to get a path from the acpi devices in question there, so I
> > > > > have no idea what's getting trimmed here.  It worries me quite a bit by
> > > > > introducing this trimming that apparently wasn't happening before
> > > > > though.  Thanks,
> > > > 
> > > > As suspected, the pnp.bus_id/id of the last device before the serial
> > > > console dies is COM1/PNP0501.  I also see all of these being trimmed
> > > > out:
> > > > 
> > > >  MBRD/PNP0C02
> > > >  DMAC/PNP0200
> > > >  MATH/PNP0C04
> > > >  PIC/PNP0000
> > > >  HPET/PNP0103
> > > >  RTC/PNP0B00
> > > >  SPKR/PNP0800
> > > >  TIME/PNP0100
> > > >  LNK{A-H}/PNP0C0F
> > > > 
> > > > This seems like a bad idea.  I forgot to mention, the original
> > > > hotplug_event is called with a device check on \_SB_.PCI0.PEX2.  The box
> > > > where I'm seeing this is a pretty generic X58 based Nehalem workstation
> > > > (Lenovo S20).
> > > 
> > > Thanks for the info!
> > > 
> > > The acpiphp_bus_trim() in acpiphp_bus_add() is a leftover and a bad one.
> > > I don't think it's actually necessary, at least Thunderbolt works without
> > > it just fine on my Aspire S5.
> > > 
> > > The patch below should help, can you please test it?
> > > 
> > > Rafael
> > > 
> > > ---
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Subject: ACPI / hotplug / PCI: Don't trim devices before scanning the namespace
> > > 
> > > In acpiphp_bus_add() we first remove device objects corresponding to
> > > the given handle and the ACPI namespace branch below it which are
> > > then re-created by acpi_bus_scan().  This used to be done to clean
> > > up after surprise removals, but now we do the cleanup through
> > > trim_stale_devices() which checks if the devices in question are
> > > actually gone before removing them, so the device hierarchy trimming
> > > in acpiphp_bus_add() is not necessary any more and, moreover, it may
> > > lead to problems if it removes device objects corresponding to
> > > devices that are actually present.
> > > 
> > > Reported-by: Alex Williamson <alex.williamson@redhat.com>
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  drivers/pci/hotplug/acpiphp_glue.c |    1 -
> > >  1 file changed, 1 deletion(-)
> > > 
> > > Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> > > ===================================================================
> > > --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> > > +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> > > @@ -487,7 +487,6 @@ static void acpiphp_bus_add(acpi_handle
> > >  {
> > >  	struct acpi_device *adev = NULL;
> > >  
> > > -	acpiphp_bus_trim(handle);
> > >  	acpi_bus_scan(handle);
> > >  	acpi_bus_get_device(handle, &adev);
> > >  	if (adev)
> > > 
> > > 
> > 
> > It boots again and the console works,

OK, so I'll queue up the patch above as a 3.12 fix and let's regard the
dying serial console problem as fixed.

Now ->

> > but I see screens and screens of messages like this:

-> this is a separate issue that we need to take care of (so I've changed the
subject to reflect that).

> > 
> > [   18.288122] pci 0000:00:00.0: no hotplug settings from platform
> > [   18.288127] pcieport 0000:00:01.0: no hotplug settings from platform
> > [   18.288142] pci 0000:01:00.0: no hotplug settings from platform
> > [   18.288157] pci 0000:01:00.1: no hotplug settings from platform
> > [   18.288162] pcieport 0000:00:03.0: no hotplug settings from platform
> > [   18.288176] pci 0000:02:00.0: no hotplug settings from platform
> > [   18.288190] pci 0000:02:00.1: no hotplug settings from platform
> > [   18.288195] pcieport 0000:00:07.0: no hotplug settings from platform
> > [   18.288209] pci 0000:03:00.0: no hotplug settings from platform
> > [   18.288224] pci 0000:03:00.1: no hotplug settings from platform
> > [   18.288228] pci 0000:00:14.0: no hotplug settings from platform
> > [   18.288233] pci 0000:00:14.1: no hotplug settings from platform
> > [   18.288237] pci 0000:00:14.2: no hotplug settings from platform
> > [   18.288242] pci 0000:00:16.0: no hotplug settings from platform
> > [   18.288247] pci 0000:00:16.1: no hotplug settings from platform
> > [   18.288251] pci 0000:00:16.2: no hotplug settings from platform
> > [   18.288256] pci 0000:00:16.3: no hotplug settings from platform
> > [   18.288260] pci 0000:00:16.4: no hotplug settings from platform
> > [   18.288265] pci 0000:00:16.5: no hotplug settings from platform
> > [   18.288269] pci 0000:00:16.6: no hotplug settings from platform
> > [   18.288274] pci 0000:00:16.7: no hotplug settings from platform
> > [   18.288278] pci 0000:00:1a.0: no hotplug settings from platform
> > [   18.288279] pci 0000:00:1a.0: using default PCI settings
> > [   18.288292] pci 0000:00:1a.1: no hotplug settings from platform
> > [   18.288293] pci 0000:00:1a.1: using default PCI settings
> > [   18.288307] ehci-pci 0000:00:1a.7: no hotplug settings from platform
> > [   18.288308] ehci-pci 0000:00:1a.7: using default PCI settings
> > [   18.288322] pci 0000:00:1b.0: no hotplug settings from platform
> > [   18.288327] pcieport 0000:00:1c.0: no hotplug settings from platform
> > [   18.288332] pcieport 0000:00:1c.4: no hotplug settings from platform
> > [   18.288344] pci 0000:05:00.0: no hotplug settings from platform
> > [   18.288349] pci 0000:00:1d.0: no hotplug settings from platform
> > [   18.288350] pci 0000:00:1d.0: using default PCI settings
> > [   18.288360] pci 0000:00:1d.1: no hotplug settings from platform
> > [   18.288361] pci 0000:00:1d.1: using default PCI settings
> > [   18.288374] pci 0000:00:1d.2: no hotplug settings from platform
> > [   18.288374] pci 0000:00:1d.2: using default PCI settings
> > [   18.288387] pci 0000:00:1d.3: no hotplug settings from platform
> > [   18.288387] pci 0000:00:1d.3: using default PCI settings
> > 
> > The boot is noticeably slower.  What's going to happen on systems that
> > actually have a significant I/O topology vs my little workstation?

That depends on how many bus check/device check events they generate on boot.

My test machines don't generate them during boot at all (even the one with
a Thunderbolt connector), so I don't see the messages in question during boot
on any of them.  Mika doesn't see them either I suppose, or he would have told
me about that before.

And let's just make it clear that it is not usual or even OK to generate bus
checks or device checks during boot like this.  And since the changes in
question have been in linux-next since right after the 3.11 merge window, I
think that someone would have complained already had that been a common issue.

Of course, we need to deal with that somehow nevertheless. :-)

> Just to give you an idea:
> 
> CONFIG_HOTPLUG_PCI_ACPI=y
> 
> $ dmesg | wc
>   5697  49935 384368
> 
> $ dmesg | tail --lines=1
> [   53.137123] Ebtables v2.0 registered
> 
> -- vs --
> 
> # CONFIG_HOTPLUG_PCI_ACPI is not set
> 
> $ dmesg | wc
>  1053  9176 71652
> 
> $dmesg | tail --lines=1
> [   28.917220] Ebtables v2.0 registered
> 
> So it spews out 5x more output with acpiphp enabled and takes and extra
> 24s to boot (nearly 2x).  Not good.

The "no hotplug settings from platform" message is from pci_configure_slot().
I think the messages you're seeing are from the call to it in
acpiphp_set_hpp_values() which is called by enable_slot().

There, I think, we can simply check the return value of pci_scan_slot() and
if that is 0 (no new devices), we can just skip everything under the call to
__pci_bus_assign_resources().

However, we can't skip the scanning of bridges, if any, because there may be
new devices below them and I guess that's what takes so much time on your
machine.

Thanks,
Rafael

