Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbaGXF5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 01:57:21 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44110 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaGXF5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 01:57:20 -0400
Message-ID: <53D0A037.2060308@linaro.org>
Date: Thu, 24 Jul 2014 14:57:11 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, wad@chromium.org,
        catalin.marinas@arm.com, will.deacon@arm.com, keescook@chromium.org
CC: dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] arm64: ptrace: reload a syscall number after ptrace
 operations
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org> <1406020499-5537-2-git-send-email-takahiro.akashi@linaro.org> <53D08358.4020902@amacapital.net>
In-Reply-To: <53D08358.4020902@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 12:54 PM, Andy Lutomirski wrote:
> On 07/22/2014 02:14 AM, AKASHI Takahiro wrote:
>> Arm64 holds a syscall number in w8(x8) register. Ptrace tracer may change
>> its value either to:
>>    * any valid syscall number to alter a system call, or
>>    * -1 to skip a system call
>>
>> This patch implements this behavior by reloading that value into syscallno
>> in struct pt_regs after tracehook_report_syscall_entry() or
>> secure_computing(). In case of '-1', a return value of system call can also
>> be changed by the tracer setting the value to x0 register, and so
>> sys_ni_nosyscall() should not be called.
>>
>> See also:
>>      42309ab4, ARM: 8087/1: ptrace: reload syscall number after
>>           secure_computing() check
>>
>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> ---
>>   arch/arm64/kernel/entry.S  |    2 ++
>>   arch/arm64/kernel/ptrace.c |   13 +++++++++++++
>>   2 files changed, 15 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index 5141e79..de8bdbc 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -628,6 +628,8 @@ ENDPROC(el0_svc)
>>   __sys_trace:
>>       mov    x0, sp
>>       bl    syscall_trace_enter
>> +    cmp    w0, #-1                // skip syscall?
>> +    b.eq    ret_to_user
>
> Does this mean that skipped syscalls will cause exit tracing to be skipped?

Yes. (and I guess yes on arm, too)

 > If so, then you risk (at least) introducing
> a nice user-triggerable OOPS if audit is enabled.

Can you please elaborate this?
Since I didn't find any definition of audit's behavior when syscall is
rewritten to -1, I thought it is reasonable to skip "exit tracing" of
"skipped" syscall.
(otherwise, "fake" seems to be more appropriate :)

-Takahiro AKASHI

> This bug existed for *years* on x86_32, and it amazes me that no one
> ever triggered it by accident. (Grr, audit.)
>
> --Andy
