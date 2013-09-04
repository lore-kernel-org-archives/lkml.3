Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482Ab3IDW3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 18:29:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59995 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab3IDW3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 18:29:18 -0400
Message-ID: <5227B432.8070205@zytor.com>
Date: Wed, 04 Sep 2013 15:29:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Andy Lutomirski <luto@amacapital.net>, Arun Sharma <asharma@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>
Subject: Re: clock_gettime_ns
References: <5226FAE1.5070201@fb.com> <CALCETrWify68=_bVmFfnTWH5vY3NgxDChr_cvL7v6VovaSJdKA@mail.gmail.com> <CANcMJZAi_738t-eDUphC6U_25xFS0NqQqdUZAzu7Aijqmrj=wA@mail.gmail.com> <CALCETrVc-3j=7bP13dkYwqxUg77rdauHQ8_KEti0khh-HX220A@mail.gmail.com> <52279E1D.3060907@linaro.org>
In-Reply-To: <52279E1D.3060907@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 01:54 PM, John Stultz wrote:
>>
>> I'd advocate for going whole hog and returning, atomically:
>>
>>  - TAI (nanoseconds from epoch)
>>  - UTC - TAI (seconds or nanoseconds) *
>>  - TAI - CLOCK_MONOTONIC (nanoseconds)
>>  - a leap second flag.
>>
>> * There are various ways to define this.  My fancy UTC - TAI wouldn't
>> actually need the leap-second flag, since the UTC time would indicate
>> leap seconds directly.

Not so (see below).

>  With the conventional approach, someone would
>> have to decide whether the leap second count increments at the
>> beginning or the end of the leap second.
> 
> Well, adjtimex() gives you UTC & tai offset & leapsecond flag in one go.
> 

But not fractional-second information,right?  I believe it would be
desirable if we can create a small structure (<= 16 bytes) for this.

UTC - TAI is always an integral number of seconds, possibly negative
(unlikely, but...)

Something like:

	struct time_ns {
		u64 tai_s;
		u32 tai_ns;
		s16 utcdelta;	/* TAI - UTC */
		u8 leap;	/* Positive leap second in progress */
		u8 pad;		/* Something useful here maybe? */
	};

Why the leap second flag?  It is necessary to represent the 61st second
in a minute during a positive leap second.  Consider the below
(artificial) cases:

(leap second)
TAI	31536000	31536001	31536002	31536003
Delta	2		2		?		3
UTC	23:59:58	23:59:59	23:59:60	00:00:00

(no leap second)
TAI	31536000	31536001	31536002	31536003
Delta	2		2		2		2
UTC	23:59:58	23:59:59	00:00:00	00:00:01

(no leap second)
TAI	31536000	31536001	31536002	31536003
Delta	3		3		3		3
UTC	23:59:57	23:59:58	23:59:59	00:00:00

There simply is no sufficiently meaningful value that can be put on the
delta during a positive leap second.  Both 2 and 3 would be wrong in the
above example, giving UTC of either 00:00:00 or 23:59:59.

There is a way to do without the leap second flag by making UTC the main
time; this does have the advantage of higher compatibility with time_t,
struct timespec, etc:

	struct timespecx {
		time_t tx_sec;		/* POSIX UTC seconds */
		u32 tx_ns;		/* Nanoseconds */
		s32 tx_taidelta;	/* TAI - UTC */
	};

The trick here is that tx_ns can grow all the way up to 1,999,999,999
during a positive leap second.

(Note that while planning these sorts of things it is worth noting that
it is at least theoretically possible that another shift in the rotation
of the Earth could one day mean needing multiple leap seconds, so at
least allowing for them would be a good idea.  Both proposals above
would handle that -- up to 255 leap seconds for the former and 4 leap
seconds for the latter, either of which should be way more than necessary.)

	-hpa


	-hpa

