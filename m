Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935089AbaFTQoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:44:55 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:58566 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935017AbaFTQow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140620102258.GA26626@arm.com>
References: <20140618202748.GA9022@www.outflux.net>
	<20140620102258.GA26626@arm.com>
Date: Fri, 20 Jun 2014 09:44:52 -0700
X-Google-Sender-Auth: 7D1cRK8oFdcMn9qEyZWLq_gUfQM
Message-ID: <CAGXu5jKJ07bXw_K+7uSAf=H_SDoeoaWPxS4rwuonbR71Svwwmw@mail.gmail.com>
Subject: Re: [PATCH] arm: ptrace: fix syscall modification under PTRACE_O_TRACESECCOMP
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        =?UTF-8?Q?Andr=C3=A9_Hentschel?= <nerv@dawncrow.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ricky Zhou <rickyz@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 3:22 AM, Will Deacon <will.deacon@arm.com> wrote:
> Hi Kees,
>
> I'm struggling to see the bug in the current code, so apologies if my
> questions aren't helpful.
>
> On Wed, Jun 18, 2014 at 09:27:48PM +0100, Kees Cook wrote:
>> An x86 tracer wanting to change the syscall uses PTRACE_SETREGS
>> (stored to regs->orig_ax), and an ARM tracer uses PTRACE_SET_SYSCALL
>> (stored to current_thread_info()->syscall). When this happens, the
>> syscall can change across the call to secure_computing(), since it may
>> block on tracer notification, and the tracer can then make changes
>> to the process, before we return from secure_computing(). This
>> means the code must respect the changed syscall after the
>> secure_computing() call in syscall_trace_enter(). The same is true
>> for tracehook_report_syscall_entry() which may also block and change
>> the syscall.
>
> I don't think I understand what you mean by `the code must respect the
> changed syscall'. The current code does indeed issue the new syscall, so are
> you more concerned with secure_computing changing ->syscall, then the
> debugger can't see the new syscall when it sees the trap from tracehook?
> Are these even supposed to inter-operate?

The problem is the use of "scno" in the call -- it results in ignoring
the value that may be set up in ->syscall by a tracer:

syscall_trace_enter(regs, scno):
    current_thread_info()->syscall = scno;
    secure_computing(scno):
        [block on ptrace]
        [ptracer changes current_thread_info()->syscall vis PTRACE_SET_SYSCALL]
    ...
    return scno;

This means the tracer's changed syscall value will be ignored
(syscall_trace_enter returns original "scno" instead of actual
current_thread_info()->syscall). In the original code, failure cases
were propagated correctly, but not tracer-induced changes.

Is that more clear? It's not an obvious state (due to the external
modification of process state during the ptrace blocking). I've also
got tests for this, if that's useful to further illustrate:

https://github.com/kees/seccomp/commit/bd24e174593f79784b97178b583f17e0ea9d2aa7

>
>> The x86 code handles this (it expects orig_ax to always be the
>> desired syscall). In the ARM case, this means we should not be touching
>> current_thread_info()->syscall after its initial assignment. All failures
>> should result in a -1 syscall, though.
>
> The only time we explicitly touch ->syscall is when we're aborting the call
> (i.e. writing -1), which I think is fine.

That was the error path, which was okay. This rearranges things to
both handle error conditions and tracer changes.

-Kees

-- 
Kees Cook
Chrome OS Security
