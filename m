Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbaDHJKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:10:22 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40597 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaDHJKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:10:15 -0400
Message-ID: <5343BCF0.3030605@hitachi.com>
Date: Tue, 08 Apr 2014 18:10:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/9] uprobes/x86: Introduce uprobe_xol_ops and arch_uprobe->ops
References: <20140404185131.GA14738@redhat.com>
In-Reply-To: <20140404185131.GA14738@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/05 3:51), Oleg Nesterov wrote:
> Introduce arch_uprobe->ops pointing to the "struct uprobe_xol_ops",
> move the current UPROBE_FIX_{RIP*,IP,CALL} code into the default
> set of methods and change arch_uprobe_pre/post_xol() accordingly.
> 
> This way we can add the new uprobe_xol_ops's to handle the insns
> which need the special processing (rip-relative jmp/call at least).
> 
> TODO: An error from adjust_ret_addr() shouldn't be silently ignored,
> we should teach arch_uprobe_post_xol() or handle_singlestep() paths
> to restart the probed insn in this case. And probably "adjust" can
> be simplified and turned into set_ret_addr(). It seems that we do
> not really need copy_from_user(), we can always calculate the value
> we need to write into *regs->sp.

It seems that you fixed this in 8/9, we don't need the TODO list in
the description.

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
> ---
>  arch/x86/include/asm/uprobes.h |    7 ++-
>  arch/x86/kernel/uprobes.c      |  107 +++++++++++++++++++++++++--------------
>  2 files changed, 74 insertions(+), 40 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index 3087ea9..9f8210b 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -33,12 +33,17 @@ typedef u8 uprobe_opcode_t;
>  #define UPROBE_SWBP_INSN		0xcc
>  #define UPROBE_SWBP_INSN_SIZE		   1
>  
> +struct uprobe_xol_ops;
> +
>  struct arch_uprobe {
> -	u16				fixups;
>  	union {
>  		u8			insn[MAX_UINSN_BYTES];
>  		u8			ixol[MAX_UINSN_BYTES];
>  	};
> +
> +	u16				fixups;
> +	const struct uprobe_xol_ops	*ops;
> +
>  #ifdef CONFIG_X86_64
>  	unsigned long			rip_rela_target_address;
>  #endif
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 3bb4198..13ad8a3 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -402,6 +402,64 @@ static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  }
>  #endif /* CONFIG_X86_64 */
>  
> +struct uprobe_xol_ops {
> +	bool	(*emulate)(struct arch_uprobe *, struct pt_regs *);
> +	int	(*pre_xol)(struct arch_uprobe *, struct pt_regs *);
> +	int	(*post_xol)(struct arch_uprobe *, struct pt_regs *);
> +};
> +
> +static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	pre_xol_rip_insn(auprobe, regs, &current->utask->autask);
> +	return 0;
> +}
> +
> +/*
> + * Adjust the return address pushed by a call insn executed out of line.
> + */
> +static int adjust_ret_addr(unsigned long sp, long correction)
> +{
> +	int rasize, ncopied;
> +	long ra = 0;
> +
> +	if (is_ia32_task())
> +		rasize = 4;
> +	else
> +		rasize = 8;
> +
> +	ncopied = copy_from_user(&ra, (void __user *)sp, rasize);
> +	if (unlikely(ncopied))
> +		return -EFAULT;
> +
> +	ra += correction;
> +	ncopied = copy_to_user((void __user *)sp, &ra, rasize);
> +	if (unlikely(ncopied))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	struct uprobe_task *utask = current->utask;
> +	long correction = (long)(utask->vaddr - utask->xol_vaddr);
> +	int ret = 0;
> +
> +	handle_riprel_post_xol(auprobe, regs, &correction);
> +	if (auprobe->fixups & UPROBE_FIX_IP)
> +		regs->ip += correction;
> +
> +	if (auprobe->fixups & UPROBE_FIX_CALL)
> +		ret = adjust_ret_addr(regs->sp, correction);
> +
> +	return ret;
> +}
> +
> +static struct uprobe_xol_ops default_xol_ops = {
> +	.pre_xol  = default_pre_xol_op,
> +	.post_xol = default_post_xol_op,
> +};
> +
>  /**
>   * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
>   * @mm: the probed address space.
> @@ -464,6 +522,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  	if (fix_call)
>  		auprobe->fixups |= UPROBE_FIX_CALL;
>  
> +	auprobe->ops = &default_xol_ops;
>  	return 0;
>  }
>  
> @@ -485,33 +544,8 @@ int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	if (test_tsk_thread_flag(current, TIF_BLOCKSTEP))
>  		set_task_blockstep(current, false);
>  
> -	pre_xol_rip_insn(auprobe, regs, &utask->autask);
> -	return 0;
> -}
> -
> -/*
> - * This function is called by arch_uprobe_post_xol() to adjust the return
> - * address pushed by a call instruction executed out of line.
> - */
> -static int adjust_ret_addr(unsigned long sp, long correction)
> -{
> -	int rasize, ncopied;
> -	long ra = 0;
> -
> -	if (is_ia32_task())
> -		rasize = 4;
> -	else
> -		rasize = 8;
> -
> -	ncopied = copy_from_user(&ra, (void __user *)sp, rasize);
> -	if (unlikely(ncopied))
> -		return -EFAULT;
> -
> -	ra += correction;
> -	ncopied = copy_to_user((void __user *)sp, &ra, rasize);
> -	if (unlikely(ncopied))
> -		return -EFAULT;
> -
> +	if (auprobe->ops->pre_xol)
> +		return auprobe->ops->pre_xol(auprobe, regs);
>  	return 0;
>  }
>  
> @@ -560,11 +594,8 @@ bool arch_uprobe_xol_was_trapped(struct task_struct *t)
>  int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
>  	struct uprobe_task *utask = current->utask;
> -	long correction;
> -	int result = 0;
>  
>  	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
> -
>  	current->thread.trap_nr = utask->autask.saved_trap_nr;
>  	/*
>  	 * arch_uprobe_pre_xol() doesn't save the state of TIF_BLOCKSTEP
> @@ -576,15 +607,9 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	else if (!(auprobe->fixups & UPROBE_FIX_SETF))
>  		regs->flags &= ~X86_EFLAGS_TF;
>  
> -	correction = (long)(utask->vaddr - utask->xol_vaddr);
> -	handle_riprel_post_xol(auprobe, regs, &correction);
> -	if (auprobe->fixups & UPROBE_FIX_IP)
> -		regs->ip += correction;
> -
> -	if (auprobe->fixups & UPROBE_FIX_CALL)
> -		result = adjust_ret_addr(regs->sp, correction);
> -
> -	return result;
> +	if (auprobe->ops->post_xol)
> +		return auprobe->ops->post_xol(auprobe, regs);
> +	return 0;
>  }
>  
>  /* callback routine for handling exceptions. */
> @@ -642,6 +667,10 @@ static bool __skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
>  	int i;
>  
> +	if (auprobe->ops->emulate)
> +		return auprobe->ops->emulate(auprobe, regs);
> +
> +	/* TODO: move this code into ->emulate() hook */

If you think this can move into the emulate(), you should do in this
patch. Since the following code runs by default, there should be
no problem to do that.

>  	for (i = 0; i < MAX_UINSN_BYTES; i++) {
>  		if (auprobe->insn[i] == 0x66)
>  			continue;
> 

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


