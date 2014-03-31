Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaCaV3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:29:07 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:64704 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaCaV3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:29:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<20140331071749.GA1252@gmail.com>
	<CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com>
Date: Mon, 31 Mar 2014 14:29:03 -0700
Message-ID: <CAMEtUuw24=+CkcdwDnJ4AbSCjGBBFx+8pTFzn5gXbQAy=KYWng@mail.gmail.com>
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for Linux
From: Alexei Starovoitov <ast@plumgrid.com>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 3:01 AM, Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
> Hi Ingo,
>
> On Mon, Mar 31, 2014 at 3:17 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
>>
>>> Hi All,
>>>
>>> The following set of patches add ktap tracing tool.
>>>
>>> ktap is a new script-based dynamic tracing tool for Linux.
>>> It uses a scripting language and lets the user trace system dynamically.
>>>
>>> Highlights features:
>>> * a simple but powerful scripting language
>>> * register-based interpreter (heavily optimized) in Linux kernel
>>> * small and lightweight
>>> * not depend on the GCC toolchain for each script run
>>> * easy to use in embedded environments without debugging info
>>> * support for tracepoint, kprobe, uprobe, function trace, timer, and more
>>> * supported in x86, ARM, PowerPC, MIPS
>>> * safety in sandbox
>>
>> I've asked this fundamental design question before but got no full
>> answer: how does ktap compare to the ongoing effort of improving the
>> BPF scripting engine?
>>
>
> From long experiences of ktap development, what make me really
> love ktap is:
>
> 1) Availability
>     ktap is only available tool to use in small embedded platform, stap
>     and BPF both need GCC now, stap have its own language, so it's much
>     better than BPF.
>     (IMO there may need several years to complete a skeleton of dynamic
>     tracing script language, see stap and dtrace)
>
> 2) Simplicity
>   ktap is simplest dynamic scripting trace solution now in Linux world,
>   compare with stap/dtrace/BPF.
>   a). It have simple syntax which make many people like it, it have
>   b). It have simple associate array, make dynamic tracing powerful.
>   c). It have a simple compiler which only have 87K in x86_64.
>   d). It have a simple tracing syntax which constant with perf events.
>
> 3) Safety
>   ktap already delivered its safety to end user, many people use ktap
>   in their dev lab to investigate problem.
>   But BPF need time to prove its safety, especially proved by end user,
>   and IMO BPF safety check would be more complex if the runtime
>   support more features as time goes.

safety of ktap is arguable.

1.
>From the diff it seems that 'loop_count' is a dynamic way of
checking that loops are not infinite, but max_loop_count = 100000
if loop body has many instructions, such large count may trigger
hung_task panic.

2.
jumps are not counted, so if userspace makes an error and loads
ktap bytecode with wrong jumps, the interpreter will hang.

3.
recursive functions and f1()->f2()->f1() are not detected either.
Another possible hang?

4.
bc_[ft]new instruction are allocating memory and garbage collector
suppose to free things when ktap module is unloaded, right?
since max_loop_cnt is 100k, a script can allocate quite a bit of memory
and kernel will be waiting for userspace trigger to free it?
Sounds dangerous.

These concerns are just from quick code review.

> 4). Samples
>   Many people like those ktap samples, ktap shows the attractive by
>   samples.
>
> Even I so love ktap and would like share ktap values to everyone, but in
> technical point of view, I still agree with you that there should have
> unified scripting engines in kernel if that engine can service for many
> domains(like networking), but that solution should show its availability/
> simplicity/safety firstly to user, not just proved by end user.
>
> Dynamic tracing scripting environment should contains:
> simple compiler, clean language syntax, fast script engine,
> associative array, aggregation, kstack, ustack, event management,
> ring buffer, samples, tapset/library, CTF, etc.
>
> ktap already fixed most of these issues by its simple design, but
> BPF only have "script engine" part(its associative array still cannot
> vmalloc), which have long road before could use by end user.

'internal bpf' instruction set is an assembler instruction set.
Low level just like x86 instruction set.
It doesn't have vmalloc instruction and shouldn't have.
'internal bpf' program can theoretically make a call to allocate
memory, but I don't think it's safe to let loadable programs to
arbitrarily allocate memory.
It's a matter of ownership of the memory.
If script can allocate and receive a pointer to memory,
the script owns that memory and kernel cannot touch it until
script does 'free' or terminates and GC kicks in.
ktap can be invoked through timers, so this dynamically
allocated tables may be living for long time affecting the whole
system. The tracing tool should be safer than that.

> ktap is not just bring a bytecode engine, it bring a complete simple
> dynamic tracing environment to end user, it bring clean language syntax,
> samples, flexible table, perf like event management, etc, those is the
> key part to end user, not bytecode engine, so if we can develop simple
> BPF compiler with similar ktap syntax in some day, then we can replace
> kp_lex.c/kp_parse.c/kp_vm.c, and there have zero reason why other
> parts cannot be shared(associative array, aggregation, kstack, ustack,
> event management, ring buffer, samples, tapset/library, CTF, etc).

I think nothing stops ktap userspace to parse ktap language
and generate 'internal bpf' format. gcc is unnecessary here.
I personally think that tracing scripts in C are more readable,
but that's minor.
But before we go about generating either 'internal bpf' or any
other format, we need to discuss safe scripting design principles.
We already have systemtap that is relying on userspace for verification.
If we want a real alternative to systemtap, kernel should take care
of safety.

Note I'm not proposing to expose 'internal bpf' to userspace in uapi
headers and I think ktap shouldn't do it either.
Kernel hosted userspace component (like perf) that uses
kernel specific headers allows for much cleaner interfaces
without creating 'forever maintain' headache.

Regards,
Alexei
