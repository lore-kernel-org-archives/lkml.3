Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3KLCXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:23:09 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60711 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3KLCWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:22:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2VuqQoo3Xv9ED94w34Te97hmz-4tNxUQdbBJTLMM4OLOg@mail.gmail.com>
References: <20131111235700.GA29987@july> <002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
 <20131112005628.GA2914@khazad-dum.debian.net> <CAPXgP11oHZXbzCt72yutmeF-P=GudzPb9whTpWe5n9LDqOMM+g@mail.gmail.com>
 <CAH9JG2VuqQoo3Xv9ED94w34Te97hmz-4tNxUQdbBJTLMM4OLOg@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 12 Nov 2013 03:22:28 +0100
Message-ID: <CAPXgP11v2B8NOAV_w4R4mcgmYYSNf4xMJpzqNtnja+s0A8NOhA@mail.gmail.com>
Subject: Re: [PATCH] video: backlight: Remove backlight sysfs uevent
To: Kyungmin Park <kmpark@infradead.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Jingoo Han <jg1.han@samsung.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 3:08 AM, Kyungmin Park <kmpark@infradead.org> wrote:
> On Tue, Nov 12, 2013 at 10:19 AM, Kay Sievers <kay@vrfy.org> wrote:
>> On Tue, Nov 12, 2013 at 1:56 AM, Henrique de Moraes Holschuh
>> <hmh@hmh.eng.br> wrote:
>>> On Tue, 12 Nov 2013, Jingoo Han wrote:
>>>> On Tuesday, November 12, 2013 8:57 AM, Kyungmin Park wrote:
>>>> > From: Kyungmin Park <kyungmin.park@samsung.com>
>>>> >
>>>> > The most mobile phones have Ambient Light Sensors and it changes brightness according lux.
>>>> > It means it changes backlight brightness frequently by just writing sysfs node, so it generates uevent.
>>>> >
>>>> > Usually there's no user to use this backlight changes. But it forks udev worker threads and it takes
>>>> > about 5ms. The main problem is that it hurts other process activities. so remove it.
>>>> >
>>>> > Kay said
>>>> > "Uevents are for the major, low-frequent, global device state-changes,
>>>> >  not for carrying-out any sort of measurement data. Subsystems which
>>>> >  need that should use other facilities like poll()-able sysfs file or
>>>> >  any other subscription-based, client-tracking interface which does not
>>>> >  cause overhead if it isn't used. Uevents are not the right thing to
>>>> >  use here, and upstream udev should not paper-over broken kernel
>>>> >  subsystems."
>>>
>>> True.
>>>
>>> Now, let's take a look at reality: should you poll()/select() on a sysfs
>>> node that doesn't suport it, it will wait until the poll/select timeout
>>> happens (or EINTR happens), and userspace has absolutely NO way to detect
>>> whether a sysfs node has poll/select support.
>>>
>>> What happens if the sysfs interface did not provide poll/select support
>>> since day one, but rather added it later?  Nobody will use it for a *long*
>>> time, if ever... unless you actually took pains to version the sysfs
>>> interface, and people actually care.
>>
>> If that's an issue, we can add a new "event" file, just for that.
>>
>>>> 'thinkpad_acpi.c' uses the 'BACKLIGHT_UPDATE_SYSFS'.
>>>> Henrique, can we remove it?
>>>
>>> Can't you fix this by rate-limiting, or otherwise adding an attribute that
>>> backlight devices should set when they need to supress change events?
>>
>> Yeah, great idea, fix a bad hack with another bad one on top. :)
>> Passing measurement data through uevents is just an utterly broken
>> idea which cannot be fixed.
>>
>>> Is there a proper on-screen-display support path for the backlight class
>>> nowadays?  Otherwise, you'd be removing the only way userspace ever had to
>>> do proper OSD of backlight changes...
>>
>> OSD drawing and event sounds usually happen as a fedback for
>> keypresses of brightness control, it would be weird to show up when
>> something else, like a light-sensor, adjusts the brightness in the
>> background.
>>
>> Anyway, there might be the need for coordination and a new interface,
>> but uevents for measurement data need to die entirely; they make no
>> sense, never made any; and the sooner they are gone the better.
>
> Now power_supply, especially battery uses this scheme. it passes
> battery data using uevent.
> do you have any idea to kill it?

It should be removed too, the same applies to power_supply as to everything
else; uevents are a broken interface for any kind of device data which
is not meant as a trigger to re-configure the device itself.

But power_supply events are at least not as unfixable as backlight,
the number of events can be kept relatively low during normal
operation. So it can happen after the backlight thing is sorted out.

Note: The same rule as for generating uevents applies also to device
properties exported in the environment too; measurement data has no
place there. Reading the "uevent" file of a battery in sysfs (we need to
do that at bootup) sometimes synchronously blocks 1 second to return,
just because it tries to add measurement data reading it live from the
hardware to add it to the event itself.

Kay
