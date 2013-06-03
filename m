Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab3FCTEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:04:20 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35560 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3FCTER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:04:17 -0400
Message-ID: <51ACE8AE.2090809@linaro.org>
Date: Mon, 03 Jun 2013 12:04:14 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Tobias Waldekranz <tobias@waldekranz.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] timekeeping: handle epoch roll-over (2038) on 32-bit
 systems
References: <CAFaRD2FP0rrQstV1GszP_URO+cZZuQdyRxOYUEmA+5BvopUAvQ@mail.gmail.com> <alpine.LFD.2.02.1306031622520.2905@ionos>
In-Reply-To: <alpine.LFD.2.02.1306031622520.2905@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 07:34 AM, Thomas Gleixner wrote:
> B1;2601;0cOn Mon, 3 Jun 2013, Tobias Waldekranz wrote:
>> In ktime_get_update_offsets, calculate the current time in the same
>> way as in ktime_get.
>>
>> On 32-bit systems, the current time is truncated via the call to
>> ktime_set, the following subtraction of offs_real will result in an
>> inaccurate time when the current number of seconds since epoch can no
>> longer fit in 31-bits (2038-01-19 03:14:07 UTC). This will send
>> hrtimer_interrupt into an infinite loop on some architectures (arm),
>> or emit an oops on others(x86).
> If we really want to survive 2038, then we need to get rid of the
> timespec based representation of time in the kernel alltogether and
> switch all related code over to a scalar nsec 64bit storage.
>
> Just "fixing" some random parts of the code in a "make it work
> somehow" way is a pointless exercise IMO.
>
> We already had long discussions about how the timekeeping code should
> be restructured to address that and other problems at least on the
> kernel side and switching everything to scalar storage is definitely
> the way to go.
>
> Though even if we fix that we still need to twist our brains around
> the timespec/timeval based user space interfaces. That's going to be
> the way more interesting challenge.

So yea.. there's a couple approaches for userland that probably need 
more discussion:

1) Create a new ABI for 32bit platforms that have a 64bit time_t
     - I know x32 was talking about this, but I don't actually see that 
code upstream, so maybe there was an issue that blocked this?
     - In talking with some folks, there was some question on how to 
handle multiple compat types, so a 64bit OS could support both old and 
new 32bit abis. I suspect there's some approach that would work here, 
but haven't done any research.

2) Add new time64_t/timespec64 structures, and add new 64bit versions of 
syscalls for any syscall that takes a timespec/time_t
     - This is a ton of work, and lots of new syscalls. Yuck.

3) Redefine time_t to be unsigned. (Possibly as part of an abi bump?). 
This is attractive, as it requires the least change to the kernel 
interfaces, and in many cases existing userland won't care (there' no 
userland that's setting timers for dates prior to 1970). We'd just need 
to update the libc ascii time formatting, and basically give up dates 
prior to 1970. Of course, this is probably too optimistic as existing 
userland code that does (time_a < time_b) would have issues comparing 
dates before and after the 2038 overflow. However, those apps will be 
broken no matter what, so I'm starting to think this approach is likely 
to be the most reasonable.


I'm curious if there are any there other ideas that folks are considering?

thanks
-john

