Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbaGYKhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:37:01 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:58459 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaGYKg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:36:59 -0400
Message-ID: <53D23341.4040403@linaro.org>
Date: Fri, 25 Jul 2014 19:36:49 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Deepak Saxena <dsaxena@linaro.org>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linaro-kernel@lists.linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] arm64: ptrace: reload a syscall number after ptrace
 operations
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org> <1406020499-5537-2-git-send-email-takahiro.akashi@linaro.org> <53D08358.4020902@amacapital.net> <53D0A037.2060308@linaro.org> <CALCETrU9_sdODRz-xZ4bouq+anHhmfx2tkr7hg00RVf_bBBJwg@mail.gmail.com>
In-Reply-To: <CALCETrU9_sdODRz-xZ4bouq+anHhmfx2tkr7hg00RVf_bBBJwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 12:01 AM, Andy Lutomirski wrote:
> On Jul 23, 2014 10:57 PM, "AKASHI Takahiro" <takahiro.akashi@linaro.org> wrote:
>>
>> On 07/24/2014 12:54 PM, Andy Lutomirski wrote:
>>>
>>> On 07/22/2014 02:14 AM, AKASHI Takahiro wrote:
>>>>
>>>> Arm64 holds a syscall number in w8(x8) register. Ptrace tracer may change
>>>> its value either to:
>>>>     * any valid syscall number to alter a system call, or
>>>>     * -1 to skip a system call
>>>>
>>>> This patch implements this behavior by reloading that value into syscallno
>>>> in struct pt_regs after tracehook_report_syscall_entry() or
>>>> secure_computing(). In case of '-1', a return value of system call can also
>>>> be changed by the tracer setting the value to x0 register, and so
>>>> sys_ni_nosyscall() should not be called.
>>>>
>>>> See also:
>>>>       42309ab4, ARM: 8087/1: ptrace: reload syscall number after
>>>>            secure_computing() check
>>>>
>>>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>>>> ---
>>>>    arch/arm64/kernel/entry.S  |    2 ++
>>>>    arch/arm64/kernel/ptrace.c |   13 +++++++++++++
>>>>    2 files changed, 15 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>>>> index 5141e79..de8bdbc 100644
>>>> --- a/arch/arm64/kernel/entry.S
>>>> +++ b/arch/arm64/kernel/entry.S
>>>> @@ -628,6 +628,8 @@ ENDPROC(el0_svc)
>>>>    __sys_trace:
>>>>        mov    x0, sp
>>>>        bl    syscall_trace_enter
>>>> +    cmp    w0, #-1                // skip syscall?
>>>> +    b.eq    ret_to_user
>>>
>>>
>>> Does this mean that skipped syscalls will cause exit tracing to be skipped?
>>
>>
>> Yes. (and I guess yes on arm, too)
>>
>>
>>> If so, then you risk (at least) introducing
>>>
>>> a nice user-triggerable OOPS if audit is enabled.
>>
>>
>> Can you please elaborate this?
>> Since I didn't find any definition of audit's behavior when syscall is
>> rewritten to -1, I thought it is reasonable to skip "exit tracing" of
>> "skipped" syscall.
>> (otherwise, "fake" seems to be more appropriate :)
>
> The audit entry hook will oops if you call it twice in a row without
> calling the exit hook in between.

Thank you, I could reproduce this problem which hits BUG(in_syscall) in
audit_syscall_entry(). Really bad, and I fixed it in my next version and
now a "skipped" system call is also traced by audit.

I ran libseccomp test and Kees' test under auditd running with a rule,
	auditctl -a exit,always -S all
and all the tests seemed to pass.

   I can also imagine ptracers getting
> confused if ptrace entry and exit don't line up.

FYI, on arm64, we can distinguish syscall enter/exit with x12 register.

> What happens if user code directly issues syscall ~0?  Does the return
> value register get set?  Is the behavior different between traced and
> untraced syscalls?

Interesting cases. Let me think about it.

Thanks,
-Takahiro AKASHI

>  The current approach seems a bit scary.
>
> --Andy
>
