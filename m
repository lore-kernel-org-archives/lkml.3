Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaJCUOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:14:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaJCUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:14:18 -0400
Date: Fri, 3 Oct 2014 22:14:09 +0200
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
Message-ID: <20141003201409.GM10583@worktop.programming.kicks-ass.net>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 10:27:47AM -0700, Andy Lutomirski wrote:
> [adding linux-api.  whoops.]
> 
> On Fri, Oct 3, 2014 at 10:18 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> > PR_SET_TSC / PR_TSC_SIGSEGV is a security feature to prevent heavily
> > sandboxed programs from learning the time, presumably to avoid
> > disclosing the wall clock and to make timing attacks much harder to
> > exploit.
> >
> > Unfortunately, this feature is very insecure, for multiple reasons,
> > and has probably been insecure since before it was written.
> >
> > Weakness 1: Before Linux 3.16, the vvar page and the HPET (!) were
> > part of the kernel's fixmap, so any user process could read them.
> > The vvar page contains low-resolution timing information (with real
> > wall clock and frequency data), and the HPET can be used for high
> > precision timing.  Even in Linux 3.16, there clean way to disable
> > access to these pages.
> >
> > Weakness 2: On most configurations, most or all userspace processes
> > have unrestricted access to RDPMC, which is even better than RDTSC
> > for exploiting timing attacks.
> >
> > I would like to fix both of these issues.  I want to deny access to
> > RDPMC to processes that haven't asked for access via
> > perf_event_open.  I also want to implement real TSC blocking, which
> > will require some vdso enhancements

So the problem with the default deny is that its:
 1) pointless -- the attacker can do sys_perf_event_open() just fine;
 2) and expensive -- the people trying to measure performance get the
    penalty of the CR4 write.

So I would suggest a default on, but allow a disable for the seccomp
users, which might have also disabled the syscall. Note that is is
possible to disable RDPMC while still allowing the syscall.
