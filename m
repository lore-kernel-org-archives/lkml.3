Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbaGYIw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:52:29 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37183 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaGYIw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:52:26 -0400
Message-ID: <53D21AC1.8050805@linaro.org>
Date: Fri, 25 Jul 2014 17:52:17 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Deepak Saxena <dsaxena@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linaro-kernel@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 2/3] asm-generic: Add generic seccomp.h for secure
 computing mode 1
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org> <1406020499-5537-3-git-send-email-takahiro.akashi@linaro.org> <53D0802A.7070703@amacapital.net> <CAGXu5j+GuoxR5o8CZZFZAEwQA=rRwBmBM-ZDU+nFAfHoqf8z9Q@mail.gmail.com> <53D096D0.2000708@linaro.org> <CALCETrV9zJ=0_kg7-zuPDUxf_uHmsf+avrd2-cypuLYhtEPt6g@mail.gmail.com>
In-Reply-To: <CALCETrV9zJ=0_kg7-zuPDUxf_uHmsf+avrd2-cypuLYhtEPt6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 11:57 PM, Andy Lutomirski wrote:
> On Jul 23, 2014 10:17 PM, "AKASHI Takahiro" <takahiro.akashi@linaro.org> wrote:
>>
>> On 07/24/2014 01:41 PM, Kees Cook wrote:
>>>
>>> On Wed, Jul 23, 2014 at 8:40 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>
>>>> On 07/22/2014 02:14 AM, AKASHI Takahiro wrote:
>>>>>
>>>>>
>>>>> Those values (__NR_seccomp_*) are used solely in secure_computing()
>>>>> to identify mode 1 system calls. If compat system calls have different
>>>>> syscall numbers, asm/seccomp.h may override them.
>>>>>
>>>>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>>>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>>>>> ---
>>>>>     include/asm-generic/seccomp.h |   28 ++++++++++++++++++++++++++++
>>>>>     1 file changed, 28 insertions(+)
>>>>>     create mode 100644 include/asm-generic/seccomp.h
>>>>>
>>>>> diff --git a/include/asm-generic/seccomp.h b/include/asm-generic/seccomp.h
>>>>> new file mode 100644
>>>>> index 0000000..5e97022
>>>>> --- /dev/null
>>>>> +++ b/include/asm-generic/seccomp.h
>>>>> @@ -0,0 +1,28 @@
>>>>> +/*
>>>>> + * include/asm-generic/seccomp.h
>>>>> + *
>>>>> + * Copyright (C) 2014 Linaro Limited
>>>>> + * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
>>>>> + *
>>>>> + * This program is free software; you can redistribute it and/or modify
>>>>> + * it under the terms of the GNU General Public License version 2 as
>>>>> + * published by the Free Software Foundation.
>>>>> + */
>>>>> +#ifndef _ASM_GENERIC_SECCOMP_H
>>>>> +#define _ASM_GENERIC_SECCOMP_H
>>>>> +
>>>>> +#include <asm-generic/unistd.h>
>>>>> +
>>>>> +#if defined(CONFIG_COMPAT) && !defined(__NR_seccomp_read_32)
>>>>> +#define __NR_seccomp_read_32           __NR_read
>>>>> +#define __NR_seccomp_write_32          __NR_write
>>>>> +#define __NR_seccomp_exit_32           __NR_exit
>>>>> +#define __NR_seccomp_sigreturn_32      __NR_rt_sigreturn
>>>>> +#endif /* CONFIG_COMPAT && ! already defined */
>>>>> +
>>>>> +#define __NR_seccomp_read              __NR_read
>>>>> +#define __NR_seccomp_write             __NR_write
>>>>> +#define __NR_seccomp_exit              __NR_exit
>>>>> +#define __NR_seccomp_sigreturn         __NR_rt_sigreturn
>>>>
>>>>
>>>>
>>>> I don't like these names.  __NR_seccomp_read sounds like the number of a
>>>> syscall called seccomp_read.
>>>>
>>>> Also, shouldn't something be including this header?  I'm confused.
>>>
>>>
>>> Ah! Good catch. These names are correct (see kernel/seccomp.c's
>>> mode1_syscalls and mode1_syscalls_32 arrays), but the location of this
>>> change was unexpected. I was expecting this file to live in
>>> arch/*/include/asm/seccomp.h, not in include/asm-generic/seccomp.h.
>>>
>>> However, since it's always the same list, it might make sense to
>>> consolidate them into a single place as a default to make arch porting
>>> easier.
>>
>>
>> Yeah, that is why I put this file under include/asm-generic.
>
> It seems odd that the header would be added without any users.  I
> guess it's okay, since arm64 uses it in the followup patch.
>
>>
>>> However, I think that should be a separate patch.
>>
>>
>> Do you mean that the code for all the existing archs should also be changed
>> to use this (common) header?
>
> If that works, yes.

As is often the case, the patch itself is quite simple, but I can't
test it on other architectures.

-Takahiro AKASHI

> --Andy
>
>>
>> -Takahiro AKASHI
>>>
>>>
>>> -Kees
>>>
