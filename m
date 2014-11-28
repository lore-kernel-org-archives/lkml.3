Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbaK1DMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 22:12:50 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37581 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaK1DMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 22:12:49 -0500
Message-ID: <5477E82A.3020208@hitachi.com>
Date: Fri, 28 Nov 2014 12:12:42 +0900
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
Subject: Re: Re: [PATCH v10 2/2] ARM: kprobes: enable OPTPROBES for ARM
 32
References: <1416551751-50846-1-git-send-email-wangnan0@huawei.com>  <1416551751-50846-3-git-send-email-wangnan0@huawei.com> <1417099007.2041.6.camel@linaro.org>
In-Reply-To: <1417099007.2041.6.camel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/27 23:36), Jon Medhurst (Tixy) wrote:
> On Fri, 2014-11-21 at 14:35 +0800, Wang Nan wrote:
>> This patch introduce kprobeopt for ARM 32.
> 
> If I've understood things correctly, this is a feature which inserts
> probes by using a branch instruction to some trampoline code rather than
> using an undefined instruction as a breakpoint. That way we avoid the
> overhead of processing the exception and it is this performance
> improvement which is the main/only reason for implementing it?
> 
> If so, I though it good to see what kind of improvement we get by
> running the micro benchmarks in the kprobes test code. On an A7/A15
> big.LITTLE vexpress board the approximate figures I get are 0.3us for
> optimised probe, 1us for un-optimised, so a three times performance
> improvement. This is with an empty probe pre-handler and no post
> handler, so with a more realistic usecase, the relative improvement we
> get from optimisation would be less.

Indeed, I think we'd better use ftrace to measure performance, since
it is the most realistic usecase. On x86, we have similar number,
and ftrace itself has 0.3-0.4us to record an event. So I guess
it can get 2 times faster. (Of course it depends on the SoC because
memory bandwidth is the key for performance of event recording)


> I thought it good to see what sort of benefits this code achieves,
> especially as it could grow quite complex over time, and the cost of
> that versus the benefit should be considered.

I don't think it's so complex. It's actually cleanly separated.
However, ARM tree should have arch/arm/kernel/kprobe/ dir,
since there are too many kprobe related files under arch/arm/kernel/ ...


>>
>> Limitations:
>>  - Currently only kernel compiled with ARM ISA is supported.
> 
> Supporting Thumb will be very difficult because I don't believe that
> putting a branch into an IT block could be made to work, and you can't
> feasibly know if an instruction is in an IT block other than by first
> using something like the breakpoint probe method and then when that is
> hit examine the IT flags to see if they're set. If they aren't you could
> then change the probe to an optimised probe. Is transforming the probe
> type like that currently supported by the generic kprobes code?

Optprobe framework optimizes probes transparently. If it can not be
optimized, it just do nothing on it.


> Also, the Thumb branch instruction can only jump half as far as the ARM
> mode one. And being 32-bits when a lot of instructions people will want
> to probe are 16-bits will be an additional problem, similar as
> identified below for ARM instructions...
> 
> 
>>
>>  - Offset between probe point and optinsn slot must not larger than
>>    32MiB.
> 
> 
> I see that elsewhere [1] people are working on supporting loading kernel
> modules at locations that are out of the range of a branch instruction,
> I guess because with multi-platform kernels and general code bloat
> kernels are getting too big. The same reasons would impact the usability
> of optimized kprobes as well if they're restricted to the range of a
> single branch instruction.
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305539.html
> 
> 
>>  Masami Hiramatsu suggests replacing 2 words, it will make
>>    things complex. Futher patch can make such optimization.
> 
> I'm wondering how can we replace 2 words if we can't determine if the
> second word is the target of a branch instruction?

on X86, we already have an instruction decoder for finding the
branch target :). But yes, it can be impossible in other arch if
it intensively uses indirect branch.

> E.g. if we had
> 
> 		b	after_probe
> 		...
> probe_me:	mov	r2, #0
> after_probe:	ldr	r0, [r1]
> 
> and we inserted a two word probe at probe_me, then the branch to
> after_probe would be to the second half of that 2 word probe. Guess that
> could be worked around by ensuring the 2nd word is an invalid
> instruction and trapping that case then emulating after_probe like we do
> unoptimised probes. This assumes that we can come up with an
> encoding for a 2 word 'long branch' that was suitable. (For Thumb, I
> suspect that we would need at least 3 16-bit instructions to achieve
> that).
> 
> As the commit message says "will make things complex" and I begin to
> wonder if the extra complexity would be worth the benefits. (Considering
> that the resulting optimised probe would only be around twice as fast.)
> 
> 
>>
>> Kprobe opt on ARM is relatively simpler than kprobe opt on x86 because
>> ARM instruction is always 4 bytes aligned and 4 bytes long. This patch
>> replace probed instruction by a 'b', branch to trampoline code and then
>> calls optimized_callback(). optimized_callback() calls opt_pre_handler()
>> to execute kprobe handler. It also emulate/simulate replaced instruction.
>>
>> When unregistering kprobe, the deferred manner of unoptimizer may leave
>> branch instruction before optimizer is called. Different from x86_64,
>> which only copy the probed insn after optprobe_template_end and
>> reexecute them, this patch call singlestep to emulate/simulate the insn
>> directly. Futher patch can optimize this behavior.
>>
>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Jon Medhurst (Tixy) <tixy@linaro.org>
>> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
>> Cc: Will Deacon <will.deacon@arm.com>
>>
>> ---
> 
> I initially had some trouble testing this. I tried running the kprobes
> test code with some printf's added to the code and it seems that only
> very rarely are optimised probes actually executed. This turned out to
> be due to the optimization being run as a background task after a delay.
> So I ended up hacking kernel/kprobes.c to force some calls to
> wait_for_kprobe_optimizer(). It would be nice to have the test code to
> robustly cover both optimised and unoptimised cases but that would need
> some new exported functions from the generic kprobes code, not sure what
> people think of that idea?

Hm, did you use ftrace's kprobe events?
You can actually add kprobes via /sys/kernel/debug/tracing/kprobe_events and
see what kprobes are optimized via /sys/kernel/debug/kprobes/list.

For more information, please refer
 Documentation/trace/kprobetrace.txt
 Documentation/kprobes.txt

Thank you,



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


