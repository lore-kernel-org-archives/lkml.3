Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbbAHTt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:49:29 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45303 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbbAHTt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:49:28 -0500
MIME-Version: 1.0
In-Reply-To: <20150108184201.GB13974@cloud>
References: <1420705550-24245-1-git-send-email-famz@redhat.com>
 <1420708372.18399.15.camel@suse.cz> <CALCETrVyPij1Zxwmw7p06UrZjoyYDXqEjmxyQ-KJ8Y7dx7mL3g@mail.gmail.com>
 <20150108184201.GB13974@cloud>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 8 Jan 2015 11:42:15 -0800
Message-ID: <CALCETrUNtP5-pidiSKjQAhwFJk6joOGo9WVmcUgP2mu_29qp9g@mail.gmail.com>
Subject: Re: [PATCH 0/3] epoll: Add epoll_pwait1 syscall
To: Josh Triplett <josh@joshtriplett.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Zach Brown <zab@zabbo.net>, Fam Zheng <famz@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dario Faggioli <raistlin@linux.it>,
        Paolo Bonzini <pbonzini@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        X86 ML <x86@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Fabian Frederick <fabf@skynet.be>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Miklos Szeredi <mszeredi@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        David Herrmann <dh.herrmann@gmail.com>,
        David Drysdale <drysdale@google.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2015 10:42 AM, <josh@joshtriplett.org> wrote:
>
> On Thu, Jan 08, 2015 at 09:57:24AM -0800, Andy Lutomirski wrote:
> > On Thu, Jan 8, 2015 at 1:12 AM, Miklos Szeredi <mszeredi@suse.cz> wrote:
> > > On Thu, 2015-01-08 at 16:25 +0800, Fam Zheng wrote:
> > >> Applications could use epoll interface when then need to poll a big number of
> > >> files in their main loops, to achieve better performance than ppoll(2). Except
> > >> for one concern: epoll only takes timeout parameters in microseconds, rather
> > >> than nanoseconds.
> > >>
> > >> That is a drawback we should address. For a real case in QEMU, we run into a
> > >> scalability issue with ppoll(2) when many devices are attached to guest, in
> > >> which case many host fds, such as virtual disk images and sockets, need to be
> > >> polled by the main loop. As a result we are looking at switching to epoll, but
> > >> the coarse timeout precision is a trouble, as explained below.
> > >>
> > >> We're already using prctl(PR_SET_TIMERSLACK, 1) which is necessary to implement
> > >> timers in the main loop; and we call ppoll(2) with the next firing timer as
> > >> timeout, so when ppoll(2) returns, we know that we have more work to do (either
> > >> handling IO events, or fire a timer callback). This is natual and efficient,
> > >> except that ppoll(2) itself is slow.
> > >>
> > >> Now that we want to switch to epoll, to speed up the polling. However the timer
> > >> slack setting will be effectively undone, because that way we will have to
> > >> round up the timeout to microseconds honoring timer contract. But consequently,
> > >> this hurts the general responsiveness.
> > >>
> > >> Note: there are two alternatives, without changing kernel:
> > >>
> > >> 1) Leading ppoll(2), with the epollfd only and a nanosecond timeout. It won't
> > >> be slow as one fd is polled. No more scalability issue. And if there are
> > >> events, we know from ppoll(2)'s return, then we do the epoll_wait(2) with
> > >> timeout=0; otherwise, there can't be events for the epoll, skip the following
> > >> epoll_wait and just continue with other work.
> > >>
> > >> 2) Setup and add a timerfd to epoll, then we do epoll_wait(..., timeout=-1).
> > >> The timerfd will hopefully force epoll_wait to return when it timeouts, even if
> > >> no other events have arrived. This will inheritly give us timerfd's precision.
> > >> Note that for each poll, the desired timeout is different because the next
> > >> timer is different, so that, before each epoll_wait(2), there will be a
> > >> timerfd_settime syscall to set it to a proper value.
> > >>
> > >> Unfortunately, both approaches require one more syscall per iteration, compared
> > >> to the original single ppoll(2), cost of which is unneglectable when we talk
> > >> about nanosecond granularity.
> >
> > I'd like to see a more ambitious change, since the timer isn't the
> > only problem like this.  Specifically, I'd like a syscall that does a
> > list of epoll-related things and then waits.  The list of things could
> > include, at least:
> >
> >  - EPOLL_CTL_MOD actions: level-triggered epoll users are likely to
> > want to turn on and off their requests for events on a somewhat
> > regular basis.
> >
> >  - timerfd_settime actions: this allows a single syscall to wait and
> > adjust *both* monotonic and real-time wakeups.
> >
> > Would this make sense?  It could look like:
> >
> > int epoll_mod_and_pwait(int epfd,
> >   struct epoll_event *events, int maxevents,
> >   struct epoll_command *commands, int ncommands,
> >   const sigset_t *sigmask);
>
> That's a complicated syscall.  (And it also doesn't have room for the
> flags argument.)
>
> At that point, why not just have a syscall like this:
>
> struct syscall {
>         unsigned long num;
>         unsigned long params[6];
> };

Too minimize locking and such.  The user / kernel transitions are very
fast in some configurations, and I suspect that all the fd lookups,
epoll data structure locks, etc are important, too.

This particular pattern (EPOLL_CTL_MOD, then timerfd_settime, then
epoll_pwait) is so common that optimizing it from three syscalls to
one (as opposed to two as in your patch) seems like it could be
worthwhile.

syscall entry + exit latency is pretty good (~180 cycles total, maybe)
these days, but only in some configurations.  In others, it blows up
pretty badly.  I'm slowly working on improving that.

Also, simplicity is a win. The multi-syscall thing has never gone
smoothly, and, as Alexei pointed out, it's a big mess for seccomp.

>
> int sys_many(size_t count, struct syscall *syscalls, int *results, unsigned long flags);
>
> I think that has been discussed in the past.
>
> Or, these days, that might be better done via eBPF, which would avoid
> the need for flags like "return on error"; an eBPF program could decide
> how to proceed after each call.
>
> - Josh Triplett
