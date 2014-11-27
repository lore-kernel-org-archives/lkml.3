Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaK0OKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:10:52 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40707 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaK0OKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:10:50 -0500
Date: Thu, 27 Nov 2014 14:10:52 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/6] arm64: ptrace: add NT_ARM_SYSTEM_CALL regset
Message-ID: <20141127141052.GP20649@arm.com>
References: <1416977391-24231-1-git-send-email-takahiro.akashi@linaro.org>
 <1416977391-24231-2-git-send-email-takahiro.akashi@linaro.org>
 <20141126124128.GH14866@arm.com>
 <5476BC60.6060005@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5476BC60.6060005@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 05:53:36AM +0000, AKASHI Takahiro wrote:
> On 11/26/2014 09:41 PM, Will Deacon wrote:
> > On Wed, Nov 26, 2014 at 04:49:46AM +0000, AKASHI Takahiro wrote:
> >> This regeset is intended to be used to get and set a system call number
> >> while tracing.
> >> There was some discussion about possible approaches to do so:
> >>
> >> (1) modify x8 register with ptrace(PTRACE_SETREGSET) indirectly,
> >>      and update regs->syscallno later on in syscall_trace_enter(), or
> >> (2) define a dedicated regset for this purpose as on s390, or
> >> (3) support ptrace(PTRACE_SET_SYSCALL) as on arch/arm
> >>
> >> Thinking of the fact that user_pt_regs doesn't expose 'syscallno' to
> >> tracer as well as that secure_computing() expects a changed syscall number,
> >> especially case of -1, to be visible before this function returns in
> >> syscall_trace_enter(), (1) doesn't work well.
> >> We will take (2) since it looks much cleaner.
> >>
> >> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> >> ---
> >>   arch/arm64/kernel/ptrace.c |   35 +++++++++++++++++++++++++++++++++++
> >>   include/uapi/linux/elf.h   |    1 +
> >>   2 files changed, 36 insertions(+)
> >>
> >> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> >> index 8a4ae8e..8b98781 100644
> >> --- a/arch/arm64/kernel/ptrace.c
> >> +++ b/arch/arm64/kernel/ptrace.c
> >> @@ -551,6 +551,32 @@ static int tls_set(struct task_struct *target, const struct user_regset *regset,
> >>   	return ret;
> >>   }
> >>
> >> +static int system_call_get(struct task_struct *target,
> >> +			   const struct user_regset *regset,
> >> +			   unsigned int pos, unsigned int count,
> >> +			   void *kbuf, void __user *ubuf)
> >> +{
> >> +	struct pt_regs *regs = task_pt_regs(target);
> >> +
> >> +	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> >> +				   &regs->syscallno, 0, -1);
> >
> > Does this work for big-endian machines? regs->syscallno is a u64, but the
> > regset defines it as an int. I think you need to copy to a temporary
> > register first.
> 
> Right. I will fix it.
> Do you prefer to use s32, instead of int, like other regsets?

I don't have a preference either way.

It would be great to have a new revision of these patches ASAP if you're
targetting 3.19.

Will
