Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaK0FNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 00:13:14 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52794 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaK0FNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 00:13:12 -0500
Message-ID: <5476B2E1.7030304@hitachi.com>
Date: Thu, 27 Nov 2014 14:13:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steve Capper <steve.capper@linaro.org>
Cc: David Long <dave.long@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        William Cohen <wcohen@redhat.com>, davem@davemloft.net
Subject: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org> <20141120135851.GA32528@linaro.org> <54759041.9080105@hitachi.com> <20141126100325.GA9157@linaro.org>
In-Reply-To: <20141126100325.GA9157@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/26 19:03), Steve Capper wrote:
> On Wed, Nov 26, 2014 at 05:33:05PM +0900, Masami Hiramatsu wrote:
>> (2014/11/21 0:02), Steve Capper wrote:
>>> On Tue, Nov 18, 2014 at 01:32:50AM -0500, David Long wrote:
>>>> From: "David A. Long" <dave.long@linaro.org>
>>>>
>>>> This patchset is heavily based on Sandeepa Prabhu's ARM v8 kprobes patches, first
>>>> seen in October 2013.  This version attempts to address concerns raised by
>>>> reviewers and also fixes problems discovered during testing, particularly during
>>>> SMP testing.
>>>>
>>>> This patchset adds support for kernel probes(kprobes), jump probes(jprobes)
>>>> and return probes(kretprobes) support for ARM64.
>>>>
>>>> Kprobes mechanism makes use of software breakpoint and single stepping
>>>> support available in the ARM v8 kernel.
>>>>
>>>> Changes since v2 include:
>>>>
>>>> 1) Removal of NOP padding in kprobe XOL slots.  Slots are now exactly one
>>>> instruction long.
>>>> 2) Disabling of interrupts during execution in single-step mode.
>>>> 3) Fixing of numerous problems in instruction simulation code.
>>>> 4) Support for the HAVE_REGS_AND_STACK_ACCESS_API feature is added, to allow
>>>> access to kprobes through debugfs.
>>>> 5) kprobes is *not* enabled in defconfig.
>>>> 6) Numerous complaints from checkpatch have been cleaned up, although a couple
>>>> remain as removing the function pointer typedefs results in ugly code.
>>>
>>> Hi David,
>>> I've been playing with this on a Juno board.
>>> I ran into one crash, which I'm not yet sure is an issue, but thought I
>>> would flag it.
>>>
>>> I opted to put a kprobe on memcpy, this is an assembler function so I
>>> located it via:
>>> $ nm ./vmlinux | grep \ memcpy$
>>> fffffe0000408a00 T memcpy
>>>
>>> Then placed a probe as follows:
>>> echo "p:memcpy 0xfffffe0000408a00 %x2" > /sys/kernel/debug/tracing/kprobe_events
>>
>> You can also do "p:memcpy memcpy %x2" > ...
> 
> Thanks, that is easier :-).
> 
>>
>>>
>>> I was able to cat out the /sys/kernel/debug/tracing/trace_pipe file and
>>> activate the probe via:
>>> echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
>>>
>>> Everything worked well, and I got the expected output.
>>>
>>> I then tried to record events with perf via:
>>> perf record -e kprobes:memcpy -a sleep 5
>>>
>>> Then I got an, easily reproducible, panic (pasted below).
>>
>> On x86, I didn't get a panic.
>>
>>>
>>> The point of failure in the panic was:
>>> fs/buffer.c:1257
>>>
>>> static inline void check_irqs_on(void)
>>> {
>>> #ifdef irqs_disabled
>>>         BUG_ON(irqs_disabled());
>>> #endif
>>> }
>>>
>>> I will do some more digging; but I have managed to code up an ftrace
>>> static probe on memcpy and record that using perf on arm64 without
>>> issue.
>>
>> Yeah, this can be a bug related to kprobes recursive call.
>> Could you do "cat /sys/kernel/debug/tracing/kprobe_profile" (before
>> run perf)?
>> The first digit is # of hit, and the second is # of missed (since
>> recursively called).
>>
>> On x86, right after tracing by ftrace, we have no missed probe.
>>
>>  # cat /sys/kernel/debug/tracing/kprobe_profile
>>   memcpy                                                  4547               0
>>
>> But after tracing by perf, many missed events I could see.
>>
>>  # cat /sys/kernel/debug/tracing/kprobe_profile
>>   memcpy                                                413983            7632
>>
>> So I guess this can be related to the recursive call (which
>> is correctly handled on x86).
>>
> 
> Before running perf, I got the following:
> 
>  # cat /sys/kernel/debug/tracing/kprobe_profile
>    memcpy                                                   838               0
> 
> Unfortunately, after the crash, I was then unable to take any other
> measurements.

Yes, but we can ensure that the recursion must be occur by
probing kprobe-tracer (ftrace) itself.

E.g.
Ensure trace_event_buffer_lock_reserve exists.
  # grep trace_event_buffer_lock_reserve /proc/kallsyms
  ffffffff8113a100 T trace_event_buffer_lock_reserve

Define a probe on it.
  # echo p:test trace_event_buffer_lock_reserve > kprobe_events

And enable with another event (because this probe is not hit unless
other events hit)

 # echo 1 > events/kprobes/test/enable
 # echo 1 > events/sched/sched_process_exec/enable

If recursive call has a problem, you'll have a panic if you execute
any command. Anyway, on x86, we can see below result.

 # cat kprobe_profile
  test                                                       1               1

So, the half of all probes will be missed.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


