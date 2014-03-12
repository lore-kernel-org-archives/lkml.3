Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbaCLBrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:47:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59240 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbaCLBrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:47:33 -0400
Message-ID: <531FBCA8.2080805@linaro.org>
Date: Wed, 12 Mar 2014 10:47:20 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0/7] arm64: Add ftrace support
References: <1393320196-2942-1-git-send-email-takahiro.akashi@linaro.org> <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org> <20140311143535.GE7944@mudshark.cambridge.arm.com>
In-Reply-To: <20140311143535.GE7944@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/11/2014 11:35 PM, Will Deacon wrote:
> Hi Akashi,
>
> On Fri, Feb 28, 2014 at 05:18:37AM +0000, AKASHI Takahiro wrote:
>> This patchset implements a function tracer on arm64.
>> There was another implementation from Cavium network, but both of us agreed
>> to use my patchset as future base. He is supposed to review this code, too.
>>
>> The only issue that I had some concern on was "fault protection" code
>> in prepare_ftrace_return(). With discussions with Steven and Tim (as author
>> of arm ftrace), I removed that code since I'm not quite sure about possibility
>> of "fault" occurrences in this function.
>>
>> The code is tested on ARMv8 Fast Model with the following tracers & events:
>>       function tracer with dynamic ftrace
>>       function graph tracer with dynamic ftrace
>>       syscall tracepoint
>>       irqsoff & preemptirqsoff (which use CALLER_ADDRx)
>> and also verified with in-kernel tests, FTRACE_SELFTEST, FTRACE_STARTUP_TEST
>> and EVENT_TRACE_TEST_SYSCALLS.
>>
>> Prerequisites are:
>>   * "arm64: Add regs_return_value() in syscall.h"
>>   * "arm64: make a single hook to syscall_trace() for all syscall features" patch
>
> It looks like there might be some more dependencies that that. Do you have a
> branch anywhere containing this series, along with all the dependencies so I
> can have a play?

I think you saw the following messages:

 >   HOSTCC  scripts/recordmcount
 > /.../linux-aarch64/scripts/recordmcount.c: In function 'do_file':
 > /.../linux-aarch64/scripts/recordmcount.c:350:7: error:
 > 'EM_AARCH64' undeclared (first use in this function)
 > /.../linux-aarch64/scripts/recordmcount.c:350:7: note:
 > each undeclared identifier is reported only once for each function it appears in
 > /.../linux-aarch64/scripts/recordmcount.c:351:15: error:
 > 'R_AARCH64_ABS64' undeclared (first > use in this function)
 > make[2]: *** [scripts/recordmcount] Error 1
 > make[1]: *** [scripts] Error 2
 > make: *** [sub-make] Error 2

This happens when a header file, elf.h, on "your host machine" does not have
definitions of EM_AARCH64 nor R_AARCH64_ABS64 because "recordmcount" is a binary
utility on host(x86), not target. It is very likely for most distros.
(I mentioned this in the cover letter, but the description might not be clear.)

Possible solutions are:
1) Define both macros directly in scripts/recordmcount.c
2) Use perl version of recordmcount

Currently I take 1), but it is a workaround.
2) should work with my current patch, too. But you need to remove HAVE_C_RECORDCOUNT
from arm64/Kconfig.

Which one do you prefer? I will include a fix for 1) in the next revision, anyway.

Thanks,
-Takahiro AKASHI

> Cheers,
>
> Will
>
