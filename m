Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaBTAeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:34:11 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49801 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaBTAeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:34:09 -0500
Message-ID: <53054D78.9090000@linaro.org>
Date: Thu, 20 Feb 2014 09:34:00 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "wad@chromium.org" <wad@chromium.org>, Will Deacon <Will.Deacon@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH 1/2] arm64: Add seccomp support
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org> <1391767892-5395-2-git-send-email-takahiro.akashi@linaro.org> <20140218153856.GB904@localhost> <530497DD.2020806@linaro.org> <20140219164125.GD22252@arm.com>
In-Reply-To: <20140219164125.GD22252@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 01:41 AM, Catalin Marinas wrote:
> On Wed, Feb 19, 2014 at 11:39:09AM +0000, AKASHI Takahiro wrote:
>> On 02/19/2014 12:38 AM, Catalin Marinas wrote:
>>> On Fri, Feb 07, 2014 at 10:11:31AM +0000, AKASHI Takahiro wrote:
>>>> --- a/arch/arm64/kernel/ptrace.c
>>>> +++ b/arch/arm64/kernel/ptrace.c
>>>> @@ -26,6 +26,7 @@
>>>>    #include <linux/smp.h>
>>>>    #include <linux/ptrace.h>
>>>>    #include <linux/user.h>
>>>> +#include <linux/seccomp.h>
>>>>    #include <linux/security.h>
>>>>    #include <linux/init.h>
>>>>    #include <linux/signal.h>
>>>> @@ -1064,6 +1065,10 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>>>>    {
>>>>    	unsigned long saved_reg;
>>>>
>>>> +	if (!dir && secure_computing((int)regs->syscallno))
>>>> +		/* seccomp failures shouldn't expose any additional code. */
>>>> +		return -1;
>>>
>>> That's only restricted to the arm64 code but could we use a more
>>> meaningful error number?
>>
>> Other architectures, including arm, also return just -1 in syscall_trace_enter(),
>> but of course, we can use another value, say, -EPERM or -ENOSYS?
>
> Actually we have another case of setting regs->syscallno = ~0UL in the
> same function, so we could do the same (also in line with entry.S).

I believe that I got you now, but we need to distinguish failure case of
seccomp and the existing (~0UL) case. In former case, depending on a bpf
rule loaded into the kernel, errno may be assigned to any arbitrary number
(not necessarily ENOSYS).
So I will use another value for this specific seccomp case.

Thanks,
-Takahiro AKASHI
