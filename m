Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3EXOCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:02:09 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61229 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab3EXOCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:02:06 -0400
MIME-Version: 1.0
In-Reply-To: <CACo8zOceMMJQPXNLM3JL_GMQh8wNVNDkSC5eBaZf3a=--9JGqA@mail.gmail.com>
References: <1368457290-1734-1-git-send-email-dh.herrmann@gmail.com>
	<CACo8zOceMMJQPXNLM3JL_GMQh8wNVNDkSC5eBaZf3a=--9JGqA@mail.gmail.com>
Date: Fri, 24 May 2013 16:02:06 +0200
Message-ID: <CANq1E4TirOvzsGCXdVFboXWqeFPJYQF3+hp-C8cLYOVsnCFuYQ@mail.gmail.com>
Subject: Re: [PATCH] HID: input: return ENODATA if reading battery attrs fails
From: David Herrmann <dh.herrmann@gmail.com>
To: Daniel Nicoletti <dantti12@gmail.com>
Cc: "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, May 13, 2013 at 11:17 PM, Daniel Nicoletti <dantti12@gmail.com> wrote:
> 2013/5/13 David Herrmann <dh.herrmann@gmail.com>:
>> Anyway, I'd still like to see this patch applied so we have this annoying
>> bug fixed. I'd be willing to change the power_supply core, too, if one of the
>> maintainers agrees on the design (David? Anton?).
>>
>> And, @Daniel, can you check whether this actually fixes the bug? I don't own
>> a device that reports battery-information, but it at least fixes the same bug
>> for the hid-wiimote driver (tested by me).
>
> Yes, it does fixes the bug. Now udevadm properly show add and remove events
> and upower happily get's them.
> But there is around  15 seconds block on the bluetooth stack, in other words
> when connecting a device it seems to probe the device which blocks till
> a timeout, and while that timeout doesn't finish other bluetooth
> devices are also
> blocked. It seems the devices aren't able to be probed so soon, possibly
> because bluetooth didn't finished setting them up. Looking at udevadm output
> I clearly see that it locks for around 3 times.
> My kernel knowledge is rather limited but if you can give me tips or patches to
> test I really want to see this code finally working properly, and sorry for
> not realizing when I sent it that it had this issue...

The block occurs because power_supply core now tries all properties in
a row instead of aborting if the first fails (which is what we want).
However, bluetooth-core didn't allow I/O during probe so the timeout
got quite huge considering 3s for 5 different properties instead of 3s
once (which no-one noticed, yet..)

This is now fixed with the HIDP-patch pending on linux-input and
linux-bluetooth. For usbhid and uhid we already allow I/O during probe
so this does not happen there.

So I hope we can apply this for linux-next (probably after gustavo
applied the HIDP fix)?
Cheers
David
