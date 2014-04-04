Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaDDS6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:58:10 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:39701 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaDDS6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:58:07 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxC_+zCD8BQ637WJLf2VXWjhJOQB7uUkVARneSKsQ2+Hg@mail.gmail.com>
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402221212.GD16570@mguzik.redhat.com>
 <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
 <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz> <20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
 <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
 <alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz> <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
 <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
 <20140403104308.GP13491@8bytes.org> <20140403170541.GA19010@thunk.org>
 <533EF832.1030902@mit.edu> <CA+55aFxC_+zCD8BQ637WJLf2VXWjhJOQB7uUkVARneSKsQ2+Hg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 4 Apr 2014 11:57:45 -0700
Message-ID: <CALCETrW7-AEZkfnFy1L0heyKxo188C9DB+ruFAvfT6iUkKxYZw@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Joerg Roedel <joro@8bytes.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 11:32 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Apr 4, 2014 at 11:21 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> The other thing I've used /dev/kmsg for is to shove a "I'm starting
>> something now" message in.  This is only really necessary because the
>> current kernel log timestamps are unusable crap.  (We could fix that,
>> hint hint.)
>
> I'd actually love to fix that, but I disagree with the "we could fix
> it". There are tons of people who know how to parse them (admittedly
> often only to ignore them), so changing the format is not likely to
> work.

What would break if we used CLOCK_BOOTTIME or CLOCK_MONOTONIC?  It's
currently sched_clock, which is measured in seconds but otherwise
seems to behave rather unpredictably.  We could keep exactly the same
format, but just use numbers measured in actual seconds instead of in
"seconds, but not really".

There are also log message metadata fields now; we could stick more
than one timestamp in there, and existing tools either won't see them
at all (if they use klogctl) or they already know how to ignore
unknown fields (/dev/kmsg).

For example, instead of logging:

[12345.67890] You wish you know what 12345 meant
  DEVICE=blah

we could log:

[12345.67890] Hah!  CLOCK_BOOTTIME says 12345.67890
  DEVICE=blah
  CLOCK_REALTIME=89173929281.171273

It would be really neat if we even went back and edited the queued up
messages once we have a clocksource.  Userspace isn't running yet, so
it can't be surprised.  We just won't show CLOCK_REALTIME at all until
someone sets the clock or we've read the RTC.  Interested users still
have CLOCK_BOOTTIME.

>
> The good news is that "dmesg -H" does help if you're human. While at
> the same time being an example of that very "there are tools that know
> about the current horrid format" issue.. D'oh.
>

I admit I have no idea wtf causes this lovely excerpt from dmesg -H:

[ +26.385160] systemd-readahead[629]: Failed to rename readahead file: Permissio
[Apr 3 20:50] TCP: lp registered

I assume it's because dmesg -H decides that it can't handle old
timestamps.  I don't know how it does with recent ones, though.

--Andy
