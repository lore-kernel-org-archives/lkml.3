Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaHVAod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 20:44:33 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44131 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaHVAoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 20:44:32 -0400
Message-ID: <53F69266.4070806@linaro.org>
Date: Fri, 22 Aug 2014 09:44:22 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Deepak Saxena <dsaxena@linaro.org>,
        arndb@arndb.de,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linaro-kernel@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 5/6] arm64: add SIGSYS siginfo for compat task
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>	<1408611405-8943-6-git-send-email-takahiro.akashi@linaro.org> <CAGXu5jLFZEWKgSVKrz=6cOfEV_2M-MwE4m+n_oOpHFZqmjRkVA@mail.gmail.com>
In-Reply-To: <CAGXu5jLFZEWKgSVKrz=6cOfEV_2M-MwE4m+n_oOpHFZqmjRkVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 02:54 AM, Kees Cook wrote:
> On Thu, Aug 21, 2014 at 3:56 AM, AKASHI Takahiro
> <takahiro.akashi@linaro.org> wrote:
>> SIGSYS is primarily used in secure computing to notify tracer.
>> This patch allows signal handler on compat task to get correct information
>> with SA_SYSINFO specified when this signal is delivered.

typo: SA_SIGINFO

>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>
> I'm unable to test this myself, but if you've got the test suite
> passing in compat mode, then this patch must be correct. :)

Thanks.
Actually I found this bug when I ran your test programs, TRAP.handler, on 32bit userland.

-Takahiro AKASHI


> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> -Kees
>
>> ---
>>   arch/arm64/include/asm/compat.h |    7 +++++++
>>   arch/arm64/kernel/signal32.c    |    8 ++++++++
>>   2 files changed, 15 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
>> index 253e33b..c877915 100644
>> --- a/arch/arm64/include/asm/compat.h
>> +++ b/arch/arm64/include/asm/compat.h
>> @@ -205,6 +205,13 @@ typedef struct compat_siginfo {
>>                          compat_long_t _band;    /* POLL_IN, POLL_OUT, POLL_MSG */
>>                          int _fd;
>>                  } _sigpoll;
>> +
>> +               /* SIGSYS */
>> +               struct {
>> +                       compat_uptr_t _call_addr; /* calling user insn */
>> +                       int _syscall;   /* triggering system call number */
>> +                       unsigned int _arch;     /* AUDIT_ARCH_* of syscall */
>> +               } _sigsys;
>>          } _sifields;
>>   } compat_siginfo_t;
>>
>> diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
>> index 1b9ad02..aa550d6 100644
>> --- a/arch/arm64/kernel/signal32.c
>> +++ b/arch/arm64/kernel/signal32.c
>> @@ -186,6 +186,14 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
>>                  err |= __put_user(from->si_uid, &to->si_uid);
>>                  err |= __put_user((compat_uptr_t)(unsigned long)from->si_ptr, &to->si_ptr);
>>                  break;
>> +#ifdef __ARCH_SIGSYS
>> +       case __SI_SYS:
>> +               err |= __put_user((compat_uptr_t)(unsigned long)
>> +                               from->si_call_addr, &to->si_call_addr);
>> +               err |= __put_user(from->si_syscall, &to->si_syscall);
>> +               err |= __put_user(from->si_arch, &to->si_arch);
>> +               break;
>> +#endif
>>          default: /* this is just in case for now ... */
>>                  err |= __put_user(from->si_pid, &to->si_pid);
>>                  err |= __put_user(from->si_uid, &to->si_uid);
>> --
>> 1.7.9.5
>>
>
>
>
