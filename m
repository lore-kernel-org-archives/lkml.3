Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab3GaCVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 22:21:34 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:40724 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3GaCVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 22:21:32 -0400
Message-ID: <51F874D0.8040500@gmail.com>
Date: Wed, 31 Jul 2013 10:22:08 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime
 UX31A
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com> <3453253.oZLO1ChPbL@vostro.rjw.lan> <CAMP44s02V_FO1BPJZqo6MB9RMknXYdV7AXDqbJzYHpgK1GUuJw@mail.gmail.com> <37178266.QXgbv9rq0i@vostro.rjw.lan> <CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com> <51F86A20.3060309@gmail.com> <CAMP44s3z7M9omEkc23JNuVpCAKi=gqdBCThCdBcBrW-QYpuzkg@mail.gmail.com>
In-Reply-To: <CAMP44s3z7M9omEkc23JNuVpCAKi=gqdBCThCdBcBrW-QYpuzkg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 10:07 AM, Felipe Contreras wrote:
> On Tue, Jul 30, 2013 at 8:36 PM, Aaron Lu <aaron.lwe@gmail.com> wrote:
>> On 07/31/2013 08:11 AM, Felipe Contreras wrote:
>>> On Tue, Jul 30, 2013 at 6:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>
>>>>> If 0 turns the screen off with the intel driver, 0 should turn the
>>>>> screen off with the ACPI driver, having inconsistent behavior
>>>>> depending on which driver is used is a bug.
>>>>
>>>> The ACPI driver simply exposes and interface to interact with the AML methods
>>>> in the BIOS directly.
>>>
>>> No, the ACPI driver is exposing a backlight interface, which has a
>>> defined stable API.
>>>
>>> Documentation/ABI/stable/sysfs-class-backlight
>>>
>>> Yes, the interface doesn't define what should happen at 0, that is a
>>> bug in the interface definition.
>>>
>>> *How* it achieves that is an implementation detail.
>>>
>>>> Yes, this is a mistake and shouldn't be designed this way.
>>>>
>>>> However, incidentally, this makes backlight control work on your machine.
>>>>
>>>> Anyway, we need all backlight drivers to work consistently and don't tempt me
>>>> to rip the ACPI driver entirely from the kernel for what it's worth.
>>>
>>> Yes, they should work consistently, and go ahead, rip the ACPI driver,
>>> *then* you'll see many more people complaining about the Linux kernel
>>> breaking user-space, which should never happen. Mistakes happen, but
>>> if you do this willingly and knowingly, I think there would be
>>> repercussions for you.
>>>
>>>> Yes, that will break backlight on your system and *then* you can complain to
>>>> Linus if you wish.
>>>
>>> It is already broken in v3.11-rc3, in fact I just booted that to try
>>> it out and it booted with the screen completely black (fortunately I
>>> knew exactly what to type to change that).
>>
>> That is bad, can you please file a bug for that? I'll need to take a
>> look at your ACPI tables, thanks.
> 
> File a bug where?

https://bugzilla.kernel.org/
For component, please choose ACPI->Power_Video.

> 
>>> Apparently this commit also needs to be reverted: efaa14c (ACPI /
>>> video: no automatic brightness changes by win8-compatible firmware).
>>> In this machine it makes the backlight work again (without
>>> acpi_osi="!Windows 2012"), but by doing so the ACPI driver also turns
>>> off the screen completely at level 0. Also, each time I change the
>>
>> So with rc3 and commit efaa14c reverted, when you set level 0 to ACPI
>> video's backlight interface, the screen will be off now? And this is not
>> the case in 3.10, right?
> 
> No, setting level 0 turns it off if efaa14c is *not* reverted. In 3.10
> 0 doesn't turn it off.

AFAIK, Win8 firmware will check a flag to decide what to do on hotkey
press and backlight brightness level change. Common behavior is:
If that flag is set:
  - on hotkey press, send out event;
  - on brightness level change, use GPU driver's interface to change
    backlight level following operation region spec.
If that flag is not set:
  - on hotkey press, adjust the brightness level without sending out
    event;
  - on brightness level change, use EC to change the brightness level.

The said commit sets the flag, so it seems with the flag set now,
it is possible the firmware interface will also give a screen off
result. But since we want to have notification event, we will have to
set that flag I think.

> 
>>> backlight level from X, the screen blinks as if going 100%, 0%, and
>>> then the desired level.
>>
>> Please attach acpidump output to the to be opened bugzilla page, thanks.
> 
> I looked at the code in the DCDT, it appears to me that they store
> different levels depending on the OSI version, so I don't think the
> problem is in the ACPI driver. Yet, the issue remains there.

It's good to know what is the problem, so I would like to see the table.
Most of the bugs I solved in ACPI video driver's backlight control are
caused by firmware, so yes, it's very unlikely a bug of the ACPI video
driver itself.

-Aaron
