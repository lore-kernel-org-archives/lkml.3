Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaHOOen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:34:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40750 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbaHOOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:34:42 -0400
Date: Fri, 15 Aug 2014 15:33:46 +0100
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
Message-ID: <20140815143346.GV27466@arm.com>
References: <53D082E9.8090303@amacapital.net>
 <53D09C4F.9010104@linaro.org>
 <CALCETrWTDS7VSyuR5wgGxpu-_YMWVUVmv9ht6t1tCSX=GA46cQ@mail.gmail.com>
 <53D2255C.9050006@linaro.org>
 <CAGXu5jJL=zXuSRNomGrB09kqpUhEpkuxDH18JN4NRbWocMw4xg@mail.gmail.com>
 <53E47DCE.4080902@linaro.org>
 <20140811092409.GE15344@arm.com>
 <53E9BAD5.3080201@linaro.org>
 <20140812094058.GD29013@arm.com>
 <53E9F7E1.9090405@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E9F7E1.9090405@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 12:17:53PM +0100, AKASHI Takahiro wrote:
> On 08/12/2014 06:40 PM, Will Deacon wrote:
> > On Tue, Aug 12, 2014 at 07:57:25AM +0100, AKASHI Takahiro wrote:
> >>
> >>   >     case SECCOMP_MODE_FILTER:
> >>   >         case SECCOMP_RET_TRACE:
> >>   >             ...
> >>   >             if (syscall_get_nr(current, regs) < 0)
> >>   >                 goto skip;
> >>
> >> This implies that we should modify syscallno *before* __secure_computing()
> >> returns.
> >
> > Why does it imply that? There are four competing entities here:
> >
> >   - seccomp
> >   - tracehook
> >   - ftrace (trace_sys_*)
> >   - audit
> >
> > With the exception of ftrace, they can all potentially rewrite the pt_regs
> > (the code you cite above is just below a ptrace_event call), so we have
> > to choose some order in which to call them.
> 
> (audit won't change registers.)

Sorry, you're quite right.

> > On entry, x86 and arm call them in the order I listed above, so it seems
> > sensible to follow that.
> 
> Right, but as far as I understand, ptrace_event() in __secure_computing()
> calls ptrace_notify(), and eventually executes ptrace_stop(), which can
> be stopped while tracer runs (until ptrace(PTRACE_CONT)?).
> So syscall_get_nr() is expected to return -1 if trace changes a syscall number to -1
> (as far as sycall_get_nr() refers to syscallno in pt_regs).
> 
> That is why I think we should have PTRACE_SET_SYSCALL.

Gotcha, yeah that looks like the cleanest approach after all. Thanks for the
explanation.

Will
