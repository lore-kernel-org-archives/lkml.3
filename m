Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaKFCk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:40:28 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37673 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaKFCkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:40:23 -0500
Message-ID: <545ADF8F.70809@linaro.org>
Date: Thu, 06 Nov 2014 11:40:15 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/6] arm64: ptrace: add PTRACE_SET_SYSCALL
References: <1412243176-16192-1-git-send-email-takahiro.akashi@linaro.org> <1412243176-16192-2-git-send-email-takahiro.akashi@linaro.org> <20141008141306.GQ26140@arm.com> <CAGXu5jJkP_fg1Ck+rj1nn7tK=ckuMk5ObvgCOJLNhb3cHb3D-Q@mail.gmail.com> <20141009092358.GB3141@arm.com>
In-Reply-To: <20141009092358.GB3141@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will, Kees

#Sorry for this late ping,

On 10/09/2014 06:23 PM, Will Deacon wrote:
> On Wed, Oct 08, 2014 at 04:30:18PM +0100, Kees Cook wrote:
>> On Wed, Oct 8, 2014 at 9:13 AM, Will Deacon <will.deacon@arm.com> wrote:
>>> On Thu, Oct 02, 2014 at 10:46:11AM +0100, AKASHI Takahiro wrote:
>>>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>>>> index fe63ac5..2842f9f 100644
>>>> --- a/arch/arm64/kernel/ptrace.c
>>>> +++ b/arch/arm64/kernel/ptrace.c
>>>> @@ -1082,7 +1082,19 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
>>>>   long arch_ptrace(struct task_struct *child, long request,
>>>>                 unsigned long addr, unsigned long data)
>>>>   {
>>>> -     return ptrace_request(child, request, addr, data);
>>>> +     int ret;
>>>> +
>>>> +     switch (request) {
>>>> +             case PTRACE_SET_SYSCALL:
>>>> +                     task_pt_regs(child)->syscallno = data;
>>>> +                     ret = 0;
>>>> +                     break;
>>>> +             default:
>>>> +                     ret = ptrace_request(child, request, addr, data);
>>>> +                     break;
>>>> +     }
>>>> +
>>>> +     return ret;
>>>>   }
>>>
>>> I still don't understand why this needs to be in arch-specific code. Can't
>>> we implement this in generic code and get architectures to implement
>>> something like syscall_set_nr if they want the generic interface?
>>
>> Personally, I'd rather see this land as-is in the arm64 tree, and then
>> later optimize PTRACE_SET_SYSCALL out of arm/ and arm64/, especially
>> since only these architectures implement this at the moment.
>
> Why? It should be really straightforward to do this in core code from the
> get-go and experience shows that, if we don't do it now, it will never
> happen.

How should I deal with this issue? I would be able to go either way.

Other than that, I will submit v8 patch series with a few very minor updates:
- use compat_uint_t in struct compat_siginfo
- use a new call interface of secure_computing(void)
- modify and clarify comments in syscall_trace_enter()

Thanks,
-Takahiro AKASHI

>> This is my plan for the asm-generic seccomp.h too -- I'd rather avoid
>> touching other architectures in this series, as it's easier to review
>> this way. Then we can optimize the code in a separate series, which
>> will have those changes isolated, etc.
>
> But this doesn't need to touch any other architectures...
>
> Will
>
