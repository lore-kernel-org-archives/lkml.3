Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762200Ab3IDXjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:39:07 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:51798 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762081Ab3IDXjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:39:05 -0400
MIME-Version: 1.0
In-Reply-To: <5227B432.8070205@zytor.com>
References: <5226FAE1.5070201@fb.com> <CALCETrWify68=_bVmFfnTWH5vY3NgxDChr_cvL7v6VovaSJdKA@mail.gmail.com>
 <CANcMJZAi_738t-eDUphC6U_25xFS0NqQqdUZAzu7Aijqmrj=wA@mail.gmail.com>
 <CALCETrVc-3j=7bP13dkYwqxUg77rdauHQ8_KEti0khh-HX220A@mail.gmail.com>
 <52279E1D.3060907@linaro.org> <5227B432.8070205@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 4 Sep 2013 16:38:42 -0700
Message-ID: <CALCETrWnZnT_t0KkWPo1v1tmPhX5_XKD19ktWL2BvKY-MezkAA@mail.gmail.com>
Subject: Re: clock_gettime_ns
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Stultz <john.stultz@linaro.org>, Arun Sharma <asharma@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 3:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/04/2013 01:54 PM, John Stultz wrote:
>>>
>>> I'd advocate for going whole hog and returning, atomically:
>>>
>>>  - TAI (nanoseconds from epoch)
>>>  - UTC - TAI (seconds or nanoseconds) *
>>>  - TAI - CLOCK_MONOTONIC (nanoseconds)
>>>  - a leap second flag.
>>>
>>> * There are various ways to define this.  My fancy UTC - TAI wouldn't
>>> actually need the leap-second flag, since the UTC time would indicate
>>> leap seconds directly.
>
> Not so (see below).
>
>>  With the conventional approach, someone would
>>> have to decide whether the leap second count increments at the
>>> beginning or the end of the leap second.
>>
>> Well, adjtimex() gives you UTC & tai offset & leapsecond flag in one go.
>>
>
> But not fractional-second information,right?  I believe it would be
> desirable if we can create a small structure (<= 16 bytes) for this.
>
> UTC - TAI is always an integral number of seconds, possibly negative
> (unlikely, but...)
>
> Something like:
>
>         struct time_ns {
>                 u64 tai_s;
>                 u32 tai_ns;
>                 s16 utcdelta;   /* TAI - UTC */
>                 u8 leap;        /* Positive leap second in progress */
>                 u8 pad;         /* Something useful here maybe? */
>         };
>
> Why the leap second flag?  It is necessary to represent the 61st second
> in a minute during a positive leap second.  Consider the below
> (artificial) cases:
>
> (leap second)
> TAI     31536000        31536001        31536002        31536003
> Delta   2               2               ?               3
> UTC     23:59:58        23:59:59        23:59:60        00:00:00
>
> (no leap second)
> TAI     31536000        31536001        31536002        31536003
> Delta   2               2               2               2
> UTC     23:59:58        23:59:59        00:00:00        00:00:01
>
> (no leap second)
> TAI     31536000        31536001        31536002        31536003
> Delta   3               3               3               3
> UTC     23:59:57        23:59:58        23:59:59        00:00:00
>
> There simply is no sufficiently meaningful value that can be put on the
> delta during a positive leap second.  Both 2 and 3 would be wrong in the
> above example, giving UTC of either 00:00:00 or 23:59:59.
>
> There is a way to do without the leap second flag by making UTC the main
> time; this does have the advantage of higher compatibility with time_t,
> struct timespec, etc:
>
>         struct timespecx {
>                 time_t tx_sec;          /* POSIX UTC seconds */
>                 u32 tx_ns;              /* Nanoseconds */
>                 s32 tx_taidelta;        /* TAI - UTC */
>         };
>
> The trick here is that tx_ns can grow all the way up to 1,999,999,999
> during a positive leap second.
>
> (Note that while planning these sorts of things it is worth noting that
> it is at least theoretically possible that another shift in the rotation
> of the Earth could one day mean needing multiple leap seconds, so at
> least allowing for them would be a good idea.  Both proposals above
> would handle that -- up to 255 leap seconds for the former and 4 leap
> seconds for the latter, either of which should be way more than necessary.)

I suspect that nearly every program will screw this up -- leap second
are rare, and the amount of branchy logic needed here is large.

Let me clarify my proposal:

A UTC time is year,month,day,hour,minute,second,fractional seconds.
So 2013/12/31 23:59:60.100 is a valid UTC time, assuming that there's
a leap second then.

Suppose the epoch is 2013/12/31 00:00:00 UTC.  Then time 86399.000 is
2013/12/31 23:59:59.000 UTC.  Time 86400.000 is 2013/12/31
23:59:60.000 UTC, 86400.100 is 2013/12/31 23:59:60.000 UTC, and
86401.000 is 2014/01/01 00:00:00.000 UTC.  This encoding happens
regardless of whether 2013/12/31 actually has a leap second.

So, for the purposes of the encoding, the last day of each month is
86401 seconds long.  One of those seconds will most likely not occur.

The benefits are that every possible UTC time has a unique
representation as a single number.  That number increases
monotonically with time.  The special case happens *every month*, so
any program that screws it up will be obviously wrong.

The main downside I can see is that it's a little strange.

--Andy
