Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbaK1Knd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:43:33 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46231 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaK1Knb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:43:31 -0500
Message-ID: <547851CA.7050803@hitachi.com>
Date: Fri, 28 Nov 2014 19:43:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Wang Nan <wangnan0@huawei.com>, linux@arm.linux.org.uk,
        will.deacon@arm.com, taras.kondratiuk@linaro.org,
        ben.dooks@codethink.co.uk, cl@linux.com, rabin@rab.in,
        davem@davemloft.net, lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Re: Re: [PATCH v10 2/2] ARM: kprobes: enable OPTPROBES for
 ARM 32
References: <1416551751-50846-1-git-send-email-wangnan0@huawei.com>   <1416551751-50846-3-git-send-email-wangnan0@huawei.com>  <1417099007.2041.6.camel@linaro.org> <5477E82A.3020208@hitachi.com> <1417169308.1845.1.camel@linaro.org>
In-Reply-To: <1417169308.1845.1.camel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/28 19:08), Jon Medhurst (Tixy) wrote:
> On Fri, 2014-11-28 at 12:12 +0900, Masami Hiramatsu wrote:
>> (2014/11/27 23:36), Jon Medhurst (Tixy) wrote:
> [...]
>>> I thought it good to see what sort of benefits this code achieves,
>>> especially as it could grow quite complex over time, and the cost of
>>> that versus the benefit should be considered.
>>
>> I don't think it's so complex. It's actually cleanly separated.
>> However, ARM tree should have arch/arm/kernel/kprobe/ dir,
>> since there are too many kprobe related files under arch/arm/kernel/ ...
> 
> Yes, that does seem like a good idea. Or rather a 'probes' directory to
> also include uprobes as that shares a lot of code with kprobes.

Agreed.

>>>>
>>>> Limitations:
>>>>  - Currently only kernel compiled with ARM ISA is supported.
>>>
>>> Supporting Thumb will be very difficult because I don't believe that
>>> putting a branch into an IT block could be made to work, and you can't
>>> feasibly know if an instruction is in an IT block other than by first
>>> using something like the breakpoint probe method and then when that is
>>> hit examine the IT flags to see if they're set. If they aren't you could
>>> then change the probe to an optimised probe. Is transforming the probe
>>> type like that currently supported by the generic kprobes code?
>>
>> Optprobe framework optimizes probes transparently. If it can not be
>> optimized, it just do nothing on it.
> 
> Yes, but I was saying that with the Thumb ISA, we can't know until the
> first time a probe is hit if it is possible to optimise it, so when any
> probe is first registered we would have to return an error from
> arch_prepare_optimized_kprobe. Then have probe handling code do some
> checks when it is first hit, and then trigger the optimising of the
> probe if possible. I guess the extra plumbing for that wouldn't be too
> hard.

Ah, I see. In that case we need another optimizing worker. Hmm, but
it also requires to consume more resource and could make bigger the
kernel. I doubt how many people who use Thumb ISA to reduce the
kernel size need this extra work...

>>> Also, the Thumb branch instruction can only jump half as far as the ARM
>>> mode one. And being 32-bits when a lot of instructions people will want
>>> to probe are 16-bits will be an additional problem, similar as
>>> identified below for ARM instructions...
>>>
>>>
>>>>
>>>>  - Offset between probe point and optinsn slot must not larger than
>>>>    32MiB.
>>>
>>>
>>> I see that elsewhere [1] people are working on supporting loading kernel
>>> modules at locations that are out of the range of a branch instruction,
>>> I guess because with multi-platform kernels and general code bloat
>>> kernels are getting too big. The same reasons would impact the usability
>>> of optimized kprobes as well if they're restricted to the range of a
>>> single branch instruction.
>>>
>>> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305539.html
>>>
>>>
>>>>  Masami Hiramatsu suggests replacing 2 words, it will make
>>>>    things complex. Futher patch can make such optimization.
>>>
>>> I'm wondering how can we replace 2 words if we can't determine if the
>>> second word is the target of a branch instruction?
>>
>> on X86, we already have an instruction decoder for finding the
>> branch target :).
> 
> How do you know where to start decoding the instructions stream from?

I just start decoding from the entry of the probed function :)

>>  But yes, it can be impossible in other arch if
>> it intensively uses indirect branch.
> 
> I don't know if it's 'impossible' on ARM, would need someone with
> expertise in formal proofs. Anyway, I for one wouldn't want to have to
> try such a thing on ARM unless I was given it as something like a paid
> year long research project. :-)

Agreed :-)

> 
>> [...]
> 
>>  
>>> I initially had some trouble testing this. I tried running the kprobes
>>> test code with some printf's added to the code and it seems that only
>>> very rarely are optimised probes actually executed. This turned out to
>>> be due to the optimization being run as a background task after a delay.
>>> So I ended up hacking kernel/kprobes.c to force some calls to
>>> wait_for_kprobe_optimizer(). It would be nice to have the test code to
>>> robustly cover both optimised and unoptimised cases but that would need
>>> some new exported functions from the generic kprobes code, not sure what
>>> people think of that idea?
>>
>> Hm, did you use ftrace's kprobe events?
> 
> Not something I've come across. I'm somewhat ashamed to say that kprobes
> is something that I've only worked on from an implementation point of
> view, not a user point of view.
> 
>> You can actually add kprobes via /sys/kernel/debug/tracing/kprobe_events and
>> see what kprobes are optimized via /sys/kernel/debug/kprobes/list.
>>
>> For more information, please refer
>>  Documentation/trace/kprobetrace.txt
>>  Documentation/kprobes.txt
> 
> Well, on ARM we decode and emulate the entire instruction set, so when I
> came to implement Thumb ISA kprobes I created test code with test cases
> to cover every instruction form and combination of argument types, which
> required a fair amount of automation, so I created a test framework for
> that (arch/arm/kernel/kprobes-test*). I also added test to cover the
> existing ARM ISA code at the time and found it mostly broken and had to
> fix it

Ah, that's a nice test code :-) It could be moved under tools/testing/selftests/.

> I know comprehensive testing isn't the Linux way, but that was my first
> Linux project and I brought my old habits with me. And as you can see
> from my testing of these latest patches I've not yet given up those
> habits.

Thank you for continuing on it!
I really appreciate your efforts!

Thanks,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


