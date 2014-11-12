Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaKLKqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:46:12 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51019 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaKLKqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:46:10 -0500
Message-ID: <54633A69.6090202@linaro.org>
Date: Wed, 12 Nov 2014 19:46:01 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: roland@hack.frob.com, linux@arm.linux.org.uk, will.deacon@arm.com,
        dsaxena@linaro.org, keescook@chromium.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org> <20141107140405.GA30156@redhat.com>
In-Reply-To: <20141107140405.GA30156@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On 11/07/2014 11:04 PM, Oleg Nesterov wrote:
> On 11/07, AKASHI Takahiro wrote:
>>
>> --- a/arch/arm/kernel/ptrace.c
>> +++ b/arch/arm/kernel/ptrace.c
>> @@ -853,11 +853,6 @@ long arch_ptrace(struct task_struct *child, long request,
>>   				       datap);
>>   			break;
>>
>> -		case PTRACE_SET_SYSCALL:
>> -			task_thread_info(child)->syscall = data;
>> -			ret = 0;
>> -			break;
>> -
>>   #ifdef CONFIG_CRUNCH
>>   		case PTRACE_GETCRUNCHREGS:
>>   			ret = ptrace_getcrunchregs(child, datap);
>> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
>> index 54e7522..d7048fa 100644
>> --- a/kernel/ptrace.c
>> +++ b/kernel/ptrace.c
>> @@ -1001,6 +1001,12 @@ int ptrace_request(struct task_struct *child, long request,
>>   		break;
>>   	}
>>   #endif
>> +
>> +#ifdef PTRACE_SET_SYSCALL
>> +	case PTRACE_SET_SYSCALL:
>> +		ret = syscall_set_nr(child, task_pt_regs(child), data);
>> +		break;
>> +#endif
>
> I too do not understand why it makes sense to move PTRACE_SET_SYSCALL into
> the common kernel/ptrace.c.

I think I explained why we need a new (atomic) interface of changing a system
call number while tracing with ptrace. But I don't have a strong preference,
either ptrace(SET_SYSCALL) or ptrace(SETREGSET, NT_SYSTEM_CALL).

> To me the fact that PTRACE_SET_SYSCALL can be undefined and syscall_set_nr()
> is very much arch-dependant (but most probably trivial) means that this  code
> should live in arch_ptrace().

Thinking of Oleg's comment above, it doesn't make sense neither to define generic
NT_SYSTEM_CALL (user_regset) in uapi/linux/elf.h and implement it in ptrace_regset()
in kernel/ptrace.c with arch-defined syscall_(g)set_nr().

Since we should have the same interface on arm and arm64, we'd better implement
ptrace(PTRACE_SET_SYSCALL) locally on arm64 for now (as I originally submitted).

-Takahiro AKASHI

> In any case, I think it doesn't make sense to pass task_pt_regs(child), this
> helper can do this itself if it needs struct pt_regs.
>
> Oleg.
>
