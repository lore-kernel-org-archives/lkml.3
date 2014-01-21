Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaAUQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:09:27 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:17817 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbaAUQJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:09:24 -0500
Message-ID: <52DE9BB0.5070909@hp.com>
Date: Tue, 21 Jan 2014 11:09:20 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, aswin@hp.com,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v9 3/5] qrwlock, x86 - Treat all data type not bigger
 than long as atomic in x86
References: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com> <1389761047-47566-4-git-send-email-Waiman.Long@hp.com> <20140120150316.GG30183@twins.programming.kicks-ass.net> <52DE9410.6090500@hp.com> <20140121153958.GA31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140121153958.GA31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 10:39 AM, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 10:36:48AM -0500, Waiman Long wrote:
>> On 01/20/2014 10:03 AM, Peter Zijlstra wrote:
>>> On Tue, Jan 14, 2014 at 11:44:05PM -0500, Waiman Long wrote:
>>>> The generic __native_word() macro defined in include/linux/compiler.h
>>>> only allows "int" and "long" data types to be treated as native and
>>>> atomic. The x86 architecture, however, allow the use of char and short
>>>> data types as atomic as well.
>>>>
>>>> This patch extends the data type allowed in the __native_word() macro to
>>>> allow the use of char and short.
>>>>
>>>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>>>> ---
>>>>   arch/x86/include/asm/barrier.h |    8 ++++++++
>>>>   1 files changed, 8 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
>>>> index 04a4890..4d3e30a 100644
>>>> --- a/arch/x86/include/asm/barrier.h
>>>> +++ b/arch/x86/include/asm/barrier.h
>>>> @@ -24,6 +24,14 @@
>>>>   #define wmb()	asm volatile("sfence" ::: "memory")
>>>>   #endif
>>>>
>>>> +/*
>>>> + * All data types<= long are atomic in x86
>>>> + */
>>>> +#ifdef __native_word
>>>> +#undef __native_word
>>>> +#endif
>>>> +#define __native_word(t)	(sizeof(t)<= sizeof(long))
>>> Yeah, not going to happen.
>> Does explicit list of acceptable sizes work for you?
>>
>> #define __native_word(t) (sizeof(t) == sizeof(char) || sizeof(t) ==
>> sizeof(short) || sizeof(t) == sizeof(int ) ||
>>                   sizeof(t) == sizeof(long))
> No, generic primitives should not have arch specific behaviour.

OK, will something like the following acceptable to you:

arch/x86/include/asm/barrier.h:

#define __arch_native_word(t) (sizeof(t) == sizeof(char) || sizeof(t) ==
sizeof(short) || sizeof(t) == sizeof(int ) ||
                  sizeof(t) == sizeof(long))

include/linux/compiler.h:

#ifndef __native_word
# ifdef __arch_native_word(t)
#  define __native_word(t)	__arch_native_word(t)
# else
#  define __native_word(t) (sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
# endif
#endif

-Longman




