Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbaGCWEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:04:48 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:62951 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaGCWEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:04:46 -0400
MIME-Version: 1.0
In-Reply-To: <7850906.HUE8jaYLrp@harkonnen>
References: <280883016.9onmf0miLq@pcbe13110.cern.ch> <CAErSpo7dyfpcMdCv3QB=PQn3HskcVtdt4MXb8KUMcQC9+N3oBQ@mail.gmail.com>
 <7850906.HUE8jaYLrp@harkonnen>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 3 Jul 2014 16:04:24 -0600
Message-ID: <CAErSpo6Dgwn5QtHwBEcJsY++ZDUu73S6Jm1EVgD0AO-NaN2Wgw@mail.gmail.com>
Subject: Re: PCIe bus enumeration
To: Federico Vaga <federico.vaga@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michel Arruat <michel.arruat@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 2:40 PM, Federico Vaga <federico.vaga@gmail.com> wrote:
> On Thursday 03 July 2014 13:43:14 Bjorn Helgaas wrote:

>> The /sys/bus/pci/slots/*/address files might help.  On my system, I
>> have:
>>
>>   $ grep . /sys/bus/pci/slots/*/address /dev/null
>>   /sys/bus/pci/slots/5/address:0000:03:00
>
> My slots directory is empty on 3.2, 3.6, 3.14. I have to compile the
> kernel with a
> particular configuration? Use a kernel parameter?

Should be built-in, no parameter needed.  I think this is from
pci_create_slot() in drivers/pci/slot.c.  That's called from
register_slot() (drivers/acpi/pci_slot.c, which obviously depends on
the BIOS) and indirectly from pciehp (which doesn't depend on the BIOS
and reads a slot number from the PCIe capability).  "lspci -vv" will
show you this slot number in the SltCap (if the port supports a slot),
e.g.,

  00:1c.3 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root Port 4
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surprise-
                        Slot #3, PowerLimit 10.000W; Interlock- NoCompl+

Since you don't see these, my guess is that your ports don't indicate
that they support a slot, e.g., they might look like this:

  00:1c.3 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root Port 4
        Capabilities: [40] Express (v2) Root Port (Slot-), MSI 00

The "Slot-" means the port doesn't have a slot, and lspci won't show
you the SltCap register, and I think the kernel won't put anything in
/sys/bus/pci/slots.

>> "lspci -v" also shows:
>>
>>   03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
>> Device 5227 (rev 01)
>>         Physical Slot: 5
>
> My lspci hasn't the "Physical Slot" field. However, where does it take
> this information?
> From the BIOS I suppose, a recent BIOS.

>From looking at the lspci source
(git://git.kernel.org/pub/scm/utils/pciutils/pciutils.git), it looks
like that "Physical Slot" comes from /sys/bus/pci/slots/..., so if you
don't have anything there, you won't see "Physical Slot".

>> I don't think the behavior should be different on PCIe, but maybe if
>> you have an example, it will help me figure out why it is
>> different.  My current machine has three Root Ports (which are
>> treated as PCI-to-PCI bridges), and they all have secondary bus
>> numbers assigned, even though only two have devices below them:
>>
>>            +-1c.0-[01]--
>>            +-1c.3-[02]----00.0
>>            +-1c.5-[03]----00.0
>
> What I observed is that when several PCIe slot belong to a single PCI
> Bridge, and you
> plug a board in one on these, then it enumerates all secondary buses,
> also the
> empty ones (like your case, all your slot belong to device 1c).
>
> But, if you un-plug the devices on secondary bus 02 and 03, you should
> not see the
> device 1c anymore. This is what is happening with my machine
> [industrial backplane
> with several PCI(e) slots and the motherboard plugged in a special
> slot.].

I think there's something unusual going on with your machine.  I can't
remove the devices on my machine (a laptop), but normally the Root
Ports or Downstream Ports leading to the slots continue to exist even
if the slots are empty.  In your case, it sounds like there's some
hardware that is turning off power to those ports when the slots are
all empty.

I assume these ports don't support hotplug.  If they *did* support
hotplug, those ports would have to exist because they handle the
hotplug events (presence detect, etc.)

If you can collect the complete "lspci -vv" output from your machine
(with a device plugged in, so we can see the port leading to it), that
will help make this more concrete.  And maybe one with no devices
plugged in, so we can see exactly what changes.

Bjorn
