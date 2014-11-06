Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaKFSRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:17:43 -0500
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36728 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaKFSRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:17:41 -0500
MIME-Version: 1.0
In-Reply-To: <545ADF8F.70809@linaro.org>
References: <1412243176-16192-1-git-send-email-takahiro.akashi@linaro.org>
	<1412243176-16192-2-git-send-email-takahiro.akashi@linaro.org>
	<20141008141306.GQ26140@arm.com>
	<CAGXu5jJkP_fg1Ck+rj1nn7tK=ckuMk5ObvgCOJLNhb3cHb3D-Q@mail.gmail.com>
	<20141009092358.GB3141@arm.com>
	<545ADF8F.70809@linaro.org>
Date: Thu, 6 Nov 2014 10:17:40 -0800
X-Google-Sender-Auth: No7MkgWFwUrYAxoOCT_FI65xljs
Message-ID: <CAGXu5j+kSSsg7wx8jL5f8PsTe0JfWDNH0WBdZ6v01yCyEB54zA@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] arm64: ptrace: add PTRACE_SET_SYSCALL
From: Kees Cook <keescook@chromium.org>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 6:40 PM, AKASHI Takahiro
<takahiro.akashi@linaro.org> wrote:
> Hi Will, Kees
>
> #Sorry for this late ping,
>
>
> On 10/09/2014 06:23 PM, Will Deacon wrote:
>>
>> On Wed, Oct 08, 2014 at 04:30:18PM +0100, Kees Cook wrote:
>>>
>>> On Wed, Oct 8, 2014 at 9:13 AM, Will Deacon <will.deacon@arm.com> wrote:
>>>>
>>>> On Thu, Oct 02, 2014 at 10:46:11AM +0100, AKASHI Takahiro wrote:
>>>>>
>>>>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>>>>> index fe63ac5..2842f9f 100644
>>>>> --- a/arch/arm64/kernel/ptrace.c
>>>>> +++ b/arch/arm64/kernel/ptrace.c
>>>>> @@ -1082,7 +1082,19 @@ const struct user_regset_view
>>>>> *task_user_regset_view(struct task_struct *task)
>>>>>   long arch_ptrace(struct task_struct *child, long request,
>>>>>                 unsigned long addr, unsigned long data)
>>>>>   {
>>>>> -     return ptrace_request(child, request, addr, data);
>>>>> +     int ret;
>>>>> +
>>>>> +     switch (request) {
>>>>> +             case PTRACE_SET_SYSCALL:
>>>>> +                     task_pt_regs(child)->syscallno = data;
>>>>> +                     ret = 0;
>>>>> +                     break;
>>>>> +             default:
>>>>> +                     ret = ptrace_request(child, request, addr, data);
>>>>> +                     break;
>>>>> +     }
>>>>> +
>>>>> +     return ret;
>>>>>   }
>>>>
>>>>
>>>> I still don't understand why this needs to be in arch-specific code.
>>>> Can't
>>>> we implement this in generic code and get architectures to implement
>>>> something like syscall_set_nr if they want the generic interface?
>>>
>>>
>>> Personally, I'd rather see this land as-is in the arm64 tree, and then
>>> later optimize PTRACE_SET_SYSCALL out of arm/ and arm64/, especially
>>> since only these architectures implement this at the moment.
>>
>>
>> Why? It should be really straightforward to do this in core code from the
>> get-go and experience shows that, if we don't do it now, it will never
>> happen.
>
>
> How should I deal with this issue? I would be able to go either way.

It sounds like Will would be happiest with PTRACE_SET_SYSCALL being
extracted from arm/ and arm64/ so I'd recommend doing that. It could
maybe be its own patch series, too.

> Other than that, I will submit v8 patch series with a few very minor
> updates:
> - use compat_uint_t in struct compat_siginfo
> - use a new call interface of secure_computing(void)
> - modify and clarify comments in syscall_trace_enter()

Sounds great, thank you!

-Kees

>
> Thanks,
> -Takahiro AKASHI
>
>
>>> This is my plan for the asm-generic seccomp.h too -- I'd rather avoid
>>> touching other architectures in this series, as it's easier to review
>>> this way. Then we can optimize the code in a separate series, which
>>> will have those changes isolated, etc.
>>
>>
>> But this doesn't need to touch any other architectures...
>>
>> Will
>>
>



-- 
Kees Cook
Chrome OS Security
