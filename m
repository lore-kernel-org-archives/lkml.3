Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaDBE5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 00:57:24 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:55509 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbaDBE5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 00:57:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<20140331071749.GA1252@gmail.com>
	<CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com>
	<CAMEtUuw24=+CkcdwDnJ4AbSCjGBBFx+8pTFzn5gXbQAy=KYWng@mail.gmail.com>
	<CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com>
Date: Tue, 1 Apr 2014 21:57:14 -0700
Message-ID: <CAMEtUuxYigBYnH_n_MCrs_=r9KLGOha3rSuNZ876mgH1tAvVCg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for Linux
From: Alexei Starovoitov <ast@plumgrid.com>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>,
        Geoff.Levand@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 9:47 PM, Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
> Hi Alexei,
>
> On Tue, Apr 1, 2014 at 5:29 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> On Mon, Mar 31, 2014 at 3:01 AM, Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
>>> Hi Ingo,
>>>
>>> On Mon, Mar 31, 2014 at 3:17 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>>>
>>>> * Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
>>>>
>>>>> Hi All,
>>>>>
>>>>> The following set of patches add ktap tracing tool.
>>>>>
>>>>> ktap is a new script-based dynamic tracing tool for Linux.
>>>>> It uses a scripting language and lets the user trace system dynamically.
>>>>>
>>>>> Highlights features:
>>>>> * a simple but powerful scripting language
>>>>> * register-based interpreter (heavily optimized) in Linux kernel
>>>>> * small and lightweight
>>>>> * not depend on the GCC toolchain for each script run
>>>>> * easy to use in embedded environments without debugging info
>>>>> * support for tracepoint, kprobe, uprobe, function trace, timer, and more
>>>>> * supported in x86, ARM, PowerPC, MIPS
>>>>> * safety in sandbox
>>>>
>>>> I've asked this fundamental design question before but got no full
>>>> answer: how does ktap compare to the ongoing effort of improving the
>>>> BPF scripting engine?
>>>>
>>>
>>> From long experiences of ktap development, what make me really
>>> love ktap is:
>>>
>>> 1) Availability
>>>     ktap is only available tool to use in small embedded platform, stap
>>>     and BPF both need GCC now, stap have its own language, so it's much
>>>     better than BPF.
>>>     (IMO there may need several years to complete a skeleton of dynamic
>>>     tracing script language, see stap and dtrace)
>>>
>>> 2) Simplicity
>>>   ktap is simplest dynamic scripting trace solution now in Linux world,
>>>   compare with stap/dtrace/BPF.
>>>   a). It have simple syntax which make many people like it, it have
>>>   b). It have simple associate array, make dynamic tracing powerful.
>>>   c). It have a simple compiler which only have 87K in x86_64.
>>>   d). It have a simple tracing syntax which constant with perf events.
>>>
>>> 3) Safety
>>>   ktap already delivered its safety to end user, many people use ktap
>>>   in their dev lab to investigate problem.
>>>   But BPF need time to prove its safety, especially proved by end user,
>>>   and IMO BPF safety check would be more complex if the runtime
>>>   support more features as time goes.
>>
>> safety of ktap is arguable.
>>
>> 1.
>> From the diff it seems that 'loop_count' is a dynamic way of
>> checking that loops are not infinite, but max_loop_count = 100000
>> if loop body has many instructions, such large count may trigger
>> hung_task panic.
>>
> Actually I'm planing use time-based time to avoid this, minor issue.
>
>> 2.
>> jumps are not counted, so if userspace makes an error and loads
>> ktap bytecode with wrong jumps, the interpreter will hang.
>>
> There leave a todo in validation code, as kernel developers don't like
> many todo in there, so I will also address it.
>
>> 3.
>> recursive functions and f1()->f2()->f1() are not detected either.
>> Another possible hang?
>>
> No, it will exit by ktap stack overflow check.
>
>> 4.
>> bc_[ft]new instruction are allocating memory and garbage collector
>> suppose to free things when ktap module is unloaded, right?
>> since max_loop_cnt is 100k, a script can allocate quite a bit of memory
>> and kernel will be waiting for userspace trigger to free it?
>> Sounds dangerous.
>>
> There will have table/function number limitation, so this is not a problem.
>
>> These concerns are just from quick code review.

ok. spotted few more things:

5.
bc_callt (ktap tailcall) doesn't have loop_count check.
so tailcall can loop forever.
Of course you can fix it with elapsed time check at every branch
or call instruction.

6.
do_bc_kstr doesn't check that 'd' value is valid and goes kbase[~d]
Can be fixed of course.

7.
uget/uset and others seem to have similar problems.

It seems that your definition of 'safe ktap' is that user cannot break
kernel if he uses ktap scripting syntax.
In that sense ktap is not much different from stap.

Overall it seems you view ktap bytecode as a continuation
of ktap syntax.
ktap language allows to read pid,uid,tid, so they were added as
separate instructions to ktap bytecode...
ktap allows dump of a table, so kernel has to do tab_histdump()
including sorting of fields and printf formatting.
What if ktap user wants a different table dump?
or new features from the language?
keep extending bytecode for every printf tweak is not a great solution.

I think design approach to ktap needs to change.
What I'm proposing is the following:
- keep ktap syntax as-is, but remove loops
- ktap style of accessing tables is definitely less verbose then C,
 so keep it, but don't let compiled program to own the memory
- keep table dump as-is, but do it in userspace instead

In other words compiler for ktap scripts can generate kernel program
and userspace program at the same time.
the end users won't notice the difference vs what you have now.

we should learn from BPF design mistake:
BPF was
- user space interface
- safe instruction set
- execution engine
all at the same time and it was hard to extend it, since all
aspects need to be considered.

We need to break this dependency.
'internal bpf' is an execution engine.
it's a low level assembler language like x86.
Think of it as renamed x86 assembler, where registers
are called r1, r2 instead of rdi, rsi.

safety comes from verifier which is decoupled from execution.
It can allow complex program or very dumb ones.
Today classic bpf is still used as kernel-user interface,
it goes through bpf checker and converted to 'internal bpf'
for faster execution.
In this case bpf checker allows all existing bpf programs,
but ibpf execution engine can do a lot more.

ktap can follow similar approach.
Though I think C as a language to express filters is simpler,
ktap syntax is fine as well.
ktap compiler can generate ibpf instructions and let
kernel verify them.
ibpf verifier that I've posted earlier has enough knobs
to be used as very strict or permissive depending on the
kernel component, while both being safe from 'not crashing
or hanging kernel' point of view.
Like loops are always disallowed, all memory/register
accesses must be valid, data and control dependency
between instructions are checked.

Best part is that ktap syntax and features can evolve
without ever touching execution engine.

> Wrong, ktap don't have vmalloc instruction, ktap only use
> vmalloc for table and memory pool pre-allocation.

allowing script to own allocated memory is where we diverge
on the approach to safety.
if script can loop or allocate memory, you'd need to dynamically
track elapsed time, all allocated memory and all read/write
accesses from the program, so execution engine slows
down and becomes enforcer of safety.
Every new instruction in such engine needs to be considered
from safety point of view. The same problem plagued old bpf.

> It's a big engineering problem, BPF bytecode is too low level,
> BPF engine exposed too much low level stuff to end user, see bpf example:

you're mixing layers here.
'internal bpf' is a low level execution engine.
Nothing prevents userspace to have ktap or C or any other syntax.

>     void dropmon(struct bpf_context *ctx) {
>         void *loc;
>         uint64_t *drop_cnt;
>
>         loc = (void *)ctx->arg2;
>
>         drop_cnt = bpf_table_lookup(ctx, 0, &loc);
>         if (drop_cnt) {
>             __sync_fetch_and_add(drop_cnt, 1);
>         } else {
>             uint64_t init = 0;
>             bpf_table_update(ctx, 0, &loc, &init);
>         }
>     }
>
> IMO there have many issues in this simple script.
>
> If user forget add drop_cnt check, what will
> happen, it will reference NULL pointer in __sync_fetch_and_add.
> How to make sure drop_cn pointer is a valid memory address in table,
> not other kernel memory allocation?

good question :)
The way verifier guarantees correctness is the following.
'bpf_table_lookup' is annotated as 'returns valid memory of size X
or NULL', so verifiers follows that value in a register through control
flow graph. In if(drop_cnt) branch, the drop_cnt is valid memory.
In else branch, drop_cnt is null.
I've explained it in better details in verifier patch and the doc.

> Look bpf_table_update function, if bpf table overflow, there have
> no way to stop script executing in there, which make completely
> wrong things, so you have to add exit condition checking after
> bpf_table_update(and maybe most C function calls).

if you think 'table overflow' notification should be hidden
from script writer, then go for it.
ktap can generate ibpf that does bpf_table_update and
aborts the script if the limit is hit.
All these decisions are up to userspace and language compiler.

> And obviously you missed add table lock/unlock in there.

good question :)
It's actually under rcu which is much faster then lock/unlock.

> In contrast, look ktap script with same functionality:
>
>     var s ={}
>
>     trace skb:kfree_skb {
>         s[arg2] += 1
>     }
>
> User don't need to handle error checking and table lock issue at all,
> both in source level and bytecode level.

agree that ktap syntax is less verbose as C.
bytecode is a different story.

> From end user point of view, they want clean language syntax like
> above ktap example, so if bpf have same dynamic tracing goal, it
> should follow this way.

sure. keep ktap syntax. The users should have multiple
choices to write their scripts.

Regards,
Alexei
