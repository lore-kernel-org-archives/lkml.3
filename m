Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaGGRez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:34:55 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:37098 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaGGRev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:34:51 -0400
MIME-Version: 1.0
In-Reply-To: <1719046.4xHmiSoxkE@pcbe13110.cern.ch>
References: <280883016.9onmf0miLq@pcbe13110.cern.ch> <1807045.P44aWKLMe6@pcbe13110.cern.ch>
 <20140704212612.GA15618@google.com> <1719046.4xHmiSoxkE@pcbe13110.cern.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 Jul 2014 11:34:31 -0600
Message-ID: <CAErSpo5YbaOjqr4obHwekRNwo1K5j0JbE-PYu48k7U90ZpWM0A@mail.gmail.com>
Subject: Re: PCIe bus enumeration
To: Federico Vaga <federico.vaga@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michel Arruat <michel.arruat@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 1:29 AM, Federico Vaga <federico.vaga@gmail.com> wrote:
> On Friday 04 July 2014 15:26:12 Bjorn Helgaas wrote:
>> On Fri, Jul 04, 2014 at 09:55:20AM +0200, Federico Vaga wrote:
>> > > I assume these ports don't support hotplug.  If they *did*
>> > > support
>> > > hotplug, those ports would have to exist because they handle the
>> > > hotplug events (presence detect, etc.)
>> >
>> > I asked: yes, they do not support hotplug
>> >
>> > > If you can collect the complete "lspci -vv" output from your
>> > > machine (with a device plugged in, so we can see the port
>> > > leading to it), that will help make this more concrete.  And
>> > > maybe one with no devices plugged in, so we can see exactly
>> > > what changes.
>> >
>> > I attached two files with the output. I putted a card in slot 10
>> > and took the output, then moved the card on slot 11 and took the
>> > output.
>> >
>> > As you can see with diff the bridge behind the slot disappear when
>> > it is empty.
>>
>> Perfect, thanks!  For some reason, it really helps me to be able to
>> stare at the actual data.  Here's the situation with slot 10
>> occupied:
>>
>>   00:01.0 82Q35 Root Port to [bus 05]          PCIe SltCap slot #21
>>   05:00.0 CERN/ECP/EDU Device                  slot 10
>>   00:1c.0 82801I Express Port 1 to [bus 04]    PCIe SltCap slot #22
>>   00:1c.3 (not present at all)
>>   00:1c.4 82801I Express Port 5 to [bus 03]    PCIe SltCap slot #0
>>   03:00.0 Realtek NIC
>>
>> and here it is with slot 11 occupied:
>>
>>   00:01.0 (not present at all)
>>   00:1c.0 82801I Express Port 1 to [bus 05]    PCIe SltCap slot #22
>>   00:1c.3 82801I Express Port 4 to [bus 04]    PCIe SltCap slot #25
>>   04:00.0 CERN/ECP/EDU Device                  slot 11
>>   00:1c.4 82801I Express Port 5 to [bus 03]    PCIe SltCap slot #0
>>   03:00.0 Realtek NIC
>>
>> I'm pretty sure this is a function of your BIOS.  There are often
>> device-specific ways to enable or disable individual devices (like
>> the root ports here), and the BIOS is likely disabling these ports
>> when there is nothing below them.  I don't know why it would turn
>> off 00:1c.3 when its slot is empty, but it doesn't turn off
>> 00:1c.0, which also leads to an empty slot. But I don't think
>> Linux is involved in this, and if the BIOS disables devices, there
>> really isn't anything Linux can do about it.
>
> It seems to happen also on some "classic" PC. I didn't experiment it
> by myself, some friends reported me this behavior in the recent past.
>
> So, It looks like that some BIOS disable the bridge when there is
> nothing behind it. Why? Power save? :/

Could be power savings, or possibly to conserve bus numbers, which are
a limited resource.

>> If you can get to an EFI shell on this box, you might be able to
>> confirm this with the "pci" command.  Booting Linux with
>> "pci=earlydump" is similar in that it dumps PCI config space before
>> we change anything.
>
> yes I confirm, the bridge are not there if I don't plug the card.
>
>> To solve this problem, I think you need slot information even when
>> there's no hotplug.  This has been raised before [1, 2], and I
>> think it's a good idea, but nobody has implemented it yet.
>
> Yes, but if the BIOS disable the bridge there is nothing we can do.

Well, it's true that it's hard to get constant *bus numbers*, but it's
never really been a good idea to rely on those, because they're
assigned at the discretion of the OS, and there are reasons why the OS
might want to reallocate them, e.g., to accommodate a deep hot-plugged
hierarchy.  If you shift focus to *slot numbers*, then I think there's
a lot more we can do.

>> Another curious thing is that you refer to "slot 10", but there's no
>> obvious connection between that and the "slot 21" in the PCIe
>> capability of the Root Port leading to that slot.  But I guess you
>> said the slots are in a backplane (they're not an integral part of
>> the motherboard).  In that case, there's no way for the motherboard
>> to know what the labels on the backplane are.
>
> It is written on the backplane. I said slot 10 because I'm counting
> the available slot, but on the backplane they are 22, 25, and other
> no-consecutive numbers.

The 22, 25, etc., are in the same range as the slot numbers in the
PCIe Slot Capabilities registers, so maybe the backplane is
constructed to make this possible.  The external PCIe chassis I'm
familiar with have one fast link on a cable leading to the box, with a
PCIe switch inside the box.  The upstream port is connected to the
incoming link, and there's a downstream port connected to each slot.
In this case, the slot numbers in the downstream ports' Slot
Capabilities registers can be made to match the silkscreen labels on
the board since everything is fixed by the hardware.

Your backplane sounds a little different (you have Ports on the root
bus leading directly to slots in the backplane, so I assume those
Ports are on the motherboard, not the backplane), but maybe the
motherboard & backplane are designed as a unit so the Port slot
numbers could match the backplane.

> If I use `biosdecode` I can get that information, but only for the
> "first level" of bridges. On some backplane I have PCI bridges behind
> bridges, and in this case biosdecode doesn't help: it just tell me
> about the bridge on the motherboard.

What specific biosdecode information are you using?  There's a fair
amount of stuff in the PCI-to-PCI bridge spec about slot and chassis
numbering, including some about expansion chassis.  I doubt that Linux
implements all that, so there's probably room for a lot of
improvement.  I attached your lspci output to the bugzilla
(https://bugzilla.kernel.org/show_bug.cgi?id=72681).  Maybe you could
attach the biosdecode info there, too, and we could see if there's a
way we can make this easier.

Bjorn
