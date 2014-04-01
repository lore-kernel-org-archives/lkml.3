Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaDADZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:25:08 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35503 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaDADZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:25:06 -0400
Message-ID: <533A318A.2080603@hitachi.com>
Date: Tue, 01 Apr 2014 12:24:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] uprobes/x86: move the UPROBE_FIX_{RIP,IP,CALL} code
 at the end of pre/post hooks
References: <20140331194412.GA9304@redhat.com>
In-Reply-To: <20140331194412.GA9304@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/01 4:44), Oleg Nesterov wrote:
> No functional changes. Preparation to simplify the review of the next
> change. Just reorder the code in arch_uprobe_pre/post_xol() functions
> so that UPROBE_FIX_{RIP_*,IP,CALL} logic goes to the end.
> 
> Also change arch_uprobe_pre_xol() to use utask instead of autask, to
> make the code more symmetrical with arch_uprobe_post_xol().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> ---
>  arch/x86/kernel/uprobes.c |   30 ++++++++++++++----------------
>  1 files changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index e8d7b38..7dd65dc 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -472,19 +472,18 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
>   */
>  int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
> -	struct arch_uprobe_task *autask;
> +	struct uprobe_task *utask = current->utask;
>  
> -	autask = &current->utask->autask;
> -	autask->saved_trap_nr = current->thread.trap_nr;
> +	regs->ip = utask->xol_vaddr;
> +	utask->autask.saved_trap_nr = current->thread.trap_nr;
>  	current->thread.trap_nr = UPROBE_TRAP_NR;
> -	regs->ip = current->utask->xol_vaddr;
> -	pre_xol_rip_insn(auprobe, regs, autask);
>  
> -	autask->saved_tf = !!(regs->flags & X86_EFLAGS_TF);
> +	utask->autask.saved_tf = !!(regs->flags & X86_EFLAGS_TF);
>  	regs->flags |= X86_EFLAGS_TF;
>  	if (test_tsk_thread_flag(current, TIF_BLOCKSTEP))
>  		set_task_blockstep(current, false);
>  
> +	pre_xol_rip_insn(auprobe, regs, &utask->autask);
>  	return 0;
>  }
>  
> @@ -558,22 +557,13 @@ bool arch_uprobe_xol_was_trapped(struct task_struct *t)
>   */
>  int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
> -	struct uprobe_task *utask;
> +	struct uprobe_task *utask = current->utask;
>  	long correction;
>  	int result = 0;
>  
>  	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
>  
> -	utask = current->utask;
>  	current->thread.trap_nr = utask->autask.saved_trap_nr;
> -	correction = (long)(utask->vaddr - utask->xol_vaddr);
> -	handle_riprel_post_xol(auprobe, regs, &correction);
> -	if (auprobe->fixups & UPROBE_FIX_IP)
> -		regs->ip += correction;
> -
> -	if (auprobe->fixups & UPROBE_FIX_CALL)
> -		result = adjust_ret_addr(regs->sp, correction);
> -
>  	/*
>  	 * arch_uprobe_pre_xol() doesn't save the state of TIF_BLOCKSTEP
>  	 * so we can get an extra SIGTRAP if we do not clear TF. We need
> @@ -584,6 +574,14 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	else if (!(auprobe->fixups & UPROBE_FIX_SETF))
>  		regs->flags &= ~X86_EFLAGS_TF;
>  
> +	correction = (long)(utask->vaddr - utask->xol_vaddr);
> +	handle_riprel_post_xol(auprobe, regs, &correction);
> +	if (auprobe->fixups & UPROBE_FIX_IP)
> +		regs->ip += correction;
> +
> +	if (auprobe->fixups & UPROBE_FIX_CALL)
> +		result = adjust_ret_addr(regs->sp, correction);
> +
>  	return result;
>  }
>  
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


