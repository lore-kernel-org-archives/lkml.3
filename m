Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaJCQlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:41:53 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:56171 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaJCQlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:41:52 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 3 Oct 2014 09:41:30 -0700
Message-ID: <CALCETrUwXk-WtfwMRtcg4NO5i8-36HXDqL3BdV7xRWDWT2w7Jw@mail.gmail.com>
Subject: Removing per-task TSD? (Re: Tightening up rdpmc permissions?)
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 11:42 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Sep 29, 2014 10:36 AM, <Valdis.Kletnieks@vt.edu> wrote:
>>
>> On Mon, 29 Sep 2014 09:39:16 -0700, Andy Lutomirski said:
>>
>> > Would it make sense to restrict rdpmc to tasks that are in mms that
>> > have a perf_event mapping?  After all, unless I misunderstand
>> > something, user code can't reliably use rdpmc unless they've mapped a
>> > perf_event object to check the rdpmc bit and figure out what ecx value
>> > to use.
>>
>> Wouldn't that be trivially easy for an attacker to bypass? Just map a dummy
>> perf_event object  and then go to town?
>
> Depends on the paranoia setting.  We could require that the mapped
> object actually have an rdpmc-able counter running.
>
> Seccomp can (and often does) block access to perf_event_open entirely.
> We could certainly change the code to only twiddle CR4 if TIF_SECCOMP
> or TIF_NOTSC is set.  I think that the real thing we should optimize
> for is to minimize the chance that a given context switch actually
> needs to *change* cr4.  Since perf_event maps are relatively unusual,
> at least only perf-using programs would have overhead if we just gated
> it on the existence of a useful rdpmc-able mapping.

So this is a mess.  I think that any reasonable implementation of
rdpmc permissions should be per mm, since we perf_event maps are, of
course, per mm.

Similarly, any reasonable implementation of rdtsc permissions should
be per mm, since doing it sensibly involves telling the vdso not to
use rdtsc, and the vdso is per mm

Unfortunately, PR_SET_TSC is a per-thread setting.  Implementing this
correctly looks like it'll require twiddling, or at least thinking
about, cr4 at switch_mm time *and* when switching tasks, because the
only sensible way of granting PMC access to a running mm is to
broadcast a function call to the cpus running that mm.

Nonetheless, this is doable.  Either there can be separate context
switching of CR4.PCE (in switch_mm) and CR4.TSD (in switch_to), or
there can be some crazy optimization to make it faster.

All of this sucks, so I'll ask a normally verboten question: can we
just remove PR_SET_TSC entirely?

No, really.  It's been effectively broken as a security measure for a
*long* time, since there's no protection of rdpmc, and rdpmc can *read
the cycle counter*.  It's also mostly broken because any process,
without any exception whatsoever (until 3.16 [1]) or with technical
exceptions that I virtually guarantee that no one uses (since I wrote
the code, and it's very recent!) can read the vvar timing data or the
fscking HPET (!).

The correct (IMO) long-term solution is to gate both rdpmc and rdtsc
on a per-mm basis and to teach the vdso to cope.  There's demand for
the latter feature from the CRIU camp, as well.

Thoughts?  Can we remove a security feature that hasn't provided any
security for years to make room for a new security feature that
doesn't suck?

[1] Even 32-bit processes can.  All they have to do is to long jump to
64 bit mode and read a fixed address.  Piece of cake!

--Andy

>
> (Also, why on earth is TIF_NOTSC a thread_info flag?  Wouldn't just
> adding a field "cr4" to task_struct or something be simpler and quite
> possibly faster?  We have a branch anyway...)
>
> --Andy



-- 
Andy Lutomirski
AMA Capital Management, LLC
