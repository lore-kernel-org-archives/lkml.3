Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaHLJl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:41:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46703 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbaHLJlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:41:25 -0400
Date: Tue, 12 Aug 2014 10:40:58 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Deepak Saxena <dsaxena@linaro.org>, Lee Campbell <leecam@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 3/3] arm64: Add seccomp support
Message-ID: <20140812094058.GD29013@arm.com>
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org>
 <1406020499-5537-4-git-send-email-takahiro.akashi@linaro.org>
 <53D082E9.8090303@amacapital.net>
 <53D09C4F.9010104@linaro.org>
 <CALCETrWTDS7VSyuR5wgGxpu-_YMWVUVmv9ht6t1tCSX=GA46cQ@mail.gmail.com>
 <53D2255C.9050006@linaro.org>
 <CAGXu5jJL=zXuSRNomGrB09kqpUhEpkuxDH18JN4NRbWocMw4xg@mail.gmail.com>
 <53E47DCE.4080902@linaro.org>
 <20140811092409.GE15344@arm.com>
 <53E9BAD5.3080201@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E9BAD5.3080201@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akashi,

On Tue, Aug 12, 2014 at 07:57:25AM +0100, AKASHI Takahiro wrote:
> On 08/11/2014 06:24 PM, Will Deacon wrote:
> > On Fri, Aug 08, 2014 at 08:35:42AM +0100, AKASHI Takahiro wrote:
> >> As discussed in a few weeks ago, aarch64 won't support PTRACE_SET_SYSCALL.
> >
> > Well, I don't think anything was set in stone. If you have a compelling
> > reason why adding the new request gives you something over setting w8
> > directly, then we can extend ptrace.
> 
> Yeah, I think I may have to change my mind. Looking into __secure_computing(),
> I found the code below:
> 
>  >     case SECCOMP_MODE_FILTER:
>  >         case SECCOMP_RET_TRACE:
>  >             ...
>  >             if (syscall_get_nr(current, regs) < 0)
>  >                 goto skip;
> 
> This implies that we should modify syscallno *before* __secure_computing()
> returns.

Why does it imply that? There are four competing entities here:

 - seccomp
 - tracehook
 - ftrace (trace_sys_*)
 - audit

With the exception of ftrace, they can all potentially rewrite the pt_regs
(the code you cite above is just below a ptrace_event call), so we have
to choose some order in which to call them.

On entry, x86 and arm call them in the order I listed above, so it seems
sensible to follow that.

> I assumed, in my next version, we could skip a system call by overwriting
> syscallno with x8 in syscall_trace_enter() after __secure_computing()
> returns 0, and it actually works.

Why does overwriting the syscallno with x8 skip the syscall?

I thought the idea was that we would save w8 prior to each call that could
change the pt_regs, then if it was changed to -1 we would replace it with
the saved value and return -1? The only confusion I have is whether we
should call the exit hooks after skipping a syscall. I *think* x86 does
call them, but ARM doesn't. Andy says this can trigger an OOPs:

  http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/274988.html

so we should fix that for ARM while we're here.

Will
