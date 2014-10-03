Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaJCUnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:43:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJCUnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:43:03 -0400
Date: Fri, 3 Oct 2014 22:42:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC
 filtering
Message-ID: <20141003204256.GO10583@worktop.programming.kicks-ass.net>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
 <20141003201409.GM10583@worktop.programming.kicks-ass.net>
 <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 01:22:22PM -0700, Andy Lutomirski wrote:
> > So the problem with the default deny is that its:
> >  1) pointless -- the attacker can do sys_perf_event_open() just fine;
> 
> Not if the attacker is in a seccomp sandbox.

Clearly :-)

> >  2) and expensive -- the people trying to measure performance get the
> >     penalty of the CR4 write.
> 
> Does this matter for performance measuring?  I'm not 100% clear on how all
> the perf_event stuff gets used in practice, but, by my very vague
> understanding, there are two main workflows:
> 
> a) perf record, etc: one process creates a ringbuffer and wakes up
> rarely to record the contents.  The process being recorded doesn't
> have a perf_event mapped, so the cr4 switch will only happen when
> waking up the perf process.
> 
> perf record prints stuff like "[ perf record: Woken up 1 times to
> write data ]", which seems to confirm my understanding.
> 
> b) self-monitoring.  A task mmaps a perf_event, does rdpmc, does
> something, and does rdpmc again.  In that case, there's no context
> switch.

Agreed, but with the default disable, the self-monitoring task will get
CR4 writes to its context switches and will be slower.

Whereas if we default on and only disable with seccomp then only the
seccomp tasks will suffer the burden of a CR4 write at context switch
time.

And I don't see a security implication in the default.

> > So I would suggest a default on, but allow a disable for the seccomp
> > users, which might have also disabled the syscall. Note that is is
> > possible to disable RDPMC while still allowing the syscall.
> 
> Disabling RDPMC per-process while still allowing the syscall will need
> a bunch of work, right? 

Not much, all you need to do is make
perf_event_mmmap_page::cap_user_rdpmc be 0 and userspace should never
use rdpmc. Currently we set that bit based on the global sysfs rdpmc
value, but we could easy bitwise AND it with a per process value.

> What happens if the same perf_event is mapped
> by two different users?

Not entirely clear on what you mean here.

> We could make the rule be that RDPMC is enabled if a perf event is
> mmapped or TIF_SECCOMP is clear, but I'd prefer to be convinced that
> there's an actual performance issue first.  Ideally we can get this
> all working with no API or ABI change at all.

Well I just want to not have extra CR4 writes by default (and by default
I don't care about seccomp).

> P.S. Hey, Intel, let us context switch RDPMC accessibility of the
> individual counters, please :)

Ha sure, make it more complicated why don't you ;-) But yes, that has
come up before.
