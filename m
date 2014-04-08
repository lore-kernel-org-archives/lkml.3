Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbaDHTvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:51:13 -0400
Received: from smtp2.ngi.it ([88.149.128.113]:51884 "EHLO smtp2.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233AbaDHTvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:51:11 -0400
Message-ID: <53445343.1040907@katamail.com>
Date: Tue, 08 Apr 2014 21:51:31 +0200
From: Michele Ballabio <barra_cuda@katamail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-1?Q?Toralf_F=F6rs?= =?ISO-8859-1?Q?ter?= 
	<toralf.foerster@gmx.de>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: Bisected KVM hang on x86-32 between v3.12 and v3.13
References: <5341707F.5000406@katamail.com> <20140407150337.GO10526@twins.programming.kicks-ass.net> <20140407150705.GB13658@twins.programming.kicks-ass.net> <5342EB78.3060002@gmx.de> <20140407185658.GK11096@twins.programming.kicks-ass.net> <20140408122128.GC13658@twins.programming.kicks-ass.net> <53444A9F.9060207@katamail.com>
In-Reply-To: <53444A9F.9060207@katamail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 21:14, Michele Ballabio wrote:
> On 08/04/2014 14:21, Peter Zijlstra wrote:
>> On Mon, Apr 07, 2014 at 08:56:58PM +0200, Peter Zijlstra wrote:
>>> On Mon, Apr 07, 2014 at 08:16:24PM +0200, Toralf Förster wrote:
>>>
>>>> v3.14-10353-g2b3a8fd works fine AFAICS
>>>> (BTW the fix is stable material, right ?)
>>>
>>> I'm fairly sure its not; its a rather invasive series; see:
>>>
>>> 2432e1364bbe x86: Nuke the supervisor_stack field in i386 thread_info
>>> b807902a88c4 x86: Nuke GET_THREAD_INFO_WITH_ESP() macro for i386
>>> 0788aa6a23cb x86: Prepare removal of previous_esp from i386 thread_info structure
>>> 198d208df437 x86: Keep thread_info on thread stack in x86_32
>>>
>>> Let me see if there's anything 'simpler' we can stuff in .13+
>>
>> OK.. so could someone test the below patch to see if that makes things
>> work for .13 and .14?
>>
>> ---
>>  arch/x86/include/asm/preempt.h | 11 +++++++++++
>>  include/linux/preempt.h        |  4 ++++
>>  include/linux/thread_info.h    |  2 --
>>  3 files changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
>> index c8b051933b1b..7ada46d8d4d8 100644
>> --- a/arch/x86/include/asm/preempt.h
>> +++ b/arch/x86/include/asm/preempt.h
>> @@ -5,6 +5,17 @@
>>  #include <asm/percpu.h>
>>  #include <linux/thread_info.h>
>>  
>> +#ifdef CONFIG_X86_32
>> +/*
>> + * i386's current_thread_info() depends on ESP and for interrupt/exception
>> + * stacks this doesn't yield the actual task thread_info.
>> + *
>> + * We hard rely on the fact that all the TIF_NEED_RESCHED bits are
>> + * the same, therefore use the slightly more expensive version below.
>> + */
>> +#define tif_need_resched() test_tsk_thread_flag(current, TIF_NEED_RESCHED)
>> +#endif
>> +
>>  DECLARE_PER_CPU(int, __preempt_count);
>>  
>>  /*
>> diff --git a/include/linux/preempt.h b/include/linux/preempt.h
>> index de83b4eb1642..891c8f8b52fe 100644
>> --- a/include/linux/preempt.h
>> +++ b/include/linux/preempt.h
>> @@ -17,6 +17,10 @@
>>  
>>  #include <asm/preempt.h>
>>  
>> +#ifndef tif_need_resched
>> +#define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
>> +#endif
>> +
>>  #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
>>  extern void preempt_count_add(int val);
>>  extern void preempt_count_sub(int val);
>> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
>> index fddbe2023a5d..a629e4b23217 100644
>> --- a/include/linux/thread_info.h
>> +++ b/include/linux/thread_info.h
>> @@ -118,8 +118,6 @@ static inline __deprecated void set_need_resched(void)
>>  	 */
>>  }
>>  
>> -#define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
>> -
>>  #if defined TIF_RESTORE_SIGMASK && !defined HAVE_SET_RESTORE_SIGMASK
>>  /*
>>   * An arch can define its own version of set_restore_sigmask() to get the
>>
> 
> It works fine for me on top of v3.14.

And on top of v3.13, too.

Thanks.

