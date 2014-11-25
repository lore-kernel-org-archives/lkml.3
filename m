Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaKYHmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:42:20 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40997 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaKYHmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:42:19 -0500
Message-ID: <547432D2.7000909@linaro.org>
Date: Tue, 25 Nov 2014 16:42:10 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 2/6] arm64: ptrace: allow tracer to skip a system call
References: <1416273038-15590-1-git-send-email-takahiro.akashi@linaro.org> <1416273038-15590-3-git-send-email-takahiro.akashi@linaro.org> <20141118140425.GM18842@arm.com> <546C58DB.5080204@linaro.org> <20141119190601.GM15985@arm.com> <546D7860.2010300@linaro.org> <20141120191738.GV19126@arm.com>
In-Reply-To: <20141120191738.GV19126@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 04:17 AM, Will Deacon wrote:
> On Thu, Nov 20, 2014 at 05:13:04AM +0000, AKASHI Takahiro wrote:
>> On 11/20/2014 04:06 AM, Will Deacon wrote:
>>> On Wed, Nov 19, 2014 at 08:46:19AM +0000, AKASHI Takahiro wrote:
>>>> Syscall(-1) will return -ENOSYS whether or not a syscallno is explicitly
>>>> replaced with -1 by a tracer, and, in this sense, it is *skipped*.
>>>
>>> Ok, but now userspace sees -ENOSYS for a skipped system call in that case,
>>> whereas it would usually see whatever the trace put in x0, right?
>>
>> If you don't really like this behavior, how about this patch instead of my [2/6] patch?
>>
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index 726b910..1ef57d0 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -668,8 +668,15 @@ ENDPROC(el0_svc)
>>            * switches, and waiting for our parent to respond.
>>            */
>>    __sys_trace:
>> +       cmp     w8, #-1                         // default errno for invalid
>> +       b.ne    1f                              // system call
>> +       mov     x0, #-ENOSYS
>> +       str     x0, [sp, #S_X0]
>> +1:
>>           mov     x0, sp
>>           bl      syscall_trace_enter
>> +       cmp     w0, #-1                         // skip the syscall?
>> +       b.eq    __sys_trace_return_skipped
>>           adr     lr, __sys_trace_return          // return address
>>           uxtw    scno, w0                        // syscall number (possibly new)
>>           mov     x1, sp                          // pointer to regs
>> @@ -684,6 +691,7 @@ __sys_trace:
>>
>>    __sys_trace_return:
>>           str     x0, [sp]                        // save returned x0
>> +__sys_trace_return_skipped:
>>           mov     x0, sp
>>           bl      syscall_trace_exit
>>           b       ret_to_user
>>
>> With this change, I believe, syscall(-1) returns -ENOSYS by default whether traced
>> or not, and still you can change a return value when tracing.
>> (But a drawback here is that a tracer will see -ENOSYS in x0 even at syscall entry
>> for syscall(-1).)
>
> But it's exactly these drawbacks that I'm objected to. syscall(-1) shouldn't
> be treated any differently to syscall(42) with respect to restarting,
> exactly like x86.

Can you elaborate a bit more as to "restarting?"
We can't make any assumption about the number of arguments taken by *invalid* syscall(-1)
and so changing a value in x0 (or any other registers) doesn't make any difference.
()

-Takahiro AKASHI

> Will
>
