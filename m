Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaBZL02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:26:28 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54187 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbaBZL00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:26:26 -0500
Date: Wed, 26 Feb 2014 11:25:44 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>
Subject: Re: [PATCH v2 1/1] arm64: make a single hook to syscall_trace() for
 all syscall features
Message-ID: <20140226112544.GD8961@mudshark.cambridge.arm.com>
References: <1391767651-5296-1-git-send-email-takahiro.akashi@linaro.org>
 <1393319683-2707-1-git-send-email-takahiro.akashi@linaro.org>
 <1393319683-2707-2-git-send-email-takahiro.akashi@linaro.org>
 <20140225150007.GB23136@mudshark.cambridge.arm.com>
 <530D4AB3.4000700@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530D4AB3.4000700@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:00:19AM +0000, AKASHI Takahiro wrote:
> On 02/26/2014 12:00 AM, Will Deacon wrote:
> > On Tue, Feb 25, 2014 at 09:14:43AM +0000, AKASHI Takahiro wrote:
> >> Currently syscall_trace() is called only for ptrace.
> >> With additional TIF_xx flags defined, it is now called in all the cases
> >> of audit, ftrace and seccomp in addition to ptrace.
> >>
> >> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> >> Acked-by: Richard Guy Briggs <rgb@redhat.com>
> >> ---
> >>   arch/arm64/include/asm/thread_info.h |   13 ++++++++++
> >>   arch/arm64/kernel/entry.S            |    5 ++--
> >>   arch/arm64/kernel/ptrace.c           |   45 +++++++++++++++++-----------------
> >>   3 files changed, 38 insertions(+), 25 deletions(-)
> 
> [...]
> 
> >> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> >> index 6a8928b..c70133e 100644
> >> --- a/arch/arm64/kernel/ptrace.c
> >> +++ b/arch/arm64/kernel/ptrace.c
> >> @@ -1062,31 +1062,30 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
> >>   {
> >>   	unsigned long saved_reg;
> >>
> >> -	if (!test_thread_flag(TIF_SYSCALL_TRACE))
> >> -		return regs->syscallno;
> >> -
> >> -	if (is_compat_task()) {
> >> -		/* AArch32 uses ip (r12) for scratch */
> >> -		saved_reg = regs->regs[12];
> >> -		regs->regs[12] = dir;
> >> -	} else {
> >> -		/*
> >> -		 * Save X7. X7 is used to denote syscall entry/exit:
> >> -		 *   X7 = 0 -> entry, = 1 -> exit
> >> -		 */
> >> -		saved_reg = regs->regs[7];
> >> -		regs->regs[7] = dir;
> >> -	}
> >> +	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
> >> +		if (is_compat_task()) {
> >> +			/* AArch32 uses ip (r12) for scratch */
> >> +			saved_reg = regs->regs[12];
> >> +			regs->regs[12] = dir;
> >> +		} else {
> >> +			/*
> >> +			 * Save X7. X7 is used to denote syscall entry/exit:
> >> +			 *   X7 = 0 -> entry, = 1 -> exit
> >> +			 */
> >> +			saved_reg = regs->regs[7];
> >> +			regs->regs[7] = dir;
> >> +		}
> >>
> >> -	if (dir)
> >> -		tracehook_report_syscall_exit(regs, 0);
> >> -	else if (tracehook_report_syscall_entry(regs))
> >> -		regs->syscallno = ~0UL;
> >> +		if (dir)
> >> +			tracehook_report_syscall_exit(regs, 0);
> >> +		else if (tracehook_report_syscall_entry(regs))
> >> +			regs->syscallno = ~0UL;
> >>
> >> -	if (is_compat_task())
> >> -		regs->regs[12] = saved_reg;
> >> -	else
> >> -		regs->regs[7] = saved_reg;
> >> +		if (is_compat_task())
> >> +			regs->regs[12] = saved_reg;
> >> +		else
> >> +			regs->regs[7] = saved_reg;
> >> +	}
> >
> > Aren't these changes (to ptrace.c) just a giant NOP?
> 
> Umm, the purpose of this big "if" is to run the code only if TIF_SYSCALL_TRACE is set,
> and to make it easy to add additional hooks, audit and ftrace, around tracehook_report_*()
> later on.

The existing code already checks TIF_SYSCALL_TRACE. I'd rather you added
this new code when it's actually nedded (e.g. when adding audit on top).

Will
