Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaGHHPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:15:42 -0400
Received: from cernmx13.cern.ch ([188.184.36.46]:13634 "EHLO CERNMX13.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaGHHPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:15:40 -0400
From: Federico Vaga <federico.vaga@cern.ch>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <michel.arruat@cern.ch>
Subject: Re: PCIe bus enumeration
Date: Tue, 8 Jul 2014 09:15:36 +0200
Message-ID: <5283004.YemU4lhtKD@pcbe13110.cern.ch>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <CAErSpo5YbaOjqr4obHwekRNwo1K5j0JbE-PYu48k7U90ZpWM0A@mail.gmail.com>
References: <280883016.9onmf0miLq@pcbe13110.cern.ch> <1719046.4xHmiSoxkE@pcbe13110.cern.ch> <CAErSpo5YbaOjqr4obHwekRNwo1K5j0JbE-PYu48k7U90ZpWM0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2642395.lo0ZgMBRX5"
Content-Transfer-Encoding: 7Bit
X-Originating-IP: [137.138.123.125]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2642395.lo0ZgMBRX5
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

(I'm changing my email address to the work one. Initially it was just 
my personal curiosity but now you are helping me with my work, so I 
think is correct in this way)

> > So, It looks like that some BIOS disable the bridge when there is
> > nothing behind it. Why? Power save? :/
> 
> Could be power savings, or possibly to conserve bus numbers, which
> are a limited resource.

what is the maximum number of buses?

> >> If you can get to an EFI shell on this box, you might be able to
> >> confirm this with the "pci" command.  Booting Linux with
> >> "pci=earlydump" is similar in that it dumps PCI config space
> >> before
> >> we change anything.
> > 
> > yes I confirm, the bridge are not there if I don't plug the card.
> > 
> >> To solve this problem, I think you need slot information even
> >> when
> >> there's no hotplug.  This has been raised before [1, 2], and I
> >> think it's a good idea, but nobody has implemented it yet.
> > 
> > Yes, but if the BIOS disable the bridge there is nothing we can
> > do.
> 
> Well, it's true that it's hard to get constant *bus numbers*, but
> it's never really been a good idea to rely on those, because
> they're assigned at the discretion of the OS, and there are reasons
> why the OS might want to reallocate them, e.g., to accommodate a
> deep hot-plugged hierarchy.  If you shift focus to *slot numbers*,
> then I think there's a lot more we can do.

At this point I'm a little bit confused about the definition "slot 
numbers" :) You mean the 22, 25, ...

> >> Another curious thing is that you refer to "slot 10", but there's
> >> no obvious connection between that and the "slot 21" in the PCIe
> >> capability of the Root Port leading to that slot.  But I guess
> >> you said the slots are in a backplane (they're not an integral
> >> part of the motherboard).  In that case, there's no way for the
> >> motherboard to know what the labels on the backplane are.
> > 
> > It is written on the backplane. I said slot 10 because I'm
> > counting
> > the available slot, but on the backplane they are 22, 25, and
> > other
> > no-consecutive numbers.
> 
> The 22, 25, etc., are in the same range as the slot numbers in the
> PCIe Slot Capabilities registers, so maybe the backplane is
> constructed to make this possible.  The external PCIe chassis I'm
> familiar with have one fast link on a cable leading to the box, with
> a PCIe switch inside the box.  The upstream port is connected to
> the incoming link, and there's a downstream port connected to each
> slot. In this case, the slot numbers in the downstream ports' Slot
> Capabilities registers can be made to match the silkscreen labels
> on the board since everything is fixed by the hardware.
> 
> Your backplane sounds a little different (you have Ports on the root
> bus leading directly to slots in the backplane, so I assume those
> Ports are on the motherboard, not the backplane), but maybe the
> motherboard & backplane are designed as a unit so the Port slot
> numbers could match the backplane.

Yes, the backplane is almost "empty". Except for the 9 PCIe backplane 
which has PCI bridges on it. At the moment I cannot check physically 
this kind of backplane, but from the lspci output I understand that 
there is a bridge on the backplane because the motherboard is the 
same.

> 
> > If I use `biosdecode` I can get that information, but only for the
> > "first level" of bridges. On some backplane I have PCI bridges
> > behind bridges, and in this case biosdecode doesn't help: it just
> > tell me about the bridge on the motherboard.
> 
> What specific biosdecode information are you using? 

I was looking at the "PCI interrupt routing", but it seems that it 
returns only information about the last bridge in the interrupt's 
routing. Here an example with a different backplane (9 PCIe). 

It seems fine for backplane without PCI Bridge on the backplane.

I attached two files, one for each type of backplane.


Maybe I'm just misunderstanding the output of biosdecode. I didn't 
find an explanation of its output: I'm guessing the meaning.

> There's a fair
> amount of stuff in the PCI-to-PCI bridge spec about slot and chassis
> numbering, including some about expansion chassis.  I doubt that
> Linux implements all that, so there's probably room for a lot of
> improvement.  I attached your lspci output to the bugzilla
> (https://bugzilla.kernel.org/show_bug.cgi?id=72681).  Maybe you
> could attach the biosdecode info there, too, and we could see if
> there's a way we can make this easier.

ok

-- 
Federico Vaga
--nextPart2642395.lo0ZgMBRX5
Content-Disposition: attachment; filename="biosdecode-1-level-bridges"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="biosdecode-1-level-bridges"

-[0000:00]-+-00.0
           +-01.0-[05]----00.0
           +-02.0
           +-03.0
           +-03.2
           +-03.3
           +-19.0
           +-1a.0
           +-1a.1
           +-1a.2
           +-1a.7
           +-1b.0
           +-1c.0-[04]--
           +-1c.4-[03]----00.0
           +-1d.0
           +-1d.1
           +-1d.2
           +-1d.7
           +-1e.0-[01-02]----0c.0-[02]--
           +-1f.0
           +-1f.2
           +-1f.3
           +-1f.5
           \-1f.6


# biosdecode 2.12
BIOS32 Service Directory present.
	Revision: 0
	Calling Interface Address: 0x000E6810
PCI Interrupt Routing 1.0 present.
	Router ID: 00:1f.0
	Exclusive IRQs: None
	Compatible Router: 8086:2914
	Slot Entry 1: ID 00:02, on-board
	Slot Entry 2: ID 00:03, on-board
	Slot Entry 3: ID 00:1f, on-board
	Slot Entry 4: ID 00:1b, on-board
	Slot Entry 5: ID 00:01, on-board
	Slot Entry 6: ID 05:00, slot number 21
	Slot Entry 7: ID 00:19, on-board
	Slot Entry 8: ID 00:1a, on-board
	Slot Entry 9: ID 00:1c, on-board
	Slot Entry 10: ID 04:00, slot number 22
	Slot Entry 11: ID 03:00, on-board
	Slot Entry 12: ID 00:1d, on-board
	Slot Entry 13: ID 01:01, on-board
	Slot Entry 14: ID 01:0b, on-board
	Slot Entry 15: ID 01:0c, slot number 4
	Slot Entry 16: ID 01:0d, slot number 3
	Slot Entry 17: ID 01:0e, slot number 2
	Slot Entry 18: ID 01:0f, slot number 1
PNP BIOS 1.0 present.
	Event Notification: Not Supported
	Real Mode 16-bit Code Address: F000:71F2
	Real Mode 16-bit Data Address: F000:0000
	16-bit Protected Mode Code Address: 0x000F721A
	16-bit Protected Mode Data Address: 0x000F0000
ACPI 2.0 present.
	OEM Identifier: ACPIAM
	RSD Table 32-bit Address: 0xBF580000
	XSD Table 64-bit Address: 0x00000000BF580100
SMBIOS 2.6 present.
	Structure Table Length: 3456 bytes
	Structure Table Address: 0x000E7110
	Number Of Structures: 79
	Maximum Structure Size: 189 bytes

--nextPart2642395.lo0ZgMBRX5
Content-Disposition: attachment; filename="biosdecode-n-level-bridges"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="biosdecode-n-level-bridges"

-[0000:00]-+-00.0
           +-01.0-[02-08]----00.0-[03-08]--+-10.0-[08]--
           |                               +-11.0-[07]----00.0
           |                               +-12.0-[06]--
           |                               +-13.0-[05]--
           |                               \-14.0-[04]--
           +-02.0
           +-03.0
           +-03.2
           +-03.3
           +-19.0
           +-1a.0
           +-1a.1
           +-1a.2
           +-1a.7
           +-1d.0
           +-1d.1
           +-1d.2
           +-1d.7
           +-1e.0-[01]--+-0d.0
           |            +-0e.0
           |            \-0f.0
           +-1f.0
           +-1f.3
           \-1f.6


# biosdecode 2.11
BIOS32 Service Directory present.
	Revision: 0
	Calling Interface Address: 0x000F0010
PCI Interrupt Routing 1.0 present.
	Router ID: 00:1f.0
	Exclusive IRQs: None
	Compatible Router: 8086:2914
	Slot Entry 1: ID 00:02, on-board
	Slot Entry 2: ID 00:03, on-board
	Slot Entry 3: ID 00:1f, on-board
	Slot Entry 4: ID 00:1b, on-board
	Slot Entry 5: ID 00:01, on-board
	Slot Entry 6: ID 02:00, slot number 21
	Slot Entry 7: ID 00:19, on-board
	Slot Entry 8: ID 00:1a, on-board
	Slot Entry 9: ID 00:1c, on-board
	Slot Entry 10: ID 00:1d, on-board
	Slot Entry 11: ID 01:01, on-board
	Slot Entry 12: ID 01:0b, on-board
	Slot Entry 13: ID 01:0c, slot number 4
	Slot Entry 14: ID 01:0d, slot number 3
	Slot Entry 15: ID 01:0e, slot number 2
	Slot Entry 16: ID 01:0f, slot number 1
PNP BIOS 1.0 present.
	Event Notification: Not Supported
	Real Mode 16-bit Code Address: F000:77F2
	Real Mode 16-bit Data Address: F000:0000
	16-bit Protected Mode Code Address: 0x000F781A
	16-bit Protected Mode Data Address: 0x000F0000
ACPI 2.0 present.
	OEM Identifier: ACPIAM
	RSD Table 32-bit Address: 0xBF580000
	XSD Table 64-bit Address: 0x00000000BF580100
SMBIOS 2.6 present.
	Structure Table Length: 3456 bytes
	Structure Table Address: 0x000E6910
	Number Of Structures: 79
	Maximum Structure Size: 189 bytes

--nextPart2642395.lo0ZgMBRX5--
