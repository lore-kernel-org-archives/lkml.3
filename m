Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083AbaGJEe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 00:34:58 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58184 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaGJEe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 00:34:57 -0400
Message-ID: <53BE17AE.7080301@linaro.org>
Date: Thu, 10 Jul 2014 06:33:50 +0200
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "wad@chromium.org" <wad@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH v4 2/2] arm64: Add seccomp support
References: <1404459115-8292-1-git-send-email-takahiro.akashi@linaro.org> <1404459115-8292-3-git-send-email-takahiro.akashi@linaro.org> <20140709111239.GH9485@arm.com>
In-Reply-To: <20140709111239.GH9485@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

 >  (1) Updating syscallno based on w8, but this ties us to the current ABI
 >      and could get messy if this register changes in the future.

So, is this the conclusion that I should follow?

-Takahiro AKASHI


On 07/09/2014 01:12 PM, Will Deacon wrote:
> Hi Akashi,
>
> On Fri, Jul 04, 2014 at 08:31:55AM +0100, AKASHI Takahiro wrote:
>> secure_computing() should always be called first in syscall_trace_enter().
>> If it returns non-zero, we should stop further handling. Then that system
>> call may eventually fail, be trapped or the process itself be killed
>> depending on loaded rules.
>> In this case, syscall_trace_enter() returns a dedicated value in order to
>> skip a normal syscall table lookup because a seccomp rule may have already
>> overridden errno.
>
> [...]
>
>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>> index 70526cf..baab5fc 100644
>> --- a/arch/arm64/kernel/ptrace.c
>> +++ b/arch/arm64/kernel/ptrace.c
>> @@ -21,12 +21,14 @@
>>
>>   #include <linux/audit.h>
>>   #include <linux/compat.h>
>> +#include <linux/errno.h>
>>   #include <linux/kernel.h>
>>   #include <linux/sched.h>
>>   #include <linux/mm.h>
>>   #include <linux/smp.h>
>>   #include <linux/ptrace.h>
>>   #include <linux/user.h>
>> +#include <linux/seccomp.h>
>>   #include <linux/security.h>
>>   #include <linux/init.h>
>>   #include <linux/signal.h>
>> @@ -1109,6 +1111,10 @@ static void tracehook_report_syscall(struct pt_regs *regs,
>>
>>   asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>>   {
>> +	if (secure_computing(regs->syscallno) == -1)
>> +		/* seccomp failures shouldn't expose any additional code. */
>> +		return -EPERM;
>> +
>>   	if (test_thread_flag(TIF_SYSCALL_TRACE))
>>   		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
>
> We return regs->syscallno immediately after this, so we have the same issue
> that Kees identified for arch/arm/. Did you follow the discussion I had with
> Andy?
>
> Will
>
