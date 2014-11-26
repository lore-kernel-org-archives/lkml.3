Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaKZS7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:59:43 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:40472 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaKZS7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:59:42 -0500
MIME-Version: 1.0
In-Reply-To: <5476120D.9030703@linaro.org>
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org>
	<20141120135851.GA32528@linaro.org>
	<54759041.9080105@hitachi.com>
	<20141126100325.GA9157@linaro.org>
	<5476120D.9030703@linaro.org>
Date: Wed, 26 Nov 2014 18:59:41 +0000
Message-ID: <CAPvkgC3eVOZEn79C9PC9c7TqC_-yCtDhw5LL6ZWUJxr+oQFaow@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
From: Steve Capper <steve.capper@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        William Cohen <wcohen@redhat.com>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2014 at 17:46, David Long <dave.long@linaro.org> wrote:
> On 11/26/14 05:03, Steve Capper wrote:
>>
>> On Wed, Nov 26, 2014 at 05:33:05PM +0900, Masami Hiramatsu wrote:
>>>
>>> (2014/11/21 0:02), Steve Capper wrote:
>>>>
>>>> On Tue, Nov 18, 2014 at 01:32:50AM -0500, David Long wrote:
>>>>>
>>>>> From: "David A. Long" <dave.long@linaro.org>
>>>>>
>>>>> This patchset is heavily based on Sandeepa Prabhu's ARM v8 kprobes
>>>>> patches, first
>>>>> seen in October 2013.  This version attempts to address concerns raised
>>>>> by
>>>>> reviewers and also fixes problems discovered during testing,
>>>>> particularly during
>>>>> SMP testing.
>>>>>
>>>>> This patchset adds support for kernel probes(kprobes), jump
>>>>> probes(jprobes)
>>>>> and return probes(kretprobes) support for ARM64.
>>>>>
>>>>> Kprobes mechanism makes use of software breakpoint and single stepping
>>>>> support available in the ARM v8 kernel.
>>>>>
>>>>> Changes since v2 include:
>>>>>
>>>>> 1) Removal of NOP padding in kprobe XOL slots.  Slots are now exactly
>>>>> one
>>>>> instruction long.
>>>>> 2) Disabling of interrupts during execution in single-step mode.
>>>>> 3) Fixing of numerous problems in instruction simulation code.
>>>>> 4) Support for the HAVE_REGS_AND_STACK_ACCESS_API feature is added, to
>>>>> allow
>>>>> access to kprobes through debugfs.
>>>>> 5) kprobes is *not* enabled in defconfig.
>>>>> 6) Numerous complaints from checkpatch have been cleaned up, although a
>>>>> couple
>>>>> remain as removing the function pointer typedefs results in ugly code.
>>>>
>>>>
>>>> Hi David,
>>>> I've been playing with this on a Juno board.
>>>> I ran into one crash, which I'm not yet sure is an issue, but thought I
>>>> would flag it.
>>>>
>>>> I opted to put a kprobe on memcpy, this is an assembler function so I
>>>> located it via:
>>>> $ nm ./vmlinux | grep \ memcpy$
>>>> fffffe0000408a00 T memcpy
>>>>
>>>> Then placed a probe as follows:
>>>> echo "p:memcpy 0xfffffe0000408a00 %x2" >
>>>> /sys/kernel/debug/tracing/kprobe_events
>>>
>>>
>>> You can also do "p:memcpy memcpy %x2" > ...
>>
>>
>> Thanks, that is easier :-).
>>
>>>
>>>>
>>>> I was able to cat out the /sys/kernel/debug/tracing/trace_pipe file and
>>>> activate the probe via:
>>>> echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
>>>>
>>>> Everything worked well, and I got the expected output.
>>>>
>>>> I then tried to record events with perf via:
>>>> perf record -e kprobes:memcpy -a sleep 5
>>>>
>>>> Then I got an, easily reproducible, panic (pasted below).
>>>
>>>
>>> On x86, I didn't get a panic.
>>>
>>>>
>>>> The point of failure in the panic was:
>>>> fs/buffer.c:1257
>>>>
>>>> static inline void check_irqs_on(void)
>>>> {
>>>> #ifdef irqs_disabled
>>>>          BUG_ON(irqs_disabled());
>>>> #endif
>>>> }
>>>>
>>>> I will do some more digging; but I have managed to code up an ftrace
>>>> static probe on memcpy and record that using perf on arm64 without
>>>> issue.
>>>
>>>
>>> Yeah, this can be a bug related to kprobes recursive call.
>>> Could you do "cat /sys/kernel/debug/tracing/kprobe_profile" (before
>>> run perf)?
>>> The first digit is # of hit, and the second is # of missed (since
>>> recursively called).
>>>
>>> On x86, right after tracing by ftrace, we have no missed probe.
>>>
>>>   # cat /sys/kernel/debug/tracing/kprobe_profile
>>>    memcpy                                                  4547
>>> 0
>>>
>>> But after tracing by perf, many missed events I could see.
>>>
>>>   # cat /sys/kernel/debug/tracing/kprobe_profile
>>>    memcpy                                                413983
>>> 7632
>>>
>>> So I guess this can be related to the recursive call (which
>>> is correctly handled on x86).
>>>
>>
>> Before running perf, I got the following:
>>
>>   # cat /sys/kernel/debug/tracing/kprobe_profile
>>     memcpy                                                   838
>> 0
>>
>> Unfortunately, after the crash, I was then unable to take any other
>> measurements.
>>
>> I rebooted, set up the kprobe, then ran `./hackbench 100 process 1000',
>> to try and exacerbate things, and got the following:
>>   # cat /sys/kernel/debug/tracing/kprobe_profile
>>     memcpy                                                100677
>> 0
>>
>> So no missed events thusfar.
>>
>> Cheers,
>>
>
> So I take it from this we can conclude the problem is not reliably
> reproducible?
>

The crash is extremely easy to reproduce.

I've not observed any missed events on a kprobe on an arm64 system
that's still alive.
My (limited!) understanding is that this suggests there could be a
problem with how missed events from a recursive call to memcpy are
being handled.

Cheers,
--
Steve
