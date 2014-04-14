Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaDNT7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:59:15 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:55827 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbaDNT7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:59:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140414191143.GA26864@kroah.com>
References: <20140414145359.48b7337c@endymion.delvare>
	<20140414191143.GA26864@kroah.com>
Date: Mon, 14 Apr 2014 15:59:11 -0400
X-Google-Sender-Auth: II_fKnyu7iMwzoDsxQ0uEXJXPfQ
Message-ID: <CA+5PVA6tO=mf5iEbuHp9Pqdf+0N7+yxY_AE2Q4GMy+sr9U25jw@mail.gmail.com>
Subject: Re: Hardware dependencies in Kconfig
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 3:11 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Apr 14, 2014 at 02:53:59PM +0200, Jean Delvare wrote:
>> Hi all,
>>
>> Configuring kernels from scratch has become an incredibly long and
>> tedious task. The reason is that the number of drivers and options has
>> exploded in the past few years. Which in itself is great - Linux is
>> successful, yeah! - but the side effects must be dealt with.
>> 6000-line .config files are no fun.
>>
>> Earlier today, I found that NET_CADENCE is set in my x86-64 kernel
>> configuration. The two ethernet drivers below this menu are for ARM
>> machines. I really shouldn't be asked about that on x86-64. I just sent
>> a patch addressing this specific issue, which follows about 50 similar
>> patches from me for similar issues in various subsystems. But I can't
>> do all of that by myself, this is too much work quantitatively, and I
>> am not always the best person to find out the proper hardware
>> dependencies that should be added.
>
> Ideally, the arch doesn't matter at all for a driver, only the
> infrastructure the driver depends on does.  So perhaps the
> "infrastructure" dependancy should be added for the drivers that you
> feel are only present on ARM platforms?  Are these all platform devices?

I think there's a theoretical vs. practical argument there.  USB, PCI,
etc drivers are mostly architecture agnostic.  However, the overlap of
drivers in the GPIO, I2C, watchdog, etc subsystems between
architectures is fairly small.  It requires the same (or at least very
similar) IP blocks to be used in different chips.  This _does_ happen,
and when it does it's also possible to have the driver "just work"
without updates.  It's also happens that the driver needs changes to
work on that arch.

So not specifying an arch dependency for those drivers in theory is
fine.  On the other side, asking questions about drivers that
literally have no practical use except on one arch is annoying and
leads to bloat.  Having that arch dep, and adding a new arch dep when
the HW is used one a new arch, adds a bit of development overhead
while helping with the issues Jean and I see.

>> I would like to call for proper hardware dependencies to become a
>> general trend: every new hardware-specific driver which is added to the
>> kernel should depend on ($hardware || COMPILE_TEST), so as to make it
>> clear right away, which type of hardware is expected to need the driver
>> in question.
>
> Adding more COMPILE_TEST dependancies for platform drivers would be
> wonderful to have, and make your life a little bit easier.  Other than
> that, a simple 'm' selection for a distro config should be fine :)

Ugh.  I hate the "distros should just say =m" for everything approach.
 Yeah, sometimes it's warranted but without on-going vetting of
configs you wind up building stuff that doesn't have any practical
chance of being on various platforms.

It also means distro kernel maintainers that want to avoid that spend
a lot of time looking at Kconfig files to figure out what drivers make
sense where.  That in turn leads to builds failing when we turn
something on that isn't in any of the defconfigs built in linux-next
on a particular arch.  That tends to lead to, at best, patch creation,
and more usually build break reports that are dealt with in a wide
variety of ways.  Creating patches for build breaks is great for stats
and stuff, but it would probably be nice not have to deal with that
hassle if it has no practical benefit.

Maybe I'm overly grumpy.  Still, it's frustrating to see Kconfig
entries that clearly say "blahblah found on foo ARM chip" in the help
with no "depends on ARM" (not meaning to pick on ARM).  I would like
to think there is some balance that could be found here.

josh
