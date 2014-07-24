Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbaGXPB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:01:27 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:57083 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616AbaGXPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:01:25 -0400
MIME-Version: 1.0
In-Reply-To: <53D0A037.2060308@linaro.org>
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org>
 <1406020499-5537-2-git-send-email-takahiro.akashi@linaro.org>
 <53D08358.4020902@amacapital.net> <53D0A037.2060308@linaro.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 24 Jul 2014 08:01:04 -0700
Message-ID: <CALCETrU9_sdODRz-xZ4bouq+anHhmfx2tkr7hg00RVf_bBBJwg@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] arm64: ptrace: reload a syscall number after
 ptrace operations
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Deepak Saxena <dsaxena@linaro.org>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linaro-kernel@lists.linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 23, 2014 10:57 PM, "AKASHI Takahiro" <takahiro.akashi@linaro.org> wrote:
>
> On 07/24/2014 12:54 PM, Andy Lutomirski wrote:
>>
>> On 07/22/2014 02:14 AM, AKASHI Takahiro wrote:
>>>
>>> Arm64 holds a syscall number in w8(x8) register. Ptrace tracer may change
>>> its value either to:
>>>    * any valid syscall number to alter a system call, or
>>>    * -1 to skip a system call
>>>
>>> This patch implements this behavior by reloading that value into syscallno
>>> in struct pt_regs after tracehook_report_syscall_entry() or
>>> secure_computing(). In case of '-1', a return value of system call can also
>>> be changed by the tracer setting the value to x0 register, and so
>>> sys_ni_nosyscall() should not be called.
>>>
>>> See also:
>>>      42309ab4, ARM: 8087/1: ptrace: reload syscall number after
>>>           secure_computing() check
>>>
>>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>>> ---
>>>   arch/arm64/kernel/entry.S  |    2 ++
>>>   arch/arm64/kernel/ptrace.c |   13 +++++++++++++
>>>   2 files changed, 15 insertions(+)
>>>
>>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>>> index 5141e79..de8bdbc 100644
>>> --- a/arch/arm64/kernel/entry.S
>>> +++ b/arch/arm64/kernel/entry.S
>>> @@ -628,6 +628,8 @@ ENDPROC(el0_svc)
>>>   __sys_trace:
>>>       mov    x0, sp
>>>       bl    syscall_trace_enter
>>> +    cmp    w0, #-1                // skip syscall?
>>> +    b.eq    ret_to_user
>>
>>
>> Does this mean that skipped syscalls will cause exit tracing to be skipped?
>
>
> Yes. (and I guess yes on arm, too)
>
>
> > If so, then you risk (at least) introducing
>>
>> a nice user-triggerable OOPS if audit is enabled.
>
>
> Can you please elaborate this?
> Since I didn't find any definition of audit's behavior when syscall is
> rewritten to -1, I thought it is reasonable to skip "exit tracing" of
> "skipped" syscall.
> (otherwise, "fake" seems to be more appropriate :)

The audit entry hook will oops if you call it twice in a row without
calling the exit hook in between.  I can also imagine ptracers getting
confused if ptrace entry and exit don't line up.

What happens if user code directly issues syscall ~0?  Does the return
value register get set?  Is the behavior different between traced and
untraced syscalls?  The current approach seems a bit scary.

--Andy
