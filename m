Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab3LLOD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:03:56 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:35360 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3LLODw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:03:52 -0500
Date: Thu, 12 Dec 2013 15:03:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
Message-ID: <20131212140347.GA17059@gmail.com>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
 <20131204084551.GA31772@gmail.com>
 <529FBA71.6070107@hitachi.com>
 <20131205102127.GA19923@gmail.com>
 <52A137B6.6030307@hitachi.com>
 <20131210152811.GA1195@gmail.com>
 <52A7CA0A.9060009@hitachi.com>
 <20131211133423.GB3101@gmail.com>
 <52A9515E.5050505@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A9515E.5050505@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/12/11 22:34), Ingo Molnar wrote:
> > 
> > * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> >>> So why are annotations needed at all? What can happen if an 
> >>> annotation is missing and a piece of code is probed which is also 
> >>> used by the kprobes code internally - do we crash, lock up, 
> >>> misbehave or handle it safely?
> >>
> >> The kprobe has recursion detector, [...]
> > 
> > It's the 'current_kprobe' percpu variable, checked via 
> > kprobe_running(), right?
> 
> Right. :)

So that recursion detection runs a bit late:

/*
 * Interrupts are disabled on entry as trap3 is an interrupt gate and they
 * remain disabled throughout this function.
 */
static int __kprobes kprobe_handler(struct pt_regs *regs)
{
        kprobe_opcode_t *addr;
        struct kprobe *p;
        struct kprobe_ctlblk *kcb;

        addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
        /*
         * We don't want to be preempted for the entire
         * duration of kprobe processing. We conditionally
         * re-enable preemption at the end of this function,
         * and also in reenter_kprobe() and setup_singlestep().
         */
        preempt_disable();

        kcb = get_kprobe_ctlblk();
        p = get_kprobe(addr);

        if (p) {
                if (kprobe_running()) {

this flag should be checked first - the kprobe handler should already 
run in non-preemptible context if it comes from an exception.

For that reason I don't understand the whole 
preempt_disable()/enable() dance - it looks entirely superfluous to 
me. The comment above the preempt_disable() looks mostly bogus.

( The flow of logic in the function is rather confusing as well - 
  lots of places return from the middle of the function - instead they 
  should have the usual 'goto out' kind of code pattern. )

> >> [...] but it is detected in the kprobe exception(int3) handler, 
> >> this means that if we put a probe before detecting the recursion, 
> >> we'll do an infinite recursion.
> > 
> > So only the (presumably rather narrow) code path leading to the 
> > recursion detection code has to be annotated, correct?
> 
> Yes, correct.

So, another thing I find confusing is the whole kprobes notifier 
block. Why doesn't it call back specific kprobes handlers, directly 
from do_int3() and do_debug()? That's much more readable and it also 
allows the kprobes code to go earlier in the handler, running its 
recursion code earlier!

Another question I have here is: how does the kprobes code protect 
against interrupts arriving in before the recursion check and running 
a probe recursively?

> >> And also, even if we can detect the recursion, we can't stop the 
> >> kernel, we need to skip the probe. This means that we need to 
> >> recover to the main execution path by doing single step. As you 
> >> may know, since the single stepping involves the debug exception, 
> >> we have to avoid proving on that path too. Or we'll have an 
> >> infinite recursion again.
> > 
> > I don't see why this is needed: if a "probing is disabled" 
> > recursion flag is set the moment the first probe fires, and if 
> > it's only cleared once all processing is finished, then any 
> > intermediate probes should simply return early from int3 and not 
> > fire.
> 
> No, because the int3 already changes the original instruction.
> This means that you cannot skip singlestep(or emulate) the
> instruction which is copied to execution buffer (ainsn->insn),
> even if you have such the flag.
> So, kprobe requires the annotations on the singlestep path.

I don't understand this reasoning.

Lets assume we allow a probe to be inserted in the single-step path. 
Such a probe will be an INT3 instruction and if it hits we get a 
recursive INT3 invocation. In that case the INT3 handler should simply 
restore the original instruction and _leave it so_. There's no 
single-stepping needed - the probe is confused and must be discarded.

Once the original instruction is restored we simply return from the 
int3 exception and the single-step handling execution can continue.

This would be _way_ more robust as we wouldn't have to precisely 
annotate anything but the very narrow int3 exception code path and the 
'restore original instruction in case of recursion' code path.

Thanks,

	Ingo
