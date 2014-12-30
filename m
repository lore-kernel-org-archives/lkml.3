Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaL3XaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 18:30:00 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:60195 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaL3X37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 18:29:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141230190327.GB23965@worktop.programming.kicks-ass.net>
References: <1419315745-20767-1-git-send-email-user@chenggang-laptop>
 <c027bde0-5f4f-441f-8d45-3e7f6f702231@alibaba-inc.com> <CALCETrVVvbnO-7bnyPCYhPbDoEg-hqmvVbfXL9ONbQPBTJNUZg@mail.gmail.com>
 <20141230190327.GB23965@worktop.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 30 Dec 2014 15:29:37 -0800
Message-ID: <CALCETrWxPBdjY0+gCmPSwjYLB0u4Z4JgGtuR-XU=qwVzoDEBpA@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkje+8mltQQVRDSF0gcGVyZiBjb3JlOiBVc2UgS1NUS19FU1AoKSBpbnN0ZQ==?=
	=?UTF-8?B?YWQgb2YgcHRfcmVncy0+c3Agd2hpbGUgb3V0cHV0IHVzZXIgcmVncw==?=
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, root <chenggang.qin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@taobao.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Namhyung Kim <namhyung@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Paul Mackerras <paulus@samba.org>,
        =?UTF-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2014 11:03 AM, "Peter Zijlstra" <peterz@infradead.org> wrote:
>
> On Thu, Dec 25, 2014 at 07:48:28AM -0800, Andy Lutomirski wrote:
> > On a quick look, there are plenty of other bugs in there besides just
> > the stack pointer issue.  The ABI check that uses TIF_IA32 in the perf
> > core is completely wrong.  TIF_IA32 may be equal to the actual
> > userspace bitness by luck, but, if so, that's more or less just luck.
> > And there's a user_mode test that should be user_mode_vm.
> >
> > Also, it's not just sp that's wrong.  There are various places that
> > you can interrupt in which many of the registers have confusing
> > locations.  You could try using the cfi unwind data, but that's
> > unlikely to work for regs like cs and ss, and, during context switch,
> > this has very little chance of working.
> >
> > What's the point of this feature?  Honestly, my suggestion would be to
> > delete it instead of trying to fix it.  It's also not clear to me that
> > there aren't serious security problems here -- it's entirely possible
> > for sensitive *kernel* values to and up in task_pt_regs at certain
> > times, and if you run during context switch and there's no code to
> > suppress this dump during context switch, then you could be showing
> > regs that belong to the wrong task.
>
> Of course the people who actually wrote the code are not on CC :/
>
> There's two users of this iirc;
>
>  1) the dwarf stack unwinder thingy, which basically dumps the userspace
>  regs and the top of userspace stack on 'event'.
>

Given how the x86_64* entry code works, using task_pt_regs from
anywhere except explicitly supported contexts (including exceptions
that originated in userspace and a small handful of system calls) is
asking for trouble.  NMI context is especially bad.

How important is this feature, and which registers matter?  It might
be possible to use a dwarf unwinder on the kernel call stack to get
most of the regs from most contexts, and it might also be possible to
make small changes to the entry code to make it possible to get some
of the registers reliably, but it's not currently possible to safely
use task_pt_regs *at all* from NMI context unless you've at least
blacklisted a handful of origin RIP values that give dangerously bogus
results.  (Using do_nmi's regs parameter if user_mode_vm(regs) is a
different story.)

* I'm not nearly as familiar with the 32-bit entry code, so I don't
know whether we have the same issues there.

>  2) the recent sample_regs_intr, which dumps the register set at
>  'event', be it kernel or userspace.
>

What's wrong with the PMI's pt_regs for that?  If we interrupted the
kernel, they'll be kernel regs (with all their attendant security
issues) and, if we interrupted userspace, then they'll be the full,
correct userspace registers.

--Andy

>
> The first is somewhat usable when lacking framepointers while still
> desiring some unwind information, the second is useful to things like
> call argument profiling and the like.
