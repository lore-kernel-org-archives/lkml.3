Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaFXVQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:16:45 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:50041 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaFXVQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:16:43 -0400
MIME-Version: 1.0
In-Reply-To: <aa91dac8e0f4416bb5f8b901b4da8f22@DM2PR05MB671.namprd05.prod.outlook.com>
References: <20140617192734.30783.71260.stgit@amt.stowe> <CAErSpo7t2kXj2ZULLXCJSWb_awS+DCtCg51dnLbb8ztWmQdYog@mail.gmail.com>
 <53A0C763.7080003@roeck-us.net> <aa91dac8e0f4416bb5f8b901b4da8f22@DM2PR05MB671.namprd05.prod.outlook.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 24 Jun 2014 15:16:22 -0600
Message-ID: <CAErSpo4xWtBtL6a-vNh_s+MRHNVa6iEe3g8ZcgFPyHHD0ZrM9g@mail.gmail.com>
Subject: Re: [PATCH] PCI: pciehp: Include the Data Link Layer State Changed
 bit when clearing the Slot Status register's event bits
To: Rajat Jain <rajatjain@juniper.net>
Cc: Guenter Roeck <linux@roeck-us.net>, Myron Stowe <myron.stowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 2:34 PM, Rajat Jain <rajatjain@juniper.net> wrote:
> Hello,
>
> Sorry, I missed this email.
>
> Please see below.
>
>> -----Original Message-----
>> From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-
>> owner@vger.kernel.org] On Behalf Of Guenter Roeck
>> Sent: Tuesday, June 17, 2014 3:56 PM
>> To: Bjorn Helgaas; Myron Stowe
>> Cc: linux-pci@vger.kernel.org; Kenji Kaneshige; linux-
>> kernel@vger.kernel.org; Rajat Jain
>> Subject: Re: [PATCH] PCI: pciehp: Include the Data Link Layer State Changed
>> bit when clearing the Slot Status register's event bits
>>
>> On 06/17/2014 02:07 PM, Bjorn Helgaas wrote:
>> > On Tue, Jun 17, 2014 at 1:27 PM, Myron Stowe
>> <myron.stowe@redhat.com> wrote:
>> >> During PCIe hot-plug initialization - pciehp_probe - data structures
>> >> related to slot capabilities are set up.  As part of this set up,
>> >> ISRs are put in place to handle slot events and all event bits are cleared
>> out.
>> >>
>> >> This patch adds the Data Link Layer State Changed
>> >> (PCI_EXP_SLTSTA_DLLSC) Slot Status bit to the event bits that are
>> >> cleared out during initialization.
>> >
>> > I think this is related to e48f1b67f668 ("PCI: pciehp: Use link change
>> > notifications for hot-plug and removal").  Prior to that, pcie_isr()
>> > didn't look at the PCI_EXP_SLTSTA_DLLSC bit.
>> >
>> > Apparently there's a non-public report of spurious messages like this
>> > at boot-time, with no actual hotplug events:
>> >
>> >    pciehp 0000:82:04.0:pcie24: slot(4): Link Up event
>> >    pciehp 0000:82:04.0:pcie24: Device 0000:83:00.0 already exists at
>> > 0000:83:00, cannot hot-add
>> >    pciehp 0000:82:04.0:pcie24: Cannot add device at 0000:83:00
>> >
>>
>> I think I have seen that message once in a while in our systems.
>> Rajat, didn't we talk about this a while ago ?
>
> Essentially my hiccup was that I was not sure whether the driver should or should not take care of the link change events that have happened BEFORE the driver gets loaded. This has more impact if the pciehp is built as a kernel module.
>
> As an example:
>
> It is common for the platform init code built into the kernel, to take the PCI devices on the board out of reset. And that can happen after the PCI enumeration but before the pciehp driver gets loaded. Thus in this condition, with this patch, the pciehp will ignore the linkup event, thus device will not be visible. The only way (other than a rescan) to do hot-add the device would be to apply-and-remove-reset-signal to the device again. At which point pciehp may give a warning about about an attempt to remove a non-existent card, and then will proceed fine with hot-add.

When you saw these problems, was pciehp a module?  We changed it
(c10cc483bf3f in v3.11) so it can't be a module any more, but if there
can still be a significant window between enumeration and pciehp init,
I'd like to understand more about it.

> The patch looks good, only wanted to make sure that we understand and agree that the pciehp should NOT process and link events that have happened before the pciehp was loaded.

Currently (before this patch), we clear the Attention Button Pressed,
Power Fault Detected, MRL Sensor Changed, Presence Detect Changed, and
Command Completed bits, but we *don't* clear Data Link Layer State
Changed.

That asymmetry seems hard to justify.  For example, if a card were
inserted after enumeration but before pciehp is initialized, we'd miss
the PDC indication, so I think we would fail to notice the new device.
That seems basically the same as missing the linkup event in your
example.  In both cases, I think we *should* notice the new device, so
the fact that we don't is a problem.

But since pciehp can't be a module any more, the window between PCI
enumeration and pciehp initialization should be relatively small.  I
think the best way to fix this would be to integrate pciehp more
closely into PCI enumeration, e.g., by doing pcie_init() at the point
where we discover the bridge, before we enumerate any devices below
the bridge.  This is somewhat tangled up with acpihp, so I don't know
how complicated it would be to do this.

So I guess my argument is:

  - Ignoring events that happen before pciehp init decreases our
dependency on BIOS
  - Handling all events consistently is very important
  - We currently have a problem with missing pre-pciehp events, but
there is a way to fix this

> Acked-by: Rajat Jain <rajatjain@juniper.net>

Thanks for taking a look at this!

Bjorn
