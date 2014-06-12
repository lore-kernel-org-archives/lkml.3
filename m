Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaFLA2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:28:47 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:59971 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbaFLA2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406120216480.5170@nanos>
References: <20140611234024.103571777@linutronix.de>
	<20140611234607.775273584@linutronix.de>
	<CALAqxLUtmY3JeHeq_RXz-Sc_jjyJQv=VRUr6bXtAge1+6bEXDA@mail.gmail.com>
	<alpine.DEB.2.10.1406120216480.5170@nanos>
Date: Wed, 11 Jun 2014 17:28:44 -0700
Message-ID: <CALAqxLVTAsxPkZ052xtMPwkM+yFfPcfrzf71Jok4SYq5VWh-cQ@mail.gmail.com>
Subject: Re: [patch 13/13] tomoyo: Use sensible time interface
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 5:22 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 11 Jun 2014, John Stultz wrote:
>
>> On Wed, Jun 11, 2014 at 4:59 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > There is no point in calling gettimeofday if only the seconds part of
>> > the timespec is used. Use get_seconds() instead. It's not only the
>> > proper interface it's also faster.
>>
>> My only caution here is you only get tick-granular time here. So if
>> the second rolled over after the last tick, you'd get the previous
>> second when you call get_seconds(). This can cause some surprising
>> effects if the get_seconds() return value is mixed with clocksource
>> granular gettimeofday() calls.
>
> If the whole thing only cares about the seconds value, then where is
> the problem?
>
> Even if you call gettimeofday() then you still can observe this
>
> gettimeofday(ts)
>         ts.tv_sec = 99
>         ts.tv_nsec = 999999999
>
> So if you readout the related value ONE nanosecond later, then this
> value will have
>         ts.tv_sec = 100
>         ts.tv_nsec = 0
>
> So what's the point? The tomoyo code chose to take seconds granular
> time stamps for whatever reasons. So it should be able to deal with
> that, right?

No, the problem I'm warning about is if they were using gettimeofday()
elsewhere in relation to those timestamps, they could see something
like:

do_gettimeofday()  { 99, 888....}
get_seconds()   { 99 }
do_gettimeofday()  { 99, 999....}
get_seconds()   { 99 }
do_gettimeofday()  { 100, 000....}
get_seconds()   { 99 }
do_gettimeofday()  { 100, 011....}
get_seconds()   { 100 }

This is the same problem people come across occasionally if they call
gettimeofday, then create a file and fret that the file's timestamp
seems to be before the gettimefoday call, and its all due to comparing
timestamps with different granularities.

I'm not saying its a problem in this case, but I'm just throwing up
some additional caution since the change you're making isn't
completely equivalent.

thanks
-john
