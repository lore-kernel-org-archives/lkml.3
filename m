Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab3JJU01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:26:27 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51224 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab3JJU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <1381435276.5630.6.camel@pasglop>
References: <1381378788.4330.30.camel@pasglop>
	<20131010174457.GE13759@kroah.com>
	<1381435276.5630.6.camel@pasglop>
Date: Thu, 10 Oct 2013 22:26:25 +0200
X-Google-Sender-Auth: Ot21G1JlrNz6ly3InCmHCroI9IU
Message-ID: <CAMuHMdW7RXjS3vvLUdTPCafNu_PcgDgbVbzVCHTOEeTsfHK90g@mail.gmail.com>
Subject: Re: sysfs for my chips
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:01 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>> > Among other, I want a sysfs file in there to access "xscom" on the chip
>> > which is a sideband bus used for low level stuff (think jtag on steroid)
>> > which we can use, among others, for chip health monitoring, general
>> > debugging and diagnostics, etc...
>> >
>> > I might add more such as VPD, model information, etc... later or at
>> > least a link to corresponding device-tree node.
>>
>> So a mixture of things that traditionally have been in /proc/cpuinfo?
>
> Not really no. /proc/cpuinfo is per-thread, and potentially might have a
> core number and a few global things. Here I'm talking mostly about
>
>   - A pseudo-file that gives access to a sideband HW bus to perform
> read/write of system registers essentially, which is per physical
> "chip" (chip in this context is processor chip, which can have lots of
> cores/threads, but also can be our memory buffer chips).
>
>   - The other stuff is much more than the kind of one-liner than one
> finds in cpuinfo. For now I'm just slapping the usual "devspec" file
> that contains the corresponding device-tree path and whatever additional
> info can be retrieved from there. Things like VPDs for example can be
> pretty big.
>
>> I've always wanted to see the cpuinfo files turn into sysfs files, so
>> that tools can parse them "properly" and not have to do different things
>> on different arches, like the proc/cpuinfo file is today (a mess).
>>
>> > How do you suggest I expose that ? So far I've been thinking about
>> > something like
>> >
>> >     /sys/chips/{processor,centaur}/chip#/files
>> >
>> > or to avoid namespace clashes
>> >
>> >     /sys/firmware/chips/{processor,centaur}/chip#/files
>> >
>> > Or maybe just
>> >
>> >     /sys/firmware/chips/chip#/files
>> >
>> > (the chip type can be inferred from the chip#, they use the same space
>> > at least as far my firmware exposes them to Linux)
>> >
>> > (the actual access to xscom goes via firmware tho it makes *some* sense)
>> >
>> > But I could instead create platform devices corresponding to the
>> > device-tree representation of each of those chips ... and have the
>> > platform devices contain the magic attributes. That's a bit more
>> > convoluted though.
>>
>> We already create platform devices for the cpus in the system in
>> /sys/devices/system/, so can you just hang the attribute files off of
>> those platform devices?
>
> This is not CPUs. CPUs are threads really. Even if they were cores, that
> still wouldn't cut it. I'm looking at chips here and not all of them
> actually processor chips. The SCOM bus address space is global to a
> physical chip and allows to access various resources that are only
> remotely related to the cores on it.

What about a "bus" for the sideband bus? That allows to decouple it
from cores, and allows to support non-processor chips, too?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
