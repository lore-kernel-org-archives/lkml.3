Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaCNQQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:16:06 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:60922 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915AbaCNQPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:15:13 -0400
Message-ID: <53232B0A.6080906@linaro.org>
Date: Sat, 15 Mar 2014 01:15:06 +0900
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
Subject: Re: [PATCH v6 6/7] arm64: ftrace: Add CALLER_ADDRx macros
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org> <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org> <1394705630-12384-7-git-send-email-takahiro.akashi@linaro.org> <20140313155415.GB25472@mudshark.cambridge.arm.com> <532270BE.6000409@linaro.org> <20140314100914.GD13541@arm.com>
In-Reply-To: <20140314100914.GD13541@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 07:09 PM, Will Deacon wrote:
> On Fri, Mar 14, 2014 at 03:00:14AM +0000, AKASHI Takahiro wrote:
>> On 03/14/2014 12:54 AM, Will Deacon wrote:
>>> On Thu, Mar 13, 2014 at 10:13:49AM +0000, AKASHI Takahiro wrote:
>>>> CALLER_ADDRx returns caller's address at specified level in call stacks.
>>>> They are used for several tracers like irqsoff and preemptoff.
>>>> Strange to say, however, they are refered even without FTRACE.
>>>>
>>>> Please note that this implementation assumes that we have frame pointers.
>>>> (which means kernel should be compiled with -fno-omit-frame-pointer.)
>>>
>>> How do you ensure that -fno-omit-frame-pointer is passed?
>>
>> arm64 selects ARCH_WANT_FRAME_POINTERS, then FRAME_POINTER is on (lib/Kconfig.debug)
>> and so -fno-omit-frame-pointer is appended (${TOP}/Makefile).
>> (stacktrace.c also assumes FRAME_POINTER.)
>>
>> Do you think I should remove the comment above?
>
> Yes please, it sounds like everything is taken care of automatically, so
> there's no need to scare people in the commit message!

OK, I will do so.

Thanks,
-Takahiro AKASHI

>>>> diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
>>>> index ed5c448..c44c4b1 100644
>>>> --- a/arch/arm64/include/asm/ftrace.h
>>>> +++ b/arch/arm64/include/asm/ftrace.h
>>>> @@ -18,6 +18,7 @@
>>>>
>>>>    #ifndef __ASSEMBLY__
>>>>    extern void _mcount(unsigned long);
>>>> +extern void *return_address(unsigned int);
>>>>
>>>>    struct dyn_arch_ftrace {
>>>>    	/* No extra data needed for arm64 */
>>>> @@ -33,6 +34,16 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
>>>>    	 */
>>>>    	return addr;
>>>>    }
>>>> -#endif /* __ASSEMBLY__ */
>>>> +
>>>> +#define HAVE_ARCH_CALLER_ADDR
>>>> +
>>>> +#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
>>>> +#define CALLER_ADDR1 ((unsigned long)return_address(1))
>>>> +#define CALLER_ADDR2 ((unsigned long)return_address(2))
>>>> +#define CALLER_ADDR3 ((unsigned long)return_address(3))
>>>> +#define CALLER_ADDR4 ((unsigned long)return_address(4))
>>>> +#define CALLER_ADDR5 ((unsigned long)return_address(5))
>>>> +#define CALLER_ADDR6 ((unsigned long)return_address(6))
>>>
>>> Could we change the core definitions of these macros (in linux/ftrace.h) to
>>> use return_address, then provide an overridable version of return_address
>>> that defaults to __builtin_return_address, instead of copy-pasting this
>>> sequence?
>>
>> I think I understand what you mean, and will try to post a separate RFC,
>> but I also want to hold off this change on this patch since such a change
>> may raise a small controversy from other archs' maintainers.
>
> I don't see anything controversial here, but ok. Steve already posted
> something you can get started with.
>
> Will
>
