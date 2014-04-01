Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaDAGw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:52:27 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45607 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaDAGwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:52:25 -0400
Message-ID: <533A6221.2030805@hitachi.com>
Date: Tue, 01 Apr 2014 15:52:17 +0900
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
Subject: Re: [PATCH 7/7] uprobes/x86: Introduce uprobe_xol_ops and arch_uprobe->ops
References: <20140331194415.GA9307@redhat.com>
In-Reply-To: <20140331194415.GA9307@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/01 4:44), Oleg Nesterov wrote:
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
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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
> index 7dd65dc..a822de5 100644
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
> +static struct uprobe_xol_ops defaule_xop_ops = {
> +	.pre_xol  = default_pre_xol_op,
> +	.post_xol = default_post_xol_op,

If there is no ops->emulate, I think it should not be defined now.
You can add it when you really need it. :)

> +};
> +
>  /**
>   * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
>   * @mm: the probed address space.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


