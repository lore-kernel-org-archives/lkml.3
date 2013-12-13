Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab3LMFeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:34:22 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:57200 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3LMFeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:34:21 -0500
Message-ID: <52AA9C55.1000103@hitachi.com>
Date: Fri, 13 Dec 2013 14:34:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL()
 and fixes crash bugs
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com> <20131205102127.GA19923@gmail.com> <52A137B6.6030307@hitachi.com> <20131210152811.GA1195@gmail.com> <52A7CA0A.9060009@hitachi.com> <20131211133423.GB3101@gmail.com> <52A9515E.5050505@hitachi.com> <20131212140347.GA17059@gmail.com>
In-Reply-To: <20131212140347.GA17059@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/12 23:03), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2013/12/11 22:34), Ingo Molnar wrote:
>>>
>>> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>
>>>>> So why are annotations needed at all? What can happen if an 
>>>>> annotation is missing and a piece of code is probed which is also 
>>>>> used by the kprobes code internally - do we crash, lock up, 
>>>>> misbehave or handle it safely?
>>>>
>>>> The kprobe has recursion detector, [...]
>>>
>>> It's the 'current_kprobe' percpu variable, checked via 
>>> kprobe_running(), right?
>>
>> Right. :)
> 
> So that recursion detection runs a bit late:
> 
> /*
>  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
>  * remain disabled throughout this function.
>  */
> static int __kprobes kprobe_handler(struct pt_regs *regs)
> {
>         kprobe_opcode_t *addr;
>         struct kprobe *p;
>         struct kprobe_ctlblk *kcb;
> 
>         addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
>         /*
>          * We don't want to be preempted for the entire
>          * duration of kprobe processing. We conditionally
>          * re-enable preemption at the end of this function,
>          * and also in reenter_kprobe() and setup_singlestep().
>          */
>         preempt_disable();
> 
>         kcb = get_kprobe_ctlblk();
>         p = get_kprobe(addr);
> 
>         if (p) {
>                 if (kprobe_running()) {
> 
> this flag should be checked first - the kprobe handler should already 
> run in non-preemptible context if it comes from an exception.

No. Even if we check it first, this flag is *only* for recursive
kprobes inside the kprobe handlers, not for the crash case.

If we'd like to check the crash case, we need to do that in
the earliest stage on the int3 interrupt, like in entry_XX.S.

And we need to allow some degree of recursion, since there
are several different int3 users (ftrace, jump label, kgdb),
at least jprobe uses int3 for returning from its handler
(see jprobe_return - kprobe provides break_handler to handle
int3 inside kprobe for this purpose.) Those are orthogonal
features, thus it will not cause infinite recursion.

> For that reason I don't understand the whole 
> preempt_disable()/enable() dance - it looks entirely superfluous to 
> me. The comment above the preempt_disable() looks mostly bogus.

Actually, this can be removed, because not only what you pointed,
but also the local interrupt is disabled while the int3 is
processing. This means that we don't need to disable preemption.

> ( The flow of logic in the function is rather confusing as well - 
>   lots of places return from the middle of the function - instead they 
>   should have the usual 'goto out' kind of code pattern. )
> 
>>>> [...] but it is detected in the kprobe exception(int3) handler, 
>>>> this means that if we put a probe before detecting the recursion, 
>>>> we'll do an infinite recursion.
>>>
>>> So only the (presumably rather narrow) code path leading to the 
>>> recursion detection code has to be annotated, correct?
>>
>> Yes, correct.
> 
> So, another thing I find confusing is the whole kprobes notifier 
> block. Why doesn't it call back specific kprobes handlers, directly 
> from do_int3() and do_debug()? That's much more readable and it also 
> allows the kprobes code to go earlier in the handler, running its 
> recursion code earlier!

Yes, I fixed it on this series! :)
I don't know what had discussed about using notify_die to handle
int3/debug. I guess it looks more generic way at that time.

> Another question I have here is: how does the kprobes code protect 
> against interrupts arriving in before the recursion check and running 
> a probe recursively?

That does just one recursion, it's no problem. The problem happens
if it causes infinite recursion.

>>>> And also, even if we can detect the recursion, we can't stop the 
>>>> kernel, we need to skip the probe. This means that we need to 
>>>> recover to the main execution path by doing single step. As you 
>>>> may know, since the single stepping involves the debug exception, 
>>>> we have to avoid proving on that path too. Or we'll have an 
>>>> infinite recursion again.
>>>
>>> I don't see why this is needed: if a "probing is disabled" 
>>> recursion flag is set the moment the first probe fires, and if 
>>> it's only cleared once all processing is finished, then any 
>>> intermediate probes should simply return early from int3 and not 
>>> fire.
>>
>> No, because the int3 already changes the original instruction.
>> This means that you cannot skip singlestep(or emulate) the
>> instruction which is copied to execution buffer (ainsn->insn),
>> even if you have such the flag.
>> So, kprobe requires the annotations on the singlestep path.
> 
> I don't understand this reasoning.
> 
> Lets assume we allow a probe to be inserted in the single-step path. 
> Such a probe will be an INT3 instruction and if it hits we get a 
> recursive INT3 invocation. In that case the INT3 handler should simply
> restore the original instruction and _leave it so_. There's no 
> single-stepping needed - the probe is confused and must be discarded.

But how can we restore the protected kernel text?
If we use text_poke, we also need to prohibit probing on the text_poke
and functions called in the text_poke too. That just shifts the annotated
area to the text_poke. :(

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


