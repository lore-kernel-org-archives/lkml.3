Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab3AOD0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:26:10 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:38078 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab3AOD0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:26:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAFTL4hxCNqCAbF6+Ny_-0jfL2G2ie8O6Be_7KtYymvJzyJGyCw@mail.gmail.com>
References: <1357941108-14138-1-git-send-email-ccross@android.com>
	<CAFTL4hzYkPCmkfqBafkTA5E_snkLoC_y3p9xwumj=L1xWAWK0g@mail.gmail.com>
	<CAMbhsRQv=ogNmkK=Np6JGM-iuG=aocqb_4aMBC6CW5mpkGvpmw@mail.gmail.com>
	<CAFTL4hxnCn13PigcWjrcnSV9RAz5gSX-VtQk9J8HEbQco7jbbQ@mail.gmail.com>
	<CAMbhsRQiK=rChiNdwM5M6t=1v_iKwYLhUn=HLW5kSkBzQdso8g@mail.gmail.com>
	<CAFTL4hxCNqCAbF6+Ny_-0jfL2G2ie8O6Be_7KtYymvJzyJGyCw@mail.gmail.com>
Date: Mon, 14 Jan 2013 19:26:07 -0800
X-Google-Sender-Auth: -c8zGusUx9hhx65PbQhKifIhu5c
Message-ID: <CAMbhsRTHRV8ty7HOYbnrH4-EESrqKQ2CMxYz3=oR=WfNEYr4LQ@mail.gmail.com>
Subject: Re: [PATCH v2] hardlockup: detect hard lockups without NMIs using
 secondary cpus
From: Colin Cross <ccross@android.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        liu chuansheng <chuansheng.liu@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 6:48 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/1/15 Colin Cross <ccross@android.com>:
>> On Mon, Jan 14, 2013 at 4:25 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>> 2013/1/15 Colin Cross <ccross@android.com>:
>>>> On Mon, Jan 14, 2013 at 4:13 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>>> I believe this is pretty much what the RCU stall detector does
>>>>> already: checks for other CPUs being responsive. The only difference
>>>>> is on how it checks that. For RCU it's about checking for CPUs
>>>>> reporting quiescent states when requested to do so. In your case it's
>>>>> about ensuring the hrtimer interrupt is well handled.
>>>>>
>>>>> One thing you can do is to enqueue an RCU callback (cal_rcu()) every
>>>>> minute so you can force other CPUs to report quiescent states
>>>>> periodically and thus check for lockups.
>>>>
>>>> That's a good point, I'll take a look at using that.  A minute is too
>>>> long, some SoCs have maximum HW watchdog periods of under 30 seconds,
>>>> but a call_rcu every 10-20 seconds might be sufficient.
>>>
>>> Sure. And you can tune CONFIG_RCU_CPU_STALL_TIMEOUT accordingly.
>>
>> After considering this, I think the hrtimer watchdog is more useful.
>> RCU stalls are not usually panic events, and I wouldn't want to add a
>> panic on every RCU stall.  The lack of stack traces on the affected
>> cpu makes a panic important.  I'm planning to add an ARM DBGPCSR panic
>> handler, which will be able to dump the PC of a stuck cpu even if it
>> is not responding to interrupts.  kexec or kgdb on panic might also
>> allow some inspection of the stack on stuck cpu.
>>
>> Failing to process interrupts is a much more serious event than an RCU
>> stall, and being able to detect them separately may be very valuable
>> for debugging.
>
> RCU stalls can happen for different reasons: softlockup (failure to
> schedule another task), hardlockup (failure to process interrupts), or
> a bug in RCU itself. But if you have a hardlockup, it will report it.

It will report it, but it will report it in the same way that it
reports a less serious issue, and in this case with zero debugging
information since the affected cpu won't dump its backtrace.  Better
than nothing, but not as useful as a panic can be.

> Now why do you need a panic in any case? I don't know DBGPCSR, is this
> a breakpoint register? How do you plan to use it remotely from the CPU
> that detects the lockup?

Panics can trigger extra debugging tools, like my previous examples
kexec and kgdb.

DBGPCSR is the "DeBuG Program Counter Sampling Register".  It is a
memory mapped register available on many (all?) ARM Cortex cpus that
returns a recent PC value for the cpu.  I have used it along with this
patch, and it produces very useful information.
