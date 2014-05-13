Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaEMTdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:33:52 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:52193 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbaEMTdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:33:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Date: Tue, 13 May 2014 21:32:53 +0200
Message-ID: <8399002.IIyBoyEHox@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdVxc3XRanpboWPumvQKbg-qdRBHQvYXwjTKX4CrxXPeAw@mail.gmail.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <6202090.0OtAjefIFT@wuerfel> <CAMuHMdVxc3XRanpboWPumvQKbg-qdRBHQvYXwjTKX4CrxXPeAw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ln5Tw+EaaW/s6zK1OOub0ikfHPTciD/ot20EZAnLf3r
 wD7xzXAeBpln68GmGmWgFocJYNqWewD9ZOvexa6fD+7GcigzkX
 M9XSWgEIYgxJNKb9SeTkzXLl+eyPKYYXqWdTos/Yep4wdjzk2R
 rpdBahVaulb7vMsNNMClgSzkG9pOPJH77T8QXWYzbhw9P4bOyH
 0UDdnfxomYawMnw7AxTUSZv+X0oJyvUDbKGbo5R/zawE8yg2xu
 Yhh7QD/MiacLInbQbRDm4Sv2NeTtIvUXeG2oH6OND2ljHkeiJG
 WQr/k3e0MeVWVqWbZtGThgaIousQmkzUWB3RdFDuze/foUvPFO
 /xF6eXjG0X3kbWCatIiI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 20:24:59 Geert Uytterhoeven wrote:
> On Tue, May 13, 2014 at 8:10 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > Using 64-bit time_t on x32 is fine, because it's fast to operate
> > in user space with 64-bit registers, and the kernel is 64-bit
> > anyway. Inside of the kernel, we may get into trouble using
> > a 64-bit time_t on 32-bit architectures because of the overhead
> > in 64-bit math, e.g. all the timekeeping code that is based on
> > timespec or some code paths in file systems and network code where
> > we actually require division of time_t values.
> 
> While going over time_t uses, have you found a pattern for use cases
> involving division of time_t values in filesystem and networking code?

In ipv4, we have multiple places doing this:

        icmp_param.data.times[1] = htonl((tv.tv_sec % 86400) * MSEC_PER_SEC +
                                         tv.tv_nsec / NSEC_PER_MSEC);

to calculate the miliseconds since midnight. For file systems, I
found that FAT uses seconds/minutes/hours/days/month/year representation,
which is a lot of divides, but that can probably be optimized and
we need to handle years beyond 2038 anyway.

> > We clearly have to change that code in some for to deal with y2038,
> > but 64-bit time_t may not be the best option. A lot of the
> > in-kernel code can probably use ktime_t, which we can change
> > to a different representation (e.g. 34 bit seconds) if needed,
> > and all the code that is only interested in relative time
> > (e.g. nanosleep) doesn't have to change at all.
> 
> Yeah. 32-bit uptimes should be good enough for everyone (don't quote
> me on that), so adding a 64-bit offset when there's a need for absolute
> time should be OK.

I think we have three categories:

a) interfaces that uses relative time_t/timespec/timeval:
   - nanosleep
   - select/pselect/poll/ppoll/epoll
   - getrusage
   - sched_rr_get_interval
   - sigtimedwait
   - clock_nanosleep
   - alarm
   - siginfo (rusage)

  These can stay compatible, but we'd have to use a different
  type if we change time_t.

b) interfaces that don't make sense for times in the past:
   - getitimer/setitimer
   - timer_settime/timer_gettime
   - gettimeofday/settimeofday
   - adjtimex
   - clock_gettime/clock_settime/clock_adjtime
   - time/stime
   - socket time stamps
   - audio time stamps
   - v4l time stamps
   - input event time stamps
   - sysv ipc (msg, sem, shm)

   Here, we are relatively free to change the start of the
   epoch in the kernel but convert to something else on the
   user space boundary. One possibility is to scale them to
   boot time and use ktime_t in the kernel.

c) interfaces that require absolute times:
   - stat/lstat/fstatat/
   - utime/utimes/futimesat

These absolutely have to use something better than time_t
both in user space and in the kernel so we can deal with
old files. A lot of file systems need to be fixed as well so
we can actually store the times, regardless of whether we
are running a 32 or 64 bit kernel.

	Arnd 
