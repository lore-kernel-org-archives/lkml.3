Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3KKRdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:33:06 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33439 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3KKRc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:32:56 -0500
Message-ID: <528114C4.5000506@hitachi.com>
Date: Tue, 12 Nov 2013 02:32:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
Cc: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        Jiang Liu <liuj97@gmail.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Re: [PATCH RFC 2/6] arm64: Kprobes with single stepping support
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org> <1382008671-4515-3-git-send-email-sandeepa.prabhu@linaro.org> <20131108165639.GD15074@mudshark.cambridge.arm.com> <527DFC1C.1020107@hitachi.com> <CA+b37P3U=cAbUvs=2B9wA4F7S9o49vh7d-KamjPsHcz-b9ZYLA@mail.gmail.com> <52808D53.7080904@hitachi.com> <5280B6C8.7050807@hitachi.com> <20131111105812.GC28302@mudshark.cambridge.arm.com>
In-Reply-To: <20131111105812.GC28302@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/11 19:58), Will Deacon wrote:
> On Mon, Nov 11, 2013 at 10:51:52AM +0000, Masami Hiramatsu wrote:
>> (2013/11/11 16:54), Masami Hiramatsu wrote:
>>>>>> In fact, how do you avoid a race with hardware breakpoints? E.g., somebody
>>>>>> places a hardware breakpoint on an instruction in the kernel for which
>>>>>> kprobes has patched in a brk. We take the hardware breakpoint, disable the
>>>>>> breakpoint and set up a single step before returning to the brk. The brk
>>>>>> then traps, but we must take care not to disable single-step and/or unmask
>>>>>> debug exceptions, because that will cause the hardware breakpoint code to
>>>>>> re-arm its breakpoint before we've stepped off the brk instruction.
>>>>>
>>>>> Hmm, frankly to say, this kind of race issue is not seriously discussed
>>>>> on x86 too, since kgdb is still a special tool (not used on the production
>>>>> system).
>>>>> I think under such situation kgdb operator must have full control of the
>>>>> system, and he can (and has to) avoid such kind of race.
>>>> Masami,
>>>>
>>>> Hmm I think in same lines, but not sure if we expect kprobes to be
>>>> able to work fool-proof along with kgdb or hw breakpoints ?
>>>
>>> For hw breakpoint, yes, we finally get check each other to safely
>>> use it even if one rejects the other one at some points(address).
>>> Since the hw breakpoint is already open for normal user via perf,
>>> we should do it. But the policy still needs to be discussed.
>>
>> OK, I've ensured that the hw_breakpoint (from perf) can work
>> with kprobes (from ftrace) at the same address on x86.
>> So if arm64 already support hw_breakpoint on perf, kprobes should
>> work with it.
> 
> Single-stepping on x86 is different to the step behaviour on arm64 afaik. On
> ARM, we have to manually remove the breakpoint, perform a single-step, then
> add the breakpoint again. If we re-enable debug exceptions in the kprobe
> handler, the step will complete early and we'll never step off the
> breakpoint.

I'm unsure about arm64's debug feature behavior, what does happen when
it performs a single-step on sw-breakpoint?

> Sandeepa: I think you need to retry Masami's test on the arm64 model, since
> I'm fairly sure it won't work as expected without some additional code.

OK, anyway, for testing same one, we need to port ftrace first. So the next
plan is to make a kprobe module to put a probe (which just printk something)
on a specific function (e.g. vfs_symlink), and run perf record with
hw-breakpoint as below

$ perf record -e "mem:0xXXXXXX:k" ln -s /dev/null /tmp/foo

Note that 0xXXXXXX is the address of vfs_symlink.

After that, you can see the message in dmesg and also check the perf result
with "sudo perf script --dump" (you can find a PERF_RECORD_SAMPLE entry if
it works)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


