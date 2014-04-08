Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbaDHW0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:26:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40460 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbaDHW0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:26:09 -0400
Subject: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140406201628.GA507@redhat.com>
References: <20140406201628.GA507@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Apr 2014 15:26:03 -0700
Message-ID: <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040822-8236-0000-0000-0000016423AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 22:16 +0200, Oleg Nesterov wrote:
> 0xe8. Anything else?

No, I think e8 is the only call instruction uprobes will see.

> 

The following couple of paragraphs should be included in the code,
perhaps merged with some of the related comments already there.  Without
it, the code is pretty hard to follow.

> Emulating of rip-relative call is trivial, we only need to additionally
> push the ret-address. If this fails, we execute this instruction out of
> line and this should trigger the trap, the probed application should die
> or the same insn will be restarted if a signal handler expands the stack.
> We do not even need ->post_xol() for this case.
> 
> But there is a corner (and almost theoretical) case: another thread can
> expand the stack right before we execute this insn out of line. In this
> case it hit the same problem we are trying to solve. So we simply turn
> the probed insn into "call 1f; 1:" and add ->post_xol() which restores
> ->sp and restarts.

Can you explain under what circumstances emulation of the call
instruction would fail?  Will the copy_to_user() call that writes the
return address to the stack grow the stack if necessary?  Will
single-stepping the mangled call instruction expand the stack?

> 
> Many thanks to Jonathan who finally found the standalone reproducer,
...
> Reported-by: Jonathan Lebon <jlebon@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/include/asm/uprobes.h |    1 +
>  arch/x86/kernel/uprobes.c      |   69 ++++++++++++++++++++++++++++++++++------
>  2 files changed, 60 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index cca62c5..9528117 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -51,6 +51,7 @@ struct arch_uprobe {
>  		struct {
>  			s32	disp;
>  			u8	ilen;
> +			u8	opc1;
>  		}				ttt;
>  	};
>  };
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 3bcc121..9283024 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -461,33 +461,85 @@ static struct uprobe_xol_ops default_xol_ops = {
>  	.post_xol = default_post_xol_op,
>  };
> 
> +static bool ttt_is_call(struct arch_uprobe *auprobe)
> +{
> +	return auprobe->ttt.opc1 == 0xe8;
> +}
> +
>  static bool ttt_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
> -	regs->ip += auprobe->ttt.ilen + auprobe->ttt.disp;
> +	unsigned long new_ip = regs->ip += auprobe->ttt.ilen;
> +
> +	if (ttt_is_call(auprobe)) {
> +		unsigned long new_sp = regs->sp - sizeof_long();
> +		if (copy_to_user((void __user *)new_sp, &new_ip, sizeof_long()))
> +			return false;
> +		regs->sp = new_sp;
> +	}
> +
> +	regs->ip = new_ip + auprobe->ttt.disp;
>  	return true;
>  }
> 
> +static int ttt_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	BUG_ON(!ttt_is_call(auprobe));
> +	/*
> +	 * We can only get here if ttt_emulate_op() failed to push the return
> +	 * address _and_ another thread expanded our stack before the (mangled)
> +	 * "call" insn was executed out-of-line. Just restore ->sp and restart.
> +	 * We could also restore ->ip and try to call ttt_emulate_op() again.
> +	 */

As I understand it, this comment assumes that the single-stepped call
instruction can't grow the stack on its own, and will instead die with a
SEGV or some such.  As noted above, I don't know if that's correct.  (If
the single-stepped call doesn't die and doesn't grow the stack -- I'm
not sure how that would happen -- then it seems like we have an infinite
loop.)

> +	regs->sp += sizeof_long();
> +	return -ERESTART;
> +}
> +
> +static void ttt_clear_displacement(struct arch_uprobe *auprobe, struct insn *insn)
> +{
> +	/*
> +	 * Turn this insn into "call 1f; 1:", this is what we will execute
> +	 * out-of-line if ->emulate() fails.

Add comment: In the unlikely event that this mangled instruction is
successfully single-stepped, we'll reset regs->ip to the beginning of
the instruction so the probepoint is hit again and the original
instruction is emulated (successfully this time, we assume).

> +	 *
> +	 * In the likely case this will lead to arch_uprobe_abort_xol(), but
> +	 * see the comment in ->emulate(). So we need to ensure that the new
> +	 * ->ip can't fall into non-canonical area and trigger #GP.
> +	 *
> +	 * We could turn it into (say) "pushf", but then we would need to
> +	 * divorce ->insn[] and ->ixol[]. We need to preserve the 1st byte
> +	 * of ->insn[] for set_orig_insn().
> +	 */
> +	memset(auprobe->insn + insn_offset_displacement(insn),
> +		0, insn->moffset1.nbytes);

s/displacement/immediate/
s/moffset1/immediate/
Both already fixed in today's patch.

> +}
> +
>  static struct uprobe_xol_ops ttt_xol_ops = {
>  	.emulate  = ttt_emulate_op,
> +	.post_xol = ttt_post_xol_op,
>  };
> 
>  static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
>  {
> +	u8 opc1 = OPCODE1(insn);
> +
> +	/* has the side-effect of processing the entire instruction */
> +	insn_get_length(insn);
> +	if (WARN_ON_ONCE(!insn_complete(insn)))
> +		return -ENOEXEC;
> 
> -	switch (OPCODE1(insn)) {
> +	switch (opc1) {
>  	case 0xeb:	/* jmp 8 */
>  	case 0xe9:	/* jmp 32 */
>  	case 0x90:	/* prefix* + nop; same as jmp with .disp = 0 */
>  		break;
> +
> +	case 0xe8:	/* call relative */
> +		ttt_clear_displacement(auprobe, insn);
> +		auprobe->ttt.opc1 = opc1;

You set ttt.opc1 for call, and later for conditional jumps, but not for
nop and unconditional jumps.  Might confuse a maintainer down the road?

> +		break;
>  	default:
>  		return -ENOSYS;
>  	}
> 
> -	/* has the side-effect of processing the entire instruction */
> -	insn_get_length(insn);
> -	if (WARN_ON_ONCE(!insn_complete(insn)))
> -		return -ENOEXEC;
> -
>  	auprobe->ttt.ilen = insn->length;
>  	auprobe->ttt.disp = insn->moffset1.value;
>  	/* so far we assume that it fits into ->moffset1 */
> @@ -534,9 +586,6 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  	case 0xca:
>  		fix_ip = false;
>  		break;
> -	case 0xe8:		/* call relative - Fix return addr */
> -		fix_call = true;
> -		break;
>  	case 0x9a:		/* call absolute - Fix return addr, not ip */
>  		fix_call = true;
>  		fix_ip = false;


