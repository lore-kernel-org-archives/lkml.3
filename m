Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854AbaDIPnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:43:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461AbaDIPnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:43:52 -0400
Date: Wed, 9 Apr 2014 17:43:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
Message-ID: <20140409154346.GB18486@redhat.com>
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Jim Keniston wrote:
>
> On Sun, 2014-04-06 at 22:16 +0200, Oleg Nesterov wrote:
> > 0xe8. Anything else?
>
> No, I think e8 is the only call instruction uprobes will see.

Good.

> The following couple of paragraphs should be included in the code,
> perhaps merged with some of the related comments already there.  Without
> it, the code is pretty hard to follow.

OK, I'll try to improve the comments somehow...

> > Emulating of rip-relative call is trivial, we only need to additionally
> > push the ret-address. If this fails, we execute this instruction out of
> > line and this should trigger the trap, the probed application should die
> > or the same insn will be restarted if a signal handler expands the stack.
> > We do not even need ->post_xol() for this case.
> >
> > But there is a corner (and almost theoretical) case: another thread can
> > expand the stack right before we execute this insn out of line. In this
> > case it hit the same problem we are trying to solve. So we simply turn
> > the probed insn into "call 1f; 1:" and add ->post_xol() which restores
> > ->sp and restarts.
>
> Can you explain under what circumstances emulation of the call
> instruction would fail?  Will the copy_to_user() call that writes the
> return address to the stack grow the stack if necessary?

If necessary and if possible.

> Will
> single-stepping the mangled call instruction expand the stack?

In the likely case it won't. If copy_to_user() failes, then "call" should
fail too (again, ignoring the potential race with another thread which can
populate the memory ->sp - 8 points to).

> > +static int ttt_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
> > +{
> > +	BUG_ON(!ttt_is_call(auprobe));
> > +	/*
> > +	 * We can only get here if ttt_emulate_op() failed to push the return
> > +	 * address _and_ another thread expanded our stack before the (mangled)
> > +	 * "call" insn was executed out-of-line. Just restore ->sp and restart.
> > +	 * We could also restore ->ip and try to call ttt_emulate_op() again.
> > +	 */
>
> As I understand it, this comment assumes that the single-stepped call
> instruction can't grow the stack on its own, and will instead die with a
> SEGV or some such.

Or the signal handler expands the stack.

> As noted above, I don't know if that's correct.  (If
> the single-stepped call doesn't die and doesn't grow the stack -- I'm
> not sure how that would happen -- then it seems like we have an infinite
> loop.)

This is fine. And this doesn't differ from the current situation when we
do not try to emulate "call" but always execute it out-of-line. And this
is not even specific to "call" insn.

Please forget about uprobes for the moment. Consider this application:

	void sigh(itn sig)
	{
	}

	int main(void)
	{
		signal(SIGSEGV, sigh);
		*(int *)NULL = 0;
		return 0;
	}

it will run the endelss "page_fault -> sighandler -> restart" loop. Nothing
bad, it can be killed, the application is wrong.

But note that sigh() can actually do, say, mmap(NULL, MAP_FIXED), in this
case the restarted insn will write to the memory and this app will exit.

Now suppose that this "*(int *)NULL = 0" insn is probed. Everything is fine
again. The kernel executes this "mov" insn out of line, this triggers the trap,
arch_uprobe_abort_xol() restores ->ip, the process returns to user-mode with
the pending SIGSEGV. If it doesn not have a handler for SIGSEGV - it dies.
If it does, it restarts the same insn after return from the signal handler.
Will the restarted insn succeed or we have an infinite loop? This, again,
depends on what the signal handler does, but an infinite loop is fine.

And this is how the "call" emulation should work. Suppose that ->emulate()
fails because we can't push the return address. It can run out of memory,
->sp can be corrupted, or RLIMIT_STACK doesn't allow to grow the stack, or
this stack is not MAP_GROWSDOWN and ->sp - 8 misses the mmaped area, or
whatever else. We simply do not care.

We execute this insn out-of-line just to trigger the trap, so that the probed
application recieves the correct signal with the properly filled siginfo.
After that it can restart the same insn if it has the handler or die. It can
run the endless loop if the signal handler does nothing useful or the next time
->emulate() will succeed because the stack was expanded by the signal handler.
Once again, this doesn't really differ from the example above (well, ignoring
the fact that in this case the probed app obviously needs sigaltstack).

The only difference is the corner case, the race with another thread which
can populate ->sp - 8 right before we execute the failed insn out-of-line.
So we turn it into "call 1f; 1:" to ensure it can't hit the same bug out-
of-line, and restart it.

See?

> > +static void ttt_clear_displacement(struct arch_uprobe *auprobe, struct insn *insn)
> > +{
> > +	/*
> > +	 * Turn this insn into "call 1f; 1:", this is what we will execute
> > +	 * out-of-line if ->emulate() fails.
>
> Add comment: In the unlikely event that this mangled instruction is
> successfully single-stepped, we'll reset regs->ip to the beginning of
> the instruction so the probepoint is hit again and the original
> instruction is emulated (successfully this time, we assume).

OK, will try...

> >  static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
> >  {
> > +	u8 opc1 = OPCODE1(insn);
> > +
> > +	/* has the side-effect of processing the entire instruction */
> > +	insn_get_length(insn);
> > +	if (WARN_ON_ONCE(!insn_complete(insn)))
> > +		return -ENOEXEC;
> >
> > -	switch (OPCODE1(insn)) {
> > +	switch (opc1) {
> >  	case 0xeb:	/* jmp 8 */
> >  	case 0xe9:	/* jmp 32 */
> >  	case 0x90:	/* prefix* + nop; same as jmp with .disp = 0 */
> >  		break;
> > +
> > +	case 0xe8:	/* call relative */
> > +		ttt_clear_displacement(auprobe, insn);
> > +		auprobe->ttt.opc1 = opc1;
>
> You set ttt.opc1 for call, and later for conditional jumps, but not for
> nop and unconditional jumps.  Might confuse a maintainer down the road?

Yes. This allows to have the fast-path "opc1 == 0" check in check_jmp_cond().
And this allows to add "BUG()" into check_jmp_cond ;)

OK, if you think this is confusing, I'll set ttt.opc1 unconditionally
and change check_jmp_cond() to simply return "true" in the "default"
case.

Oleg.

