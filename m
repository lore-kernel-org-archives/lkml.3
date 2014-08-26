Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaHZRvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:51:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39589 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbaHZRvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:51:41 -0400
Date: Tue, 26 Aug 2014 18:51:28 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Kees Cook <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Deepak Saxena <dsaxena@linaro.org>, "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/6] arm64: ptrace: allow tracer to skip a system call
Message-ID: <20140826175128.GD23445@arm.com>
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>
 <1408611405-8943-3-git-send-email-takahiro.akashi@linaro.org>
 <CAGXu5jJCyqpXkdvNDCu+eMr0qnqwbqUUo4u+2p_7DvFMzfKoEw@mail.gmail.com>
 <53F69045.7010301@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F69045.7010301@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 01:35:17AM +0100, AKASHI Takahiro wrote:
> On 08/22/2014 02:08 AM, Kees Cook wrote:
> > On Thu, Aug 21, 2014 at 3:56 AM, AKASHI Takahiro
> > <takahiro.akashi@linaro.org> wrote:
> >> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> >> index 8876049..c54dbcc 100644
> >> --- a/arch/arm64/kernel/ptrace.c
> >> +++ b/arch/arm64/kernel/ptrace.c
> >> @@ -1121,9 +1121,29 @@ static void tracehook_report_syscall(struct pt_regs *regs,
> >>
> >>   asmlinkage int syscall_trace_enter(struct pt_regs *regs)
> >>   {
> >> +       unsigned int saved_syscallno = regs->syscallno;
> >> +
> >>          if (test_thread_flag(TIF_SYSCALL_TRACE))
> >>                  tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
> >>
> >> +       if (IS_SKIP_SYSCALL(regs->syscallno)) {
> >> +               /*
> >> +                * RESTRICTION: we can't modify a return value of user
> >> +                * issued syscall(-1) here. In order to ease this flavor,
> >> +                * we need to treat whatever value in x0 as a return value,
> >> +                * but this might result in a bogus value being returned.
> >> +                */
> >> +               /*
> >> +                * NOTE: syscallno may also be set to -1 if fatal signal is
> >> +                * detected in tracehook_report_syscall_entry(), but since
> >> +                * a value set to x0 here is not used in this case, we may
> >> +                * neglect the case.
> >> +                */
> >> +               if (!test_thread_flag(TIF_SYSCALL_TRACE) ||
> >> +                               (IS_SKIP_SYSCALL(saved_syscallno)))
> >> +                       regs->regs[0] = -ENOSYS;
> >> +       }
> >> +
> >
> > I don't have a runtime environment yet for arm64, so I can't test this
> > directly myself, so I'm just trying to eyeball this. :)
> >
> > Once the seccomp logic is added here, I don't think using -2 as a
> > special value will work. Doesn't this mean the Oops is possible by the
> > user issuing a "-2" syscall? As in, if TIF_SYSCALL_WORK is set, and
> > the user passed -2 as the syscall, audit will be called only on entry,
> > and then skipped on exit?
> 
> Oops, you're absolutely right. I didn't think of this case.
> syscall_trace_enter() should not return a syscallno directly, but always
> return -1 if syscallno < 0. (except when secure_computing() returns with -1)
> This also implies that tracehook_report_syscall() should also have a return value.
> 
> Will, is this fine with you?

Well, the first thing that jumps out at me is why this is being done
completely differently for arm64 and arm. I thought adding the new ptrace
requests would reconcile the differences?

Will
