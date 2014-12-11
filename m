Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965260AbaLKWH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:07:58 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41140 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934334AbaLKWHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:07:55 -0500
MIME-Version: 1.0
In-Reply-To: <20141211113243.3f21551e@jbarnes-t420>
References: <CAErSpo4iZCUZgqNi-fX+YX=sKV=Ae5z8kn8-++E0Cgft9unmBg@mail.gmail.com>
 <20141211181136.GA11367@kroah.com> <20141211113243.3f21551e@jbarnes-t420>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 11 Dec 2014 15:07:34 -0700
Message-ID: <CAErSpo4V8tYE+yHvQ+Se=tQHWAKafk89SmVTjeCVRzbA-VtQbg@mail.gmail.com>
Subject: Re: Special handling of display/VGA devices in hotplug drivers
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dely Sy <dely.l.sy@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatxjain@gmail.com>, Guenter Roeck <groeck@juniper.net>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Praveen Kalamegham <praveen@nextio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Praveen]

On Thu, Dec 11, 2014 at 12:32 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Thu, 11 Dec 2014 13:11:36 -0500
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
>> On Thu, Dec 11, 2014 at 10:34:30AM -0700, Bjorn Helgaas wrote:
>> > It looks like you added the initial pciehp driver [1], which
>> > includes the following code in pciehp_disable_slot():
>> >
>> > + if (class_code == PCI_BASE_CLASS_DISPLAY) {
>> > + /* Display/Video adapter (not supported) */
>> > + rc = REMOVE_NOT_SUPPORTED;
>> >
>> > + /* If it's a bridge, check the VGA Enable bit */
>> > + if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
>> > + rc = pci_bus_read_config_byte (pci_bus, devfn,
>> > PCI_BRIDGE_CONTROL, &BCR);
>> > + if (rc)
>> > + return rc;
>> > +
>> > + /* If the VGA Enable bit is set, remove isn't supported */
>> > + if (BCR & PCI_BRIDGE_CTL_VGA) {
>> > + rc = REMOVE_NOT_SUPPORTED;
>> >
>> > I'm trying to figure out why VGA devices are handled specially.  I
>> > can't find anything in the PCI specs that mentions this.  Most of
>> > the other PCI hotplug drivers have similar code.  Do you remember
>> > anything about this?
>>
>> The PCI spec said that you were not allowed to hotplug VGA drivers.
>> The big issue is that POST usually needs to run on those things, and
>> there is no way to POST a PCI hotplugged device.

I don't think this is a problem any more, is it?  I think X can
execute option ROMs, and if we assign the guest to a VM, the guest
BIOS can also do it.

> Yeah, the legacy I/O regions get routed through the bridge with the VGA
> bit set, and most legacy code probably can't handle that (whether POST,
> VBIOS, or VGA drivers).
>
> There is some code for moving the VGA routing around, so that might be
> an option if you wanted to remove such a bridge.  You'd have to find a
> VGA device under another bridge, and enable routing to that first, then
> you could do the remove.

The legacy code thing does seem like an issue.  Since ac81860ea073, we
don't actually fail when removing a VGA device; we only fail when
removing a bridge with VGA routing enabled.  Maybe that should be
tweaked so we fail when removing either a bridge or a VGA device to
which the legacy ranges are currently routed.  Then we could still
remove secondary VGA devices like the computational GPUs that
motivated ac81860ea073.

Failing in pciehp_unconfigure_device() makes sense if the user pressed
the attention button to request removal.  But if the bridge was
surprise-removed, e.g., user pulled out an ExpressCard, the bridge is
already gone, and failing just means we can't clean things up, so
we're going to leave drivers bound to the bridge and downstream
devices.

Bjorn
