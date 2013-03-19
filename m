Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab3CSPrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:47:03 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:35895 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab3CSPrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:47:00 -0400
Message-ID: <5148886F.8000809@googlemail.com>
Date: Tue, 19 Mar 2013 15:46:55 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130312 Thunderbird/17.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Yijing Wang <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com> <51065FA6.4070208@googlemail.com> <51066B46.10409@fold.natur.cuni.cz> <5106CD6C.4070009@googlemail.com> <5106E770.9070602@fold.natur.cuni.cz> <510A5F0E.6010100@googlemail.com> <CAErSpo4x8pb7J8MnokXiFTE=01-TffCk6CKC0VS7CEf3X1bSBw@mail.gmail.com> <5138C03C.8080600@googlemail.com> <CAErSpo4nyRgUf8hsbNKBTzW+eqzyNTrLFYFaJ6v=sSVQg7CBPw@mail.gmail.com> <5138F6B6.8050208@googlemail.com> <CAErSpo6=Fkfi2TTyoDCXpvnmvyYgio1PQjscwn66vHN4FF2X2g@mail.gmail.com> <5139C0F7.9030907@googlemail.com> <CAErSpo4PZYK=AaEnFqEOPaopLF8_b_x8YwNhVbRMoNk21aZf4Q@mail.gmail.com> <513AFECB.40409@googlemail.com> <CAErSpo6QLeo5Qjq=sNBYZ4ism1ck5e2+toPpOjS+P6Y-5y37Gg@mail.gmail.com> <CAErSpo7ybiSM=xgtjoc0hD=rtoJ7whVeHkbTLU7ZpnrpxR8Ezg@mail.gmail.com>
In-Reply-To: <CAErSpo7ybiSM=xgtjoc0hD=rtoJ7whVeHkbTLU7ZpnrpxR8Ezg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

Sorry I meant to reply to your mail so that copy recipients will know 
the outcome of the things you asked me to do. But then I forgot. Doh! 
You should have received the attachment notification from bugzilla, I think.

On 03/15/13 22:48, Bjorn Helgaas wrote:
> On Tue, Mar 12, 2013 at 4:20 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Sat, Mar 9, 2013 at 2:20 AM, Chris Clayton <chris2553@googlemail.com> wrote:
>>> On 03/08/13 22:57, Bjorn Helgaas wrote:
>
>>>> Thanks.  I opened this bug report:
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=54981 to keep track of
>>>> your logs.
>
> Hi Chris,
>
> The current Linux acpiphp driver doesn't do anything unless it finds
> devices with _EJ0 or _RMV methods, and your DSDT has neither.  But I
> think that implementation is incorrect because I'm not convinced that
> those methods are required in order to do hotplug via ACPI.  For
> example, your DSDT *does* have an _L01 method that does notifications
> to the root ports.  I suspect that hotplug events on your box generate
> an SCI that invokes that method.  Linux basically ignores the
> resulting notify events, and I suspect that hotplug works on Windows
> because it is paying attention to them.
>
> Can you build a kernel with CONFIG_ACPI_DEBUG=y, do the following, and
> attach all the output to the bugzilla?
>
> 1) Boot with empty ExpressCard slot (without using "pcie_ports=native")
> 2) # echo 0x00010004 > /sys/module/acpi/parameters/debug_layer
> 3) # echo 0x08000004 > /sys/module/acpi/parameters/debug_level
> 4) # lspci -vv
> 5) # setpci -s 1c.3 0x42.w
> 6) # setpci -s 1c.3 0x5a.w
> 7) # setpci -s 1c.3 0xd8.l
> 8) Insert ExpressCard
> 9) # setpci -s 1c.3 0x5a.w
> 10) # dmesg
>
> Here's what I think we'll see:
>
> - Slot Implemented (bit 8 of XCAP at 0x42) set, indicating a slot is
> implemented below this root port
> - Hot Plug SCI Enable (bit 30 of MPC at 0xd8) set, indicating that the
> root port should generate an SCI whenever a hotplug event is detected
> - Presence Detect State (bit 6 of SLTSTS at 0x5a) change from 0 with
> the slot empty to 1 with the slot occupied
> - pciehp doing nothing (since _OSC didn't grant the OS permission to
> use PCIe native hotplug)
> - dmesg indication of the SCI, leading to a Bus Check notification to
> \_SB.PCI0.RP04, which is the 1c.3 root port leading to the ExpressCard
> slot
>

As far as I can see, your predicted outcomes where correct. I've added 
the logs to the bugzilla report.

> A Bus Check notification means we're supposed to re-enumerate starting
> at that device.  If we *did* re-enumerate, we would find the new
> ExpressCard.
>
> Thanks,
>    Bjorn
>

Thanks,
Chris
