Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaHLLSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 07:18:03 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64147 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaHLLSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 07:18:01 -0400
Message-ID: <53E9F7E1.9090405@linaro.org>
Date: Tue, 12 Aug 2014 20:17:53 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Deepak Saxena <dsaxena@linaro.org>, Lee Campbell <leecam@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 3/3] arm64: Add seccomp support
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org> <1406020499-5537-4-git-send-email-takahiro.akashi@linaro.org> <53D082E9.8090303@amacapital.net> <53D09C4F.9010104@linaro.org> <CALCETrWTDS7VSyuR5wgGxpu-_YMWVUVmv9ht6t1tCSX=GA46cQ@mail.gmail.com> <53D2255C.9050006@linaro.org> <CAGXu5jJL=zXuSRNomGrB09kqpUhEpkuxDH18JN4NRbWocMw4xg@mail.gmail.com> <53E47DCE.4080902@linaro.org> <20140811092409.GE15344@arm.com> <53E9BAD5.3080201@linaro.org> <20140812094058.GD29013@arm.com>
In-Reply-To: <20140812094058.GD29013@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2014 06:40 PM, Will Deacon wrote:
> Hi Akashi,
>
> On Tue, Aug 12, 2014 at 07:57:25AM +0100, AKASHI Takahiro wrote:
>> On 08/11/2014 06:24 PM, Will Deacon wrote:
>>> On Fri, Aug 08, 2014 at 08:35:42AM +0100, AKASHI Takahiro wrote:
>>>> As discussed in a few weeks ago, aarch64 won't support PTRACE_SET_SYSCALL.
>>>
>>> Well, I don't think anything was set in stone. If you have a compelling
>>> reason why adding the new request gives you something over setting w8
>>> directly, then we can extend ptrace.
>>
>> Yeah, I think I may have to change my mind. Looking into __secure_computing(),
>> I found the code below:
>>
>>   >     case SECCOMP_MODE_FILTER:
>>   >         case SECCOMP_RET_TRACE:
>>   >             ...
>>   >             if (syscall_get_nr(current, regs) < 0)
>>   >                 goto skip;
>>
>> This implies that we should modify syscallno *before* __secure_computing()
>> returns.
>
> Why does it imply that? There are four competing entities here:
>
>   - seccomp
>   - tracehook
>   - ftrace (trace_sys_*)
>   - audit
>
> With the exception of ftrace, they can all potentially rewrite the pt_regs
> (the code you cite above is just below a ptrace_event call), so we have
> to choose some order in which to call them.

(audit won't change registers.)

> On entry, x86 and arm call them in the order I listed above, so it seems
> sensible to follow that.

Right, but as far as I understand, ptrace_event() in __secure_computing()
calls ptrace_notify(), and eventually executes ptrace_stop(), which can
be stopped while tracer runs (until ptrace(PTRACE_CONT)?).
So syscall_get_nr() is expected to return -1 if trace changes a syscall number to -1
(as far as sycall_get_nr() refers to syscallno in pt_regs).

That is why I think we should have PTRACE_SET_SYSCALL.

>> I assumed, in my next version, we could skip a system call by overwriting
>> syscallno with x8 in syscall_trace_enter() after __secure_computing()
>> returns 0, and it actually works.
>
> Why does overwriting the syscallno with x8 skip the syscall?
>
> I thought the idea was that we would save w8 prior to each call that could
> change the pt_regs, then if it was changed to -1 we would replace it with
> the saved value and return -1?

I think its the right way to do.
But x86 rewrites orig_ax and arm rewrites syscallno directly, and
refer to these values as "syscall numbers" later on, for example,
see the arguments to audit_syscall_entry().
So if we don't update syscallno, we may see different behaviors from x86 or arm?

> The only confusion I have is whether we
> should call the exit hooks after skipping a syscall. I *think* x86 does
> call them, but ARM doesn't. Andy says this can trigger an OOPs:

Again, right. we should definitely avoid OOPs.
But we may be able to avoid OOPs by not calling entry hooks for skipped system
calls, instead of calling exit hooks, if we rewrite syscallno as mentioned above.
(Please note, as I mentioned, audit_syscall_xx() ignores any request for logging
invalid system calls.)

Thanks,
-Takahiro AKASHI

>    http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/274988.html
>
> so we should fix that for ARM while we're here.
>
> Will
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
