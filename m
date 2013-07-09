Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab3GIUTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 16:19:40 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:46795 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3GIUTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 16:19:37 -0400
MIME-Version: 1.0
In-Reply-To: <51DBD95C.4060406@googlemail.com>
References: <51016937.1020202@googlemail.com> <5105AFDB.9000200@googlemail.com>
 <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com>
 <51065FA6.4070208@googlemail.com> <51066B46.10409@fold.natur.cuni.cz>
 <5106CD6C.4070009@googlemail.com> <5106E770.9070602@fold.natur.cuni.cz>
 <510A5F0E.6010100@googlemail.com> <CAErSpo4x8pb7J8MnokXiFTE=01-TffCk6CKC0VS7CEf3X1bSBw@mail.gmail.com>
 <5138C03C.8080600@googlemail.com> <CAErSpo4nyRgUf8hsbNKBTzW+eqzyNTrLFYFaJ6v=sSVQg7CBPw@mail.gmail.com>
 <5138F6B6.8050208@googlemail.com> <CAErSpo6=Fkfi2TTyoDCXpvnmvyYgio1PQjscwn66vHN4FF2X2g@mail.gmail.com>
 <5139C0F7.9030907@googlemail.com> <CAErSpo4PZYK=AaEnFqEOPaopLF8_b_x8YwNhVbRMoNk21aZf4Q@mail.gmail.com>
 <513AFECB.40409@googlemail.com> <CAErSpo6QLeo5Qjq=sNBYZ4ism1ck5e2+toPpOjS+P6Y-5y37Gg@mail.gmail.com>
 <CAErSpo7ybiSM=xgtjoc0hD=rtoJ7whVeHkbTLU7ZpnrpxR8Ezg@mail.gmail.com>
 <5148886F.8000809@googlemail.com> <CAErSpo4khnDo8_gbNsdr966Dba9tLPEg32iYE7TMiEjQOu-5aw@mail.gmail.com>
 <51DBD95C.4060406@googlemail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 9 Jul 2013 14:19:16 -0600
Message-ID: <CAErSpo6L21RapNxPsBr=+7TeK9StTTj_Vx8D9PTeEXz+yOs0wg@mail.gmail.com>
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
To: Chris Clayton <chris2553@gmail.com>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Yijing Wang <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 3:35 AM, Chris Clayton <chris2553@gmail.com> wrote:
> Hello again, Bjorn.
>
> On 04/01/13 18:28, Bjorn Helgaas wrote:
>
> <snip>
>
>
>>>> Hi Chris,
>>>>
>>>> The current Linux acpiphp driver doesn't do anything unless it finds
>>>> devices with _EJ0 or _RMV methods, and your DSDT has neither.  But I
>>>> think that implementation is incorrect because I'm not convinced that
>>>> those methods are required in order to do hotplug via ACPI.  For
>>>> example, your DSDT *does* have an _L01 method that does notifications
>>>> to the root ports.  I suspect that hotplug events on your box generate
>>>> an SCI that invokes that method.  Linux basically ignores the
>>>> resulting notify events, and I suspect that hotplug works on Windows
>>>> because it is paying attention to them.
>>>>
>>>> Can you build a kernel with CONFIG_ACPI_DEBUG=y, do the following, and
>>>> attach all the output to the bugzilla?
>>>>
>>>> 1) Boot with empty ExpressCard slot (without using "pcie_ports=native")
>>>> 2) # echo 0x00010004 > /sys/module/acpi/parameters/debug_layer
>>>> 3) # echo 0x08000004 > /sys/module/acpi/parameters/debug_level
>>>> 4) # lspci -vv
>>>> 5) # setpci -s 1c.3 0x42.w
>>>> 6) # setpci -s 1c.3 0x5a.w
>>>> 7) # setpci -s 1c.3 0xd8.l
>>>> 8) Insert ExpressCard
>>>> 9) # setpci -s 1c.3 0x5a.w
>>>> 10) # dmesg
>>>>
>>>> Here's what I think we'll see:
>>>>
>>>> - Slot Implemented (bit 8 of XCAP at 0x42) set, indicating a slot is
>>>> implemented below this root port
>>>> - Hot Plug SCI Enable (bit 30 of MPC at 0xd8) set, indicating that the
>>>> root port should generate an SCI whenever a hotplug event is detected
>>>> - Presence Detect State (bit 6 of SLTSTS at 0x5a) change from 0 with
>>>> the slot empty to 1 with the slot occupied
>>>> - pciehp doing nothing (since _OSC didn't grant the OS permission to
>>>> use PCIe native hotplug)
>>>> - dmesg indication of the SCI, leading to a Bus Check notification to
>>>> \_SB.PCI0.RP04, which is the 1c.3 root port leading to the ExpressCard
>>>> slot
>>>>
>>>
>>> As far as I can see, your predicted outcomes where correct. I've added
>>> the
>>> logs to the bugzilla report.
>>
>>
>> Yes, it behaved exactly as I expected.  I attached a few more details
>> of the analysis to the bug report
>> (https://bugzilla.kernel.org/show_bug.cgi?id=54981).  I think we need
>> to rework acpiphp to fix this.  We will fix it, but I don't know who
>> will do it, or when it will happen.  My list is growing faster than I
>> can deal with :(
>>
>
> I see that there has been quite a bit of work in the acpiphp area recently.
> Is any of it intended to fix (or ease the subsequent fixing of) this bug
> report, please?

The problem on your system is that acpiphp doesn't work correctly
because it expects a certain combination of _ADR/_EJ0/_RMV methods,
and your system doesn't quite match.  Rafael's acpiphp work is
definitely addressing that issue, but I don't know whether he's made
it far enough yet.

I doubt that work will appear in a v3.11-rc release, though.  More
likely it will appear in -next fairly soon and will first appear in
Linus' tree in v3.12-rc1.  So if you want to test it, either try out
-next or wait for v3.12-rc1.

> It's not a big deal if it isn't - I do have a system that, via kernel
> command line arguments, recognises expresscard devices when I plug them into
> the slot. But when the release comes along that includes the reworking of
> acpiphp that you mentioned, I will give extra attention to hotplugging when
> I try out the -rc kernels on my laptop.

Thanks!  We'll certainly appreciate any testing reports.

Bjorn
