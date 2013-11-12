Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3KLKzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:55:47 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:65327 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3KLKz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:55:28 -0500
MIME-Version: 1.0
In-Reply-To: <52820043.6090107@hitachi.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
	<1382008671-4515-3-git-send-email-sandeepa.prabhu@linaro.org>
	<20131108165639.GD15074@mudshark.cambridge.arm.com>
	<527DFC1C.1020107@hitachi.com>
	<CA+b37P3U=cAbUvs=2B9wA4F7S9o49vh7d-KamjPsHcz-b9ZYLA@mail.gmail.com>
	<52808D53.7080904@hitachi.com>
	<5280B6C8.7050807@hitachi.com>
	<20131111105812.GC28302@mudshark.cambridge.arm.com>
	<528114C4.5000506@hitachi.com>
	<CA+b37P08cLAvBYAXSkozLPzrpuXn=N0SUetwL6N8JL+10AtYjQ@mail.gmail.com>
	<5281D848.7000502@hitachi.com>
	<CA+b37P2EgB0toYwhLny8k-cbrziBVXURST5kHNXcY7AF-CNVLg@mail.gmail.com>
	<52820043.6090107@hitachi.com>
Date: Tue, 12 Nov 2013 16:25:26 +0530
Message-ID: <CA+b37P1xLYWA-a0PwgxT7S7dNr5TdGFscLYFeQhAQUyO_E=Mzw@mail.gmail.com>
Subject: Re: Re: Re: Re: [PATCH RFC 2/6] arm64: Kprobes with single stepping support
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Will Deacon <will.deacon@arm.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2013 15:47, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2013/11/12 17:44), Sandeepa Prabhu wrote:
>> On 12 November 2013 12:57, Masami Hiramatsu
>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>> (2013/11/12 15:23), Sandeepa Prabhu wrote:
>>>>>>> OK, I've ensured that the hw_breakpoint (from perf) can work
>>>>>>> with kprobes (from ftrace) at the same address on x86.
>>>>>>> So if arm64 already support hw_breakpoint on perf, kprobes should
>>>>>>> work with it.
>>>>>>
>>>>>> Single-stepping on x86 is different to the step behaviour on arm64 afaik. On
>>>>>> ARM, we have to manually remove the breakpoint, perform a single-step, then
>>>>>> add the breakpoint again. If we re-enable debug exceptions in the kprobe
>>>>>> handler, the step will complete early and we'll never step off the
>>>>>> breakpoint.
>>>>>
>>>>> I'm unsure about arm64's debug feature behavior, what does happen when
>>>>> it performs a single-step on sw-breakpoint?
>>>>>
>>>>>> Sandeepa: I think you need to retry Masami's test on the arm64 model, since
>>>>>> I'm fairly sure it won't work as expected without some additional code.
>>>>>
>>>>> OK, anyway, for testing same one, we need to port ftrace first. So the next
>>>
>>> Sorry for confusion, s/next/fallback is what I meant. Making a kprobe module
>>> can be done without ftrace port.
>> Yes, got it, all my verification until now are done using sample
>> modules only,  looking out for perf (or some other mechanism: ptrace?)
>> that uses v8 hw breakpoint.
>
> Yes, kprobe vs. perf and uprobe vs. ptrace :)
>
>
>>>>> plan is to make a kprobe module to put a probe (which just printk something)
>>>>> on a specific function (e.g. vfs_symlink), and run perf record with
>>>>> hw-breakpoint as below
>>>>>
>>>>> $ perf record -e "mem:0xXXXXXX:k" ln -s /dev/null /tmp/foo
>>>>>
>>>>> Note that 0xXXXXXX is the address of vfs_symlink.
>>>>>
>>>>> After that, you can see the message in dmesg and also check the perf result
>>>>> with "sudo perf script --dump" (you can find a PERF_RECORD_SAMPLE entry if
>>>>> it works)
>>>> Thanks for steps, ARM64 ftrace patches are under review on arm mailing
>>>> list, I can contact the (linaro) developer implementing ftrace on
>>>> what's supported and then figure-out a way to test this concurrency of
>>>> kprobes breakpoint and hardware breakpoint.
>>>
>>> Would you mean this? :)
>>> http://www.spinics.net/lists/arm-kernel/msg278477.html
>>>
>>> Wow, it seems that this also has some works around instruction
>>> manipulation (and confusable filenames...)
>> I referred to: http://lwn.net/Articles/572323/  which is another
>> implementation and on LAKML
>
> OK, I'll check that (and looks good at a glance).
> By the way, I concern about Linaro guys who looks working a bit far
> from the LKML and original feature maintainers. Please contact them,
> I'm sure they don't bite your hand :)
Hmm sure, will convey to our developers/leads :-)

>
> BTW, I'm currently trying a general housecleaning of __kprobes
> annotations. It may also have impact on your patch.
> https://lkml.org/lkml/2013/11/8/187
Hmm, we can help testing your patchset on arm64 platforms. Also have
many doubts on the changes you are working [blacklisting probes etc]

Basically I had tried placing kprobe on memcpy() and the model hung
(insmod never returned back!). Fast-model I have does not have option
of any debug so no clue what happened!.
memcpy() is low-level call being used internally within kprobes, so
probably we cannot handle probe on that routine, but then how to make
sure all such API are rejected by kprobe sub-system ?

~Sandeepa
>
> Thank you,
>
> --
> Masami HIRAMATSU
> IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
>
>
