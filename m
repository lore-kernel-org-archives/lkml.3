Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbaCFCe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:34:56 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:34012 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbaCFCez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:34:55 -0500
Message-ID: <5317DEC6.4060103@linaro.org>
Date: Thu, 06 Mar 2014 11:34:46 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "wad@chromium.org" <wad@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] arm64: Add seccomp support
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org> <1393320025-2855-1-git-send-email-takahiro.akashi@linaro.org> <1393320025-2855-3-git-send-email-takahiro.akashi@linaro.org> <20140228172006.GF30996@mudshark.cambridge.arm.com>
In-Reply-To: <20140228172006.GF30996@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2014 02:20 AM, Will Deacon wrote:
> On Tue, Feb 25, 2014 at 09:20:24AM +0000, AKASHI Takahiro wrote:
>> secure_computing() should always be called first in syscall_trace(), and
>> if it returns non-zero, we should stop further handling. Then that system
>> call may eventually fail, be trapped or the process itself be killed
>> depending on loaded rules.
>
> [...]
>
>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>> index d4ce70e..f2a74bc 100644
>> --- a/arch/arm64/kernel/ptrace.c
>> +++ b/arch/arm64/kernel/ptrace.c
>> @@ -20,12 +20,14 @@
>>    */
>>
>>   #include <linux/audit.h>
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
>> @@ -1064,6 +1066,10 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>>   {
>>   	unsigned long saved_reg;
>>
>> +	if (!dir && secure_computing((int)regs->syscallno))
>
> Why do you need this cast to (int)?

OK. I will remove it because gcc doesn't complain about it anyway.

> Also, it's probably better to check for
> -1 explicitly here.

I wil fix it.

> I'm slightly surprised that we do the secure computing check first. Doesn't
> this allow a debugger to change the syscall to something else after we've
> decided that it's ok?

To be honest, I just followed other architectures' implementation.
Can you elaborate any use case that you have in your mind?

-Takahiro AKASHI

> Will
>
