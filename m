Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaENVdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:33:20 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:61134 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaENVdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:33:18 -0400
MIME-Version: 1.0
In-Reply-To: <8399002.IIyBoyEHox@wuerfel>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<6202090.0OtAjefIFT@wuerfel>
	<CAMuHMdVxc3XRanpboWPumvQKbg-qdRBHQvYXwjTKX4CrxXPeAw@mail.gmail.com>
	<8399002.IIyBoyEHox@wuerfel>
Date: Wed, 14 May 2014 14:33:18 -0700
X-Google-Sender-Auth: ndmBPpkOe1MrXEUcWk5IQQ3j5mc
Message-ID: <CANcMJZAOi9ctWkpEgynj6wxCrvW4oS5ZHj3Chv04D=VQDogEvw@mail.gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
From: John Stultz <john.stultz@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 13 May 2014 20:24:59 Geert Uytterhoeven wrote:
>> On Tue, May 13, 2014 at 8:10 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > Using 64-bit time_t on x32 is fine, because it's fast to operate
>> > in user space with 64-bit registers, and the kernel is 64-bit
>> > anyway. Inside of the kernel, we may get into trouble using
>> > a 64-bit time_t on 32-bit architectures because of the overhead
>> > in 64-bit math, e.g. all the timekeeping code that is based on
>> > timespec or some code paths in file systems and network code where
>> > we actually require division of time_t values.
>>
>> While going over time_t uses, have you found a pattern for use cases
>> involving division of time_t values in filesystem and networking code?
>
> In ipv4, we have multiple places doing this:
>
>         icmp_param.data.times[1] = htonl((tv.tv_sec % 86400) * MSEC_PER_SEC +
>                                          tv.tv_nsec / NSEC_PER_MSEC);
>
> to calculate the miliseconds since midnight. For file systems, I
> found that FAT uses seconds/minutes/hours/days/month/year representation,
> which is a lot of divides, but that can probably be optimized and
> we need to handle years beyond 2038 anyway.

We can do some tricks for internal optimizations here if these are
critical.  I'd be more concerned about userland divisions where moving
to a 64bit time_t would cause performance issues that we cannot help
optimize.


>> > We clearly have to change that code in some for to deal with y2038,
>> > but 64-bit time_t may not be the best option. A lot of the
>> > in-kernel code can probably use ktime_t, which we can change
>> > to a different representation (e.g. 34 bit seconds) if needed,
>> > and all the code that is only interested in relative time
>> > (e.g. nanosleep) doesn't have to change at all.
>>
>> Yeah. 32-bit uptimes should be good enough for everyone (don't quote
>> me on that), so adding a 64-bit offset when there's a need for absolute
>> time should be OK.
>
> I think we have three categories:
>
> a) interfaces that uses relative time_t/timespec/timeval:
>    - nanosleep
>    - select/pselect/poll/ppoll/epoll
>    - getrusage
>    - sched_rr_get_interval
>    - sigtimedwait
>    - clock_nanosleep
>    - alarm
>    - siginfo (rusage)
>
>   These can stay compatible, but we'd have to use a different
>   type if we change time_t.


So as a correction, at least clock_nanosleep can specify sleep times
using absolute time.


> b) interfaces that don't make sense for times in the past:
>    - getitimer/setitimer
>    - timer_settime/timer_gettime
>    - gettimeofday/settimeofday
>    - adjtimex
>    - clock_gettime/clock_settime/clock_adjtime
>    - time/stime
>    - socket time stamps
>    - audio time stamps
>    - v4l time stamps
>    - input event time stamps
>    - sysv ipc (msg, sem, shm)
>
>    Here, we are relatively free to change the start of the
>    epoch in the kernel but convert to something else on the
>    user space boundary. One possibility is to scale them to
>    boot time and use ktime_t in the kernel.

I'm not sure I'm totally following this... Are you suggesting we keep
32bit time internally w/ some different offset but then pass to
userland a 64bit time_t?  Or are you suggesting we change the abi to
move the epoch?

I think I'm with hpa in his recent mail in that the internal
representation is an optimization detail, and the bigger question is
do we use a  64bit time_t for future systems (possibly w/ a major ABI
break - with compat interface for existing 32bit applications), or do
we try to rev interfaces function by function to provide 2038 safe
versions which applications will have to be modified to use?

Me, I'm a fan of moving time_t to 64bits, since it makes "porting"
applications to a 2038 safe ABI easier.

thanks
-john
