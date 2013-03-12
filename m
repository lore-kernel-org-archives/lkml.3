Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3CLWVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:21:21 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34279 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3CLWVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:21:19 -0400
MIME-Version: 1.0
In-Reply-To: <513AFECB.40409@googlemail.com>
References: <51016937.1020202@googlemail.com> <5104427D.2050002@googlemail.com>
 <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com>
 <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com>
 <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com>
 <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com>
 <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com>
 <51065FA6.4070208@googlemail.com> <51066B46.10409@fold.natur.cuni.cz>
 <5106CD6C.4070009@googlemail.com> <5106E770.9070602@fold.natur.cuni.cz>
 <510A5F0E.6010100@googlemail.com> <CAErSpo4x8pb7J8MnokXiFTE=01-TffCk6CKC0VS7CEf3X1bSBw@mail.gmail.com>
 <5138C03C.8080600@googlemail.com> <CAErSpo4nyRgUf8hsbNKBTzW+eqzyNTrLFYFaJ6v=sSVQg7CBPw@mail.gmail.com>
 <5138F6B6.8050208@googlemail.com> <CAErSpo6=Fkfi2TTyoDCXpvnmvyYgio1PQjscwn66vHN4FF2X2g@mail.gmail.com>
 <5139C0F7.9030907@googlemail.com> <CAErSpo4PZYK=AaEnFqEOPaopLF8_b_x8YwNhVbRMoNk21aZf4Q@mail.gmail.com>
 <513AFECB.40409@googlemail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Mar 2013 16:20:58 -0600
Message-ID: <CAErSpo6QLeo5Qjq=sNBYZ4ism1ck5e2+toPpOjS+P6Y-5y37Gg@mail.gmail.com>
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
To: Chris Clayton <chris2553@googlemail.com>
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

On Sat, Mar 9, 2013 at 2:20 AM, Chris Clayton <chris2553@googlemail.com> wrote:
> Hi Bjorn,
>
>
> On 03/08/13 22:57, Bjorn Helgaas wrote:
>>
>> [+cc Rafael, in case the _OSC thing rings a bell with him]
>>
>> On Fri, Mar 8, 2013 at 3:44 AM, Chris Clayton <chris2553@googlemail.com>
>> wrote:
>>>
>>> On 03/08/13 00:39, Bjorn Helgaas wrote:
>>>>
>>>> On Thu, Mar 7, 2013 at 1:21 PM, Chris Clayton <chris2553@googlemail.com>
>>>> wrote:
>>>>>
>>>>> On 03/07/13 17:30, Bjorn Helgaas wrote:

>>>> It looks like something's going wrong when we evaluate _OSC.  Can you
>>>> collect an acpidump from your machine?
>>>>
>>> A bziped file containing the output from acpidump is attached.
>>
>>
>> Thanks.  I opened this bug report:
>> https://bugzilla.kernel.org/show_bug.cgi?id=54981 to keep track of
>> your logs.
>>
>
> Excellent, thanks.
>
>
>> Here's your _OSC method from the acpidump:
>>
>>              Method (_OSC, 4, Serialized) {
>>                  ...
>>                  If (LAnd (LEqual (Arg0, GUID), NEXP))
>>                      ... # normal case
>>                  Else {
>>                      Or (CDW1, 0x04, CDW1)  # "unrecognized UUID" error
>>                      Return (Local0)
>>                  }
>>
>> It fails with "unrecognized UUID" if either (1) we supply the wrong
>> UUID or (2) "NEXP" is false.  I have no idea what NEXP is; your
>> DSDT.dsl never sets it, so maybe it's related to a BIOS setup option
>> or something?  I found a BIOS manual [1] but didn't see anything
>> likely.  I guess it might be worth you looking, or maybe trying a
>> "reset to defaults" if it's not too destructive for you.  You don't
>
>
> As the manual showed, there aren't too many user-changeable settings in the
> BIOS on this machine, so I tried a "reset to defaults". Unfortunately, it
> made no difference.

Yeah, no surprise, I guess, since it works fine in Windows with the
current BIOS settings.

I looked at the DSDTs from several other machines and quite a few of
them use similar NEXP tests.  NEXP is in the GNVS area, which is
apparently used for communication between BIOS/ACPI/SMI, and I think
it means "Native PCIe support."  The BIOS probably initializes it,
possibly based on the machine type or something.

The _OSC description (ACPI 5.0 sec 6.2.10.3) is pretty clear that if a
host bridge doesn't have an _OSC method, the OS should not use
features like PCIe native hotplug.  That's why the Linux pciehp driver
isn't doing anything here.  It's possible that Windows is using PCIe
native hotplug anyway (maybe they figure "unrecognized UUID" is
different from _OSC being completely absent), or maybe there's some
way it could be using ACPI hotplug (though I *think* that would
require some more methods that your box doesn't suppy).

My guess is the former, and maybe we can figure out a way to relax
Linux's strictness around _OSC handling.

Bjorn
