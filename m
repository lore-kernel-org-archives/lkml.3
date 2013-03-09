Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab3CIJUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 04:20:17 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41640 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab3CIJUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 04:20:14 -0500
Message-ID: <513AFECB.40409@googlemail.com>
Date: Sat, 09 Mar 2013 09:20:11 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130220 Thunderbird/17.0.3
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Yijing Wang <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com> <51065FA6.4070208@googlemail.com> <51066B46.10409@fold.natur.cuni.cz> <5106CD6C.4070009@googlemail.com> <5106E770.9070602@fold.natur.cuni.cz> <510A5F0E.6010100@googlemail.com> <CAErSpo4x8pb7J8MnokXiFTE=01-TffCk6CKC0VS7CEf3X1bSBw@mail.gmail.com> <5138C03C.8080600@googlemail.com> <CAErSpo4nyRgUf8hsbNKBTzW+eqzyNTrLFYFaJ6v=sSVQg7CBPw@mail.gmail.com> <5138F6B6.8050208@googlemail.com> <CAErSpo6=Fkfi2TTyoDCXpvnmvyYgio1PQjscwn66vHN4FF2X2g@mail.gmail.com> <5139C0F7.9030907@googlemail.com> <CAErSpo4PZYK=AaEnFqEOPaopLF8_b_x8YwNhVbRMoNk21aZf4Q@mail.gmail.com>
In-Reply-To: <CAErSpo4PZYK=AaEnFqEOPaopLF8_b_x8YwNhVbRMoNk21aZf4Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On 03/08/13 22:57, Bjorn Helgaas wrote:
> [+cc Rafael, in case the _OSC thing rings a bell with him]
>
> On Fri, Mar 8, 2013 at 3:44 AM, Chris Clayton <chris2553@googlemail.com> wrote:
>> On 03/08/13 00:39, Bjorn Helgaas wrote:
>>> On Thu, Mar 7, 2013 at 1:21 PM, Chris Clayton <chris2553@googlemail.com>
>>> wrote:
>>>> On 03/07/13 17:30, Bjorn Helgaas wrote:
>
>>>>> 3) HVR-1400 not being recognized when inserted.  This is a PCI hotplug
>>>>> issue, and I *can* help with this.  I don't know what your hardware
>>>>> is, but in general, pciehp should take care of this.  If it doesn't,
>>>>> or if you have to use an argument like "pcie_ports=native", we should
>>>>> fix this.
>
>>>>> So 3) is the thing I might be able to help with.  If there's still a
>>>>> problem here (and even having to boot with an argument is a problem),
>>>>> let's start by collecting complete dmesg logs, with and without your
>>>>> "pcie_ports" option.  Boot without the card installed, then insert it
>>>>> and remove it.  If you can use something like v3.9-rc1 with
>>>>> CONFIG_HOTPLUG_PCI_PCIE=y, that would be ideal.
>>>>
>>>>
>>>> OK, I've gathered these logs using a kernel built from a pull of Linus'
>>>> tree
>>>> this afternoon (v3.9-rc1-108-g9f22578). Also, the cx23885 driver is still
>>>> blacklisted to avoid unnecessary noise and the chance of an oops if the
>>>> card
>>>> springs out again when I insert it. The driver does load if it's not
>>>> blacklisted (and the pcie_ports=native option is present).
>>>>
>>>> The two logs are attached. As you will see, nothing at all happens when
>>>> the
>>>> pcie_ports=native option is absent. The nf_conntrack message is normally
>>>> the
>>>> last one from a normal boot.
>>>
>>>
>>> Perfect, thanks!
>>>
>>> It looks like something's going wrong when we evaluate _OSC.  Can you
>>> collect an acpidump from your machine?
>>>
>> A bziped file containing the output from acpidump is attached.
>
> Thanks.  I opened this bug report:
> https://bugzilla.kernel.org/show_bug.cgi?id=54981 to keep track of
> your logs.
>

Excellent, thanks.

> Here's your _OSC method from the acpidump:
>
>              Method (_OSC, 4, Serialized) {
>                  ...
>                  If (LAnd (LEqual (Arg0, GUID), NEXP))
>                      ... # normal case
>                  Else {
>                      Or (CDW1, 0x04, CDW1)  # "unrecognized UUID" error
>                      Return (Local0)
>                  }
>
> It fails with "unrecognized UUID" if either (1) we supply the wrong
> UUID or (2) "NEXP" is false.  I have no idea what NEXP is; your
> DSDT.dsl never sets it, so maybe it's related to a BIOS setup option
> or something?  I found a BIOS manual [1] but didn't see anything
> likely.  I guess it might be worth you looking, or maybe trying a
> "reset to defaults" if it's not too destructive for you.  You don't

As the manual showed, there aren't too many user-changeable settings in 
the BIOS on this machine, so I tried a "reset to defaults". 
Unfortunately, it made no difference.

> have a copy of Windows on that box, do you?  I *assume* hotplug would
> work fine with Windows and maybe we could figure out what it is doing
> differently.
>

Yes, I have Windows 7 Home Premium (64 bit), although, as I said 
previously, I rarely boot it. One occasion when I usually do is when I 
buy new hardware. The hotplug works fine in Windows with the two 
expresscards that I own.

I'm happy to help work out what's different on Windows, but I have no 
diagnostic tools installed, so I might need some hand-holding. One 
immediate difference is that my Windows installation is 64bit whereas my 
linux installation is 32 bit.

Thanks for your help so far,

Chris

> Bjorn
>
> [1] http://solutions.us.fujitsu.com/www/content/pdf/SupportGuides/AH530_BIOS_Guide_FPC58-2843-01_rA.pdf
>
