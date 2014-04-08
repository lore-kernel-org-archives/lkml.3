Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbaDHWxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:53:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39244 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbaDHWxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:53:13 -0400
Subject: Re: [RFC PATCH v2 5/6] uprobes/x86: Emulate rip-relative
 conditional "short" jmp's
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
In-Reply-To: <20140407142723.GA8881@redhat.com>
References: <20140406201524.GA32694@redhat.com>
	 <20140406201632.GA514@redhat.com>  <20140407142723.GA8881@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Apr 2014 15:53:06 -0700
Message-ID: <1396997587.5056.61.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040822-0928-0000-0000-00000106EC69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 16:27 +0200, Oleg Nesterov wrote:
> On 04/06, Oleg Nesterov wrote:
> >
> > Incomplete, lacks "jcxz". Simple to fix. Anything else?
> 
> Please see v2 below. Simplify the preprocessor hacks.
> 
> -------------------------------------------------------------------------------
> Subject: [RFC PATCH v2 5/6] uprobes/x86: Emulate rip-relative conditional "short" jmp's
> 
> Incomplete, lacks "jcxz". Simple to fix. Anything else?
> 
> Reported-by: Jonathan Lebon <jlebon@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/kernel/uprobes.c |   61 +++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 59 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 9283024..3865d8b 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -466,18 +466,72 @@ static bool ttt_is_call(struct arch_uprobe *auprobe)
>  	return auprobe->ttt.opc1 == 0xe8;
>  }
> 
> +#define CASE_COND					\
> +	COND(70, 71, XF(OF))				\
> +	COND(72, 73, XF(CF))				\
> +	COND(74, 75, XF(ZF))				\
> +	COND(78, 79, XF(SF))				\
> +	COND(7a, 7b, XF(PF))				\
> +	COND(76, 77, XF(CF) || XF(ZF))			\
> +	COND(7c, 7d, XF(SF) != XF(OF))			\
> +	COND(7e, 7f, XF(ZF) || XF(SF) != XF(OF))
> +
> +#define COND(op_y, op_n, expr)				\
> +	case 0x ## op_y: DO((expr) != 0)		\
> +	case 0x ## op_n: DO((expr) == 0)
> +
> +#define XF(xf)	(!!(flags & X86_EFLAGS_ ## xf))

All this macro magic seems way more clever than it is legible.

Given that you're mapping 0f 8x to 7x (patch #6), is_cond_jmp_opcode()
could just be
	return (0x70 <= opcode && opcode <= 0x7f);

I would keep the XF macro (although the !! operation to convert non-zero
to 1 isn't strictly needed) and just do an explicit 16-case switch for
check_jmp_cond().

> +
> +static bool is_cond_jmp_opcode(u8 opcode)
> +{
> +	switch (opcode) {
> +	#define DO(expr)	\
> +		return true;
> +	CASE_COND
> +	#undef	DO
> +
> +	default:
> +		return false;
> +	}
> +}
> +
> +static bool check_jmp_cond(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	unsigned long flags = regs->flags;
> +
> +	switch (auprobe->ttt.opc1) {
> +	case 0x00:	/* not a conditional jmp */
> +		return true;
> +
> +	#define DO(expr)	\
> +		return expr;
> +	CASE_COND
> +	#undef	DO
> +
> +	default:
> +		BUG();
> +	}
> +}
> +
> +#undef	XF
> +#undef	COND
> +#undef	CASE_COND
> +
>  static bool ttt_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
>  	unsigned long new_ip = regs->ip += auprobe->ttt.ilen;
> +	unsigned long disp = auprobe->ttt.disp;

Looks like a negative ttt.disp will get sign-extended like you want, but
still, making disp unsigned here doesn't seem quite right.

> 
>  	if (ttt_is_call(auprobe)) {
>  		unsigned long new_sp = regs->sp - sizeof_long();
>  		if (copy_to_user((void __user *)new_sp, &new_ip, sizeof_long()))
>  			return false;
>  		regs->sp = new_sp;
> +	} else if (!check_jmp_cond(auprobe, regs)) {
> +		disp = 0;
>  	}
> 
> -	regs->ip = new_ip + auprobe->ttt.disp;
> +	regs->ip = new_ip + disp;
>  	return true;
>  }
> 
> @@ -536,8 +590,11 @@ static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
>  		ttt_clear_displacement(auprobe, insn);
>  		auprobe->ttt.opc1 = opc1;
>  		break;
> +
>  	default:
> -		return -ENOSYS;
> +		if (!is_cond_jmp_opcode(opc1))
> +			return -ENOSYS;
> +		auprobe->ttt.opc1 = opc1;
>  	}
> 
>  	auprobe->ttt.ilen = insn->length;


