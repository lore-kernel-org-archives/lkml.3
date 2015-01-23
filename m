Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbbAWSds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:33:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbbAWSdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:33:45 -0500
Subject: Re: futex(2) man page update help request
From: Torvald Riegel <triegel@redhat.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        Darren Hart <dvhart@infradead.org>, Anton Blanchard <anton@samba.org>,
        Petr Baudis <pasky@suse.cz>, Eric Dumazet <edumazet@google.com>,
        bill o gallmeister <bgallmeister@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>,
        Rich Felker <dalias@libc.org>
In-Reply-To: <54B7D87C.3090901@gmail.com>
References: <537346E5.4050407@gmail.com>
	 <CF98E3EF.90564%dvhart@linux.intel.com>
	 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
	 <5373D0CA.2050204@redhat.com>
	 <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
	 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>
	 <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>
	 <54B7D87C.3090901@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jan 2015 19:29:48 +0100
Message-ID: <1422037788.29655.0.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-15 at 16:10 +0100, Michael Kerrisk (man-pages) wrote:
> [Adding a few people to CC that have expressed interest in the 
> progress of the updates of this page, or who may be able to
> provide review feedback. Eventually, you'll all get CCed on
> the new draft of the page.]
> 
> Hello Thomas,
> 
> On 05/15/2014 04:14 PM, Thomas Gleixner wrote:
> > On Thu, 15 May 2014, Michael Kerrisk (man-pages) wrote:
> >> And that universe would love to have your documentation of 
> >> FUTEX_WAKE_BITSET and FUTEX_WAIT_BITSET ;-),
> > 
> > I give you almost the full treatment, but I leave REQUEUE_PI to
> > Darren and FUTEX_WAKE_OP to Jakub. :)
> 
> Thank you for the great effort you put into compiling the
> text below, and apologies for my long delay in following up.
> 
> I've integrated almost all of your suggestions into the 
> manual page. I will shortly send out a new draft of the
> page that contains various FIXMEs for points that remain 
> unclear.

Michael, thanks for working on the draft!  I'll review the draft closely
once you've sent it (or have I missed it?).

There are a few things that I'd like to see covered.

First, we should discuss that users, until they control all code in the
respective process, need to expect futexes to be affected by spurious
futex_wake calls; see https://lkml.org/lkml/2014/11/27/472 for
background and Linus' choice (AFAIU) to just document this.
So, for example, a return code of 0 for FUTEX_WAIT can mean either being
woken up by a FUTEX_WAKE intended for this futex, or a stale one
intended for another futex used by, for example, glibc internally.
(Note that as explained in this thread, this isn't just a glibc
artifact, but a result of the general futex design mixed with
destruction requirements for mutexes and other constructs in C++11 and
POSIX.)
It might also be necessary to further consider this when documenting the
errors, because it does affect how to handle them. See this for a glibc
perspective:
https://sourceware.org/ml/libc-alpha/2014-09/msg00381.html

Second, the current documentation for EINTR is that it can happen due to
receiving a signal *or* due to a spurious wake-up.  This is difficult to
handle when implementing POSIX semaphores, because they require that
EINTR is returned from SEM_WAIT if and only if the interruption was due
to a signal.  Thus, if FUTEX_WAIT returns EINTR, the semaphore
implementation can't return EINTR from sem_wait; see this for more
comments, including some discussion why use cases relying on the POSIX
requirement around EINTR are borderline timing-dependent:
https://sourceware.org/git/?p=glibc.git;a=blob;f=nptl/sem_waitcommon.c;h=96848d7ac5b6f8f1f3099b422deacc09323c796a;hb=HEAD#l282
Others have commented that aio_suspend has a similar issue; if EINTR
wouldn't in fact be returned spuriously, the POSIX-implementation-side
would get easier.

Third, I think it would be useful to -- somewhere -- explain which
behavior the futex operations would have conceptually when expressed by
C11 code.  We currently say that they wake up, sleep, etc, and which
values they return.  But we never say how to properly synchronize with
them on the userspace side.  The C11 memory model is probably the best
model to use on the userspace side, so that's why I'm arguing for this.
Basically, I think we need to (1) tell people that they should use
memory_order_relaxed accesses to the futex variable (ie, the memory
location associated with the whole futex construct on the kernel side --
or do we have another name for this?), and (2) give some conceptual
guarantees for the kernel-side synchronization so that one use this to
derive how to use them correctly in userspace.

The man pages might not be the right place for this, and maybe we just
need a revision of "Futexes are tricky".  If you have other suggestions
for where to document this, or on the content, let me know.  (I'm also
willing to spend time on this :) ).


Torvald




