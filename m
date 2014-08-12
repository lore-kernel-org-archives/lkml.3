Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaHLG5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:57:34 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39200 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaHLG5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:57:33 -0400
Message-ID: <53E9BAD5.3080201@linaro.org>
Date: Tue, 12 Aug 2014 15:57:25 +0900
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
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org> <1406020499-5537-4-git-send-email-takahiro.akashi@linaro.org> <53D082E9.8090303@amacapital.net> <53D09C4F.9010104@linaro.org> <CALCETrWTDS7VSyuR5wgGxpu-_YMWVUVmv9ht6t1tCSX=GA46cQ@mail.gmail.com> <53D2255C.9050006@linaro.org> <CAGXu5jJL=zXuSRNomGrB09kqpUhEpkuxDH18JN4NRbWocMw4xg@mail.gmail.com> <53E47DCE.4080902@linaro.org> <20140811092409.GE15344@arm.com>
In-Reply-To: <20140811092409.GE15344@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On 08/11/2014 06:24 PM, Will Deacon wrote:
> On Fri, Aug 08, 2014 at 08:35:42AM +0100, AKASHI Takahiro wrote:
>> On 08/06/2014 12:08 AM, Kees Cook wrote:
>>> On Fri, Jul 25, 2014 at 2:37 AM, AKASHI Takahiro
>>> <takahiro.akashi@linaro.org> wrote:
>>>> I found a bug in my current patch (v5). When 32-bit tracer skips a system call,
>>>> we should not update syscallno from x8 since syscallno is re-written directly
>>>> via ptrace(PTRACE_SET_SYSCALL).
>>>
>>> Ah, yes. Will aarch64 have a PTRACE_SET_SYSCALL option, or is this
>>> strictly a 32-bit vs 64-bit issue?
>>
>> As discussed in a few weeks ago, aarch64 won't support PTRACE_SET_SYSCALL.
>
> Well, I don't think anything was set in stone. If you have a compelling
> reason why adding the new request gives you something over setting w8
> directly, then we can extend ptrace.

Yeah, I think I may have to change my mind. Looking into __secure_computing(),
I found the code below:

 >     case SECCOMP_MODE_FILTER:
 >         case SECCOMP_RET_TRACE:
 >             ...
 >             if (syscall_get_nr(current, regs) < 0)
 >                 goto skip;

This implies that we should modify syscallno *before* __secure_computing() returns.

I assumed, in my next version, we could skip a system call by overwriting syscallno
with x8 in syscall_trace_enter() after __secure_computing() returns 0, and it actually
works.
But we'd better implement PTRACE_SET_SYSCALL to comply with what __secure_computing()
expects.

-Takahiro AKASHI


> Will
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
